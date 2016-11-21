# mongodb使用总结


[MongoDB Grails示例](https://github.com/btpka3/btpka3.github.com/tree/master/grails/my-mongo)

### 【grom】非内嵌类使用many-to-one or one-to-one等问题

```
   若非内嵌类，则不能使用类似belongsTo = [xx:XX] 或者 hasOne = [xx:XX] 或者 XX xx等的关联方式，需要指定使用String xxId
```
### 【grom】非内嵌类使用one-to-many等问题

```
若非内嵌类，则不能使用类似List<XX> xxs的关联方式，否则虽不会报错，
但是却不能正常保存（保存的都为null）；然而可以使用hasMany = [xxs: XX]的方式
```

### 【grom】数组查询

```
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

### 牵涉大数据量，多表查询并且分页

1. 使用定时任务定期 mapRecude 维护数据，要设计成可全量的，也可以增量的
2. 管理后台需要有相关的画面来手动触发
3. mapRecude 定时任务流程
    * GMONGO API: MapReduce 表A，以A表ID为主键区分，将结果存储到表 TmpXXX中( 只维护部分字段)
    * GMONGO API: MapReduce 表B，以A表ID为主键区分，将结果存储到表 TmpXXX中( 只维护另外一部分字段)

4. 查询流程
    * GMONGO API: where 过滤、排序、分页，查询出页面所需记录的ID列表
    * GORM API: 根据ID列表获取相关对象列表（注意顺序需要与ID列表中的一致）

参考：
* [Mongo Map-Reduce](http://docs.mongodb.org/manual/core/map-reduce/)
* [GMongo Map-Reduce demo](https://github.com/poiati/gmongo#mapreduce)
* [GORM Mongo Map-Reduce](http://stackoverflow.com/questions/5681851/mongodb-combine-data-from-multiple-collections-into-one-how/8746805#8746805)

### 查询

```js
db.user.find({phone:"17011223344"}).pretty();
```

### 更新

```js


// 数组
db.order.update({'orderItems.refund':"5656cdb6e4b07eb5d99b9767"}, { $set:{ "orderItems.0.refund" : null}}, {upsert:false});
```
