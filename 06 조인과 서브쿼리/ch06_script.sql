-- 6�� ���̺� ���̸� �������ִ� ���ΰ� ���� ���� �˾ƺ���

select a.employee_id, a.emp_name, a.department_id, b.department_name
    from employees a, 
        departments b
    where a.department_id = b.department_id;