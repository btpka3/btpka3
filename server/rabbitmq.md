# Docker 安装


## 创建自定义镜像

构建本地镜像


```
mkdir /tmp/aaa
cd /tmp/aaa
touch Dockerfile  # 文件内容见后面
docker build -t btpka3/my-mq:1.0 .
docker images
```

Dockerfile 文件内容

```
FROM rabbitmq

RUN rabbitmq-plugins enable --offline rabbitmq_management
EXPOSE 15671 15672

RUN rabbitmq-plugins enable --offline rabbitmq_mqtt
EXPOSE 1883 8883

RUN echo =====RABBITMQ_VERSION: ${RABBITMQ_VERSION}
ADD https://dl.bintray.com/rabbitmq/community-plugins/rabbitmq_web_mqtt-3.6.x-14dae543.ez \
    /usr/lib/rabbitmq/lib/rabbitmq_server-$RABBITMQ_VERSION/plugins/
RUN chmod go+r /usr/lib/rabbitmq/lib/rabbitmq_server-$RABBITMQ_VERSION/plugins/rabbitmq_web_mqtt-3.6.x-14dae543.ez
EXPOSE 15675

RUN rabbitmq-plugins enable --offline rabbitmq_web_mqtt
```



/var/lib/rabbitmq

```
mkdir -p ~/tmp/mq/conf/
mkdir -p ~/tmp/mq/data/
echo '[ { rabbit, [ { loopback_users, [ ] } ] } ].' > ~/tmp/mq/conf/rabbitmq.config
touch ~/tmp/mq/conf/rabbitmq-env.conf

docker run -d \
    --name mq \
    -p 4369:4369 \
    -p 5671:5671 \
    -p 5672:5672 \
    -p 25672:25672 \
    -p 15671:15671 \
    -p 15672:15672 \
    -p 1883:1883 \
    -p 8883:8883 \
    -p 15675:15675 \
    -v /Users/zll/tmp/mq/data/:/var/lib/rabbitmq/:rw \
    -v /Users/zll/tmp/mq/conf/rabbitmq.config:/etc/rabbitmq/rabbitmq.config \
    -v /Users/zll/tmp/mq/conf/rabbitmq-env.conf:/etc/rabbitmq/rabbitmq-env.conf \
    btpka3/my-mq:1.0

docker exec -it mq bash
# 启用 MQTT 插件
rabbitmq-plugins enable rabbitmq_mqtt

# 显示默认配置
cat /etc/rabbitmq/rabbitmq.config
cat /etc/rabbitmq/enabled_plugins


# 通过浏览器访问
# http://localhost:15672



```

## TLS

```
[
    {ssl,           [
        {versions,              ['tlsv1.2', 'tlsv1.1']}
    ]},
    {rabbit,        [
        {loopback_users,        []},  
        {ssl_listeners,         [5671]},
        {ssl_options,           [
            {cacertfile,            "/var/lib/rabbitmq/myca.pem.cer"},
            {certfile,              "/var/lib/rabbitmq/server.pem.cer"},
            {keyfile,               "/var/lib/rabbitmq/server.pem.key"},
            {versions,              ['tlsv1.2', 'tlsv1.1']},
            {verify,                verify_peer},
            {fail_if_no_peer_cert,  false}
        ]}
    ]},
    {rabbitmq_mqtt, [
        {default_user,          "guest"},
        {default_pass,          "guest"},
        {allow_anonymous,       false},
        {vhost,                 "/"},
        {exchange,              "amq.topic"},
        {subscription_ttl,      1800000},
        {prefetch,              10},
        {ssl_listeners,         [8883]},
        {tcp_listeners,         [1883]},
        {tcp_listen_options,    [
            {backlog,               128},
            {nodelay,               true}
        ]}
    ]}
].
```


## RabbitMQ常用命令

```sh
# 启停命令等
[me@localhost:~] sudo service rabbitmq-server xxx

# 重置（即清除所有queue，binding，message等）
[me@localhost:~] sudo rabbitmqctl stop_app
[me@localhost:~] sudo rabbitmqctl force_reset
[me@localhost:~] sudo rabbitmqctl start_app


# 列出给定的 queues
sudo rabbitmqctl list_queues
```




