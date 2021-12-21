/*-------------
 part 8
--------------*/

--EMP에서 10번 부서만 뽑아서 TABLE 만듦.
--전에 배운 대로면 이렇게
--CREATE TABEL EMP_HISTORY ( EMPNO NUMBER(4), ENAME VERAHR(203));
--INSERT INTO EMP_HISTORY VALUES (773, 212,. ...);

--하지만 우리는 가져올 데이터가 있으므로
--테이블 복제
CREATE TABLE EMP_history as (select * from emp where deptno = '10');
SELECT * FROM EMP_HISTORY;

INSERT INTO EMP_history VALUES
(9999,'GUGUGU','SALESMAN',7698,TO_DATE('28-9-1981','dd-mm-yyyy'),1300,0,10);
COMMIT;

--union / union all
(SELECT * FROM EMP_HISTORY)
UNION
(SELECT * FROM EMP)
; --15개

SELECT * FROM EMP_HISTORY
UNION ALL
SELECT * FROM EMP
; --18개


--INTERSECT (교집합)
(SELECT * FROM EMP_HISTORY)
INTERSECT
(SELECT * FROM EMP)
;

--IMINUS(순서 주의!!)
SELECT * FROM EMP
MINUS
SELECT * FROM EMP_HISTORY
;

SELECT * FROM EMP_HISTORY
MINUS
SELECT * FROM EMP
;


--새 값 더해서 보려면 행 형식 맞춰줘야함
--
SELECT EMPNO, ENAME FROM EMP
UNION
SELECT 111, 'ABC' FROM DUAL
UNION
SELECT 222, 'FGH' FROM DUAL
;

--행 개수 안 맞음 에러
--01789. 00000 -  "query block has incorrect number of result columns"
SELECT EMPNO, ENAME FROM EMP
UNION
SELECT 111, 'ABC' FROM DUAL
UNION
SELECT 222, 'FGH', 333 FROM DUAL
;

-- SSSS에 컬럼 이름 안 주면 그냥 1번행 값 따라간다
-- 'SSSS'그냥 쓰면 모든 행이 'SSSS'값을 가지는 열을 추가한다.
(SELECT EMPNO, ENAME, 'SSSS' AS COL1 FROM EMP)
UNION
(SELECT 111, 'ABC', 'BCD' FROM DUAL)
UNION
(SELECT 222, 'FGH', 'GHI' FROM DUAL)
;


-- SELECT 일치
-- 타입 일치 안 하면 TO_000 SQL문 사용
(SELECT EMPNO, ENAME, JOB AS COL1 FROM EMP)
UNION
(SELECT 111, 'ABC', 'BCD' FROM DUAL)
UNION
(SELECT 222, 'FGH', 'GHI' FROM DUAL)
;

(SELECT EMPNO, ENAME, TO_CHAR(1111) AS COL1 FROM EMP)
UNION
(SELECT 111, 'ABC', 'BCD' FROM DUAL)
UNION
(SELECT 222, 'FGH', 'GHI' FROM DUAL)
;

--ORDER BY로 첫째 열이 아닌 열 기준으로 굳이 정렬해야 하는 경우
--INLINE VIEW를 써라
SELECT *
FROM (SELECT * FROM EMP_HISTORY
        UNION ALL
        SELECT * FROM EMP)
ORDER BY ENAME
;

/*-------------
 part 9
--------------*/

--<INSERT>
CREATE TABLE TT(SEQ NUMBER, VAL NUMBER);  --DDL은 롤백 안 된다. 지우고 싶으면 DROP
INSERT INTO TT VALUES(1,2);
SELECT * FROM TT;

DROP TABLE TT;
CREATE TABLE TT(SEQ NUMBER, VAL VARCHAR2(10));
INSERT INTO TT VALUES(1,'2');
INSERT INTO TT VALUES(SYSDATE,'2'); --TYPE 다르면 에러(묵시적 변환해주기도 하지만 쓰지마라.)
SELECT * FROM TT;

--모든 열에 값을 넣으면 나열 안 해도 된다.
INSERT INTO TT(SEQ, VAL) VALUES(66, '육육'); --아래와 같은 결과
INSERT INTO TT VALUES(66, '육육'); --위와 같은 결과

