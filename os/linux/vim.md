CentOS 的最小化安装默认只安装了最小版的VI，可以通过以下命令安装全部功能的Vim：
```bash
yum install vim-common vim-enhanced vim-minimal
sudo apt-get install vim
```





修改环境变量
```bash
[root@h01 ~]# vi /etc/profile.d/custom.sh
alias vi=vim
```
或者
```bash
[root@h01 ~]# vi ~/.bashrc
alias vi=vim
```

# 修改vim配置文件
修改用户级别的 需要修改 `~/.vimrc`。修改全局的，
需要修改 `/etc/vimrc` , 或者 `/etc/vim/vimrc` , 或者 `/etc/vim/vimrc.local`（可以通过 `:version` 看到）

```vim
set nocompatible
set number
colors desert
syntax on
set ruler
set showcmd
set cursorline
set fileencodings=utf-8,gbk
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set fileformats=unix
set hlsearch
set formatoptions-=cro
set paste
set mouse=i
" set list
" comment here
```

## filetype

`vi ~/.vim/filetype.vim`, 在 vim 中可以通过 `:set syntax?` 查看当前 syntax 的值

```bash
autocmd BufRead,BufNewFile my.cnf set syntax=dosini
autocmd BufRead,BufNewFile build.gradle set syntax=groovy
```

## 使用不同的编码重新加载文件

```bash
:e ++enc=gbk
```

## Mac OS X 下的 plist文件着色

彩色查看 `/Library/LaunchDaemons` 目录下文件
[vim-plist](https://github.com/darfink/vim-plist)

```
git clone git://github.com/darfink/vim-plist.git ~/.vim/bundle/vim-plist
```
## colorschema

```bash
ll /usr/share/vim/vim74/colors
# 或者在vim中
:colo <tab>
```

## 安装vba插件
[largeFile](http://www.drchip.org/astronaut/vim/#LARGEFILE),
[Manual](http://www.drchip.org/astronaut/vim/doc/LargeFile.txt.html)
wget http://www.drchip.org/astronaut/vim/vbafiles/LargeFile.vba.gz
gunzip LargeFile.vba.gz
vi LargeFile.vba
:source %
```


:source %

```

## 将换行符从dos格式变为unix格式
参考：[1](http://vim.wikia.com/wiki/File_format)
```
:update	                 Save any changes.
:e ++ff=dos	         Edit file again, using dos file format ('fileformats' is ignored).
:setlocal ff=unix	 This buffer will use LF-only line endings when written.
:w	                 Write buffer using unix (LF-only) line endings.
```

删除行尾换行符

```
:set noendofline binary
:w
```

十六进制编辑

```
:%!xxd
```


* 删除BOM头

```bash
:set nobomb
:wq
```
## 查找

```bash
# see : https://blog.csdn.net/u014015972/article/details/50688837
/+\d\+      # 查找 "+1", "+11"

# https://vimhelp.org/pattern.txt.html#%2F%5C%25x
/\%01       # 查找 ^A
/\%02       # 查找 ^B
```


## 全局替换
- [Power of g](https://vim.fandom.com/wiki/Power_of_g)

```bash
:%s/\t/    /g

:g/^$/d         # 删除空行

```

## 查找替换

```bash
:range s[ubstitute]/pattern/string/cgiI

range
    100     # 第100行
    .       # 当前行
    $       # 文件的最后一行
    %       # 整个文件，与【1,$】相同
‘t              # 标记t
/pattern[/]     # pattern的下一个匹配行
?pattern[?]     # pattern的上一个匹配行
\/              # 最近一个搜索pattern的下一个匹配行
\?              # 最近一个搜索pattern的上一个匹配行
\&              # 最近一个替换pattern的下一个匹配行

c 每次替换都要确认
g 替换一行当中所有的匹配项（没有g只替换第一个匹配值，pingao注：注意与%区别）
i 忽略大小写
I 不忽略大小写

```

## MacOS 无法copy ssh +vim 的内容

https://stackoverflow.com/a/42433989/533317

```bash
:set mouse=i
```


## tab
```bash
# 显示空白字符
:set list

# 替换为空格
:%s/\t/    /g

# 不显示空白字符
:set nolist
```


# 命令模式

```vim
# 文件
:open pathToFile                # 打开指定的文件
:bn                             # 查看下一个文件
:bp                             # 查看上一个文件
:args                           # 查看当前打开的文件列表
:split pathToFile               # 在分割窗口中打开指定的文件
Ctrl+ww                         # 在分割窗口中循环切换文件
:e ftp://192.168.1.101/xxx.txt  # 打开远程文件（FTP）
:e \\sambahost\share\xxx.txt    # 打开远程文件（Samba）
:set binary noeol               # 重要，vim默认会追加一个0xOA(换行符)，可以通过该设置不追加，否则会影响md5sum等计算。


# 光标移动
h                               # 左移1个字符（可前接数字）
l                               # 右移1个字符（可前接数字）
k                               # 上移1行（可前接数字）
j                               # 下移1行（可前接数字）
gg                              # 跳到第一行（可前接数字）
G                               # 跳到最后一行

Ctrl+F / PageDown               # 下一页
Ctrl+B / PageUp                 # 上一页

^                               # 移至行首第一个非空白字符
0                               # 移至行首
<Home>                          # 移至行首
$                               # 移至行尾（可前接数字）
<End>                           # 移至行尾

w                               # 向后移动1个单词，光标停在单词首部（可前接数字）
b                               # 向后移动1个单词，光标停在单词首部（可前接数字）
e                               # 向后移动1个单词，光标停在单词尾部（可前接数字）
ge                              # 向后移动1个单词，光标停在单词尾部（可前接数字）

# 缩进
<<                              # 当前行向左缩进
>>                              # 当前行向右缩进

dd                              # 删除当前行
dw                              # 删除一个词

yy                              # 复制当前行

[,c                             # 跳转至上次修改的地方
],c                             # 跳转至下次修改的地方


查看当前set的值
:set expandtab?                 # 打印该选项的使用方法和值
:set autoindent!                # 该选项值取反（针对bool型）
:set option&                    # 重置该选项值为默认值
:verbose set textwidth?         # 查看值


# 进入插入模式
i                               # 在当前光标位置前插入
I                               # 在当前行的行首插入
a                               # 在当前光标位置后插入
A                               # 在当前行的行尾插入
o                               # 在当前行之后插入一行
O                               # 在当前行之前插入一行

# 进入 visual 模式
v
```

# 插入模式

```vim
# 缩进
C-d                             # 当前行向左缩进
C-t                             # 当前行向右缩进
```

# visual 模式

```vim
<                               # 当前选区向左缩进
>                               # 当前选区向右缩进
```


## diff
```shell
vi -d file1 file2
ctrl + W + W                # 切换窗口
:diffput                    # 将当前高亮的diff，从左窗口应用到右窗口
:diffget                    # 将当前高亮的diff，从右窗口应用到左窗口
u                           # 撤销应用的diff
:diffupdate                 # 重新使用上传撤销应用的diff
```
