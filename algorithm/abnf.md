# 扩展的巴科斯范式

[RFC 5234](https://tools.ietf.org/html/rfc5234) 定义了
《Augmented BNF for Syntax Specifications: ABNF》*[]:
[RFC 7405](https://tools.ietf.org/html/rfc7405) 更新了
《Case-Sensitive String Support in ABNF》

* 规则格式为 `name = elements crlf`,
    * `name` 为规则名称，不区分大小写，由英文字符开头，并后跟英文字符、连字符（减号）、数字字符组成
    * `elements` 为 一个或多个规则名、或终字符。
    * 规则名称和规则定义通过 `=` 分隔
    * `;` 分号后面是注释
    * 终字符只是一个非负整数，终字符通过以下几种格式表达，多个字符通过 `.` 分隔：

      |mode |desp                                             |e.g.|
                    |-----|-------------------------------------------------|-----|
      |%b?? |binary, 使用二进制翻译后面的内容                     |     |
      |%d?? |decimal, 使用十进制翻译后面的内容                    |`CR=%d13`, `CRLF=%d13.10`|
      |%x?? |hexadecimal, 使用十六进制翻译后面的内容               |`CR=%x0D`|
      |"???"|string, 直接使用字符串表示，（不区分大小写）         |`cmd="echo hi~"`|
      |%i"???"|string, 直接使用字符串表示，（不区分大小写）         ||
      |%s"???"|string, 直接使用字符串表示，（区分大小写）         ||

  注意：用字符串表达的时候，是不区分大小写的，如果要区分需要使用其他几种表达方式。

* 操作符

| operator  | desp                    | e.g.                                       |
|-----------|-------------------------|--------------------------------------------|
| ` `       | 空格代表连接操作                | `r =  %d97 %d98 %d99` —— r 为 "abc" 小写字符串   |
| `/`       | 斜杠代表或操作                 | ` r1 r2 / r3 r4` 匹配 `r1 r2` 或 `r3 r4`      |
| `=/`      | 追加或操作                   | `r0=r1/r2; r0=/r3` 等价于 `r0 = r1/r2/r3`     |
| `%c##-##` | 范围可选值                   | `D=%x30-32` 等价于 `D="0"/"1"/"2"`            |
| `(R1 R2)` | 组操作                     | `r1 (r2/r3) r4` 匹配 `r1 r2 r4` 或 `r1 r3 r4` |
| `*Rule`   | 重复操作, `<min>*<max>Rule` | `*R1` 表示R1重复0次或无限次                         |
| `<n>Rule` | 重复指定次数操作                | 等价于 `<n>*<n>Rule`                          |
| `[RULE]`  | 可选操作                    | `[r1 r2]` 等价于 `*1(r1 r2)`                  |
| `;`       | 注释                      |                                            |

操作符优先级

前面的优先级高

1. 规则名、终字符
1. 注释
1. 范围可选值
1. 重复操作符
1. 组操作、可选操作
1. 连接操作
1. 或操作

# 核心规则

```
ALPHA          =  %x41-5A / %x61-7A     ; A-Z / a-z
BIT            =  "0" / "1"
CHAR           =  %x01-7F               ; any 7-bit US-ASCII character, excluding NUL
CR             =  %x0D                  ; carriage return
CRLF           =  CR LF                 ; Internet standard newline
CTL            =  %x00-1F / %x7F        ; controls
DIGIT          =  %x30-39               ; 0-9
DQUOTE         =  %x22                  ; " (Double Quote)
HEXDIG         =  DIGIT / "A" / "B" / "C" / "D" / "E" / "F"
HTAB           =  %x09                  ; horizontal tab
LF             =  %x0A                  ; linefeed
LWSP           =  *(WSP / CRLF WSP)     ;
OCTET          =  %x00-FF               ; 8 bits of data
SP             =  %x20                  ; spcae
VCHAR          =  %x21-7E               ; visible (printing) characters
WSP            =  SP / HTAB             ; white space
```


