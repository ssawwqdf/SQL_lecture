--다른 계정에 있는 테이블에서 SQL문 불러와서 테이블 넣을 수 있다.
--전체를 긁어올 필요는 없고 CREATE부분만 하면 된다.
DROP TABLE DEPT;
CREATE TABLE DEPT
       (DEPTNO NUMBER(2) CONSTRAINT PK_DEPT PRIMARY KEY,
	DNAME VARCHAR2(14) ,
	LOC VARCHAR2(13) ) ;
DROP TABLE EMP;
CREATE TABLE EMP
       (EMPNO NUMBER(4) CONSTRAINT PK_EMP PRIMARY KEY,
	ENAME VARCHAR2(10),
	JOB VARCHAR2(9),
	MGR NUMBER(4),
	HIREDATE DATE,
	SAL NUMBER(7,2),
	COMM NUMBER(7,2),
	DEPTNO NUMBER(2) CONSTRAINT FK_DEPTNO REFERENCES DEPT);

INSERT INTO DEPT VALUES
	(10,'ACCOUNTING','NEW YORK');
INSERT INTO DEPT VALUES (20,'RESEARCH','DALLAS');
INSERT INTO DEPT VALUES
	(30,'SALES','CHICAGO');
INSERT INTO DEPT VALUES
	(40,'OPERATIONS','BOSTON');
INSERT INTO EMP VALUES
(7369,'SMITH','CLERK',7902,to_date('17-12-1980','dd-mm-yyyy'),800,NULL,20);
INSERT INTO EMP VALUES
(7499,'ALLEN','SALESMAN',7698,to_date('20-2-1981','dd-mm-yyyy'),1600,300,30);
INSERT INTO EMP VALUES
(7521,'WARD','SALESMAN',7698,to_date('22-2-1981','dd-mm-yyyy'),1250,500,30);
INSERT INTO EMP VALUES
(7566,'JONES','MANAGER',7839,to_date('2-4-1981','dd-mm-yyyy'),2975,NULL,20);
INSERT INTO EMP VALUES
(7654,'MARTIN','SALESMAN',7698,to_date('28-9-1981','dd-mm-yyyy'),1250,1400,30);
INSERT INTO EMP VALUES
(7698,'BLAKE','MANAGER',7839,to_date('1-5-1981','dd-mm-yyyy'),2850,NULL,30);
INSERT INTO EMP VALUES
(7782,'CLARK','MANAGER',7839,to_date('9-6-1981','dd-mm-yyyy'),2450,NULL,10);
INSERT INTO EMP VALUES
(7788,'SCOTT','ANALYST',7566,to_date('13-7-1987','dd-mm-yyyy'),3000,NULL,20);
INSERT INTO EMP VALUES
(7839,'KING','PRESIDENT',NULL,to_date('17-11-1981','dd-mm-yyyy'),5000,NULL,10);
INSERT INTO EMP VALUES
(7844,'TURNER','SALESMAN',7698,to_date('8-9-1981','dd-mm-yyyy'),1500,0,30);
INSERT INTO EMP VALUES
(7876,'ADAMS','CLERK',7788,to_date('13-7-1987', 'dd-mm-yyyy'),1100,NULL,20);
INSERT INTO EMP VALUES
(7900,'JAMES','CLERK',7698,to_date('3-12-1981','dd-mm-yyyy'),950,NULL,30);
INSERT INTO EMP VALUES
(7902,'FORD','ANALYST',7566,to_date('3-12-1981','dd-mm-yyyy'),3000,NULL,20);
INSERT INTO EMP VALUES
(7934,'MILLER','CLERK',7782,to_date('23-1-1982','dd-mm-yyyy'),1300,NULL,10);


DROP TABLE SALGRADE;
CREATE TABLE SALGRADE
      ( GRADE NUMBER,
	LOSAL NUMBER,
	HISAL NUMBER );
INSERT INTO SALGRADE VALUES (1,700,1200);
INSERT INTO SALGRADE VALUES (2,1201,1400);
INSERT INTO SALGRADE VALUES (3,1401,2000);
INSERT INTO SALGRADE VALUES (4,2001,3000);
INSERT INTO SALGRADE VALUES (5,3001,9999);
COMMIT;

SET TERMOUT ON
SET ECHO ON
;


--COMMIT하고 나와야 데이터베이스 상에 저장된다.



--==================================================

--그룹함수
--MAX IN SUM AVG COUNT
--COUNT(1) COUNT(*) COUNT(DEPTNO)

SELECT * FROM EMP;

SELECT DEPTNO, JOB, COUNT(1)
FROM EMP
GROUP BY DEPTNO, JOB
HAVING COUNT(1) > 1
ORDER BY DEPTNO;

--WHERE은 SELECT에 대한 조건 HAVING은 GROUP에 대한 조건이라고 생각해도 될 것 같다
--그렇게 생각하면 왜 WHERE에 그룹함수 못 쓰는지 직관적으로 이해할 수 있다.
SELECT MIN(SAL)
FROM EMP
WHERE DEPTNO=10;

