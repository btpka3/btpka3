# 微信 debug


## 参考
* [微信web开发者工具](https://mp.weixin.qq.com/wiki/10/e5f772f4521da17fa0d7304f68b97d7e.html#.E4.B8.8B.E8.BD.BD.E5.9C.B0.E5.9D.80)
* [参考1](http://blog.qqbrowser.cc/)
* 《[微信-公众平台：微信web开发者工具](https://mp.weixin.qq.com/wiki?t=resource/res_main&id=mp1455784140&token=&lang=zh_CN)》
* 《[微信调试工具问题反馈和建议收集贴](http://bbs.browser.qq.com/thread-205291-1-1.html)》

smb://192.168.0.12/public/wechat_web_devtools_0.7.0_x64.exe




----------------------------------------以下废弃


# 在线调试微信打开的HTML5页面

注意：最新的情况已经可以在 http://blog.qqbrowser.cc/ 使用qq浏览器来调试了。



## 需求
现在微信内嵌了自己的 X5 浏览器内核，该内核毕竟与别的主流浏览器还是有一点差别，如何线上调试成了一个棘手的问题。
开发时我们还可以使用 alert，线上错误就没办法了，再说总alert也很烦。

## 参考

* 《[微信webview调试方法](http://bbs.mb.qq.com/thread-243399-1-1.html?pid=313743&fid=93)》

    下面这个步骤将允许你在电脑的 chromium 浏览器 ：
    1. 即时查看你在微信中渲染的html的 dom （会额外插入两个辅助用的 iframe）
    1. 选中不同 dom 的节点，微信中渲染的html上相应的块高亮显示。
    1. 修改相应的 dom 也会在 微信中渲染的html上及时反馈
    1. 断点调试 javascript

* 《[linux下android开发真机设备识别不了怎么办](http://jingyan.baidu.com/article/49711c6151ca75fa441b7c1c.html)》

## 步骤

### 手机开启USB调试

手机上 -> 工具 -> 设置 -> 开发人员选项 -> 开启 `USB 调试`

PS：华为的手机默认没有显示 `开发人员选项`，需要： 手机上 -> 工具 -> 设置 -> 关于手机 -> 连续点击 `版本号` 5～7次，
之后会提示说 进入开发者模式，再返回后就可以看到 `开发人员选项` 了


### 手机上安装 tbs 调试包

[附件](http://res.imtt.qq.com/tbs_inspect/wx_sq_webview_debug.zip)

1. 在手机上面安装微信（如果是第一次新装）
1. 在微信中随便找个聊天窗口，收入 `//deletetbs` 删除原有的 TBS 工具 (注意：该操作没有任何提示的哦)
1. 在手机上安装附件压缩包中的 tbs_20150526_021257_inspector.apk 或者 从[这里](http://res.imtt.qq.com/tbs_inspect/TbsSuiteNew.zip)下载。
1. 打开 `TBS 工具集` ：

    1. 选择 `安装本地TBS内核`
    1. 选择 `com.tencent.mm` —— 即为微信安装 TBS
    1. 点击最下面的 `快速杀死App（强行停止）` 按钮，退出微信
    1. 点击 `(1)安装TBS` 按钮
    1. 打开微信，随便找个服务号，公众号的链接，打开一个网址，停留1分钟，然后返回到 TBS 工具集 的画面
    1. 点击 `(3)检查是否安装成功`， 确保安装成功
1. 将手机通过USB连接到电脑上
1. 在手机微信中打开网页
2. 吃用 chrominum 浏览器打开 `http://localhost:9222`, 选择要调试的画面进行调试。

### 电脑上安装 inspector_client 脚本

1. 电脑上安装 python （略过，Ubuntu貌似已经自带安装了？ PS：注意，Ubuntu下 python 3 的执行命令是 python3, python 2 的执行命令是 python）
1. 解压附件中的 `inspector_client20150401.zip`

    ```
    file inspector_client20150401.zip             # 可以检测到使用的是 7zip 格式压缩的

    sudo mkdir /usr/local/inspector_client
    sudo apt-get install p7zip-full
    sudo 7z x inspector_client20150401.zip -r -o/usr/local/inspector_client

    cd /usr/local/inspector_client
    sudo chmod +rx -R *
    sudo chmod +x platforms/linux/adb            # 为adb增加可执行权限
    sudo chmod +x inspector.py
    sudo vi inspector.py                         # 移除第一行中的 `^M`， 否则会报错，提示找不到 python

    ./inspector.py                               # 开始执行，之后用 chromium 浏览器访问 http://localhost:9222
                                                 # 如果提示未找到USB设备，请参考下面的 `让电脑识别手机的USB连接`
    ```


### 让电脑识别手机的USB连接

国产手机大多无法被android开发套件的adb程序识别，需要手动配置一下

1. 将手机用USB线连接上电脑
1. 通过 `lsusb` 命令获取所有的 usb 设备

    ```
    Bus 002 Device 002: ID 8087:8000 Intel Corp.
    Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
    Bus 001 Device 002: ID 8087:8008 Intel Corp.
    Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
    Bus 004 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
    Bus 003 Device 003: ID 0101:0007
    Bus 003 Device 018: ID 12d1:1052 Huawei Technologies Co., Ltd.      # 该行的 `12d1:1052` 就是手机的 USB ID
    Bus 003 Device 004: ID 258a:0003
    Bus 003 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
    ```

1. 创建规则文件

    ```bash
    sudo touch /etc/udev/rules.d/50-android.rules

    sudo vi /etc/udev/rules.d/50-android.rules
    # 增加以下一行内容, 其中 12d1:1037 就是前一步获取的手机的 USB ID，只使用冒号前面的即可。这里是 "12d1"
    SUBSYSTEM=="usb",SYSFS{idVendor}=="12d1",MODE="0666"

    #示例
    SUBSYSTEM=="usb",SYSFS{idVendor}=="0bb4",MODE="0666"
    SUBSYSTEM=="usb",ATTR{idVendor}=="0bb4",ATTR{idProduct}=="0c02",SYMLINK+="android_adb"
    ```

1. 修改 adb_usb.ini

    ```bash
    echo "0x12d1" >> ~/.android/adb_usb.ini
    ```

1. 重启 udev 服务
                                                 
    ```
    sudo service udev restart
    ```

1. 使用 adb 检查

    ```
    ${inspector_client_home}/platforms/linux/adb kill-server
    ${inspector_client_home}/platforms/linux/adb devices
    ```


# 微信命令

|代码                        |解释          |
|---------------------------|------------|
|//getfpkey                 |得到手机基本信息                                |
|//pickpoi                  |定位当前位置                                  |
|//fullexit                 |完全退出微信                                  |
|//sightinfo                |打开查看小视频参数(以后你小视频的时候就都显示了)   |
|//traceroute               |打开诊断网络                                  |
|//uplog                    |上传记录                                    |
|//netstatus                |显示当前网络情况                                |
|//sightinfo                |小视频信息                                   |
|//whatsnew                 |打开首屏窗口显示微信新功能介绍                         |
|//gettbs                   |显示tbs信息                                 |
|//deletetbs                |删除tbs信息                                 |
|//clrgamecache             |清除游戏缓存                                  |
|//sosomap                  |切换为腾讯地图                                 |
|//checkcount               |统计聊天记录的数量                               |
|//dumpmemory               |内存释放                                    |
|//gamemsg                  |游戏消息                                    |
|//voipfacedebug            |开启或关闭voip调试功能                           |
|//adddownloadtask          |添加下载任务                                  |
|//querydownloadtaskbyurl   |查询下载任务,以url方式返回                         |
|//removedownloadtask       |清除下载任务                                  |
|//pausedownloadtask        |暂停下载任务                                  |
|//resumedownloadtask       |重新下载                                    |
|//testofflinedownloadtask  |打开内部体验,下载                               |
|//testupdate               |检查更新                                    |
|//debugsnstimelinestat     |打开或关闭sns的时间线调试状态