
# spring-cloud
[spring cloud](https://docs.spring.io/spring-cloud/docs/2021.0.6/reference/html/)

## spring-cloud-build

## spring-cloud-bus
将多个 spring boot 的服务节点 通过一个轻量级的 message broker 将其组成一个分布式系统。
他们之间可以通过 广播状态变更。

endpoint
- /actuator/busrefresh
- /actuator/busenv

核心java类
- org.springframework.cloud.bus.event.RemoteApplicationEvent


## spring-cloud-circuitbreaker

## spring-cloud-cli
## spring-cloud-cloudfoundry

## spring-cloud-commons
- 在spring标砖的 applicationContext 基础之上，提供了一个新的 `Bootstrap` 的 ApplicationContext, 并使用一个独立的 简短的 配置文件。
- 核心抽象：
  - 服务发现
  - 服务注册
  - 提供自带 Load Balancer 的 RestTemplate、WebClient
  - client端的负载均衡
  - Circuit Breaker : 熔断机制
  - CachedRandomPropertySource
- 核心Java类
  - org.springframework.cloud.bootstrap.BootstrapConfiguration
  - org.springframework.cloud.bootstrap.config.PropertySourceLocator
  - org.springframework.cloud.context.config.annotation.RefreshScope
  - @org.springframework.cloud.client.discovery.EnableDiscoveryClient
  - org.springframework.cloud.client.discovery.DiscoveryClient
  - org.springframework.cloud.client.discovery.ReactiveDiscoveryClient
  - org.springframework.cloud.client.serviceregistry.ServiceRegistry
  - org.springframework.cloud.client.loadbalancer.reactive.ReactiveLoadBalancer
  - org.springframework.cloud.util.random.CachedRandomPropertySource


## spring-cloud-config



[spring-cloud-config-server](https://github.com/spring-cloud/spring-cloud-config/blob/master/spring-cloud-config-server)
是一个示例。

可以从 git 仓库中读取配置。

- 支持从各种不同的远端存储拉配置文件。
- 配置文件加解密
- 往 spring cloud bus 上推送通知
- config server 的 HTTP endpoint 格式列表：
  - `/{application}/{profile}[/{label}]`
  - `/{application}-{profile}.yml`
  - `/{label}/{application}-{profile}.yml`
  - `/{application}-{profile}.properties`
  - `/{label}/{application}-{profile}.properties`

- 支持各种不同的底层存储作为 config server
  - git
  - File System
  - JDBC
  - redis
  - Vault
- FIXME
  - 如何拉取自定义配置？而不是 application.properties




## spring-cloud-consul
## spring-cloud-contract

- vs. swagger? [issue 136 : Integration with Swagger 2 / Open API](https://github.com/spring-cloud/spring-cloud-contract/issues/136)

    - spring-cloud-contract 只模拟接口，并不定义 API 内完整的字段。

- [技术干货 | 消费者驱动契约(CDC) 之 SpringCloud Contracts](http://www.sohu.com/a/200331844_617676)

    开发流程

    ```text
    消费端                             服务端
    编写相关单元测试
    编写需求的实现
    将服务端工程clone 到本地
    在服务端工程中定义契约
    在服务端工程中添加SpringCloud Contract Verifier插件，创建并安装stubs到仓库
    运行集成测试，直到功能符合需求
    在服务端工程中编写的契约提交到仓库
                                        检出新分支并pull契约
                                        定义接口
                                        实现接口
                                        对接口进行测试、验收
                                        合并代码到master并发布到仓库
    合并代码到master并发布到仓库
    ```
## spring-cloud-function
## spring-cloud-gateway
## spring-cloud-kubernetes

核心java类
- org.springframework.cloud.kubernetes.discovery.KubernetesDiscoveryClient

## spring-cloud-netflix
## spring-cloud-openfeign
## spring-cloud-sleuth
## spring-cloud-stream
## spring-cloud-task

## spring-cloud-vault

- spring cloud config server 的实现端和客户端
- 秘钥存储
- 认证
- ACL
-



## spring-cloud-zookeeper

功能
- Service Discovery : 服务发现
- spring cloud config server 的实现端和客户端

- 核心类
  - org.springframework.cloud.client.discovery.DiscoveryClient
  - org.springframework.cloud.zookeeper.discovery.watcher.DependencyWatcherListener
  - org.springframework.cloud.zookeeper.serviceregistry.ZookeeperServiceRegistry

# RefreshScope

- org.springframework.cloud.autoconfigure.RefreshAutoConfiguration#refreshScope() 注册了一个bean `refreshScope`
- org.springframework.cloud.context.scope.refresh.RefreshScope extends org.springframework.cloud.context.scope.GenericScope
- org.springframework.cloud.context.scope.GenericScope 实现了 BeanFactoryPostProcessor
  并在 postProcessBeanFactory() 中通过 org.springframework.beans.factory.config.ConfigurableBeanFactory#registerScope
  注册了 `refresh` scope
- org.springframework.cloud.context.scope.refresh.RefreshScope 实现了 `ApplicationListener<ContextRefreshedEvent>` 接口
  并在
