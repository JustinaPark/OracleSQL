-- 7장 고급 쿼리 다루기

select department_id,
    department_name,
    0 as parent_id,
    1 as levels,
    parent_id || department_id as sort
from departments
where parent_id is null
union all
select t2.department_id,
    lpad(' ', 3 * (2-1)) || t2.department_name as department_name,
    t2.parent_id,
    2 as levels,
    t2.parent_id || t2.department_id as sort
from departments t1,
    departments t2
where t1.parent_id is null
    and t2.parent_id = t1.department_id
union all 
select t3.department_id,
    lpad(' ', 3 * (3-1)) || t3.department_name as department_name,
    t3.parent_id,
    3 as levels,
    t2.parent_id || t3.parent_id || t3.department_id as sort
from departments t1,
    departments t2,
    departments t3
where t1.parent_id is null
    and t2.parent_id = t1.department_id
    and t3.parent_id = t2.department_id
union all
select t4.department_id,
    lpad(' ', 3 * (4-1)) || t4.department_name as department_name,
    t4.parent_id,
    4 as levels,
    t2.parent_id || t3.parent_id || t4.parent_id || t4.department_id as sort
from departments t1,
    departments t2,
    departments t3,
    departments t4
where t1.parent_id is null
    and t2.parent_id = t1.department_id
    and t3.parent_id = t2.department_id
    and t4.parent_id = t3.department_id
order by sort;

-- 계층형 쿼리
select department_id, lpad(' ', 3 * (level-1)) || department_name, level
    from departments
    start with parent_id is null
    connect by prior department_id = parent_id;
    
--start with 조건 : 계층형 구조에서 최상위 계층의 로우를 식별하는 조건을 명시. 이 조건에 맞는 로우부터 시작해 계층형 구조를 풀어 나간다.
--connect by 조건 : 계층형 구조가 어떤 식으로 연결되는지 기술하는 부분. 
    
select a.employee_id, lpad(' ', 3 * (level-1)) || a.emp_name,
    level,
    b.department_name
from employees a,
    departments b
where a.department_id = b.department_id
start with a.manager_id is null
connect by prior a.employee_id = a.manager_id;

select a.employee_id, lpad(' ', 3 * (level-1)) || a.emp_name,
        level,
        b.department_name, a.department_id
    from employees a,
        departments b
    where a.department_id = b.department_id
        and a.department_id = 30            -- 최상위 로우 제외됨.
    start with a.manager_id is null
    connect by nocycle prior a.employee_id = a.manager_id;
    
select a.employee_id, lpad(' ', 3 * (level-1)) || a.emp_name,
        level,
        b.department_name, a.department_id
    from employees a,
        departments b
    where a.department_id = b.department_id
    start with a.manager_id is null
    connect by nocycle prior a.employee_id = a.manager_id
        and a.department_id = 30;
        
--계층형 쿼리의 내부적 처리 절차
--1. 조인이 있으면 조인을 먼저 처리
--2. start with 절을 참조해 최상위 계층 로우 선택
--3. connect by 절에 명시된 구문에 따라 계층형 관계(부모-자식 관계)를 파악해 자식 로우를 차례로 선택.
--    최상위 로우를 기준으로 자식 로우를 선택하고, 이 자식 로우에 대한 또 다른 자식 로우가 있으면 선택하는 식.
--4. 자식 로우 찾기가 끝나면 조인을 제외한 where 조건에 해당하는 로우를 걸러내는데, 로우별로 조건에 맞지 않은 건을 걸러냄.

select department_id, lpad(' ', 3 * (level-1)) || department_name, level
    from departments
    start with parent_id is null
    connect by prior department_id = parent_id
    order by department_name;   -- 계층형 구조 깨짐. order siblings by 절 사용해야.
    
select department_id, lpad(' ', 3 * (level-1)) || department_name, level
    from departments
    start with parent_id is null
    connect by prior department_id = parent_id
    order siblings by department_name;

