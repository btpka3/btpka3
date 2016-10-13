
# 参考

* [GitBook Help Center](https://help.gitbook.com/)
* [gitbook@github](https://github.com/GitbookIO/gitbook)
* [GitBook Toolchain Documentation](http://toolchain.gitbook.com/)


```sh
npm install gitbook-cli -g
cd youBookRootDir
gitbook init
gitbook serve

# gitbook build ./ --log=debug --debug
gitbook build

```

目录结构

```txt
.
├── cover.jpg           // 可选: 转换为电子书时,使用的封面
├── book.json           // 可选: 配置文件
├── README.md           // 必须: 前言、简介
├── SUMMARY.md          // 必须: ToC 目录
├── GLOSSARY.md         // 可选: 术语表
├── chapter-1/      
|   ├── README.md       // 每个章节特定的说明文档
|   └── something.md
└── chapter-2/
    ├── README.md
    └── something.md
```

gitbook 从 `.gitignore`, `.bookignore` 和 `.ignore` 中读取要忽略的文件。
其他静态文件都复制到输出目录中

# 插件

```
# 1. 先修改 book.json 追加plugins的名称
plugins : ["mathjax"]

# 2. 再在命令安装插件
gitbook install

```

常用插件

* [mathjax](https://plugins.gitbook.com/plugin/mathjax) 

$$x=\frac{-b\pm\sqrt{b^2-4ac}}{2a}$$
\\(x=\frac{-b\pm\sqrt{b^2-4ac}}{2a}\\)




# 输出

需要先[安装](http://toolchain.gitbook.com/ebook.html)一定的必要软件, 比如 [calibre](https://calibre-ebook.com/download)。


```
sudo ln -s /Applications/calibre.app/Contents/MacOS/ebook-convert /usr/bin


# 生成各种格式
gitbook pdf ./ ./mybook.pdf
gitbook epub ./ ./mybook.epub

```