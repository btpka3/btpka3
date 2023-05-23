- [qemu](https://www.qemu.org/)

```shell
brew install qemu

# 创建 500MB 大小， qcow 格式的影片镜像
qemu-img create -f qcow c.img 500M

qemu -clock dynticks -rtc-td-hack -localtime -hda c.img -cdrom linux.iso -boot d -m 128 -enable-audio -localtime

qemu-system-*
qemu-system-x86_64
qemu-system-arm
```


- Fedora CoreOS
    - [Provisioning Fedora CoreOS on QEMU](https://docs.fedoraproject.org/en-US/fedora-coreos/provisioning-qemu/)


```shell
STREAM="stable"
coreos-installer download -s "${STREAM}" -p qemu -f qcow2.xz --decompress

IGNITION_CONFIG="/Users/zll/data0/work/git-repo/github/btpka3/btpka3/os/coreos/remote.ign"
IMAGE="/Users/zll/data0/store/soft/coreos-installer/data/fedora-coreos-38.20230430.3.1-qemu.x86_64.qcow2"
# for x86/aarch64:
IGNITION_DEVICE_ARG="-fw_cfg name=opt/com.coreos/config,file=${IGNITION_CONFIG}"
# for s390x/ppc64le:
IGNITION_DEVICE_ARG="-drive file=${IGNITION_CONFIG},if=none,format=raw,readonly=on,id=ignition -device virtio-blk,serial=ignition,drive=ignition"


# 临时存储 (FIXME ： why not work ? -fw_cfg  invalid option )
qemu-system-x86_64 -accel hvf -m 2048 -cpu host -nographic -snapshot \
  -drive if=virtio,file=${IMAGE} ${IGNITION_DEVICE_ARG} \
  -nic user,model=virtio,hostfwd=tcp::2222-:22



# podman 对应的 完整命令
qemu-system-x86_64 -m 2048 -smp 1 \
  -fw_cfg name=opt/com.coreos/config,file=/Users/zll/.config/containers/podman/machine/qemu/podman-machine-default.ign \
  -qmp unix:/var/folders/hn/bj86pn8n6p71ltp2h0wbpv640000gp/T/podman/qmp_podman-machine-default.sock,server=on,wait=off \
  -netdev socket,id=vlan,fd=3 \
  -device virtio-net-pci,netdev=vlan,mac=5a:94:ef:e4:0c:ee \
  -device virtio-serial \
  -chardev socket,path=/var/folders/hn/bj86pn8n6p71ltp2h0wbpv640000gp/T/podman/podman-machine-default_ready.sock,server=on,wait=off,id=apodman-machine-default_ready \
  -device virtserialport,chardev=apodman-machine-default_ready,name=org.fedoraproject.port.0 \
  -pidfile /var/folders/hn/bj86pn8n6p71ltp2h0wbpv640000gp/T/podman/podman-machine-default_vm.pid \
  -machine q35,accel=hvf:tcg \
  -cpu host \
  -virtfs local,path=/Users,mount_tag=vol0,security_model=none \
  -virtfs local,path=/private,mount_tag=vol1,security_model=none \
  -virtfs local,path=/var/folders,mount_tag=vol2,security_model=none \
  -drive if=virtio,file=/Users/zll/.local/share/containers/podman/machine/qemu/podman-machine-default_fedora-coreos-38.20230430.2.1-qemu.x86_64.qcow2 \
  -display none




# 持久存储
qemu-img create -f qcow2 -F qcow2 -b ${IMAGE} my-fcos-vm.qcow2
qemu-kvm -m 2048 -cpu host -nographic \
  -drive if=virtio,file=my-fcos-vm.qcow2 ${IGNITION_DEVICE_ARG} \
  -nic user,model=virtio,hostfwd=tcp::2222-:22

# 浏览

ssh -p 2222 core@localhost
```

# network
```shell
qemu-system-x86_64 -netdev user,id=mynet0,net=192.168.76.0/24,dhcpstart=192.168.76.9 -accel hvf
```
