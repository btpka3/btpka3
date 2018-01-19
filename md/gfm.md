

# 一级标题
## 二级标题
### 三级标题
#### 四级标题
##### 五级标题
###### 六级标题

## 引用

> 这是
> 一大块儿的
>> 级联原文引用
>
> 和原文引用
> ## This is a header.
>
> 1.   This is the first list item.
> 2.   This is the second list item.
>
> Here's some example code:
>
>     return shell_exec("echo $input | $markdown_script");



## 文本
这里是 *斜体文本* 、 **加粗文本**、~~有删除线的文本~~、`printf()`、


## 链接

* [github](https://www.github.com)
* [baidu](https://www.baidu.com "百度")

---------------------------------------

* [网易][163]
* [腾讯][qq]
* [Google][]
![微信图标][wx_logo]

[163]: http://news.163.com/  "网易新闻"


## 代码块

[qq]: http://news.qq.com/  "腾讯新闻"
[Google]: http://google.com/ (谷歌在中国已经不能访问了)
[wx_logo]: https://res.wx.qq.com/mpres/htmledition/images/bg/bg_logo2491a6.png

```ruby
require 'redcarpet'
markdown = Redcarpet.new("Hello World!")
puts markdown.to_html
```

## 列表

* 列表1
* 列表2
   1. 列表21
   1. 列表22
   1. 列表23
       1. 列表231
       1. 列表232
       1. 列表233
* 列表3
   * 列表31
   * 列表32
   * 列表33
       * 列表331
       * 列表332
       * 列表333





~~删除线文本~~

| 表头1  | Second Header |
| ------------- | ------------- |
| 内容  | Content Cell  |
| 内容  | Content Cell  |