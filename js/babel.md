

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

