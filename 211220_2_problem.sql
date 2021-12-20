/*-------------
problem 6~10 내 풀이 (많이 틀림. 확인)
조각조각 나눠서 하자.
--------------*/

--6. EMP 테이블에서 가장 많은 사원을 갖는 MGR번호 출력
--   ENO
--   --------
--   7698

SELECT EMP MGR, ENMAE
FROM EMP
GROUP BY MGR
HAVING COUNT(1) = MAX(SELECT MGR
                       FROM EMP
                       GROUP BY MGR)
;

--7. EMP 테이블에서 부서번호가 20인 부서의 이름,급여,시간당급여 출력 (조건:시간당급여 내림차순 정렬, 1다달 근무일수:12일, 1일 근무시간:8시간)
SELECT D.DNAME, E.ENAME, SAL, SAL/8/12
FROM EMP E, DEPT D
WHERE E.DEPTNO=D.DEPTNO
AND   E.DEPTNO=20
;


--8. EMP 테이블에서 입사일이 90일이 지난 후의 사원명,입사일,90일후급여,90일후급여일을 출력
SELECT ENAME, HIREDATE, 
FROM EMP
WHERE HIREDATE-
;

--9. EMP 테이블에서 부서번호가 10인 사원수와 부서번호가 30인 사원수를 각각 출력하시오.
--  CNT10  CNT30
--  ------   --------
--   3           6     

SELECT DEPTNO, COUNT(1)
FROM EMP
WHERE DEPTNO IN (10, 30)
GROUP BY DEPTNO
;

--10. EMP 테이블에서 각 부서 별 입사일이 가장 오래된 사원을 한 명씩 선별해 사원번호, 사원명, 부서번호, 입사일을 출력하시오.
SELECT EMPNO, ENAME, DEPTNO, HIREDATE
FROM EPM
WHERE SYSDATE-HIREDATE = (SELECT MAX(SYSDATE-HIREDATE)
                          FROM EMP
                          GROUP BY DEPTNO
                          )
;

--1. SMITH와 같은 부서에 근무중인 사원들의 사원번호(empno), 이름(ename), 급여액(sal), 부서이름(dname) 출력
SELECT E.EMPNO, E.ENAME, E.SAL, D.DNAME
FROM EMP E, DEPT D
WHERE E.DEPTNO=D.DEPTNO
AND   E.DEPTNO=(SELECT DEPTNO
                FROM EMP
                WHERE ENAME='SMITH'
                )
;

--2. CHICAGO 지역에 근무중인 사원중 BLAKE가 직속상관인 사원들의
--사원번호(empno), 이름(ename), 직무(job) 출력

SELECT EMPNO, ENAME, JOB
FROM EMP
WHERE MGR=(SELECT EMPNO
            FROM EMP
            WHERE ENAME='BLAKE')
;


--3. 3000 이상의 급여를 받는 사원들과 같은 부서에 근무하고 있는
--사원의 사원번호(empno), 이름(ename), 급여(sal) 츌룍
SELECT EMPNO, ENAME, SAL
FROM EMP
WHERE DEPTNO=(SELECT DEPTNO
             FROM EMP
             WHERE SAL>3000)
;

--문제1 :  부서명이 'SALES' 인 사원의 사번, 이름 출력
SELECT EMPNO, ENAME
FROM EMP
WHERE DEPTNO=(SELECT DEPTNO
             FROM DEPT
             WHERE DNAME='SALES')
;

---- 아래처럼 하면 아무 결과도 출력 안 됨. 왜일까????
--SELECT E.EMPNO, E.ENAME
--FROM EMP E JOIN DEPT D ON E.EMPNO=D.DEPTNO
--WHERE E.DEPTNO=(SELECT DEPTNO
--                FROM DEPT
--                WHERE DNAME='SALES')
--;

--문제2 : 사번이 '7844'인 사원의 job 과 동일한 job 인 사원의 사번, 이름, job 출력
SELECT EMPNO, ENAME, JOB
FROM EMP
WHERE JOB = (SELECT JOB
            FROM EMP
            WHERE EMPNO=7844)
;

--문제3 : 사번이 '7521' 인 사원의 job 과 동일하고
--'7900' 인 사번의 급여보다 많은 급여를 받는 사원의 사번, 이름, job, 급여 출력

SELECT EMPNO, ENAME, JOB, SAL
FROM EMP
WHERE JOB = (SELECT JOB
             FROM EMP
            WHERE EMPNO=7521)
AND SAL > (SELECT SAL
            FROM EMP
            WHERE EMPNO=7900)
