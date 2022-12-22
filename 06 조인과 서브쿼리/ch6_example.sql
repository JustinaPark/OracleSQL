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
-- 1,2 �����ؼ� �ִ����, �ּ� ���� ��� ã��
-- 3����� ��� ���̺� �����ؼ� ��� �̸� ��������

