
[CoreOS Installer](https://coreos.github.io/coreos-installer/)

```shell
alias coreos-installer='podman run --pull=always --privileged --rm -v /dev:/dev -v /Users/zll/data0/store/soft/coreos-installer/data:/data -w /data quay.io/coreos/coreos-installer:release'

STREAM="stable"
coreos-installer download -s "${STREAM}" -p virtualbox -f ova
```
