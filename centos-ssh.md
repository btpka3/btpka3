


ssh 登录慢

```sh
vi /etc/ssh/sshd_config
# 注释掉以下两行
#GSSAPIAuthentication yes
#GSSAPICleanupCredentials yes
```