;

--문제4 : 가장 적은 급여를 받는 사원의 사번, 이름, 급여를 출력
SELECT EMPNO, ENAME, SAL
FROM EMP
WHERE SAL IN (SELECT MIN(SAL)
            FROM EMP)
;

--문제 : 부서별 최소 급여 중에서 30번 부서의 최소급여보다는 많이 받는 부서의 부서번호, 최소 급여를 출력

SELECT DEPTNO, MIN(SAL)
FROM EMP
GROUP BY DEPTNO
HAVING MIN(SAL) > (SELECT MIN(SAL)
                    FROM EMP
                    WHERE DEPTNO=30
                    )
;

--문제6 : job이 CLERK 인 사원이 2명 이상 있는 부서의 부서번호, 부서명 출력

SELECT DEPTNO, DNAME
FROM DEPT
WHERE DEPTNO = (SELECT DEPTNO
        FROM EMP
        WHERE JOB='CLERK'
        GROUP BY DEPTNO
        HAVING COUNT(1)>=2)
;

--문제7 : job 이 'CLERK' 인 사원이 한명이라도 있는 부서의 부서명 출력

SELECT DEPTNO, DNAME
FROM DEPT
WHERE DEPTNO IN (SELECT DEPTNO
                FROM EMP
                WHERE JOB='CLERK'
                GROUP BY DEPTNO
                HAVING COUNT(1)>=1)
;


--문제8 : 각 부서별로 최소 급여를 받는 사원의 부서번호, 부서명, 사번, 이름, 급여 출력

--틀린 답
--SELECT D.DEPTNO, D.DNAME, E.EMPNO, E.ENAME, E.SAL
--FROM EMP E, DEPT D
--WHERE E.DEPTNO=D.DEPTNO
--AND    ENAME IN (SELECT ENAME
--                FROM EMP
--                GROUP BY DEPTNO
--                HAVING SAL = MIN(SAL))
--;

SELECT D.DEPTNO, D.DNAME, E.EMPNO, E.ENAME, E.SAL
FROM EMP E, DEPT D
WHERE E.DEPTNO=D.DEPTNO
GROUP BY D.DEPTNO, D.DNAME, E.EMPNO, E.ENAME, E.SAL
HAVING SAL IN (SELECT MIN(SAL)
              FROM EMP
              GROUP BY DEPTNO)          
;


--문제9 : 평균 급여보다 많거나 같고 최대 급여보다는 적은 급여를 받는 사원의 사번, 이름, 급여 출력
SELECT EMPNO, ENAME, SAL
FROM EMP
WHERE SAL >= (SELECT AVG(SAL)
              FROM EMP)   
AND   SAL < (SELECT MAX(SAL)
              FROM EMP)
;



--[rownum] 문제10 : 월급이 높은 순으로 사번, 이름, 월급을 상위 5명만 출력

SELECT EMPNO, ENAME, SAL
FROM 
(SELECT EMPNO, ENAME, SAL
FROM EMP
ORDER BY SAL DESC
)
WHERE ROWNUM<=5
;

--[rownum] 문제10-2 : 월급이 높은 순으로 사번, 이름, 월급을 상위 3~5명만 출력            
SELECT RATING, EMPNO, ENAME, SAL
FROM(
        SELECT ROWNUM AS RATING, SAL_ROW, EMPNO, ENAME, SAL
        FROM(SELECT ROWNUM AS SAL_ROW, EMPNO, ENAME, SAL
             FROM EMP
             ORDER BY SAL DESC))
WHERE RATING BETWEEN 3 AND 5
;

             
/*-------------
problem 6~10 해답(설명 포함)
--------------*/

--6. EMP 테이블에서 가장 많은 사원을 갖는 MGR번호 출력
--   ENO
--   --------
--   7698

SELECT MGR AS ENO
FROM EMP
GROUP BY MGR
HAVING COUNT(1) = (SELECT MAX (COUNT(1)) FROM EMP GROUP BY MGR)
;



--7. EMP 테이블에서 부서번호가 20인 부서의 이름,급여,시간당급여 출력 (조건:시간당급여 내림차순 정렬, 1다달 근무일수:12일, 1일 근무시간:8시간)
SELECT D.DNAME, E.ENAME, SAL, SAL/8/12 AS HSAL
FROM EMP E, DEPT D
WHERE E.DEPTNO=D.DEPTNO
AND   E.DEPTNO=20
ORDER BY HSAL DESC
;




