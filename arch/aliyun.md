

# 存储

## NAS文件存储
* 实际使用容量付费
* 有包年的优惠, 超过套餐按量收费。单价贵, 但存储空间利用率高。
* 可以挂载到多个ESC, docker容器上。
* 100G SSD 包年 = 1494.00 元/年

## 块存储(云盘)
* 按整块硬盘购买,
* 不支持包年包月
* 100G SSD = 0.042元/时 * 24 * 365 = 367.92 元/年
* 只能挂载到单个云主机上

## OSS 存储


# 负载均衡

说明示例:

```
# 1. 在prod12, prod13上部署 qh-wap-api, 均监听 1200 端口
# 2. 在购买创/建负载均衡示例, 假设IP是为 100.98.237.78
# 3. 阿里云 管理控制台 - 产品与服务 - 负载均衡 :
#    3.1 服务器: 添加prod12, prod13
#    3.2 监听: 虚拟服务器组: qh-admin 为 [prod12:1200, prod13:1200]
#    3.3 配置监听: 添加端口80 -> 10020 的端口映射, 虚拟服务器组为 qh-admin
#        如果监听是 http 协议,则创建之后,可以根据URL,域名等进行转发。
# 缺点: 前端的一个端口,只能映射后端的一个固定端口, 就造成一台服务器上
#    不能同时运行多个app, 除非使用docker并分配ip地址。

# 使用以下命令测试

curl -v 'http://100.98.237.78/qh/mall/api/common/indexImg' \
    -H 'Host: kingsilk.net' \
    -H 'accept-encoding: gzip, deflate, sdch' \
    -H 'accept-language: en-US,en;q=0.8' \
    -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.75 Safari/537.36 QQBrowser/4.1.4132.400' \
    -H 'accept: */*' -H 'cache-control: max-age=0' \
    -H 'authority: www.google-analytics.com' \
    -H 'referer: http://socket.io/get-started/chat/' \
    -H 'if-modified-since: Wed, 28 Sep 2016 20:19:01 GMT' \
    --compressed

```

# 容器服务








```
export DOCKER_TLS_VERIFY="1"
export DOCKER_HOST="tcp://master1g5.cs-cn-hangzhou.aliyun.com:13796"
export DOCKER_CERT_PATH="/Users/zll/.acs/certs/my-c"
# export DOCKER_MACHINE_NAME="???"
# FIXME: how to create remote machine
docker-machine create --url=tcp://master1g5.cs-cn-hangzhou.aliyun.com:13796 \
    qh-aliyun





# 路由规则
172.18.1.0/24     -> docker 主机1
0.0.0.0/0         -> 网关
192.168.1.0/24    : 内部网络
100.64.0.0/10     : 公网IP网络？
----------
[root@dc1 ~] ifconfig
driver              : IP/network
docker              : 172.31.254.1/24   # ???
docker_gwbridge     : 172.17.0.1/16     # 创建docker集群时指定
eth0                : 192.168.1.2/24    # 在创建VPC时指定的网络 192.168.0.0/16
                                        # 在创建虚拟交换机时指定子网, 192.168.1.0/24
                                        # 创建docker 节点时, 该节点的IP是自动分配的。
vpc-b445a           : 172.18.1.1/24     # ???

[root@dc1 ~] docker network ls
NETWORK ID      NAME                DRIVER
9bbbec5b6c2e    bridge              bridge  # 172.31.254.1/24
821dfb8f1b5c    docker_gwbridge     bridge  # 包含多个container, 172.17.0.*/16
e7299d5b5360    host                host
b445ad2f63ad    multi-host-network  vpc
385bc2a224ce    none                null


[root@dc1 ~] docker inspect nginx_nginx_1     # 172.18.1.4/24
[root@dc1 ~] docker inspect nginx2_nginx2_1   # 172.18.1.5/24
```


1. 应当通过NAT网关让无公网IP的ESC主机访问外网。(ESC主机主动访问外网)
2. 通过带公网网关的负载均衡服务器反向代理 无公网IP的ESC主机上的服务。(ESC主机等待外网请求来访问)


容器的负载均衡有外网ip地址。
XXX.$cluster_id.$region_id.alicontainer.com