select department_id, lpad(' ', 3 * (level-1)) || department_name, level,
        CONNECT_BY_ROOT department_name as root_name    -- connect_by_root : 최상위 로우 반환 연산자, 다음에는 표현식이 옴
    from departments
    start with parent_id is null
    connect by prior department_id = parent_id;
    
select department_id, lpad(' ', 3 * (level-1)) || department_name, level,
        CONNECT_BY_ISLEAF
    from departments
    start with parent_id is null
    connect by prior department_id = parent_id;
    
select department_id, LPAD(' ', 3 * (LEVEL-1)) || department_name, LEVEL,
        sys_CONNECT_BY_PATH(department_name, '|')
    from departments
    start with parent_id is null
    connect by prior department_id = parent_id;
    
select department_id, lpad(' ', 3 * (level-1)) || department_name, level,
        connect_by_iscycle isloop,
        parent_id
    from departments
    start with department_id = 30
    connect by nocycle prior department_id = parent_id;
    
-- 계층형 쿼리 응용
create table ex7_1 as
    select rownum seq,
        '2014' || LPAD(CEIL(rownum/1000), 2, '0') month,
        round(dbms_random.value(100, 1000)) amt
    from dual
connect by level <= 12000;  -- 명시한 숫자만큼의 로우 반환

select * 
    from ex7_1;
    
select month, sum(amt)
    from ex7_1
    group by month
    order by month;
    
select rownum
    from ( 
        select 1 as row_num
            from dual
            union all
            select 1 as row_num
                from dual
        )
    connect by level <= 4;
    
create table ex7_2 as
    select department_id,
        listagg(emp_name, ', ') within group (order by emp_name) as empnames
    from employees
    where department_id is not null
    group by department_id;
    
select * from ex7_2;

select empnames,
    level as lvl
from ( select empnames || ',' as empnames,
            length(empnames) ori_len,
            length (replace(empnames, ',', '')) new_len
        from ex7_2
        where department_id = 90
        )
connect by level <= ori_len - new_len + 1;

select empnames, 
        decode(level, 1, 1, instr(empnames, ',', 1, level-1)) start_pos,
        instr(empnames, ',', 1, level) end_pos,
        level as lvl
    from ( select empnames || ',' as empnames,
                length(empnames) ori_len,
                length(replace(empnames, ',', '')) new_len
            from ex7_2
            where department_id = 90
            )
    connect by level <= ori_len - new_len + 1;
    
select replace (substr(empnames, start_pos, end_pos - start_pos), ',', '') as emp
    from (select empnames,
                decode(level, 1, 1, instr(empnames, ',', 1, level-1)) start_pos,
                instr(empnames, ',', 1, level) end_pos,
                level as lvl
            from ( select empnames || ',' as empnames,
                        length(empnames) ori_len,
                        length(replace(empnames, ',', '')) new_len
                    from ex7_2
                    where department_id = 90
                )
            connect by level <= ori_len - new_len + 1
        );
        
-- with절

select b2.*
from ( select period, region, sum(loan_jan_amt) jan_amt
        from kor_loan_status
        group by period, region
        ) b2,
        ( select b.period, max(b.jan_amt) max_jan_amt
            from ( select period, region, sum(loan_jan_amt) jan_amt
                    from kor_loan_status
                    group by period, region
                    ) b, 
                    ( select max(period) max_month
                        from kor_loan_status
                        group by substr(period, 1, 4)
                    ) a
            where b.period = a.max_month
            group by b.period
        ) c
    where b2.period = c.period
        and b2.jan_amt = c.max_jan_amt
    order by 1;
    
