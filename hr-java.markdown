
问：以下两个controller分别执行，那些记录会插入到数据库中？

```java
@Transactional(REQUIRE)
AaaService{
    exec(){
        insertRec1();
        bbbService.exec();
        insertRec2();
    }
}

@Transactional(REQUIRE)
BbbService{
    exec(){
        insertRec3();
        throw exception;
        insertRec4();
    }
}

@Transactional(REQUIRE)
CccService{
    exec(){
        insertRec5();
        insertRec6();
    }
}

YyyController{  // 没有任何AOP
    indexAction(){
        aaaService.exec();
    }
}

XxxController{  // 没有任何AOP
    indexAction(){
        cccService.exec();
        bbbService.exec();
    }
}
```