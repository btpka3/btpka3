- [dive](https://github.com/wagoodman/dive) # 分析镜像的工具

# 特性
## Show Docker image contents broken down by layer
显示 docker 镜像不同 layer 中的内容
## Indicate what's changed in each layer
显示给定layer中哪些文件修改了。
## Estimate "image efficiency"
评估docker镜像的效能。比如：哪些文件因为被后面的layer 覆盖，移动等造成的镜像尺寸增大。
## Quick build/analysis cycles
可以在构建docker镜像时就完成分析，不必等到镜像构建完成之后再分析。
只要将命令 `docker build ...` 替换成 `dive build ...` 即可。

## CI Integration
设置环境变量 `export CI=true`，可完全黑屏文本输出结果。


## Multiple Image Sources and Container Engines Supported

支持多种镜像来源（source） : docker, docker-archive, podman

```shell
dive <your-image> --source <source>
dive <source>://<your-image>
```


# 安装
```shell
brew install dive
dive docker.io/library/eclipse-temurin:11-jdk-alpine
```

 