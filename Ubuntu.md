
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



7788

```sh
[me@locahost]$ sudo apt-get install chromium-browser

[me@locahost]$ sudo add-apt-repository ppa:fcitx-team/nightly
[me@locahost]$ sudo apt-get update
[me@locahost]$ sudo apt-get install fcitx
[me@locahost]$ sudo apt-get install gnome-language-selector
[me@locahost]$ im-config
#http://pinyin.sogou.com/linux/
fcitx -r --enable fcitx-qimpanel
fcitx-qimpanel

gnome-terminal : Edit : Profiles : New 
: Title and Command : 选中 Run command as a login shell


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

    <keybind key="W-t">                                                         
      <action name="Execute">
        <command>gnome-terminal</command>
      </action>
    </keybind>


$ openbox --reconfigure
```

* Lubuntu 锁屏

```sh
$ vi ~/.config/openbox/lubuntu-rc.xml
    <!-- Lock the screen on Home + l-->
    <keybind key="W-l">
      <action name="Execute">
<!--       <command>xscreensaver-command -lock</command>--> 
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


# flash

```sh
sudo apt-get install pepperflashplugin-nonfree
sudo update-pepperflashplugin-nonfree --install
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
