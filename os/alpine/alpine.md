[apline linux](https://www.alpinelinux.org/) 使用
的是 [OpenRC](https://docs.alpinelinux.org/user-handbook/0.1a/Working/openrc.html)
作为 init service。

[Repositories](https://wiki.alpinelinux.org/wiki/Repositories)

# 支持 alpine 的包

可自行到 [这里](https://pkgs.alpinelinux.org/packages) 搜索。

arm64已经与aarch64合并，因为aarch64和arm64指的是同一件事。

- busybox
- podman


- jdk : aliababa
  dragonwell : [alibabadragonwell/dragonwell:dragonwell-17.0.3.0.3.7_jdk-17.0.3-ga-alpine](https://hub.docker.com/layers/alibabadragonwell/dragonwell/dragonwell-17.0.3.0.3.7_jdk-17.0.3-ga-alpine/images/sha256-80c216958a8589e59bd769e8ed45b0268577bdb4896ca2c28e1a21f1e4438174?context=explore)

| package           | x86_64 | aarch64 |
|-------------------|--------|---------|
| busybox           | Y      | Y       |
| podman            | Y      | Y       |
| nginx             | Y      | Y       |
| redis             | Y      | Y       |
| tengine           | -      | -       |
| dragonwell        | -      | -       |
| GraalVM           |        |         |
| mysql             | Y      | Y       |
| mariadb           | Y      | Y       |
| postgresql        | -      | -       |
| mongodb           | -      | -       |
| cloud-init        | Y      | Y       |
| podman            | Y      | Y       |
| aliyun/aliyun-cli | -      | -       |
| ceph-dev          | Y      | Y       |
| s3fs-fuse         | Y      | Y       |

# alpine/busybox

```bash
# 检查 alpine 版本
cat /etc/os-release
cat /etc/issue
cat /etc/alpine-release

# 检查 kernel 版本
uname -r
cat /proc/version

# docker run -it --rm --network=customBridge alpine:3.5
# 参考： https://serverfault.com/questions/104125/busybox-how-to-list-process-priority
ps -o pid,ppid,pgid,nice,user,group,tty,vsz,etime,time,comm,args

# 判断bash 是否存在，如不不存在则安装
command -v bash >/dev/null || apk add --no-cache bash



apk add --no-cache shadow # 提供 usermod 命令
apk add --no-cache openrc # 提供 rc-update 命令


# 参考： https://wiki.alpinelinux.org/wiki/Alpine_Linux_package_management#Overview
apk update          # 更新索引到本地
apk search -v xxx   # 搜索指定的 package
apk add xxx         # 下载并安装指定的 package
apk del xxx         # 卸载指定的 package
apk info            # 列出所有已经安装的 package
apk info xxx        # 查看指定 package 的信息
apk info -L xxx     # 查看指定 package 的所有的文件列表
apk info installkernel
apk -v cache clean  # 清楚缓存
apk info --who-owns /etc/ssh/sshd_config
apk info --who-owns /lib/modules/4.14.69-0-vanilla//kernel/net/netfilter/nft_nat.ko


# 常用工具
apk add --no-cache drill       # 替代 nslookup/dig
drill kingsilk.net @223.5.5.5
drill kingsilk.net @127.0.0.11
drill kingsilk.net @8.8.8.8

# 仓库：
cat > /etc/apk/repositories <<EOF
https://dl-cdn.alpinelinux.org/alpine/v3.17/main
https://dl-cdn.alpinelinux.org/alpine/v3.17/community
https://dl-cdn.alpinelinux.org/alpine/edge/testing
EOF


# 启动服务
apk add openrc
touch /run/openrc/softlevel
rc-service --list
rc-status --list
rc-status --servicelist

rc-update add etcd
rc-service etcd status

rc-service hostname start
rc-service networking start
rc-service etcd start
rc-service etcd stop

```

## 参考

- [Building a modified kernel for Alpine Linux](https://strfry.org/blog/building-alpine-kernel.html)
