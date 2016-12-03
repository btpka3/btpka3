
# 苹果电脑

2016 在 杭州钱皇, 公司在给配置(租赁)了一个顶配的苹果笔记本电脑给用,这是第一次正式使用苹果的设备。
下面就记录一下总结。


## 参考

* [苹果推送证书的设置](https://code.csdn.net/micrqwe/document/file/iphoneAPN.md)
* [ Why does chown report “Operation not permitted” on OS X?](http://superuser.com/questions/279235/why-does-chown-report-operation-not-permitted-on-os-x)
* [copying file under root got failed in OS X El Capitan 10.11](http://stackoverflow.com/questions/32590053/copying-file-under-root-got-failed-in-os-x-el-capitan-10-11)
* [Microsoft Office 2016 for Mac with VL License Utility V2.0](https://www.firewolf.science/2015/09/microsoft-office-2016-for-mac-15-25-0-with-vl-license-utility/)
* [Microsoft Office 2016 for Mac Downloads](http://macadmins.software/)
* [360安全卫士for Mac](http://www.360.cn/mac/)

* [insanelymac.com](http://www.insanelymac.com/forum/files/)
* [osx86project](http://wiki.osx86project.org/wiki/index.php/Main_Page)
* [hackintosh.com](http://www.hackintosh.com/)
* [VMware 11安装Mac OS X 10.10](http://jingyan.baidu.com/article/ff411625b9011212e48237b4.html)
* [bootdiskutility.exe](http://cvad-mac.narod.ru/index/bootdiskutility_exe/0-5)
* [clover](https://clover-wiki.zetam.org/zh-CN/What-is-what)

## brew
苹果电脑并没有类似 Ubuntu 的 apt-get 或 CentOS 的 yum 命令, 但第三方提供了类似的工具 [brew](http://brew.sh/)

```bash
sudo chown -R $USER /usr/local

echo source \~/.bashrc >> ~/.bashr_profile
```

## 修改主机名

```bash
sudo scutil –-set HostName new_hostname
sudo /usr/libexec/locate.updatedb
```

## 常用快捷键

```
Command + <-                    : Home 键
Command + ->                    : End  键
Command + tab                   : 在不同应用之间循环切换窗口
Command + `                     : 在同一个应用之间循环切换窗口

Command + Control + F           : 全屏显示当前窗口

# 显示桌面
Command + F3                    : 部分第三方软件下不行
Fn + F11                        : 部分第三方软件下不行
Command + Shift + 3             : 全屏截图
Command + Shift + 4             : 选定区域截图
Command + Shift + 4, Space      : 对特定窗体进行截图
```

## Finder

Finder 上没有地址栏, 可以
FinderPath https://bahoom.com/finderpath/

```
# Finder上没有地址栏?
Command+Shift+G             显示指定的目录

# 显示所有文件
defaults write com.apple.finder AppleShowAllFiles TRUE;killall Finder
defaults write com.apple.Finder AppleShowAllFiles FALSE;killall Finder

# 在打开、保存对话框中临时显示所有文件
Command+Shift+Period

# 在 bash 中使用 Finder 打开指定的路径
open /tmp
```



## Networking

```
networksetup -setairportpower airport off      # 关闭wifi
networksetup -setairportpower airport on       # 开启wifi
sudo ifconfig en4 down                         # 关闭有线网卡
sudo ifconfig en4 up
lsof -n -i :8080                               # 获取哪些进程在使用（监听/访问）8080端口


## 安装 PCRE

```
http://www.pcre.org/
tar zxvf pcre-8.38.tar.bz2
cd
less INSTALL
./configure
make
make check

```



## tengine

* 使用 brew 安装 pcre

    ```
    brew install pcre
    ```

* 使用 brew 安装 最新的 openssl

    ```
    # 检查系统自带的旧版本
    openssl version     # OpenSSL 0.9.8zh 14 Jan 2016
    which OpenSSL         # /usr/bin/openssl

    # 安装最新版本
    brew install openssl

    # 以下命令不再起作用了，只能修改编译器的参数了
    # brew link --force openssl

    # 使命令行下使用的是最新的
    ln -s /usr/local/opt/openssl/bin/openssl /usr/local/bin/openssl

    # 新开窗口
    openssl version     # OpenSSL 1.0.2h  3 May 2016
    ```

* 编译并安装

    ```
    # 创建安装所需的目标目录
    mkdir -p /usr/local/tengine/tengine-2.1.2


    cd tengine-2.1.2

    # 下面命令不要使用 `--with-openssl=DIR`，该选项只能使用 openssl 的源码包，
    # 而不能使用 brew 安装的预编译包

    ./configure --prefix=/usr/local/tengine/tengine-2.1.2 \
        --user=`whoami` \
        --with-cc-opt=-I/usr/local/opt/openssl/include \
        --with-ld-opt=-L/usr/local/opt/openssl/lib
    ```

* 修改 nginx.conf

    ```
    user zll staff;
    ```

* 配置launchd配置文件

新建文件 `/Library/LaunchDaemons/tengine.plist`

    ```
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
                           "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key><string>tengine</string>
        <key>RunAtLoad</key><true/>
        <key>KeepAlive</key><true/>
        <key>ProgramArguments</key>
        <array>
            <string>/usr/local/tengine/tengine-2.1.2/sbin/nginx</string>
            <string>-g</string>
            <string>daemon off;</string>
        </array>
        <key>WorkingDirectory</key><string>/usr/local/tengine/tengine-2.1.2</string>
        <key>StandardErrorPath</key><string>/var/log/system.log</string>
        <key>LaunchOnlyOnce</key><true/>
      </dict>
    </plist>
    ```

* 启停

    ```
    # 注意：因为tengine.plist 不是在自己主目录下，所有要 sudo
    sudo launchctl load     -wF /Library/LaunchDaemons/tengine.plist
    sudo launchctl unload     /Library/LaunchDaemons/tengine.plist
    sudo launchctl start     tengine
    sudo launchctl stop     tengine
    sudo launchctl list      tengine


    /System/Library和/Library和~/Library目录的区别?
    /System/Library     Apple自己开发的软件。
    /Library             系统管理员存放的第三方软件。
    ~/Library/             用户自己存放的第三方软件。
    LaunchDaemons        是用户未登陆前就启动的服务(守护进程)。
    LaunchAgents        是用户登陆后启动的服务(守护进程)。
    ```

# 自启动服务


`vi /Library/LaunchDaemons/com.yangyz.memcached.plist`


```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.yangyz.memcached.plist</string>
    <key>ProgramArguments</key>
    <array>
        <string>/usr/bin/start-memcached</string>
    </array>
    <key>KeepAlive</key>
    <false/>
    <key>RunAtLoad</key>
    <true/>
    <key>StandardErrorPath</key>
    <string>/tmp/memcached.err</string>
    <key>StandardOutPath</key>
    <string>/tmp/memcached.out</string>
</dict>
</plist>
```



苹果电脑中通过 LaunchCtl 管理服务。常用命令有

```
man plist
man launchd
man launchd.plist
launchctl load         ~/Library/LaunchAgents/net.xxx.yyy.plist
launchctl unload     ~/Library/LaunchAgents/net.xxx.yyy.plist
launchctl start     net.xxx.yyy.plist
launchctl stop         net.xxx.yyy.plist
launchctl list
```


## 共享文件夹

### smb服务器在苹果电脑上

1. 苹果电脑上进行以下操作：

    ```
    System Preferences
        -> Sharing
            -> 选中 `File Sharing`
            -> 点击 "Options" 按钮，确保 SMB 共享选项开启
        -> User & Groups
            -> 点击左下角的"锁"的图标，输入你的密码并解锁修改权限
            -> 选中 'Guest User'
            -> 勾选中 'Allow guest users to connect to shared folders'
    ```
1. windows 电脑上访问 `\\192.168.0.146` (IP地址应该是你苹果电脑的IP地址)，用户名为 `guset`, 密码为空。Done.

1. Linux 电脑上访问 `smb://192.168.0.146` 访问即可。

1. 苹果电脑上创建共享目录：在目标目录上右键 -> Get Info -> 选中 "Shared Folder" 即可。
注意：需要在系统偏好的文件共享中更新权限。

## windows上提供的共享目录

1. Mac OS X -> Finder -> Go -> Connect to Server ()

⌘、⌥、⇧、⌃、⎋

## Android
sdk 下载
http://sdk.android-studio.org/



/Users/zll/work/nfs/12/share /data1/samba/share/share


## node
### 使用 brew 安装

```
brew search node
brew install homebrew/versions/node4-lts
```

### 从nodejs官网下载pkg进行安装

```
pkgutil --pkgs | grep node
pkgutil --files org.nodejs.node.pkg

# 删除
pkgutil --only-files --files org.nodejs.node.pkg | tr '\n' '\0' | xargs -n 1 -0 sudo rm -if
pkgutil --only-dirs  --files org.nodejs.node.pkg | tail -r | tr '\n' '\0' | xargs -n 1 -0 sudo rmdir
```




## Terminal

```


Preferences
    Gerneral
        -> On startup, open : New window with profile: Pro
    Profiles
        -> Pro -> 'Advanced' 标签页 -> International
            : "Text encoding" 选择为 "Unicodd (UTF-8)"
            : 取消选中 'Set locale environment variables on startup'
            : 选中 "Unicode East Asian Ambiguous characters are wide"

vi ~/.bash_profile
export LC_CTYPE=en_US.UTF-8

# 正常显示中文
vi ~/.inputrc
set meta-flag on
set input-meta on
set output-meta on
set convert-meta off

# 快捷键
Ctrl+A   光标跳到行首
Ctrl+E   光标跳到行尾
Alt + <- 向左跳过一个词
Alt + -> 向右跳过一个词
Esc + F  光标移动到下一个单词开始   (F - Forward)
Esc + B  光标移动到当前单词开始        (B - Back)

Ctrl + C  取消当前行输入，新开一行
Ctrl + K  将光标位置到结尾的内容清除，并复制到 Kill Buffer
Ctrl + Y  将 Kill Buffer 中的内存粘贴出来
Ctrl + R  反向查找历史命令
Ctrl + W  从光标当前位置，向后删除一个词

Fn + Shift + <-     Home
Fn + Shift + ->     End

Command + Shift + double-click  :  select a path or a URL
Command + click-and-drag        : 选择不连续的文字
Alt + click-and-drag            : 矩形区域选择
```





《[Steps to get your adapter working if you just upgraded to Mac OS 10.11 El Capitan.](http://inkandfeet.com/how-to-use-a-generic-usb-20-10100m-ethernet-adaptor-rd9700-on-mac-os-1011-el-capitan)》
 重启, <kbd>Command + R</kdb> 进入恢复模式, 并命令行运行 `csrutil disable`


## Android

(Android File Transfer)[https://www.android.com/filetransfer/]

```
myApp/platforms/android/project.properties
myApp/platforms/android/CordovaLib/project.properties
```


## xcode

```
Preference
    -> "Text Editing" 标签页
        "Editing" 标签页 :
            Show :
                选中 "Line numbers"
                选中 "Code folding ribbon"
        "indentation" 标签页 :
            Line wrapping:
                取消选中 "Wrap lines to editor width"

# 快捷键
# http://bbs.itheima.com/thread-111004-1-1.html

Command + Alt + S         : 保存所有文件
Command + Shift + W     : 关闭文件
Command + [                : 左缩进
Command + ]                : 左缩进

# 格式化代码，Xcode 不支持格式化代码，只能编排缩进
# 1. 选中要编排缩进的代码， 鼠标右键，Structure, Re-Ident
# 2. 一个取巧的方法就是：全选、剪切、再粘贴（Command+A, Command+X, Command+V）
```











