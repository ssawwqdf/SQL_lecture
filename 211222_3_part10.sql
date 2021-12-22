
/*-------------------------------------
CHAP 10. DDL(DATA DEFINITION LANGUAGE): CREATE, DROP, ALTER****
--ROLLLBACK; 자동커밋 롤백 안됨...주의
--EMPTY: 데이터 비워져있을 때 가급적 사용... 주의주의주의
-------------------------------------*/

--컬럼 이름 변경
alter table EMP_HISTORY2 rename column "JOB" to "JOB2";

DESC EMP_HISTORY2; --테이블 요약!!!!!!!

--컬럼 추가
ALTER TABLE EMP_HISTORY2 ADD FNAME VARCHAR2(10);
DESC EMP_HISTORY2;

--컬럼 삭제
alter table EMP_HISTORY2 drop column SAL2;
alter table EMP_HISTORY2 drop column COMM;
DESC EMP_HISTORY2;

--테이블 이름 변경
alter table EMP_HISTORY2 rename to EMP_NEW;
DESC EMP_HISTORY2;

