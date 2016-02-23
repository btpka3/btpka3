

# 如何真机调试？

参考 [这里](http://blog.csdn.net/freshlover/article/details/42528643)


# 安装


## 安装 cordova

注意：该段命令无需大家执行

```
npm install -g cordova

# 确认统一安装 6.0.0 版本的 cordova
cordova -v
cordova create qh-app
cordova platform add android

# 注意: 第一次执行时，会从远程下载 gradle-2.2.1-all.zip，可能会比较慢，
#  可以先下载到本地，再执行以下命令。
export CORDOVA_ANDROID_GRADLE_DISTRIBUTION_URL=file:///local/path/to/gradle-2.2.1-all.zip
cordova build android
```
