# wiki 说明
“好记性不如烂笔头”，善于总结才能不断积累、前进。

虽说在大学期间（2004～2008）也整理过一些笔记，但是搞IT的，在纸质记事本上记录总结，终归各种不便。
尤其当要提供各种网上资源的链接、总结一些命令/框架的介绍时。
而纸质笔记也不便于长久保存（N年）、再整理、与分享。
因此，那时就开始寻找各种方便的网上博客空间。
尝试过网易博客等，但是最终由于需要方便的贴出一些代码片段（甚至整个文章都是Java代码，靠注释自说明），最终发现在 chinaunix 的博客可以通过引入当时流行的 JS代码着色工具 dp.SyntaxHighlighter 可以插入漂亮的代码，（后来才意识到这是一个很明显的跨站脚本攻击 bug，但后来 chinaunix改过几次版，该bug早已修复），就在 [chinaunix 博客](http://btpka3.blog.chinaunix.net/)上待了几年。

后来，渐渐发现一些不便之处：

1. 博客虽说展示方便，但是，如果代码有些许变动，维护却极不方便。总不能别人用示例代码发现编译不通过吧，那也太丢人了。
1. 自己的总结还是主要以代码为主，不会去码大量的文字说明。为了偷懒，就开始以压缩包为附件提供，而文章内容就一两行。阅读也有些许不便。
1. 自己的示例代码的压缩包的持久保存。当时还没有现在的各种动则几G、几T的云存储。
网易邮箱，qq都只提供几M的存储空间。但是鉴于自己用网易邮箱多，那些部分示例代码压缩包就都放到网易网盘中的。手动维护仍是不便。

因此，作程序员的，版本控制工具还是会一些的，虽然第一个接触的是 vss，但也知道可以免费使用的cvs、svn。
因此开始寻求各种免费的svn空间。适逢当时 google 在中国也是很火，比如 google appengine、 google code。
于是乎，就把各种总结迁移到 google code 了。

后来由于总所周之的原因，谷歌的产品逐渐在国内无法访问。
而 git/markdown 伴随着 github 也逐渐大紫大红起来，于是，偶的代码/博客又从google code 上迁移到了 [github](https://github.com/btpka3/btpka3.github.com) 上。
并将代码使用 git 管理，而文字性总结通过 markdown+git 管理起来。

但鉴于国外的 github 在国内访问不是很稳定，尤其是对 markdown 写的总结可能需要临时频繁修改，龟速是无法忍受的。而 oschina 也在 gitlab 的基础上衍生出了一套国内的 git 托管，于是，代码还留在 github 上，而markdown总结则迁移到了这里。

-----------------------------------------
鉴于github使用的部分资源在国内访问不稳定，打算将在github上的wiki迁移到这里。

```
git clone --bare  https://github.com/btpka3/btpka3.github.com.wiki.git
cd btpka3.github.com.wiki.git
git push --mirror http://git.oschina.net/btpka3/btpka3.wiki.git
cd ..
git clone http://git.oschina.net/btpka3/btpka3.wiki.git
cd btpka3.wiki
echo Welcome to the btpka3 wiki! > Home.markdown
git add Home.markdown
git commit -m "recover home page for wiki"
git push
```

本地编辑wiki [参考](http://git.oschina.net/xieyajie/XDUI/wikis/git_access)
使用[gollum](https://github.com/gollum/gollum)
-----------------------------------------




