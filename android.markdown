

# 安装

```
sudo mkdir /usr/local/android/
sudo tar zxvf android-sdk_r24.3.4-linux.tgz -C /usr/local/android/

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

# native.js
http://ask.dcloud.net.cn/article/88

http://ask.dcloud.net.cn/article/114