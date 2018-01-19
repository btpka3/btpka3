



```bash
yum install expect

```


```bash
#!/usr/bin/expect
set password xxxx               # 设置密码
set timeout 30                  # 设置超时时间

                                # 登录
spawn ssh xxxUser@pub-prod11.kingsilk.net -C -N -g -R localhost:16600:localhost:80 -o ExitOnForwardFailure=yes -o ServerAliveInterval=60
                                
expect "password"               # 期待密码提示，最多等待30秒（前面有设置）
send "$password\r"              # 发送密码
interact                        # 把控制权交给控制台
```
