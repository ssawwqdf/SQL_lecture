
--1. 부서번호가 10번인 사람의 사원번호,사원명,급여 출력
select empno, ename, sal
from emp
where deptno=10;
/*   expr 사이에 , 빼먹지 않도록 유의*/

--2. 사원번호가 7369인 사람의 사원명,입사일,부서번호 출력
select ename, hiredate, deptno
from emp
where empno=7369;
/*   ;빼먹지 않도록 유의*/

--3.입사일이 1983년 이상인 사원의 이름,급여 출력
select ename, sal
from emp
where hiredate >= '1983-01-01';
 /*   날짜에 ''표시 해줘야 함에 유의*/
 /*   FM대로면
 HIREDATE >= TO_DATE('1983-01-01','YYYY-MM-DD')*/


--4.직업이 MANAGER가 아닌 사원의 모든 정보 출력
select *
from emp
where job != 'MANAGER';
/*   manager 소문자로 표기하지 않도록 유의
     <>나 NOTIN도 쓸 수 있다.*/

--5.입사일이 81/04/02보다 늦고 82/12/29보다 빠른 사원의 모든 정보 출력
select *
from emp
where hiredate>'1981/04/02' and hiredate<'1982/12/29';
/*   and 사용 시 ()는 상과 없음. 날짜에 '' 표시 하기
     초과 미만이니까 등호 빼주기*/
/*   정석
where hiredate>to_date('1981/04/02','yyyy--mm-dd')and
      hiredate<to_date('1982/12/29', 'yyyy-mm-mm'); */

--6.사원번호가 7654와 7782 사이 이외의 사원의 모든 정보 출력
select *
from emp
where empno not between 7654 and 7782;
--where empno not in (7654,7782)이거 안 된다 하신듯 못 들음.
/*   '사이 이외!'. between 사용 시 column명은 앞으로 간다*/

--7.직업이 MANAGER와 SALESMAN인 사원의 모든 정보 출력 
select *
from emp
where job in ('MANAGER', 'SALESMAN');


--8.입사일이 81년도인 사원의 모든 정보 출력
select *
from emp
where hiredate between '1981-01-01' and '1981-12-31';
--where to_CHAR(hiredate, 'YYYY')='1981'도 되지만 좋지 않은 코딩(조건절에서 원본에 변형했기 때문)


--9.커미션을 받는 사원의 모든 정보 출력
select *
from emp
where comm is not null and
      comm>0;
/*  comm=0인 애들도 빼야됨*/
/*  where nvl(comm,0) >0도 가능. but 조건절에서 원본 변형한 거라 비추*/
 

--10. 연봉이 20000 이상인 사원의 모든 정보 출력 (연봉에는 comm을 포함시킬것)
select *
from emp
where comm*12+20000>=20000; --오답

select *
from emp
where sal*12+nvl(comm,0)>=20000;

/*  null은 없애는 처리 해줘야됨 주의!!!!.*/

--12. 이름에 'A'가 들어가는 사원들의 이름, 부서번호 출력
select ename, deptno
from emp
where INSTR(UPPER(ENAME),'A')>0;   --불필요하게 길다

/*  세상에는 'LIKE'라는 함수가 있다.*/
/*  select ename, deptno
from emp
where ename like '%A%'
;
*/

--13. 직업이 'SALESMAN'인 사원 이름, 부서번호 출력
select ename, deptno
from emp
where job='SALESMAN';


--14. 부서번호가 10번, 20번인 사원들의 사원이름, 급여, 부서번호 출력
--      출력된 결과물을 부서번호가 낮은 순으로, 급여가 높은 순으로 정렬
select ename, sal, deptno
from emp
where deptno in ('10', '20')
order by deptno, sal desc
;

----groupby------
--1. EMP 테이블에서 10번부서 급여의 평균,최고,최저,급여를받는인원수 출력(조건 평균 급여가 많은 순으로 출력)
select avg(sal), max(sal), min(sal), count(sal)
from emp
where deptno=10
order by avg(sal) desc
;

--2. EMP 테이블에서 각 부서별 급여의 평균,최고,최저 출력(조건:부서 오름차순 정렬)
select deptno, avg(sal), max(sal), min(sal)
from emp
group by deptno
order by deptno
;


--3. EMP 테이블에서 같은업무를 하는 사람의 수가 4명 이상인 업무와 인원수 출력
select job, count(job)
from emp
group by job
having count(job)>=4
;

--4. EMP 테이블에서 부서 인원이 4명보다 많은 부서의 부서번호, 인원수, 급여의 합을 출력하시오
select deptno, count(deptno), sum(sal)
from emp
group by deptno
having count(deptno)>4
;


--5. EMP 테이블에서/ 각 부서별 /같은 업무를 하는 사람의 인원수를 구하여 부서번호,업무명,인원수출력
--(조건 부서번호 오름차순, 업무 내림차순 정렬)

select deptno, job, count(job)
from emp
group by deptno, job
order by deptno, job desc
;

/* alias 해주면 보기 예쁘다*/

/* 문제 풀고 싶으면 oracle deptno empt 문제 검색 */