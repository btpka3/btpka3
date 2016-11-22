
* [CQL for Cassandra 2.x](http://www.datastax.com/documentation/cql/3.1/cql/cql_intro_c.html)
* [CQL语法参考](http://cassandra.apache.org/doc/cql3/CQL.html)
* [CQL客户端](http://wiki.apache.org/cassandra/ClientOptions)
* [Cassandra建模--DataModel](http://wiki.apache.org/cassandra/DataModel)

keyspace名、表名、列名在 CQL 3中是大小写不敏感的，除非使用双引号。cassandra内部是使用小写存储的。



# 数据类型

|type|表达形式|description|
|---|---|---|
|ascii     |string | ASCII字符串|
|bigint    |integer|64位有符号 long型|
|blob      |blob           |任意长度的字节，十六进制字符串|
|boolean   |boolean|true/false，大小写不敏感|
|counter   |integer|64位有符号值|
|decimal   |integer、浮点型|可变精度的数值|
|double    |integer|64位 IEEE-754 浮点型|
|float     |integer、浮点型|32位 IEEE-754 浮点型|
|inet      |string|IP地址。4个字节长的IPv4地址或者16字节长的IPv6地址|
|int       |integer|32位有符号整型|
|text      |string|UTF-8编码的字符串，是varchar的别名|
|timestamp |integer，string|时间戳|
|timeuuid  |uuid | type 1 UUID |
|uuid      |uuid | type 1 或者 type 4 UUID|
|varchar   |string| UTF-8编码的字符串|
|varint    |integer| 任意精度的整形|

# 表达形式

|literals|description |
|----|----|
|blob       |十六进制|
|boolean    |`true`,`false`. 大小写不敏感|
|numeric    |正则表达式为： `'-'?[0-9]+('.'[0-9]*)?([eE][+-]?[0-9+])?` |
|identifier |字母开头，后面为字母、数字、下划线。keyspace名、表名、列名等均为identifier|
|integer    |由可选的减号开始，一个或多个数字组成|
|string     |单引号括起来，如果需要包含单引号，需使用两个单引号代替（转义）|
|uuid       |32个十六进制字符，0-9,a-f。不区分大小写，在第8、12、16、20个字符之后插入减号 '-'，比如  01234567-0123-0123-0123-0123456789ab|
|timeuuid   |为从 00:00:00.00 UTC开始以100纳秒为间隔的时间（60bit）,时钟序列（防重复）（14bit）， IEEE 801 MAC地址（48bit）|


## 日期类型
日期类型的字符串表达形式可以是：
* 2011-02-03 04:05+0000
* 2011-02-03 04:05:00+0000
* 2011-02-03 04:05:00.000+0000
* 2011-02-03T04:05+0000
* 2011-02-03T04:05:00+0000
* 2011-02-03T04:05:00.000+0000

# 集合
集合不能嵌套集合。

## set

获取后的结果是经过排序的

```sql

CREATE TABLE users (
  user_id text PRIMARY KEY,
  first_name text,
  last_name text,
  emails set<text>
);

-- 插入
INSERT INTO users (user_id, first_name, last_name, emails)
  VALUES('frodo', 'Frodo', 'Baggins', {'f@baggins.com', 'baggins@gmail.com'});


-- 使用减号移除一个元素
UPDATE users
  SET emails = emails - {'fb@friendsofmordor.org'} WHERE user_id = 'frodo';

-- 移除所有
UPDATE users SET emails = {} WHERE user_id = 'frodo';
DELETE emails FROM users WHERE user_id = 'frodo';

```


## list
获取后的结果是插入时的顺序。

```sql
ALTER TABLE users ADD top_places list<text>;

-- 全部替换
UPDATE users
  SET top_places = [ 'rivendell', 'rohan' ] WHERE user_id = 'frodo';

--在最前面插入元素
UPDATE users
  SET top_places = [ 'the shire' ] + top_places WHERE user_id = 'frodo';

--在最后面追加元素
UPDATE users
  SET top_places = top_places + [ 'mordor' ] WHERE user_id = 'frodo';

--在特定位置插入元素（轻易不要使用，性能较低）
UPDATE users SET top_places[2] = 'riddermark' WHERE user_id = 'frodo';

--删除特定位置上的元素
DELETE top_places[3] FROM users WHERE user_id = 'frodo';

--按值删除（推荐该方式，原子性。否则，如果先查在更新，可能线程不安全）
UPDATE users
  SET top_places = top_places - ['riddermark'] WHERE user_id = 'frodo';
```

## map

```sql
ALTER TABLE users ADD todo map<timestamp, text>;

-- 更新值
UPDATE users
   SET todo = {
           '2012-9-24'       : 'enter mordor',
           '2012-10-2 12:00' : 'throw ring into mount doom'
       }
 WHERE user_id = 'frodo';

INSERT INTO users (todo)
     VALUES ({
                '2013-9-22 12:01'  : 'birthday wishes to Bilbo',
                '2013-10-1 18:00' : 'Check into Inn of Prancing Pony'
            });

-- 更新指定key
UPDATE users
   SET todo['2012-10-2 12:00'] = 'throw my precious into mount doom'
 WHERE user_id = 'frodo';

-- 删除指定key
DELETE todo['2012-9-24'] FROM users WHERE user_id = 'frodo';

-- 更新指定key并设定TTL
UPDATE users USING TTL <computed_ttl>
  SET todo['2012-10-1'] = 'find water' WHERE user_id = 'frodo';
```


# functions

```
create table dual (val text primary key);
insert into dual (val) values('X') if not exists;
```

|type|function | description |
|---|---|---|
|blob          |${type}AsBlob(typedObj) | INSERT INTO xxTable (blobCol) VALUES (bigintAsBlob(3));|
|blob          |blobAs${type}(blobObj)  | INSERT INTO xxTable (bigintCol) VALUES (blobAsBigint(0x0000000000000003));
|uuid/timeuuid |dateOf(timeuuidObj)|select dateOf(now()) from system.schema_keyspaces limit 1|
|uuid/timeuuid |now()|select now() from system.schema_keyspaces limit 1|
|uuid/timeuuid |minTimeuuid(timestampStr) |SELECT * FROM myTable WHERE t > maxTimeuuid('2013-01-01 00:05+0000')|
|uuid/timeuuid |maxTimeuuid(timestampStr) |SELECT * FROM myTable WHERE t > maxTimeuuid('2013-02-02 10:00+0000')|
|uuid/timeuuid |unixTimestampOf(timeuuidObj) |select unixTimestampOf(now()) from system.schema_keyspaces limit 1|
|token         |token(obj) |select * from system.schema_keyspaces where token(keyspace_name) > token('21')|
|WRITETIME     |writetime(colName)|select keyspace_name, writetime(durable_writes) from system.schema_keyspaces|
|TTL           |ttl(colName)|select keyspace_name, ttl(durable_writes) from system.schema_keyspaces|
|count         |count(*), count(1) | select count(*) from system.schema_keyspaces |


where条件
|type|description|
|---|---|
|partition key| 只能用 "=", "IN"。如果使用 token() 函数，则可以使用 ">", ">=", "<", "<="|
|clustering collumn|在使用 ALLOW FILTERING时，可以单独作为where条件，否则需要与partition key、索引列，结合使用|