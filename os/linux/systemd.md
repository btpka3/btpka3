## 参考

* [Systemd - wikipedia](* http://zh.wikipedia.org/wiki/Systemd)
* [Chapter 6. Managing Services with systemd](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/System_Administrators_Guide/chap-Managing_Services_with_systemd.html)

```
# 查看默认启动级别
systemctl get-default
systemctl set-default multi-user.target

# 修改默认启动级别为3
systemctl enable multi-user.target
# 该命令相当于
ln -s '/usr/lib/systemd/system/multi-user.target' '/etc/systemd/system/default.target'

# 若修改默认启动级别为5， 需要将之前的启动级别disable
systemctl disable multi-user.target
# 该命令相当于
rm '/etc/systemd/system/default.target'

# 再启用启动级别5
systemctl enable graphical.target
# 该命令相当于
ln -s '/usr/lib/systemd/system/graphical.target' '/etc/systemd/system/default.target'
```

## 常用命令

```
less /var/log/messages                          # 查看详细错误日志
journalctl                                      # 查看日志
systemctl --failed                              # 检查启动失败的服务
systemctl status network.service

systemctl enable name.service
systemctl disable name.service
systemctl reenable name.service
systemctl status name.service
systemctl is-active name.service
systemctl is-enabled name.service
systemctl list-unit-files --type service

systemctl mask name.service
systemctl unmask name.service

systemctl start name.service
systemctl stop name.service
systemctl restart name.service
systemctl try-restart name.service
systemctl reload name.service
```


## Available systemd Unit Types
|Unit Type      |File Extension     |Description|
|---------------|-------------------|-----------|
|Service unit   |.service           |A system service.|
|Target unit    |.target            |A group of systemd units.|
|Automount unit |.automount         |A file system automount point.|
|Device unit    |.device            |A device file recognized by the kernel.|
|Mount unit     |.mount             |A file system mount point.|
|Path unit      |.path              |A file or directory in a file system.|
|Scope unit     |.scope             |An externally created process.|
|Slice unit     |.slice             |A group of hierarchically organized units that manage system processes.|
|Snapshot unit  |.snapshot          |A saved state of the systemd manager.|
|Socket unit    |.socket            |An inter-process communication socket.|
|Swap unit      |.swap              |A swap device or a swap file.|
|Timer unit    |.timer             |A systemd timer. |

## Load path when running in system mode (--system)

|Path                    | Description                 |
|------------------------|-----------------------------|
|/etc/systemd/system     | Local configuration         |
|/run/systemd/system     | Runtime units               |
|/usr/lib/systemd/system | Units of installed packages |


##  Load path when running in user mode (--user)

|Path                       | Description                 |
|---------------------------|-----------------------------|
|$HOME/.config/systemd/user | User configuration          |
|/etc/systemd/user          | Local configuration         |
|/run/systemd/user          | Runtime units               |
|/usr/lib/systemd/user      | Units of installed packages |



## 参考

```bash
man systemctl
man systemd-system.conf
man systemd.directives
man systemd.special
man systemd.unit
man systemd.service
man systemd.exec
man systemd.slice
man systemd.scope
man systemd.socket
man systemd.mount
man systemd.swap
man systemd.resource-control

man journalctl
```


配置文件路径

```text
/etc/systemd/system/*
/run/systemd/system/*
/usr/lib/systemd/system/*
...

$XDG_CONFIG_HOME/systemd/user/*
$HOME/.config/systemd/user/*
/etc/systemd/user/*
$XDG_RUNTIME_DIR/systemd/user/*
/run/systemd/user/*
$XDG_DATA_HOME/systemd/user/*
$HOME/.local/share/systemd/user/*
/usr/lib/systemd/user/*
```

## 文件格式

```
[Unit]

Description=xxx
Documentation=空格分隔参考网址的URL
After=
Requires=
Wants=
Conflicts=

[Service]
Type=
ExecStart=
ExecStop=
ExecReload=
Restart=
RemainAfterExit

[Service], [Socket], [Mount], [Swap]
WorkingDirectory=
RootDirectory=
User=
Group=
Nice=
UMask=
Environment=

[Install]
Alias=
RequiredBy=
WantedBy=
Also=
DefaultInstance=
```

# @ 符号

参考 : [1](https://superuser.com/questions/393423/the-symbol-and-systemctl-and-vsftpd)


1. `vi /etc/systemd/system/echo@.service`

    ```
    [Unit]
    Description=Echo '%I'

    [Service]
    Type=oneshot
    ExecStart=/bin/echo %i
    StandardOutput=syslog
    ```

2. 运行1

    ```bash
    systemctl start echo@foo.service
    journalctl -n10    # 可以看到 echo 输出 "foo"
    ```

3. 运行1

    ```bash
    systemctl start echo@bar.service
    journalctl -n10    # 可以看到 echo 输出 "bar"
 
    man systemd.unit
    man systemd-system.conf
    ```

