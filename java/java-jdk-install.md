# Linux 下安装

## open jdk

```bash
# CentOs
yum install java-1.8.0-openjdk-devel
which -a java
export JAVA_HOE=/usr/lib/jvm/java-1.8.0


# Ubuntu
sudo add-apt-repository ppa:openjdk-r/ppa
sudo apt-get update 
sudo apt-get install openjdk-8-jdk
sudo update-alternatives --config java
```

## sdkman 安装

```
# https://support.apple.com/kb/DL1572?viewlocale=en_US&locale=en_US

sdk list java
sdk install java 8u144-oracle
sdk install java 6u65-apple   # eclipse 等程序要用 jdk6 运行

# MacOs 删除
/usr/libexec/java_home  # 查看当前JAVA_HOME
sudo rm -rf /Library/Java/JavaVirtualMachines/jdk<version>.jdk
sudo rm -rf /Library/PreferencePanes/JavaControlPanel.prefPane
sudo rm -rf /Library/Internet\ Plug-Ins/JavaAppletPlugin.plugin
sudo rm -rf /Library/LaunchAgents/com.oracle.java.Java-Updater.plist
sudo rm -rf /Library/PrivilegedHelperTools/com.oracle.java.JavaUpdateHelper
sudo rm -rf /Library/LaunchDaemons/com.oracle.java.Helper-Tool.plist
sudo rm -rf /Library/Preferences/com.oracle.java.Helper-Tool.plist

```

## 二进制包安装

1. 从[oracle官网](http://www.oracle.com/technetwork/java/javase/downloads/index.html)下载所需的JDK二进制安装包，并保存到 `/data/tmp/` 目录下。
1. 安装

    ```bash
[root@locahost ~] cd /data/tmp
[root@locahost ~] ./jdk-6u45-linux-x64.bin                      # 会解压出一个名称为 "jdk1.6.0_45" 的目录
[root@locahost ~] mv jdk1.6.0_45 /data/software/           # 移动到规约要求的目录下。
    ```
1. 设置全局环境变量 `vi /etc/profile.d/test12.sh`

    ```bash
    #!/bin/bash
    export JAVA_HOME=/data/software/jdk1.6.0_45

    if [ "${_PATH}" != "1" ]; then
        export _PATH=1
        export PATH=$JAVA_HOME/bin:$PATH
    fi
    ```
1. 重新登录root用户后确认

    ```bash
    [root@his-branch-proxy1 ~]# java -version
    java version "1.6.0_45"
    Java(TM) SE Runtime Environment (build 1.6.0_45-b06)
    Java HotSpot(TM) 64-Bit Server VM (build 20.45-b01, mixed mode)

    [root@locahost ~] ln -s -T $JAVA_HOME/bin/java /usr/bin/java  # 如果是用RPM的bin包安装的，则跳过此步骤。
    ```

## 压缩包安装



```bash
sudo mkdir /usr/local/java
sudo tar zxvf jdk-8u40-linux-x64.tar.gz -C /usr/local/java

# 修改环境变量
vi /etc/profile.d/xxx.sh
export JAVA_HOME=/usr/local/java/jdk1.8.0_40
export PATH=$JAVA_HOME/bin:$PATH

# 重新登录后验证
java -version
```

