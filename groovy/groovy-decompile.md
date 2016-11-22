## groovy 反编译

Groovy 是动态语言，扩展了Java语法，最终还是要编译成字节码( *.class )，运行在 Java 虚拟机上的。那么，从 *.groovy 到 *.class 都发生了什么？我们且反编译一些字节码看看吧。



### Test.groovy

```groovy
package me.test

class Test {

    def hi(name){
        println "hi, ${name}!"
    }

    static main(args) {
        def t = new Test();
        t.hi("world")
        t.metaClass .aaa=222
        def str = "xxx"
        str.metaClass .yyy="zzz"
        println str.yyy
    }
}
```

### Test.java

```java
/*
 * Decompiled with CFR 0_87.
 *
 * Could not load the following classes:
 *  groovy.lang.GroovyObject
 *  groovy.lang.MetaClass
 *  org.codehaus.groovy.reflection.ClassInfo
 *  org.codehaus.groovy.runtime.GStringImpl
 *  org.codehaus.groovy.runtime.ScriptBytecodeAdapter
 *  org.codehaus.groovy.runtime.callsite.CallSite
 *  org.codehaus.groovy.runtime.callsite.CallSiteArray
 *  org.codehaus.groovy.runtime.typehandling.ShortTypeHandling
 */
package me.test;

import groovy.lang.GroovyObject;
import groovy.lang.MetaClass;
import org.codehaus.groovy.reflection.ClassInfo;
import org.codehaus.groovy.runtime.GStringImpl;
import org.codehaus.groovy.runtime.ScriptBytecodeAdapter;
import org.codehaus.groovy.runtime.callsite.CallSite;
import org.codehaus.groovy.runtime.callsite.CallSiteArray;
import org.codehaus.groovy.runtime.typehandling.ShortTypeHandling;

public class Test
implements GroovyObject {
    private static /* synthetic */ ClassInfo $staticClassInfo;
    public static transient /* synthetic */ boolean __$stMC;
    private transient /* synthetic */ MetaClass metaClass;
    private static /* synthetic */ SoftReference $callSiteArray;

    public Test() {
        MetaClass metaClass;
        Test test;
        CallSite[] arrcallSite = Test.$getCallSiteArray();
        this.metaClass = metaClass = this.$getStaticMetaClass();
    }

    public Object hi(Object name) {
        CallSite[] arrcallSite = Test.$getCallSiteArray();
        return arrcallSite[0].callCurrent((GroovyObject)this, (Object)new GStringImpl(new Object[]{name}, new String[]{"hi, ", "!"}));
    }

    public static /* varargs */ void main(String ... args) {
        CallSite[] arrcallSite = Test.$getCallSiteArray();
        Object t = arrcallSite[1].callConstructor((Object)Test.class);
        arrcallSite[2].call(t, (Object)"world");
        int n = 222;
        ScriptBytecodeAdapter.setProperty((Object)n, (Class)null, (Object)arrcallSite[3].callGetProperty(t), (String)"aaa");
        String str = "xxx";
        String string = "zzz";
        ScriptBytecodeAdapter.setProperty((Object)string, (Class)null, (Object)arrcallSite[4].callGetProperty((Object)str), (String)"yyy");
        arrcallSite[5].callStatic((Class)Test.class, arrcallSite[6].callGetProperty((Object)str));
    }

    public /* synthetic */ Object this$dist$invoke$1(String name, Object args) {
        CallSite[] arrcallSite = Test.$getCallSiteArray();
        return ScriptBytecodeAdapter.invokeMethodOnCurrentN((Class)Test.class, (GroovyObject)this, (String)ShortTypeHandling.castToString((Object)new GStringImpl(new Object[]{name}, new String[]{"", ""})), (Object[])ScriptBytecodeAdapter.despreadList((Object[])new Object[0], (Object[])new Object[]{args}, (int[])new int[]{0}));
    }

    public /* synthetic */ void this$dist$set$1(String name, Object value) {
        CallSite[] arrcallSite = Test.$getCallSiteArray();
        Object object = value;
        ScriptBytecodeAdapter.setGroovyObjectProperty((Object)object, (Class)Test.class, (GroovyObject)this, (String)ShortTypeHandling.castToString((Object)new GStringImpl(new Object[]{name}, new String[]{"", ""})));
    }

    public /* synthetic */ Object this$dist$get$1(String name) {
        CallSite[] arrcallSite = Test.$getCallSiteArray();
        return ScriptBytecodeAdapter.getGroovyObjectProperty((Class)Test.class, (GroovyObject)this, (String)ShortTypeHandling.castToString((Object)new GStringImpl(new Object[]{name}, new String[]{"", ""})));
    }

    protected /* synthetic */ MetaClass $getStaticMetaClass() {
        ClassInfo classInfo;
        if (this.getClass() != Test.class) {
            return ScriptBytecodeAdapter.initMetaClass((Object)this);
        }
        if ((classInfo = Test.$staticClassInfo) == null) {
            Test.$staticClassInfo = classInfo = ClassInfo.getClassInfo(this.getClass());
        }
        return classInfo.getMetaClass();
    }

    public /* synthetic */ MetaClass getMetaClass() {
        MetaClass metaClass = this.metaClass;
        if (metaClass != null) {
            return metaClass;
        }
        this.metaClass = this.$getStaticMetaClass();
        return this.metaClass;
    }

    public /* synthetic */ void setMetaClass(MetaClass metaClass) {
        this.metaClass = metaClass;
    }

    public /* synthetic */ Object invokeMethod(String string, Object object) {
        return this.getMetaClass().invokeMethod((Object)this, string, object);
    }

    public /* synthetic */ Object getProperty(String string) {
        return this.getMetaClass().getProperty((Object)this, string);
    }

    public /* synthetic */ void setProperty(String string, Object object) {
        this.getMetaClass().setProperty((Object)this, string, object);
    }

    public static /* synthetic */ void __$swapInit() {
        CallSite[] arrcallSite = Test.$getCallSiteArray();
        Test.$callSiteArray = null;
    }

    static {
        Test.__$swapInit();
    }

    public /* synthetic */ void super$1$wait() {
        super.wait();
    }

    public /* synthetic */ String super$1$toString() {
        return super.toString();
    }

    public /* synthetic */ void super$1$wait(long l) {
        super.wait(l);
    }

    public /* synthetic */ void super$1$wait(long l, int n) {
        super.wait(l, n);
    }

    public /* synthetic */ void super$1$notify() {
        super.notify();
    }

    public /* synthetic */ void super$1$notifyAll() {
        super.notifyAll();
    }

    public /* synthetic */ Class super$1$getClass() {
        return super.getClass();
    }

    public /* synthetic */ Object super$1$clone() {
        return super.clone();
    }

    public /* synthetic */ boolean super$1$equals(Object object) {
        return super.equals(object);
    }

    public /* synthetic */ int super$1$hashCode() {
        return super.hashCode();
    }

    public /* synthetic */ void super$1$finalize() {
        super.finalize();
    }

    private static /* synthetic */ void $createCallSiteArray_1(String[] arrstring) {
        arrstring[0] = "println";
        arrstring[1] = "<$constructor$>";
        arrstring[2] = "hi";
        arrstring[3] = "metaClass";
        arrstring[4] = "metaClass";
        arrstring[5] = "println";
        arrstring[6] = "yyy";
    }

    private static /* synthetic */ CallSiteArray $createCallSiteArray() {
        String[] arrstring = new String[7];
        Test.$createCallSiteArray_1(arrstring);
        return new CallSiteArray((Class)Test.class, arrstring);
    }

    private static /* synthetic */ CallSite[] $getCallSiteArray() {
        CallSiteArray callSiteArray;
        if (Test.$callSiteArray == null || (callSiteArray = (CallSiteArray)Test.$callSiteArray.get()) == null) {
            callSiteArray = Test.$createCallSiteArray();
            Test.$callSiteArray = new SoftReference<CallSiteArray>(callSiteArray);
        }
        return callSiteArray.array;
    }

    static /* synthetic */ Class class$(String string) {
        try {
            return Class.forName(string);
        }
        catch (ClassNotFoundException var1_1) {
            throw new NoClassDefFoundError(var1_1.getMessage());
        }
    }
}
```