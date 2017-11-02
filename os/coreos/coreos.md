# 参考
* [coreos](https://coreos.com/os/docs/latest/)
* [virtualbox](https://coreos.com/os/docs/latest/booting-on-virtualbox.html)
* [Installing CoreOS Container Linux to disk](https://coreos.com/os/docs/latest/installing-to-disk.html)
* [CoreOS With Nvidia CUDA GPU Drivers](http://tleyden.github.io/blog/2014/11/04/coreos-with-nvidia-cuda-gpu-drivers/)

# 安装
## 作为 VirtualBox 虚拟机安装

```bash
brew install gpg
brew install cdrtools

wget https://raw.githubusercontent.com/coreos/scripts/master/contrib/create-coreos-vdi
chmod +x create-coreos-vdi

./create-coreos-vdi -V stable


wget https://raw.github.com/coreos/scripts/master/contrib/create-basic-configdrive
chmod +x create-basic-configdrive

# 当前目录生成 my_vm01.iso，用以配置ssh key
./create-basic-configdrive -H my_vm01 -S ~/.ssh/id_rsa.pub



VBoxManage clonehd coreos_production_1298.7.0.vdi my_vm01.vdi
VBoxManage modifyhd my_vm01.vdi --resize 10240

# 使用 virtualbox 创建 64bit 的linux虚拟机，
# - 使用刚刚创建的vdi虚拟硬盘，
# - 启动时，挂载刚刚创建的 my_vm01.iso 文件（有了该 ISO 会使用我的SSH key 登录）
# - 网络模式设置为 桥接模式，以便能获取到与 宿主机同一个网络的IP地址。
#   启动后，ip地址会在虚拟机的登录窗口显示。

# 使用 ssh key 登录
ssh core@192.168.0.138 

# 在 虚拟机内测试使用 docker
docker run -it --rm alpine:3.5 ip addr
  
```

## 安装到物理机上

1. 先运行 任何一种 Linux 的 LiveCD
1. 运行 [coreos-install 脚本](https://raw.githubusercontent.com/coreos/init/master/bin/coreos-install)
  
## FIXME

- 硬件驱动如何解决？比如显卡，网卡等?

    需要下载 coreos 源码，驱动的源码，给 kernel 打补丁，验证、编译生成新的 coreos 镜像。
