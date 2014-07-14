
# 时间相关命令

```sh
[root@localhost ~]# date           # 查看系统时间
[root@localhost ~]# date -R        # 查看当前时区
[root@localhost ~]# date 020304052001        # 设置系统时间为：2001年2月3日4点5分

[root@localhost ~]# hwclock        # 查看BIOS时间
[root@localhost ~]# hwclock -w     # 将系统时间同步到BIOS时间，防止重启失效
[root@localhost ~]# tzselect       # 设置当前时区

# 设置当前时区
[root@localhost ~]# cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
[root@localhost ~]# cat /etc/sysconfig/clock


```

# 安装NTP

```sh
[root@localhost ~]# yum install ntp
[root@localhost ~]# chkconfig --level 345 ntpd on
[root@localhost ~]# chkconfig --list ntpd
[root@localhost ~]# vi /etc/ntp.conf
logfile /var/log/ntp.log

[root@localhost ~]# vi /etc/sysconfig/ntpd
OPTIONS="-u ntp:ntp -p /var/run/ntpd.pid -g"
SYNC_HWCLOCK=yes


[root@localhost ~]# ntpdate server 0.asia.pool.ntp.org

# 启动ntp服务
[root@localhost ~]# service ntpd start

# 查看NTP运行状态
[root@localhost ~]# ntpstat

[root@localhost ~]# ntpstat -unlnp		# 应该能看到ntpd使用了123端口
[root@localhost ~]# ntpq -p                     # 列出所有与上级ntp服务器的联系
remote           上级ntp服务器的主机名
refid            上级ntp服务器的IP地址
st               startnum阶层
t				
when             多少时间前曾同步过
poll             同步间隔
reach            已经向上级ntp服务器要求更新的次数
delay            网络延迟
offset           时间补偿
jitter           系统时间与BIOS时间之差

[root@localhost ~]# ntpdate -d			# 查看出错原因
```

启停命令

```sh
[root@localhost ~]# service ntpd
Usage: /etc/init.d/ntpd {start|stop|status|restart|try-restart|force-reload}
```