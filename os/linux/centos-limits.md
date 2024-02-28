
## 修改 kernel 参数

```
# locate grub.cfg             # or grub.conf
# vi /boot/efi/EFI/centos/grub.cfg

ll /etc/rc.local
chmod +x /etc/rc.d/rc.local
vi /etc/rc.local                  # 追加以下两行内容
echo never > /sys/kernel/mm/transparent_hugepage/enabled
echo never > /sys/kernel/mm/transparent_hugepage/defrag
```

# ps

```bash
/home/staragent/plugins/AOL.src/AOL.cur/scripts/salt-call
ps -o pid,comm,ruid,ruser,euid,euser,fuid,fuser,ouid,ppid -p $$
ps -o user= -o comm= -o pid= -p $$

pstree -aup $$
pstree -puh $$
```


## 修改系统变量

 查看kernel参数

```bash
                                                                   # 每个进程可以打开的最大文件数
sysctl -A  | grep fs\.file-max                      # fs.file-max = 764817
sysctl fs.file-max
cat /proc/sys/fs/file-max

vi /etc/sysctl.conf                                      # 修改系统级的配置，持久生效
fs.file-max = 787933

sysctl -p                                                     # 重新加载配置文件，使其即时生效


#  高并发web连接
net.ipv4.tcp_max_syn_backlog = 100000
net.core.somaxconn = 65535
net.ipv4.tcp_syncookies = 0


# 查看给定的进程的 ulimit 限制
JAVA_PID=$(ps aux|grep java | grep org.apache.catalina.startup.Bootstrap|awk '{print $2}')
echo $JAVA_PID
prlimit -p ${JAVA_PID} -n      # 方式一
cat /proc/${JAVA_PID}/limits   # 方式二
prlimit --pid ${JAVA_PID} --nofile

# 检查给定的进程的 使用的 open file 的数量
ls -1 /proc/${JAVA_PID}/fd | wc -l
lsof -p ${JAVA_PID} | wc -l

# 修改
sudo prlimit --pid ${JAVA_PID} --nofile=655351:655352   #  修改 soft/hard

# 查看指定用户开启的总进程数
ps auxwwf | grep $USER_NAME | grep -v grep | wc -l
```



### upper limit on inotify watches reached

```bash
sudo sysctl fs.inotify.max_user_watches
sudo sysctl fs.inotify.max_user_watches=8192000

sudo vi /etc/sysctl.conf
fs.inotify.max_user_watches=8192000


sudo sysctl fs.file-max
sudo sysctl -w fs.file-max=6000001
sysctl -p

```





### 修改用户限制

Pluggable Authentication Modules (PAM)
https://www.tecmint.com/increase-set-open-file-limits-in-linux/

```bash

man prlimit
prlimit -p $$ -n
ulimit
sudo bash -c "ulimit -n"
ls -l /usr/lib64/security/*.so

vi /etc/pam.d/login                 # 确认已经启用 pam_limits.so
session required pam_limits.so

man limits.conf

ulimit -n                           # 等同于 `ulimit -Sn` 只显示 SOFT 的值
ulimit -Ha                          # 检查所有硬限制（比如用户最大进程数、可打开的最大文件数）
ulimit -Sa                          # 检查所有软限制

ulimit -n 10240                     # 临时生效，重启失效
vi /etc/security/limits.conf
vi /etc/security/limits.d/xxx.conf  # 如果值太小，则修改该文件，持久生效
*        -    nofile         65535  # redis:64000
*        -    nproc        40960    # redis:64000



```





说明：修改配置文件只能对新的session起作用。如果要想即时生效，可以通过 `ulimit -n 20000` 等开启，前提是 新的数值不能超过hard所设定的值。hard值一旦被设定，就不能够再增加。




sudo

