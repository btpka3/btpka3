

mongodb有那些工具？可以到 [mongodb-tools.com](http://mongodb-tools.com/) 进行过滤查找。

[robomongo](https://robomongo.org/download)是一个mongodb的 GUI 管理程序。

# Linux 环境安装

```
# wget https://download.robomongo.org/0.9.0-rc8/linux/robomongo-0.9.0-rc8-linux-x86_64-c113244.tar.gz
sudo mkdir /usr/local/robomongo
sudo tar zxvf robomongo-0.9.0-rc8-linux-x86_64-c113244.tar.gz -C /usr/local/robomongo
```

# 桌面图片

```
cd /usr/local/robomongo/robomongo-0.9.0-rc8-linux-x86_64-c113244/bin
sudo wget https://robomongo.org/static/robomongo-128x128-129df2f1.png
sudo mv robomongo-128x128-129df2f1.png robomongo.png
vi ~/Desktop/robomongo.desktop

[Desktop Entry]                                      
Name=Robomongo
Icon=/usr/local/robomongo/robomongo-0.9.0-rc8-linux-x86_64-c113244/bin/robomongo.png
Exec=/usr/local/robomongo/robomongo-0.9.0-rc8-linux-x86_64-c113244/bin/robomongo
StartupNotify=true
Terminal=false
Type=Application

```