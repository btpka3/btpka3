

# 安装

```
sudo mkdir /usr/local/android/
sudo tar zxvf android-sdk_r24.3.4-linux.tgz -C /usr/local/android/
sudo chown -R zll:zll /usr/local/android/

sudo vi /etc/profile.d/zll.sh
# 追加以下两行内容：
export ANDROID_HOME=/usr/local/android/android-sdk-linux
export PATH=$ANDROID_HOME/tools:$PATH
```


http://www.th7.cn/Program/Android/201411/320301.shtml

# Android SDK 国内镜像代理

http://mirrors.neusoft.edu.cn/android/repository/

解决国内访问Google服务器的困难：

1. 启动 Android SDK Manager ；
1. 打开主界面，依次选择「Tools」、「Options...」，弹出『Android SDK Manager - Settings』窗口；
1. 在『Android SDK Manager - Settings』窗口中，在「HTTP Proxy Server」和「HTTP Proxy Port」输入框内填入mirrors.neusoft.edu.cn和80，并且选中「Force https://... sources to be fetched using http://...」复选框；
1. 设置完成后单击「Close」按钮关闭『Android SDK Manager - Settings』窗口返回到主界面；
1. 依次选择「Packages」、「Reload」。

http://wear.techbrood.com/


# Ubuntu 下面模拟器加速

```
sudo apt-get install qemu-kvm libvirt-bin ubuntu-vm-builder bridge-utils
sudo adduser `whoami` kvm
sudo adduser `whoami` libvirtd

# 检验是否安装成功
sudo virsh -c qemu:///system list

# 列出所有的 avd
android list avd

# 选择一个并启动（使用 kvm）
# 注意：下面命令中的 "test1" 是 avd 的名称
emulator -avd test1 -qemu -m 2047 -enable-kvm
```

# native.js
http://ask.dcloud.net.cn/article/88

http://ask.dcloud.net.cn/article/114

#Ubuntu 14 LTS 需要安装32为的库才行

http://stackoverflow.com/questions/18041769/error-cannot-run-aapt

```
sudo apt-get install gcc-multilib lib32z1 lib32stdc++6
```



# 绕过华数等宽带提供商的恶心http劫持现象

```
# 建立ssh隧道（需要有公网服务器）
ssh sshUser@sshHost -C -f -N -g -D 9999

export _JAVA_OPTIONS="-DsocksProxyHost=127.0.0.1 -DsocksProxyPort=9999"
android
```