《[通过acsrouting路由应用暴露HTTP服务](https://help.aliyun.com/document_detail/25984.html)》
cn-hangzhou.alicontainer.com

nginx2.c78a5a1e1c8784f5ba957190903b84bb8.cn-hangzhou.alicontainer.com
nginx.c78a5a1e1c8784f5ba957190903b84bb8.cn-hangzhou.alicontainer.com
docker.kingsilk.net     ip为SLB的公网IP

```
# 容器 + 公网SLB
curl -v http://docker.kingsilk.net
    -> SLB的公网IP
        (在阿里云的域名服务中设置相应的A记录)
    -> SLB 80 => ECS主机的9080
        (已默认提供, 由docker容器 acsrouting 容器提供)
    -> acsrouting 根据域名,将请求转发到特定的 docker容器上
       (在阿里云管理控制台/产品与服务/容器服务/服务/某个服务的"变更配置": Web路由规则中配置域名)
其他问题:
* 需要额外购买 EIP、并手动搭建 SNAT服务, 以便让内网ECS上网, 并占用一台ECS主机


年费用:
* 公网20M负载均衡 = 2.32元/小时 * 24 小时/天 * 365 天/年 = 20323.2 元/年
* 5M EIP(上网用) = 5.28元/天 * 365 天/年 = 1927.2 元/年
* 云主机 ecs.s3.large(4核8GB) * 3 :
    * 包年 = 4039.20 元/年 * 3 = 12117.6 元 (优选)
    * 按量 = 12091.72 元/年 * 3 = 36275.16 元

SUM = 20323.2 + 1927.2 + 12117.6 = 34368 元/年

# 容器 + NAT网关
curl -v http://nat.kingsilk.net
    -> NAT网关的用于DNAT的公网IP
       (在阿里云的域名服务中设置相应的A记录)
       NAT网关一般要配置两个公网IP,一个用于SNAT,一个用DNAT——两者不能复用IP。
    -> NAT网关: 80-> 私网SLB的 9080
       因为docker容器使用的IP地址与VPC网络不在一个网段, 而SLB拥有内网IP。
       所以用 SLB 做中转。
    -> 内网SLB: SLB 9080 -> ECS 9080
       (已默认提供, 由docker容器 acsrouting 容器提供)
    -> acsrouting 根据域名,将请求转发到特定的 docker容器上
       (在阿里云管理控制台/产品与服务/容器服务/服务/某个服务的"变更配置": Web路由规则中配置域名)

年费用:
* 小型NAT网关 = 12元/天 * 365天 = 4380 元/年
* 20M2IP宽带包 = 68.16/天 * 365天 = 24878.4 元/年
* 私网负载均衡 = 0 元/年
* 云主机 ecs.s3.large(4核8GB) * 3 :
    * 包年 = 4039.20 元/年 * 3 = 12117.6 元 (优选)
    * 按量 = 12091.72 元/年 * 3 = 36275.16 元

SUM = 4380 + 24878.4 + 12117.6 = 41376 元/年

# 容器 + 专有网络 + 自建DNAT/SNAT

FIXME:
1. websocket?
2. http2?
3. 容器集群内手动指定只在部分节点上发布服务?

```

* NAT网关
《[关于最新NAT网关的一些问题求解](https://bbs.aliyun.com/read/291254.html)》
一个NAT网关不能同时 SNAT, DNAT, 只能二选一。其直接结果就是花费加倍 12*365*2=8760
The specified ExternalIp is already used in SnatTable
114.55.125.80

* 网络管理
    * 创建专有网络VPC, 假设为 192.168.0.0/16
        不选用经典

    可选网段有: 192.168.0.0/16, 172.16.0.0/12, 10.0.0.0/8
    假设为192.168.0.0/16

      docker集群的IP地址为172.18.1.4
* 创建一个docker集群
    * 容器起始网段可以是  172.17.0.0/24 – 172.31.0.0/24
    * 不购买EIP
    * 不购买负载均衡
    * 不添加node


# Q & A:
* 为何不选用经典网络, 而要选用专有网络VPC?

    经典网络不能自定义IP, 无法在ESC主机上通过搭建NAT, 故无法让无公网IP的ESC主机直接访问外网。
    但可以在有外网IP的ESC主机上SSH隧道, 让无公网IP的ESC主机上设置代理达到上网的目的, 繁琐。

    此外负载均衡服务, 只能映射到不同IP的固定端口上, 我们可能在一台ESC上跑多个想暴露在
    80 端口上的服务(通过URL 转发), 这就要求 docker 服务使用独立的IP地址。经典网络中做不到。

* 为何要 NAT 网关, 而不用自建SNAT?

    如何自建SNAT 可以参考[这里](https://help.aliyun.com/document_detail/27738.html), 需要修改iptables配置。

    《[自建SNAT网关平滑迁移到NAT网关](https://help.aliyun.com/document_detail/43261.html)》

    SNAT网关比自建SNAT有更好的可用性和性能。
    NAT 网关最便宜也得需要 12*365=4380元/年, 还不包含宽带包的费用。

    NAT网关可以随时变更IP地址和宽带大小,只能按固定带宽购买。
    EIP 可以按照固定带宽或流量去购买,但绑定到一个ESC上的。ESC上需要手动设置软件路由器(ipfilter等)。
    而有EIP的ESC主机则不灵活, 需要先再购买一个
   1.37 *24*365




# DNS
## 参考
- 阿里云-域名
    - [服务简介](https://help.aliyun.com/document_detail/61257.html)
    - [API - 提交修改DNS任务 SaveTaskForModifyingDomainDns](https://help.aliyun.com/document_detail/58478.html)
- 阿里云-云解析
    - [产品概述](https://help.aliyun.com/document_detail/29699.html)
    - [API - 添加解析记录](https://help.aliyun.com/document_detail/29772.html)
        
        ```bash
        curl                  \
              -v              \
              -X GET -G       \
              --data-urlencode Format=JSON \
              --data-urlencode Version=2015-01-09 \
              --data-urlencode AccessKeyId=XXX \
              --data-urlencode Signature=XXX \
              --data-urlencode SignatureMethod=HMAC-SHA1 \
              --data-urlencode Timestamp=2015-01-09T12:00:00Z \
              --data-urlencode SignatureVersion=1.0 \
              --data-urlencode SignatureNonce=XXX \
              \
              --data-urlencode Action=AddDomainRecord \
              --data-urlencode DomainName=test.me \
              --data-urlencode RR=test13 \
              --data-urlencode Type=TXT \
              --data-urlencode Value=xxx \
              --data-urlencode TTL=600 \
              --data-urlencode Priority=1 \
              \
              https://alidns.aliyuncs.com
        ```
