https://help.aliyun.com/zh/oss/developer-reference/install-ossutil


```shell
ossutil help config
ossutil config  -e oss-cn-beijing.aliyuncs.com -i xxx -k xxx
cat ~/.ossutilconfig
[Credentials]
language=EN
endpoint=oss-cn-zhangjiakou.aliyuncs.com
accessKeyID=xxx
accessKeySecret=yyy

ossutil ls oss://uniface-tmp
ossutil cp {} oss://uniface-tmp/dangqian.zll/{}
ossutil cp ww_large_msg.txt oss://content-tmp/dangqian.zll/ww_large_msg.txt
```

