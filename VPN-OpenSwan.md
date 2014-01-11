## client
[ref0](https://github.com/xelerance/Openswan/wiki/L2tp-ipsec-configuration-using-openswan-and-xl2tpd)
[ref1](https://wiki.archlinux.org/index.php/L2TP/IPsec_VPN_client_setup)

### openswan
```
vi /etc/ipsec.conf
version 2.0
config setup
    protostack=netkey  # 使用哪个协议栈，可用值：auto、klips、netkey、mast（mast是klips的一个变种）
    nat_traversal=yes
    virtual_private=%v4:192.168.0.0/16,%v4:10.0.0.0/8,%v4:172.16.0.0/12,%v4:25.0.0.0/8,%v4:!10.254.253.0/24
    oe=off
    interfaces="%defaultroute"
include /etc/ipsec.d/*.conf

vi /etc/ipsec.d/custom.conf
conn test-l2tp-vpn
    authby=never
    pfs=no
    auto=add
    rekey=no
    type=transport
    left=192.168.0.172          # local ip
    leftprotoport=17/1701
    leftnexthop=%defaultroute
    right=218.242.153.146       # your vpn server's public ip
    rightprotoport=17/%any
    rightsubnet=vhost:%priv,%no

vi /etc/ipsec.secrets
include /etc/ipsec.d/*.secrets

vi /etc/ipsec.d/custom.secrets
192.168.1.101 68.68.32.79 : PSK "your_pre_shared_key"

#ipsec auto --add test-l2tp-vpn

```


### xl2tpd
```

  /etc/xl2tpd/l2tp-secrets /var/run/l2tp-control

vi /etc/xl2tpd/xl2tpd.conf
TODO

vi /etc/ppp/options.l2tpd.client


vi /etc/ppp/chap-secrets

mkdir -p /var/run/xl2tpd
touch /var/run/xl2tpd/l2tp-control

service ipsec start
service xl2tpd start
? for vpn in /proc/sys/net/ipv4/conf/*; do echo 0 > $vpn/accept_redirects; echo 0 > $vpn/send_redirects; done

ipsec verify
ipsec auto --up test-l2tp-vpn


```



## 搭建网络到网络VPN
### 测试场景
* 子网1：A类：10.0.0.0-10.255.255.255
* 子网0：C类：192.168.0.0-192.168.255.255（模拟公网）
* 子网2：B类：172.16.0.0-172.31.255.255 
示意图：
```
    |------net1------|--------------net0-------------|-----------net2-------|
    |    10.*.*.*    |           192.168.1.*         |      172.16.*.*      |
   pc12-------------pc11----------------------------pc21-------------------pc22
10.0.0.2-----10.0.0.1&192.168.1.201--------192.168.1.202&172.16.0.1--------172.16.0.2
```
### 安装测试用虚拟机
* 下载VirtualBox、CentOS 6.*，安装一个虚拟主机之后，再复制三份，分别命名为pc12,pc11,pc21,pc22
* 复制好主机之后，需要按照设计

