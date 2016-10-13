

# mail

```
list        # 显示支持的命令列表
headers     # 显示当前邮件列表
delete      # 删除当前的邮件
d 1-10      # 删除第 1~10 封邮件
next        # 阅读下一封邮件 
n 10        # 阅读第10封邮件
```
# postfix

```
yum install mailx                     # 提供 mail 命令
yum install postfix
postqueue -p                           # 查看队列
mailq                                       # 查看队列
postsuper -d $msgId              # 删除指定的msg

echo "this is the body" | mail  -s "this is the subject" -r "from@test.me" "to@test.me"
# 除此之外，还需要确保sendmail或postfix等MTA是否配置正确。
```

# postfix 

## 禁用ipv6

```
vi /etc/postfix/main.cf
# inet_protocols = all
inet_protocols = ipv4
```

## 查看日志

```
talf /var/log/maillog
```