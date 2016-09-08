
[gradle](http://gradle.org/)



```
wget https://downloads.gradle.org/distributions/gradle-2.11-bin.zip
sudo mkdir /usr/local/grale/
sudo unzip gradle-2.11-bin.zip -d /usr/local/grale/


sudo vi /etc/profile.d/zll.sh
export GRADLE_HOME=/usr/local/grale/gradle-2.11
export PATH=$GRADLE_HOME/bin:$PATH

# 启用 Gradle Daemon
vi ~/.gradle/gradle.properties
org.gradle.daemon=true


# 列出所有task
gradle tasks --all
```

## init script
maven可以通过 settings.xml 进行全局配置，比如本地仓库的位置，mirror等。
那Gradle如何进行类似设置？——可以使用 [init script](https://docs.gradle.org/current/userguide/init_scripts.html)

创建文件 `~/.gradle/init.gradle`

```
allprojects {
    repositories {
        mavenLocal()
        maven {
            url "http://mvn.kingsilk.xyz/content/groups/public/"
        }
    }
}

```

