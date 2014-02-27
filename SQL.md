* Q1: 找出总分最高的学生

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
