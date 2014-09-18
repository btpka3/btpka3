# 业务组合主键

```
class Xxx {
    static constraints = {
        a nullable : false
        b nullable : false
        c nullable : false, unique: ['a','b']
    }
    String a
    String b
    String c
    String d
}

// FIXME ：SQL 组合主键。
```


# 一对一 双向

```
class Face {
    static hasOne = [nose:Nose]
    static constraints = { nose unique: true } 
}
class Nose {
    Face face
}

```