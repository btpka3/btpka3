

## 参考
* [css-tricks](https://css-tricks.com/)
* 《[10步掌握CSS定位](http://www.see-design.com.tw/i/css_position.html)》
* 《[使用viewport元标签控制布局](https://developer.mozilla.org/zh-CN/docs/Mobile/Viewport_meta_tag)》
* [mydevice.io](http://www.mydevice.io/devices/)
* [2015移动app视觉规范](http://www.25xt.com/appsize)
* [dpi.lv](http://dpi.lv/)
* [viewportsizes.com](http://viewportsizes.com/)
* [resolution](http://ryanve.com/lab/resolution/)
## material design

* [material design](http://wiki.jikexueyuan.com/project/material-design/)
* [material icons](http://btpka3.github.io/js/angular/my-ng-material/src/md-icon2.html)

## 屏幕常见尺寸



| 标屏 | 分辨率 | 宽屏| 分辨率
|-----|-----|-----|-----
|QVGA|320×240|WQVGA|400×240
|VGA|640×480|WVGA|800×480
|SVGA|800×600|WSVGA|1024×600
|XGA|1024×768|WXGA|1280×768/1280×800/1280*960
|SXGA|1280×1024|WXGA+|1440×900
|SXGA+|1400×1050|WSXGA+|1680×1050
|UXGA|1600×1200|WUXGA|1920×1200
|QXGA|2048×1536|WQXGA|2560×1536

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

|     |低密度(120)-ldpi|中密度(160)-mdpi|高密度(240)-hdpi
|------|--------------|---------------|--------------
|小屏幕  |QVGA(240*320)
|正常屏幕|WQVGA400(240*400)、WQVGA432(240*432)|HVGA(320*480)| WVGA800(480*800)、WVGA854(480*854)
|大屏幕  ||WVGA800(480*800)、WVGA854(480*854)

## 常见手机屏幕

|Phone                |inch |ratio|phys w/h |phys ppi|dpr|css w/h |css ppi|
|---------------------|-----------|---------|--------|---|--------|-------|
|Mi 2                 |4.0" |16:9 | 720*1280|320     |   |        |       |
|Mi 3/4               |     |16:9 |1080*1920|        |   |        |       |
|iPhone 3/3G/3GS      |3.5" |3:2  | 320* 480|163     |  1|320*480 | 96    |
|iPhone 4/4S          |3.5" |3:2  | 640* 960|326     |  2|320*480 |192    |
|iPhone 5/5C/5S       |4.0" |~16:9| 640*1136|326     |  2|320*568 |192    |
|iPhone SE            |4.0" |~16:9| 640*1136|326     |   |        |       |
|iPhone 6             |4.7" |~16:9| 750*1334|326     |  2|375*667 |192    |
|iPhone 6/6S          |4.7" |~16:9| 750*1334|326     |  2|375*667 |192    |
|iPhone 6+/6S+        |5.5" |16:9 |1080*1920|401     |  3|414:736 |       |
|iPad 1/2             |9.7" |4:3  | 768*1024|131.96  |  1|768*1024|131.96 |
|iPad 3/4/air         |9.7" |4:3  |1536*2048|263.92  |  2|768*1024|131.96 |
|iPad mini            |7.9" |4:3  | 768*1024|162.03  |  1|768*1024|162.03 |
|iPad mini2           |7.9" |4:3  |1536*2048|324.05  |  2|768*1024|162.03 |


## 常见屏幕比例

|short/long     |ratio|
|---------------|-----|
|0.5625         |16:9 |
|0.625          |16:10|
|0.666666667    |3:2  |
|0.692307692    |13:9 |
|0.75           |4:3  |



关键词：dpi、ppi、dppx 、dpr = Device Pixel Ratio

~










# animation

* [Animated Buttons](http://tympanus.net/Tutorials/AnimatedButtons/index6.html)
* [Original Hover Effects](http://tympanus.net/Tutorials/OriginalHoverEffects/index10.html)


# 笔记
*  ？？？ `display:table-cell` 无法 float?
*  [`display:table` 垂直居中](http://jsfiddle.net/wZ96P/)
* 《[A Complete Guide to Flexbox](https://css-tricks.com/snippets/css/a-guide-to-flexbox/)》
* 《[Flex布局新旧混合写法详解（兼容微信）](http://www.tuicool.com/articles/Yzeu6j7)》
* http://www.zhihu.com/question/22991944
* www.w3.org/TR/2009/WD-css3-flexbox-20090723/