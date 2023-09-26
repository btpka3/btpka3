

```shell
echo | nc 30.196.226.251 22
echo | nc -U /path/to/xxx.sock

# 监听 6443 端口
nc -l 6443
# 连接 6443 端口
nc -zv 192.168.56.3 6443
```