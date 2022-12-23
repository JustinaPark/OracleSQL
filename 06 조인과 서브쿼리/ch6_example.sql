-- self check

-- 1. 101번 사원에 대해 아래의 결과를 산출하는 쿼리를 작성해보자

select * from employees;
select * from DEPARTMENTS;

SELECT
    employee_id AS 사번,
    emp_name AS 사원명,
    job_id AS job명칭,
    hire_date AS job시작일자,
    retire_date AS job종료일자,
    b.department_name AS job수행부서명
FROM
    employees a,
    departments b
WHERE
    a.employee_id = '101'
    AND a.department_id = b.department_id;
    
-- 2. 아래의 쿼리를 수행하면 오류가 발생한다. 오류의 원인은?

SELECT
    a.employee_id,
    a.emp_name,
    b.job_id,
    b.department_id
FROM
    employees a,
    job_history b
WHERE 
    a.employee_id = b.employee_id (+)
    AND a.department_id (+) = b.department_id;
    
select * from employees;
select * from job_history;

-- 3. 외부 조인을 할 때 (+)연산자를 같이 사용할 수 없는데, IN 절에 사용하는 값이 한 개이면 사용할 수 있다.
--    그 이유는?

-- 4. 다음의 쿼리를 ANSI 문법으로 변경해 보자.

select a.department_id, a.department_name
    from departments a, employees b
where a.department_id = b.department_id
    and b.salary > 3000
order by a.department_name;

SELECT
    a.department_id,
    a.department_name
FROM
    departments a
    INNER JOIN employees b ON ( a.department_id = b.department_id )
WHERE
    b.salary > 3000
ORDER BY
    a.department_name;
    
    
-- 5. 다음은 연관성 있는 서브 쿼리다. 이를 연관성 없는 서브 쿼리로 변환해 보자.
SELECT
    a.department_id,
    a.department_name
FROM
    departments a
WHERE
    EXISTS (
        SELECT
            1
        FROM
            job_history b
        WHERE
            a.department_id = b.department_id
    );


SELECT
    department_id,
    department_name
FROM
    departments
WHERE
    department_id IN (
        SELECT
            department_id
        FROM
            job_history
    );
    
-- 6. 연도별 이탈리아 최대매출액과 사원을 작성하는 쿼리를 기준으로 
-- 최대매출액 뿐만 아니라 최소매출액과 해당 사원을 조회하는 쿼리를 작성해 보자.

select * from countries;
select * from customers;
select * from sales;
select * from employees;

-- 연도, 사원별 이탈리아 매출액 구하기
select substr(a.sales_month, 1, 4) as years,
    a.employee_id, sum(a.amount_sold) as amount_sold
from sales a, customers b, countries c
where a.cust_id = b.cust_id
    and b.country_id = c.country_id
    and c.country_name = 'Italy'
group by substr(a.sales_month, 1, 4), a.employee_id;

-- 1 결과에서 연도별 최대, 최소 매출액 구하기
select years,
    max(amount_sold) as max_sold
    , min(amount_sold) as min_sold
from (select substr(a.sales_month, 1, 4) as years,
            a.employee_id, sum(a.amount_sold) as amount_sold
        from sales a,
            customers b,
            countries c
        where a.cust_id = b.cust_id
            and b.country_id = c.country_id
            and c.country_name = 'Italy'
        group by substr(a.sales_month, 1, 4), a.employee_id) k
group by years
order by years;

-- 1,2 조인해서 최대매출, 최소 매출 사원 찾기
select emp.years, 
    emp.employee_id, 
    emp.amount_sold
from ( select substr(a.sales_month, 1, 4) as years,
            a.employee_id, sum(a.amount_sold) as amount_sold
        from sales a,
            customers b,
            countries c
        where a.cust_id = b.cust_id
            and b.country_id = c.country_id
            and c.country_name = 'Italy'
        group by substr(a.sales_month, 1, 4), a.employee_id
    ) emp,
    ( select years, 
            max(amount_sold) as max_sold,
            min(amount_sold) as min_sold
        from ( select substr(a.sales_month, 1, 4) as years,
                    a.employee_id,
                    sum(a.amount_sold) as amount_sold
                from sales a,
                    customers b,
                    countries c
                where a.cust_id = b.cust_id
                    and b.country_id = c.country_id
                    and c.country_name = 'Italy'
                group by substr(a.sales_month, 1, 4), a.employee_id
            ) K
        group by years
    ) sale
where emp.years = sale.years
    and (emp.amount_sold = sale.max_sold or emp.amount_sold = sale.min_sold)
--    and emp.amount_sold = sale.max_sold
--    and emp.amount_sold = sale.min_sold
order by years;


-- 3결과와 사원 테이블 조인해서 사원 이름 가져오기
select emp.years, 
    emp.employee_id,
    emp2.emp_name,
    emp.amount_sold
from ( select substr(a.sales_month, 1, 4) as years,
            a.employee_id, sum(a.amount_sold) as amount_sold
        from sales a,
            customers b,
            countries c
        where a.cust_id = b.cust_id
            and b.country_id = c.country_id
            and c.country_name = 'Italy'
        group by substr(a.sales_month, 1, 4), a.employee_id
    ) emp,
    ( select years, 
            max(amount_sold) as max_sold,
            min(amount_sold) as min_sold
        from ( select substr(a.sales_month, 1, 4) as years,
                    a.employee_id,
                    sum(a.amount_sold) as amount_sold
                from sales a,
                    customers b,
                    countries c
                where a.cust_id = b.cust_id
                    and b.country_id = c.country_id
                    and c.country_name = 'Italy'
                group by substr(a.sales_month, 1, 4), a.employee_id
            ) K
        group by years
    ) sale,
    employees emp2
where emp.years = sale.years
    and (emp.amount_sold = sale.max_sold or emp.amount_sold = sale.min_sold)
    and emp.employee_id = emp2.employee_id
order by years;

-- 1998 최솟값 어디갔냐......
-- employees 테이블에 없어서 그렇대

select years,
    max(amount_sold) as max_sold
    , min(amount_sold) as min_sold
from (select substr(a.sales_month, 1, 4) as years,
            a.employee_id, sum(a.amount_sold) as amount_sold
        from sales a,
            customers b,
            countries c
        where a.cust_id = b.cust_id
            and b.country_id = c.country_id
            and c.country_name = 'Italy'
        group by substr(a.sales_month, 1, 4), a.employee_id) k
where years = 1998
group by years
order by years;

select substr(a.sales_month, 1, 4) as years,
            a.employee_id, sum(a.amount_sold) as amount_sold
        from sales a,
            customers b,
            countries c
        where a.cust_id = b.cust_id
            and b.country_id = c.country_id
            and c.country_name = 'Italy'
        group by substr(a.sales_month, 1, 4), a.employee_id
        order by years;
        
        
select a.years, a.employee_id, a.amount_sold
from ( SELECT SUBSTR(a.sales_month, 1, 4) as years,
                a.employee_id, 
                SUM(a.amount_sold) AS amount_sold
           FROM sales a,
                customers b,
                countries c
          WHERE a.cust_id = b.CUST_ID
            AND b.country_id = c.COUNTRY_ID
            AND c.country_name = 'Italy'     
          GROUP BY SUBSTR(a.sales_month, 1, 4), a.employee_id) a 
                , employees emp2
where a.employee_id = emp2.employee_id
  ORDER BY years;
  
select * from sales;
select * from EMPLOYEES;