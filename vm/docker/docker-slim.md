

# 简介 

[docker-slim](https://github.com/docker-slim/docker-slim) 可通过静态分析得出所要使用的实际文件，从而减小文件尺寸。

```bash
docker-slim info  xxxImage   # 解析 image 的信息 
docker-slim build xxxImage   # 解析 image 的信息，并构建一个裁剪后的版本。期间需要运行起来目标进行以便进行分析。
```
