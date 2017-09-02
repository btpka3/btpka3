

https://www.clamav.net/
https://www.avast.com
http://rkhunter.sourceforge.net/


## clamav

```bash
yum search clamav 

yum install clamav clamav-scanner clamav-update

# 更新病毒库
freshclam

man clamd.conf
vi /etc/clamd.conf

# 递归扫描指定的目录, 且只有出错时才提示
clamscan --quiet -r /boot/
```


### clamd.conf

```conf
LogFile         /var/log/clamd.log
```


## rkhunter
```bash
yum install rkhunter
 
# 安装完就就创建
rkhunter --propupd
ls /var/lib/rkhunter/db/rkhunter.dat

rkhunter -c
less /var/log/rkhunter/rkhunter.log

# 在线更新数据库
# 含有rootkit名字的数据库来检测系统的rootkits漏洞, 所以经常更新该数据库非常重要, 你可以通过下面命令来更新该数据库
rkhunter --update

# 版本更新
rkhunter --versioncheck

# 更新红色的
#http://rkhunter.cvs.sourceforge.net/viewvc/rkhunter/rkhunter/files/FAQ
```