with b2 as (select period, region, sum(loan_jan_amt) jan_amt
            from kor_loan_status
            group by period, region
            ),
    c as (select b.period, max(b.jan_amt) max_jan_amt
            from ( select period, region, sum(loan_jan_amt) jan_amt
                    from kor_loan_status
                    group by period, region
                    ) b,
                    (select max(period) max_month
                        from kor_loan_status
                        group by substr(period, 1, 4)
                    ) a
            where b.period = a.max_month
            group by b.period
            )
    select b2.*
        from b2, c
        where b2.period = c.period
        and b2.jan_amt = c.max_jan_amt
        order by 1;
        
with b2 as (select period, region, sum(loan_jan_amt) jan_amt
            from kor_loan_status
            group by period, region
            ),
    c as (select b2.period, max(b2.jan_amt) max_jan_amt
            from b2,
                (select max(period) max_month
                    from kor_loan_status
                    group by substr(period, 1, 4)
                ) a
            where b2.period = a.max_month
            group by b2.period
            )
    select b2.*
        from b2, c
        where b2.period = c.period
        and b2.jan_amt = c.max_jan_amt
        order by 1;
        
-- 순환 서브쿼리
select department_id, lpad(' ', 3 * (level-1)) || department_name, level
    from departments
    start with parent_id is null
    connect by prior department_id = parent_id;
    
with recur( department_id, parent_id, department_name, lvl)
        as ( select department_id, parent_id, department_name, 1 as lvl
                from departments
                where parent_id is null     -- start with parent_id is null과 같음
                union all
                select a.department_id, a.parent_id, a.department_name, b.lvl + 1
                    from departments a, recur b
                    where a.parent_id = b.department_id 
                            -- connect by prior department_id = parent_id와 같음
            )
    select department_id, lpad(' ', 3 * (lvl-1)) || department_name, lvl
        from recur;
        
with recur ( department_id, parent_id, department_name, lvl)
        as ( select department_id, parent_id, department_name, 1 as lvl
                from departments
                where parent_id is null
                union all
                select a.department_id, a.parent_id, a.department_name, b.lvl + 1
                    from departments a, recur b
                    where a.parent_id = b.department_id
            )
    search depth first by department_id set order_seq
--    search breadth first by department_id set order_seq   -- 레벨 순서대로 조회
    select department_id, lpad(' ', 3 * (lvl-1)) || department_name, lvl, order_seq
        from recur;
        
-- 분석함수

select department_id, emp_name,
    row_number() over (partition by department_id
                        order by department_id, emp_name) dep_rows
    from employees;
    
select department_id, emp_name, 
    salary, 
    rank() over (partition by department_id
                order by salary) dep_rank
    from employees;
    
select department_id, emp_name, 
    salary, 
    dense_rank() over (partition by department_id   -- 순위 건너뛰지 않고
                order by salary) dep_rank
    from employees;
    
select *
    from ( select department_id, emp_name,
                salary, 
                dense_rank() over (partition by department_id
                                    order by salary desc) dep_rank
            from employees
            )
    where dep_rank <= 3;
    
select department_id, emp_name, salary, 
        cume_dist() over (partition by department_id
                            order by salary) dep_dist
    from employees;
    
select department_id, emp_name, salary,
        rank() over (partition by department_id
                        order by salary) raking
        , cume_dist() over (partition by department_id
                            order by salary) cume_dist_value
        , percent_rank() over (partition by department_id
                                order by salary) percentile
    from employees
    where department_id = 30;
    
select department_id, emp_name, salary
        , ntile(4) over (partition by department_id
                            order by salary
                        ) ntiles
    from employees
    where department_id in (30, 60);
    
select emp_name, hire_date, salary,
        lag(salary, 1, 0) over (order by hire_date) as prev_sal,
        lead(salary, 1, 0) over (order by hire_date) as next_sal
    from employees
    where department_id = 30;
    
select emp_name, hire_date, salary,
        lag(salary, 2, 0) over (order by hire_date) as prev_sal,
        lead(salary, 2, 0) over (order by hire_date) as next_sal
    from employees
    where department_id = 30;
    
-- window절

