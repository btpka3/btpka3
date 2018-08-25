

## install


## quick start


```sh
java -Dfelix.config.properties=file:/path/to/config.properties -jar ./bin/felix.jar

# 查看帮助
help



# 查看当前安装了哪些 bundle
felix:lb

# 安装 bundle
felix:install path/to/bundle.jar

# 卸载 bundle
felix:uninstall
felix:resolve


# ------------------
help obr:repos

# 查看使用的哪个 obr 仓库
# 默认显示的是 http://felix.apache.org/obr/ 
# 浏览器访问该网址的话，可以看到下面主要有个 `releases.xml` 文件
obr:repos list

# 列出 OSGi Bundle Repository (OBR) 中有的 bundle
obr:list 
obr:list -v "Apache Felix Bundle Repository"
obr:info "Apache Felix Bundle Repository"@1.6.6

# 下载 source 包到指定的目录
obr:source /tmp "Apache Felix Bundle Repository"@1.6.6

# 下载 javadoc 包到指定的目录
obr:javadoc /tmp "Apache Felix Bundle Repository"@1.6.6

# 从 obr 仓库下载并安装给定的 bundle
obr:deploy "Apache Felix Bundle Repository"@1.6.6
```
