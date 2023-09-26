
- https://ceph.com/en/
- https://docs.ceph.com/en/latest/start/intro/

- [FUSE : Filesystem in Userspace](https://www.kernel.org/doc/html/next/filesystems/fuse.html)
- [Ceph client libraries for Homebrew](https://github.com/mulbc/homebrew-ceph-client)
- kubernetes : storage volumes : [cephfs](https://kubernetes.io/zh-cn/docs/concepts/storage/volumes/#cephfs)
- [ceph/ceph-container](https://github.com/ceph/ceph-container/tree/main/examples/kubernetes)
- [Ceph集群搭建篇](https://developer.aliyun.com/article/1211852)

# docker - alpine

```shell
docker run --name my-ceph-server -it docker.io/library/alpine:3.18
docker exec -it my-ceph-server sh -l
```

# install - alpine
```shell
#apk add ceph16-common
#apk add ceph16-fuse

apk add ceph17-common
apk add ceph17-cephadm
apk add ceph17-fuse

# 可用命令
ceph
ceph-authtool 
ceph-conf
ceph-fuse
ceph-rbdnamer
cephadm
```


# install - macos

```shell
brew tap mulbc/ceph-client
brew install ceph-client
```

# CEPH STORAGE CLUSTER
EPH STORAGE CLUSTER 是所有 ceph 部署的基建，其包含以下几个后台服务:
- Ceph OSD Daemon (OSD)
- Ceph Monitor (MON)
- Ceph Manager


# install - server on fedora

```shell
hostnamectl set-hostname my-fedora
dnf install ceph

# 检查版本时，会下载 docker 镜像： quay.io/ceph/ceph:*
cephadm version

cephadm bootstrap --mon-ip 192.168.11.13
ceph -s
```