select department_id, emp_name, hire_date, salary,
        sum(salary) over (partition by department_id order by hire_date
                            rows between unbounded preceding and unbounded following
                            ) as all_salary,
        sum(salary) over (partition by department_id order by hire_date
                            rows between unbounded preceding and current row
                            ) as first_current_sal,
        sum(salary) over (partition by department_id order by hire_date
                            rows between current row and unbounded following
                            ) as current_end_sal
    from employees
    where department_id in (30, 90);
    
select department_id, emp_name, hire_date, salary,
        sum(salary) over (partition by department_id order by hire_date
                            range between unbounded preceding and unbounded following
                            ) as all_salary,
        sum(salary) over (partition by department_id order by hire_date
                            range 365 preceding
                            ) as range_sal1,
        sum(salary) over (partition by department_id order by hire_date
                            range between 365 preceding and current row
                            ) as range_sal2
    from employees
    where department_id = 30;
    
-- window 함수
select department_id, emp_name, hire_date, salary,
        first_value(salary) over (partition by department_id order by hire_date
                                    rows between unbounded preceding and unbounded following
                                    ) as all_salary,
        first_value(salary) over (partition by department_id order by hire_date
                                    rows between unbounded preceding and current row
                                    ) as fr_st_to_current_sal,
        first_value(salary) over (partition by department_id order by hire_date
                                    rows between current row and unbounded following
                                    ) as fr_current_to_end_sal
    from employees
    where department_id in (30, 90);

select department_id, emp_name, hire_date, salary,
        last_value(salary) over (partition by department_id order by hire_date
                                    rows between unbounded preceding and unbounded following
                                    ) as all_salary,
        last_value(salary) over (partition by department_id order by hire_date
                                    rows between unbounded preceding and current row
                                    ) as fr_st_to_current_sal,
        last_value(salary) over (partition by department_id order by hire_date
                                    rows between current row and unbounded following
                                    ) as fr_current_to_end_sal
    from employees
    where department_id in (30, 90);
    
select department_id, emp_name, hire_date, salary,
        nth_value(salary, 2) over (partition by department_id order by hire_date
                                rows between unbounded preceding and unbounded following
                                ) as all_salary,
        nth_value(salary, 2) over (partition by department_id order by hire_date
                                rows between unbounded preceding and current row
                                ) as fr_st_to_current_sal,
        nth_value(salary, 2) over (partition by department_id order by hire_date
                                rows between current row and unbounded following
                                ) as fr_current_to_end_sal
    from employees
    where department_id in (30, 90);
    
-- 기타함수
select department_id, emp_name, salary
        ,ntile(4) over (partition by department_id
                            order by salary
                        ) ntiles
        , width_bucket(salary, 1000, 10000, 4) widthbuacket -- 1000부터 10000까지 4구간으로 나누기
                                                    -- ntile은 파티션에 속한 로우의 수를 기준으로, 
                                                    -- width_bucket은 매개변수에 따라 나뉨
    from employees
    where department_id = 60;
    
with basis as ( select period, region, sum(loan_jan_amt) jan_amt
                    from kor_loan_status
                    group by period, region
                ),
    basis2 as ( select period, min(jan_amt) min_amt, max(jan_amt) max_amt
                    from basis
                    group by period
                )
    select a.period,
            b.region "최소지역", b.jan_amt "최소금액",
            c.region "최대지역", c.jan_amt "최대금액"
        from basis2 a, basis b, basis c
    where a.period = b.period
        and a.min_amt = b.jan_amt
        and a.period = c.period
        and a.max_amt = c.jan_amt
    order by 1, 2;
    
select department_id, emp_name, hire_date, salary, 
        round(ratio_to_report(salary) over (partition by department_id)
            , 2) * 100 as salary_percent
    from employees
    where department_id in (30, 90);
    
-- 다중 테이블 insert
create table ex7_3 (
            emp_id number,
            emp_name varchar2(100));

