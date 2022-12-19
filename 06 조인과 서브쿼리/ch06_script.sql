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