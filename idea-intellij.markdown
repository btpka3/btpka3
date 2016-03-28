# 15

```
>> License server 
http://idea.lanyus.com
```
# 安装

```
sudo mkdir /usr/local/idea
sudo tar zxvf ~/Downloads/ideaIU-14.0.3.tar.gz -C /usr/local/idea

vi ~/Desktop/idea14.desktop
[Desktop Entry]
Version=1.0
Type=Application
Terminal=false
Icon[en_US]=gnome-panel-launcher
Name[en_US]=idea-IU-14.0.3
Exec=/usr/local/idea/idea-IU-139.1117.1/bin/idea.sh
Icon=/usr/local/idea/idea-IU-139.1117.1/bin/idea.png

cd /usr/local/idea/idea-IU-139.1117.1/bin/
sudo cp idea64.vmoptions idea64.vmoptions.bak
sudo vi idea64.vmoptions           // 修改JVM参数
sudo vi idea.sh                    // 在最开始加入  `. /etc/profile.d/xxx.sh`
```



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
Keymap : 复制一份 Eclipse 版的快捷键配置，搜索 close 并
    移除 Window/Active Tool Window/Close Active Tab 的 `Ctrl+W` 的快捷键
    为 Window/Editor Tabs/Close 追加 `Ctrl+W` 的快捷键
    查找F2使用的快捷键，并全部移除，为 Main Menu/Refactor/Rename 增加 F2 快捷键
```

# 插件

* [sonarqube](http://plugins.jetbrains.com/plugin/7238?pr=idea)
* [angularjs](http://plugins.jetbrains.com/plugin/6971?pr=idea)
# 通过IP地址访问 build-in server

在nginx/tengin 中加入如下配置文件

```
server {                                                                                                                
    listen 192.168.0.60:63342;
    server_name 192.168.0.60;
    server_tokens off;
    root /notExisted;
    location / { 
        proxy_pass              http://localhost:63342;
        proxy_set_header        Host            $host;
        proxy_set_header        X-Real-IP       $remote_addr;
        proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header        X-Forwarded-Proto $scheme;
    }   
}
```
