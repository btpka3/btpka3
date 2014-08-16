

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
```