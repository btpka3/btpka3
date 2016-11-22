
# 参考

* [GitBook Help Center](https://help.gitbook.com/)
* [gitbook@github](https://github.com/GitbookIO/gitbook)
* [GitBook Toolchain Documentation](http://toolchain.gitbook.com/)


```bash
npm install gitbook-cli -g
cd youBookRootDir
gitbook init
gitbook serve

# gitbook build ./ --log=debug --debug
gitbook build

```

目录结构

```
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

## 插件 - prism
[prism](https://plugins.gitbook.com/plugin/prism) 插件提供了更好的代码着色配置。
但是在本地启动过程中，如果发现控制台有提示 `{ [Error: Cannot find module 'prismjs/components/prism-cfg.js'] code: 'MODULE_NOT_FOUND' }` 这样的提示，
务必请查找并修改为 prism 支持的语法类型。该类型可以在 `./node_modules/prismjs/components` 目录下通过文件名来快速判别。

### 使用其他的主题？

确保你的book目录中有 package.json （可以通过 `npm init` 创建）

```bash
npm install --save prism-themes
```

修改 book.json 

```json
{
  "pluginsConfig": {
    "prism": {
      "css": [
        "prism-themes/themes/prism-duotone-dark.css"
      ]
    }
  }
}
```


# 主题

[theme-default](https://github.com/GitbookIO/theme-default) 是默认主题。

# 字体

[fontsettings](https://plugins.gitbook.com/plugin/fontsettings)