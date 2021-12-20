--1. Write a query to display the employee name and hiredate for all
--employees in the same department as Blake. Exclude Blake.

SELECT ENAME, HIREDATE
FROM EMP
WHERE DEPTNO = (SELECT DEPTNO
                 FROM EMP
                 WHERE ENAME='BLAKE')
AND ENAME != 'BLAKE'
;

--3. Write a query to display the employee number and name for all
--employees who work in a department with any employee whose name
--contains a T. Save your SQL statemant in a file called p6q3.sql
SELECT EMPNO, ENAME
FROM EMP
WHERE DEPTNO IN (SELECT DEPTNO
                FROM EMP
                WHERE ENAME LIKE '%T%'
                GROUP BY DEPTNO
                HAVING COUNT(1)>0)
;

--> P6Q3.SQL

--4. Display the employee name, department number, and job title for all
--employees whose department location is Dallas.

SELECT ENAME, DEPTNO, JOB
FROM (SELECT E.*
        FROM EMP E, DEPT D
        WHERE E.DEPTNO=D.DEPTNO
        AND     D.LOC='DALLAS')
;

--5. Display the employee name and salary of all employees who report to
--King
SELECT ENAME, SAL
FROM EMP
WHERE MGR=(SELECT EMPNO
            FROM EMP
            WHERE ENAME='KING')
;

--6. Display the department number, name,, and job for all employees in the
--Sales department.
SELECT D.DEPTNO, D.DNAME, E.JOB
FROM DEPT D, EMP E
WHERE D.DEPTNO=E.DEPTNO
AND D.DNAME='SALES'
;

--7. Modify p6q3.sql to display the employee number, name, and salary for all
--employees who earn more than the average salary and who work in a
--department with any employee with a T in their name. Rerun your
--query. 

SELECT EMPNO, ENAME, SAL
FROM (SELECT *
        FROM EMP
                WHERE DEPTNO IN (SELECT DEPTNO
                FROM EMP
                WHERE ENAME LIKE '%T%'
                GROUP BY DEPTNO
                HAVING COUNT(1)>0))
WHERE SAL > (SELECT AVG(SAL)
                FROM EMP
                WHERE DEPTNO IN (SELECT DEPTNO
                                FROM EMP
                                WHERE ENAME LIKE '%T%'
                                GROUP BY DEPTNO
                                HAVING COUNT(1)>0))
;

