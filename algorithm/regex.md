

正则表达式

参考[java.util.regex.Pattern](http://docs.oracle.com/javase/7/docs/api/index.html?java/util/regex/Pattern.html)

* Q: 为何 在Ecipse中 `.*` 为嘛只能匹配到光标～行尾的内容，不含换行符？ `.*\n` 则可以一次匹配每一行，设置空行？

    A: `.`在Java中默认是不匹配换行符的。可以在编程时设置 `Pattern.DOTALL`，或者通过表达式 `(?s).*` 来使 `.` 匹配任意字符。此时， `(?s).*\n` 会从光标处匹配到最后一个换行符。



# java.util.Scanner
不足：

1. 所有与next相关的方法都必须使用分隔符，有时很不方便。
1. ???没有后圆括弧的记录为何需要很长的扫描时间？
1. findInLine() 对超长行会开辟内存，直到能放下完整的一行，会严重消耗内存。
1. findWithinHorizon() 不能将当前位置作为起始位置与 ^ 进行严格匹配。
1. findWithinHorizon() 之后，没有使内部buf.compact()的方法。



