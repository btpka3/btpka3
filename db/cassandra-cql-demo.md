
参考：
* 《[Cassandra Query Language (CQL) v3.1.7](http://cassandra.apache.org/doc/cql3/CQL.html)》
* 《[CQL for Cassandra 2.x](http://www.datastax.com/documentation/cql/3.1/cql/cql_reference/counter_type.html)》
* 《[CQL for Cassandra 1.2 : Using collections](http://www.datastax.com/documentation/cql/3.0/cql/cql_using/use_collections_c.html)》


# cql 实例

## 重建 keyspace

```sql
-- 创建 keyspace
drop keyspace if exists test;
create keyspace if not exists test
        with replication = { 'class' : 'SimpleStrategy', 'replication_factor' : 1 }
        and durable_writes = true;
use test;
describe keyspace test;

--- 查看 keyspace
SELECT * FROM system.schema_keyspaces WHERE keyspace_name = 'test';
```

## 重建表

```sql
-- 重建表
drop table if exists xxx;
create table if not exists xxx (
    id text,
    sid text,
    name text,
    tags set<text>,
    addrs list<text>,
    extra map<text,text>,
    memo text,
    primary key(id, sid)
);

-- 创建索引 : 使用默认命名规则 "${表名}_${列名}_idx"
create index on xxx(name);
create index on xxx(tags);
create index on xxx(addrs);
create index on xxx(extra);

-- 查看表
describe table xxx;

-- 说明
-- partition key       = id (主键中的第一个）
-- clustering collumns = sid (主键中的非第一列）
-- indexed collumns    = name, tags, addrs, extra
-- common collumns     = memo
```


## 插入记录

```sql

-- 插入记录, 主键必须齐全。
insert into xxx (
        id,
        sid,
        name,
        tags,
        addrs,
        extra,
        memo
    ) values (
        '1',
        'sid1',
        'name1',
        {'tag3', 'tag4'},
        ['addr3', 'addr4'],
        {'key3' : 'value3', 'key4' : 'value4'},
        'memo1'
    );

-- insert : 可以使用if语句，以防止重复插入（轻量级事务，性能不确定，应避免使用）
--          if not exists 仅仅指主键。
insert into xxx (id, sid) values ('3','sid3') if not exists;
```

## 查询

### 按列的分类单独做 where 条件

```sql

-- select : where (OK) : 没有 where 条件
select * from xxx;

-- select : where  (OK) : partition key 单独作为 where 条件
select * from xxx where id = '1';

-- select : where  (WARN) :  clustering collumns 不可单独作为 where 条件，除非 ALLOW FILTERING
select * from xxx where sid = 'sid1';

-- select : where  (OK) : indexed collumns (值)可以单独作为 where 条件。
select * from xxx where name = 'name1';
select * from xxx where tags contains 'tag3';
select * from xxx where addrs contains 'addr3';
select * from xxx where extra contains 'value3';

-- select : where  (ERROR) : indexed collumns (Map的key) 不能作为 where 条件。
select * from xxx where extra contains key 'key3';

-- select : where  (ERROR) : 普通数据列不能作为 where 条件。
select * from xxx where memo = 'memo1';
```

### 列的分类组合做 where 条件

```sql
-- select : where  (OK) : clustering collumns 可以和 partition key 一起作为 where 条件。
select * from xxx where id = '1' and sid = 'sid1';

-- select : where  (OK) : clustering collumns 可以和 indexed collumns (值)一起作为 where 条件。
select * from xxx where sid = 'sid1' and name = 'name1';
select * from xxx where sid = 'sid1' and tags contains 'tag3';
select * from xxx where sid = 'sid1' and addrs contains 'addr3';
select * from xxx where sid = 'sid1' and extra contains 'value3';
```

## 更新

### 普通字段更新

```sql
-- update : where 条件中只能是主键，且必须要全部出现，且只能使用 `=`
update xxx set memo = 'memo2' where id = '1' and sid = 'sid1';

-- update : 匹配的记录不存在时，实际相当于插入，需要注意。
update xxx set memo = 'memo2' where id = '2' and sid = 'sid2';

-- update : 可以使用if语句，作用相当于乐观锁（轻量级事务，性能不确定，应避免使用）
update xxx set memo = 'memo3' where id = '1' and sid = 'sid1' if memo='memo2';

-- update : 普通字段、集合中的每个元素都可以单独设置 TTL
update xxx using ttl 30000 set extra['key3'] = 'value3' where id = '1' and sid = 'sid1';
```


### 集合类 set 字段更新

```sql
-- update : collections : set : add (set是插入时无序的，读取时是自然排序的)
update xxx set tags = tags + {'tag6', 'tag1'} where id = '1' and sid = 'sid1';

-- update : collections : set : remove
update xxx set tags = tags - {'tag4'} where id = '1' and sid = 'sid1';

-- update : collections : set : clear
update xxx set tags = {} where id = '1' and sid = 'sid1';
update xxx set tags = null where id = '1' and sid = 'sid1';
delete tags from xxx where id = '1' and sid = 'sid1';
```

### 集合类 list 字段更新

```sql
-- update : collections : list : append (list是有序的)
update xxx set addrs = addrs + ['addr6'] where id = '1' and sid = 'sid1';

-- update : collections : list : prepend (list是有序的)
update xxx set addrs = ['addr1'] + addrs where id = '1' and sid = 'sid1';

-- update : collections : list : update (特定位置替换, 下标不能超过当前size)
update xxx set addrs[1] = 'addr2' where id = '1' and sid = 'sid1';

-- update : collections : list : remove
update xxx set addrs = addrs - ['addr4','addr2'] where id = '1' and sid = 'sid1';

-- update : collections : list : clear
update xxx set addrs = [] where id = '1' and sid = 'sid1';
update xxx set addrs = null where id = '1' and sid = 'sid1';
delete addrs from xxx where id = '1' and sid = 'sid1';
```

### 集合类 map 字段更新

```sql
-- update : collections : map : add/update
update xxx set extra['key5'] = 'value5' where id = '1' and sid = 'sid1';

-- update : collections : map : remove
update xxx set extra['key5'] = null where id = '1' and sid = 'sid1';
delete extra['key4'] from xxx where id = '1' and sid = 'sid1';

-- update : collections : map : clear
update xxx set extra = {} where id = '1' and sid = 'sid1';
update xxx set extra = null where id = '1' and sid = 'sid1';
delete extra from xxx where id = '1' and sid = 'sid1';
```

## 删除

```sql
-- delete
delete from xxx where id = '1' and sid = 'sid1';
```