--부서 테이블에 있는 부서번호를 갖는 모든 사원 출력

--1) 조인
SELECT E.ENAME, E.DEPTNO
FROM EMP E, DEPT D
WHERE E.DEPTNO = D.DEPTNO;

--2) 서브쿼리 이용
SELECT ENAME, DEPTNO
FROM EMP
WHERE DEPTNO IN (SELECT DEPTNO
                 FROM DEPT
                )
;

--3) EXISTS (WHERE 조건 필요하다!!!! 주의!!!!!!!!!!!!! EXISTS는 SELECT에 뭐라도 나오면 그냥 TRUE)
SELECT ENAME, DEPTNO
FROM EMP E
WHERE  EXISTS (SELECT DEPTNO
                FROM DEPT
                WHERE E.DEPTNO = DEPTNO
                    )
;