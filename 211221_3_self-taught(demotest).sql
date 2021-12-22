--1. EMP테이블에서 부서 인원이 4명보다 많은 부서의 부서번호,인원수,급여의 합을 출력하시오.
--DEPTNO COUNT(*) SUM(SAL)
------------ ---------- ----------
--30 6 9400
--

SELECT DEPTNO, COUNT(1), SUM(SAL)
FROM EMP
GROUP BY DEPTNO
HAVING COUNT(1) >=4
;

--2. EMP테이블에서 가장 많은 사원이 속해있는 부서번호와 사원수를 출력하시오.
--DEPTNO COUNT(*)
------------ ----------
--30 6
--이렇게 복잡하게만 되나???

SELECT DEPTNO, COUNT(1)
FROM EMP
GROUP BY DEPTNO
HAVING COUNT(1) = (SELECT MAX(c)
                    FROM (SELECT DEPTNO, COUNT(1) c
                            FROM EMP
                            GROUP BY DEPTNO))
;



--3. EMP테이블에서 가장 많은 사원을 갖는 MGR의 사원번호를 출력하시오.
--EMPNO
------------
--7698
--
SELECT MGR EMPNO_MOST
FROM EMP
GROUP BY MGR
HAVING COUNT(1) = (SELECT max(C)
                   FROM (SELECT MGR, count(1) C
                        FROM EMP
                        GROUP BY MGR)
                   )
;

--4. EMP테이블에서 부서번호가 10인 사원수와 부서번호가 30인 사원수를 각각 출력하시오.
--CNT10 CNT20
------------ ----------
--3 6
--
SELECT (SELECT COUNT(1)
        FROM EMP
        WHERE DEPTNO=10) CNT10,
        (SELECT COUNT(1)
        FROM EMP
        WHERE DEPTNO=30) CNT20
FROM DUAL
;


--5. EMP테이블에서 사원번호(EMPNO)가 7521인 사원의 직업(JOB)과 같고
--사원번호(EMPNO)가 7934인 사원의 급여(SAL)보다 많은 사원의
--사원번호,이름,직업,급여를 출력하시오.
--EMPNO ENAME JOB SAL
------------ ---------- --------- ----------
--7499 ALLEN SALESMAN 1600
--7844 TURNER SALESMAN 1500
--

SELECT EMPNO, ENAME, JOB, SAL
FROM EMP
WHERE JOB=(SELECT JOB
            FROM EMP
            WHERE EMPNO=7521)
AND SAL > (SELECT SAL
            FROM EMP
            WHERE EMPNO=7934)
;
            


--6.직업(JOB)별로 최소 급여를 받는 사원의 정보를 사원번호,이름,업무,부서명을 출력하시오.
---조건1 :직업별로 내림차순 정렬
--EMPNO ENAME JOB DNAME
------------ ---------- --------- --------------
--7521 WARD SALESMAN SALES
--7654 MARTIN SALESMAN SALES
--7839 KING PRESIDENT ACCOUNTING
--7782 CLARK MANAGER ACCOUNTING
--7369 SMITH CLERK RESEARCH
--7788 SCOTT ANALYST RESEARCH
--7902 FORD ANALYST RESEARCH
--

SELECT E.EMPNO, E.ENAME, E.JOB, D.DNAME
FROM EMP E, DEPT D
WHERE E.DEPTNO=D.DEPTNO
AND (E.JOB, E.SAL) IN (SELECT JOB, MIN(SAL)
                            FROM EMP
                            GROUP BY JOB)
ORDER BY JOB DESC
;
            

--7.각 사원 별 시급을 계산하여 부서번호,사원이름,시급을 출력하시오.
---조건 1.한달 근무일수는 20일,하루 근무시간은 8시간이다.
---조건 2.시급은 소수 두 번째 자리에서 반올림한다.
---조건 3.부서별로 오름차순 정렬
---조건 4.시급이 많은 순으로 출력
--DEPTNO ENAME 시급
------------ ---------- ----------
--10 KING 31.3
--10 CLARK 15.3
--20 FORD 18.8
--20 JONES 18.6
--~~~중략 ~~~
--30 JAMES 5.9
--

SELECT DEPTNO, ENAME, ROUND(SAL/20/8, 1) HW
FROM EMP
ORDER BY DEPTNO, HW DESC
;


--8.각 사원 별 커미션(COMM)이 0또는 NULL이고 부서위치가 ‘GO’로 끝나는 사원의 정보를 사원번호,사원이름,커미션,
--부서번호,부서명,부서위치를 출력하여라.
---조건 1.보너스가 NULL이면 0으로 출력
--EMPNO ENAME COMM DEPTNO DNAME LOC
------------ ---------- ---------- ---------- -------------- -------------
--7698 BLAKE 0 30 SALES CHICAGO
--7844 TURNER 0 30 SALES CHICAGO
--7900 JAMES 0 30 SALES CHICAGO
--