```bash
sudo bash -c "whoami ; ulimit -n"
# root
# 65535

sudo su admin -c "whoami ; ulimit -n"
# admin
# 655350


sudo bash -c "
                   echo whoami=\$(whoami)   ID=\$$   UID=\$UID   PPID=\$PPID   ulimit-n=\$(ulimit -n);   ps -o user= -o comm= -p \$PPID;   pstree -aup \$$ ;
    (su admin -c \"echo whoami=\\\$(whoami) ID=\\\$$ UID=\\\$UID PPID=\\\$PPID ulimit-n=\\\$(ulimit -n); ps -o user= -o comm= -p \\\$PPID; pstree -aup \\\$$ \")
# "


# whoami=root ID=187611 UID=0 PPID=187610 ulimit-n=65535
#    PID TTY          TIME CMD
# 187610 pts/0    00:00:00 sudo
# bash(140439,admin)───sudo(187610,root)───bash(187611)───pstree(187616)
# whoami=admin ID=187618 UID=2228 PPID=187617 ulimit-n=655350
#    PID TTY          TIME CMD
# 187617 pts/0    00:00:00 su
# bash(187618,admin)───pstree(187623)


sudo bash -c "
        echo whoami=\$(whoami)   ID=\$$   UID=\$UID   PPID=\$PPID   ulimit-n=\$(ulimit -n);
        sudo prlimit -n -o HARD,SOFT -p \$$ ;
        sudo prlimit -n -o HARD,SOFT -p \$PPID ;
        ps -o pid,comm,ruid,ruser,euid,euser,fuid,fuser,ouid,ppid -p \$$ ;
        ps -o pid,comm,ruid,ruser,euid,euser,fuid,fuser,ouid,ppid -p \$PPID ;
        pstree -aup \$$ ;
        echo =============== ;
    (su admin -c \"
        echo whoami=\\\$(whoami)   ID=\\\$$   UID=\\\$UID   PPID=\\\$PPID   ulimit-n=\\\$(ulimit -n);
        sudo prlimit -n -o HARD,SOFT -p \\\$$ ;
        sudo prlimit -n -o HARD,SOFT -p \\\$PPID ;
        pstree -aup \\\$PPID ;
        ps -o pid,comm,ruid,ruser,euid,euser,fuid,fuser,ouid,ppid -p \\\$$ ;
        ps -o pid,comm,ruid,ruser,euid,euser,fuid,fuser,ouid,ppid -p \\\$PPID ;
        pstree -aup \\\$$ ;
    \")
# "


sudo bash -c "
        echo whoami=\$(whoami)   ID=\$$   UID=\$UID   PPID=\$PPID   ulimit-n=\$(ulimit -n);
    su - admin -c \"
        echo whoami=\\\$(whoami)   ID=\\\$$   UID=\\\$UID   PPID=\\\$PPID   ulimit-n=\\\$(ulimit -n);
    \"
# "



```



## ulimit 与 systemd 的配置映射表


|ulimit |setrlimit          |systemd            |description
|-------|-------------------|-------------------|-----------
|-b     |                   |                   |The maximum socket buffer size
|-c     |RLIMIT_CORE        |LimitCORE          |The maximum size of core files created
|-d     |RLIMIT_DATA        |LimitDATA          |The maximum size of a process's data segment
|-e     |RLIMIT_NICE        |LimitNICE          |The maximum scheduling priority ("nice")
|-f     |RLIMIT_FSIZE       |LimitFSIZE         |The maximum size of files written by the shell and its children
|-i     |RLIMIT_SIGPENDING  |LimitSIGPENDING    |The maximum number of pending signals
|-l     |RLIMIT_MEMLOCK     |LimitMEMLOCK       |The maximum size that may be locked into memory
|-m     |RLIMIT_RSS         |LimitRSS           |The maximum resident set size (many systems do not honor this limit)
|-n     |RLIMIT_NOFILE      |LimitNOFILE        |The maximum number of open file descriptors (most systems do not allow this value to be set)
|-p     |                   |                   |The pipe size in 512-byte blocks (this may not be set)
|-q     |RLIMIT_MSGQUEUE    |LimitMSGQUEUE      |The maximum number of bytes in POSIX message queues
|-r     |RLIMIT_RTPRIO      |LimitRTPRIO        |The maximum real-time scheduling priority
|       |RLIMIT_RTTIME      |LimitRTTIME
|-s     |RLIMIT_STACK       |LimitSTACK         |The maximum stack size
|-t     |RLIMIT_CPU         |LimitCPU           |The maximum amount of cpu time in seconds
|-u     |RLIMIT_NPROC       |LimitNPROC         |The maximum number of processes available to a single user
|-v     |RLIMIT_AS          |LimitAS            |The maximum  amount of virtual memory available to the shell and, on some systems, to its children
|-x     |RLIMIT_LOCKS       |LimitLOCKS         |The maximum number of file locks
|-T     |                   |                   |The maximum number of threads


`/etc/systemd/system.conf`  里是 systemd 的全局默认配置


systemd 示例

```
[Unit]
Description=MongoDB Server
After=network.target

[Service]
User=mongod
Group=mongod
Type=forking

PIDFile=/data0/mongod/mongod.pid
ExecStartPre=
ExecStart=/usr/bin/mongod -f /etc/mongod.conf
ExecReload=/bin/kill -s HUP $MAINPID
ExecStop=/bin/kill -s QUIT $MAINPID
WorkingDirectory=/data0/mongod
Restart=always

LimitFSIZE=infinity
LimitCPU=infinity
LimitAS=infinity
LimitNOFILE=64000
LimitRSS=infinity
LimitNPROC=64000

PrivateTmp=true

[Install]
WantedBy=multi-user.target
```


## 修改信号量设置

see [Setting Semaphore Parameters](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/5/html/Tuning_and_Optimizing_Red_Hat_Enterprise_Linux_for_Oracle_9i_and_10g_Databases/sect-Oracle_9i_and_10g_Tuning_Guide-Setting_Semaphores-Setting_Semaphore_Parameters.html)


```bash
# 检查当前值
cat /proc/sys/kernel/sem
250	32000	32	128

# 检查当前值
ipcs -ls

# 查看 cookie
ipcs


# （临时）修改信号量
echo 250 32000 100 128 > /proc/sys/kernel/sem
sysctl -w kernel.sem="250 32000 100 128"

# （持久）修改信号量
echo "kernel.sem=250 32000 100 128" >> /etc/sysctl.conf
```



