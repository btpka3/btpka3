
[打印](http://www.hplipopensource.com/hplip-web/install/install/index.html)

# u盘安装

使用 usb-creator-gtk 来创建可以启动U盘。该程序可以到 Ubuntu software center 中查找 'Startup disk creator' 进行安装

# 显卡驱动
```
lspci -nnk | grep VGA                         # 查看显卡型号
sudo add-apt-repository ppa:xorg-edgers/ppa   # 安装 Nvidia 驱动的 ppa
sudo apt-get update
sudo apt-get purge nvidia*                    # 移除旧的的显卡驱动

# 安装新的驱动。最好通过 start-> Preferences -> Aditional Drivers 选择安装
sudo apt-get install nvidia-349   
```

# 版本

ubuntu 所有的版本号以及 [codeName](https://wiki.ubuntu.com/DevelopmentCodeNames) :

```
lsb_release -a                      # 查看当前安装的 ubuntu 的版本
```


# dpkg

```
dpkg -i package.deb
```

# apt


```sh
apt-get -s install <package>
apt-cache policy <package>
apt-cache search <package>  # 模糊查找package
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

# 如果通过 dpkg 或 apt-get 安装时，依赖未满足，可以使用该命令删除
sudo apt-get remove xxx

sudo add-apt-repository --remove ppa:whatever/ppa


apt-mark showhold 
sudo apt-mark unhold <package name>
```

## apt-get socks5 proxy 

```
http://pkgs.org
apt-get install tsocks
vi /etc/tsocks.conf
 sudo tsocks apt-get update
```

# bt 下载

```
sudo add-apt-repository apt://transmission
sudo apt-get install transmission
```

# 7788

```
sudo apt-get install trash-cli           # 今后不要使用rm命令删除文件，而使用 trash 将其移动到回收站，然后不定期的清理回收站，防止误删。
sudo apt-get install rar                 # rar
sudo apt-get install libreoffice         # libreoffice
sudo apt-get purge abiword
sudo apt-get purge gnumeric

sudo apt-get install gnome-calculator    # 计算器
sudo apt-get install curl

sudo apt-get install p7zip               # 7z
7z x xxx.7z -r -o /home/xx               # 7z : 解压
7z a -t7z -r manager.7z /home/manager/*  # 7z : 压缩
```

# 修改主机名

```
sudo hostname your-new-hostname

sudo vim /etc/hostname
your-new-hostname

sudo vim /etc/hosts
127.0.1.1     your-new-hostname
```

# 中文字体
参考[这里](http://wiki.ubuntu.com.cn/%E5%AD%97%E4%BD%93)

```sh
sudo apt-get install ttf-wqy-microhei   #文泉驿-微米黑
sudo apt-get install ttf-wqy-zenhei     #文泉驿-正黑
sudo apt-get install xfonts-wqy         #文泉驿-点阵宋体
sudo apt-get install fonts-wqy-microhei fonts-wqy-zenhei 
# sudo mkfontscale
# sudo mkfontdir
# sudo fc-cache -fv
```

# 输入法

```sh
#sudo add-apt-repository ppa:fcitx-team/nightly
sudo add-apt-repository ppa:fcitx-team/stable
sudo apt-get update
sudo apt-get install fcitx
#sudo apt-get install gnome-language-selector
im-config  # or im-switch


# 以下三种输入法选择其一就可以了。
sudo apt-get install fcitx-googlepinyin 
sudo apt-get install fcitx-sunpinyin
# 搜狗输入法 for linux http://pinyin.sogou.com/linux/


# 后续配置

# 防止Fcitx的Ctrl+Shift+F进行繁简转换：语言指示图标上右键->Configure->Addon
# ->选中 "Simple Chinese To Tranditional Chinese" -> 点击底部的Configure按钮
# -> 取消相应的快捷键即可。

#fcitx -r --enable fcitx-qimpanel
#fcitx-qimpanel

# Linux Mint 中如果找不到相应的配置入口，可以安装并调用以下命令
fcitx-config-gtk
```

# gedit

## 安装

```sh
sudo apt-cache search gedit
sudo apt-get install gedit 
sudo apt-get install gedit-plugins

# gmate https://github.com/gmate/gmate
sudo apt-add-repository ppa:ubuntu-on-rails/ppa
sudo apt-get update
sudo apt-get install gedit-gmate

# 移除旧的 文本编辑器 leafpad
sudo apt-get remove leafpad
```

## 配置

```
View -> 取消选中 'toolbar'
Edit -> Preferences :
    View
        -> 选中 'Display line numbers'
        -> 选中 'Highlight current line'
        -> 选中 'Highlight matching brackets'
    Editor
        -> Tab width 设置为 4 
        -> 选中 'Insert spaces instead tabs'
        -> 选中 'Enable automatic indentation'
        -> 取消选中 'Create a backup copy of files before saving'
        -> 取消选中 'Autosave files every 10 minutes'
    Font & Colors
        -> 选择一个自己喜爱的 Color Schema
```


# gnome-terminal

```sh

gnome-terminal : Edit : Profiles : New : xxx : 并设置默认为该 profile
: General 
   : 取消选中 Use the system fixed width font，并选择使用 Monospace 14 / ubuntu mono 14
   : 选中 Use custom default terminal size ： 120x30
: Title and Command 
   : 选中 Run command  as login shell
   // : 选中 Run a cunstom command instead of my shell，并输入 `env TERM=xterm-color /bin/bash`

# gnome-terminal 彩色显示
vi /etc/profile.d/xxx.sh
export TERM=xterm-color

# 使命令行提示符只显示父目录，而非整个路径
vi ~/.bashrc
查找 PS1 并将其中最后的 \w 替换为 \W
修改ll别名
alias ll='ls -lF'
```

## 常用快捷键

|hot key      | descrption|
|-------------|-----------|
|Alt+1        | 主键盘上的额数字键，可以快速切换至第N个标签页 |
|Ctrl+Shift+T | 开启新的标签页 |
|Ctrl+Shift+C | 复制 |
|Ctrl+Shift+V | 粘贴 |
|Ctrl+E       | 清屏 |
|Ctrl+R       | 搜索历史命令 |
|Ctrl+W       | 向后删除一个词 |
|Ctrl+C       | 取消当前行的输入，新开始一行 |
|Ctrl+U       | 清空当前输入行 |
|Ctrl+D       | 如果当前行是空白行时，可以退出登录，直到退出当前窗口。 |


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

# chromium-browser

```sh
[me@locahost:~]$ sudo apt-get install chromium-browser
```

NOTICE: 该浏览器中文乱码可以参考[这里](https://code.google.com/p/chromium/issues/detail?id=316723&q=chinese%20title&colspec=ID%20Pri%20M%20Iteration%20ReleaseBlock%20Cr%20Status%20Owner%20Summary%20OS%20Modified)

```sh
sudo rm /etc/fonts/conf.d/65-droid-sans-fonts.conf
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

# qq

参考[这里](http://blog.csdn.net/beyond_ray/article/details/38966251)

```

#sudo add-apt-repository ppa:ubuntu-wine/ppa
#sudo apt-get update
#sudo apt-get install wine1.7


sudo apt-get install    \
    libasound2          \
    libgtk2.0-0         \
    liblcms2-2          \
    libpng12-0          \
    libsm6              \
    libncurses5         \
    libcups2            \
    libpulse0           \
    libmpg123-0         \
    libasound2-plugins  \
    ttf-wqy-microhei
 
sudo apt-get install libgtk2.0-0:i386
sudo apt-get install ia32-libs
sudo apt-get install lib32ncurses5

sudo dpkg -i wine-qqintl_0.1.3-2_i386.deb
sudo apt-get install -f
#sudo apt-get remove wine-qqintl

cp /usr/share/applications/qqintl.desktop ~/Desktop
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
sudo service ssh status
```

# 登录画面的number lock

```sh
# for login

sudo vi /etc/xdg/lubuntu/lxdm/lxdm.conf
[base]
numlock=1

sudo vi /etc/lxdm/default.conf
[base]
numlock=1

# for lock screen
sudo vi /etc/lightdm/lightdm.conf.d/20-lubuntu.conf
greeter-setup-script=/usr/bin/numlockx on

# ???
sudo apt-get install numlockx
echo "/usr/bin/numlockx on" | sudo tee -a /etc/xdg/lxsession/Lubuntu/autostart

sudo vi /etc/X11/xinit/xinitrc
# 追加一下几行
/usr/bin/numlockx on 

# ???
sudo vi /usr/share/lightdm/lightdm.conf.d/60-lightdm-gtk-greeter.conf
greeter-setup-script=/usr/bin/numlockx on

```


# Adobe Flash Player

火狐安装的版本一般都比较低，而Chromium浏览器自带一般相对高些。具体可以通过该[网页](https://www.adobe.com/software/flash/about/)检测查看。


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


# 配置DNS

```sh
# 方法1
sudo vi /etc/network/interfaces
# 追加一下一行
dns-nameservers 192.168.101.1

# 方法2
sudo vi /etc/resolvconf/resolv.conf.d/base
nameserver 8.8.8.8

# 最后，更新
sudo resolvconf -u
cat /etc/resolv.conf

sudo ifdown eth0 && sudo ifup eth0
cat /etc/resolv.conf

#  补充
# 可以检测dns有没有在没有记录的时候提供替代地址，比如 189so 网址导航服务
dig @8.8.8.8 www.not-exist-domain.com 

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
## TO Windows

```sh
sudo apt-get install grdesktop
```

## FROM Windows

see [this](http://askubuntu.com/questions/247501/i-get-failed-to-load-session-ubuntu-2d-when-using-xrdp)

```
sudo apt-get install xrdp
sudo apt-get install vnc4server  # tightvncserver

sudo cp /etc/xrdp/xrdp.ini /etc/xrdp/xrdp.back && sudo nano /etc/xrdp/xrdp.ini

[globals]
max_bpp=128
use_compression=yes

[xrdp7]
xserverbpp=128

sudo service xrdp restart

echo lxsession -s Lubuntu -e LXDE > ~/.xsession
# sudo apt-get install gnome-session-fallback
# echo gnome-session --session=gnome-fallback > ~/.xsession
# echo xfce4-session > ~/.xsession
```



# PHP

```sh
sudo apt-get install nginx
sudo apt-get install php5-fpm php5-cli php5-cgi php5-mysql
sudo service php5-fpm status

sudo vi /etc/php5/fpm/php.ini
cgi.fix_pathinfo=0

sudo vi /etc/php5/fpm/pool.d/www.conf
owner = www-data
group = www-data
listen.owner = www-data
listen.group = www-data
listen.mode = 0660


sudo vi /etc/nginx/sites-available/default
    location ~ \.php$ {
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
    #   # NOTE: You should have "cgi.fix_pathinfo = 0;" in php.ini
    #   
    #   # With php5-cgi alone:
    #   fastcgi_pass 127.0.0.1:9000;
    #   # With php5-fpm:
        fastcgi_pass unix:/var/run/php5-fpm.sock;
        fastcgi_index index.php;
        include fastcgi_params;
    }

sudo service php5-fpm restart
sudo service nginx restart

vi /usr/share/nginx/html/my.php
<?php phpinfo(); ?>

# 访问浏览器 http://localhost/my.php
```

# 自动挂载Windows分区



```sh
sudo blkid   # 查看各个分区的UUID
id           # 查看自己当前账户的uid和gid
sudo vi /etc/fstab
UUID=519CB82E5888AD0F  /media/Data  ntfs  defaults,gid=1000,uid=1000  0 0
```
