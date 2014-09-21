# maven 
http://gmaven.codehaus.org/Home



# 为类添加静态方法
[ExpandoMetaClass](http://groovy.codehaus.org/ExpandoMetaClass)、
[MetaClasses](http://groovy.codehaus.org/JN3525-MetaClasses)、
[Per-Instance MetaClass](http://groovy.codehaus.org/Per-Instance+MetaClass)

per-Instance 与 其 metaClass 存储在 org.codehaus.groovy.reflection.ClassInfo#perInstanceMetaClassMap 中，参见348行。


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
// 追加方法
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

# FIXME

```groovy
// export JAVA_OPTS="-Xmx12M -XX:-UseGCOverheadLimit -Xloggc:gc.log -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=oom.dump.hprof"
// 1. 限定最大堆内存大小，
// 2. 不抛出 java.lang.OutOfMemoryError: GC overhead limit exceeded
// 3. 记录gc日志
// 4. 内存溢出时，dump出内存
// groovy GMain.groovy
// 该测试用例大约在 250 次的时候出错
class GMain {

	static main(args) {
		def r = new Random()

		500.times { i ->
			def str = r.nextInt().toString()
			def list = []
			10.times {
				list << r.nextInt()
			}
			str.metaClass.bbb = {list}
			println "${i} : ${str}.bbb = ${str.bbb()}"
		}
	}
}

```