## 安装Erlang

RabbitMQ是使用Erlang开发，因此需要先安装Erlang。具体要使用哪个版本。则需要看一下[这里](http://www.rabbitmq.com/which-erlang.html)了。最低需要 R13B03。


PRM 安装请参考[这里](https://www.erlang-solutions.com/downloads/download-erlang-otp)。提示：请确 CentOS 上已经安装了 EPEL.

虽然测试环境的都是 CentOs 6.x系列，而生产环境则还有 CentOs 5.x 系列。
通过[这里](https://fedoraproject.org/wiki/Erlang)可以得知，CentOS 5.x下的EPEL只支持到 R12B-5，版本太低了。
如果要使用RabbitMq集群，则使用的RabbitMQ、Erlang需要一致。因此，为了方便起见，Erlang还是使用源码编译安装。


从[这里](http://www.erlang.org/download.html)下载 otp_src_17.1.tar.gz。解压后需要先阅读一下 `README.md` 和 `HOWTO/INSTALL.md`

```sh

# 依赖检查
yum install unixODBC unixODBC-dev openssl openssl-devel
make -v                 # 确保有GNU Make
gcc  --version          # 确保有GNU gcc
perl -v                 # 确保 perl 的版本 >= 5
m4   --version          # 确保有GNU M4
rpm  -q ncurses-devel   # 确保 ncurses-devel 已经安装。若未安装可以使用 yum install ncurses-devel 安装。
sed  --version          # 确保已经安装了 sed
rpm  -q openssl         # (可选)检查openssl已经安装，如有必要，升级一下版本
java -version           # (可选)检查已经安装了Oracle JDK
rpm  -q flex            # (可选)
# skip X Windows、wxWidgets check


# 解压
tar zxvf otp_src_17.1.tar.gz
cd otp_src_17.1
export ERL_TOP=`pwd`
export LANG=C

# 配置
# 默认是安装到 `/usr/local/{bin,lib/erlang}` 下的， 这里我们可以不指定PREFIX。
./configure  --enable-threads --enable-smp-support --enable-kernel-poll --enable-hipe

# 编译
make

# （可选）测试。 FIXME: 在测试环境上是有几个testcase没通过的，暂不知会造成何种影响
make release_tests
cd release/tests/test_server
$ERL_TOP/bin/erl -s ts install -s ts smoke_test batch -s init stop
# 运行完testcase之后，可以scp -r user@xxx.xxx.xxx.xxx:$ERL_TOP/release/tests/test_server /tmp/1 ,在本地浏览器查看结果

# 安装
cd $ERL_TOP
make install

# 简单测试
erl
A=12.
A.
```

## 压缩包安装RabbitMq
参考[这里](http://www.rabbitmq.com/download.html)，安装 **Installing on Generic Unix**, 基本上解压后就可以直接运行了。

```
tar zxvf rabbitmq-server-generic-unix-3.3.5.tar.gz -C /usr/local/

# 修改配置 rabbitmq.config
cd /usr/local/rabbitmq_server-3.3.5
vi ./etc/rabbitmq/rabbitmq.config                          # 可以使guest账户远程主机登录
[{rabbit, [{loopback_users, []}]}].


useradd rabbitmq
chown -R rabbitmq:rabbitmq /usr/local/rabbitmq_server-3.3.5

vi /etc/profile.d/lizi.sh
export RABBITMQ_HOME=/usr/local/rabbitmq_server-3.3.5
export PATH=$RABBITMQ_HOME/sbin:$PATH
```

## yum/rpm 安装

使用yum/rpm 安装，请参考[这里](http://www.rabbitmq.com/install-rpm.html)。

```
systemctl is-enabled rabbitmq-server
systemctl status rabbitmq-server
systemctl restart rabbitmq-server

```

# 创建集群
参考官方文档[clustering](http://www.rabbitmq.com/clustering.html) 和[HA](http://www.rabbitmq.com/ha.html)。非官方总结可以参考[这里](http://88250.b3log.org/rabbitmq-clustering-ha)。
下面以服务器 s83 和 s85 创建集群为例，进行步骤介绍


```sh
# 分别在 s83、s85 修改hosts
vi /etc/hosts
192.168.101.83 s83
192.168.101.85 s85

# 先启动 s83
[root@s83 ~]# su - rabbitmq
[rabbitmq@s83 ~]$ rabbitmq-server -detached                                          # 以 rabbitmq 用户启动
[rabbitmq@s83 ~]$ scp /home/rabbitmq/.erlang.cookie rabbitmq@s85:/home/rabbitmq/     # 使集群用的cookie相同  

# 再启动 s85
[root@s85 ~]# su - rabbitmq
[rabbitmq@s85 ~]$ rabbitmq-server -detached
[rabbitmq@s85 ~]$ rabbitmqctl stop_app
[rabbitmq@s85 ~]$ rabbitmqctl join_cluster rabbit@s83                               # 加入、创建集群
[rabbitmq@s85 ~]$ rabbitmqctl start_app

rabbitmqctl cluster_status                                # 分别确认集群状态  

rabbitmqctl set_policy ha-all "^" '{"ha-mode":"all"}'     # 设置HA模式：所有消息都会两个节点上copy
rabbitmqctl set_policy TTL ".*" '{"message-ttl":60000}'   # 设置消息过期时间：60秒

# （可选）安装一些插件
rabbitmq-plugins enable rabbitmq_management
rabbitmq-plugins enable rabbitmq_federation
rabbitmq-plugins enable rabbitmq_federation_management
# 之后重启RabbitMQ，并访问 http://xxxx:15672

# 用户管理
rabbitmq默认的用户和密码均为：guest
rabbitmqctl delete_user guest                              # 删除guest用户
rabbitmqctl add_user lizi lizi_mq                          # 添加用户，用户名：lizi；密码：lizi_mq
rabbitmqctl set_user_tags lizi administrator               # 为lizi用户设置administrator权限，可选的
                                                           # 权限有：administrator,monitoring, management
rabbimqctl change_password lizi {newpassword}              # 为lizi用户修改密码
```



 


修改 `/etc/hosts`

```
192.168.101.83 s83
192.168.101.85 s85
```


集群配置参考


开启相关插件. [Management](http://www.rabbitmq.com/management.html)、
[federation](http://www.rabbitmq.com/federation.html)

 
设置所有资源都使用HA模式

```
rabbitmqctl set_policy ha-all "^" '{"ha-mode":"all"}'
```


# 启停命令

```sh
# 1. 先到所有集群节点的电脑上执行以下命令
su - rabbitmq
rabbitmq-server -detached

# 2. 在到任一集群节点上确认
su - rabbitmq
rabbitmqctl cluster_status 
```



XXX：不要使用以下init.d脚本。`/etc/init.d/rabbitmq-server` 以下示例文件是从rpm包中提取的。

```sh
#!/bin/sh
#
# rabbitmq-server RabbitMQ broker
#
# chkconfig: - 80 05
# description: Enable AMQP service provided by RabbitMQ
#

### BEGIN INIT INFO
# Provides:          rabbitmq-server
# Required-Start:    $remote_fs $network
# Required-Stop:     $remote_fs $network
# Description:       RabbitMQ broker
# Short-Description: Enable AMQP service provided by RabbitMQ broker
### END INIT INFO

# Source function library.
. /etc/init.d/functions
. /etc/profile.d/lizi.sh

#PATH=/sbin:/usr/sbin:/bin:/usr/bin
export HOME=/home/rabbitmq

NAME=rabbitmq-server
DAEMON=${RABBITMQ_HOME}/sbin/${NAME}
CONTROL=${RABBITMQ_HOME}/sbin/rabbitmqctl
DESC=rabbitmq-server
USER=rabbitmq
ROTATE_SUFFIX=
INIT_LOG_DIR=/var/log/rabbitmq
PID_FILE=/var/run/rabbitmq/pid

START_PROG="daemon"
LOCK_FILE=/var/lock/subsys/$NAME


test -x $DAEMON || exit 0
test -x $CONTROL || exit 0

RETVAL=0
set -e

[ -f /etc/default/${NAME} ] && . /etc/default/${NAME}

ensure_pid_dir () {
    PID_DIR=`dirname ${PID_FILE}`
    if [ ! -d ${PID_DIR} ] ; then
        mkdir -p ${PID_DIR}
        chown -R ${USER}:${USER} ${PID_DIR}
        chmod 755 ${PID_DIR}
    fi
}

remove_pid () {
    rm -f ${PID_FILE}
    rmdir `dirname ${PID_FILE}` || :
}

start_rabbitmq () {
    status_rabbitmq quiet
    if [ $RETVAL = 0 ] ; then
        echo RabbitMQ is currently running
    else
        RETVAL=0
        ensure_pid_dir
        set +e
        RABBITMQ_PID_FILE=$PID_FILE $START_PROG $DAEMON \
            > "${INIT_LOG_DIR}/startup_log" \
            2> "${INIT_LOG_DIR}/startup_err" \
            0<&- &
        $CONTROL wait $PID_FILE >/dev/null 2>&1
        RETVAL=$?
        set -e
        case "$RETVAL" in
            0)
                echo SUCCESS
                if [ -n "$LOCK_FILE" ] ; then
                    touch $LOCK_FILE
                fi
                ;;
            *)
                remove_pid
                echo FAILED - check ${INIT_LOG_DIR}/startup_\{log, _err\}
                RETVAL=1
                ;;
        esac
    fi
}

stop_rabbitmq () {
    status_rabbitmq quiet
    if [ $RETVAL = 0 ] ; then
        set +e
        $CONTROL stop ${PID_FILE} > ${INIT_LOG_DIR}/shutdown_log 2> ${INIT_LOG_DIR}/shutdown_err
        RETVAL=$?
        set -e
        if [ $RETVAL = 0 ] ; then
            remove_pid
            if [ -n "$LOCK_FILE" ] ; then
                rm -f $LOCK_FILE
            fi
        else
            echo FAILED - check ${INIT_LOG_DIR}/shutdown_log, _err
        fi
    else
        echo RabbitMQ is not running
        RETVAL=0
    fi
}

status_rabbitmq() {
    set +e
    if [ "$1" != "quiet" ] ; then
        $CONTROL status 2>&1
    else
        $CONTROL status > /dev/null 2>&1
    fi
    if [ $? != 0 ] ; then
        RETVAL=3
    fi
    set -e
}

rotate_logs_rabbitmq() {
    set +e
    $CONTROL rotate_logs ${ROTATE_SUFFIX}
    if [ $? != 0 ] ; then
        RETVAL=1
    fi
    set -e
}

restart_running_rabbitmq () {
    status_rabbitmq quiet
    if [ $RETVAL = 0 ] ; then
        restart_rabbitmq
    else
        echo RabbitMQ is not runnning
        RETVAL=0
    fi
}

restart_rabbitmq() {
    stop_rabbitmq
    start_rabbitmq
}

case "$1" in
    start)
        echo -n "Starting $DESC: "
        start_rabbitmq
        echo "$NAME."
        ;;
    stop)
        echo -n "Stopping $DESC: "
        stop_rabbitmq
        echo "$NAME."
        ;;
    status)
        status_rabbitmq
        ;;
    rotate-logs)
        echo -n "Rotating log files for $DESC: "
        rotate_logs_rabbitmq
        ;;
    force-reload|reload|restart)
        echo -n "Restarting $DESC: "
        restart_rabbitmq
        echo "$NAME."
        ;;
    try-restart)
        echo -n "Restarting $DESC: "
        restart_running_rabbitmq
        echo "$NAME."
        ;;
    *)
        echo "Usage: $0 {start|stop|status|rotate-logs|restart|condrestart|try-restart|reload|force-reload}" >&2
        RETVAL=1
        ;;
esac

exit $RETVAL
```

