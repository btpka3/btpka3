# 简介

Bind， DNS server


# 参考

* [How To Configure BIND as a Private Network DNS Server on CentOS 7 ](https://www.digitalocean.com/community/tutorials/how-to-configure-bind-as-a-private-network-dns-server-on-centos-7#prerequisites)


# 安装 master 主服务器

1. 安装

    ```bash
    yum install bind bind-utils
    ```

1. 配置: `vi /etc/named.conf`
    
    ```bash
    # man named.conf
    # 最顶部追加以下配置
    
    acl "trusted" {
            10.128.10.11;    # ns1 - can be set to localhost
            10.128.20.12;    # ns2
            10.128.100.101;  # host1
            10.128.200.102;  # host2
    };
    
    # 修改 options 中 listen-on， 追加自己的要监听的 IP 地址。也可以是 any
    listen-on port 53 { 127.0.0.1; 10.128.10.11; };
    #listen-on-v6 port 53 { ::1; };
 
    # 修改 allow-transfer， 地址为 第二天dns服务器的地址。
    allow-transfer { 10.128.20.12; };      # 也可以是 none
 
    # 修改 options 中 allow-query， 或修改 any
    allow-query { trusted; }
 
    dnssec-validation no;
    //forward     "first";   // 优先使用 forwarders 指定的 DNS 进行查询。
    //forwarders {211.140.13.188; 211.140.188.188;};
    
    # 在最后追加 本地域名解析
    include "/etc/named/named.conf.local";
    ```

1. 修改本地域名配置： `/etc/named/named.conf.local`


    ```conf
    # 正向域名的解析
    zone "nyc3.example.com" {
        type master;
        file "/etc/named/zones/db.nyc3.example.com"; # zone file path
    };
    
    # 根据IP地址反向获取域名
    zone "128.10.in-addr.arpa" {
        type master;
        file "/etc/named/zones/db.10.128";  # 10.128.0.0/16 subnet
    };
    ```
1. 创建正向域名解析文件： 

    ```bash
    chmod 755 /etc/named
    mkdir /etc/named/zones
    vi /etc/named/zones/db.nyc3.example.com
    ```
    
    文件 db.nyc3.example.com 中内容示例如下：
     
    ```conf
    zone "nyc3.example.com" {
        type master;
        file "/etc/named/zones/db.nyc3.example.com"; # zone file path
    };
    zone "128.10.in-addr.arpa" {
        type master;
        file "/etc/named/zones/db.10.128";  # 10.128.0.0/16 subnet
    };
    
    [root@nat named]# cat /etc/named/zones/db.nyc3.example.com
    $TTL    604800
    @       IN      SOA     ns1.nyc3.example.com. admin.nyc3.example.com. (
                  3         ; Serial
                 604800     ; Refresh
                  86400     ; Retry
                2419200     ; Expire
                 604800 )   ; Negative Cache TTL
    
    ; name servers - NS records
        IN      NS      ns1.nyc3.example.com.
        IN      NS      ns2.nyc3.example.com.
    
    ; name servers - A records
    ns1.nyc3.example.com.          IN      A       10.128.10.11
    ns2.nyc3.example.com.          IN      A       10.128.20.12
    
    ; 10.128.0.0/16 - A records
    host1.nyc3.example.com.        IN      A      10.128.100.101
    host2.nyc3.example.com.        IN      A      10.128.200.102
    ```
    
1. 创建反向解析文件： `vi /etc/named/zones/db.10.128`

    ```conf
    $TTL    604800
    @       IN      SOA     ns1.nyc3.example.com. admin.nyc3.example.com. (
                                  3         ; Serial
                             604800         ; Refresh
                              86400         ; Retry
                            2419200         ; Expire
                             604800 )       ; Negative Cache TTL
    
    ; name servers - NS records
          IN      NS      ns1.nyc3.example.com.
          IN      NS      ns2.nyc3.example.com.
    
    ; PTR Records
    11.10   IN      PTR     ns1.nyc3.example.com.    ; 10.128.10.11
    12.20   IN      PTR     ns2.nyc3.example.com.    ; 10.128.20.12
    101.100 IN      PTR     host1.nyc3.example.com.  ; 10.128.100.101
    102.200 IN      PTR     host2.nyc3.example.com.  ; 10.128.200.102
    ```
1. 检查配置并启动

    ```bash
    named-checkconf
    named-checkzone nyc3.example.com /etc/named/zones/db.nyc3.example.com
    named-checkzone 128.10.in-addr.arpa /etc/named/zones/db.10.128
    
    # 启动
    systemctl start named
    ```
    
1. 修改防火墙

    ```bash
    firewall-cmd --permanent --zone=public --add-port=53/tcp
    firewall-cmd --permanent --zone=public --add-port=53/udp
    firewall-cmd --reload
    ```
# 安装 slave 备用服务器

1. 安装

    配置基本同主服务器，但是 `/etc/named/named.conf.local` 明确指定 slave模式，文件内容示例如下：
    
    ```conf
    zone "nyc3.example.com" {
        type slave;
        file "slaves/db.nyc3.example.com";
        masters { 10.128.10.11; };  # ns1 private IP
    };

    zone "128.10.in-addr.arpa" {
        type slave;
        file "slaves/db.10.128";
        masters { 10.128.10.11; };  # ns1 private IP
    };
    ```
#配置 clent

* CentOS 客户端

    1. `vi /etc/resolv.conf`
    
        ```conf
        search nyc3.example.com  # your private domain
        nameserver 10.128.10.11  # ns1 private IP address
        nameserver 10.128.20.12  # ns2 private IP address
        ```
* Ubuntu 客户端

    1. `vi /etc/resolvconf/resolv.conf.d/head`
    
        ```conf
        search nyc3.example.com  # your private domain
        nameserver 10.128.10.11  # ns1 private IP address
        nameserver 10.128.20.12  # ns2 private IP address
        ```
    1. 重启 dns 相关服务
     
        ```bash
        sudo resolvconf -u
        ```
    
# 测试

```bash
# 检查错误日志
tailf /var/named/data/named.run
nslookup host1
nslookup 10.128.100.101
dig +trace baidu.com @localhost
```

# 向DNS服务器中追加配置

## Primary Nameserver

1. Forward zone file:

    1. 追加相应的 A 记录
    1. 增加相应的 Serial 值

1. Reverse zone file

    1. 追加相应的 "PTR" 记录
    1. 追加相应的 Serial 值
1. 在 `named.conf` 的 `options` 中 "trusted" ACL 追加相应的 IP 地址
 
1. 重启服务

    ```bash
    systemctl reload named
    ```
## Secondary Nameserver

1.  重启服务

    ```bash
    systemctl reload named
    ```
    
## Client
配置新主机使用dns服务器