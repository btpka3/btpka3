// ==UserScript==
// @name         Code Block Font: Sarasa Mono SC
// @namespace    https://github.com/dangqian
// @version      1.0.0
// @description  将常用网站代码块字体替换为 Sarasa Mono SC，解决中英文混排对齐问题
// @author       当千
// @match        *://*.yuque.com/*
// @match        *://*.antfin.com/*
// @match        *://github.com/*
// @match        *://gitlab.com/*
// @match        *://*.gitlab.com/*
// @match        *://*.alibaba-inc.com/*
// @run-at       document-start
// @grant        GM_addStyle
// ==/UserScript==

(function () {
  'use strict';

  const FONT_STACK = '"Sarasa Mono SC", SFMono-Regular, Consolas, "Liberation Mono", Menlo, Courier, monospace';

  const css = `
    /* ===== 语雀 (Yuque / AntFin) ===== */
    ne-code-content,
    .ne-code .cm-editor,
    .ne-code .cm-content,
    .ne-code .cm-line,
    .ne-codeblock .cm-editor,
    .ne-codeblock .cm-content,
    .ne-codeblock .cm-line,
    .CodeMirror,
    .CodeMirror pre.CodeMirror-line,
    .CodeMirror pre.CodeMirror-line-like,
    .ne-code-content *,
    ne-code-content * {
      font-family: ${FONT_STACK} !important;
    }

    /* ===== GitHub ===== */
    .highlight pre,
    .blob-code,
    .blob-code-inner,
    .CodeMirror,
    .CodeMirror-code,
    .CodeMirror-line,
    .react-code-text,
    .react-code-line-contents,
    code[class*="language-"],
    pre[class*="language-"],
    .markdown-body pre,
    .markdown-body code,
    .markdown-body .highlight {
      font-family: ${FONT_STACK} !important;
    }

    /* ===== GitLab ===== */
    .code .line,
    .blob-viewer pre,
    .blob-viewer code,
    .diff-line-num,
    .line_content,
    .ide-editor .monaco-editor,
    .markdown-code-block pre,
    .markdown-code-block code {
      font-family: ${FONT_STACK} !important;
    }

    /* ===== 通用 code/pre 兜底 ===== */
    pre > code,
    pre.code,
    code.hljs,
    .hljs {
      font-family: ${FONT_STACK} !important;
    }
  `;

  if (typeof GM_addStyle === 'function') {
    GM_addStyle(css);
  } else {
    const style = document.createElement('style');
    style.textContent = css;
    (document.head || document.documentElement).appendChild(style);
  }
})();
