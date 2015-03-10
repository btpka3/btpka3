## 参考

* [Systemd - wikipedia](* http://zh.wikipedia.org/wiki/Systemd)
* [Chapter 6. Managing Services with systemd](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/System_Administrators_Guide/chap-Managing_Services_with_systemd.html)

```
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



## 文件格式 

```
man systemd.directives
man systemd.special

man system.unit

[Unit] / [Install]
Description=xxx
Documentation=空格分隔参考网址的URL
Requires=依赖的服务
RequiresOverridable=
Requisite=
RequisiteOverridable=
Wants=
BindsTo=
PartOf=
Conflicts=
Before=
After=
OnFailure=
PropagatesReloadTo=
ReloadPropagatedFrom=

man systemd.service
[Service]
Type=
PIDFile=
ExecStart=
ExecStop=
RestartSec=
Restart=
Sockets=


man systemd.exec
[Service], [Socket], [Mount], [Swap]
WorkingDirectory=
RootDirectory=
User=
Group=
Nice=
UMask=
Environment=

man systemd.resource-control
[Slice], [Scope], [Service], [Socket], [Mount], [Swap]
CPUAccounting=
MemoryAccounting=
Slice=

man systemd.slice
man systemd.scope
man systemd.socket
man systemd.mount
man systemd.swap

```