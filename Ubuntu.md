
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






# JDK
## 安装Oracle [JDK](http://askubuntu.com/questions/56104/how-can-i-install-sun-oracles-proprietary-java-6-7-jre-or-jdk)
```sh
sudo apt-get install python-software-properties
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update
sudo apt-get install oracle-java7-installer

# abort
sudo killall -9 apt-get
ps aux | grep dpkg # kill them
dpkg --configure -a
sudo apt-get -r oracle-java7-installer

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