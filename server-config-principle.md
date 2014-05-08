# 服务配置准则

1. 软件安装方式应当遵循以下优先顺序：
    1. 使用 `yum` 安装。
    1. 使用预编译的 rpm，bin 安装。但一定要确保来源可靠。
    1. 使用源码包进行本地编译安装。只有当上述方式不满足、版本较老、或预编译的选项不符合要求时才使用该方式。前两种方式一般都提供好了init.d脚本等，比较方便。

1. 全局性的环境变量应配置到 `/etc/profile.d/his.sh`。用户别的环境变量应当配置到  `~/.bashrc` 中
1. 安装的服务、应用，需使用各自独立的系统账户运行，不可使用root账户运行。
1. 安装的服务、应统一使用 `service xxxServiceName  start|stop|restart|status` 进行起停控制。  
    该命令需要配置init脚本： `/etc/init.d/xxxServiceName`。
    环境变量，运行用的系统用户应尽量在 init.d 脚本中配置。
    如果源码编译安装时不提供init.d脚本，需要手动编写，。之后一般需要执行以下命令：

    ```sh
[root@localhost ~] chkconfig --add xxxInit.d                    # xxxInit.d 是init.d脚本的文件名
[root@localhost ~] chkconfig --list xxxInit.d                    # 查看默认启动级别
[root@localhost ~] chkconfig --level 345 xxxInit.d  on      # 设置默认启动级别为 init 3, 4, 5
[root@localhost ~] service xxxInit.d  start                      #  之后就可以通过service命令启动了。注意：service命令只能由root账户运行。
    ```
    

# 目录规范
1. rpm 安装类的软件按照其默认的安装路径。比如：nginx，postgresql等。但是主要数据存放应通过环境变量、配置文件单独指定目录。比如 PostgreSql 指定PG_DATA环境变量指定到 /data/store/${software-name}/ 。
2. 解压类、编译类软件包的安装路径应指定到 /data/software/${software-name}/ 。比如tomcat、redis等
3. TC研发中心开发的应用都放到 `/data/app/${software-name}/` 目录下

示例：
```sh
# 解压类、编译类软件包的安装路径
/data/software/tomcat/default/                           # tomcat 根目录。一个tomcat运行所有的Web应用时，应使用该tomcat
/data/software/tomcat/${app-artifact-id}/             # tomcat 根目录。一个tomcat运行单独某个Web应用时使用
/data/software/redis/                                         # redis根目录

# 软件包额外存储目录
/data/store/postgres/                                        # PG_DATA=/data/db/postgres
/data/store/redis                                               # redis磁盘存储目录
/data/store/zookeepr                                         # zookeep磁盘存储目录


# his 应用部署目录
/data/app/${app-artifact-id}/${app-artifact-id}-x.x.x.zip  
/data/app/${app-artifact-id}/${app-artifact-id}/conf
/data/app/${app-artifact-id}/${app-artifact-id}/bin
/data/app/${app-artifact-id}/${app-artifact-id}/lib

# 日志目录
/data/outputs/log/${app-artifact-id}/
/data/outputs/log/${software-name}/
```

# 开发用主机列表
## 开发测试主机列表
| IP | 主机名| 备注 |
| ---- | ---- | ---- |
| 80 | nginx | |

## 本地开发主机列表
| IP | 主机名| 备注 |
| ---- | ---- | ---- |
|10.1.110.0 | dev-db1 | DB: HIS、SSO、MIN；zookeeper | 


# 端口分配

| 端口 | 使用者| 备注 |
| ---- | ---- | ---- |
| 80 | nginx | |
| 81 | nginx | 反向代理Gitlab |
| 1233 | PostgresSql | |
| 6379 | redis | |
| 2181 | zookeeper | clientPort|
| 2888 | zookeeper | zookeeper节点间相互通信的端口。|
| 3888 | zookeeper | zookeeper节点间用于Leader选举通信的端口。|
| 1801x | xx       | 18010：dubob服务端口 |
| 1802x | xx             | 18020：http；18021：https；18022：tomcat adimin； 18023：AJP；18024：JPDA；|
| 1902x | sonarQube                      | 19020：http |