--INSERT NULL
INSERT INTO TT VALUES(3,NULL); --NULL
INSERT INTO TT VALUES(4, ''); --NULL
INSERT INTO TT VALUES(99, 'NULL'); --NULL이라는 문자가 들어간다.
INSERT INTO TT VALUES(88, ' '); --공백 글자가 들어간다
INSERT INTO TT(SEQ) VALUES(77);--취급 안 해도 NULL이다.

SELECT * FROM TT;

--형 일치
CREATE TABLE QQ(SEQ NUMBER, VAL VARCHAR2(10), RDDATE DATE);
INSERT INTO QQ VALUES(11,'2020-11-11', SYSDATE);
SELECT * FROM QQ; --겉보기에는 VAL과 RDDATE 값은 같아보임.
SELECT SEQ, VAL+1, RDDATE FROM QQ; --에러
SELECT SEQ, TO_DATE(VAL+1 YYYY-MM-DD), RDDATE FROM QQ; --원본은 그대로 글자지만 보여주기만 날짜로(에러 확인)
SELECT SEQ, VAL, RDDATE+1 FROM QQ; --정상


ROLLBACK; --COMMIT 안 했으므로 데이터 다 날라감. 단 테이블 형태는 남음.

--다른 테이블에서 행 복사(오라클 버전마다 되는 게 있고 아닌 게 있다.)
--SUBQUERY를 쓰며 VALUES는 필요 없다.
SELECT * FROM EMP_HISTORY;
INSERT INTO EMP_HISTORY 
   SELECT * FROM EMP WHERE DEPTNO = 20; --EMP 테이블에서 20번 부서 사람 더함.
   
INSERT INTO EMP_HISTORY 
   SELECT * FROM EMP WHERE DEPTNO = 30; --EMP 테이블에서 30번 부서 사람 더함.
   

-- (위에 PART 8에서 했던 거랑 비교)테이블 복제(테이블 생성 후 데이터까지 입력)
CREATE TABLE EMP_history
AS (select * from emp where deptno = '10'); --AS: ~처럼 만들어줘
SELECT * FROM EMP_HISTORY;

-- 테이블이 있다는 전제로 데이터만 멀티로 입력
INSERT INTO EMP_HISTORY 
   SELECT * FROM EMP WHERE DEPTNO = 30;
   
-- 테이블 모양만 복제하고 싶은 경우(EX. 월 단위로 테이블 만드는 경우. 배치성테이블)
CREATE TABLE EMP_history2
AS (select * from emp where deptno = 99999999); --이렇게 해도는 된다

CREATE TABLE EMP_history3
AS (select * from emp where 1=0); --현업에서 많이 함. 세상에 1=0인 값 없으니까

DROP TABLE EMP_HISTORY2;
DROP TABLE EMP_HISTORY3;
DROP TABLE QQ;

CREATE TABLE QQQ(SEQ NUMBER PRIMARY KEY,
                VAL VARCHAR2(10),
                RDATE DATE NOT NULL  --NULL이면 안 된다.
                );

INSERT INTO QQQ(SEQ, VAL) VALUES (1, 'AAA');
--에러 난다. CREATE TABLE 할 때 QQQ의 RDATE에 NULL이면 안 된다고 했는데
--해당 명령어대로면 DATE가 NULL이 되기 때문

INSERT INTO QQQ(SEQ, VAL, RDATE) VALUES (1, 'AAA', SYSDATE);
INSERT INTO QQQ(SEQ, VAL, RDATE) VALUES (2, NULL, SYSDATE);

--PK 조건: 1. 중복 X, 2. NULL X
INSERT INTO QQQ(SEQ, VAL, RDATE) VALUES (2, 'BBB', SYSDATE); --에러: SEQ는 PK인데 중복값
--                   ORA-00001: unique constraint (AI.SYS_C007025) violated
INSERT INTO QQQ(SEQ, VAL, RDATE) VALUES (NULL, 'BBB', SYSDATE);--에러: SEQ는 PK인데 NULL
--                   ORA-01400: cannot insert NULL into ("AI"."QQQ"."SEQ")


--<UPDATE>
