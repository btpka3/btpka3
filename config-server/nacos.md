
[nacos](https://nacos.io/zh-cn/index.html)

- github
  - alibaba
    - [nacos](https://github.com/alibaba/nacos/)
        - [com.alibaba.nacos:nacos-console](https://github.com/alibaba/nacos/blob/develop/console/src/main/java/com/alibaba/nacos/Nacos.java)
  - nacos-group
    - [nacos-spring-project](https://github.com/nacos-group/nacos-spring-project)
    - [nacos-spring-boot-project](https://github.com/nacos-group/nacos-spring-boot-project)
    - [nacos-docker](https://github.com/nacos-group/nacos-docker)
       docker image : [nacos/nacos-server](https://hub.docker.com/r/nacos/nacos-server)
    - [nacos-k8s](https://github.com/nacos-group/nacos-k8s)
  - sofastack
    - [sofa-jraft](https://github.com/sofastack/sofa-jraft)
      maven gav : `com.alipay.sofa:jraft-core`
# port

## 7848


- com.alibaba.nacos.core.cluster.MemberUtil#DEFAULT_RAFT_OFFSET_PORT
- com.alibaba.nacos.core.cluster.MemberUtil#calculateRaftPort
- com.alibaba.nacos.core.cluster.MemberMetaDataConstants#RAFT_PORT
- com.alibaba.nacos.core.cluster.MemberUtil#singleParse # 设置 RAFT_PORT
- com.alibaba.nacos.core.distributed.ProtocolManager
   # injectMembers4CP -> config.setMembers
   #
- com.alibaba.nacos.core.distributed.raft.JRaftProtocol#init
- com.alibaba.nacos.core.distributed.ConsistencyConfiguration#strongAgreementProtocol
- com.alibaba.nacos.core.distributed.raft.RaftConfig
  # 该 class 启用了 ConfigurationProperties， 前缀: `nacos.core.protocol.raft`
  # 方法： getSelfMember()， 字段： selfAddress
- com.alibaba.nacos.core.distributed.raft.JRaftServer#[createMultiRaftGroup](https://github.com/alibaba/nacos/blob/8cd5a5ea0bfb7014523eb19ca72e28282a9155a2/core/src/main/java/com/alibaba/nacos/core/distributed/raft/JRaftServer.java#L257)
  - #localPeerId

com.alipay.sofa:jraft-core:
- com.alipay.sofa.jraft.RaftGroupService#start(boolean)
- com.alipay.sofa.jraft.RaftServiceFactory#createAndInitRaftNode
- com.alipay.sofa.jraft.core.[NodeImpl](https://github.com/sofastack/sofa-jraft/blob/322935562b910d415e25493c6ebe6f76713f55b2/jraft-core/src/main/java/com/alipay/sofa/jraft/core/NodeImpl.java#L1091)
  - #serverId ，示例值： `30.196.226.115:7848`
- com.alipay.sofa.jraft.rpc.impl.GrpcClient.#[newChannel](https://github.com/sofastack/sofa-jraft/blob/322935562b910d415e25493c6ebe6f76713f55b2/jraft-extension/rpc-grpc-impl/src/main/java/com/alipay/sofa/jraft/rpc/impl/GrpcClient.java#L212)

```plain
2023-05-23 20:19:46,155 INFO Node <naming_persistent_service/30.196.226.115:7848> init, term=0, lastLogId=LogId [index=0, term=0], conf=30.196.226.115:7848,11.161.45.192:7848, oldConf=.
2023-05-23 20:19:46,158 WARN RPC server is not started in RaftGroupService.
2023-05-23 20:19:46,158 INFO Start the RaftGroupService successfully.
2023-05-23 20:19:46,256 INFO Creating new channel to: 30.196.226.115:7848.
```


## 7848
## 8848
alibaba nacos 默认端口 [HTTP 端口](https://github.com/alibaba/nacos/blob/8cd5a5ea0bfb7014523eb19ca72e28282a9155a2/naming/src/main/resources/application.properties#L16)。

## 9848
针对 GRPC SDK 服务端口
com.alibaba.nacos.api.common.Constants#SDK_GRPC_PORT_DEFAULT_OFFSET = 1000
com.alibaba.nacos.core.remote.grpc.GrpcSdkServer
com.alibaba.nacos.core.remote.[BaseRpcServer](https://github.com/alibaba/nacos/blob/8cd5a5ea0bfb7014523eb19ca72e28282a9155a2/core/src/main/java/com/alibaba/nacos/core/remote/BaseRpcServer.java#L60)
com.alibaba.nacos.core.remote.grpc.BaseGrpcServer#[startServer](https://github.com/alibaba/nacos/blob/8cd5a5ea0bfb7014523eb19ca72e28282a9155a2/core/src/main/java/com/alibaba/nacos/core/remote/grpc/BaseGrpcServer.java#L91)

```plain
# ${nacos_home}/log/remote.log
2023-05-23 20:27:06,765 INFO Nacos GrpcSdkServer Rpc server started at port 9848 and tls config:{"sslProvider":"","enableTls":false,"mutualAuthEnable":false,"trustAll":false,"compatibility":true}
```

## 9849
集群模式下的 GRPC 服务端口

com.alibaba.nacos.api.common.Constants#CLUSTER_GRPC_PORT_DEFAULT_OFFSET = 1001
com.alibaba.nacos.core.remote.grpc.GrpcClusterServer

```plain
# ${nacos_home}/log/remote.log
2023-05-23 20:27:06,769 INFO Nacos GrpcClusterServer Rpc server started at port 9849 and tls config:{"sslProvider":"","enableTls":false,"mutualAuthEnable":false,"trustAll":false,"compatibility":true}
```





# java sdk : com.alibaba.nacos:nacos-client
核心java类：
- com.alibaba.nacos.api.NacosFactory
- com.alibaba.nacos.api.config.ConfigService
- com.alibaba.nacos.api.naming.NamingFactory
- com.alibaba.nacos.api.naming.NamingService
- @com.alibaba.nacos.api.annotation.NacosProperties
- @com.alibaba.nacos.api.config.annotation.NacosValue
- @com.alibaba.nacos.api.config.annotation.NacosConfigurationProperties
- com.alibaba.nacos.api.annotation.NacosInjected
- com.alibaba.nacos.api.config.annotation.NacosConfigListener
- com.alibaba.nacos.spring.core.env.NacosPropertySource
- com.alibaba.nacos.api.config.listener.Listener

# spring sdk : com.alibaba.nacos:nacos-spring-context

maven GAV: com.alibaba.boot:nacos-config-spring-boot-starter:0.2.12
maven GAV: com.alibaba.boot:nacos-discovery-spring-boot-starter:0.2.12

核心java类
- com.alibaba.nacos.spring.context.annotation.EnableNacos
- com.alibaba.nacos.spring.context.annotation.discovery.EnableNacosDiscovery
- @com.alibaba.nacos.spring.context.annotation.config.NacosPropertySource
- @com.alibaba.nacos.spring.context.annotation.config.NacosPropertySources



# spring cloud

核心java类：
- com.alibaba.cloud.nacos.NacosConfigAutoConfiguration               ⭕️
- com.alibaba.cloud.nacos.client.NacosPropertySource
- com.alibaba.cloud.nacos.NacosConfigProperties
- com.alibaba.cloud.nacos.discovery.NacosDiscoveryClient
- com.alibaba.cloud.nacos.discovery.NacosDiscoveryAutoConfiguration  ⭕️
- com.alibaba.cloud.nacos.registry.NacosServiceRegistry
- com.alibaba.cloud.nacos.balancer.NacosBalancer
- com.alibaba.cloud.nacos.refresh.NacosContextRefresher  # 当判断配置信息有变更的时候，发布 RefreshEvent。


# ERROR


```
"com.alibaba.nacos.client.Worker@10227" daemon prio=5 tid=0xf6 nid=NA runnable
  java.lang.Thread.State: RUNNABLE
	 blocks localhost-startStop-1@2386
	  at com.alibaba.nacos.common.remote.client.grpc.GrpcUtils.parse(GrpcUtils.java:132)
	  at com.alibaba.nacos.common.remote.client.grpc.GrpcClient.serverCheck(GrpcClient.java:220)
	  at com.alibaba.nacos.common.remote.client.grpc.GrpcClient.connectToServer(GrpcClient.java:329)
	  at com.alibaba.nacos.common.remote.client.RpcClient.start(RpcClient.java:363)
	  at com.alibaba.nacos.client.config.impl.ClientWorker$ConfigRpcTransportClient.ensureRpcClient(ClientWorker.java:891)
	  - locked <0x31c1> (a com.alibaba.nacos.client.config.impl.ClientWorker)
	  at com.alibaba.nacos.client.config.impl.ClientWorker$ConfigRpcTransportClient.executeConfigListen(ClientWorker.java:785)
	  at com.alibaba.nacos.client.config.impl.ClientWorker$ConfigRpcTransportClient.lambda$startInternal$2(ClientWorker.java:704)
	  at com.alibaba.nacos.client.config.impl.ClientWorker$ConfigRpcTransportClient$$Lambda$653.687978293.run(Unknown Source:-1)
	  at java.util.concurrent.Executors$RunnableAdapter.call(Executors.java:515)
	  at java.util.concurrent.FutureTask.run(FutureTask.java:264)
	  at java.util.concurrent.ScheduledThreadPoolExecutor$ScheduledFutureTask.run(ScheduledThreadPoolExecutor.java:304)
	  at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1128)
	  at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:628)
	  at java.lang.Thread.run(Thread.java:829)
```



## docker

```shell
docker run --rm -it  -p 8848:8848 -p 9848:9848 -p 9849:9849 -p 7848:7848 -e MODE=standalone nacos/nacos-server:v2.2.3
```


```shell
# 手动使用外部 MySql 数据库
docker run --rm -it  -p 8848:8848 -p 9848:9848 -p 9849:9849 -p 7848:7848 --entrypoint bash nacos/nacos-server:v2.2.3

export MYSQL_SERVICE_HOST=mysql-server.default.svc.cluster.local
export MYSQL_SERVICE_DB_NAME=nacos2
export MYSQL_SERVICE_PORT=3306
export MYSQL_SERVICE_USER=root
export MYSQL_SERVICE_PASSWORD=xxx
export SPRING_DATASOURCE_PLATFORM=mysql
export MODE=standalone
export PREFER_HOST_MODE=hostname
export NACOS_SERVERS="$(hostname):8848"

/home/nacos/bin/docker-startup.sh
```

# 本地验证

## 查询

```shell
NACOS_ADDR=http://127.0.0.1:8848
CONTEXT_ROOT=/nacos
NACOS_ADDR=http://nacos.default.svc.cluster.local:8848

namespaceId=public
dataId=gong9.mw.tddl.conf
group=gong9-mw

curl -v "${NACOS_ADDR}${CONTEXT_ROOT}/v2/cs/config?dataId=${dataId}&group=${group}&namespaceId=${namespaceId}"
```

## 更新

```shell

NACOS_ADDR=http://mse-32a46c30-nacos-ans.mse.aliyuncs.com
CONTEXT_ROOT=/nacos
namespaceId=public
dataId=gong9-mw-demo-web-test
group=demo
contentFile=/tmp/test.txt

cat > ${contentFile} <<EOF
demo001
EOF

# 更新
curl -s -X POST \
        "${NACOS_ADDR}${CONTEXT_ROOT}/v2/cs/config" \
        -d "dataId=${dataId}" \
        -d "group=${group}" \
        -d "namespaceId=${NACOS_NAMESPACE}" \
        --data-urlencode content@${contentFile}

# 读取
curl -v "${NACOS_ADDR}${CONTEXT_ROOT}/v2/cs/config?dataId=${dataId}&group=${group}&namespaceId=${namespaceId}"
```



# data 目录

```plain
/home/nacos/data/config-data/${groupId}/${dataId}
/home/nacos/data/naming/data/                                                   # empty
/home/nacos/data/protocol/raft/naming_instance_metadata/log/000004.log
/home/nacos/data/protocol/raft/naming_instance_metadata/log/CURRENT
/home/nacos/data/protocol/raft/naming_instance_metadata/log/IDENTITY
/home/nacos/data/protocol/raft/naming_instance_metadata/log/LOCK
/home/nacos/data/protocol/raft/naming_instance_metadata/log/LOG
/home/nacos/data/protocol/raft/naming_instance_metadata/log/MANIFEST-000005
/home/nacos/data/protocol/raft/naming_instance_metadata/log/OPTIONS-000007
/home/nacos/data/protocol/raft/naming_instance_metadata/log/OPTIONS-000009
/home/nacos/data/protocol/raft/naming_instance_metadata/meta-data/raft_meta
/home/nacos/data/protocol/raft/naming_instance_metadata/meta-data/snapshot/     # empty
```





# alterntive
- [Togglz](https://www.togglz.org/)
- spring cloud config
- 阿里巴巴内部 : diamond / switch


