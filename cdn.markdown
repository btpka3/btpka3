

# 七牛云

## 直传

目前(2016)公司项目图片资源所用的CDN为 [七牛云](http://www.qiniu.com/)。但是为了防止文件命名问题（包含重命名，文件重复上传），采用的方案是：

1. 用户先上传图片到 自己的WebApp服务器
1. 自己的WebApp服务器上：

    1. 计算文件MD5，
    1. 将其MD5值作为CDN上的文件名，并上传
    1. WebApp服务器上并不存储文件内容，仅仅在数据库内只保留元信息。 

1. Web前端再通过JS，使用七牛云的[图片处理API](http://developer.qiniu.com/code/v6/api/kodo-api/image/index.html)修改URL参数来适应不同的手机屏幕。


缺点：时不时被反馈用户上传慢，因此在考虑使用浏览器端计算文件MD5值。

七牛云的[直传API](http://developer.qiniu.com/code/v6/api/kodo-api/up/upload.html) 支持通过[魔法变量](http://developer.qiniu.com/article/kodo/kodo-developer/up/vars.html#magicvar)来自动使用七牛云ETAG [`$(etag)`](http://developer.qiniu.com/article/kodo/kodo-developer/appendix.html#qiniu-etag) 来设定文件名。 

虽然七牛云ETAG不是MD5值，也不是标准的SHA1算法，但也能起到防重复上传的作用。但是仍有一下问题：

1. 用户只有将图片上传到七牛云服务器上之后，才知道是否重复上传了，可能会白白浪费带宽。
1. 使用七牛云ETAG作为文件名的话，将绑定到七牛云上，不利于更换其他API，能自己指定文件名防止重复的话最好。
1. [七牛云ETAG类库](https://github.com/qiniu/qetag)的JS版本，只能运行再Node环境下，无法运行在浏览器环境下。


搜索了一下，可用的相关JS类库有 [sjcl](https://github.com/bitwiseshiftleft/sjcl)、
[crypto-js](https://github.com/brix/crypto-js/tree/develop/src)、
[SpartMd5](https://github.com/satazor/js-spark-md5)，但最推荐的当属 [Web Cryptography API](https://www.w3.org/TR/WebCryptoAPI/)，可以在MDN上看到详尽的[API ](https://developer.mozilla.org/en-US/docs/Web/API/Window/crypto)， 在[CanIUse网站上](http://caniuse.com/#feat=cryptography)可以看到，除了IE旧版本之外，其他的基本都支持了。

但是 Web Cryptography API [不支持](https://developer.mozilla.org/en-US/docs/Web/API/SubtleCrypto/digest) MD5的方式。



## 对应微信内的APP不支持直接文件上传，该如何对应CDN直传？

安卓版微信文件上传提示[只能上传SD卡内容](http://www.zhihu.com/question/21452742?rf=27008938).

七牛云支持[fetch](http://developer.qiniu.com/code/v6/api/kodo-api/rs/fetch.html) API 来处理。


# 阿里云OSS

[阿里云OSS](https://www.aliyun.com/product/oss) 配合其 CDN 服务，是已经在用的网站静态资源网站存储的方案。

支持通过URL进行图片处理。但是没有类似七牛云的fetch 的 API。

