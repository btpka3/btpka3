
## 前端开发人员面试题

注意：下面这些问题不是必须纸面作答，先思考如何口头回答即可。

* CSS中 `padding`、`margin`、`outline` 作用是什么？请讲解一下 CSS 的 box 模型。
* HTTP 规范中定义了那些 Http method？语义是？
* HTTP 规范中与缓存相关 HTTP 请求头、响应头有哪些？
* 请尽可能详细的介绍一个URL的组成部分
* 请指出下面例子的打印结果

    ```js
    var messages = ["aaa", "bbb", "ccc"];
    for (var i = 0; i < messages.length; i++) {
      setTimeout(function () {
        console.log(messages[i]);
      }, i * 1500);
    }
    console.log(messages[i]);
    ```

* 请讲解一下 Javascript 中 call()、 apply()、callee、caller，并说明下面代码的打印结果。

    ```
    <html>
    <script>
        var o = {
            k: "v",
            a: function () {
                console.log("111", this, arguments, arguments.callee, arguments.callee.caller);
            }
        };

        var b = function () {
            console.log("222", this, arguments, arguments.callee, arguments.callee.caller);

            a("aaa");
        };

        var a = function () {
            console.log("333", this, arguments, arguments.callee, arguments.callee.caller);
        };

        b.call(o, 1, 2, 3);
    </script>
    </html>
    ```

* 请讲解一下 Javascript 中的 prototype，并说明下面代码的打印结果。

    ```
    <html>
    <script>

        // 第一部分
        var o1 = {v1: 100};
        var o2 = {v2: 200};
        o2.prototype = o1;
        console.log(o2.v1, o2.v2);

        // 第二部分
        var F = function () {
            this.value1 = 100;
        };

        F.prototype.value2 = 200;
        F.prototype.value3 = [300];


        var f1 = new F();
        console.log(f1.value1, f1.value2, JSON.stringify(f1.value3));
        f1.value1++;
        f1.value2++;
        f1.value3[0]++;
        console.log(f1.value1, f1.value2, JSON.stringify(f1.value3));

        var f2 = new F();
        console.log(f2.value1, f2.value2, JSON.stringify(f2.value3));
        f2.value1++;
        f2.value2++;
        f2.value3[0]++;
        console.log(f2.value1, f2.value2, JSON.stringify(f2.value3));

    </script>
    </html>
    ```

* 关于 Javascript 中的 typeof 操作符，请回答下面代码的输出结果。

    ```
    <html>
    <script>
        console.log(typeof 1.3333);
        console.log(typeof typeof 1.3333);
        console.log(typeof 1.3333 + "123");
        console.log(typeof NaN);
        console.log(typeof false);
        console.log(typeof []);
        console.log(typeof {});
    </script>
    </html>
    ```

* 关于 Javascript 中变量的查找方式，请回答下面代码的输出结果。

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
* Javascript 如何跨域请求数据？
* 请尝试写出一个匹配含符号位、含小数位的正则表达式。
* 关于Web前端开发，可以做哪些优化？
* 平常都使用哪些开发工具？调试工具？
* 请讲解一些 XSS。
* 有没有配置过 Apache/Nginx? 你常用的配置项有哪些？是否熟悉 Linux 服务器管理？
* 是否熟悉 Node.js？ 
* 使用过哪些源代码管理工具？是否熟悉 git？
* 什么是 hybrid app ? 请介绍一下你了解或用过的工具、框架。
* 请介绍一下你熟悉的CSS预处理器。有何优缺点？