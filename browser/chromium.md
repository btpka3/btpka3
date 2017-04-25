

# 中文tab页的title乱码

相关[bug1](https://code.google.com/p/chromium/issues/detail?id=316723&q=chinese%20title&colspec=ID%20Pri%20M%20Iteration%20ReleaseBlock%20Cr%20Status%20Owner%20Summary%20OS%20Modified), [bug2](https://code.google.com/p/chromium/issues/detail?id=272006)

```bash
# 临时解决办法
sudo mv /etc/fonts/conf.d/65-droid-sans-fonts.conf /etc/fonts/conf.d/65-droid-sans-fonts.conf.bak
```


```bash
# 确认日志
chromium-browser --enable-logging --v=1 --disable-extensions  https://zh.wikipedia.org/
tailf ~/.config/chromium/chrome_debug.log
```


# 手机 浏览器 WebView 远程调试

1. chrome remote debug时打开inspect时出现一片空白

因为chrome inspect需要翻墙加载以下我网站上的资源：


https://chrome-devtools-frontend.appspot.com
https://chrometophone.appspot.com


编辑hosts文件，添加：

61.91.161.217    chrome-devtools-frontend.appspot.com
61.91.161.217    chrometophone.appspot.com

即可