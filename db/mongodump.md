# 备份

```bash

# 每个 collection 一个 gzip压缩的文件
mongodump \
    --host 192.168.0.12 \
    --port 27017 \
    --username dev2_4 \
    --password dev2_4 \
    --db dev2_4 \
    --gzip \
    --out /tmp/zll

# 多有 collection 压缩后打包在一个文件内 FIMME: 暂不要用，见下文
mongodump \
    --host 192.168.0.12 \
    --port 27017 \
    --username dev2_4 \
    --password dev2_4 \
    --db dev2_4 \
    --gzip \
    --archive=/tmp/zll/dev2_4.`date +%Y%m%d%H%M%S`.gz
```

# 恢复

```bash
# 从包含多个 gzip 压缩文件的目录中恢复
mongorestore \
    --host 192.168.0.12 \
    --port 27017 \
    --username zll_test \
    --password zll_test \
    --db zll_test \
    --gzip \
    --dir /tmp/zll/dev2_4

# 从单个 gzip 压缩 archive 中恢复。
# FIXME : r3.2.7 版本的 mongorestore 未能成功
# 参考 https://jira.mongodb.org/browse/TOOLS-1073
# 参考 https://jira.mongodb.org/browse/TOOLS-1234
mongorestore \
    --host=192.168.0.12 \
    --port=27017 \
    --username=zll_test \
    --password=zll_test \
    --db=zll_test \
    --gzip \
    --archive=/tmp/zll/dev2_4.20170518181234.gz
```


