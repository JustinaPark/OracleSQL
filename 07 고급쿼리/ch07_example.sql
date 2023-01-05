-- self check

-- 1. 계층형 쿼리 응용편에서 LISTAGG 함수를 사용해 다음과 같이 로우를 컬럼으로 분리했다.
select department_id, 
        listagg(emp_name, ',') within group (order by emp_name) as empnames
    from employees
    where department_id is not null
    group by department_id;
-- listagg 함수 대신 계층형 쿼리, 분석함수를 사용해서 위 쿼리와 동일한 결과를 산출하는 쿼리를 작성해보자.
select department_id,
    SUBSTR(SYS_CONNECT_BY_PATH(emp_name, ','),2) empnames
 from (select emp_name, 
            department_id,
            count(*) over (partition by department_id) cnt,
            ROW_NUMBER () OVER ( partition BY department_id order BY emp_name) rowseq 
          FROM employees
          WHERE department_id IS NOT NULL)
 WHERE rowseq = cnt
 START WITH rowseq = 1 
CONNECT BY PRIOR rowseq + 1 = rowseq 
    AND PRIOR department_id = department_id; 
    
-- 2. 다음 쿼리는 사원 테이블에서 JOB_ID가 'SH_CLERK'인 사원을 조회하는 쿼리다.
select employee_id, emp_name, hire_date
    from employees
    where job_id = 'SH_CLERK'
    order by hire_date;
    
-- 사원 테이블에서 퇴사일자(retire_date)는 모두 비어있는데, 위 결과에서 사원번호가 184번인 사원의 퇴사일자는 
-- 다음으로 입사일자가 빠른 192번 사원의 입사일자라고 가정해서 다음과 같은 형태로 결과를 추출하도록 쿼리를 작성해보자.
-- (입사일자가 가장 최근인 183번 사원의 퇴사일자는 NULL이다).

select employee_id, emp_name, hire_date
        , lead(hire_date) over (PARTITION BY JOB_ID order by hire_date) as retire_date
    from employees
    where job_id = 'SH_CLERK'
    order by hire_date;
    
-- 3. sales 테이블에는 판매 데이터, customers 테이블에는 고객정보가 있다.
-- 2001년 12월(sales_month = '200112') 판매 데이터 중 현재일자를 기준으로 고객의 나이(customoers.cust_year_of_birth)를
-- 계신해서 다음과 같이 연령대별 매출금액을 보여주는 쿼리를 작성해 보자.

select * from sales;
select * from customers;

select 