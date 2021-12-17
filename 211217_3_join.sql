--------- 여러 테이블 JOIN

select *
from emp, dept
  -- 14  * 4   =56
;
-- EMP 테이블이 스미스~밀러까지 반복되면서 Deptno, dname, loc가 반복되는 형태

SELECT *
FROM EMP, DEPT
WHERE EMP.DEPTNO = DEPT.DEPTNO
ORDER BY EMP.DEPTNO ASC, DEPT.DEPTNO ASC
;

--40번 부서는 연결된 사람이 없어 안 나옴..

-- OUTER JOIN: 40번 부서에 아무도 없지만 보여줌.
SELECT *
FROM EMP, DEPT
WHERE EMP.DEPTNO = DEPT.DEPTNO
ORDER BY EMP.DEPTNO(+) ASC, DEPT.DEPTNO ASC
;

-- ERROR: 00918. 00000 -  "column ambiguously defined"
select ename, deptno, dname
from emp, dept
where dept.deptno=emp.deptno
;
-->양쪽 테이블에 겹치는 이름의 칼럼을 사용할 경우 반드시!!! 테이블.칼럼 명확히 기재
select ename, dept.deptno, dname
from emp, dept
where dept.deptno=emp.deptno
;
------------------------
/* 위는 오라클 문법이고 가능하면 ANSI 문법 써라*/
------------------------

SELECT DNAME, DEPT.DEPTNO, ENAME
FROM DEPT
JOIN EMP
ON DEPT.DEPTNO = EMP.DEPTNO
;


--          ANSI
SELECT DNAME, DEPT.DEPTNO, ENAME
FROM DEPT JOIN EMP ON DEPT.DEPTNO = EMP.DEPTNO
WHERE DEPT.DEPTNO=10
;

--          오라클 문법이면(거의 대부분 데이터베이스에 통용)
select ename, dept.deptno, dname
from emp, dept
where dept.deptno=emp.deptno AND DEPT.DEPTNO=10
;

---selfjoin
----- 사원 기준 10번 부서 사람들의 사원번호 사원명 매니저번호, 매니저명 출력
--내가 쓴 ANSI
SELECT E1.EMPNO, E1.ENAME, E1.MGR, E2.ENAME MNAME
FROM EMP E1 JOIN EMP E2 
    ON E1.MGR=E2.EMPNO
WHERE E1.DEPTNO=10
;
--강사님이 쓴 JOIN
SELECT E1.EMPNO, E1.ENAME, E1.MGR, E2.ENAME
FROM EMP E1, EMP E2
WHERE E1.MGR=E2.EMPNO
    AND E1.DEPTNO=10;

/* SELFJOIN 할 때도 어떤 테이블에서 가져왔는지 명확하게*/


-----------outer join
-- emp table에 40번 부서에 속한 사람이 없어서 안 나온다.
SELECT *
FROM EMP E, DEPT D
WHERE E.DEPTNO(+) = D.DEPTNO;
  --10 20 30    10 20 30 40
  --없는 쪽에 (+). 좌항 우항 다 가능한데 단 언제나 컬럼 이름 뒤에 써야 된다.
  --40번 부서 없으면 EMP에 NULL을 더해서라도 DEPT에 있는 거 보여줘라
  
-- ANSI 문법의 경우 기준을 어디로 잡는가를 체크
-- DISTINT 했을 때 누가 CASE BY(경우)를 많이 갖고 있는가에 따라 LEFT RIGHT
SELECT *
FROM EMP E RIGHT OUTER JOIN DEPT D ON E.DEPTNO=D.DEPTNO
;

SELECT *
FROM DEPT E LEFT OUTER JOIN EMP D ON E.DEPTNO=D.DEPTNO
;

--        DISDINT 했을 때의 의미
SELECT DISTINCT DEPTNO FROM EMP;  --세 개

SELECT DISTINCT DEPTNO FROM DEPT;  --네 개