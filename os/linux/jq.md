
-[jq Manual](https://stedolan.github.io/jq/manual/)
    - xq
    - yq

```bash
curl -fsSL https://github.com/jqlang/jq/releases/download/jq-1.7/jq-linux-amd64 -o /tmp/jq-linux-amd64
docker run --rm -it -v /tmp/jq-linux-amd64:/jq-linux-amd64  docker.io/library/alpine:3.18 sh -l

# 输入文件：多行，一行一个JSON，且有String类型的字段 data
# 作用：将单行当做json解析，提取 data , 并输出
jq -r -R 'fromjson|.data' 20220414_productvideo.txt > 20220414_productvideo.data.txt
```

# 输出字段
```shell
json='{"x":[
    {"t":"a","name":"a1","age":11},
    {"t":"b","name":"b1","age":21},
    {"t":"a","name":"a2","age":12},
    {"t":"b","name":"b2","age":22}
]}'
echo "$json" | jq -r -c '.x[].name'
# 输出
a1
b1
a2
b2

echo "$json" | jq -r -c '[.x[].name]'
# 输出
["a1","b1","a2","b2"]


json='{
    "aaa": {"t":"a","name":"a1","age":11},
    "bbb": {"t":"b","name":"b1","age":21},
    "ccc": {"t":"a","name":"a2","age":12},
    "ddd": {"t":"b","name":"b2","age":22}
}'
echo "$json" | jq -r '[to_entries|.[]|.value.x=.key|.value]'
# 输出
[
  {
    "t": "a",
    "name": "a1",
    "age": 11,
    "x": "aaa"
  },
  {
    "t": "b",
    "name": "b1",
    "age": 21,
    "x": "bbb"
  },
  {
    "t": "a",
    "name": "a2",
    "age": 12,
    "x": "ccc"
  },
  {
    "t": "b",
    "name": "b2",
    "age": 22,
    "x": "ddd"
  }
]
```

# 单行输出
```shell
json='{
   "a": "a1",
   "b": "b1"
}'
echo "$json" | jq -r -c
# 输出
{"a":"a1","b":"b1"}
```


# 按照字段筛选
```shell
json='[
    {"t":"a","name":"a1","age":11},
    {"t":"b","name":"b1","age":21},
    {"t":"a","name":"a2","age":12},
    {"t":"b","name":"b2","age":22}
]'
# 通过 .[] 对对象的属性展开，过滤，但结果是多个值。
echo "$json" | jq -c '.[]|select(.t == "a")'
# 输出
{"t":"a","name":"a1","age":11}
{"t":"a","name":"a2","age":12}

# 通过 map 过滤，并保持最后是单个结果
echo "$json" | jq -r 'map(select(.t == "a"))'
# 输出
[
  {
    "t": "a",
    "name": "a1",
    "age": 11
  },
  {
    "t": "a",
    "name": "a2",
    "age": 12
  }
]


json='{
   "classLoaders": [
     {
        "classes": [
            {"className":"aaa", "size":10},
            {"className":"bbb", "size":20}
        ]
     },
     {
        "classes": [
            {"className":"ccc", "size":10},
            {"className":"ddd", "size":20}
        ]
     }
   ]
}'
echo "$json" | jq -r '.classLoaders[]|.classes[]|select(.size > 10)'

```

# any/all
等价于java的 Stream#anyMatch,Stream#allMatch,

```shell
json='[
    {"name":"a1","hobbies":["aaa","bbb","ccc"]},
    {"name":"a2","hobbies":["bbb","ccc","ddd"]},
    {"name":"a3","hobbies":["ccc","ddd","eee"]},
    {"name":"a4","hobbies":["aaa","aaa","aaa"]}
]'
echo "$json" | jq -c '.[]|select(any(.hobbies; .[] == "bbb"))'
echo "$json" | jq -c '.[]|select(all(.hobbies; .[] != "eee"))'
# 注意：如果数组中 全部都 满足 any 的条件，此时结果是不匹配的（🤔🤔🤔 WHY???)
# 下面的这个将不会输出全部都是 "aaa" 的记录
echo "$json" | jq -c '.[]|select(any(.hobbies; .[] == "aaa"))'
```

# diff
```shell
diff <(jq '.nodes[].ruleId' rollback.json | sort)  <(jq '.nodes[].ruleId' fix.json | sort)
```


# 输出表格
```shell
json='[
    {"t":"a","name":"a1","age":11},
    {"t":"b","name":"b1","age":21},
    {"t":"a","name":"a2","age":12},
    {"t":"b","name":"b2","age":22}
]'

# 缺点：未对齐
echo "$json" | jq -r '["T","NAME","AGE"], ["--","------","------"], (.[]|[.t, .name, .age]) | @tsv'
T	NAME	AGE
--	------	------
a	a1	11
b	b1	21
a	a2	12
b	b2	22


# 缺点：有双引号
echo "$json" | jq -r '["T","NAME","AGE"], (.[]|[.t, .name, .age]) |@csv' | column  -s, -t
"T"  "NAME"  "AGE"
"a"  "a1"    11
"b"  "b1"    21
"a"  "a2"    12
"b"  "b2"    22

# Prefect
echo "$json" | jq -r '["T","NAME","AGE"], (.[]|[.t, .name, .age]) | @tsv' | column -ts $'\t'
T  NAME  AGE
a  a1    11
b  b1    21
a  a2    12
b  b2    22
```


# reduce

```shell
json='[1,2,3,4,5]'
echo "${json}" | jq 'reduce .[] as $item (0; . + $item)'
# Output : 15

json='
{
    "a1":["a101","a102"],
    "b1":["b101","b102"],
    "a2":["a201","a202"],
    "b2":["b201","b202"]
}
'
echo "${json}" | jq -r '
to_entries | map()
[

    |.[]
    |select(.key | test( "^a"; "x"))
    |from_entries
]
'

```


# 自定义函数
## 单个 to_port
```shell
json='
{
    "name": "http",
    "nodePort": 30001,
    "port": 7001,
    "protocol": "TCP",
    "targetPort": 7001
}
'

echo "$json" | jq -r '
    def to_port: (.port|tostring) + ":" + (.nodePort|tostring) + "/" + (.protocol|tostring);
    .|to_port
'
```

## 数组 to_port
```shell
json='
[
    {
        "name": "http",
        "nodePort": 30001,
        "port": 7001,
        "protocol": "TCP",
        "targetPort": 7001
    },
    {
        "name": "http",
        "nodePort": 30002,
        "port": 7002,
        "protocol": "UDP",
        "targetPort": 7002
    }
]
'

echo "$json" | jq -r '
    def to_port: (.port|tostring) + ":" + (.nodePort|tostring) + "/" + (.protocol|tostring);
    map(.|to_port)|join(",")
'
```



```shell
json='
{
    "apiVersion": "v1",
    "items": [
        {
            "apiVersion": "v1",
            "kind": "Service",
            "metadata": {
                "name": "blackcat"
            },
            "spec": {
                "clusterIP": "10.107.36.125",
                "type": "NodePort",
                "ports": [
                    {
                        "name": "http",
                        "nodePort": 30001,
                        "port": 7001,
                        "protocol": "TCP",
                        "targetPort": 7001
                    },
                    {
                        "name": "7002tcp",
                        "nodePort": 30002,
                        "port": 7002,
                        "protocol": "TCP",
                        "targetPort": 7002
                    },
                    {
                        "name": "8000deb",
                        "nodePort": 30003,
                        "port": 8000,
                        "protocol": "TCP",
                        "targetPort": 8000
                    }
                ]
            }
        },
        {
            "apiVersion": "v1",
            "kind": "Service",
            "metadata": {
                "name": "zk-ui"
            },
            "spec": {
                "clusterIP": "10.96.62.109",
                "type": "NodePort",
                "ports": [
                    {
                        "name": "http",
                        "port": 9000,
                        "protocol": "TCP",
                        "targetPort": 9000
                    }
                ]
            }
        }
   ]
}
'

echo "$json" | jq -r '
    def to_port: (.port|tostring) + ":" + (.nodePort|tostring) + "/" + (.protocol|tostring);

    ["NAME", "TYPE", "CLUSTER-IP", "PORT(S)"],
    (
       .items[]
       | select(.spec.type=="NodePort")
       | [
          .metadata.name,
          .spec.type,
          .spec.clusterIP,
          (.spec.ports|map(.|to_port)|join(","))
      ]
    )
    | @tsv
' | column -ts $'\t'
```

# object key-value字符串拼接

```shell
json='
[
    {"a": "a1","b": "b1"},
    {"a": "a2","b": "b2"}
]
'

echo "$json" | jq -r '
    def to_port: (.port|tostring) + ":" + (.nodePort|tostring) + "/" + (.protocol|tostring);
   .[]|to_entries|map(.key + "=" + .value)|join(",")
'
# 结果
a=a1,b=b1
a=a2,b=b2
```


# pretty

```shell
jq . fminified.json
```

# 压缩/minify
```shell
# 字符串
echo '{ "foo": "bar" }' | jq -r tostring
echo '{ "foo": "bar" }' | jq -r tostring > minified.json

# 文件
jq -r tostring file.json
jq -r tostring file.json > minified.json
```


# 多行JSON日志

```shell
json='
{"level":"ERROR","count":44}
{"level":"INFO","count":22}
{"level":"ERROR","count":33}
{"level":"INFO","count":11}
'

echo "${json}" | jq -r 'select(.level == "INFO")|.count|tostring' | sort
```


# 把key替换成值
```shell
json='
{"user":"stedolan","titles":["JQ Primer", "More JQ"]}
'
echo "${json}" | jq -r '{(.user): .titles}|tostring'
```


# 按照 key 过滤
等价于java的 Stream#filter

```shell
json='
{
    "a1":["a101","a102"],
    "b1":["b101","b102"],
    "a2":["a201","a202"],
    "b2":["b201","b202"]
}
'

echo "${json}" | jq -r 'to_entries|.[]|select(.key | test( "^a"; "x"))|.value'

# 重新合并成成对应的对象: 通过 to_entries + from_entries
echo "${json}" | jq -r '[to_entries|.[]|select(.key | test( "^a"; "x"))]|from_entries'
# 重新合并成成对应的对象: 通过 with_entries
echo "${json}" | jq -r 'with_entries(select(.key | test( "^a"; "x")))'
```

# 数组、对象展开
等价于java的 Stream#flatMap


```shell
################ 示例1. 内部是数组
json='
{"name":"333","hobbies":["a201","a202"]}
'
echo "${json}" | jq -c '{name,hobby:.hobbies[]}'
# 输出:
# {"name":"333","hobby":"a201"}
# {"name":"333","hobby":"a202"}

################ 示例2. 内部是对象: 使用 对象+对象
json='
{"name":"333","addr":{"provice":"henan", "city":"luoyang"}}
'
echo "${json}" | jq -c '{name}+.addr'
# 输出:
# {"name":"333","provice":"henan","city":"luoyang"}

################ 示例3. 复杂case
json='
{
    "x1":[
        {"name":"111","hobbies":["a101","a102"]},
        {"name":"222","hobbies":["b101","b102"]}
     ],
    "x2":[
        {"name":"333","hobbies":["a201","a202"]},
        {"name":"444","hobbies":["b201","b202"]}
    ]
}
'
echo "${json}" | jq -c 'to_entries|.[]|{"room":.key} + .value[]'
# 输出:
# {"room":"x1","name":"111","hobbies":["a101","a102"]}
# {"room":"x1","name":"222","hobbies":["b101","b102"]}
# {"room":"x2","name":"333","hobbies":["a201","a202"]}
# {"room":"x2","name":"444","hobbies":["b201","b202"]}
echo "${json}" | jq -c 'to_entries|.[]|{"room":.key} + .value[]| del(.hobbies) + {hobby:.hobbies[]}'
# 输出:
# {"room":"x1","name":"111","hobby":"a101"}
# {"room":"x1","name":"111","hobby":"a102"}
# {"room":"x1","name":"222","hobby":"b101"}
# {"room":"x1","name":"222","hobby":"b102"}
# {"room":"x2","name":"333","hobby":"a201"}
# {"room":"x2","name":"333","hobby":"a202"}
# {"room":"x2","name":"444","hobby":"b201"}
# {"room":"x2","name":"444","hobby":"b202"}
```





# 阿里云SLS user_log_config.json 列出采集的文件


```shell
# 输出 \t 分隔的以下信息
# 阿里云主账号,日志路径,  文件名,        SLS project,   SLS logstore
# aliuid,    log_path, file_pattern, project_name, category

cat user_log_config.json  | jq -r '
.metrics
|map([.aliuid, .log_path, .file_pattern, .project_name, .category])
|sort_by(.[0], .[1], .[2], .[3], .[4])
|.[]
|@tsv
'

# 列出 max_depth>0 的配置
cat user_log_config.json  | jq -r '.metrics|with_entries(select(.value.max_depth>0))'

# 列出 max_depth>0 的配置, 并转成终端表格
tsvStr=$(cat user_log_config.json  \
| jq -r '
[
    .metrics
    |to_entries
    |.[]
    |select(.value.max_depth>0)
    |.sls_logtail = (.key |split("$")[1])
    |[
        .value.aliuid,
        .value.project_name,
        .value.category,
        .sls_logtail,
        .value.max_depth,
        .value.log_path,
        .value.file_pattern
    ]
]
|sort_by(.[0], .[1], .[2], .[3], .[4], .[5], .[6])
|.[]
|@tsv
' )
headStr=$'ALIYUN_USERID\tSLS_PROJECT\tSLS_LOGSTORE\tSLS_LOGTAIL\tMAX_DEPTH\tLOG_PATH\tFILE_PATTERN\n'
echo "${headStr}${tsvStr}" | column -t -s $'\t'



```
