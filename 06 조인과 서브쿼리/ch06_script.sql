-- 6�� ���̺� ���̸� �������ִ� ���ΰ� ���� ���� �˾ƺ���

-- ���� ����
select a.employee_id, a.emp_name, a.department_id, b.department_name
    from employees a, 
        departments b
    where a.department_id = b.department_id;
    
-- ���� ����
select department_id, department_name
    from departments a
    where exists(select *
                    from employees b
                    where a.department_id = b.department_id
                        and b.salary > 3000)
    order by a.department_name;
    
select department_id, department_name
    from departments a
    where a.department_id in (select b.department_id
                                    from employees b
                                    where b.salary > 3000)
    order by department_name;
    
select a.department_id, a.department_name
    from departments a, employees b
    where a.department_id = b.department_id
        and b.salary > 3000
    order by a.department_name;

-- ��Ƽ ����
select a.employee_id, a.emp_name, a.department_id, b.department_name
    from employees a, 
        departments b
    where a.department_id = b.department_id
        and a.department_id not in (select department_id
                                        from departments
                                        where manager_id is null);
          
select count(*)
    from employees a
    where not exists(select 1
                        from departments c
                        where a.department_id = c.department_id
                            and manager_id is null);

-- ���� ����
select a.employee_id, a.emp_name, b.employee_id, b.emp_name, a.department_id
    from employees a,
        employees b
    where a.employee_id < b.employee_id
        and a.department_id = b.department_id
        and a.department_id = 20;
        
-- �ܺ� ����
select a.department_id, a.department_name, b.job_id, b.department_id
    from departments a,
        job_history b
    where a.department_id = b.department_id;    -- job_history ���̺� ���� �μ� ��ȸ X
    
select a.department_id, a.department_name, b.job_id, b.department_id
    from departments a,
        job_history b
    where a.department_id = b.department_id(+);
    
select a.employee_id, a.emp_name, b.job_id, b.department_id
    from employees a,
        job_history b
    where a.employee_id = b.employee_id(+)
    and a.department_id = b.department_id;  -- 4�Ǹ� ��ȸ��
    
select a.employee_id, a.emp_name, b.job_id, b.department_id
    from employees a,
        job_history b
    where a.employee_id = b.employee_id(+)
        and a.department_id = b.department_id(+);   -- �ܺ� ������ ���ǿ� �ش��ϴ� ���� ���� ��ο� (+)�� �ٿ���
        
-- īŸ�þ� ����
select a.employee_id, a.emp_name, b.department_id, b.department_name
    from employees a, 
        departments b;
        
-- ANSI ���� ����
select a.employee_id, a.emp_name, b.department_id, b.department_name
    from employees a,
        departments b
    where a.department_id = b.department_id
        and a.hire_date >= to_date('2003-01-01', 'YYYY-MM-DD');
        
select a.employee_id, a.emp_name, b.department_id, b.department_name
    from employees a
    inner join departments b        -- ANSI ����
        on (a.department_id = b.department_id)
    where a.hire_date >= to_date('2003-01-01', 'YYYY-MM-DD');
    
select a.employee_id, a.emp_name, b.department_id, b.department_name
    from employees a
    inner join departments b
        using (department_id)
    where a.hire_date >= to_date('2003-01-01', 'YYYY-MM_DD');   -- (X) using ���� �� �κ��� �ĺ��ڸ� ���� �� ����.
    
select a.employee_id, a.emp_name, department_id, b.department_name
    from employees a
    inner join departments b
        using (department_id)
    where a.hire_date >= to_date('2003-01-01', 'YYYY-MM-DD');
    
-- ANSI �ܺ� ����
select a.employee_id, a.emp_name, b.job_id, b.department_id
    from employees a,
        job_history b
    where a.employee_id = b.employee_id(+)
        and a.department_id = b.department_id(+);