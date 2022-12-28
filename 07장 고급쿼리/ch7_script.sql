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
    
