
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


## 修改系统变量

 查看kernel参数

```sh
                                                                   # 每个进程可以打开的最大文件数
sysctl -A  | grep fs\.file-max                      # fs.file-max = 764817
sysctl fs.file-max
cat /proc/sys/fs/file-max

vi /etc/sysctl.conf                                      # 修改系统级的配置，持久生效
fs.file-max = 787933

sysctl -p                                                     # 重新加载配置文件，使其即时生效
```

查看指定进程正在使用的文件数量

```sh
ls -la /proc/<pid>/fd
lsof -p <pid of process>
lsof -p <pid> | wc -l
ulimit -n
```

查看指定用户开启的总进程数

```sh
ps auxwwf | grep $USER_NAME | grep -v grep | wc -l
```

### 修改用户限制

```sh
vi /etc/pam.d/login                 # 确认已经启用 pam_limits.so
session required pam_limits.so

man limits.conf

ulimit -Ha                          # 检查所有硬限制（比如用户最大进程数、可打开的最大文件数）
ulimit -Sa                          # 检查所有软限制

ulimit -n 10240                     # 临时生效，重启失效
vi /etc/security/limits.d/xxx.conf  # 如果值太小，则修改该文件，持久生效
*        -    nofile         65535  # redis:64000
*        -    nproc        40960    # redis:64000
```

说明：修改配置文件只能对新的session起作用。如果要想即时生效，可以通过 `ulimit -n 20000` 等开启，前提是 新的数值不能超过hard所设定的值。hard值一旦被设定，就不能够再增加。
 
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


sytstem 示例

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




