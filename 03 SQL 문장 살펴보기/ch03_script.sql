drop table ex3_5;
--commit;

-- 3�� SQL ���� ���캸��
-- select��
select employee_id, emp_name
    from employees
    where salary > 5000;
    
select employee_id, emp_name
    from employees
    where salary > 5000
    order by employee_id;
    
select employee_id, emp_name
    from employees
    where salary > 5000
        and job_id = 'IT_PROG'  -- ��ҹ��� ����
    order by employee_id;
    
select employee_id, emp_name
    from employees
    where salary > 5000
        or job_id = 'IT_PROG'  -- ��ҹ��� ����
    order by employee_id;
    
select a.employee_id, a.emp_name, a.department_id, 
        b.department_name
    from employees a,
        departments b
    where a.department_id = b.department_id;
    
select a.employee_id, a.emp_name, a.department_id,
        b.department_name as dep_name
    from employees a,
        departments b
    where a.department_id = b.department_id;

-- insert��
create table ex3_1 (
            col1 varchar2(10),
            col2 number,
            col3 date
            );
            
insert into ex3_1 (col1, col2, col3)
    values ('ABC', 10, SYSDATE);
    
insert into ex3_1 (col3, col1, col2)
    values (SYSDATE, 'DEF', 20);
    
insert into ex3_1 (col1, col2, col3)
    values ('ABC', 10, 30);     -- (x) ������ Ÿ�� �����
    
select * from ex3_1;    -- �÷��� ��� ������ �÷� ����

insert into ex3_1
    values ('GHI', 10, sysdate);
    
insert into ex3_1 (col1, col2)
    values ('GHI', 20);     -- (O)
    
insert into ex3_1
    values ('GHI', 30);     -- (x) ���� ���� ������� ����
    

create table ex3_2 (
            emp_id number,
            emp_name varchar2(100));
            
insert into ex3_2(emp_id, emp_name)
    select employee_id, emp_name
        from employees
        where salary > 5000;
        
select * from ex3_1;

insert into ex3_1(col1, col2, col3)
    values (10, '10', '2014-01-01');    -- ������ ����ȯ : ������ Ÿ���� �ڵ����� ��ȯ
    
-- update��
select * from ex3_1;

update ex3_1
    set col2 = 50;
    
update ex3_1
    set col3 = sysdate
    where col3 is null;     -- '= null', '= ''' (X) ����Ŭ������ �ݵ�� is null�� ��
    
-- merge��
