

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