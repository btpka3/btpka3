# samba

## Win7

匿名共享

1. 同步工作组

    ```
    aaa
    ```

1. 开启 Guest 账户，并留空 Guest 密码。
   
    ```
    "我的电脑" 右键 -> 管理 -> 计算机管理（本地）-> 系统工具 -> 本地用户和组 -> 用户 -> 双击 Guest 账户： 右键 属性， 取消 "账户已禁用"
    ```

1. 修改组策略 `Win+R` 运行 `gpedit.msc` 
  
    ```
    \本地计算机\计算机配置\windows 设置\安全设置\本地策略
        \用户权限分配 : 拒绝从网络上访问这台计算机 : 删除其中的 guest 账户
        \安全选项
    ``` 


## centos

###  安装

NetBIOS Message Block (NMB )
可以通过主机名代替IP地址来访问局域网里的主机。

1. 安装samba

    ```sh
    rpm -qa | grep samba   # 确认samba是否已经安装
    yum list samba            #  查看可安装的samba版本
    yum install samba        #  安装
    ```

1. 设置默认运行级别

    ```sh
    chkconfig --list smb                     # 查看smb默认运行级别
    chkconfig --list nmb                     # 查看nmb默认运行级别
    chkconfig --level 345 smb on       # 设置smb默认运行级别 
    chkconfig --level 345 nmb on       # 设置smb默认运行级别
    ```

1. （可选）设置防火墙

    如果开启了防火墙的情况下，需要开启TCP 139、445端口; UDP 137、138端口。

1.  （可选）设置SELinux

    如果开启了SELinux，则需要为每个共享目录执行以下命令。

    ```sh
    [root@localhost ~]# chcon -R -t samba_share_t /path/to/shared/folder
    ```
    或者禁用SELinux

    ```sh
    [root@localhost ~]# setenforce 0                    # 临时禁用SELinux，重启后失效
    [root@localhost ~]# vi /etc/selinux/config        # 永久禁用SELinux
      SELINUX=disabled
    ```

# 认证访问

1. 添加使用samba的账户

    ```sh
    # xxxUserName用户仅仅用来远程samba登录，不需要本地登录。
    [root@localhost ~]# adduser -M xxxUserName  
    # 为xxxUserName用户设置samba登录时的密码（注意：该密码不同于账户本地登录操作系统的密码）
    # samba默认的密码文件是 /var/lib/samba/private/passdb.tdb
    [root@localhost ~]# smbpasswd -a xxxUserName
    ```


1. 设置共享资源

    ```sh
    [root@localhost ~]# vi /etc/samba/smb.conf
      # 先使用分号注释掉[homes]和[printers]部分的配置，以禁止共享各个账户的主目录和打印机
      # 再追加以下共享配置
      [share]                                                # 共享的名称，可以出现多个这样的配置
      comment=some discription
      path=/path/to/shared/folder
      browseable=yes
      writeable=no
      valid users=xxxUserName
      write list=
    # 验证配置文件语法是否正确
    [root@localhost ~]# testparm -s /etc/samba/smb.conf
    ```

1. 设置实际目录的权限，以便有samba写权限的用户在本地共享目录上就有写权限

    ```sh
    [root@localhost ~]# chown witeableUser:witeableUser /path/to/shared/folder
    ```
1. 重启 samba 服务

    ```sh
    [root@localhost ~]# service smb restart
    [root@localhost ~]# service nmb restart
    ```

# 匿名访问

1. 为samba设置匿名访问用的账户

    ```sh
    [root@localhost ~]# smbpasswd -an nobody
    [root@localhost ~]# vi /etc/samba/smb.conf
      [global]
      security = share  
      guest account = nobody
      dns proxy = no
    ```

1. 设置可匿名访问的资源

    ```sh
    [root@localhost ~]# vi /etc/samba/smb.conf
      [share]
      path = /path/to/shared/folder
      browseable=yes
      writeable=no
      guest ok = yes
      guest only = yes
    # 验证配置文件语法是否正确
    [root@localhost ~]# testparm -s /etc/samba/smb.conf
    ```

1. 修改匿名可写目录的权限

    ```sh
    [root@localhost ~]# chown nobody:nobody /path/to/shared/folder
    ```
1. 重启 samba 服务

    ```sh
    [root@localhost ~]# service smb restart
    [root@localhost ~]# service nmb restart
    ```


## ubuntu 

### 安装

```
sudo apt-get install samba
```
	
### 匿名访问

1. 修改 `vi /etc/samba/smb.conf`

    ```
    [global]
    guest account = nobody
    ```

1. 创建共享目录、并修改权限

    ```
    mkdir -p /data0/samba/tmp
    chown -R nobody:nogroup /data0/samba/tmp
    ```

1. 配置 

    ```conf
    [tmp]
    path=/data0/samba/tmp
    browseable = yes
    writeable = yes
    guest ok = yes 
    guest only = yes 
    ```