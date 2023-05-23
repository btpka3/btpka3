zincati 是Fedora CoreOS 主机自动更新的 agent。
它是 Cincinnati and rpm-ostree 的 客户端， 负责更新和重启机器。

Cincinnati 是一个自动更新的协议。

[coreos/zincati](https://coreos.github.io/zincati/)
[coreos /fedora-coreos-cincinnati](https://github.com/coreos/fedora-coreos-cincinnati)
[Cincinnati](https://github.com/openshift/cincinnati)

```shell
rpm-ostree status
systemctl status zincati.service

rpm-ostree status
```
