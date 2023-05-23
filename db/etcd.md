## 简介

- [etcd](https://coreos.com/etcd/)是用于共享配置和服务发现的分布式，一致性的KV存储系统
  - [System limits](https://etcd.io/docs/v3.3/dev-guide/limit/) 默认单个请求最大 1.5MB ，可调。

## 参考

* [Consul vs. ZooKeeper, doozerd, etcd](https://www.consul.io/intro/vs/zookeeper.html)

## FIXME

* etcd vs. Eureka vs. Consul


# 安装

## macos

```shell
brew install etcd
# 第一个窗口
etcd

# 第二个窗口
etcdctl put greeting "Hello, etcd"
etcdctl get greeting
```



## alpine docker
not work

```shell
podman run --rm -it docker.io/alpine:latest sh
cat > /etc/apk/repositories <<EOF
https://dl-cdn.alpinelinux.org/alpine/v3.17/main
https://dl-cdn.alpinelinux.org/alpine/v3.17/community
https://dl-cdn.alpinelinux.org/alpine/edge/testing
EOF
apk add etcd
etcd
```
