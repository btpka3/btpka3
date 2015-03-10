## 参考

* [Systemd - wikipedia](* http://zh.wikipedia.org/wiki/Systemd)

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