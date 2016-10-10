
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
├── book.json           // 配置文件
├── README.md           // 前言、简介
├── SUMMARY.md          // ToC 目录
├── GLOSSARY.md         // 术语表
├── chapter-1/      
|   ├── README.md
|   └── something.md
└── chapter-2/
    ├── README.md
    └── something.md
```

gitbook 从 `.gitignore`, `.bookignore` 和 `.ignore` 中读取要忽略的文件。
其他静态文件都复制到输出目录中