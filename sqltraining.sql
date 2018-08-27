CREATE DATABASE IF NOT EXISTS NIIT DEFAULT CHARSET utf8 COLLATE utf8_general_ci;
create table  if not exists stu(
rollno int primary key auto_increment,
stu_name varchar(100) not null,
gender varchar(1) not null default 'M',
tel varchar(100) unique
)engine=innodb default charset=utf8;

create table if not exists course(
course_id int primary key,
course_name varchar(100)
);

create table if not exists mark(
mark_id int,
stu_id int,
course_id int,
score int,
foreign key(stu_id) references stu(rollno),
foreign key(course_id) references course(course_id)
);

insert into stu values(1,'feng','F','17805429002'),
(2,'yu','M','17805429004'),
(3,'xing','M','17805429005'),
(4,'chen','M','17805429006'),
(5,'xiao','M','17805429007');

insert into course values(1,'math'),
(2,'chinese'),
(3,'english');

insert into mark values(1,1,1,98),
(2,1,2,99),
(3,2,3,78),
(4,2,2,65),
(5,3,1,80),
(6,3,3,69);

create user 'niit'@'%' identified by 'niit';/*%表示匹配所有主机*/
grant all privileges on niit.* to 'niit'@'%';/*添加用户的权限*/

select a.rollno,a.stu_name,b.score
from stu a,mark b
where a.rollno=b.stu_id;

select a.rollno,a.stu_name,b.course_id,b.course_name,c.score
from stu a,course b,mark c
where a.rollno=c.stu_id and b.course_id=c.course_id;

select rollno,stu_name
from stu a,mark b
where a.rollno=b.stu_id and b.score in(select max(score) from mark);

select rollno,stu_name,gender,tel
from stu a,course b,mark c
where a.rollno=c.stu_id and b.course_id=c.course_id and c.score in(select max(score) from mark group by course_id);

DELIMITER $$
create procedure avg2(s1 int)returns varchar
BEGIN
declare c int;
set c=(select avg(score) from mark where course_id=s1);
if c>85 then return "优秀";
elseif 70<c<80 then return "良好";
elseif 60<c then return "一般";
elseif c<60 then return "不及格";
end if;
END;

create proc search
@coursename char(20)
exec('
select c.studentid,c.studentname,a.coursename,case when result>=80 then ''优秀‘'
when result >=60 then''及格'’ else ''不及格‘' end result ----自己按成绩划分，注意是两个单引号，在存储过程里 常量要用两个单引号
from sc a left join student b on a.studentid=b.studenid 
left join course c on a.courseid=c.courseid
where c.coursename='+@coursename+'
);


DELIMITER $$
create function avg1(s1 int)returns int
BEGIN
declare c int;
set c=(select avg(score) from mark where course_id=s1);
return c;
END;

select avg1(1);

DELIMITER $$
CREATE TRIGGER ins_film
BEFORE delete on stu
for each row

END;
$$
delimiter ;