TODO

## spring-cloud-config


[spring-cloud-config-server](https://github.com/spring-cloud/spring-cloud-config/blob/master/spring-cloud-config-server)
是一个示例。

可以从 git 仓库中读取配置。


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
    

