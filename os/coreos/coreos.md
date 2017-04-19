

# 参考
*  [coreos](https://coreos.com/)
* [virtualbox](https://coreos.com/os/docs/latest/booting-on-virtualbox.html)

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

# 使用 virtualbox 创建 64bit 的linux虚拟机，并使用刚刚创建的vdi虚拟硬盘，和iso文件
# 注意，网络模式设置为 桥接模式，以便能获取到与 宿主机同一个网络的IP地址。
# 启动后，ip地址会在虚拟机的登录窗口显示。

ssh core@192.168.0.138  # 使用 ssh key 登录  
```