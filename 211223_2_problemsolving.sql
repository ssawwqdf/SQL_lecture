--1.회원별 주문 상품 통계
--회원아이디 상품번호 상품갯수 구매금액
--(조건:주문건이 없더라도 회원출력)

--<내코드>
---주문 건별
select U.USER_ID, OG.GOOD_SEQ, OG.ORDER_AMOUNT, OG.ORDER_PRICE
from USERS U, ORDERS_GOODS OG, ORDERS O
WHERE U.USER_SEQ=O.USER_SEQ(+)
AND OG.ORDER_CODE=O.ORDER_CODE
ORDER BY USER_ID, GOOD_SEQ
;
---주문 상품 중복 시 통합

select U.USER_ID, OG.GOOD_SEQ, SUM(OG.ORDER_AMOUNT), SUM(OG.ORDER_PRICE)
from USERS U, ORDERS_GOODS OG, ORDERS O
WHERE U.USER_SEQ=O.USER_SEQ(+)
AND OG.ORDER_CODE=O.ORDER_CODE
GROUP BY USER_ID, GOOD_SEQ
ORDER BY USER_ID, GOOD_SEQ
;

--<강사님코드>
SELECT U.USER_ID, OG.GOOD_SEQ, SUM(OG.ORDER_AMOUNT), SUM(OG.ORDER_PRICE)
FROM USERS U, ORDERS O, ORDERS_GOODS OG
WHERE U.USER_SEQ=O.USER_SEQ(+)
AND O.ORDER_CODE=OG.ORDER_CODE(+)
GROUP BY U.USER_ID, OG.GOOD_SEQ
ORDER BY U.USER_ID
;

--ORDER가 NULL이면 OG쪽도 NULL일 것이다
--OG랑 O에도 (+) 해주기!! 왜지???????????????

--2.업체별 공급 상품 리스트
--업체번호 업체명 상품번호 상품명
--(조건:상품이 없더라도 업체명 출력)

--내코드
--왜 CG에 안 되는지 이해 못 했다.
--company를 다 보여줘라 company goods에 없어도. 그래서 cg에 (+)
--그러면 cg랑 g 연결해야되는데 cg의 널값이랑 연결되는 g가 있을까? 없다.
--그래도 보여줘야하니까 g에 (+) 해주는 것!!!!
--가운데 cg 가리면 궁극적으로는 a에서 c(+)로 가는 것.
--문식님 질문: 근데 seq는 pk인데 null 들어가도 되나?


SELECT C.COM_SEQ, C.COM_NAME, G.GOOD_SEQ, G.GOOD_NAME
FROM COMPANY C, COMPANY_GOODS CG, GOODS G
WHERE C.COM_SEQ=CG.COM_SEQ(+)
AND G.GOOD_SEQ(+)=CG.GOOD_SEQ
ORDER BY C.COM_SEQ
;

--강사님
--GOOD테이블
SELECT C.COM_SEQ, C.COM_NAME, G.GOOD_SEQ, G.GOOD_NAME
FROM COMPANY C, COMPANY_GOODS CG, GOODS G
WHERE C.COM_SEQ=CG.COM_SEQ(+)
AND G.GOOD_SEQ(+)=CG.GOOD_SEQ
ORDER BY C.COM_SEQ
;

--

--3.회원관리
--정규직/비정규직 구분하여 출력 
--조건1:정규직이면A,비정규직이면B로 출력
--조건2:급여(1일 8시간 한달:20일 기준으로 계산)
--회원번호 회원명 정규/비정규여부 월급여

--(비정규직은 시급)

--내코드
--JOIN 시 코드 AND가 아니라 OR!!!
SELECT U.USER_ID, U.USER_NAME,
CASE WHEN U.USER_SEQ IN (SELECT USER_SEQ
                        FROM FULLTIME)
            THEN 'A',
     WHEN U.USER_SEQ IN (SELECT USER_SEQ
                        FROM PARTTIME) 
            THEN 'B',
     ELSE NULL
     END AB
FROM USERS U, FULTIME F, PARTTIME P
WHERE U.USER_SEQ=F.USER_SEQ(+)
AND U.USER_SEQ=P.USER_SEQ(+)

;

