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

修改vim配置文件
```sh
[root@h01 ~]# vi ~/.vimrc
set number
“ comment here
colors desert
syntax on
set ruler
set showcmd
set cursorline
set fileencodings=utf-8,gbk
set list
set expandtab
set tabstop=4
set fileformats=unix
```
## 将换行符从dos格式变为unix格式
参考：[1](http://vim.wikia.com/wiki/File_format)
```
:update	                 Save any changes.
:e ++ff=dos	         Edit file again, using dos file format ('fileformats' is ignored).
:setlocal ff=unix	 This buffer will use LF-only line endings when written.
:w	                 Write buffer using unix (LF-only) line endings.
```