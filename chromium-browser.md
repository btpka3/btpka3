

# 中文tab页的title乱码

相关[bug1](https://code.google.com/p/chromium/issues/detail?id=316723&q=chinese%20title&colspec=ID%20Pri%20M%20Iteration%20ReleaseBlock%20Cr%20Status%20Owner%20Summary%20OS%20Modified), [bug2](https://code.google.com/p/chromium/issues/detail?id=272006)

```sh
# 临时解决办法
sudo mv /etc/fonts/conf.d/65-droid-sans-fonts.conf /etc/fonts/conf.d/65-droid-sans-fonts.conf.bak
```


```sh
# 确认日志
chromium-browser --enable-logging --v=1 --disable-extensions  https://zh.wikipedia.org/
tailf ~/.config/chromium/chrome_debug.log
```