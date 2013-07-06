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