create table ex7_4 (
            emp_id number,
            emp_name varchar2(100));
            
insert into ex7_3 values (101, '홍길동');
insert into ex7_3 values (102, '김유신');

insert all 
    into ex7_3 values (103, '강감찬')
    into ex7_3 values (104, '연개소문')
select *
    from dual;
    
insert all
    into ex7_3 values (emp_id, emp_name)
select 103 emp_id, '강감찬' emp_name
    from dual
    union all
    select 104 emp_id, '연개소문' emp_name
        from dual;
        
insert all
    into ex7_3 values (105, '가가가')
    into ex7_4 values (105, '나나나')
select *
    from dual;

select *
    from ex7_3
    union all
    select * 
        from ex7_4;
        
truncate table ex7_3;
truncate table ex7_4;
truncate table ex7_5;

insert all
    when department_id = 30 then
        into ex7_3 values (employee_id, emp_name)
    when department_id = 90 then
        into ex7_4 values (employee_id, emp_name)
    select department_id, employee_id, emp_name
        from employees;
        
select emp_id, emp_name from ex7_3
    union 
    select emp_id, emp_name from ex7_4
    order by EMP_ID;
    
select a.emp_id, a.emp_name, b.department_id
    from ex7_3 a, employees b
    where a.emp_id = b.employee_id;
    
select a.emp_id, a.emp_name, b.department_id
    from ex7_4 a, employees b
    where a.emp_id = b.employee_id;
    
select a.emp_id, a.emp_name, b.department_id
    from ex7_3 a, employees b
    where a.emp_id = b.employee_id
    union all
select a.emp_id, a.emp_name, b.department_id
    from ex7_4 a, employees b
    where a.emp_id = b.employee_id
    order by emp_id;
    
select *
    from (select a.emp_id, a.emp_name, b.department_id
            from ex7_3 a, employees b
            where a.emp_id = b.employee_id), 
        (select c.emp_id, c.emp_name, b.department_id
            from ex7_4 c, employees b
            where c.emp_id = b.employee_id);

select a.emp_id, a.emp_name, b.department_id        -- 요거
    from ( select emp_id, emp_name from ex7_3
            union 
            select emp_id, emp_name from ex7_4
            order by EMP_ID ) a,
            employees b
    where a.emp_id = b.employee_id;


select a.emp_id, a.emp_name, b.emp_id, b.emp_name, c.department_id
    from ex7_3 a, ex7_4 b, employees c
    where a.emp_id = c.employee_id
        or b.emp_id = c.employee_id;    

select a.emp_id, a.emp_name, b.department_id
    from ex7_3 a, employees b
    where a.emp_id = b.employee_id
    union
        select c.emp_id, c.emp_name, b.department_id
            from ex7_3 c, employees b
            where c.emp_id = b.employee_id;   

select * from employees;

create table ex7_5 (
    emp_id number,
    emp_name varchar2(100));
    
insert all
    when department_id = 30 then
        into ex7_3 values (employee_id, emp_name)
    when department_id = 90 then
        into ex7_4 values (employee_id, emp_name)
    else
        into ex7_5 values (employee_id, emp_name)
select department_id, 
        employee_id, emp_name
    from employees;
    
select count(*)
    from ex7_5;
    
select department_id, employee_id, emp_name, salary
    from employees
    where department_id = 30;
    
insert all
    when employee_id < 116 then
        into ex7_3 values (employee_id, emp_name)
    when salary < 5000 then
        into ex7_4 values (employee_id, emp_name)
    select department_id, employee_id, emp_name, salary
        from employees
        where department_id = 30;
        
select * from ex7_3
union all
select * from ex7_4;

rollback;

insert first
    when employee_id < 116 then
        into ex7_3 values (employee_id, emp_name)
    when salary < 5000 then
        into ex7_4 values (employee_id, emp_name)
    select department_id, employee_id, emp_name, salary
        from employees
        where department_id = 30;