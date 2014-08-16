


|工具 |功能描述|
|---|---|
|uptime|系统平均负载率|
|dmesg|硬件/系统信息|
|top|进程进行状态|
|iostat|CPU和磁盘平均使用率|
|vmstat|系统运行状态|
|sar|实时收集系统使用状态|
|KDE System Guard|图形监控工具|
|free|内存使用率|
|traffic-vis|网络监控（只有SUSE有）|
|pmap|进程内存占用率|
|strace|追踪程序运行状态|
|ulimit|系统资源使用限制|
|mpstat|多处理器使用率|

##

```
yum install rrdtool

service snmpd status
yum install -y net-snmp net-snmp-utils net-snmp-devel

# 创建用户
net-snmp-config --create-snmpv3-user -a 123456 zll
adding the following line to /var/lib/net-snmp/snmpd.conf:
   createUser zll MD5 "123456" DES
adding the following line to /etc/snmp/snmpd.conf:
   rwuser zll

service snmpd start
# 本机测试
snmpwalk -v 1 -c public localhost

```

[cacti](http://www.cacti.net/)

[Nagios](http://www.nagios.com/products/nagiosxi/)

[zabbix](http://www.zabbix.org/wiki/Main_Page)


[网络IO监控iftop](http://www.ex-parrot.com/~pdw/iftop/)

[监控宝](http://www.vpser.net/manage/jiankongbao.html)