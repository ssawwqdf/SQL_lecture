-- Return average sal by each deptno,
-- but only if average sal is 2000 or/and above
select deptno, avg(sal)
from emp
group by deptno
having avg(sal) >= 2000;
