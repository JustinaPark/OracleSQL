-- self check

-- 1. ex3_6�̶�� ���̺��� ����� ��� ���̺�(employees)���� ������ ����� 124���̰� 
--   �޿��� 2000���� 3000 ���̿� �ִ� ����� ���, �����, �޿�, ������ ����� �Է��ϴ� insert���� �ۼ��غ���.

create table ex3_6 (
          employee_id  NUMBER(6),
          emp_name     VARCHAR2(80),
          salary       NUMBER(8,2),
          manager_id   NUMBER(6)
            );
            
insert into ex3_6 (employee_id, emp_name, salary, manager_id)
        select employee_id, emp_name, salary, manager_id
            from employees
            where manager_id = 124
                and salary between 2000 and 3000;
                
select * from ex3_6;

-- 2. 
delete ex3_3;

insert into ex3_3 (employee_id)
    select e.employee_id 
        from employees e, sales s
        where e.employee_id = s.employee_id
            and s.sales_month between '200010' and '200012'
        group by e.employee_id;
        
-- commit;

merge into ex3_3 a
    using ( select employee_id, salary, manager_id
                from employees
                where manager_id = 145 ) b
    on ( a.employee_id = b.employee_id )
        when matched then
            update set a.bonus_amt = a.bonus_amt + b.salary * 0.01
        when not matched then
            insert (a.employee_id, a.bonus_amt) values (b.employee_id, b.salary * .005);
    
select * from ex3_3;
rollback;

-- 3. ��� ���̺�(employees)���� Ŀ�̼�(commission_pct) ���� ���� ����� ����� ������� �����ϴ� ������ �ۼ��غ���.
select employee_id, emp_name
    from employees
    where commission_pct is null;
    
-- 4. �Ʒ��� ������ �� �����ڷ� ��ȯ�� ����.
select employee_id, salary
    from employees
    where salary between 2000 and 2500
    order by employee_id;
    
select employee_id, salary
    from employees
    where salary >= 2000
        and salary <= 2500
    order by employee_id;
    
-- 5. ������ �� ������ any, all�� ����ؼ� ������ ����� �����ϵ��� ������ ����.
select employee_id, salary
    from employees
    where salary in (2000, 3000, 4000)
    order by employee_id;

select employee_id, salary
    from employees
    where salary = any (2000, 3000, 4000)
    order by employee_id;
    
select employee_id, salary
    from employees
    where salary not in (2000, 3000, 4000)
    order by employee_id;
    
select employee_id, salary
    from employees
    where salary <> all (2000, 3000, 4000)
    order by employee_id;