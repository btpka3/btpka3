


## 安装 Android SDK

```
sudo mkdir /usr/local/android/
sudo tar zxvf android-sdk_r24.3.4-linux.tgz -C /usr/local/android/
sudo chown -R `whoami`:`whoami` /usr/local/android/

# 修改环境变量
sudo vi /etc/profile.d/xxx.sh
# 追加以下两行内容：
export ANDROID_HOME=/usr/local/android/android-sdk-linux
export PATH=$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools:$PATH
```

参考： [1](http://www.th7.cn/Program/Android/201411/320301.shtml)

## 创建 AVD

```
#  设置 Android SDK Manager 使用国内镜像
andorid
    -> 主界面
    -> 点击菜单 "Tools"
    -> 点击菜单项 "Options..."，弹出窗口： "Android SDK Manager - Settings" :
        -> 设置 "HTTP Proxy Server" 为 `mirrors.neusoft.edu.cn`
        -> 设置 "HTTP Proxy port" 为 `80`
        -> 勾选中 "Force https://... sources to be fetched using http://..."
        -> 点击 "Close" 按钮
    -> 点击菜单 "Packages"
    -> 点击菜单项 "Reload"

    # （可选），选中 所需的各种 API版本 并下载安装

    -> 点击菜单 "Tools"
    -> 点击菜单项 "Manage AVDs"，弹出窗口: "Android Virtual Device (AVD) Manager" :
        -> 点击 "Create" 按钮
        -> AVD Name         : 随意输入，比如 "test1"
        -> Device           : 比如 "Nexus One (3.7", 480 x 800: hdpi)"
        -> Taget            : 比如 "Android 4.4.2 - API Level 19"
        -> CPU/ABI          : 通常为 "Intel Atom (x86)"
        -> Keyboard         : 勾选中 "Hardware keyboard present"
        -> Skin             : 选中 "Skin with dynamic hardware controls"
        -> Front Camera     : "None"
        -> Back Camera      : "None"
        -> Memory Options   : RAM : 1024M, VM Heap: 32M
        -> Internal Sotrage : 2048M
        -> SD Card          : 2048M
        -> Emulation Options: 选中 "Use Host GPU"

   # 重要：安装 Extra/Intel x86 Enumlator Accelerator(HAXM installer)
     会将 HAXM 下载到 Android SDK 目录下的 Extra下面，仍然需要浏览到该目录手动安装一下的。

```

参考： [1](http://mirrors.neusoft.edu.cn/android/repository/)、[2](http://wear.techbrood.com/)

## Ubuntu 下面模拟器加速: 安装 kvm

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


# 学习

* 《[Android状态栏微技巧，带你真正理解沉浸式模式](http://blog.csdn.net/guolin_blog/article/details/51763825)》

```

App Manifest

https://developer.mozilla.org/en-US/Apps/Fundamentals


Chrome Apps
developer.chrome.com/apps

Web Worker
Service Worker
Web Sockert

Activity
    onCreate()
    onStart()
    onResume()
    onStop()
    onDestroy()


    Activity栈 后进先出LIFO
Service
Broadcast Receiver
    正常广播
    有序广播
Content Provider
```