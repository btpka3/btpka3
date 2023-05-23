- [podman](https://podman.io/getting-started/)
- [podman desktop](https://podman-desktop.io/)
- [podman-compose](https://github.com/containers/podman-compose)
- [quay.io](https://quay.io/search)

# install

```bash
#macos
brew install podman
brew install podman-desktop
brew install podman-compose
#brew install podman-machine

# 注意：初始化maichine的时候，都要设置一下数据卷
# 因为 当宿主机是 MacOS 时，docker 命令的相关数据卷挂在 在其完全虚拟机 Fedora CoreOS 中执行的，而不是在 MacOS 上执行的。
podman machine init -v $HOME:$HOME --now --cpus=2 --memory=2048
podman machine start
podman info

podman machine ssh podman-machine-default

podman run --rm -it alpine:latest sh


ll /tmp/podman.sock
/run/user/502/podman/podman.sock
```

# podman VS. docker

因为使用Docker Daemon运行Docker有以下这些问题：

- 单点故障问题，Docker Daemon一旦死亡，所有容器都将死亡
- Docker Daemon拥有运行中的容器的所有子进程
- 所有Docker操作都必须由具有跟root相同权限的用户执行
- 构建容器时可能会导致安全漏洞

FIXME: Docker最近在其守护进程配置中添加了 [Rootless](https://docs.docker.com/engine/security/rootless/) 模式 , then ?

命令行

| dcoker         | podman         |
|----------------|----------------|
| docker         | podman         |
| docker-compose | podman-compose |
| docker-machine | podman-machine |
