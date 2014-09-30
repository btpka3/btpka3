
# 生成SSH KEY

```sh
ssh-keygen -t rsa -C "hi@test.me" -N 'xxxPass' -f ~/.ssh/id_rsa
```

# 加入信任的ssh 公钥

```sh
vi ~/.ssh/authorized_keys 
# 将 id_rsa.pub 中的内容追加进来

```



# ssh 登录慢

```sh
# ------- for client
vi /etc/ssh/ssh_config
Host *
    GSSAPIAuthentication no
    AddressFamily inet

# ------- for server
vi /etc/ssh/sshd_config
# 修改为：
#GSSAPIAuthentication yes
GSSAPIAuthentication no
#UseDNS yes
UseDNS no
```





# SSH 隧道


## 场景举例

|        |  A@dev         |  B@prod       | C@prod       |
|--------|----------------|---------------|--------------|
|Inet IP |-               |122.225.22.222 |-             |
|Lan IP  |192.168.1.111   |172.17.17.10   |172.17.17.80  |
|service |Redis:6379      |               |MySql:3306    |

* dev 为公司的开发环境，通过ADSL上网，没有固定公网IP
* prod 为公司的线上环境，有固定的公网IP。
* A@dev 只可以通过公网IP 122.225.22.222 SSH到 B@prod
* B@prod 和 C@prod位于同一个内网，可以相互ssh到，但都无法访问到 A@dev
* C@prod 安装有MySql服务，端口是3306
* A@dev 安装有Redis服务，端口是6379


## SSH 动态端口转发
可通过本地特定端口，访问远程所有服务————即代理服务器。

```sh
# 在SSH client端执行
ssh sshUser@sshHost -C -f -N -g -D [localBindIp:]localBindPort
```

需求示例：线上环境同一种web服务有集群，我需要调试特定某个节点上的服务。

1. 启动代理转发

    ```sh
    # 在 A@dev 上执行以下命令：
    ssh root@122.225.22.222 -C -f -N -g -D 9999 &
    ```
1. 在 chrome 浏览器中 安装 SwitchySharp 插件，新建 Proxy Profiles：
    1. 设置SOCKS v4连接的IP地址为 localhost, 端口为 9999;
    1. 设置本机IP和本地局域网IP地址不进行代理： `localhost; 127.0.0.1; 192.168.101.* `

1. 临时修改本机 /etc/hosts, 设置域名为线上环境某个IP地址

1. 就可以在chrome 浏览器中使用SwitchySharp的新建的profile通过域名访问了。


PS：不同应用的socks代理设置的方式不同，需要自行阅读相关文档解决。


## SSH 本地端口转发

访问本地特定端口，就是访问远程特定服务。

```sh
# 在SSH client端执行
ssh sshUser@sshHost -C -f -N -g -L [localBindIP:]localBindPort:remoteServiceIP:remoteServicePort
```

需求示例：需要从A@dev上直接访问 C@prod 的MySql服务


1. 开启端口转发

    ```sh
    # 在 A@dev 上执行
    ssh root@122.225.22.222 -C -N -g -L 13306:172.17.17.80:3306 &
    ```
1. 本地访问远程MySql服务

    ```sh
    # 在A@dev 上执行
    mysql -h 192.168.1.111 -P 13306 -u yourDbUser -p yourDb
    ```

## SSH 动态端口转发
使单向网络中末端可以通过特定端口逆向访问特定服务。
比如：有静态外网IP的网络中的主机 可以访问 无静态外网IP（ASDL）的网络中主机上的服务。


```sh
# 在SSH client端执行
ssh sshUser>@sshHost -C -f -N -g -R [sshBindIp:]sshBindPort:localBindHost:localBindPort &
```

需求示例：需要从C@prod上直接访问 A@dev 的Redis服务

1. 开启远程端口反向转发

    ```sh
    # 在 A@dev 上执行
    ssh root@122.225.22.222 -C -N -g -R 172.17.17.10:16379:localhost:6379  -o ExitOnForwardFailure=yes &
    ```

1. 访问Redis服务

    ```sh
    telnet 172.17.17.10 16379
    key *                            # redis 命令 : 列出所有key
    ```
