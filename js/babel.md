

[babel js](http://babeljs.io) 可以将使用高级语法的Javascript 转换为低级的 Js 语法，以便较旧的 JS 引擎能支持。


## 插件

### preset

[preset](https://babeljs.io/docs/plugins/#presets) 是预设的一组插件的总和。

* babel-preset-env
   该插件将使用统计的 [compat-table](https://github.com/kangax/compat-table)，为特定环境使用特定的插件。
   比如：针对 node 环境，或针对 chrome 52 版本。

* babel-preset-latest
    总包含其他最新的年度的 preset，比如现在包含：es2017, es2016, es2015
    
* babel-preset-es2015
    此类是按照特定的 javascript 规范，包含一定的插件。注意：preset-es2016 不会包含 preset-2015 中的任何插件。
    
* babel-preset-stage-x
    按照 [tc39](https://github.com/tc39) 中建议的几个阶段来引入不同的插件。
    
    * state-0: 仅仅是一个想法，在 babel 中可能有对应的插件
    * state-1: 提议.  包含部分提议，以及 preset-stage-2， preset-stage-3 中的插件
    * state-2: 草案
    * state-3: 新的规范的候选
    * state-4: 已完成，将会在下一个年度的规范中追加。
    


## 参考

* [在线演示](http://babeljs.io/repl/)


## ECMAScript 6/ECMAScript 2015 

《[Learn ES2015](https://babeljs.io/learn-es2015/)》

《[ECMAScript® 2015 Language Specification](http://www.ecma-international.org/ecma-262/6.0/)》

《[Exploring ES2016 and ES2017](http://exploringjs.com/es2016-es2017/)》

* const 

    ```js
    const a = 1;
    a = 2;          // 将出错
    ```
*  arrow functions 

    ```js
    const double = [1,2,3].map((num) => num * 2);
    console.log(double); // [2,4,6]
    ```
* class

    ```js
    class Foo {
      set bar() {
        throw new Error("foo!");
      }
    }
    
    class Bar extends Foo {
      bar() {
        // will throw an error when this method is defined
      }
    }
    ```
* Enhanced Object Literals

    ```js
    var obj = {
        // Sets the prototype. "__proto__" or '__proto__' would also work.
        __proto__: theProtoObj,
        // Computed property name does not set prototype or trigger early error for
        // duplicate __proto__ properties.
        ['__proto__']: somethingElse,
        // Shorthand for ‘handler: handler’
        handler,
        // Methods
        toString() {
         // Super calls
         return "d " + super.toString();
        },
        // Computed (dynamic) property names
        [ "prop_" + (() => 42)() ]: 42
    };
    ```
* Template Strings

    ```js
    // Multiline strings
    `In ES5 this is
     not legal.`;
    
    // Interpolate variable bindings
    var name = "Bob", time = "today";
    `Hello ${name}, how are you ${time}?`;
    
    // Unescaped template strings
    String.raw`In ES5 "\n" is a line-feed.`;
    
    // Construct an HTTP request prefix is used to interpret the replacements and construction
    GET`http://foo.org/bar?a=${a}&b=${b}
        Content-Type: application/json
        X-Credentials: ${credentials}
        { "foo": ${foo},
          "bar": ${bar}}`(myOnReadyStateChangeHandler);
    ```
    
* Destructuring

    ```js
    // list matching
    var [a, ,b] = [1,2,3];
    a === 1;
    b === 3;
    
    // object matching
    var { op: a, lhs: { op: b }, rhs: c }
           = getASTNode();
    
    // object matching shorthand
    // binds `op`, `lhs` and `rhs` in scope
    var {op, lhs, rhs} = getASTNode();
    
    // Can be used in parameter position
    function g({name: x}) {
      console.log(x);
    }
    g({name: 5});
    
    // Fail-soft destructuring
    var [a] = [];
    a === undefined;
    
    // Fail-soft destructuring with defaults
    var [a = 1] = [];
    a === 1;
    
    // Destructuring + defaults arguments
    function r({x, y, w = 10, h = 10}) {
      return x + y + w + h;
    }
    r({x:1, y:2}) === 23
    ```

* Default + Rest + Spread

    ```js
    function f1(x, y=12) {
      // y is 12 if not passed (or passed as undefined)
      return x + y;
    }
    f1(3) == 15
    
    function f2(x, ...y) {
      // y is an Array
      return x * y.length;
    }
    f2(3, "hello", true) == 6
    
    function f3(x, y, z) {
      return x + y + z;
    }
    // Pass each elem of array as argument
    f3(...[1,2,3]) == 6
    ```
    
* Let + Const
    
    ```js
    function f() {
      {
        let x;
        {
          // this is ok since it's a block scoped name
          const x = "sneaky";
          // error, was just defined with `const` above
          x = "foo";
        }
        // this is ok since it was declared with `let`
        x = "bar";
        // error, already declared above in this block
        let x = "inner";
      }
    }
    ```
* Iterators + For..Of


    ```js
    let fibonacci = {
      [Symbol.iterator]() {
        let pre = 0, cur = 1;
        return {
          next() {
            [pre, cur] = [cur, pre + cur];
            return { done: false, value: cur }
          }
        }
      }
    }
    
    for (var n of fibonacci) {
      // truncate the sequence at 1000
      if (n > 1000)
        break;
      console.log(n);
    }
    ```

* Generators

    ```js
    var fibonacci = {
      [Symbol.iterator]: function*() {
        var pre = 0, cur = 1;
        for (;;) {
          var temp = pre;
          pre = cur;
          cur += temp;
          yield cur;
        }
      }
    }
    
    for (var n of fibonacci) {
      // truncate the sequence at 1000
      if (n > 1000)
        break;
      console.log(n);
    }
    ```

* Unicode

    ```js
    // same as ES5.1
    "𠮷".length == 2
    
    // new RegExp behaviour, opt-in ‘u’
    "𠮷".match(/./u)[0].length == 2
    
    // new form
    "\u{20BB7}" == "𠮷" == "\uD842\uDFB7"
    
    // new String ops
    "𠮷".codePointAt(0) == 0x20BB7
    
    // for-of iterates code points
    for(var c of "𠮷") {
      console.log(c);
    }
    ```
    
* Modules

    定义1
    ```js
    // lib/math.js
    export function sum(x, y) {
      return x + y;
    }
    export var pi = 3.141593;
    
    ```
    
    引入1
    ```js
    // app.js
    import * as math from "lib/math";
    console.log("2π = " + math.sum(math.pi, math.pi));
    ```
    
    定义2
    ```js
    // lib/mathplusplus.js
    export * from "lib/math";
    export var e = 2.71828182846;
    export default function(x) {
        return Math.exp(x);
    }
    ```

    引入2
    ```js
    // app.js
    import exp, {pi, e} from "lib/mathplusplus";
    console.log("e^π = " + exp(pi));
    ```
* Module Loaders

    该部分并不包含在 ECMAScript 2015 规范中，而是留给实现部分。Module loader 职责包含：

    * Dynamic loading
    * State isolation
    * Global namespace isolation
    * Compilation hooks
    * Nested virtualization
    
* Map + Set + WeakMap + WeakSet
    
    ```js
    var s = new Set();
    s.add("hello").add("goodbye").add("hello");
    s.size === 2;
    s.has("hello") === true;
    
    // Maps
    var m = new Map();
    m.set("hello", 42);
    m.set(s, 34);
    m.get(s) == 34;
    
    // Weak Maps
    var wm = new WeakMap();
    wm.set(s, { extra: 42 });
    wm.size === undefined
    
    // Weak Sets
    var ws = new WeakSet();
    ws.add({ data: 42 });
    // Because the added object has no other references, it will not be held in the set
    ```

* Proxies

    ```js
    // Proxying a normal object
    var target = {};
    var handler = {
      get: function (receiver, name) {
        return `Hello, ${name}!`;
      }
    };
    
    var p = new Proxy(target, handler);
    p.world === "Hello, world!";
    ```
    
    ```js
    // Proxying a function object
    var target = function () { return "I am the target"; };
    var handler = {
      apply: function (receiver, ...args) {
        return "I am the proxy";
      }
    };
    
    var p = new Proxy(target, handler);
    p() === "I am the proxy";
    ```
    
    ```js
    var handler =
    {
      // target.prop
      get: ...,
      // target.prop = value
      set: ...,
      // 'prop' in target
      has: ...,
      // delete target.prop
      deleteProperty: ...,
      // target(...args)
      apply: ...,
      // new target(...args)
      construct: ...,
      // Object.getOwnPropertyDescriptor(target, 'prop')
      getOwnPropertyDescriptor: ...,
      // Object.defineProperty(target, 'prop', descriptor)
      defineProperty: ...,
      // Object.getPrototypeOf(target), Reflect.getPrototypeOf(target),
      // target.__proto__, object.isPrototypeOf(target), object instanceof target
      getPrototypeOf: ...,
      // Object.setPrototypeOf(target), Reflect.setPrototypeOf(target)
      setPrototypeOf: ...,
      // for (let i in target) {}
      enumerate: ...,
      // Object.keys(target)
      ownKeys: ...,
      // Object.preventExtensions(target)
      preventExtensions: ...,
      // Object.isExtensible(target)
      isExtensible :...
    }
    ```
    
* Symbols

* Subclassable Built-ins

    ```js
    // User code of Array subclass
    class MyArray extends Array {
        constructor(...args) { super(...args); }
    }
    
    var arr = new MyArray();
    arr[1] = 12;
    arr.length == 2
    ```
    
* Math + Number + String + Object APIs

    ```js
    Number.EPSILON
    Number.isInteger(Infinity) // false
    Number.isNaN("NaN") // false
    
    Math.acosh(3) // 1.762747174039086
    Math.hypot(3, 4) // 5
    Math.imul(Math.pow(2, 32) - 1, Math.pow(2, 32) - 2) // 2
    
    "abcde".includes("cd") // true
    "abc".repeat(3) // "abcabcabc"
    
    Array.from(document.querySelectorAll("*")) // Returns a real Array
    Array.of(1, 2, 3) // Similar to new Array(...), but without special one-arg behavior
    [0, 0, 0].fill(7, 1) // [0,7,7]
    [1,2,3].findIndex(x => x == 2) // 1
    ["a", "b", "c"].entries() // iterator [0, "a"], [1,"b"], [2,"c"]
    ["a", "b", "c"].keys() // iterator 0, 1, 2
    ["a", "b", "c"].values() // iterator "a", "b", "c"
    
    Object.assign(Point, { origin: new Point(0,0) })
    ```
* Binary and Octal Literals

    ```js
    0b111110111 === 503 // true
    0o767 === 503 // true
    ```
* Promises
    
    ```js
    function timeout(duration = 0) {
        return new Promise((resolve, reject) => {
            setTimeout(resolve, duration);
        })
    }
    
    var p = timeout(1000).then(() => {
        return timeout(2000);
    }).then(() => {
        throw new Error("hmm");
    }).catch(err => {
        return Promise.all([timeout(100), timeout(200)]);
    })
    ```
    
* Reflect API

    ```js
    var O = {a: 1};
    Object.defineProperty(O, 'b', {value: 2});
    O[Symbol('c')] = 3;
    
    Reflect.ownKeys(O); // ['a', 'b', Symbol(c)]
    
    function C(a, b){
      this.c = a + b;
    }
    var instance = Reflect.construct(C, [20, 22]);
    instance.c; // 42
    ```

* Tail Calls

    ```js
    function factorial(n, acc = 1) {
        "use strict";
        if (n <= 1) return acc;
        return factorial(n - 1, n * acc);
    }
    
    // Stack overflow in most implementations today,
    // but safe on arbitrary inputs in ES2015
    factorial(100000)
    ```



