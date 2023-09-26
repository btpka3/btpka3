

# virtualbox
下载 [fedora](https://fedoraproject.org/)  qcow2 格式的文件，然后将其转换成vdi 格式

```shell
qemu-img convert -f qcow2 ~/Downloads/Fedora-Server-KVM-38-1.6.x86_64.qcow2 -O vdi ~/VirtualBox\ VMs/fedora2.vdi
```
然后 virtualbox 新建一个空的 linux 虚拟机，但不用分配硬盘，创建好后再直接使用上述 vdi 硬盘

第一次启动时，一定要注意 修改 root 密码并启动root 账号


# 静态IP地址

see fcos.md


# docker

```shell
systemctl status firewalld
systemctl stop firewalld
systemctl disable firewalld
setenforce 0
sed -i 's/enforcing/disabled/' /etc/selinux/config
swapoff -a
sed -ri 's/.*swap.*/#&/' /etc/fstab


yum install lvm2 python3 ntpdate -y
ntpdate ntp1.aliyun.com
```

https://docs.docker.com/engine/install/fedora/

```shell
sudo dnf remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-selinux \
                  docker-engine-selinux \
                  docker-engine

sudo dnf -y install dnf-plugins-core
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl status docker
sudo systemctl enable docker
sudo systemctl start docker

sudo docker run hello-world


cat > /etc/docker/daemon.json << EOF
{
  "registry-mirrors": ["https://b9pmyelo.mirror.aliyuncs.com"],
  "exec-opts": ["native.cgroupdriver=systemd"]
}
EOF
```


# k8s

see fcos.md






