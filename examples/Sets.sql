-- --------
-- Sets.sql
-- --------

use test;

-- ------------------------------------------------------------------------
drop table if exists Student;
drop table if exists Apply;
drop table if exists College;

-- ------------------------------------------------------------------------
create table Student (
    sID    int,
    sName  text,
    GPA    float,
    sizeHS int);

create table Apply (
    sID      int,
    cName    text,
    major    text,
    decision boolean);

create table College (
    cName      text,
    state      char(2),
    enrollment int);

-- ------------------------------------------------------------------------
insert into Student values (123, 'Amy',    3.9,  1000);
insert into Student values (234, 'Bob',    3.6,  1500);
insert into Student values (320, 'Lori',   null, 2500);
insert into Student values (345, 'Craig',  3.5,   500);
insert into Student values (432, 'Kevin',  null, 1500);
insert into Student values (456, 'Doris',  3.9,  1000);
insert into Student values (543, 'Craig',  3.4,  2000);
insert into Student values (567, 'Edward', 2.9,  2000);
insert into Student values (654, 'Amy',    3.9,  1000);
insert into Student values (678, 'Fay',    3.8,   200);
insert into Student values (765, 'Jay',    2.9,  1500);
insert into Student values (789, 'Gary',   3.4,   800);
insert into Student values (876, 'Irene',  3.9,   400);
insert into Student values (987, 'Helen',  3.7,   800);

insert into Apply values (123, 'Berkeley', 'CS',             true);
insert into Apply values (123, 'Cornell',  'EE',             true);
insert into Apply values (123, 'Stanford', 'CS',             true);
insert into Apply values (123, 'Stanford', 'EE',             false);
insert into Apply values (234, 'Berkeley', 'biology',        false);
insert into Apply values (321, 'MIT',      'history',        false);
insert into Apply values (321, 'MIT',      'psychology',     true);
insert into Apply values (345, 'Cornell',  'bioengineering', false);
insert into Apply values (345, 'Cornell',  'CS',             true);
insert into Apply values (345, 'Cornell',  'EE',             false);
insert into Apply values (345, 'MIT',      'bioengineering', true);
insert into Apply values (543, 'MIT',       'CS',            false);
insert into Apply values (678, 'Stanford', 'history',        true);
insert into Apply values (765, 'Cornell',  'history',        false);
insert into Apply values (765, 'Cornell',  'psychology',     true);
insert into Apply values (765, 'Stanford', 'history',        true);
insert into Apply values (876, 'MIT',      'biology',        true);
insert into Apply values (876, 'MIT',      'marine biology', false);
insert into Apply values (876, 'Stanford', 'CS',             false);
insert into Apply values (987, 'Berkeley', 'CS',             true);
insert into Apply values (987, 'Stanford', 'CS',             true);

insert into College values ('Berkeley', 'CA', 36000);
insert into College values ('Cornell',  'NY', 21000);
insert into College values ('Irene',    'TX', 25000);
insert into College values ('MIT',      'MA', 10000);
insert into College values ('Stanford', 'CA', 15000);

-- ------------------------------------------------------------------------
select * from Student;
select * from Apply;
select * from College;

-- ------------------------------------------------------------------------
-- set union: names of students OR colleges

-- this is not good, the attribute name is misleading
select "*** #1a ***";
select sName from Student
union
select cName from College
order by sName;

-- this is better
select "*** #1b ***";
select sName as csName from Student
union
select cName from College
order by csName;

-- ------------------------------------------------------------------------
-- set intersection: names of students AND colleges
-- MySQL does not support intersect
-- Every derived table must have its own alias

-- inner join, with on
select "*** #2a ***";
select *
    from
        (select sName from Student) as R
        inner join
        (select cName from College) as S
        on (R.sName = S.cName);

-- inner join, with using
select "*** #2b ***";
select *
    from
        (select sName as csName from Student) as R
        inner join
        (select cName as csName from College) as S
        using (csName);

-- subquery, with in
select "*** #2c ***";
select sName as csName
    from Student
    where sName in
        (select cName
            from College);

-- subquery, with exists
select "*** #2d ***";
select sName as csName
    from Student
    where exists
        (select *
            from College
            where sName = cName);

-- ------------------------------------------------------------------------
-- set difference: ID of students who did not apply anywhere
-- MySQL does not support except (minus)

-- subquery, with not in
select "*** #3a ***";
select sID
    from Student
    where sID not in
        (select sID
            from Apply);

-- subquery, with not exists
select "*** #3b ***";
select sID
    from Student
    where not exists
        (select *
            from Apply
            where Student.sID = Apply.sID);

-- ------------------------------------------------------------------------
drop table if exists Student;
drop table if exists Apply;
drop table if exists College;

exit
