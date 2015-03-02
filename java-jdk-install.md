# Linux 下安装
## 二进制包安装

1. 从[oracle官网](http://www.oracle.com/technetwork/java/javase/downloads/index.html)下载所需的JDK二进制安装包，并保存到 `/data/tmp/` 目录下。
1. 安装

    ```sh
[root@locahost ~] cd /data/tmp
[root@locahost ~] ./jdk-6u45-linux-x64.bin                      # 会解压出一个名称为 "jdk1.6.0_45" 的目录
[root@locahost ~] mv jdk1.6.0_45 /data/software/           # 移动到规约要求的目录下。
    ``` 
1. 设置全局环境变量

    ```sh
[root@locahost ~] vi /etc/profile.d/his.sh
      #!/bin/bash
      export JAVA_HOME=/data/software/jdk1.6.0_45
      export CLASSPATH=.:
      export PATH=${JAVA_HOME}/bin:${PATH}
    ``` 
1. 重新登录root用户后确认

    ```sh
    [root@his-branch-proxy1 ~]# java -version
    java version "1.6.0_45"
    Java(TM) SE Runtime Environment (build 1.6.0_45-b06)
    Java HotSpot(TM) 64-Bit Server VM (build 20.45-b01, mixed mode)
    
    [root@locahost ~] ln -s -T $JAVA_HOME/bin/java /usr/bin/java  # 如果是用RPM的bin包安装的，则跳过此步骤。
    ``` 

## 压缩包安装
JDK版本统一使用1.7.0_60
 

```sh
tar zxvf jdk-7u60-linux-x64.tar.gz -C /usr/local/

# 修改环境变量
vi /etc/profile.d/lizi.sh
export JAVA_HOME=/usr/local/jdk1.7.0_60
export PATH=$JAVA_HOME/bin:$PATH

# 重新登录后验证
java -version
```

 