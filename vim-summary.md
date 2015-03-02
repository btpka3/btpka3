## 安装
CentOS 的最小化安装默认只安装了最小版的VI，可以通过以下命令安装全部功能的Vim：
```sh
[root@h01 ~]# yum install vim-X11 vim-common vim-enhanced vim-minimal
```

修改环境变量
```sh
[root@h01 ~]# vi /etc/profile.d/custom.sh
alias vi=vim
```
或者
```sh
[root@h01 ~]# vi ~/.bashrc
alias vi=vim
```

# 修改vim配置文件
修改用户级别的 需要修改 `~/.vimrc`。修改全局的，需要修改 `/usr/vimrc` （可以通过 `:version` 看到） 

```vimrc
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
" set list
" comment here
```

## filetype

```sh
vi ~/.vim/filetype.vim              # mysql配置文件语法着色
autocmd BufRead,BufNewFile my.cnf set syntax=dosini
```

## colorschema

```sh
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

* 删除BOM头

```sh
:set nobomb
:wq
```
## 全局替换 

```sh
:%s/\t/    /g
```

## tab
```sh
# 显示空白字符
:set list

# 替换为空格
:%s/\t/    /g

# 不显示空白字符
:set nolist
```


# 命令模式

```vi
# 文件
:open pathToFile                # 打开指定的文件
:bn                             # 查看下一个文件
:bp                             # 查看上一个文件
:args                           # 查看当前打开的文件列表
:split pathToFile               # 在分割窗口中打开指定的文件
Ctrl+ww                         # 在分割窗口中循环切换文件
:e ftp://192.168.1.101/xxx.txt  # 打开远程文件（FTP）
:e \\sambahost\share\xxx.txt    # 打开远程文件（Samba）


# 光标移动
h                               # 左移1个字符（可前接数字）
l                               # 右移1个字符（可前接数字）
k                               # 上移1个字符（可前接数字）
j                               # 下移1个字符（可前接数字）

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

```vi
# 缩进
C-d                             # 当前行向左缩进
C-t                             # 当前行向右缩进
```

# visual 模式

```vi
<                               # 当前选区向左缩进
>                               # 当前选区向右缩进
```