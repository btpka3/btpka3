# ostree
[ostree](https://ostreedev.github.io/ostree/introduction/)



# rpm-ostree

- [Adding OS extensions to the host system](https://docs.fedoraproject.org/en-US/fedora-coreos/os-extensions/)
- [rpm-ostree](https://coreos.github.io/rpm-ostree/)
- [aliyun mirror](https://developer.aliyun.com/mirror/)
- https://packages.fedoraproject.org/

```shell
sudo rpm-ostree status
sudo rpm-ostree upgrade
sudo rpm-ostree rollback
sudo rpm-ostree deploy <version>

sudo rpm-ostree install <pkg>
sudo rpm-ostree install -yA <pkg>
rpm-ostree db diff

sudo rpm-ostree uninstall <pkg>
sudo rpm-ostree rollback --reboot

ll /etc/yum.repos.d
```

# coreos/coreos-assembler
[coreos/coreos-assembler](https://coreos.github.io/coreos-assembler/)

```shell
podman pull quay.io/coreos-assembler/coreos-assembler
mkdir -p /Users/zll/data0/store/fcos
cd /Users/zll/data0/store/fcos
vi cosa.sh    # see https://coreos.github.io/coreos-assembler/building-fcos/
. ./cosa.sh

```
