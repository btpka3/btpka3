
# ubuntu 下中文字体

```sh
# 安装文泉驿中文字体
sudo apt-get install ttf-wqy-microhei

vi $IDEA_HOME/bin/idea64.vmoptions
-Dawt.useSystemAAFontSettings=lcd
-Dsun.java2d.xrender=true
-Dswing.aatext=true 
-Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel

#

Settings -> Appearance -> Override default fonts by ... : WenQuanYi Micro Hei Mono 13px
Settings -> Editor 
    -> Use anti-aliased font
    -> Colors & Fonts -> Font.  : WenQuanYi Micro Hei Mono 14px

or  YaHei Consolas Hybrid 15px
```
[YaHei.Consolas.1.12.rar](http://files.cnblogs.com/icelyb24/YaHei.Consolas.1.12.rar)





# 常用设置

从菜单栏打开 File -> Settings : 

```
Appearance && Behavior
    Appearance :
        1. Theme 下拉选择为 "Darcula"
    Keymap : 
        1. Keymaps 下拉选择为 "Eclipse"
Editor :
    General :
        Appearance : 
            1. 选中 "Show line numbers"
            1. 选中 "Show whitespaces"
```