--8. EMP 테이블에서 입사일이 90일이 지난 후의 사원명,입사일,90일후급여,90일후급여일을 출력
SELECT ENAME, HIREDATE, SAL, HIREDATE+90, SAL*90
FROM EMP
;

--9. EMP 테이블에서 부서번호가 10인 사원수와 부서번호가 30인 사원수를 각각 출력하시오.
--  CNT10  CNT30
--  ------   --------
--   3           6     
--위와 같이 출력해라
-- 현업에서 많이 쓰는 형태!!!

SELECT (SELECT COUNT(1) FROM EMP WHERE DEPTNO=10) AS CNT10,
       (SELECT COUNT (1) FROM EMP WHERE DEPTNO=30) AS CNT30
FROM DUAL       
;

--10. EMP 테이블에서 각 부서 별 입사일이 가장 오래된 사원을 한 명씩 선별해 사원번호, 사원명, 부서번호, 입사일을 출력하시오.
SELECT DEPTNO, MIN(HIREDATE) EMPNO, ENAME
FROM EMP
GROUP BY DEPTNO, EMPNO, ENAME
HAVING MIN(HIREDATE) IN  (SELECT MIN(HIREDATE)
                      FROM EMP
                      GROUP BY DEPTNO
                       )
;

--GROUP BY EMPNO, ENAME 안 해주면 SELECT에 GROUP BY보다 많은 변수 들어가게 된다.

--1. SMITH와 같은 부서에 근무중인 사원들의 사원번호(empno), 이름(ename), 급여액(sal), 부서이름(dname) 출력
--1. ㅇㅇㅇㅇㅇㅇㅇ부서에 근무중인 사원들의 사원번호(empno), 이름(ename), 급여액(sal), 부서이름(dname) 출력
SELECT E.EMPNO, E.ENAME, E.SAL, D.DNAME
FROM EMP E, DEPT D
WHERE E.DEPTNO=D.DEPTNO
AND   E.DEPTNO=(SELECT DEPTNO
                FROM EMP
                WHERE ENAME='SMITH'
                )
;

--2. CHICAGO 지역에 근무중인 사원중 BLAKE가 직속상관인 사원들의
--사원번호(empno), 이름(ename), 직무(job) 출력
--시카고에서 근무중인 사원 중!!
--직속상관 이름까지 하라 해도 재밌을듯

SELECT EMPNO, ENAME, JOB, MGR
FROM EMP
WHERE MGR=(SELECT EMPNO
            FROM EMP
            WHERE ENAME='BLAKE')
AND DEPTNO=(SELECT DEPTNO
             FROM DEPT
             WHERE LOC='CHICAGO')
;

--3. 3000 이상의 급여를 받는 사원들과 같은 부서에 근무하고 있는
--사원의 사원번호(empno), 이름(ename), 급여(sal) 츌룍
--등호 빼먹지 말기
SELECT EMPNO, ENAME, SAL
FROM EMP
WHERE DEPTNO IN (SELECT DEPTNO
            FROM EMP
            WHERE SAL>=3000)
;

--문제1 :  부서명이 'SALES' 인 사원의 사번, 이름 출력
--풀이 완전 다름 확인
SELECT E.EMPNO, E.ENAME
FROM DEPT D, EMP E
WHERE D.DNAME = 'SALES' AND D.DEPTNO = E.DEPTNO;

--문제2 : 사번이 '7844'인 사원의 job 과 동일한 job 인 사원의 사번, 이름, job 출력
SELECT EMPNO, ENAME, JOB
FROM EMP
WHERE JOB = (SELECT JOB
            FROM EMP
            WHERE EMPNO=7844)
;

--문제3 : 사번이 '7521' 인 사원의 job 과 동일하고
--'7900' 인 사번의 급여보다 많은 급여를 받는 사원의 사번, 이름, job, 급여 출력

SELECT EMPNO, ENAME, JOB, SAL
FROM EMP
WHERE JOB = (SELECT JOB
             FROM EMP
            WHERE EMPNO=7521)
AND SAL > (SELECT SAL
            FROM EMP
            WHERE EMPNO=7900)
;

--문제4 : 가장 적은 급여를 받는 사원의 사번, 이름, 급여를 출력
SELECT EMPNO, ENAME, SAL
FROM EMP
WHERE SAL IN (SELECT MIN(SAL)
            FROM EMP)
;

--문제 5: 부서별 최소 급여 중에서 30번 부서의 최소급여보다는 많이 받는 부서의 부서번호, 최소 급여를 출력

