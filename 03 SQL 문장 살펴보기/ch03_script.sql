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
create table ex3_3 (
            employee_id number,
            bonus_amt number default 0
            );
            
insert into ex3_3 (employee_id)
    select e.employee_id
        from employees e, sales s
        where e.employee_id = s.employee_id
            and s.sales_month between '200010' and '200012'
        group by e.employee_id;
        
select * 
    from ex3_3
    order by employee_id;
    
select employee_id, manager_id, salary, salary * 0.1
    from employees
    where employee_id in ( select employee_id
                                from ex3_3)
    order by employee_id;
                                
select employee_id, manager_id, salary, salary * 0.001
    from employees
    where employee_id not in ( select employee_id
                                    from ex3_3 )
        and manager_id = 146;


merge into ex3_3 d
    using ( select employee_id, salary, manager_id
                from employees
                where manager_id = 146 ) b
        on ( d.employee_id = b.employee_id )
    when matched then
        update set d.bonus_amt = d.bonus_amt + b.salary * 0.01
    when not matched then 
        insert ( d.employee_id, d.bonus_amt ) values ( b.employee_id, b.salary * .001 )
        where ( b.salary < 8000 );
        
merge into ex3_3 d
    using ( select employee_id, salary, manager_id
                from employees
                where manager_id = 146 ) b
        on ( d.employee_id = b.employee_id )
    when matched then
        update set d.bonus_amt = d.bonus_amt + b.salary * 0.01
        delete where ( b.employee_id = 161 )
    when not matched then 
        insert ( d.employee_id, d.bonus_amt ) values ( b.employee_id, b.salary * .001 )
        where ( b.salary < 8000 );
        
-- delete��
delete ex3_3;

select *
    from ex3_3
    order by employee_id;
    
select partition_name 
    from user_tab_partitions
    where table_name = 'SALES';
    
-- commit�� rollback, trauncate
create table ex3_4 (
            employee_id number
            );
            
insert into ex3_4 values (100);

select * 
    from ex3_4;
    
-- commit;

truncate table ex3_4;

-- �ǻ��÷�(pseudo-column) : ���̺��� �÷�ó�� ���������� ������ ���̺� ��������� �ʴ� �÷�
--      select�������� ��� ���������� ���� insert, update, delete �� �� ����
--      connect_by_iscycle, connect_by_isleaf, level : ������ �������� ����ϴ� �ǻ��÷�
--      nextval, currval : ���������� ����ϴ� �ǻ��÷�
--      rownum, rowid

select rownum, employee_id
    from employees;
    
select rownum, employee_id
    from employees
    where rownum < 5;
    
select rownum, employee_id, rowid
    from employees
    where rownum < 5;
    
-- ������
select employee_id || '-' || emp_name as employee_info   -- ���ڿ����� || : �� ���ڸ� ���̴� ����
    from employees
    where rownum < 5;
    
-- ǥ���� : �� �� �̻��� ���� ������, SQL �Լ� ���� ���յ� ��
select employee_id, salary,
        case when salary <= 5000 then 'C���'     -- then ���� ��� ���� ������ Ÿ�� ��ġ���Ѿ�
            when salary > 5000 and salary <= 15000 then 'B���'
            else 'A���'
        end as salary_grade
    from employees;
    
-- ���ǽ�
-- �� ���ǽ�
select employee_id, salary
    from employees
    where salary = any ( 2000, 3000, 4000 )
    order by employee_id;
    
select employee_id, salary
    from employees
    where salary = 2000
        or salary = 3000
        or salary = 4000
    order by employee_id;
    
select employee_id, salary
    from employees
    where salary = all ( 2000, 3000, 4000 )
    order by employee_id;
    
select employee_id, salary
    from employees
    where salary = some ( 2000, 3000, 4000 )    -- any�� ����
    order by employee_id;
    
-- �� ���ǽ�
select employee_id, salary
    from employees
    where not ( salary >= 2500 )
    order by employee_id;
    
-- null ���ǽ�
--  is null, is not null�� ���ؾ� ��

-- between and ���ǽ�
select employee_id, salary
    from employees
    where salary between 2000 and 2500
    order by employee_id;

-- in ���ǽ�
select employee_id, salary
    from employees
    where salary in ( 2000, 3000, 4000 )
    order by employee_id;
    
select employee_id, salary
    from employees
    where salary not in ( 2000, 3000, 4000 )
    order by employee_id;
    
-- exists ���ǽ�
select department_id, department_name
    from departments a
    where exists ( select *
                    from employees b
                    where a.department_id = b.department_id
                        and b.salary > 3000 )
    order by a.department_name;
    
-- like ���ǽ�
select emp_name
    from employees
    where emp_name like 'A%'
    order by emp_name;
    
create table ex3_5 (
            names varchar2(30)
            );
            
insert into ex3_5 values ('ȫ�浿');
insert into ex3_5 values ('ȫ���');
insert into ex3_5 values ('ȫ���');
insert into ex3_5 values ('ȫ���');

select * 
    from ex3_5
    where names like 'ȫ��%';
    
select * 
    from ex3_5
    where names like 'ȫ��_';