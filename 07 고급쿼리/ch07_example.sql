-- self check

-- 1. ������ ���� �������� LISTAGG �Լ��� ����� ������ ���� �ο츦 �÷����� �и��ߴ�.
select department_id, 
        listagg(emp_name, ',') within group (order by emp_name) as empnames
    from employees
    where department_id is not null
    group by department_id;
-- listagg �Լ� ��� ������ ����, �м��Լ��� ����ؼ� �� ������ ������ ����� �����ϴ� ������ �ۼ��غ���.
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
    
-- 2. ���� ������ ��� ���̺��� JOB_ID�� 'SH_CLERK'�� ����� ��ȸ�ϴ� ������.
select employee_id, emp_name, hire_date
    from employees
    where job_id = 'SH_CLERK'
    order by hire_date;
    
-- ��� ���̺��� �������(retire_date)�� ��� ����ִµ�, �� ������� �����ȣ�� 184���� ����� ������ڴ� 
-- �������� �Ի����ڰ� ���� 192�� ����� �Ի����ڶ�� �����ؼ� ������ ���� ���·� ����� �����ϵ��� ������ �ۼ��غ���.
-- (�Ի����ڰ� ���� �ֱ��� 183�� ����� ������ڴ� NULL�̴�).

select employee_id, emp_name, hire_date
        , lead(hire_date) over (PARTITION BY JOB_ID order by hire_date) as retire_date
    from employees
    where job_id = 'SH_CLERK'
    order by hire_date;
    
-- 3. sales ���̺��� �Ǹ� ������, customers ���̺��� �������� �ִ�.
-- 2001�� 12��(sales_month = '200112') �Ǹ� ������ �� �������ڸ� �������� ���� ����(customoers.cust_year_of_birth)��
-- ����ؼ� ������ ���� ���ɴ뺰 ����ݾ��� �����ִ� ������ �ۼ��� ����.

select * from sales;
select * from customers;

select 