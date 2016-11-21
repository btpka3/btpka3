


# 代码块示例
## 方式一

输入代码：
```

    代码块前需要空一个空行、代码块内容需要都缩进4个空格
    这种方法不能用在List中、无法指定着色语法
    echo 1+2
    echo hello world
```

结果示例：

    代码块前需要空一个空行、代码块内容需要都缩进4个空格
    这种方法不能用在List中、无法指定着色语法
    echo 1+2
    echo hello world

## 方式二
输入代码：

    
    ```
    代码块前需要空一个空行
    如果要嵌套到List中，代码块内容需要都缩进4*N个空格。
    echo 1+2
    echo hello world
    ```
结果示例：

```
代码块前需要空一个空行
如果要嵌套到List中，代码块内容需要都缩进4*N个空格。
echo 1+2
echo hello world
```

# List 示例

```bash
no indent code block
```
* level1-1

    ```bash
# echo hello world
需要将 ```bash  和 ``` 缩进4个空格。
    ```
    indent * 1 paragraph (ending with two space)  
    indent * 1 paragraph
    1. level2-1
        indent * 1 paragraph (ending with two space)  
        indent * 1 paragraph

        ```bash
# echo hello world
        ```
    1. level2-2
* level1-1
    1. aaa
    2. bbb

```bash
# vi /etc/profile.d/his.sh
#!/bin/bash
export JAVA_HOME=/x/x/x
```



# 表格示例


| Tables        | Are           | Cool |
| ----------------- |---------------| ------|
| col 3 is      | right-aligned | $1600 |
| col 2 is      | centered      |   $12 |
| zebra stripes | are neat      |    $1 |