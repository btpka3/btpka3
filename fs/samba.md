# samba

## Win7

匿名共享

1. （可选）简化主机名，统一工作组，

    ```
    "我的电脑" 右键
         -> 高级系统设置
         -> "计算机名" 标签页
         -> 点击 "更改" 按钮
             : 简化主机名
             : 统一工作组为 `WORKGROUP`
         -> 重启电脑以便生效
    ```

1. 开启 Guest 账户，并留空 Guest 密码。

    ```
    "我的电脑" 右键 -> 管理 -> 计算机管理（本地）-> 系统工具 -> 本地用户和组
         -> 用户 -> 双击 Guest 账户： 右键 属性， 取消 "账户已禁用"
    ```

1. 修改组策略 `Win+R` 运行 `gpedit.msc`

    ```
    \本地计算机\计算机配置\windows 设置\安全设置\本地策略
        \用户权限分配
            拒绝从网络上访问这台计算机 -> 删除其中的 guest 账户
        \安全选项
            网络访问：本地账户的共享和安全模型 -> 选为 “仅来宾 - 对本地用户进行身份验证，其身份为来宾”
    ```


## centos

###  安装

NetBIOS Message Block (NMB )
可以通过主机名代替IP地址来访问局域网里的主机。

1. 安装samba

    ```bash
    rpm -qa | grep samba   # 确认samba是否已经安装
    yum list samba            #  查看可安装的samba版本
    yum install samba        #  安装
    ```

1. 设置默认运行级别

    ```bash
    chkconfig --list smb                     # 查看smb默认运行级别
    chkconfig --list nmb                     # 查看nmb默认运行级别
    chkconfig --level 345 smb on       # 设置smb默认运行级别
    chkconfig --level 345 nmb on       # 设置smb默认运行级别
    ```

1. （可选）设置防火墙

    如果开启了防火墙的情况下，需要开启TCP 139、445端口; UDP 137、138端口。

1.  （可选）设置SELinux

    如果开启了SELinux，则需要为每个共享目录执行以下命令。

    ```bash
    [root@localhost ~]# chcon -R -t samba_share_t /path/to/shared/folder
    ```
    或者禁用SELinux

    ```bash
    [root@localhost ~]# setenforce 0                    # 临时禁用SELinux，重启后失效
    [root@localhost ~]# vi /etc/selinux/config        # 永久禁用SELinux
      SELINUX=disabled
    ```

# 认证访问

1. 添加使用samba的账户

    ```bash
    # xxxUserName用户仅仅用来远程samba登录，不需要本地登录。
    [root@localhost ~]# adduser -M xxxUserName
    # 为xxxUserName用户设置samba登录时的密码（注意：该密码不同于账户本地登录操作系统的密码）
    # samba默认的密码文件是 /var/lib/samba/private/passdb.tdb
    [root@localhost ~]# smbpasswd -a xxxUserName
    ```


1. 设置共享资源

    ```bash
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

    ```bash
    [root@localhost ~]# chown witeableUser:witeableUser /path/to/shared/folder
    ```
1. 重启 samba 服务

    ```bash
    [root@localhost ~]# service smb restart
    [root@localhost ~]# service nmb restart
    ```

# 匿名访问

1. 为samba设置匿名访问用的账户

    ```bash
    [root@localhost ~]# smbpasswd -an nobody
    [root@localhost ~]# vi /etc/samba/smb.conf
      [global]
      security = share          # 该值已经废弃，应使用 user
      guest account = nobody    # 此为默认值，可不必明确设置
      dns proxy = no
    ```

1. 设置可匿名访问的资源

    ```bash
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

    ```bash
    [root@localhost ~]# chown nobody:nobody /path/to/shared/folder
    ```
1. 重启 samba 服务

    ```bash
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

    ```ini
    [tmp]
    path=/data0/samba/tmp
    browseable = yes
    writeable = yes
    guest ok = yes
    guest only = yes
    ```


# demo

smb.conf

```
[global]
    workgroup = WORKGROUP
    server string = %h server (Samba, test13)
    dns proxy = no

    log file = /var/log/samba/log.%m
    max log size = 100
    syslog = 0
#    panic action = /usr/share/samba/panic-action %d
    server role = standalone server

    passdb backend = tdbsam
    obey pam restrictions = yes
    unix password sync = yes
    passwd program = /usr/bin/passwd %u
    passwd chat = *Enter\snew\s*\spassword:* %n\n *Retype\snew\s*\spassword:* %n\n *password\supdated\ssuccessfully* .
    pam password change = yes
    map to guest = bad user
    usershare allow guests = yes

[tmp]
    comment = tmp
    path =  /data0/tmp
    browseable = yes
    guest ok = yes
    guest only = yes
    writable = yes

```