--강사님 코드
SELECT U.USER_SEQ, U.USER_NAME, 'B' AS "정규/비정규여부", TSAL*8*20 AS "월급여"
FROM USERS U, PARTTIME P
WHERE U.USER_SEQ=P.USER_SEQ
UNION
SELECT U.USER_SEQ, U.USER_NAME, 'A' AS "정규/비정규여부", ASAL AS "월급여"
FROM USERS U, FULLTIME F
WHERE U.USER_SEQ=F.USER_SEQ
;

--조건문 버전
SELECT U.USER_SEQ, U.USER_NAME, 'B' AS "정규/비정규여부", TSAL*8*20 AS "월급여"
FROM USERS U, PARTTIME P
WHERE U.USER_SEQ=P.USER_SEQ
UNION
SELECT U.USER_SEQ, U.USER_NAME, 'A' AS "정규/비정규여부", ASAL AS "월급여"
FROM USERS U, FULLTIME F
WHERE U.USER_SEQ=F.USER_SEQ
;


(SELECT U.USER_SEQ, U.SUER_NAME, 'B' AS "정규/비정규", TSAL*8*20 AS 월급여,
CASE WHEN TSAL>0 THEN 'B'
    ELSE 'A'
    END)구분

--아래처럼 하면 박씨 두 번 나온다.(두 번 연결됐기 때문)
SELECT U.USER_SEQ, U.USER_NAME, P.USER_SEQ PS, F.USER_SEQ FS
FROM USERS U, PARTTIME P, FULLTIME F
WHERE U.USER_SEQ=P.USER_SEQ OR
      U.USER_SEQ=F.USER_SEQ
;

--4.상품/주문관리
--주문된 상품별 판매량, 판매금액 출력
--조건:판매량이 높은 순으로 정렬
--상품번호 상품명 상품금액 총판매량 총판매금액

SELECT G.GOOD_SEQ, G.GOOD_NAME, G.GOOD_PRICE, SUM(OG.ORDER_AMOUNT) TAMT, SUM(OG.ORDER_PRICE) TPRICE
FROM GOODS G, ORDERS O, ORDERS_GOODS OG
WHERE G.GOOD_SEQ=OG.GOOD_SEQ AND
        O.ORDER_CODE=OG.ORDER_CODE
GROUP BY G.GOOD_SEQ, G.GOOD_NAME, G.GOOD_PRICE
ORDER BY TAMT DESC
;

--5. 사용자별 구매 통계(VVIP)
--회원아이디  총구매횟수   총구매금액
--조건1 : 구매금액이 높은 순 출력
--내코드
SELECT U.USER_ID 회원아이디, COUNT(1) 총구매횟수, SUM(O.TOT_PRICE) 총구매금액
FROM USERS U, ORDERS O
WHERE U.USER_SEQ=O.USER_SEQ
GROUP BY U.USER_SEQ, U.USER_ID
ORDER BY 총구매금액 DESC
;

--강사님
SELECT U.USER_SEQ, COUNT(O.USER_SEQ) TCNT, SUM(O.TOT_PRICE) TPRICE
FROM USERS U, ORDERS O
WHERE U.USER_SEQ=O.USER_SEQ
GROUP BY U.USER_SEQ
ORDER BY TPRICE DESC;
;


--6. 휴먼회원 통계
--구매실적이 전혀 없는 회원 목록 출력

--회원아이디 회원명  
--lee       이씨     

--내코드
SELECT USID, USNM
FROM (SELECT U.USER_ID USID, U.USER_NAME USNM, COUNT(O.ORDER_CODE) OC
        FROM USERS U, ORDERS O
        WHERE U.USER_SEQ=O.USER_SEQ(+)
        GROUP BY U.USER_ID, U.USER_NAME
        HAVING COUNT(O.ORDER_CODE)=0)
;


--강사님(간단하게)
SELECT * FROM USERS
WHERE USER_SEQ NOT IN
                    (SELECT DISTINCT USER_SEQ
                    FROM ORDERS);


--7. 전체 회원 목록 중 휴먼 회원이 차지하는 비율?
--조건1 : 관리자 제외
--조건2: 휴먼회원은 구매 실적이 전혀 없는 회원
-- 회원수   휴먼회원비율
--------- 
--  2/5      40%       

--강사님 (d이거 맞아? 확인)
SELECT DM||'/'||AM 회원수, (DM/AM)*100||'%' 휴면회원비율
FROM(SELECT
            (SELECT COUNT(1) FROM USERS WHERE USER_ID!='admin') AM,
            (SELECT COUNT(1)
            FROM USERS
            WHERE USER_SEQ
            NOT IN(SELECT DISTINCT USER_SEQ
                    FROM ORDERS) AND
                    USER_ID='admin') DM
FROM DUAL);


