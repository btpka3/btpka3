

# 为所有对象添加新方法

```groovy
Object.metaClass.hi = {println "hi,"+it}                            
Object.metaClass.hi = {String str-> println "hi-" + str}
Object.metaClass.getMyClassName { delegate.getClass().getName() }
1.hi()    // 无参函数
1.hi("a") // 含参函数
println 1.myClassName
```

# 为所有对象添加新属性
