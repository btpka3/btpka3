## 参考

* [css-tricks](https://css-tricks.com/)
* 《[10步掌握CSS定位](http://www.see-design.com.tw/i/css_position.html)》
* 《[使用viewport元标签控制布局](https://developer.mozilla.org/zh-CN/docs/Mobile/Viewport_meta_tag)》
* [mydevice.io](http://www.mydevice.io/devices/)
* [2015移动app视觉规范](http://www.25xt.com/appsize)
* [dpi.lv](http://dpi.lv/)
* [viewportsizes.com](http://viewportsizes.com/)
* [resolution](http://ryanve.com/lab/resolution/)
* 《[Height equals width with pure CSS](http://www.mademyday.de/css-height-equals-width-with-pure-css.html)》
* https://csstriggers.com/
* 《[在 iOS 模拟器中调试 Web 页面](http://www.open-open.com/news/view/16e47a2)》

## Web Components

[polymer](https://www.polymer-project.org)

## Web Gradients

[CSS Gradient Animator](https://www.gradient-animator.com/)
[webgradients](https://github.com/itmeo/webgradients)

## rem布局

* http://m.mogujie.com/
* https://segmentfault.com/a/1190000003690140

## material design

* [material design](http://wiki.jikexueyuan.com/project/material-design/)
* [material icons](http://btpka3.github.io/js/angular/my-ng-material/src/md-icon2.html)

## ios vs Safari

* ios 版本比例 [1](https://developer.apple.com/support/app-store/)、[2](https://david-smith.org/iosversionstats/)
* [Safari version history](https://en.wikipedia.org/wiki/Safari_version_history)
* [IOS vs. Safari 版本](http://www.somegeekintn.com/blog/stuff/iosvers/)
* [IOS 版本](https://en.wikipedia.org/wiki/IOS_version_history)
* [MacOSX 与 Safari 版本](https://en.wikipedia.org/wiki/Safari_version_history)

| iPhone          | year | iOS         |
|-----------------|------|-------------|
| iPhone 4        | 2010 | 4.0 ~ 7.1.2 |
| iPhone 4s       | 2011 | 5.0 ~ 8.4   |
| iPhone 5        | 2012 | 6.0 ~ 8.4   |
| iPhone 5c/5s    | 2013 | 7.0 ~ 8.4   |
| iPhone 6/6 Plus | 2014 | 8.0 ~ 8.4   |

```
iPhone 3GS        - Mobile Safari 4.0.5
iPhone 4          - Mobile Safari 4.0.5
iPhone 4s         - Mobile Safari 5.1
iPhone 5 / 6.0    - Mobile Safari 6.0

iPad 1 / 3.2.2    - Mobile Safari 4.0.4
iPad 2 / 4.3.3    - Mobile Safari 5.02
iPad 2 / 5.0      - Mobile Safari 5.1
iPad 3 / 5.1      - Mobile Safari 5.1
iPad 4 / 6.0      - Mobile Safari 6.0


```

## 微信

| Owner | device    | iOS   | soft   | UserAgent                                                                                                                                                       |
|-------|-----------|-------|--------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 小卉    | iphone 4s | 7.0.3 | 微信     | Mozilla/5.0 (iPhone; CPU iPhone OS 7_0_3 like Mac OS X) AppleWebKit/537.51.1 (KHTML, like Gecko) Mobile/11B511 MicroMessenger/6.1 NetType/WIFI                  |
| 小卉    | iphone 4s | 7.0.3 | Safari | Mozilla/5.0 (iPhone; CPU iPhone OS 7_0_3 like Mac OS X) AppleWebKit/537.51.1 (KHTML, like Gecko) Version/7.0 Mobile/11B511 Safari/9537.53                       |
| 豆豆    | iphone 5s | 8.1   | 微信     | Mozilla/5.0 (iPhone; CPU iPhone OS 8_1 like Mac OS X) AppleWebKit/600.1.4 (KHTML, like Gecko) Mobile/12B411 MicroMessenger/6.3.13 NetType/WIFI Language/zh_CN   |
| 豆豆    | iphone 5s | 8.1   | Safari | Mozilla/5.0 (iPhone; CPU iPhone OS 8_1 like Mac OS X) AppleWebKit/600.1.4 (KHTML, like Gecko) Version/8.0 Mobile/12B411 Safari/600.1.4                          |
| 沐风    | ipone 6   | 9.3.2 | 微信     | Mozilla/5.0 (iPhone; CPU iPhone OS 9_3_2 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Mobile/13F69 MicroMessenger/6.3.22 NetType/WIFI Language/zh_CN |
| 沐风    | ipone 6   | 9.3.2 | Safari | Mozilla/5.0 (iPhone; CPU iPhone OS 9_3_2 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13F69 Safari/601.1                          |

## 屏幕常见尺寸

| 标屏    | 分辨率       | 宽屏     | 分辨率
|-------|-----------|--------|----------------------------
| QVGA  | 320×240   | WQVGA  | 400×240
| VGA   | 640×480   | WVGA   | 800×480
| SVGA  | 800×600   | WSVGA  | 1024×600
| XGA   | 1024×768  | WXGA   | 1280×768/1280×800/1280*960
| SXGA  | 1280×1024 | WXGA+  | 1440×900
| SXGA+ | 1400×1050 | WSXGA+ | 1680×1050
| UXGA  | 1600×1200 | WUXGA  | 1920×1200
| QXGA  | 2048×1536 | WQXGA  | 2560×1536

## 计算 DPI

比如： WVGA（800×400），3.7英寸屏幕的DPI

```
DPI = 对角线的像素数 / 屏幕英寸数
    = sqrt(800^2 + 480^2) / 3.7
    = sqrt(640000 + 230400) / 3.7
    = sqrt(870400) / 3.7
    = 932.952303175 / 3.7
    = 252.149271128
```

## 屏幕分类

|      | 低密度(120)-ldpi                       | 中密度(160)-mdpi                     | 高密度(240)-hdpi
|------|-------------------------------------|-----------------------------------|-----------------------------------
| 小屏幕  | QVGA(240*320)
| 正常屏幕 | WQVGA400(240*400)、WQVGA432(240*432) | HVGA(320*480)                     | WVGA800(480*800)、WVGA854(480*854)
| 大屏幕  |                                     | WVGA800(480*800)、WVGA854(480*854)

## 常见手机屏幕

| Phone           | inch | ratio | phys w*h  | phys ppi | dpr | css w*h  | css ppi
|-----------------|------|-------|-----------|----------|-----|----------|---------
| Mi 2            | 4.0" | 16:9  | 720*1280  | 320
| Mi 3/4          |      | 16:9  | 1080*1920
| iPhone 3/3G/3GS | 3.5" | 3:2   | 320* 480  | 163      | 1   | 320*480  | 96
| iPhone 4/4S     | 3.5" | 3:2   | 640* 960  | 326      | 2   | 320*480  | 192
| iPhone 5/5C/5S  | 4.0" | ~16:9 | 640*1136  | 326      | 2   | 320*568  | 192
| iPhone SE       | 4.0" | ~16:9 | 640*1136  | 326
| iPhone 6        | 4.7" | ~16:9 | 750*1334  | 326      | 2   | 375*667  | 192
| iPhone 6/6S     | 4.7" | ~16:9 | 750*1334  | 326      | 2   | 375*667  | 192
| iPhone 6+/6S+   | 5.5" | 16:9  | 1080*1920 | 401      | 3   | 414*736
| iPad 1/2        | 9.7" | 4:3   | 768*1024  | 131.96   | 1   | 768*1024 | 131.96
| iPad 3/4/air    | 9.7" | 4:3   | 1536*2048 | 263.92   | 2   | 768*1024 | 131.96
| iPad mini       | 7.9" | 4:3   | 768*1024  | 162.03   | 1   | 768*1024 | 162.03
| iPad mini2      | 7.9" | 4:3   | 1536*2048 | 324.05   | 2   | 768*1024 | 162.03

## 常见屏幕比例

| short/long  | ratio |
|-------------|-------|
| 0.5625      | 16:9  |
| 0.625       | 16:10 |
| 0.666666667 | 3:2   |
| 0.692307692 | 13:9  |
| 0.75        | 4:3   |

关键词：dpi、ppi、dppx 、dpr = Device Pixel Ratio

~

# safari 远程调试：

1. safari @ mac os:

    1. 菜单 "Safari" -> "Preferences" -> "Advanced" -> 选中最底部的 "Show Developer menu in menu bar"
    1. 有必要的时候，退出并重启 Safari

1. safari @ ios

    1. ios : 设置 -> Safari -> 高级 -> 开启 "Web 检查器"
    1. 使用 Safari 浏览网页

1. safari @ mac os: -> Develop 菜单 -> xxx's iPad -> 选择要检查的网页。

# tools

* [styleguide](http://styleguide.devbproto.com/styleguide/#3)

# layout

* [flexboxgrid](https://github.com/kristoferjoseph/flexboxgrid)
* [grd](https://1000ch.github.io/grd/)

# animation

* [Animated Buttons](http://tympanus.net/Tutorials/AnimatedButtons/index6.html)
* [Original Hover Effects](http://tympanus.net/Tutorials/OriginalHoverEffects/index10.html)
* [css SPINNERS](https://boguz.github.io/Spinners/)
* [WAIT! Animate](http://waitanimate.wstone.io/#/)

# 图片

* [Imagehover.css](http://imagehover.io/)
* [HUE.css](https://evankarageorgos.github.io/hue/grid.html)
* [CSSCO](http://www.cssco.co/)

# 颜色

* [brand-colors](http://brand-colors.com/)

# 笔记

* ？？？ `display:table-cell` 无法 float?
* [`display:table` 垂直居中](http://jsfiddle.net/wZ96P/)
* 《[A Complete Guide to Flexbox](https://css-tricks.com/snippets/css/a-guide-to-flexbox/)》
* 《[Flex布局新旧混合写法详解（兼容微信）](http://www.tuicool.com/articles/Yzeu6j7)》
* http://www.zhihu.com/question/22991944
* www.w3.org/TR/2009/WD-css3-flexbox-20090723/

# css 规则的优先顺序？

* 说明
    * a : 选择器包含元素id的数量
    * b : 选择器中类选择器，属性选择器，伪类选择器（不保护含 :not(X) 伪类）的数量
    * c : 选择器包元素名称选择器，伪元素的数量
    * 忽略通配符选择器

示例

```css
* /* a=0 b=0 c=0 -> specificity =   0 */
LI /* a=0 b=0 c=1 -> specificity =   1 */
UL LI /* a=0 b=0 c=2 -> specificity =   2 */
UL OL + LI /* a=0 b=0 c=3 -> specificity =   3 */
H1 + *[REL=up] /* a=0 b=1 c=1 -> specificity =  11 */
UL OL LI.red /* a=0 b=1 c=3 -> specificity =  13 */
LI.red.level /* a=0 b=2 c=1 -> specificity =  21 */
#x34y /* a=1 b=0 c=0 -> specificity = 100 */
#s12:not(FOO) /* a=1 b=0 c=1 -> specificity = 101 */
    /* a=0 b=3 c=3 -> specificity =  33 */
md-list.md-dense md-list-item > md-icon:first-child:not(.md-avatar-icon) {
    color: red;
}

/* a=0 b=3 c=2 -> specificity =  32 */
.ks-category md-list-item > md-icon.subdir:first-child {
    color: blue;
}

<
md-list class

=
"ks-category md-dense"
>

<
md-list-item >

<
md-icon class

=
"subdir"
> xxx

<
md-icon >

<!--
问：文本

"xxx"
是红色还是蓝色？

-->
<
md-icon class

=
"subdir"
> yyy

<
md-icon >

<
/
md-list-item >

<
/
md-list >

```

## 参考

* [css 3](https://www.w3.org/TR/css3-selectors/#specificity)
* [css 2](http://www.w3.org/TR/CSS21/cascade.html#specificity)
* [Pseudo-classes](https://developer.mozilla.org/en-US/docs/Web/CSS/Pseudo-classes)

# 伪类

```css
:active
:any
:checked
:default
:dir()
:disabled
:empty
:enabled
:first
:first-child
:first-of-type
:fullscreen
:focus
:hover
:indeterminate
:in-range
:invalid
:lang()
:last-child
:last-of-type
:left
:link
:not()
:nth-child()
:nth-last-child()
:nth-last-of-type()
:nth-of-type()
:only-child
:only-of-type
:optional
:out-of-range
:read-only
:read-write
:required
:right
:root
:scope
:target
:valid
:visited
```

# 伪元素

```
element::after {}
element::before {}
element::first-letter {}
element::first-line {}
element::selection {}
```

# 进度条/spin

* 《[10+ Best Pure CSS Loading Spinners For Front-end Developers](https://365webresources.com/10-best-pure-css-loading-spinners-front-end-developers/)》


