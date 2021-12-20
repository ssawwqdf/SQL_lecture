--PART 7. 서브쿼리
/*-------------
단일행 서브쿼리
--------------*/

SELECT * FROM EMP
;

--BLAKE의 급여는?
SELECT ENAME, SAL
FROM EMP
WHERE ENAME='BLAKE'
;

--급여가 2850보다 많이 받는 사람
SELECT ENAME, SAL
FROM EMP
WHERE SAL>2850
;

--급여가 BLAKE의 급여보다 많이 받는 사람은?
--급여가 _____??____보다 많이 받는 사람은?
SELECT ENAME, SAL
FROM EMP
WHERE SAL>
          (SELECT SAL
           FROM EMP
           WHERE ENAME='BLAKE'
            )
;

--BLAKE와 같은 직업을 갖고, BLAKE의 급여보다 많이 받는 사람
--직업____111_____을 갖고, 급여가 __22__보다 많이 받는 사람

SELECT ENAME, JOB, SAL
FROM EMP
WHERE SAL>
         (SELECT SAL
          FROM  EMP
          WHERE ENAME='BLAKE')
AND   JOB=
          (SELECT JOB
           FROM EMP
           WHERE ENAME='BLAKE')
;

--최소급여를 받는 사원의 이름, 사원번호, 급여
--급여가 ___받는 사원의 이름, 사원번호, 급여
SELECT ENAME, EMPNO, SAL
FROM EMP
WHERE SAL =
            (SELECT MIN(SAL)
             FROM EMP)
;

--30번 부서 사람들의 최소급여보다 최소급여가 많은 부서
SELECT DEPTNO, MIN(SAL)
FROM EMP
GROUP BY DEPTNO
HAVING MIN(SAL)>(SELECT MIN(SAL)
                 FROM EMP
                 WHERE DEPTNO=30
                  )
;


/*-------------
다중행 서브쿼리
--------------*/

--각 부서별 최소급여는?
SELECT MIN(SAL)
FROM EMP
GROUP BY DEPTNO
;

--급여가 800,1250,3000보다 많이 받는 사람은?
SELECT ENAME, SAL
FROM EMP
WHERE SAL > (800, 1250, 3000) --에러!(괄호 안에 조건이 한 번에 여러 개가 되기 때문)
;

-->같은 원리로
--각 부서의 최소급여보다 급여를 더 많이 받는 사람은?
SELECT ENAME, SAL
FROM EMP
WHERE SAL > (SELECT MIN(SAL)
            FROM EMP
            GROUP BY DEPTNO) --01427. 00000 -  "single-row subquery returns more than one row"
                             -- 단일행 쿼리에 둘 이상의 조건이 나오는 경우 에러 메세지
;
--으로 쓰면 에러가 난다.

--연산자 "뒤"에 다음과 같은 문법 추가
    --ANY : A, B, C 중 하나만 만족하면 된다.
    --ALL : A, B, C 모두 만족해야 한다.
SELECT ENAME, SAL
FROM EMP
WHERE SAL > ALL (SELECT MIN(SAL)
                 FROM EMP
                 GROUP BY DEPTNO)
;
    -- 등호로 ~ 중에 하나라고 할 때는 IN을 쓸 수도 있다.
    --IN: ~ 중에 하나(등호)

--10번 부서 사람들의 직업
SELECT JOB FROM EMP WHERE DEPTNO=10;

--직업이 MANAGER, PRESIDENT, CLERK인 사람
SELECT ENAME, JOB
FROM EMP
WHERE JOB IN ('MANAGER', 'PRESIDENT', 'CLERK')
;

--10번 부서 사람들의 직업과 같은 사람
SELECT ENAME, JOB
FROM EMP
WHERE JOB IN (SELECT JOB FROM EMP WHERE DEPTNO=10)
;

