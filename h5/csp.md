# 介绍

[CSP - Content Security Policy](https://w3c.github.io/webappsec-csp) 是一种白名单机制，用来限制允许从哪些地方加载资源。

## 启用

* 通过 http 响应头

    - 按规则应用，`Content-Security-Policy: yourPolicySettings;`
    - 仅报告   `Content-Security-Policy-Report-Only: script-src 'self'; report-to csp-reporting-endpoint`
      注意：`Content-Security-Policy-Report-Only` 不支持 meta 标签设置。

* 通过 HTML meta 标签：

  ```html
  <meta http-equiv="Content-Security-Policy"
        content="default-src 'self'; img-src https://*; child-src 'none';">
  ```

## 语法

与 css 语法一样：`directive1: expr1 exprs2; directive1: expr1 exprs2;`

## 指令

### fetch 相关指令

* `default-src` : 为所有其他 fetch 相关指令提供默认值
* `connect-src` : 限定 JS 可用 Ajax 连接通信的规则
* `font-src`    : 限定 css 中字体资源
* `frame-src`   : 限定 html 中 `<iframe>` 等标签允许加载的资源
* `img-src`     : 限定图片资源可以加载的来源
* `manifest-src`: 限定 [application manifests](https://www.w3.org/TR/appmanifest/) 来源
* `media-src`   : 限定视频、音频以及关联的文本追踪资源
* `object-src`  : 限定 `<object>` 所加载的资源
* `script-src`  : 限定 js 的位置，加载资源的来源等。候选值

    - `https://example.com/path/to/file.js` : 只允许该文件
    - `example.com` : 只要是该域名下的资源都可以
    - `https:`      : 只要是 `https` 资源都可以
    - `'none'`      : 什么都不允许（注意：需要有单引号。）
    - `'self'`      : 只允许当前网页的 origin 下的资源（注意：需要有单引号。）
    - `'unsafe-inline'`     :
    - `'unsafe-eval'`       :
    - `'strict-dynamic'`    :
    - `'unsafe-hashed-attributes'` :
    - `'report-sample'`     :
    - `'nonce-ch4hvvbHDpv7xCSvXCs3BrNggHdTzxUA'`
    - `'sha256-abcd...'`

* `style-src`   : 限定 css 设置的出现的位置，来源。
* `worker-src`  : 限定 Worker 所加载的资源。

### Document 相关指令

* `base-uri`    : 限定 html 中 `<base>` 标签中的内容。
* `plugin-types`: 限定 html 中 `<object type="application/x-shockwave-flash">` 标签中的类型。
* `sandbox`     : 限定 html 中 `<iframe sandbox='xxx'>` 。
* `disown-opener`   : 限定 html 中 `<iframe sandbox='xxx'>` 。

### Navigation 相关指令

* `form-action` : 限定表单提交的 url
* `frame-ancestors` : 限定哪些 URL 上的 html 可以 通过 `<frame>`, `<iframe>`,
  `<object>`, `<embed>`, 或 `<applet>` 加载当前网页。

* `navigation-to`   : 限定当前网页可以链接出去的网址，比如通过  `<a>`, `<form>`, `window.location`, `window.open` 等方式。

### Reporting 相关指令

* `report-to`   : 违反 CSP 时要提交报告的网址

## script-src

## 伪代码

```js

var cspList = [];


function inlineCheck() {

}

/**
 * @param type  可选值为 "script", "script attribute", "style", "style attribute".
 */
function isInlineBlocked(element, type, src) {
    for (var policy in policyList) {
        for (var directive in policy.directives) {

        }
    }
}

// true-检查通过，false-检查未通过
function preRequestCheck(request, policy, scriptSrc) {
    if (isWorkerSrc(request) && policy.directives.contains("'worker-src'")) {
        return true;
    }

    if (isScript(request)) {
        if (isNonceMatch(request)) {
            return true;
        }
        if (isHashMatch(request)) {

        }
    }

    return true;

}

function isRequestViolate(request, policy) {
    for (var directive in ploicy) {
        var violate = preRequestCheck(request, policy, directive);
        if (violate) {
            return violate;
        }
    }

    return null;
}

function isRequestBlocked(request) {
    var blocked = false;


    for (var policy in cspList) {
        if (policy.isReportOnly()) {
            continue;
        }

        var violate = isRequestViolate(request, policy);
        if (violate) {
            reportViolate(violate);
            return true;
        }
    }
    return blocked;

}

```


