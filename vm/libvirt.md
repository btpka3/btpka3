
# libvirt
- [libvirt](https://libvirt.org/macos.html)
  - [QEMU/KVM/HVF hypervisor driver](https://libvirt.org/drvqemu.html)
  - [VirtualBox hypervisor driver](https://libvirt.org/drvvbox.html)
- fedora coreos :
  - 《[Provisioning Fedora CoreOS on libvirt](https://docs.fedoraproject.org/en-US/fedora-coreos/provisioning-libvirt/)》
  - 《[Tutorials/Testing Fedora CoreOS updates](https://docs.fedoraproject.org/en-US/fedora-coreos/tutorial-updates/)》

```shell
brew install libvirt
```

# virt-manager
[virt-manager](https://ports.macports.org/port/virt-manager/)

```shell
brew install libvirt
brew install virt-manager

libvirtd
# 如果要开启启动（不建议在 MacOS 上开启），执行以下命令
brew services start libvirt

virt-install
virsh reboot xxxVmName
virsh start  xxxVmName
virsh -c lxc:///        list --all
virsh -c qemu:///system list --all

virt-manager
virt-viewer
virt-install

```
