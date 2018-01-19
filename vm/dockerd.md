
而 /etc/docker/daemon.json 的具体配置项需要参考 
[dockerd 17.06](https://docs.docker.com/engine/reference/commandline/dockerd/) 
[dockerd 17.03](https://docs.docker.com/v17.03/engine/reference/commandline/dockerd/)
命令：

版本早于 17.06-ce

```text
[Service]
ExecStart=
ExecStart=/usr/bin/docker daemon -H fd:// --graph="/mnt"
```
版本晚于 17.06-ce

```text
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd -H fd:// --data-root="/mnt"
```


# 使用 阿里云 的镜像进行加速

参考 [这里](https://cr.console.aliyun.com/#/accelerator)

```bash

# 17.06-ce 前的版本，需要配置 "graph":    "/data0/store/soft/docker", 
# docker 存储的默认目录是 /var/lib/docker

sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
"data-root": "/data0/store/soft/docker",
"storage-driver": "devicemapper",
"registry-mirrors": ["https://cbnwh58y.mirror.aliyuncs.com"]
}
EOF

sudo systemctl daemon-reload
sudo systemctl restart docker
docker run -it --rm alpine:3.5
```


## storage-driver

* `aufs` : 最老，基于对 Linux Kernel 的补丁，也不能合并到主kernel中。
也会引起一些严重的 kernel 崩溃。但是 aufs 允许 container 共享 executable and shared library memory。

* `devicemapper` : 则使用简单的监控，并通过 Copy on Write (CoW) 来执行。
* `btrfs` : 对于 `docker build` 而言会非常快，但和 `devicemapper` 一样，并不公用相同的 库的内存。
* `zfs` : 没有 `btrfs` 快，但是有更长的跟踪记录，以提供稳定性。通过 Single Copy ARC， 不同 clone 中相同的块只缓存一次。
* `overlay` : 一个非常快的 联合的文件系统，已经合并到了 Linux Kernel 3.18.0 中。
并支持 page cache sharing——即，多个container 如果访问相同的文件，则会共享同一个 page cache enty，
因此 该文件系统与 `aufs` 相比，也一样高效利用内存。

   但是因为该系统比较新，不应该使用到生产环境。特别是，它会过度消耗 iNode。
   
   不支持在 `btrfs` 或任何 Copy on Write 文件系统上
* `overlay2` : 通过 kernel 4.0 中的新特性避免了过度消耗 iNode。



# 7788

[Compatibility Matrix](https://success.docker.com/Policies/Compatibility_Matrix)


