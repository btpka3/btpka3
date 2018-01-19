## 前端开发人员笔试题



1. 请问下题中 `div#d1` 的宽度是_____像素？

    ```html
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>div#d1.width=?</title>
        <style>
            #d1 {
                box-sizing: border-box;
                margin: 10px;
                padding: 11px;
                border: 2px solid red;
                outline: 5px dotted #555500;
                display: inline-block;
            }
            #d2 {
                box-sizing: content-box;
                margin: 1px;
                padding: 2px;
                border: 1px solid blue;
                outline: 3px dotted #555500;
                background-color: aquamarine;
                width: 100px;
            }
        </style>
    </head>
    <body>
    <div id="d1">
        <div id="d2">XXX</div>
    </div>
    </body>
    </html>
    ```

1. 请指出下面例子共打印四条消息。按先后顺序，其值分别是：

    ```js
    var messages = ["aaa", "bbb", "ccc"];
    for (var i = 0; i < messages.length; i++) {
      setTimeout(function () {
        console.log(i + " : " + messages[i]);
      }, i * 1500);
    }
    console.log(i + " : " + messages[i]);
    ```


1. 下面代码的打印结果是？

    ```
    <html>
    <script>
        var F = function () {
            this.value1 = 100;
        };

        F.prototype.value2 = 200;
        F.prototype.value3 = [300];

        var f1 = new F();
        console.log("" + f1.value1 + ", " + f1.value2 + ", " + f1.value3[0]);
        f1.value1++;
        f1.value2++;
        f1.value3[0]++;
        console.log("" + f1.value1 + ", " + f1.value2 + ", " + f1.value3[0]);

        var f2 = new F();
        console.log("" + f2.value1 + ", " + f2.value2 + ", " + f2.value3[0]);
        f2.value1++;
        f2.value2++;
        f2.value3[0]++;
        console.log("" + f2.value1 + ", " + f2.value2 + ", " + f2.value3[0]);
    </script>
    </html>
    ```


1. 以下html内容有错么？如果有，请指出，并给出更正后的答案：

    ```
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>html validator</title>
        <script type="text/javascript" src="https://code.jquery.com/jquery-2.2.2.min.js"/>
    </head>
    <body>
    <div>
        <!-- 注释：js 操作符有： +, -, *, /, --, ++ 等等. -->
        <a href="http://validator.w3.org/?key1=html validator&key2=value2">
            <img src="http://www.w3.org/Icons/w3c_home" alt="w3c logo" title="w3c logo" ></img>
            Html Validator
        </a>
    </div>
    </body>
    </html>
    ```
1. 针对下面的html， 以下css 选择分别选择了哪些元素（请列出选中元素的id）？

    1. `#d2`     选中了________
    1. `div`     选中了________
    1. `.c1.c2`  选中了________
    1. `.c1 .c3` 选中了________
    1. `.c2>[c2]`    选中了________

    ```
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>css selector</title>
    </head>
    <body>
    <div id="d1" class="c1 c3">
        <div id="d2" class="c1 c2" c2="aaa">aaa</div>
        <div id="d3" class="c2 c3" c1="bbb" title="bbb">bbb</div>
        <div id="d4" class="c1 c2 c3" c2="ccc" >ccc</div>
        <div id="d5" class="c1 c2">
            <div id="d6" class="c2 c3" c2="ddd">ddd</div>
            <div id="d7" class="c3" c4="eee">eee
                <span id="s1">fff</span>
            </div>
        </div>
    </div>
    </body>
    </html>
    ```
1. 下面 html 页面，点击按钮时，控制台回打印什么语句？

    ```
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>event</title>
    </head>
    <body onload="regClick()">
    <div id="d1">This
        <span id="d2">
            is a
            <button id="d3">button</button>
            .
        </span>
    </div>
    <script>
        function regClick() {
            var ele = document.getElementById("d1");
            ele.addEventListener("click", function (e) {
                console.log("1. " + e.target.id + ", " + e.currentTarget.id);
            });

            ele = document.getElementById("d2");
            ele.addEventListener("click", function (e) {
                console.log("2.1 " + e.target.id + ", " + e.currentTarget.id);
            });
            ele.addEventListener("click", function (e) {
                console.log("2.2 " + e.target.id + ", " + e.currentTarget.id);
                e.stopPropagation();
            });

            ele = document.getElementById("d3");
            ele.addEventListener("click", function (e) {
                console.log("3 " + e.target.id + ", " + e.currentTarget.id);
            });
        }
    </script>
    </body>
    </html>
    ```

1. 以下网页，浏览器内容窗口调整为宽 400px, 高 600px 时，文本 `aaa` 的color是？font-size是？

    ```
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>css media query</title>
        <style type="text/css">
            * {
                color: black;
                font-size: 12px;
            }

            .c1 {
                color: red;
                font-size: 16px;
            }

            @media (max-width: 400px) {
                .c1 {
                    color: blue;
                    font-size: 30px !important;
                }
            }

            @media (orientation: portrait) {
                .c1 {
                    color: green;
                    font-size: 40px;
                }
            }
        </style>
    </head>
    <body>
    <div class="c1" style="font-size:20px;">aaa</div>
    </body>
    </html>
    ```

1. 下面Javascript代码打印的内容依次是？


    ```
    <html>
    <script>
        var age = 18;

        function User(a) {
            var age = 24;
            this.age = a;

            this.print1 = function(){
                console.log(age);
            };

            this.print2 = function(){
                console.log(this.age);
            };

            this.print3 = function(){
                return function(){
                    console.log(this.age);
                }
            };
        }

        var u = new User(81);
        u.print1();
        u.print2();
        u.print3()();
    </script>
    </html>
   ```


1. 下面JavaScript中依次打印什么内容？

    ```
    <html>
    <script>
        console.log("1. " + ( undefined == null));
        console.log("2. " + ( 0 == false));
        console.log("3. " + ( "" == false));
        console.log("4. " + ( "" == 0));
        console.log("5. " + ( [] == false));
        console.log("6. " + ( {} == false));
        console.log("7. " + ( typeof -NaN));
        console.log("8. " + ( typeof true));
        console.log("9. " + ( typeof 1 + 123));
        console.log("10. " + ( 0.1 + 0.2 + 0.3));
    </script>
    </html>
    ```

1. 下列那些http头与可以用于缓存控制？

   1. Date
   1. Cache-Control
   1. Last-Modified
   1. Etag
   1. If-Modified-Since
   1. Cookie
   1. If-None-Match
   1. Origin
   1. Status
   1. Expires

1. 文本 "xxx" 是红色还是蓝色？

    ```
    <html>
    <head>
      <style>
        md-list.md-dense md-list-item > md-icon:first-child:not(.md-avatar-icon) {
          color:red;
        }

        .ks-category md-list-item > md-icon.subdir:first-child {
          color:blue;
        }
      </style>
    </head>
    <body>
    <md-list class="ks-category md-dense">
      <md-list-item>
        <md-icon class="subdir" >xxx</md-icon>  <!-- 问：文本 "xxx" 是红色还是蓝色？ -->
        <md-icon class="subdir" >yyy</md-icon>
      </md-list-item>
    </md-list>
    </body>
    </html>
    ```



