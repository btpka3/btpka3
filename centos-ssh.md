
# 生成SSH KEY

```sh
ssh-keygen -t rsa -C "hi@test.me" -N 'xxxPass' -f ~/.ssh/id_rsa
```

# 加入信任的ssh 公钥

```sh
vi ~/.ssh/authorized_keys 
# 将 id_rsa.pub 中的内容追加进来

```



# ssh 登录慢

```sh
vi /etc/ssh/sshd_config
# 注释掉以下两行
#GSSAPIAuthentication yes
#GSSAPICleanupCredentials yes
```

