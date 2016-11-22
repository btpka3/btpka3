## 参考

* [Linux启动：用Upstart代替传统init](http://www.linuxdiyf.com/viewarticle.php?id=48913)
* [systemd、upstart和system V](http://blog.csdn.net/kumu_linux/article/details/7653802)
* [Upstart - wikipedia](http://zh.wikipedia.org/wiki/Upstart)




|                  |System V Init | Upstart | Systemd |
|------------------|--------------|---------|---------|
|Ajax              |No            |Yes      |Yes      |
|Require On Demand |No            |Yes      |Yes      |
|Ubuntu            |*             |6.10+    |???      |
|RHEL/CentOS       |*             |6+       |7+       |
|Fedora            |*             |9+       |15+      |


man upstart
man starting
started
stopping
stopped
startup
man 7 runlevel
telinit
initctl
man 5 init
man 8 init
man 8 teinit
man 8 start
man 8 stop
man 3 fnmatch


inotify

man exec

/etc/init/
    *.conf       只读，无需可执行权限
    *.override


## 文件格式


### 流程定义

```
exec COMMAND [ ARG ]...
    要执行的命令，可以使用Shell变量

script ... end script
    定义一段以 sh(1) 执行的脚本。执行时会请用 `-e` 选项，
    因此，script中任何语句出差均会中止执行该脚本。

pre-start exec|script...
    这段脚本会在该job的starting(7)事件处理完之后、主进程开始之前执行。
    通常用于初始化——比如创建必要的目录。

post-start exec|script...
    这段脚本会在该job的主进程spawned后、发射started(7)事件前执行。
    通常用于向主进程发送必须的命令、或者延迟主进程——直至主进程可以接受client请求。

pre-stop exec|script...
    这段脚本会在 stop on 小节中配置的停止事件触发、或者由stop(8)命令停止时执行。
    会在stopping(7)事件发射前、在主进程被kill前执行。
    常用于向主进程发送必要的停止命令，也可以被没有参数的 start(8) 调用，以取消停止命令。

post-stop exec|script...
    这段脚本会在主进程被kill之后、stopped(7)事件发射前执行。
    常用于清理环境——比如删除临时目录。
```

### 事件定义

任务可以由管理员在任何时候通过start(8)、 stop(8)命令启停。
但其远不如由 init(8) 进程负责、在需要时才启动方便。

```
start on EVENT [[KEY=]VALUE]... [and|or...]
    定义触发任务自动启动的事件。多个事件可以使用 and、or 连接起来。

stop on EVENT [[KEY=]VALUE]... [and|or...]
    定义触发任务自动启动的事件。

```

### 任务环境
每个任务都运行在启动它的事件或命令所在的环境中。
UPSTART_EVENTS 环境变量包含了启动该任务的事件列表。如果任务被手动启动，该变量则不存在。
此外，pre-stop 和 post-stop 会在停止该任务的事件或命令所在的环境中运行。

```
env KEY=VLAUE
    定义环境变量

export KEY
    将环境变量暴露在该任务的 starting(7), started(7), stopping(7), stopped(7) 事件中。

```

### 服务、任务和respawning
默认任务（jobs）就是服务（services）。

```
task
    指明该任务是一个 task。

respawn
    指明该任务如果意外终止，则应当自动重新启动。

respawn limit COUNT INTERVAL
    如果因意外终止而多次以指定的间隔重新启动达到指定次数。则会停止而不再重新启动。

normal exit STATUS|SIGNAL
    额外指明某些状态码、事件也任务是正常的，而不必重新启动。

```

### 实例

### 文档

### 进程环境

### Override文件
### 杂项






## mysql.conf

```groovy
# MySQL Service

description     "MySQL Server"
author          "Mario Limonciello <superm1@ubuntu.com>"

start on runlevel [2345]
stop on starting rc RUNLEVEL=[016]

respawn
respawn limit 2 5

env HOME=/etc/mysql
umask 007

# The default of 5 seconds is too low for mysql which needs to flush buffers
kill timeout 300

pre-start script
    ## Fetch a particular option from mysql's invocation.
    # Usage: void mysqld_get_param option
    mysqld_get_param() {
      /usr/sbin/mysqld --print-defaults \
        | tr " " "\n" \
        | grep -- "--$1" \
        | tail -n 1 \
        | cut -d= -f2
    }

    # priority can be overriden and "-s" adds output to stderr
    ERR_LOGGER="logger -p daemon.err -t /etc/init/mysql.conf -i"

    #Sanity checks
    [ -r $HOME/my.cnf ]
    [ -d /var/run/mysqld ] || install -m 755 -o mysql -g root -d /var/run/mysqld
    /lib/init/apparmor-profile-load usr.sbin.mysqld

    # check for diskspace shortage
    datadir=`mysqld_get_param datadir`
    BLOCKSIZE=`LC_ALL=C df --portability $datadir/. | tail -n 1 | awk '{print $4}'`
    if [ $BLOCKSIZE -le 4096 ] ; then
      echo "$0: ERROR: The partition with $datadir is too full!" >&2
      echo "ERROR: The partition with $datadir is too full!" | $ERR_LOGGER
      exit 1
    fi
end script

exec /usr/sbin/mysqld

post-start script
   for i in `seq 1 30` ; do
        /usr/bin/mysqladmin --defaults-file="${HOME}"/debian.cnf ping && {
            exec "${HOME}"/debian-start
            # should not reach this line
            exit 2
        }
        statusnow=`status`
        if echo $statusnow | grep -q 'stop/' ; then
            exit 0
        elif echo $statusnow | grep -q 'respawn/' ; then
            exit 1
        fi
        sleep 1
    done
    exit 1
end script
```










