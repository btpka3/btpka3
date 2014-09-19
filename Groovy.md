# 为类添加静态方法

```groovy
Object.metaClass.static.hi = {println "hi,"+it}                            
Object.metaClass.static.hi = {String str-> println "hi-" + str}
Object.metaClass.static.getMyClassName = { delegate.name }
Integer.hi()    // 无参函数
Integer.hi("a") // 含参函数
println Integer.myClassName // java.lang.Integer  
```

# 为类添加预定义的新方法、属性

```groovy
# 追加方法
Object.metaClass.hi = {println "hi,"+it}                            
Object.metaClass.hi = {String str-> println "hi-" + str}
// 追加属性：命名要求是 getXxx
Object.metaClass.getMyClassName { delegate.getClass().getName() }
1.hi()    // 无参函数
1.hi("a") // 含参函数
println 1.myClassName  
```

# 为类添加动态发现的新方法、属性


# 为特定的实例添加方法

```groovy
def a = "a" 
def b = "b" 

a.metaClass.hi{println "hi,$delegate"}

a.hi()
b.hi()  // ERROR 
```

# TODO 为特定的实例添加新属性
