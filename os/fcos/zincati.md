zincati 是Fedora CoreOS 主机自动更新的 agent。
它是 Cincinnati and rpm-ostree 的 客户端， 负责更新和重启机器。

Cincinnati 是一个自动更新的协议。

[coreos/zincati](https://coreos.github.io/zincati/)
[coreos /fedora-coreos-cincinnati](https://github.com/coreos/fedora-coreos-cincinnati)
[Cincinnati](https://github.com/openshift/cincinnati)
[configuration](https://github.com/coreos/zincati/blob/main/docs/usage/configuration.md)


```shell
rpm-ostree status
systemctl status zincati.service

rpm-ostree status
```


# 配置文件

```shell
# 配置文件位于以下目录
/usr/lib/zincati/config.d/
/etc/zincati/config.d/
/run/zincati/config.d/
```