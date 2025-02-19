

[uchardet](https://github.com/BYVoid/uchardet)


## 批量检测，并变更文件编码
```bash
brew install uchardet

uchardet xxx.java

# 修改文件的编码
find . -type f              \
    | grep -v \.idea        \
    | grep -v \.git         \
    | grep -v "/target/"    \
    | grep -v "/fonts/"    \
    | grep -v "/flash/"    \
    | grep -v \.gif \
    | grep -v \.png \
    | grep -v \.swf \
    | xargs -I {} -S 10240 sh -c 'printf "%s %s\n" {} `uchardet {}`' \
    | grep GB18030 \
    | cut -d' ' -f1 \
    | grep \.java \
    | xargs -I {} -S 10240 sh -c 'f="{}"; iconv -f UTF-8 -t GBK ${f} > ${f}.tmp ; mv ${f}.tmp ${f}'


# 修改换行符
find . -type f -name "*.java" \
    | xargs -I {} sh -c 'f="{}"; awk '"'"'BEGIN{RS="\r\n"; ORS="\n"}{print $0}'"'"' ${f} > ${f}.tmp ;  mv ${f}.tmp ${f}'

```





#  检查并代码 encoding 从 GB18030 转换到 UTF-8

```bash
# 批量检查并转换
# uchardet : https://github.com/BYVoid/uchardet
brew install uchardet

find . -type f -name "*.java" \
    | xargs -I {} sh -c 'printf "%s %s\n" {} `uchardet {}`' \
    | grep GB18030 \
    | cut -d' ' -f1 \
    | xargs -I {} sh -c 'f="{}"; iconv -f GB18030 -t UTF-8 ${f} > ${f}.tmp ; mv ${f}.tmp ${f}'

# 少量处理 （Idea Intellj)
# PS: 部分文件可能会被识别成 WINDOWS-1252, ISO-8859-1 等编码，
# 但内容还是有包含中文字符的，这种量少，手动处理即可
Idea Intellij :
1. 文件源码右键 : File encoding : 先选 GB2312 : Reload ，确保能正确显示中文字符
2. 文件源码右键 : File encoding : 再选 UTF-8 : Convert ，再进行转换，存盘
```

# 换行符 "\r\n" -> "\n"

```bash
# 批量处理
# 解释: awk 名利中的 RS 是指读入文件时使用的换行符， ORS 是指打印输出时使用的换行符
find . -type f -name "*.java" \
    | xargs -I {} sh -c 'f="{}"; awk '"'"'BEGIN{RS="\r\n"; ORS="\n"}{print $0}'"'"' ${f} > ${f}.tmp ;  mv ${f}.tmp ${f}'


# 少量处理 （VIM)
vim /path/to/file
:e ++ff=dos	         # 再次编辑文件，使用 DOS 文件格式（换行符是 "\r\n"), 会忽略 fileformats 设定
:setlocal ff=unix	 # VIM  Buffer 中使用换行符 "\n".
:w	                 # 存盘
```

# 使用 editorconfig
事后弥补总不如事前约定，建议使用 [editorconfig](https://editorconfig.org/) 进行配置。
这个被众多IDE 工具支持的。

具体使用的话， 在项目的根目录创建一个 ".editorconfig" 即可。示例内容如下。

```txt
root = true

[*]
end_of_line = lf
insert_final_newline = true

[*.xml]
indent_style = space
indent_size = 4

[*.java]
indent_style = space
indent_size = 4
```

PS: 该文件只主要配置 缩进使用空格还是 "\t", 以及换行符，并不牵涉文件编码。
文件编码还是统一使用 maven，gradle 的工具设定。





