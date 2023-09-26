- github : [dragonflyoss/Dragonfly2](https://github.com/dragonflyoss/Dragonfly2)
- doc : [d7y.io](https://d7y.io/zh/docs/next/)
    - [dfcache](https://d7y.io/zh/docs/next/reference/cli/dfcache)




# dfget

## 配置
Dfdaemon / 《[配置 Dfdaemon YAML 文件](https://d7y.io/zh/docs/next/reference/configuration/dfdaemon)》


## 作为客户端

```shell
dfget version
dfget -h

ls -l /home/staragent/plugins/dragonfly/dfget 

# 下载: http
dfget -O /path/to/output -u "http://example.com/object"

# 下载: 阿里云OSS
dfget --header "Endpoint: https://oss-cn-hangzhou.aliyuncs.com" \
    --header "AccessKeyID: id" \
    --header "AccessKeySecret: secret" \
    --url oss://bucket/path/to/object \
    --output /path/to/output \
    --filter "Expires&Signature"
```

## 作为服务端

```shell
dfget daemon 
```


# dfcache
# dfstore
