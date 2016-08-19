


# 如何定制修改 build.gradle?
build.gradle 都是自动生成的，那又是如何自动生成？如何修改其中的代码？


# 版本？
最新的 cordova (6.3.0) 使用的是 cordova-ios@4.2.0，cordova-android@5.2.1。
安卓开发的话，支持 [14-23](https://cordova.apache.org/docs/en/latest/guide/platforms/android/) 的安卓 API(Android 4.0~6.0)。


# 如何真机调试？

参考 [这里](http://blog.csdn.net/freshlover/article/details/42528643)。

注意：初次使用时，会白屏，因为谷歌的服务器被墙了。可以使用 XX-NET 翻墙一下就OK了。

# 设置 android webview 可调试
参考 [1](https://developers.google.com/chrome-developer-tools/docs/remote-debugging#configure-webview)

```java
  if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
      WebView.setWebContentsDebuggingEnabled(true);
  }
```

WebView 能否被 debug，不受 AndroidManifest.xml 中的 `debuggable` 的影响。但是如果想只有 `debuggable` 为 true 时，webview 才能被调试，可以使用以下代码。

```
  if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
    if (0 != (getApplicationInfo().flags &= ApplicationInfo.FLAG_DEBUGGABLE))
    { WebView.setWebContentsDebuggingEnabled(true); }
  }
```




# 跨域？

cordova 默认是使用 file 协议加载html的。但默认 file 协议 是无法 ajax 访问外部网站数据的。

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

# cordova 插件版本检查

```
cordova plugin list

npm install -g cordova-check-plugins
cordova-check-plugins
```

# android 自动签名

```sh
cd $PROJECT_ROOT
vi ./platforms/android/debug-signing.properties         # debug 签名用
vi ./platforms/android/release-signing.properties       # release 签名用
```

示例内容如下 (具体可分析 ./platforms/android/build.gradle 中 addSigningProps 方法)
```properties
storeFile=../../xxx.jks
storePassword=xxx
storeType=jks
keyAlias=xxx
keyPassword=xxx
```


