
--EMP, DEPT TABLE 복제
CREATE TABLE EMP_CP AS (SELECT * FROM EMP);
CREATE TABLE DEPT_CP AS (SELECT * FROM DEPT);


--부서번호 10인 애들 SAL에 100을 곱한 값 반환
SELECT *
FROM EMP
WHERE DEPTNO=10;
  --SELECT 를 쓰면
SELECT SAL*100
FROM EMP
WHERE DEPTNO=10; --원본 바뀌지 않음


  --UPDATE를 쓰면

UPDATE EMP_CP
SET SAL = 5555;  --이러면 모든 애들 다 변함 주의!!!
ROLLBACK;

UPDATE EMP_CP
SET SAL=5555
WHERE DEPTNO=10; --10번 부서만 SAL=5555로 바뀜

UPDATE EMP_CP
SET SAL=5555,
    JOB='GOGOGOGO'
WHERE DEPTNO=1;  --바꾸고싶은만큼 ,로 구분해서 적어줘라

UPDATE EMP_CP
SET SAL=5555,
    JOB='GOGOGOGO',
    MGR=NULL               
WHERE DEPTNO=10;     ---------그동안 COL IS NULL 썼다. 근데 업데이트문에서만 =써야됨

SELECT *
FROM EMP_CP
ORDER BY DEPTNO
;
--SET에 서브쿼리를 넣을 수도 있다.
-- EMP_CP테이블에서 7900의 사원정보를 7844직업과 같고 7654의 급여와 같게 수정
SELECT *
FROM EMP_CP
ORDER BY DEPTNO
; 

UPDATE EMP_CP
SET JOB=(SELECT JOB
        FROM EMP
        WHERE EMPNO=7844),
    SAL=(SELECT SAL
        FROM EMP
        WHERE EMPNO=7654)
WHERE EMPNO=7900
;

(SELECT *
FROM EMP_CP
WHERE EMPNO=7900
    OR  EMPNO=7844
    OR EMPNO=7654)
UNION
(SELECT *
FROM EMP
WHERE EMPNO=7900
    OR  EMPNO=7844
    OR EMPNO=7654)
; 

--확인 후 COMMIT하든 ROLLBACK하든해라~
COMMIT;

---<DELETE>
--이 값 지워줘 이런 건 없다. 한 줄을 날리는 게 DELETE
--UPDATE보다 더 위험하다. 모르고 했으면 빠르게 DBA를 찾아가라
--조건을 달아줘라
SELECT * FROM EMP_CP;
DELETE
FROM EMP_CP
WHERE DEPTNO=30;


--SMITH와 같은 부서 사원들 삭제
DELETE
FROM EMP_CP
WHERE DEPTNO=(SELECT DEPTNO
            FROM EMP
            WHERE ENAME='SMITH')
;

SELECT *
FROM EMP_CP
;
ROLLBACK;
--DELETE 하기 전에 SELECT로 대체해서 맞는지 확인


--+ TRUNCATE
--TRUNCATE는 DELETE와 달리 DDL문이라 ROLLBACK이 안 된다 주의!!!
DELETE FROM QQQ; --데이터만 날라가고 테이블 껍데기는 남는다. 백업로그도 있다.
DROP TABLE QQQ; --테이블 자체를 없앤다.
TRUNCATE TABLE QQQ; --데이터가 날라가고 테이블 껍데기는 남는다.(데이터가 잘려나갔습니다.)
                    --DELETE와의 차이는 DELETE는 백업은 남겨두지만 TRUNCATE는 남겨두지 않는다.
                    --DBA도 복구할 방법이 없다.

