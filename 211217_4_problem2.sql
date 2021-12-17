--11. DALLAS에서 근무하는 사원의 이름, 직업, 부서번호, 부서이름 출력
SELECT E.ENAME, E.JOB, E.DEPTNO, D.DNAME
FROM EMP E, DEPT D
WHERE E.DEPTNO=D.DEPTNO
    AND D.LOC='DALLAS'
;

--12. 이름에 'A'가 들어가는 사원들의 이름과 부서이름을 출력
SELECT E.ENAME, D.DNAME
FROM EMP E, DEPT D
WHERE E.DEPTNO=D.DEPTNO
    AND E.ENAME LIKE '%A%'
;


--13. 직업이 'SALESMAN'인 사원들의 직업과 그 사원이름, 부서 이름 출력
SELECT E.JOB, E.ENAME, D.DNAME
FROM EMP E, DEPT D
WHERE E.DEPTNO=D.DEPTNO
    AND E.JOB='SALESMAN'
;


--14. 부서번호가 10번, 20번인 사원들의 부서번호, 부서이름, 사원이름, 급여 출력
--      출력된 결과물을 부서번호가 낮은 순으로, 급여가 높은 순으로 정렬
SELECT E.DEPTNO, D.DNAME, E.ENAME, SAL
FROM EMP E, DEPT D
WHERE E.DEPTNO = D.DEPTNO
    AND (E.DEPTNO = 10 OR E.DEPTNO = 20)
ORDER BY E.DEPTNO, SAL DESC
    ;
