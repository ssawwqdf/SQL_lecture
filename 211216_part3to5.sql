--singlerow function--
--word

select upper('abc') from emp;
--> results come out with 14rows. it's because emp has 14 rows.

select upper('abc') from dual;
--> if you want output only one row, use 'dual' table. it's basic table having 1 rows.

select upper('abc'), lower('AAddedC'), Length('abc'),
    '-'||trim('    ac  c     ')||'-',
    lpad('abc', 7,'*'), rpad('abc', 7, '0'),
    substr('abcde',1, 2),
    substr('abcde',-1),
    substr('abced',-3,3)
from dual;
--there is no midtrim (so if blank is in some letters, it dosen't trim)

--we can also use function to column
select ename, upper(ename), lower(ename), Length(ename),
    '-'||trim(ename)||'-',
    lpad(ename, 7,'*'), rpad(ename, 7, '0'),
    substr(ename,1, 2),
    substr(ename,-1),
    substr(ename,-3,3)
from emp;

--output ename into followed form
/*
SMITH -->S**TH
WARD -->W**D
MARTIN --> M**TIN
*/

select substr(ename,1,1)||'**'||substr(ename,3)
from emp;

-->other student(kms)
select substr(ename, 1,1)||lpad('*',2,'*')||substr(ename, 3) ename
from emp;

--> other student(phj)
SELECT ENAME,SUBSTR(ENAME,1,1)||'*'||'*'||SUBSTR(ENAME, 4)
FROM EMP;

--> other student(khs)
select substr(ename,1,1) || '**'|| substr(ename,4)
from emp;

--> other student(csh) = fresh
select rpad(substr(ename,1,1),3,'*')||substr(ename,4)
from emp;

--> other student(snr) = fresh
select  replace (ename, SUBSTR (ename, 2,2), '**')
from emp;

--------------------------

select sal from emp;

--set one month=20days -> salary/day?
select sal, sal/20 from emp;

    --round?
select round(sal/20) from emp;

    --trunk?
select trunc(sal/20) from emp;

--work 8hous per day -> salary/hour?
select sal/20/8     from emp;
select round((sal/20/8),1) from emp;
select ceil(sal/20/8) from emp;

----- form change==casting
-- date type transform

select sysdate,
    to_char(sysdate,'yyyy-mm-dd hh24:mi:ss')
from dual;

select hiredate, hiredate+1 from emp;

select to_char(hiredate, 'mm-dd-yyyy') from emp;

select to_char(hiredate, 'mm-dd-yyyy')+1 from emp; --error(because it's low ver(not automatically identified substitude form)

--casting char -> date
select '2021-01-01' from dual;  --single quote means it's character type
select to_date('2021-01-01', 'yyyy-mm-dd')+1 from dual; -- if you use to_date function, you can use date calculation

-----
select sysdate, hiredate, trunc(sysdate-hiredate) as workday from emp;
select trunc((sysdate-hiredate)/365) as workday from emp;

-- find someone employed after 1982
select ename
from emp
where hiredate>'1982-1-1' ;

select ename
from emp
where hiredate>to_date('1982-1-1') ;  -- you would have to use to_date format on lower ver.

        --how about if date format is different?
select ename
from emp
where hiredate>'1982/1/1' ;  --ver. 11 automatically fit date format diffrence.

select to_date(sysdate, 'yyyy-mm-dd') from dual;  -- usually date can't be used in to_date. but this version make it be able to.

select to_char('2021-01-01', 'yyyy-mm-dd') from dual; --char can't be used in to_char


/* 1. if it's date type -> calculation and comparison of condition goes well
2. if it's date with char type -> using to_date function make your work easier
*/


select '1'+1 from dual ;  -- automatically char gets number

-- nesting of function
select ename ||'_kr'||'_123' from EMP;
select concat(ename,'_kr_123') from EMP;
select concat(ename, concat('_kr','_123') from emp; --error
select concat(concat(ename,'_kr'),'_123') from emp; --correct

--NVL

select nvl(comm, 0), comm+100, nvl(comm, 0)+100
from emp;

--conditional expression
select deptno,
    case deptno when 10 then 'ten'
                when 20 then 'twelve'
                when 30 then 'thirty'
                else 'else'
    end totext
from emp;

select deptno,
    case        when deptno=10 then 'ten'
                when deptno=20 then 'twelve'
                when deptno=30 then 'thirty'
                else 'else'
    end totext
from emp;

--if when sal between( 1000 and 2000)

select sal,
    case when sal<1000 then 'poor'
         when sal<2000 then 'normal'
         when sal<3000 then 'rich'
         else 'superrich'
    end totext
from emp;

select sal,
    case when (sal>0 and sal<1000) then 'poor'
         when (sal>1000 and sal<2000) then 'normal'
         when (sal>2000 and sal<3000) then 'rich'
         else 'superrich'
    end totext
from emp;

select sal,
    case when (sal between 0 and 1000) then 'poor'
         when (sal between 1000 and 2000) then 'normal'
         when (sal between 2000 and 3000) then 'rich'
         else 'superrich'
    end totext
from emp;

-- mgr exist ->yes, not exist ->no): as mgr_yn
select mgr,
    case mgr when (mgr is null) then 'no'
             else 'yes'
    end mgr_yn
from emp;               --error

select mgr,
    case nvl(mgr,0) when 0 then 'no'
                    else 'yes'
    end mgr_yn
from emp;               --intructor

----
--decode
select deptno,
    decode (deptno, 10, 'ten',
                   20, 'twelve',
                   30, 'thirty',
                   'guitar') as totext
from emp;

-------part 5.
--group

-- group function <5>
-- max(), min(), avg(), sum(), count()
    --use sal
select max(sal)
from emp;

select min(sal)
from emp;

select avg(sal)
from emp;

select sum(sal)
from emp;

select count(sal)
from emp;

select max(sal)
from emp
where deptno=10;


---- 
select trunc(avg(sal),0)
from emp
where deptno=10;        --2916

select trunc(avg(sal),0)
from emp
where deptno=20;        --2175

select trunc(avg(sal),0)
from emp
where deptno=30;        --1566

select deptno, trunc(avg(sal),0)
from emp
group by deptno
order by deptno;  --'order by' is always placed in last line.

------***** if you write "group by column1, column2", then you can only use column 1,2 on select.
------Error massage: ORA-00979: not a GROUP BY expression
------   but, group function is not related with group by

select ename, deptno, trunc(avg(sal),0)
from emp
group by deptno
order by deptno asc;     --error
             --> ename makes an error as group by dosen't have ename.

select deptno, job, trunc(avg(sal),0)
from emp
group by deptno, job
order by deptno asc;     

-- but it dosen't matter if a column is lncluded with group function, even though the column dosen't exist in GROUP BY.
select deptno, job, avg(sal)
from emp
group by deptno, job
order by deptno asc;     

-----ORA-00937: not a single-group group function
-----select sal and select min(ename) have different number of row.
----- sal(-> 14 rows), min(ename) (-> single row)

select sal, min (ENAME)
from emp;
-- min(ename) has only one value(Adam), but emp and sal have 14values. so error occurs

--if you want to operate abouve, add GROUP BY
select sal, min (ENAME)
from emp
group by sal;