SELECT E.EMPNO, E.ENAME, NVL(E.COMM, 0) COMMI, D.DEPTNO, D.DNAME, D.LOC
FROM EMP E, DEPT D
WHERE (COMM=0
OR COMM IS NULL)
AND D.LOC LIKE('%GO')
;


--9.각 부서 별 평균 급여가 2000이상이면 초과,그렇지 않으면 미만을 출력하시오.
--DEPTNO평균급여
------------ ----
--30초과
--20미만
--10미만
--

SELECT DEPTNO,
(CASE WHEN SAL>=2000 THEN '초과'
      ELSE '미만'
      END)
FROM (SELECT DEPTNO, AVG(SAL) SAL
      FROM EMP
      GROUP BY DEPTNO)
;


--10.각 부서 별 입사일이 가장 오래된 사원을 한 명씩 선별해 사원번호,사원명,부서번호,입사일을 출력하시오.
--EMPNO ENAME DEPTNO HIREDATE
------------ ---------- ---------- ------------------------------
--7782 CLARK 10 1981-06-09
--7369 SMITH 20 1980-12-17
--7499 ALLEN 30 1981-02-20
--
SELECT EMPNO, ENAME, DEPTNO, HIREDATE
FROM EMP
WHERE (DEPTNO,HIREDATE) IN (SELECT DEPTNO, MIN(HIREDATE)
                            FROM EMP
                            GROUP BY DEPTNO)
ORDER BY DEPTNO
;

--11. 1980년~1980년 사이에 입사된 각 부서별 사원수를 부서번호,부서명,입사 1980,입사 1981,입사 1982로
--출력하시오.
--DEPTNO DNAME 입사1980 입사1981 입사1982
------------ -------------- ---------- ---------- ----------
--
--10 ACCOUNTING 0 2 1
--20 RESEARCH 1 2 0
--30 SALES 0 6 0
--

--SELECT D.DEPTNO, D.DNAME
--FROM DEPT D
--LEFT OUTER JOIN
--    (SELECT DEPTNO, COUNT(DEPTNO)
--    FROM (SELECT *
--            FROM EMP
--            WHERE HIREDATE BETWEEN '1980-01-01' AND '1980-12-31')
--            GROUP BY DEPTNO) HIRE1980
--ON D.DEPTNO=HIRE1980.DEPTNO
        
        
SELECT DEPTNO, COUNT(DEPTNO)
FROM (SELECT *
        FROM EMP
        WHERE HIREDATE BETWEEN '1981-01-01' AND '1981-12-31')
        GROUP BY DEPTNO) HIRE1981,       
SELECT DEPTNO, COUNT(DEPTNO)
FROM (SELECT *
        FROM EMP
        WHERE HIREDATE BETWEEN '1982-01-01' AND '1982-12-31')
        GROUP BY DEPTNO) HIRE1982,       
       
       
         (SELECT DEPTNO COUNT(1)
                FROM EMP
                WHERE HIREDATE BETWEEN '1981-01-01' AND '1981-12-31'
                GROUP BY DEPTNO) HIRE1981,
         (SELECT COUNT(1)
                FROM EMP
                WHERE HIREDATE BETWEEN '1982-01-01' AND '1982-12-31') HIRE1982
FROM DEPT D, EMP E
GROUP BY E.DEPTNO, D.DNAME 
;

;
SELECT E.DEPTNO, D.DNAME,
        (SELECT DEPTNO, COUNT(DEPTNO)
                FROM EMP
                WHERE HIREDATE BETWEEN '1980-01-01' AND '1980-12-31'
                GROUP BY DEPTNO) HIRE1980,
         (SELECT DEPTNO COUNT(1)
                FROM EMP
                WHERE HIREDATE BETWEEN '1981-01-01' AND '1981-12-31'
                GROUP BY DEPTNO) HIRE1981,
         (SELECT COUNT(1)
                FROM EMP
                WHERE HIREDATE BETWEEN '1982-01-01' AND '1982-12-31') HIRE1982
FROM DEPT D, EMP E
GROUP BY E.DEPTNO, D.DNAME 
;




--12. 1981년 5월 31일 이후 입사자 중 커미션(COMM)이 NULL이거나 0인 사원의 커미션은 500으로 그렇지 않으면 기존
--COMM을 출력하시오.
--ENAME COMM
------------ ----------
--MARTIN 1400
--CLARK 500
--SCOTT 500
--KING 500
--TURNER 500
--ADAMS 500
--JAMES 500
--FORD 500
--MILLER 500
--

SELECT ENAME,
    (CASE WHEN COMM IS NULL THEN 500
            WHEN COMM=0 THEN 500
            ELSE COMM
            END)
FROM(
    SELECT *
    FROM EMP
    WHERE HIREDATE >= TO_DATE('1981-05-31'))
;


--13. 1981년 6월 1일 ~ 1981년 12월 31일 입사자 중 부서명(DNAME)이 SALES인 사원의 부서번호,사원명,직업,
--입사일을 출력하시오.
---조건 1.입사일 오름차순 정렬
--DEPTNO DNAME ENAME JOB HIREDATE
------------ -------------- ---------- --------- --------------------------------
--30 SALES TURNER SALESMAN 1981-09-08
--30 SALES MARTIN SALESMAN 1981-09-28
--30 SALES JAMES CLERK 1981-12-03
--

