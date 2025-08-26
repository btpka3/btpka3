class MyClass {
    public Object getProperty(String name) {
        boolean hasProperty = metaClass.hasProperty(this, name) != null;
        Object value = null;
        if("x02".equals(name)){
            value = "x02-2";
        } else if("y02".equals(name)){
            value = "y02-2";
        } else {
            value = metaClass.getProperty(this, name);
        }
        return value + ":hasProperty=" + hasProperty;
    }

    // x01: field:✅, getter:❌, getProperty特殊逻辑:❌
    // 注意：groovy 也不会自动给生成getter
    private String x01 = "x01-1";

    // x02: field:✅, getter:❌, getProperty特殊逻辑:✅
    private String x02 = "x02-1";


    // // x01: field:❌, getter:✅, getProperty特殊逻辑:❌
    // public String getX01() {
    //     return "x01-1";
    // }
    // // x02: field:❌, getter:✅, getProperty特殊逻辑:✅
    // public String getX02() {
    //     return "x02-1";
    // }


    // y01: field:❌, getter:✅, getProperty特殊逻辑:❌
    public String getY01() {
        return "y01-1";
    }

    // y02: field:❌, getter:✅, getProperty特殊逻辑:✅
    public String getY02() {
        return "y02-1";
    }

    // ⚠️：x01是直接访问field，没经过 getProperty("x01")
    // ⚠️：y02是 getProperty("y01")
    public String getZ01() {
        return x01+", "+y01+", z01-1";
    }
    // ⚠️：x02是直接访问field，没经过 getProperty("x02")
    // ⚠️：y02是 getProperty("y02")
    public String getZ02() {
        return x02+", "+y02+", z02-1";
    }
}

var myObj = new MyClass();

// 解释: 先调用 getProperty("x01"), 再调用 getX01()
println "x01        = " + myObj.x01;
// 解释: 通过 `@` 直接访问 field
println "@x01       = " + myObj.@x01;

// ❌ 异常: groovy.lang.MissingMethodException: No signature of method: MyClass.getX01() ...
// println "getX01()   = " + myObj.getX01();

println "x02        = " + myObj.x02;

// 解释: 先调用 getProperty("y01"), 再调用 getY01()
println "y01        = " + myObj.y01;
println "getY01()   = " + myObj.getY01();

println "y02        = " + myObj.y02;
// 解释: 没有调用 getProperty("y02"), 直接调用getY02()
println "getY02()   = " + myObj.getY02();

println "getZ01()   = " + myObj.getZ01();
println "getZ02()   = " + myObj.getZ02();


/*  grppvy testGetter.groovy : 输出:
x01        = x01-1:hasProperty=true
@x01       = x01-1
x02        = x02-2:hasProperty=true
y01        = y01-1:hasProperty=true
getY01()   = y01-1
y02        = y02-2:hasProperty=true
getY02()   = y02-1
getZ01()   = x01-1, y01-1:hasProperty=true, z01-1
getZ02()   = x02-1, y02-2:hasProperty=true, z02-1
*/