SELECT MIN(SAL)
FROM EMP
GROUP BY DEPTNO
HAVING DEPTNO=10;
--위에 둘 다 같은 결과 반환. 위의 경우 DEPTNO가 10인 애들 중에서 최소 SAL을 구하는 거고
--아래는 부서별 그룹에서 부서번호를 10으로 갖는 그룹을 선택하고 최소 SAL을 구하는 거라

SELECT DEPTNO, MIN(SAL)
FROM EMP
WHERE DEPTNO=10
GROUP BY DEPTNO --사실 안 넣어도 말은 됨. 근데 안 넣으면 에러가 난다. 그룹함수랑 일반컬럼 같이 써서
;

--WHERE에는 그룹함수 못 씀.
--서브쿼리 안에 그룹함수 들어가는 건 괜춘
SELECT *
FROM EMP
WHERE SAL < (SELECT MIN(SAL) FROM EMP WHERE DEPTNO=10)
;

--멀티컬럼조건
SELECT *
FROM EMP
WHERE (JOB, SAL) IN (SELECT JOB, MIN(SAL) FROM EMP WHERE DEPTNO=10 GROUP BY JOB)
;

SELECT * FROM EMP
WHERE JOB=(SELECT JOB FROM EMP WHERE ENAME='ALLEN')
;

--멀티컬럼조건 (HAVING)은 안 된다.
SELECT MIN(SAL), MAX(SAL) FROM EMP
GROUP BY DEPTNO
HAVING (MIN(SAL), MAX(SAL)) = (10, 1)
;


--셀프조인.

--가전 카테고리를 생각해보자.
CREATE TABLE CATES(
CTAE_1 VARCHAR2(6),
CATE_2 VARCHAR2(10),
CATE_3 VARCHAR2(20))
; --컬럼 1 이름 잘못 만듦 -.-;;


SELECT * FROM CATES
WHERE CTAE_1='가전'; --테이블 이렇게 만드는 경우 많지 않다. CATE(카테)구분 자체가 늘어날 수 있기 때문.

/*-------------------------------
보통 이런 식으로 만든다.

CATE_SEQ CATE_NAME CATE_GUBUN CATE_P(부모카테고리SEQ)
      1 가전           1            
      2 세탁기         2         1
      3 냉장고         2         1
      4 LG트롬_C012    3         2
      5 삼성세탁기_C012 
      6 LG냉장고_C012
      7 삼성냉장고_C012
      8 가구          1
      9 침대          2        8
---------------------------------------------------*/

--데이터 넣으면서 CSV 샘플파일 넣기(CATE)

--대카테고리 불러오기
SELECT * FROM CATE
WHERE CATE_GUBUN=1;

--중카테고리 불러오기
SELECT * FROM CATE
WHERE CATE_GUBUN=2;

SELECT C1.CATE_NAME 대카테, C2.CATE_NAME 중카테
FROM CATE C1, CATE C2
WHERE C1.CATE_SEQ=C2.CATE_P
AND C1.CATE_P IS NULL --CATE_GUBUN=1해도 됨.
;

--소카테고리 불러오기
SELECT C1.CATE_NAME 대카테, C2.CATE_NAME 중카테, C3.CATE_NAME 소카테
FROM CATE C1, CATE C2, CATE C3
WHERE C1.CATE_SEQ=C2.CATE_P(+)
AND C2.CATE_SEQ=C3.CATE_P(+)
AND C1.CATE_P IS NULL
;


--INDEX
--3,4년차 팀장급 되면 PLAN 짜서 메모리랑 스캔 순서 이런 거 확인해야됨.

--모델링

--다대다간계 질문

drop table empcp;
CREATE TABLE EMPCP AS 
(SELECT * FROM EMP WHERE EMPNO IN (7934, 7369,7521))
;

INSERT INTO EMPCP (SELECT * FROM EMP WHERE EMPNO='7839');
UPDATE EMPCP SET DEPTNO=99 WHERE EMPNO='7839';
SELECT * FROM EMPCP;

select *
FROM EMPCP E, DEPT D
WHERE E.DEPTNO=D.DEPTNO
;

select *
FROM EMPCP E RIGHT OUTER JOIN DEPT D
ON E.DEPTNO=D.DEPTNO
;

select *
FROM EMPCP E FULL OUTER JOIN DEPT D
ON E.DEPTNO=D.DEPTNO
;                                       --문법적으로는 말이 되지만 데이터 해석이 안 된다.

--오라클 랭크 함수
--RANK
--중복순위 처리의 문제(중복 개수만큼 다음 순위 값 증가? 중복순위 있어도 순차적으로?)
--전자가 RANK, 후자가  DENSE_RANK()
--오라클 OVER라는 함수 상당히 많다. OVER: 집계 함수(통계용 함수. EX 각 부서별 합산,
--합산 낸 거 중 꼴찌)

SELECT ENAME 
     , SAL 
     , RANK() OVER (ORDER BY SAL DESC)       RANK 
     , DENSE_RANK() OVER (ORDER BY SAL DESC) DENSE_RANK 
  FROM EMP 
 ORDER BY SAL DESC;

