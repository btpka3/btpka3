# 15

```
>> License server
http://idea.lanyus.com
或者
http://www.iteblog.com/idea/key.php
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

# 注意： Mac OS X 下，会单独生成文件的保存路径，比如：/Users/zll/Library/Preferences/IntelliJIdea2016.2/idea.vmoptions

```

# 苹果下快捷键

<!-- ↑ ↓ ← → ↖ ↗ ↙ ↘ ↔ ↕  ⬆️⬇️➡️⬅️ -->

|key |description|
|------|-----|
|<kbd>Cmd + ←</kdb>|光标移动到行首|
|<kbd>Cmd + →</kdb>|光标移动到行尾|
|<kbd>Cmd + Shift + ↑</kdb>|选中区域向上移动|
|<kbd>Cmd + Shift + ↓</kdb>|选中区域向下移动|
|<kbd>Cmd + /</kdb>|注释代码|
|<kbd>Cmd + [</kdb>|导航：向后|
|<kbd>Cmd + ]</kdb>|导航：向前|
|<kbd>Cmd + Shift + [</kdb>|导航：前一个 Tab|
|<kbd>Cmd + Shift + ]</kdb>|导航：后一个 Tab|
|<kbd>Cmd + Backspace</kdb>|删除当前行|
|<kbd>Cmd + D</kdb>|复制当前行|
|<kbd>Cmd + Shift + Backspace</kdb>|导航：回到最后一次修改处|
|<kbd>Cmd + Fn + ←</kdb>|回到编辑器第一行|
|<kbd>Cmd + Fn + →</kdb>|回到编辑器最后一行|
|<kbd>Cmd + P</kdb>|显示参数|
|<kbd>Cmd + Shift + E</kdb>|显示最近修改的文件|
|<kbd>Cmd + Shift + V</kdb>|显示最近5次粘贴的内容|
|<kbd>Cmd + Option + L</kdb>|格式化代码|
|<kbd>Cmd + Option + L</kdb>|格式化代码|
|<kbd>Ctrl + Option + O</kdb>|格式化 import|


# ubuntu 下中文字体

```bash
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
## 7788

1. 工程中选择输出目录（比如 target，build，dist 等），右键选择 `Mark Directory As` -> `Excluded`
   或者到 `Preferences | Project | Directories` 中排除指定的目录。


## jetbrains license server

use docker [woailuoli993/jblse](https://hub.docker.com/r/woailuoli993/jblse/).


```bash
docker create                           \
    --name qh-idea                      \
    --restart unless-stopped            \
    -p 20701:20701                      \
    woailuoli993/jblse
    
docker start qh-idea

# 认证服务器： http://127.0.0.1:20701
```
