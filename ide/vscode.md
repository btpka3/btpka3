

```
# 使用命令行
1. 打开 visual studio code
2. 打开 Command Palette (F1)， 并输入 'shell command',
   并选择命令 `Shell Command: Install 'code' command in PATH`
3. 新开命令行窗口，输入 `code`, 如果要打开当前目录，输入 `code .` 即可。
```


## 常用操作

* 行排序

    1. 选中要排序的行
    1. <kbd>F1</kbd> 或者 <kbd>Ctrl + Shift + P</kbd> 或者 <kbd>Cmd + Shift + P</kbd>
    1. 输入 `sort`
    1. 选择 `Sort Lines Ascending` 或者 `Sort Lines Descending`

* 切换语言 ：
    1. <kbd>F1</kbd> 或者 <kbd>Ctrl + Shift + P</kbd> 或者 <kbd>Cmd + Shift + P</kbd>
    1. 输入选择 ">Change Language Mode"
    1. 再选择对应的 语言

## 常用插件

* [Sort lines](https://marketplace.visualstudio.com/items?itemName=Tyriar.sort-lines)
    注意：该插件的基础功能在 vsc 中已经提供了。


    ```
    # 使用
    1. 选中要排序的文本
    2. 按 F1，
    3. 输入 `sort`,
    4. 并选择相应的排序操作。
    ```



# 快捷键

```txt
Cmd + K, M          : Select Language Model
Shift + Alt + F     : 格式化代码
Cmd + Shift + P     : 打开命令面板
F1                  : 打开命令面板
```


# 浏览器中使用
- [Monaco Editor](https://microsoft.github.io/monaco-editor/index.html)
- [ace](https://ace.c9.io/#nav=embedding)
  - 没有 diff 功能
- [code server](https://github.com/coder/code-server)
