
# ubuntu 下中文字体

```sh
# 安装文泉驿中文字体
sudo apt-get install ttf-wqy-microhei

vi $IDEA_HOME/bin/idea64.vmoptions
-Dawt.useSystemAAFontSettings=lcd
-Dsun.java2d.xrender=true
-Dswing.aatext=true 
-Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel


```