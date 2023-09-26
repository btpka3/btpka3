
[yaml.org](https://yaml.org/)

# 多行文本
Block Scalars : 

- scalar header
    - block style indicator
        - `|` : 表示保留换行符
        - `>` : 表示将 换行符 替换为 空格。 注意：如果有空行的话，会保留空行的换行符。
    - block chomping indicator
        - `-` : 删除字符串后面的所有空行
        - `+` : 保留字符串后面的所有空行
        - 空  : 字符串后面仅保留一行空行

## 示例

注意：行尾有3个空格

```yaml
key101 : |-
  aa bb   
  cc dd   
  
  ff  gg   


key102 : |+
  aa bb   
  cc dd   
  
  ff  gg   


key103 : |
  aa bb   
  cc dd   
  
  ff  gg   


key201 : >-
  aa bb   
  cc dd   
  
  ff  gg   


key202 : >+
  aa bb   
  cc dd   
  
  ff  gg   


key203 : >
  aa bb   
  cc dd   
  
  ff  gg   


demo: demo
```

加载后转 JSON 的输出

```json
{
  "key101" : "aa bb   \ncc dd   \n\nff  gg   ",
  "key102" : "aa bb   \ncc dd   \n\nff  gg   \n\n\n",
  "key103" : "aa bb   \ncc dd   \n\nff  gg   \n",
  "key201" : "aa bb    cc dd   \nff  gg   ",
  "key202" : "aa bb    cc dd   \nff  gg   \n\n\n",
  "key203" : "aa bb    cc dd   \nff  gg   \n",
  "demo" : "demo"
}
```