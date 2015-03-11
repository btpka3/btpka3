
## 修改 kernel 参数

```
locate grub.cfg             # or grub.conf
vi /boot/efi/EFI/centos/grub.cfg


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
vi /etc/pam.d/login                                    # 确认已经启用 pam_limits.so
session required pam_limits.so

man limits.conf
ulimit -Ha                                                 # 检查所有硬限制（比如用户最大进程数、可打开的最大文件数）
ulimit -Sa                                                 # 检查所有软限制

ulimit -n 10240                                         # 临时生效，重启失效
vi /etc/security/limits.d/xxx.conf              # 如果值太小，则修改该文件，持久生效
*        -    nofile         65535    # redis:64000
*        -    nproc        40960    # redis:64000
```

说明：修改配置文件只能对新的session起作用。如果要想即时生效，可以通过 `ulimit -n 20000` 等开启，前提是 新的数值不能超过hard所设定的值。hard值一旦被设定，就不能够再增加。
 
 