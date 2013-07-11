## 多模块
```
  -pl, --projects                ：只构建指定的模块列表，使用逗号分隔
  -rf, --resume-from             ：多模块构建时，跳过指定的模块
  -am, --also-make               ：在构建指定的模块时，也构建该模块所依赖的其他模块
  -amd, --also-make-dependents   ：在构建指定的模块时，也构建依赖于该模块的其他模块
```
示例：
```
# 安装leafModule1和它所依赖的模块（含父模块）
mvn -Dmaven.test.skip=true -am --projects subModule1/leafModule1 clean install
```
参考：[Guide multiple modules](http://maven.apache.org/guides/mini/guide-multiple-modules.html)
注意：使用以上参数时，当前路径应当是根模块的pom.xml所在的目录  
注意：如果子模块B有一些自动生成代码的Maven插件依赖于子模块A，恐怕就不能一起编译了。而必须先install子模块A，才能在子模块B中自动生成代码、之后才可能重新一起编译、打包

## 常用命令
查看那些profile生效
`mvn help:active-profiles -N`