SELECT DEPTNO, MIN(SAL)
FROM EMP
GROUP BY DEPTNO
HAVING MIN(SAL) > (SELECT MIN(SAL)
                    FROM EMP
                    WHERE DEPTNO=30
                    )
;

--문제6 : job이 CLERK 인 사원이 2명 이상 있는 부서의 부서번호, 부서명 출력
--많이 다름 확인

SELECT D.DEPTNO, D.DNAME
FROM EMP E, DEPT D
WHERE JOB = 'CLERK' AND E.DEPTNO=D.DEPTNO
GROUP BY D.DEPTNO, D.DNAME, E.JOB
HAVING COUNT(1) >= 2
ORDER BY D.DEPTNO;

--문제7 : job 이 'CLERK' 인 사원이 한명이라도 있는 부서의 부서명 출력

SELECT DEPTNO, JOB, COUNT(1)
FROM EMP
WHERE JOB='CLERK'
GROUP BY DEPTNO, JOB
HAVING COUNT(1) >= 1
ORDER BY DEPTNO;


--문제8 : 각 부서별로 최소 급여를 받는 사원의 부서번호, 부서명, 사번, 이름, 급여 출력
-- HAVING에 멀티 조건 달아줄 수 있다!!!!!*********************

SELECT D.DEPTNO, D.DNAME, E.EMPNO, E.ENAME, E.SAL
FROM EMP E, DEPT D
WHERE E.DEPTNO = D.DEPTNO
GROUP BY D.DEPTNO, D.DNAME, E.EMPNO, E.ENAME, E.SAL
HAVING (D.DEPTNO, E.SAL) IN (SELECT DEPTNO, MIN (SAL)
                           FROM EMP
                          GROUP BY DEPTNO)
;


--문제9 : 평균 급여보다 많거나 같고 최대 급여보다는 적은 급여를 받는 사원의 사번, 이름, 급여 출력
SELECT EMPNO, ENAME, SAL
FROM EMP
WHERE SAL >= (SELECT AVG(SAL)
              FROM EMP)   
AND   SAL < (SELECT MAX(SAL)
              FROM EMP)
;


--> 10번 풀기 전에 ROWNUM부터 배워보자
--rownum
--오라클의 예약된 명칭
select rownum, rowid
from emp
;
--상위 ~번째 하고 싶으면 order by를 원래 넣는 순서에 넣으면 rownum을 끌고 다닌다.
--SUBQUERY로 나오는 표를 FROM절에도 넣을 수 있다.

SELECT ROWNUM, INS_ROWNUM, EMPNO, ENAME SAL
FROM (SELECT ROWNUM INS_ROWNUM, EMPNO, ENAME FROM EMP
        ORDER BY SAL DESC)
WHERE ROWNUM BETWEEN 1 AND 8;
        
--ROWNUM은 중간에서 끊어오지는 못한다.
--중간만 뽑아오고 싶으면 출력한 테이블을 FROM으로 다시 넣어서 하면 된다.(3중 쿼리)
--**1페이지 누르면 1부터 10까지, 2페이지 누르면 11부터 20번까지 불러오는 거 하려면 알아야됨.

SELECT ROWNUM, E.*
FROM (
        SELECT ROWNUM AS SEL_ROWNUM, INS_ROWNUM, EMPNO, ENAME
        FROM (SELECT ROWNUM AS INS_ROWNUM, EMPNO, ENAME
                FROM EMP
                ORDER BY ENAME ASC)
        ) E
WHERE SEL_ROWNUM BETWEEN 4 AND 8
;


--[rownum] 문제10 : 월급이 높은 순으로 사번, 이름, 월급을 상위 5명만 출력
SELECT ROWNUM, E.*
FROM (SELECT EMPNO, ENAME, SAL
        FROM EMP
        ORDER BY SAL DESC
        ) E
WHERE ROWNUM<= 5
        ;
--[rownum] 문제10-2 : 월급이 높은 순으로 사번, 이름, 월급을 상위 3~5명만 출력
--서브쿼리로 들어가는 테이블에 EMPNO, ENAME, SAL 있으면 맨 바깥 쿼리에 *해도 그것만 불러온다
--사실 마리아DB로 하면 더 간단하긴 함 LIMIT하면 돼서


SELECT *
FROM ( SELECT ROWNUM AS RR, E.*
        FROM (SELECT EMPNO, ENAME, SAL
             FROM EMP
            ORDER BY SAL DESC
        ) E
 )EE
 WHERE RR BETWEEN 3 AND 5
        ;
