
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
```


# 按照字段筛选
```shell
json='[
    {"t":"a","name":"a1","age":11},
    {"t":"b","name":"b1","age":21},
    {"t":"a","name":"a2","age":12},
    {"t":"b","name":"b2","age":22}
]'
echo "$json" | jq -c '.[]|select(.t == "a")'
# 输出
{"t":"a","name":"a1","age":11}
{"t":"a","name":"a2","age":12}
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
cat > /tmp/demo.json.log <<EOF
{"level":"ERROR","count":44}
{"level":"INFO","count":22}
{"level":"ERROR","count":33}
{"level":"INFO","count":11}
EOF

cat /tmp/demo.json.log | jq -r 'select(.level == "INFO")|.count|tostring' | sort
```


# 把key替换成值
```shell
cat > /tmp/demo.json.log <<EOF
{"user":"stedolan","titles":["JQ Primer", "More JQ"]}
EOF
cat /tmp/demo.json.log | jq -r '{(.user): .titles}|tostring'
```
