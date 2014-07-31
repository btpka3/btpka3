
# apt


```sh
apt-get -s install <package>
apt-cache policy <package>
apt-show-versions <package>
aptitude versions <package>

# 查询安装包安装了那些内容
dpkg-query -L <package_name>

# 列出所有已经安装的软件包
dpkg-query -l 

# 查找指定的文件属于哪一个package
sudo apt-get install apt-file
sudo apt-file update
apt-file search filename
apt-file search /path/to/file

```

# 中文字体
参考[这里](http://wiki.ubuntu.com.cn/%E5%AD%97%E4%BD%93)

```sh
sudo apt-get install ttf-wqy-microhei  #文泉驿-微米黑
sudo apt-get install ttf-wqy-zenhei  #文泉驿-正黑
sudo apt-get install xfonts-wqy #文泉驿-点阵宋体
```

# 输入法

```sh
[me@locahost:~]$ sudo add-apt-repository ppa:fcitx-team/nightly
[me@locahost:~]$ sudo apt-get update
[me@locahost:~]$ sudo apt-get install fcitx
[me@locahost:~]$ sudo apt-get install gnome-language-selector
[me@locahost:~]$ im-config
[me@locahost:~]$ sudo apt-get install fcitx-googlepinyin fcitx-sunpinyin
# 防止Fcitx的Ctrl+Shift+F进行繁简转换：语言指示图标上右键->Configure->Addon
# ->选中 "Simple Chinese To Tranditional Chinese" -> 点击底部的Configure按钮
# -> 取消相应的快捷键即可。


#http://pinyin.sogou.com/linux/
#fcitx -r --enable fcitx-qimpanel
#fcitx-qimpanel
```

# gedit

# gnome-terminal

```sh

gnome-terminal : Edit : Profiles : New : xxx : 并设置默认为该 profile
: General 
   : 取消选中 Use the system fixed width font，并选择使用 Monospace 14
   : 选中 Use custom default terminal size ： 120x30
: Title and Command : 选中 Run command as a login shell

# 使命令行提提示符彩色显示
vi /etc/profile.d/xxx.sh
#!/bin/bash
export TERM=xterm-color

# 使命令行提示符只显示父目录，而非整个路径
vi ~/.bashrc
查找 PS1 并将其中最后的 \w 替换为 \W
修改ll别名
alias ll='ls -lF'
```


# 文件管理器  PCManFM

```sh
Edit : Preference :
  General : Default View : Detailed list view
  Layout : 选中 Filesystem root
```
# 桌面图标

```sh
# 复制既有应用的图标
ll /usr/share/applications/*.desktop
cp /usr/share/applications/firefox.desktop ~/Desktop

# 自定义一个图标

vi ~/Desktop/idea-IU-135.909.desktop
[Desktop Entry]
Version=1.0
Type=Application
Terminal=false
Icon[en_US]=gnome-panel-launcher
Name[en_US]=idea-IU-135.909
Exec=env UBUNTU_MENUPROXY=  /home/zll/work/idea-IU-135.909/bin/idea.sh
Icon=/home/zll/work/idea-IU-135.909/bin/idea.png
```

# 7788 

```sh
[me@locahost:~]$ sudo apt-get install chromium-browser
```

# service

```sh
# 等价于CentOS上的chkconfig
[me@localhost:~]$ sudo apt-get install sysv-rc-conf
[me@localhost:~]$ sudo sysv-rc-conf --help
```

# JDK
## 安装Oracle [JDK](http://askubuntu.com/questions/56104/how-can-i-install-sun-oracles-proprietary-java-6-7-jre-or-jdk)
```sh
sudo apt-get install python-software-properties
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update
sudo apt-get install oracle-java7-installer

# 缓存文件
# /var/cache/oracle-jdk8-installer/jdk-8u5-linux-x64.tar.gz

# abort
sudo killall -9 apt-get
ps aux | grep dpkg # kill them
dpkg --configure -a
sudo dpkg -r oracle-java7-installer

```

# 系统配置
## Lubuntu 开机就使用小键盘（numlock）
```sh
sudo vi /etc/xdg/lubuntu/lxdm/lxdm.conf
[base]
numlock=1
```

# python

```sh
sudo apt-get install python-dev
sudo apt-get install python-pip
```

# Ruby

```sh
# 1.9.3
sudo apt-get install ruby1.9.3

# FIXME 2.0+
wget http://cache.ruby-lang.org/pub/ruby/2.1/ruby-2.1.1.tar.gz
tar zxvf ruby-2.1.1.tar.gz
cd ruby-2.1.1/
./configure
???

# RVM
curl -sSL https://get.rvm.io | bash -s stable
# in new console
rvm install 2.1.1

```

# 常见问题
* 禁止自动login

```sh
$ sudo vi /etc/lightdm/lightdm.conf
[SeatDefaults]
#autologin-user=xxx            # comment this line
#autologin-user-timeout=0      # comment this line
```

* Lununtu 截屏
[Lununtu Keyboard](https://help.ubuntu.com/community/Lubuntu/Keyboard)

```sh
$ vi ~/.config/openbox/lubuntu-rc.xml

    <keybind key="W-r">                
      <action name="Execute">
        <!-- <command>lxsession-default launcher_manager</command> -->
        <command>lxpanelctl run</command>
      </action>
    </keybind>


    <!-- Take a screenshot of the current window with scrot when Alt+Print are pressed -->
    <keybind key="A-Print">
      <action name="Execute">
        <!--<command>lxsession-default screenshot window</command>-->
        <command>scrot -u -b</command>
      </action>
    </keybind>
    <!-- Launch scrot when Print is pressed -->
    <keybind key="Print">
      <action name="Execute">
        <!--<command>lxsession-default screenshot</command>-->
        <command>scrot</command>
      </action>
    </keybind>

    <!-- 打开控制台-->
    <keybind key="W-t">                                                         
      <action name="Execute">
        <command>gnome-terminal</command>
      </action>
    </keybind>
 
    <!-- Lubuntu 锁屏-->
    <keybind key="W-l">
      <action name="Execute">
        <!-- <command>xscreensaver-command -lock</command>--> 
        <command>dm-tool lock</command>
      </action>
    </keybind>

$ openbox --reconfigure

```


# SSH

```sh
sudo apt-get install openssh-client
sudo apt-get install openssh-server
```

# 登录画面的number lock

```sh
# for login
sudo vi /etc/lxdm/default.conf
[base]
numlock=1

# for lock screen
sudo vi /etc/lightdm/lightdm.conf.d/20-lubuntu.conf
greeter-setup-script=/usr/bin/numlockx on

# ???
sudo vi /etc/X11/xinit/xinitrc
# 追加一下几行
/usr/bin/numlockx on 

# ???
sudo vi /usr/share/lightdm/lightdm.conf.d/60-lightdm-gtk-greeter.conf
greeter-setup-script=/usr/bin/numlockx on

```


# Adobe Flash Player

```sh
sudo apt-get install flashplugin-installer 

#sudo apt-get install pepperflashplugin-nonfree
#sudo update-pepperflashplugin-nonfree --install
```

# 文件关联

```sh
vi ~/.local/share/applications/mimeapps.list
cat /usr/share/applications/defaults.list
```


# Mount UDF/ISO-13346 镜像

```sh
sudo mount -t auto /dev/cdrom0 / media/cdrom0
```


# 静态IP地址
参考[这里](http://www.sudo-juice.com/how-to-set-a-static-ip-in-ubuntu-the-proper-way/)

## 先禁用图形化的网络管理工具

```sh
sudo vi /etc/NetworkManager/NetworkManager.conf
[main]
plugins=ifupdown,keyfile,ofono
#dns=dnsmasq   # 注释掉这一行

[ifupdown]
#managed=false
managed=true   # 将值改为true
```
## 配置静态IP地址

```sh
sudo vi /etc/network/interfaces

auto lo
iface lo inet loopback


auto eth0
iface     eth0 inet static
address   192.168.115.222
gateway   192.168.115.1
netmask   255.255.255.0 
dns-nameservers 8.8.8.8 8.8.4.4
# ??? DNS貌似也可以配置在 /etc/resolvconf/resolv.conf.d/base
```
## 重启网络

```sh
sudo service network-manager stop
sudo service network-manager start
```


# wine
[wine](http://www.winehq.org/) 可以让部分Windows程序运行在Linux环境下，主要原理是其重新实现了Windows的API。

[安装参考](http://wiki.ubuntu.com.cn/Wine)

# netbook/laptop screen brightness

```sh
# done.
xrandr -q | grep " connected"
xrandr --output LVDS1 --brightness 0.5 
#xrandr --output VGA1 --brightness 0.9
#xbacklight -inc XX 

sudo vi /etc/default/grub 
# GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"
# OK...............
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash acpi_osi="
#GRUB_CMDLINE_LINUX_DEFAULT="quiet splash acpi_backlight=vendor"
sudo update-grub

```

# 远程桌面
## TO windows

```sh
sudo apt-get install grdesktop
```
