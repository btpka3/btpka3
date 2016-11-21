[QQ 企业邮箱配置参考](http://service.exmail.qq.com/cgi-bin/help?subtype=1&&id=28&&no=1000564)

# Foxmail for Windows

TODO

# ThunderBird for Ubuntu

## 安装

```bash
sudo apt-get  install thunderbird

## 配置qq企业邮箱

```
启动thunderbird后，点击右上角的 三条杠 的图标 
    : Preferences 
    : Account Settings 
    : 点击左侧底部 Account Actions 
        : Add Mail Account 
            : 按提示收入邮箱地址和密码，continue
            : 点击 manual config 
                : incoming 选择 IMAP协议，服务器输入 imap.exmail.qq.com ，SSL选择 "SSL/TLS"; 
                : outgoing服务器收入 smtp.exmail.qq.com，SSL选择 "SSL/TLS"; 
                : Username的两个输入框均输入完整的邮箱地址（比如：zhangll@xxx.com）;
                : 点击 Re-test确认配置
                : done
    : 点击刚刚新建的邮箱账户
        : 右侧 Signature Text， 选中 Use Html。可以设置发送邮件的签名。
          可以通过Firefox登录qq企业邮箱，新建邮件，但无需发送，选中签名并右键 View Selection source 查看、复制、粘贴即可
        : 选中 Copies & Folders 
            : 选中 Place a copy in : Other "Sent Messages on zhangll@xxx.com"
              # (请忽略该设置) "Sent" Folder on Local Folders （否则由于qq企业邮箱的问题，远程没有Sent目录）
              # (请忽略该设置) 可选——选中 Bcc these email address: 收入自己的邮箱全路径。（这样，就可以保证自己所发送的邮件都有远程备份）
```

接收邮件服务器：imap.exmail.qq.com ，使用SSL，端口号993
发送邮件服务器：smtp.exmail.qq.com ，使用SSL，端口号465


## 安装常用插件

启动thunderbird后，点击右上角的 三条杠 的图标 : Add-ons:
* 搜索并安装 MinimizeToTray。可以将在最小化时缩小到系统托盘中。

    配置：重启ThunderBird后，再到该插件页面的 Extensions 标签页，点击 Preferences 按钮进行配置。一般选中 When minimizing 和 Show context menu on right click。

* 搜索并安装 Minimize On Start and Close。

    配置：重启ThunderBird后，再到该插件页面的 Extensions 标签页，点击 Preferences 按钮进行配置。一般选中 Minimize on Esc-press（即，当按ESC键时，就最小化，配合前一个插件，就会缩到系统托盘中）。


## 登录时自动启动

* Ubuntu
参考[这里](http://askubuntu.com/questions/48321/how-do-i-start-applications-automatically-on-login)

* LUbuntu
System->Preferences->Default Applications for LXSession : Autostart 标签页：输入 thunderbird



## 使用过滤器

有时候，某一类邮件过多时（比如来自禅道），想从所有邮件中挑选出来，单独存放到一个目录下时，可以使用。

1. 新建目录
   
    在ThunderBird左侧的邮箱账户上右键->New Folder->输入目录的名称，比如 "zentao"

1. 创建过滤器并运行一次

    在ThunderBird右上角，点击三条横杠的图标->Message Filters->Message Filters->弹出窗口中点击 按钮 new
    ->为Filter启动一个名称，设置From contains "zentao@xxx.com", 设置将消息移动到 刚刚新建的目录中，OK
    ->返回弹出窗口，选中刚刚新建的Filter，并点击按钮 "Run Now"



# Android 手机客户端

TODO


# Iphone 手机邮件客户端