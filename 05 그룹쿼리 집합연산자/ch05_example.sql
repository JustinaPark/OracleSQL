-- self check

-- 1. ��� ���̺��� �Ի�⵵�� ��� ���� ���ϴ� ������ �ۼ��� ����.
select * from employees;

select to_char(hire_date, 'YYYY')
    from employees;

select to_char(hire_date, 'YYYY'), 
        count(*)
    from employees
    group by to_char(hire_date, 'YYYY')
    order by to_char(hire_date, 'YYYY');
    
-- 2. kor_loan_status ���̺��� 2012�⵵ ����, ������ ���� �� �ܾ��� ���ϴ� ������ �ۼ��� ����.
select * from kor_loan_status;

select period, region, sum(loan_jan_amt) totl_jan
from kor_loan_status
where period like '2012%'
group by rollup(period, region)
order by period, region;

-- 3. ������ ������ ���� rollup�� ������ ������.
select period, gubun, sum(loan_jan_amt) totl_jan
    from kor_loan_status
    where period like '2013%'
    group by period, rollup(gubun);
    
-- �� ������ rollup�� ������� �ʰ�, ���� �����ڷ� ������ ����� �������� ������ �ۼ��� ����.
SELECT period, gubun, SUM(loan_jan_amt) totl_jan
  FROM kor_loan_status
 WHERE period LIKE '2013%' 
 GROUP BY period,  gubun
 UNION 
SELECT period, '', SUM(loan_jan_amt) totl_jan
  FROM kor_loan_status
 WHERE period LIKE '2013%' 
 GROUP BY period;  
 
-- 4. ���� ������ �����ؼ� ����� Ȯ���ϰ� ���� �����ڷ� ������ ����� �����ϵ��� ������ �ۼ��� ����.
select period,
        case when gubun = '���ô㺸����' 
            then sum(loan_jan_amt) 
            else 0 end ���ô㺸�����,
        case when gubun = '��Ÿ����' 
            then sum(loan_jan_amt)
            else 0 end ��Ÿ�����
    from kor_loan_status
    where period = '201311'
    group by period, gubun;
        
select period, 
        nvl(sum(loan_jan_amt), 0) ���ô㺸�����,
        nvl(sum(loan_jan_amt), 0) ��Ÿ�����
    from kor_loan_status
    where period = '201311' 
        and (gubun = '���ô㺸����'
        or gubun = '��Ÿ����')
    group by period, gubun
    union
    select period, nvl(sum(loan_jan_amt), 0) ��Ÿ�����
    from kor_loan_status
    where period = '201311' 
        and gubun = '��Ÿ����'
    group by period, gubun;
    
-- ��
SELECT period, SUM(loan_jan_amt) ���ô㺸�����, 0 ��Ÿ�����
  FROM kor_loan_status
 WHERE period = '201311' 
   AND gubun = '���ô㺸����'
 GROUP BY period, gubun
 UNION ALL
SELECT period, 0 ���ô㺸�����, SUM(loan_jan_amt) ��Ÿ�����
  FROM kor_loan_status
 WHERE period = '201311' 
   AND gubun = '��Ÿ����'
 GROUP BY period, gubun ;
 
-- 5. ������ ���� ����, �� ������ �� ���� ���� �� �ܾ��� ���ϴ� ������ �ۼ��� ����.

-- ��
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