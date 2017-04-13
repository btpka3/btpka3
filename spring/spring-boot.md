

* [reference guide](http://projects.spring.io/spring-boot/#quick-start)

## banner
默认打印 classpath下 banner.txt，可以修改文件位置和编码。
也可以是图片，图片的话会转为 [ASCII art](https://en.wikipedia.org/wiki/ASCII_art)。

一些在线的 ASCII art 工具：
* [Text to ASCII Art Generator (TAAG)](http://www.patorjk.com/software/taag/)
* [1](http://ascii.mastervb.net/text_to_ascii.php)
* [2](http://chris.com/ascii/)
* [5 Best Ascii Art Generators (Convert your Image to Text)](http://www.mytrickpages.com/2013/10/5-best-ascii-art-generators-convert-your-image-to-text.html)


# gradle 启动多个 profile

```
# build.gradle
bootRun {
    String activeProfile =  System.properties['spring.profiles.active']
    String confLoc = System.properties['spring.config.location']
    systemProperty "spring.profiles.active", activeProfile
    systemProperty "spring.config.location", "file:$confLoc"
}

./gradlew -Dspring.profiles.active=a,b bootRun

# idea intellij 的 Run/Debug 中编辑窗口如下配置：
Tasks:              bootRun
VM options:         -Dspring.profiles.active=a,b
Script parameters:  
```


