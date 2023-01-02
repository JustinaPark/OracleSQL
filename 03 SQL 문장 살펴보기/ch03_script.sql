drop table ex3_5;
--commit;

-- 3장 SQL 문장 살펴보기
-- select문
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
        and job_id = 'IT_PROG'  -- 대소문자 구분
    order by employee_id;
    
select employee_id, emp_name
    from employees
    where salary > 5000
        or job_id = 'IT_PROG'  -- 대소문자 구분
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

-- insert문
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
    values ('ABC', 10, 30);     -- (x) 데이터 타입 맞춰야
    
select * from ex3_1;    -- 컬럼명 기술 생략시 컬럼 순서

insert into ex3_1
    values ('GHI', 10, sysdate);
    
insert into ex3_1 (col1, col2)
    values ('GHI', 20);     -- (O)
    
insert into ex3_1
    values ('GHI', 30);     -- (x) 값의 수가 충분하지 않음
    

create table ex3_2 (
            emp_id number,
            emp_name varchar2(100));
            
insert into ex3_2(emp_id, emp_name)
    select employee_id, emp_name
        from employees
        where salary > 5000;
        
select * from ex3_1;

insert into ex3_1(col1, col2, col3)
    values (10, '10', '2014-01-01');    -- 묵시적 형변환 : 데이터 타입이 자동으로 변환
    
-- update문
select * from ex3_1;

update ex3_1
    set col2 = 50;
    
update ex3_1
    set col3 = sysdate
    where col3 is null;     -- '= null', '= ''' (X) 오라클에서는 반드시 is null로 비교
    
-- merge문