--8. 각 회원별로 매니저-회원 관계를 출력하시오
--조건1: 관리자 제외
--조건2: 매니저번호 오름차순 회원번호 오름차순 정렬


--매니저  회원  
--lee	kim
--lee     park
--prak    hong

SELECT M.USER_ID 매니저, U.USER_ID 회원
FROM USERS U, USERS M
WHERE U.MGR_SEQ=M.USER_SEQ
ORDER BY U.MGR_SEQ, U.USER_SEQ
;


--9. 주문/상품/업체 대시보드 현황판

-- 총주문수량 총주문금액  총회원수  총업체수 총상품수
-- 58         1025000     5         7        12

--       AMT      PRICE       UCNT       CCNT       GCNT
---------- ---------- ---------- ---------- ----------
--        48     244000          5          7         10
SELECT (SELECT SUM(ORDER_AMOUNT)
        FROM ORDERS_GOODS OG) AMT,
        (SELECT SUM(ORDER_PRICE)
        FROM ORDERS_GOODS OG) PRICE,
        (SELECT COUNT(USER_SEQ)
        FROM USERS U) UCNT,
        (SELECT COUNT(COM_SEQ)
        FROM COMPANY C) CCNT,
        (SELECT COUNT(GOOD_SEQ)
        FROM GOODS G) GCNT
FROM DUAL;

--10.월별 판매 실적....
--  1월   2월   3월   4월  
-- 20000  12000  50000 0
SELECT NVL((SELECT SUM(TOT_PRICE)
             FROM ORDERS 
             WHERE ORDER_DATE BETWEEN '2018-01-01' AND '2018-01-31'),0) "1월",
       NVL((SELECT SUM(TOT_PRICE)
             FROM ORDERS 
             WHERE ORDER_DATE BETWEEN '2018-02-01' AND '2018-02-28'),0) "2월", 
       NVL((SELECT SUM(TOT_PRICE)
             FROM ORDERS 
             WHERE ORDER_DATE BETWEEN '2018-03-01' AND '2018-03-31'),0) "3월",
       NVL((SELECT SUM(TOT_PRICE)
             FROM ORDERS 
             WHERE ORDER_DATE BETWEEN '2018-04-01' AND '2018-04-30'),0) "4월",
       NVL((SELECT SUM(TOT_PRICE)
             FROM ORDERS 
             WHERE ORDER_DATE BETWEEN '2018-05-01' AND '2018-05-31'),0) "5월",
       NVL((SELECT SUM(TOT_PRICE)
             FROM ORDERS 
             WHERE ORDER_DATE BETWEEN '2018-06-01' AND '2018-06-30'),0) "6월",
       NVL((SELECT SUM(TOT_PRICE)
             FROM ORDERS 
             WHERE ORDER_DATE BETWEEN '2018-07-01' AND '2018-07-31'),0) "7월",
       NVL((SELECT SUM(TOT_PRICE)
             FROM ORDERS 
             WHERE ORDER_DATE BETWEEN '2018-08-01' AND '2018-08-31'),0) "8월", 
       NVL((SELECT SUM(TOT_PRICE)
             FROM ORDERS 
             WHERE ORDER_DATE BETWEEN '2018-09-01' AND '2018-09-30'),0) "9월",
       NVL((SELECT SUM(TOT_PRICE)
             FROM ORDERS 
             WHERE ORDER_DATE BETWEEN '2018-10-01' AND '2018-10-31'),0) "10월",
       NVL((SELECT SUM(TOT_PRICE)
             FROM ORDERS 
             WHERE ORDER_DATE BETWEEN '2018-11-01' AND '2018-11-30'),0) "11월",
       NVL((SELECT SUM(TOT_PRICE)
             FROM ORDERS 
             WHERE ORDER_DATE BETWEEN '2018-12-01' AND '2018-12-31'),0) "12월"
FROM DUAL
;

--강사님 다른 풀이(1월만 나타내면)
SELECT 
    (SELECT SUM(DECODE(TOT_PRICE, NULL, 0, TOT_PRICE)) FROM ORDERS WHERE ORDER_DATE BETWEEN '2018-01-01' AND '2018-01-31') AS "1월"
FROM DUAL
;