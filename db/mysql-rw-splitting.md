一下是旭阳写的,本人尚未实践。

# mysql Read/Write Splitting -- mysql读写分离
[什么是读写分离](http://baike.baidu.com/link?url=KeEHhhriTrdzziYnCmKV6COAyO5iZRJkSCtSCbq8SjKGws57hRCGryFq4mZZC13T6ZZyYt_yZnJeP327iO_Xn_)

现在主要的读写分离插件/中间件：
  * [Amoeba](http://sourceforge.net/projects/amoeba/) -- 陈思儒（前阿里）
  * [cobar](https://github.com/alibaba/cobar) -- 阿里
  * [TDDL](http://www.tuicool.com/articles/nmeuu2) -- 阿里
  * [Atlas](https://github.com/Qihoo360/Atlas/) -- Qihoo360

[什么是Atlas](https://github.com/Qihoo360/Atlas/blob/master/README_ZH.md)

Atlas的主要功能（这里主要进行前两点的配置说明）：

  * 读写分离
  * 从库负载均衡
  * IP过滤
  * 自动分表
  * DBA可平滑上下线DB
  * 自动摘除宕机的DB

测试设备：

| 类型        | 服务器地址         | 版本  |
| ------------- |:-------------:| -----:|
|mysql主库|192.168.101.86|mysql  Ver 14.14 Distrib 5.5.40, for debian-linux-gnu (x86_64) using readline 6.2|
|mysql从库|192.168.101.82|mysql  Ver 14.14 Distrib 5.6.20, for Linux (x86_64) using  EditLine wrapper|
|atlas服务器|192.168.101.83|Atlas-2.2.1.el6.x86_64.rpm，注意续安装mysql客户端进行测试|
slave在master的复制用户为s82。
master和slave的访问用户为naladb。


## [数据库主从复制](http://git.lizi.com/pd/pd-env/wikis/mysql-replication)

## 下载并安装atlas
[下载地址](https://github.com/Qihoo360/Atlas/releases)，选择最新的centos版本Atlas-2.2.1.el6.x86_64.rpm并进行安装

注意：Atlas只能安装运行在64位的系统上。

## 配置文件修改
[配置文件修改](https://github.com/Qihoo360/Atlas/wiki/Atlas%E7%9A%84%E5%AE%89%E8%A3%85)

可使用默认的test配置文件的基础上进行修改即可，也可自定义配置文件，都需要在启动atlas时进行指定。

## 启动并测试
  * sudo ./mysql-proxyd test start，启动Atlas。
  * sudo ./mysql-proxyd test restart，重启Atlas。
  * sudo ./mysql-proxyd test stop，停止Atlas。
在保证主从mysql库已经正常运行的情况下，在atlas的服务器上进入命令行（mysql -h127.0.0.1 -P1234 -u用户名 -p密码），若可以正常登陆说明初步安装正确，然后进行查询和insert等sql语句进行验证。
atlas的目录很简单：
   * /usr/local/mysql-proxy/bin/ 启动脚本，主要使用mysql-proxyd，注意不是mysql-proxy！
   * /usr/local/mysql-proxy/log/ 日志目录，可以查看系统日志以及sql执行日志
   * /usr/local/mysql-proxy/conf/ 配置文件目录，默认为test，可以自定义配置文件，均需要在启动atlas时进行指定
   * /usr/local/mysql-proxy/lib/ 项目依赖

常见问题：
   自动读写分离挺好，但有时候我写完马上就想读，万一主从同步延迟怎么办?
   解决方案：SQL语句前增加 /*master*/ 就可以将读请求强制发往主库。在mysql命令行测试该功能时，需要加-c选项，以防mysql客户端过滤掉注释信息，比如在命令行中强制查询主库，可执行 "/*master-c*/select * from test01;"。



