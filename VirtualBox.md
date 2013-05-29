## 网络连接
1.  网络地址转换（NAT）

    Guest系统访问网络资源均通过Host系统，只能单向访问。Host系统及其他外部系统均无法访问Guest系统。

2.  桥接网卡（Bridged Adapter） - 最常用

    可独立分配一个IP地址，局域网内所有主机均可与其互通。

3.  内部网络（Internal）

    Guest系统之间可以相互访问，但与外部隔绝。

4.  仅主机（Host Only）适配器

    ??? 前面几种功能在这里若合理配置均可实现。

## 共享本地硬盘
这里以Host系统为Windows，Guest系统为CentOS为例进行讲解：

1.  用虚拟光驱加载 VirtualBox 根目录下的 `VBoxGuestAdditions.iso`
2.  启动Guest系统，`设备` 菜单 -> 分配光驱 -> 选择第一步加载的虚拟光驱
3.  在Guest系统（CentOS）中加载cdrom，
    ```sh
[root@h01 ~]# mount /dev/cdrom /media/cdrom
mount: block device /dev/sr0 is write-protected, mounting read-only
[root@h01 ~]# cd /media/cdrom
[root@h01 ~]# ./VBoxLinuxAdditions.run
...  # NOTICE : 如果你没有安装CentOS的桌面系统，会提示 Installing the Window System drivers  [FAILED] 请无视。
    ```
4.  重启系统
    ```sh
[root@h01 ~]# init 6
    ```
5.  Guest系统运行窗口： `设备` 菜单 -> 共享文件夹 -> 点击`添加共享文件夹`图标 -> 设置`共享文件夹路径`（比如：`F:/`）
-> 设置`共享文件名称`（比如: `F`） -> 选中`固定分配` -> 确定
6.  在Guest系统中运行以下命令加载
    ```sh
[root@h01 ~]# mount -t vboxsf F /mnt/f    # 其中`F`是前一步设置的`共享文件名称`，`/mnt/f` 是挂在目录，若不存在请自行创建
mount: block device /dev/sr0 is write-protected, mounting read-only
[root@h01 ~]# cd /mnt/f
...
    ```
