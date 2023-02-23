
-[jq Manual](https://stedolan.github.io/jq/manual/)

```bash
# 输入文件：多行，一行一个JSON，且有String类型的字段 data
# 作用：将单行当做json解析，提取 data , 并输出
jq -r -R 'fromjson|.data' 20220414_productvideo.txt > 20220414_productvideo.data.txt
```
