-- self check

-- 1. ex3_6이라는 테이블을 만들고 사원 테이블(employees)에서 관리자 사번이 124번이고 
--   급여가 2000에서 3000 사이에 있는 사원의 사번, 사원명, 급여, 관리자 사번을 입력하는 insert문을 작성해보자.

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

-- 3. 사원 테이블(employees)에서 커미션(commission_pct) 값이 없는 사원의 사번과 사원명을 추출하는 쿼리를 작성해보자.
select employee_id, emp_name
    from employees
    where commission_pct is null;
    
-- 4. 아래의 쿼리를 논리 연산자로 변환해 보자.
select employee_id, salary
    from employees
    where salary between 2000 and 2500
    order by employee_id;
    
select employee_id, salary
    from employees
    where salary >= 2000
        and salary <= 2500
    order by employee_id;
    
-- 5. 다음의 두 쿼리를 any, all을 사용해서 동일한 결과를 추출하도록 변경해 보자.
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