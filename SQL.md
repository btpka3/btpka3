# Q1: 找出总分最高的学生

```sql
CREATE TABLE a
(
  id integer primary key,
  name character varying(128),
  subject character varying(128),
  score integer
);

INSERT INTO a VALUES (1,'张3','语文',80);
INSERT INTO a VALUES (2,'张3','数学',80);
INSERT INTO a VALUES (3,'李4','语文',90);
INSERT INTO a VALUES (4,'李4','数学',90);
INSERT INTO a VALUES (5,'王5','语文',90);
INSERT INTO a VALUES (6,'王5','数学',80);
INSERT INTO a VALUES (7,'贾6','语文',90);
INSERT INTO a VALUES (8,'贾6','数学',90);
```

A1:
```sql
select t1.name
  from (select name, sum(score) as totalScore from a group by name) as t1
 where t1.totalScore = (select max(t2.totalScore) from 
       (select name, sum(score) as totalScore from a group by name) as t2)
```
A2:

```sql
-- having？
```


# Q: 表A和表B除了ID字段名不一样，其他字段名称一直。要求一条SQL查询出相同字段名称不同值的记录（含所在表的ID）。

```sql

CREATE TABLE A (
   id_a varchar(10) PRIMARY KEY, 
   col1 varchar(10), 
   col2 varchar(10)
) 
CREATE TABLE B (
   id_b varchar(10) PRIMARY KEY, 
   col1 varchar(10), 
   col2 varchar(10)
) 

insert into a values ('a1', '1', '1');
insert into a values ('a2', '2', '2');

insert into b values ('b2', '2', '2');
insert into b values ('b3', '3', '3');


select a.id_a AS id, a.col1 AS col1, a.col2 AS col2, 'A' AS src from A a where not exists ( select * from B b where a.col1=b.col1 and a.col2=b.col2 )
union
select b.id_b AS id, b.col1 AS col1, b.col2 AS col2, 'B' AS src from B b where not exists ( select * from A a where a.col1=b.col1 and a.col2=b.col2)


-- result
/*
 id | col1 | col2 | src 
----+------+------+-----
 b3 | 3    | 3    | B
 a1 | 1    | 1    | A
*/

```

