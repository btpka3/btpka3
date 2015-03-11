# mongodb使用总结

### 【grom】非内嵌类使用many-to-one or one-to-one等问题

```groovy
   若非内嵌类，则不能使用类似belongsTo = [xx:XX] 或者 hasOne = [xx:XX] 或者 XX xx等的关联方式，需要指定使用String xxId
```
### 【grom】非内嵌类使用one-to-many等问题

```groovy
若非内嵌类，则不能使用类似List<XX> xxs的关联方式，否则虽不会报错，
但是却不能正常保存（保存的都为null）；然而可以使用hasMany = [xxs: XX]的方式
```

### 【grom】数组查询

```groovy
   假设Cart中有List<String> strIds；则可以针对数组进行各式查询：
   * 精确查询 -- （包括数组的顺序） -- 查询出strIds为["a0","a1","a2"]的数据
     def cartList = Cart.createCriteria().list {
            eq("strIds", ["a0","a1","a2"])
     }
   * 模糊查询 -- 数组包含即可 -- 查询出所有strIds中包含a8的数据
     def cartList = Cart.createCriteria().list {
            eq("strIds", "a8")
     }
   * 下标查询 -- 查询出所有strIds中下标8的值为a8的数据
     def cartList = Cart.createCriteria().list {
            eq("strIds.8", "a8")
     }
```