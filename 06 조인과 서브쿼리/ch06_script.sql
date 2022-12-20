-- 6장 테이블 사이를 연결해주는 조인과 서브 쿼리 알아보기

-- 동등 조인
select a.employee_id, a.emp_name, a.department_id, b.department_name
    from employees a, 
        departments b
    where a.department_id = b.department_id;
    
-- 세미 조인
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

-- 안티 조인
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

-- 셀프 조인
select a.employee_id, a.emp_name, b.employee_id, b.emp_name, a.department_id
    from employees a,
        employees b
    where a.employee_id < b.employee_id
        and a.department_id = b.department_id
        and a.department_id = 20;
        
-- 외부 조인
select a.department_id, a.department_name, b.job_id, b.department_id
    from departments a,
        job_history b
    where a.department_id = b.department_id;    -- job_history 테이블에 없는 부서 조회 X
    
select a.department_id, a.department_name, b.job_id, b.department_id
    from departments a,
        job_history b
    where a.department_id = b.department_id(+);
    
select a.employee_id, a.emp_name, b.job_id, b.department_id
    from employees a,
        job_history b
    where a.employee_id = b.employee_id(+)
    and a.department_id = b.department_id;  -- 4건만 조회됨
    
select a.employee_id, a.emp_name, b.job_id, b.department_id
    from employees a,
        job_history b
    where a.employee_id = b.employee_id(+)
        and a.department_id = b.department_id(+);   -- 외부 조인은 조건에 해당하는 조인 조건 모두에 (+)를 붙여야
        
-- 카타시안 조인
select a.employee_id, a.emp_name, b.department_id, b.department_name
    from employees a, 
        departments b;
        
-- ANSI 내부 조인
select a.employee_id, a.emp_name, b.department_id, b.department_name
    from employees a,
        departments b
    where a.department_id = b.department_id
        and a.hire_date >= to_date('2003-01-01', 'YYYY-MM-DD');
        
select a.employee_id, a.emp_name, b.department_id, b.department_name
    from employees a
    inner join departments b        -- ANSI 문법
        on (a.department_id = b.department_id)
    where a.hire_date >= to_date('2003-01-01', 'YYYY-MM-DD');
    
select a.employee_id, a.emp_name, b.department_id, b.department_name
    from employees a
    inner join departments b
        using (department_id)
    where a.hire_date >= to_date('2003-01-01', 'YYYY-MM_DD');   -- (X) using 절의 열 부분은 식별자를 가질 수 없음.
    
select a.employee_id, a.emp_name, department_id, b.department_name
    from employees a
    inner join departments b
        using (department_id)
    where a.hire_date >= to_date('2003-01-01', 'YYYY-MM-DD');
    
-- ANSI 외부 조인
select a.employee_id, a.emp_name, b.job_id, b.department_id
    from employees a,
        job_history b
    where a.employee_id = b.employee_id(+)
        and a.department_id = b.department_id(+);
        
select a.employee_id, a.emp_name, b.job_id, b.department_id
    from employees a
    left outer join job_history b
        on (a.employee_id = b.employee_id
            and a.department_id = b.department_id);
            
select a.employee_id, a.emp_name, b.job_id, b.department_id
    from job_history b
    right outer join employees a
        on (a.employee_id = b.employee_id
            and a.department_id = b.department_id);
            
select a.employee_id, a.emp_name, b.job_id, b.department_id
    from employees a
    left join job_history b         -- outer 생략 가능
        on (a.employee_id = b.employee_id
            and a.department_id = b.department_id);
            
-- cross 조인
select a.employee_id, a.emp_name, b.department_id, b.department_name
    from employees a,
        departments b;
        
select a.employee_id, a.emp_name, b.department_id, b.department_name
    from employees a
        cross join departments b;
        
-- full outer 조인
create table HONG_A (emp_id int);
create table HONG_B (emp_id int);

insert into hong_a values ( 10);
insert into hong_a values ( 20);
insert into hong_a values ( 40);

insert into hong_b values ( 10);
insert into hong_b values ( 20);
insert into hong_b values ( 30);

commit;

select a.emp_id, b.emp_id
    from hong_a a,
        hong_b b
    where a.emp_id(+) = b.emp_id(+);    -- (X)outer-join된 테이블은 1개만 지정 가능

select a.emp_id, b.emp_id
    from hong_a a
    full outer join hong_b b
        on (a.emp_id = b.emp_id);
        
-- 서브쿼리
select count(*)
    from employees
    where salary >= (select avg(salary)
                        from employees);

select count(*)
    from employees
    where department_id in (select department_id
                                from departments
                                where parent_id is null);
                                
select employee_id, emp_name, job_id
    from employees
    where (employee_id, job_id) in (select employee_id, job_id
                                        from job_history);
                                        
update employees
    set salary = ( select avg(salary)
                    from employees );
                    
delete employees
    where salary >= ( select avg(salary)
                        from employees );
                        
rollback;

select * 
    from employees;
    
select a.department_id, a.department_name
    from departments a
    where exists( select 1
                    from job_history b
                    where a.department_id = b.department_id );
                    
select a.employee_id,
    ( select b.emp_name
        from employees b
        where a.employee_id = b.employee_id ) as emp_name,
    a.department_id,
    ( select b.department_name
        from departments b
        where a.department_id = b.department_id ) as dep_name
    from job_history a;
    
select a.department_id, a.department_name
    from departments a
    where exists ( select 1
                    from employees b
                    where a.department_id = b.department_id
                        and b.salary > ( select avg(salary)
                                            from employees )
                    );
                    
update employees a
    set a.salary = ( select sal
                        from ( select b.department_id, avg(c.salary) as sal
                                from departments b,
                                    employees c
                                where b.parent_id = 90
                                    and b.department_id = c.department_id
                                group by b.department_id ) d
                        where a.department_id = d.department_id )
    where a.department_id in ( select department_id
                                    from departments
                                    where parent_id = 90 );
                                    
select department_id, min(salary), max(salary)
    from employees a
    where department_id in ( select department_id
                                from departments
                                where parent_id = 90 )
    group by department_id;
    
merge into employees a
    using ( select b.department_id, avg(c.salary) as sal
                from departments b,
                    employees c
                where b.parent_id = 90
                    and b.department_id = c.department_id
                group by b.department_id ) d
        on ( a.department_id = d.department_id )
    when matched then
        update set a.salary = d.sal;
        
rollback;


-- 인라인 뷰
select a.employee_id, a.emp_name, b.department_id, b.department_name
    from employees a,
        departments b,
        ( select avg(c.salary) as avg_salary
            from departments b,
                employees c
            where b.parent_id = 90 
                and b.department_id = c.department_id ) d
    where a.department_id = b.department_id
        and a.salary > d.avg_salary;
        
select a.*
    from ( select a.sales_month, round(avg(a.amount_sold)) as month_avg
            from sales a,
                customers b,
                countries c
            where a.sales_month between '200001' and '200012'
                and a.cust_id = b.cust_id
                and b.country_id = c.country_id
                and c.country_name = 'Italy'
            group by a.sales_month
        ) a,
        ( select round(avg(a.amount_sold)) as year_avg
            from sales a,
                customers b,
                countries c
            where a.sales_month between '200001' and '200012'
                and a.cust_id = b.cust_id
                and b.country_id = c.country_id
                and c.country_name = 'Italy'
        ) b
    where a.month_avg > b.year_avg;