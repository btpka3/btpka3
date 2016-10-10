* 《[用Markdown来写自由书籍-开源技术的方案](http://www.ituring.com.cn/article/828)》
* [简书](http://www.jianshu.com/) —— 使用MarkDown来写文章和博客。
* [作业部落](https://www.zybuluo.com/) —— HTTPS加密链接，可离线编辑，更多功能支持，作者即将推出 Linux/Windows/Mac 全平台客户端
* [gitbook](https://www.gitbook.com/)

* jekyll
* pandoc. 如果想转成PDF文件，要安装LATEX。推荐安装MiKTex。但是，中文转PDF，因latex支持中文差，转换有问题。

    ```
    pandoc -s                            \
           -S                            \
           --filter pandoc-citeproc      \
           --biblio all.bib              \
           --csl apa6.csl                \
           --latex-engine=xelatex        \
           --template=template.latex     \
           --variable mainfont="Georgia" \
           --variable fontsize=12pt      \
           --toc                         \
           all.md                        \
           -o all.pdf
    ```
* https://github.com/progit/progit
* https://github.com/WebBooks/wbb
* [Calibre2](http://calibre-ebook.com/)
* http://www.douban.com/note/330859852/

```
sudo apt-get install texlive  # texlive-full
```