SELECT D.DEPTNO, E.ENAME, E.JOB
FROM EMP E, DEPT D
WHERE E.DEPTNO=D.DEPTNO
AND     D.DNAME='SALES'
AND HIREDATE BETWEEN '1981-06-01' AND '1981-12-31'
;

--14.현재 시간과 현재 시간으로부터 한 시간 후의 시간을 출력하시오.
---조건 1.현재시간 포맷은 ‘4자리년-2자일월-2자리일 24시:2자리분:2자리초’로 출력
---조건 1.한시간후 포맷은 ‘4자리년-2자일월-2자리일 24시:2자리분:2자리초’로 출력
--현재시간 한시간후
--------------------- -------------------
--2012-07-31 05:43:45 2012-07-31 06:43:45
--
SELECT TO_DATE(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), TO_DATE(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')+TO_DATE('1', 'HH24')
FROM DUAL

--15.각 부서별 사원수를 출력하시오.
---조건 1.부서별 사원수가 없더라도 부서번호,부서명은 출력
---조건 2.부서별 사원수가 0인 경우 ‘없음’출력
---조건 3.부서번호 오름차순 정렬
--DEPTNO DNAME 사원수
------------ -------------- ----------------------------------------
--10 ACCOUNTING 3
--20 RESEARCH 5
--30 SALES 6
--40 OPERATIONS 없음
--
SELECT D.DEPTNO, D.DNAME, COUNT(1)
FROM EMP E, DEPT D
WHERE E.DEPTNO=D.DEPTNO
GROUP BY D.DEPTNO, D.DNAME


--16.사원 테이블에서 각 사원의 사원번호,사원명,매니저번호,매니저명을 출력하시오.
---조건 1.각 사원의 급여(SAL)는 매니저 급여보다 많거나 같다.
--사원번호 사원명 매니저사원번호 매니저명
------------ ---------- ---------- ----------
--7902 FORD 7566 JONES
--7788 SCOTT 7566 JONES
--
--


--18.사원명의 첫 글자가 ‘A’이고,처음과 끝 사이에 ‘LL’이 들어가는 사원의 커미션이 COMM2일때,
--모든 사원의 커미션에 COMM2를 더한 결과를 사원명, COMM, COMM2, COMM+COMM2로 출력하시오.
--ENAME COMM COMM2 COMM+COMM2
------------ ---------- ---------- ----------
--ADAMS 0 300 300
--ALLEN 300 300 600
--BLAKE 0 300 300
--CLARK 0 300 300
--FORD 0 300 300
--JAMES 0 300 300
--JONES 0 300 300
--KING 0 300 300
--MARTIN 1400 300 1700
--MILLER 0 300 300
--SCOTT 0 300 300
--SMITH 0 300 300
--TURNER 0 300 300
--WARD 500 300 800
--


--19.각 부서별로 1981년 5월 31일 이후 입사자의 부서번호,부서명,사원번호,사원명,입사일을 출력하시오.
---조건 1.부서별 사원정보가 없더라도 부서번호,부서명은 출력
---조건 2.부서번호 오름차순 정렬
---조건 3.입사일 오름차순 정렬
--DEPTNO DNAME EMPNO ENAME HIREDATE
------------ -------------- ---------- ---------- ---------
--10 ACCOUNTING 7782 CLARK 09-6-81
--10 ACCOUNTING 7839 KING 17-11-81
--10 ACCOUNTING 7934 MILLER 23-1-82
--20 RESEARCH 7902 FORD 03-12-81
--20 RESEARCH 7788 SCOTT 19-4-87
--20 RESEARCH 7876 ADAMS 23-5-87
--30 SALES 7844 TURNER 08-9-81
--30 SALES 7654 MARTIN 28-9-81
--30 SALES 7900 JAMES 03-12-81
--40 OPERATIONS
--내풀이
SELECT D.DEPTNO, D.DNAME, E.EMPNO, E.ENAME, E.HIREDATE
FROM DEPT D,
    (SELECT *
    FROM EMP
    WHERE HIREDATE >= TO_DATE('1981-05-31')) E
WHERE E.DEPTNO(+)=D.DEPTNO
ORDER BY D.DEPTNO, E.HIREDATE
;



--20.입사일로부터 지금까지 근무년수가 40년 미만인 사원의 사원번호,사원명,입사일,근무년수를 출력하시오.
---조건 1.근무년수는 월을 기준으로 버림 (예:30.4년 = 30년, 30.7년=30년)
--EMPNO ENAME HIREDATE 근무년수
------------ ---------- ---------- ----------
--7788 SCOTT 1987-04-19 25
--7876 ADAMS 1987-05-23 2

--내풀이
SELECT EMPNO, ENAME, HIREDATE, TRUNC((SYSDATE-HIREDATE)/365,0) 근무년수
FROM EMP
WHERE (SYSDATE-HIREDATE) < 40*365