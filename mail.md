

```
yum install mailx                     # 提供 mail 命令
yum install postfix
postqueue -p                           # 查看队列
mailq                                       # 查看队列
postsuper -d $msgId              # 删除指定的msg

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