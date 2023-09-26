[apache dubbo](https://cn.dubbo.apache.org/zh-cn/index.html)


- org.apache.dubbo.config.spring.context.annotation.DubboConfigConfiguration
- org.apache.dubbo.config.spring.ConfigCenterBean



# error
## 字符串substring下标越界

```
堆栈
"localhost-startStop-1@2386" daemon prio=5 tid=0x1c nid=NA runnable
  java.lang.Thread.State: RUNNABLE
	  at org.apache.dubbo.common.BaseServiceMetadata.interfaceFromServiceKey(BaseServiceMetadata.java:73)
	  at org.apache.dubbo.rpc.model.FrameworkServiceRepository.keyWithoutGroup(FrameworkServiceRepository.java:97)
	  at org.apache.dubbo.rpc.model.FrameworkServiceRepository.registerProvider(FrameworkServiceRepository.java:58)
	  at org.apache.dubbo.rpc.model.ModuleServiceRepository.registerProvider(ModuleServiceRepository.java:110)


参数：
serviceKey = nacos://nacos.default.svc.cluster.local:8848/org.apache.dubbo.metadata.MetadataService:1.0.0
groupIndex=7
versionIndex=5
serviceKey.substring(groupIndex, versionIndex) # 报错 java.lang.StringIndexOutOfBoundsException
原因：误设置： nacos 的地址 =>  org.apache.dubbo.config.ApplicationConfig#setName 
```

# 指定provider的 IP 和端口
- [Invoke provider with specified IP port](https://cn.dubbo.apache.org/en/docs/v2.7/user/examples/invoke-with-specified-ip/)

```java
try {
    // create Address instance based on provider's ip port
    Address address = new Address("10.220.47.253", 20880);
    RpcContext.getContext().setObjectAttachment("address", address);
    return testService.sayHello("Tom");
} catch (Throwable ex){
    return ex.getMessage();
}
```


# dubbo-admin

- [docker.io/apache/dubbo-admin:0.5.0](https://hub.docker.com/r/apache/dubbo-admin)
-《[Dubbo Admin配置说明](https://github.com/apache/dubbo-admin/wiki/Dubbo-Admin%E9%85%8D%E7%BD%AE%E8%AF%B4%E6%98%8E)》

```shell

echo '
server.port=38080
#dubbo.protocol.port=30880
#dubbo.application.qos-port=32222

admin.config-center=nacos://nacos:nacos@11.167.75.235:8848?group=DEFAULT_GROUP&namespace=public
admin.registry.address=nacos://nacos:nacos@11.167.75.235:8848?group=dubbo
admin.metadata-report.address=nacos://nacos:nacos@11.167.75.235:8848?group=dubbo
admin.root.user.name=root
admin.root.user.password=root
admin.check.sessionTimeoutMilli=3600000
server.compression.enabled=true
server.compression.mime-types=text/css,text/javascript,application/javascript
server.compression.min-response-size=10240
admin.check.tokenTimeoutMilli=3600000
admin.check.signSecret=86295dd0c4ef69a1036b0b0c15158d77
dubbo.application.name=dubbo-admin
dubbo.registry.address=${admin.registry.address}
spring.datasource.url=jdbc:h2:mem:~/dubbo-admin;MODE=MYSQL;
spring.datasource.username=sa
spring.datasource.password=
mybatis-plus.global-config.db-config.id-type=none
dubbo.application.logger=slf4j
' > /tmp/application.properties

docker run -it --rm \
    -v /tmp/application.properties:/config/application.properties \
    -p 38080:38080 \
    docker.io/apache/dubbo-admin:0.5.0

``` 
浏览器访问： [http://localhost:38080](http://localhost:38080)

docker run -it --rm --name tmp_dubbo_admin --entrypoint sh docker.io/apache/dubbo-admin:0.5.0

docker run -it --rm  --entrypoint sh docker.io/apache/dubbo-admin:0.5.0

docker cp tmp_dubbo_admin:/app.jar /tmp/app.jar



# ???
```shell
-Ddubbo.application.check-serializable=false
-Ddubbo.application.serialize-check-status=DISABLE
-Ddubbo.hessian.allowNonSerializable=true
```

# 序列化：Serialization
- org.apache.dubbo.common.serialize.Serialization
- org.apache.dubbo.common.serialize.hessian2.Hessian2Serialization deserialize

watch org.apache.dubbo.common.serialize.hessian2.Hessian2FactoryManager getSerializerFactory '{params[0],returnObj,throwExp}' -x 3


```txt
# dubbo 调用后，对返回值的反序列化调用
ts=2023-08-21 09:56:10;thread_name=arthas-command-execute;id=1dd;is_daemon=true;priority=5;TCCL=com.taobao.pandora.boot.loader.ReLaunchURLClassLoader@79079097
    @org.apache.dubbo.common.serialize.hessian2.Hessian2Serialization.deserialize()
        at org.apache.dubbo.common.serialize.DefaultSerializationExceptionWrapper.deserialize(DefaultSerializationExceptionWrapper.java:57)
        at org.apache.dubbo.rpc.protocol.dubbo.DecodeableRpcResult.decode(DecodeableRpcResult.java:94)
        at org.apache.dubbo.rpc.protocol.dubbo.DecodeableRpcResult.decode(DecodeableRpcResult.java:149)
        at org.apache.dubbo.remoting.transport.DecodeHandler.decode(DecodeHandler.java:62)
        at org.apache.dubbo.remoting.transport.DecodeHandler.received(DecodeHandler.java:50)
        at org.apache.dubbo.remoting.transport.dispatcher.ChannelEventRunnable.run(ChannelEventRunnable.java:62)
        at org.apache.dubbo.common.threadpool.ThreadlessExecutor$RunnableWrapper.run(ThreadlessExecutor.java:152)
        at org.apache.dubbo.common.threadpool.ThreadlessExecutor.waitAndDrain(ThreadlessExecutor.java:77)
        at org.apache.dubbo.rpc.AsyncRpcResult.get(AsyncRpcResult.java:205)
        at org.apache.dubbo.rpc.protocol.AbstractInvoker.waitForResultIfSync(AbstractInvoker.java:287)
        at org.apache.dubbo.rpc.protocol.AbstractInvoker.invoke(AbstractInvoker.java:190)
        at org.apache.dubbo.rpc.listener.ListenerInvokerWrapper.invoke(ListenerInvokerWrapper.java:71)
        at org.apache.dubbo.metrics.filter.MetricsFilter.invoke(MetricsFilter.java:63)
        at org.apache.dubbo.rpc.cluster.filter.FilterChainBuilder$CopyOfFilterChainNode.invoke(FilterChainBuilder.java:334)
        at org.apache.dubbo.rpc.cluster.filter.FilterChainBuilder$CallbackRegistrationInvoker.invoke(FilterChainBuilder.java:196)
        at org.apache.dubbo.rpc.protocol.ReferenceCountInvokerWrapper.invoke(ReferenceCountInvokerWrapper.java:78)
        at org.apache.dubbo.rpc.cluster.support.AbstractClusterInvoker.invokeWithContext(AbstractClusterInvoker.java:383)
        at org.apache.dubbo.rpc.cluster.support.FailoverClusterInvoker.doInvoke(FailoverClusterInvoker.java:80)
        at org.apache.dubbo.rpc.cluster.support.AbstractClusterInvoker.invoke(AbstractClusterInvoker.java:344)
        at org.apache.dubbo.rpc.cluster.router.RouterSnapshotFilter.invoke(RouterSnapshotFilter.java:46)
        at org.apache.dubbo.rpc.cluster.filter.FilterChainBuilder$CopyOfFilterChainNode.invoke(FilterChainBuilder.java:334)
        at org.apache.dubbo.monitor.support.MonitorFilter.invoke(MonitorFilter.java:108)
        at org.apache.dubbo.rpc.cluster.filter.FilterChainBuilder$CopyOfFilterChainNode.invoke(FilterChainBuilder.java:334)
        at org.apache.dubbo.rpc.cluster.filter.support.MetricsClusterFilter.invoke(MetricsClusterFilter.java:50)
        at org.apache.dubbo.rpc.cluster.filter.FilterChainBuilder$CopyOfFilterChainNode.invoke(FilterChainBuilder.java:334)
        at org.apache.dubbo.rpc.protocol.dubbo.filter.FutureFilter.invoke(FutureFilter.java:52)
        at org.apache.dubbo.rpc.cluster.filter.FilterChainBuilder$CopyOfFilterChainNode.invoke(FilterChainBuilder.java:334)
        at org.apache.dubbo.spring.security.filter.ContextHolderParametersSelectedTransferFilter.invoke(ContextHolderParametersSelectedTransferFilter.java:41)
        at org.apache.dubbo.rpc.cluster.filter.FilterChainBuilder$CopyOfFilterChainNode.invoke(FilterChainBuilder.java:334)
        at org.apache.dubbo.rpc.cluster.filter.support.ConsumerClassLoaderFilter.invoke(ConsumerClassLoaderFilter.java:40)
        at org.apache.dubbo.rpc.cluster.filter.FilterChainBuilder$CopyOfFilterChainNode.invoke(FilterChainBuilder.java:334)
        at org.apache.dubbo.rpc.cluster.filter.support.ConsumerContextFilter.invoke(ConsumerContextFilter.java:118)
        at org.apache.dubbo.rpc.cluster.filter.FilterChainBuilder$CopyOfFilterChainNode.invoke(FilterChainBuilder.java:334)
        at org.apache.dubbo.rpc.cluster.filter.FilterChainBuilder$CallbackRegistrationInvoker.invoke(FilterChainBuilder.java:196)
        at org.apache.dubbo.rpc.cluster.support.wrapper.AbstractCluster$ClusterFilterInvoker.invoke(AbstractCluster.java:91)
        at org.apache.dubbo.rpc.cluster.support.wrapper.MockClusterInvoker.invoke(MockClusterInvoker.java:103)
        at org.apache.dubbo.rpc.cluster.support.wrapper.ScopeClusterInvoker.invoke(ScopeClusterInvoker.java:169)
        at org.apache.dubbo.registry.client.migration.MigrationInvoker.invoke(MigrationInvoker.java:284)
        at org.apache.dubbo.rpc.proxy.InvocationUtil.invoke(InvocationUtil.java:57)
        at org.apache.dubbo.rpc.proxy.InvokerInvocationHandler.invoke(InvokerInvocationHandler.java:75)
        at com.alibaba.security.openapi.service.MetaServiceDubboProxy2.getRiskTagList(MetaServiceDubboProxy2.java:-1)
        at jdk.internal.reflect.NativeMethodAccessorImpl.invoke0(NativeMethodAccessorImpl.java:-2)
        at jdk.internal.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)
        at jdk.internal.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
        at java.lang.reflect.Method.invoke(Method.java:566)
        at ognl.OgnlRuntime.invokeMethod(OgnlRuntime.java:899)
        at ognl.OgnlRuntime.callAppropriateMethod(OgnlRuntime.java:1544)
        at ognl.ObjectMethodAccessor.callMethod(ObjectMethodAccessor.java:68)
        at ognl.OgnlRuntime.callMethod(OgnlRuntime.java:1620)
        at ognl.ASTMethod.getValueBody(ASTMethod.java:91)
        at ognl.SimpleNode.evaluateGetValueBody(SimpleNode.java:212)
        at ognl.SimpleNode.getValue(SimpleNode.java:258)
        at ognl.ASTChain.getValueBody(ASTChain.java:141)
        at ognl.SimpleNode.evaluateGetValueBody(SimpleNode.java:212)
        at ognl.SimpleNode.getValue(SimpleNode.java:258)
        at ognl.ASTSequence.getValueBody(ASTSequence.java:63)
        at ognl.SimpleNode.evaluateGetValueBody(SimpleNode.java:212)
        at ognl.SimpleNode.getValue(SimpleNode.java:258)
        at ognl.Ognl.getValue(Ognl.java:470)
        at ognl.Ognl.getValue(Ognl.java:572)
        at ognl.Ognl.getValue(Ognl.java:542)
        at com.taobao.arthas.core.command.express.OgnlExpress.get(OgnlExpress.java:40)
        at com.taobao.arthas.core.command.klass100.OgnlCommand.process(OgnlCommand.java:105)
        at com.taobao.arthas.core.shell.command.impl.AnnotatedCommandImpl.process(AnnotatedCommandImpl.java:82)
        at com.taobao.arthas.core.shell.command.impl.AnnotatedCommandImpl.access$100(AnnotatedCommandImpl.java:18)
        at com.taobao.arthas.core.shell.command.impl.AnnotatedCommandImpl$ProcessHandler.handle(AnnotatedCommandImpl.java:111)
        at com.taobao.arthas.core.shell.command.impl.AnnotatedCommandImpl$ProcessHandler.handle(AnnotatedCommandImpl.java:108)
        at com.taobao.arthas.core.shell.system.impl.ProcessImpl$CommandProcessTask.run(ProcessImpl.java:385)
        at java.util.concurrent.Executors$RunnableAdapter.call(Executors.java:515)
        at java.util.concurrent.FutureTask.run(FutureTask.java:264)
        at java.util.concurrent.ScheduledThreadPoolExecutor$ScheduledFutureTask.run(ScheduledThreadPoolExecutor.java:304)
        at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1128)
        at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:628)
        at java.lang.Thread.run(Thread.java:829)
```