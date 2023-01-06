-- self check

-- 1. 사원 테이블에서 입사년도별 사원 수를 구하는 쿼리를 작성해 보자.
select * from employees;

select to_char(hire_date, 'YYYY')
    from employees;

select to_char(hire_date, 'YYYY'), 
        count(*)
    from employees
    group by to_char(hire_date, 'YYYY')
    order by to_char(hire_date, 'YYYY');
    
-- 2. kor_loan_status 테이블에서 2012년도 월별, 지역별 대출 총 잔액을 구하는 쿼리를 작성해 보자.
select * from kor_loan_status;

select period, region, sum(loan_jan_amt) totl_jan
from kor_loan_status
where period like '2012%'
group by rollup(period, region)
order by period, region;

-- 3. 다음의 쿼리는 분할 rollup을 적용한 쿼리다.
select period, gubun, sum(loan_jan_amt) totl_jan
    from kor_loan_status
    where period like '2013%'
    group by period, rollup(gubun);
    
-- 이 쿼리를 rollup을 사용하지 않고, 집합 연산자로 동일한 결과가 나오도록 쿼리를 작성해 보자.
SELECT period, gubun, SUM(loan_jan_amt) totl_jan
  FROM kor_loan_status
 WHERE period LIKE '2013%' 
 GROUP BY period,  gubun
 UNION 
SELECT period, '', SUM(loan_jan_amt) totl_jan
  FROM kor_loan_status
 WHERE period LIKE '2013%' 
 GROUP BY period;  
 
-- 4. 다음 쿼리를 실행해서 결과를 확인하고 집합 연산자로 동일한 결과를 추출하도록 쿼리를 작성해 보자.
select period,
        case when gubun = '주택담보대출' 
            then sum(loan_jan_amt) 
            else 0 end 주택담보대출액,
        case when gubun = '기타대출' 
            then sum(loan_jan_amt)
            else 0 end 기타대출액
    from kor_loan_status
    where period = '201311'
    group by period, gubun;
        
select period, 
        nvl(sum(loan_jan_amt), 0) 주택담보대출액,
        nvl(sum(loan_jan_amt), 0) 기타대출액
    from kor_loan_status
    where period = '201311' 
        and (gubun = '주택담보대출'
        or gubun = '기타대출')
    group by period, gubun
    union
    select period, nvl(sum(loan_jan_amt), 0) 기타대출액
    from kor_loan_status
    where period = '201311' 
        and gubun = '기타대출'
    group by period, gubun;
    
-- 답
SELECT period, SUM(loan_jan_amt) 주택담보대출액, 0 기타대출액
  FROM kor_loan_status
 WHERE period = '201311' 
   AND gubun = '주택담보대출'
 GROUP BY period, gubun
 UNION ALL
SELECT period, 0 주택담보대출액, SUM(loan_jan_amt) 기타대출액
  FROM kor_loan_status
 WHERE period = '201311' 
   AND gubun = '기타대출'
 GROUP BY period, gubun ;
 
-- 5. 다음과 같은 형태, 즉 지역과 각 월별 대출 총 잔액을 구하는 쿼리를 작성해 보자.

-- 답
SELECT REGION, 
       SUM(AMT1) AS "201111", 
       SUM(AMT2) AS "201112", 
       SUM(AMT3) AS "201210", 
       SUM(AMT4) AS "201211", 
       SUM(AMT5) AS "201312", 
       SUM(AMT6) AS "201310",
       SUM(AMT6) AS "201311"
  FROM ( 
         SELECT REGION,
                CASE WHEN PERIOD = '201111' THEN LOAN_JAN_AMT ELSE 0 END AMT1,
                CASE WHEN PERIOD = '201112' THEN LOAN_JAN_AMT ELSE 0 END AMT2,
                CASE WHEN PERIOD = '201210' THEN LOAN_JAN_AMT ELSE 0 END AMT3, 
                CASE WHEN PERIOD = '201211' THEN LOAN_JAN_AMT ELSE 0 END AMT4, 
                CASE WHEN PERIOD = '201212' THEN LOAN_JAN_AMT ELSE 0 END AMT5, 
                CASE WHEN PERIOD = '201310' THEN LOAN_JAN_AMT ELSE 0 END AMT6,
                CASE WHEN PERIOD = '201311' THEN LOAN_JAN_AMT ELSE 0 END AMT7
         FROM KOR_LOAN_STATUS
       )
GROUP BY REGION
ORDER BY REGION       
;