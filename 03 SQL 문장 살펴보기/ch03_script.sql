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
        
-- delete문
delete ex3_3;

select *
    from ex3_3
    order by employee_id;
    
select partition_name 
    from user_tab_partitions
    where table_name = 'SALES';
    
-- commit과 rollback, trauncate
create table ex3_4 (
            employee_id number
            );
            
insert into ex3_4 values (100);

select * 
    from ex3_4;
    
-- commit;

truncate table ex3_4;

-- 의사컬럼(pseudo-column) : 테이블의 컬럼처럼 동작하지만 실제로 테이블에 저장되지는 않는 컬럼
--      select문에서는 사용 가능하지만 값을 insert, update, delete 할 수 없음
--      connect_by_iscycle, connect_by_isleaf, level : 계층형 쿼리에서 사용하는 의사컬럼
--      nextval, currval : 시퀀스에서 사용하는 의사컬럼
--      rownum, rowid

select rownum, employee_id
    from employees;
    
select rownum, employee_id
    from employees
    where rownum < 5;
    
select rownum, employee_id, rowid
    from employees
    where rownum < 5;
    
-- 연산자
select employee_id || '-' || emp_name as employee_info   -- 문자연산자 || : 두 문자를 붙이는 연산
    from employees
    where rownum < 5;
    
-- 표현식 : 한 개 이상의 값과 연산자, SQL 함수 등이 결합된 식
select employee_id, salary,
        case when salary <= 5000 then 'C등급'     -- then 이하 출력 값의 데이터 타입 일치시켜야
            when salary > 5000 and salary <= 15000 then 'B등급'
            else 'A등급'
        end as salary_grade
    from employees;
    
-- 조건식
-- 비교 조건식
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
    where salary = some ( 2000, 3000, 4000 )    -- any와 같음
    order by employee_id;
    
-- 논리 조건식
select employee_id, salary
    from employees
    where not ( salary >= 2500 )
    order by employee_id;
    
-- null 조건식
--  is null, is not null로 비교해야 함

-- between and 조건식
select employee_id, salary
    from employees
    where salary between 2000 and 2500
    order by employee_id;

-- in 조건식
select employee_id, salary
    from employees
    where salary in ( 2000, 3000, 4000 )
    order by employee_id;
    
select employee_id, salary
    from employees
    where salary not in ( 2000, 3000, 4000 )
    order by employee_id;
    
-- exists 조건식
select department_id, department_name
    from departments a
    where exists ( select *
                    from employees b
                    where a.department_id = b.department_id
                        and b.salary > 3000 )
    order by a.department_name;
    
-- like 조건식
select emp_name
    from employees
    where emp_name like 'A%'
    order by emp_name;
    
create table ex3_5 (
            names varchar2(30)
            );
            
insert into ex3_5 values ('홍길동');
insert into ex3_5 values ('홍길용');
insert into ex3_5 values ('홍길상');
insert into ex3_5 values ('홍길상동');

select * 
    from ex3_5
    where names like '홍길%';
    
select * 
    from ex3_5
    where names like '홍길_';