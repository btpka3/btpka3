
# JDK
## 安装Oracle [JDK](http://askubuntu.com/questions/56104/how-can-i-install-sun-oracles-proprietary-java-6-7-jre-or-jdk)
```sh
sudo apt-get install python-software-properties
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update
sudo apt-get install oracle-java7-installer
```

# 系统配置
## Lubuntu 开机就使用小键盘（numlock）
```sh
sudo vi /etc/xdg/lubuntu/lxdm/lxdm.conf
[base]
numlock=1
```