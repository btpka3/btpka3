

# alpine/busybox

```bash
# docker run -it --rm --network=customBridge alpine:3.5
# 参考： https://serverfault.com/questions/104125/busybox-how-to-list-process-priority
ps -o pid,ppid,pgid,nice,user,group,tty,vsz,etime,time,comm,args

# 判断bash 是否存在，如不不存在则安装
command -v bash >/dev/null || apk add --no-cache bash



apk add --no-cache shadow # 提供 usermod 命令


# 参考： https://wiki.alpinelinux.org/wiki/Alpine_Linux_package_management#Overview
apk update          # 更新索引到本地
apk search -v xxx   # 搜索指定的 package
apk add xxx         # 下载并安装指定的 package
apk del xxx         # 卸载指定的 package
apk info            # 列出所有已经安装的 package
apk info xxx        # 查看指定 package 的信息
apk -v cache clean  # 清楚缓存


# 常用工具
apk add --no-cache drill       # 替代 nslookup/dig
drill kingsilk.net @223.5.5.5
drill kingsilk.net @127.0.0.11
drill kingsilk.net @8.8.8.8
```
