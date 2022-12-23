-- self check

-- 1. 101�� ����� ���� �Ʒ��� ����� �����ϴ� ������ �ۼ��غ���

select * from employees;
select * from DEPARTMENTS;

SELECT
    employee_id AS ���,
    emp_name AS �����,
    job_id AS job��Ī,
    hire_date AS job��������,
    retire_date AS job��������,
    b.department_name AS job����μ���
FROM
    employees a,
    departments b
WHERE
    a.employee_id = '101'
    AND a.department_id = b.department_id;
    
-- 2. �Ʒ��� ������ �����ϸ� ������ �߻��Ѵ�. ������ ������?

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

-- 3. �ܺ� ������ �� �� (+)�����ڸ� ���� ����� �� ���µ�, IN ���� ����ϴ� ���� �� ���̸� ����� �� �ִ�.
--    �� ������?

-- 4. ������ ������ ANSI �������� ������ ����.

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
    
    
-- 5. ������ ������ �ִ� ���� ������. �̸� ������ ���� ���� ������ ��ȯ�� ����.
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
    
-- 6. ������ ��Ż���� �ִ����װ� ����� �ۼ��ϴ� ������ �������� 
-- �ִ����� �Ӹ� �ƴ϶� �ּҸ���װ� �ش� ����� ��ȸ�ϴ� ������ �ۼ��� ����.

select * from countries;
select * from customers;
select * from sales;
select * from employees;

-- ����, ����� ��Ż���� ����� ���ϱ�
select substr(a.sales_month, 1, 4) as years,
    a.employee_id, sum(a.amount_sold) as amount_sold
from sales a, customers b, countries c
where a.cust_id = b.cust_id
    and b.country_id = c.country_id
    and c.country_name = 'Italy'
group by substr(a.sales_month, 1, 4), a.employee_id;

-- 1 ������� ������ �ִ�, �ּ� ����� ���ϱ�
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

-- 1,2 �����ؼ� �ִ����, �ּ� ���� ��� ã��
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


-- 3����� ��� ���̺� �����ؼ� ��� �̸� ��������
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

-- 1998 �ּڰ� ��𰬳�......
-- employees ���̺� ��� �׷���

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