-- 5장 그룹쿼리 집합연산자

-- 기본 집계 함수
-- count(expr)
select count(*)
    from employees;
    
select count(employee_id)
    from employees;
    
select count(department_id) -- null이 아닌 건에 대해서만 반환
    from employees;
    
select count(distinct department_id)
    from employees;
    
select distinct department_id
    from employees
    order by 1;
    
-- sum(expr)
select sum(salary)
    from employees;
    
select sum(salary), sum(distinct salary)
    from employees;
    
-- avg(expr)
select avg(salary), avg(distinct salary)
    from employees;
    
-- min(expr), max(expr)
select min(salary), max(salary) -- distinct 필요X
    from employees;
    
-- vriance(expr), stddev(expr)
select variance(salary), stddev(salary)
    from employees;
    
-- group by절과 having절
select department_id, sum(salary)
    from employees
    group by department_id
    order by department_id;
    
select *
    from kor_loan_status;
    
select period, region, sum(loan_jan_amt) totl_jan
    from kor_loan_status
    where period like '2013%'
    group by period, region
    order by period, region;
    
select period, region, sum(loan_jan_amt) totl_jan
    from kor_loan_status
    where period = '201311'
    group by region     -- (X) select 리스트에 있는 컬럼명이나 표현식 중 집계함수 제외하고는 모두 명시해줘야 함.
    order by region;
    
select period, region, sum(loan_jan_amt) totl_jan
    from kor_loan_status
    where period = '201311'
    group by period, region
    having sum(loan_jan_amt) > 100000
    order by region;
    
-- rollup절과 cube절
-- rollup(expr1, expr2, ...) 
select period, gubun, sum(loan_jan_amt) totl_jan
    from kor_loan_status
    where period like '2013%'
    group by period, gubun
    order by period;
    
select period, gubun, sum(loan_jan_amt) totl_jan
    from kor_loan_status
    where period like '2013%'
    group by rollup(period, gubun);
    
select period, gubun, sum(loan_jan_amt) totl_jan
    from kor_loan_status
    where period like '2013%'
    group by period, rollup(gubun);
    
select period, gubun, sum(loan_jan_amt) totl_jan
    from kor_loan_status
    where period like '2013%'
    group by rollup(period), gubun;
    
-- cube(expr1, expr2, ...)
select period, gubun, sum(loan_jan_amt) totl_jan
    from kor_loan_status
    where period like '2013%'
    group by cube(period, gubun);
    
select period, gubun, sum(loan_jan_amt) totl_jan
    from kor_loan_status
    where period like '2013%'
    group by period, cube(gubun);
    
-- 집합연산자
-- union 
select goods
    from exp_goods_asia
    where country = '한국'
    order by seq;
    
select goods
    from exp_goods_asia
    where country = '일본'
    order by seq;
    
select goods
    from exp_goods_asia
    where country = '한국'
    union
    select goods
        from exp_goods_asia
        where country = '일본';
        
-- union all
select goods
    from exp_goods_asia
    where country = '한국'
    union all
    select goods
        from exp_goods_asia
        where country = '일본';
        
-- intersect
select goods
    from exp_goods_asia
    where country = '한국'
    intersect
    select goods
        from exp_goods_asia
        where country = '일본';
        
-- minus
select goods
    from exp_goods_asia
    where country = '한국'
    minus
    select goods
        from exp_goods_asia
        where country = '일본';       -- 한국에는 있지만 일본에는 없는 것 출력, 순서 중요
        
-- 집합 연산자 제한사항
select goods
    from exp_goods_asia
    where country = '한국'
    union
    select seq, goods
        from exp_goods_asia
        where country = '일본';   -- (X) 리스트 개수와 데이터 타입 일치해야
        
select seq, goods
    from exp_goods_asia
    where country = '한국'
    union
    select seq, goods
        from exp_goods_asia
        where country = '일본';
        
select seq, goods
    from exp_goods_asia
    where country = '한국'
    INTERSECT
    select seq, goods
        from exp_goods_asia
        where country = '일본';
        
select seq
    from exp_goods_asia
    where country = '한국'
    union
    select goods            -- (X) 데이터 타입 같아야
        from exp_goods_asia
        where country = '일본';
        
select goods
    from exp_goods_asia
    where country = '한국'
    order by goods      -- (X) order by절은 맨 마지막 문장에서만 사용
    union
    select goods
        from exp_goods_asia
        where country = '일본';
        
select goods
    from exp_goods_asia
    where country = '한국'
    union
    select goods
        from exp_goods_asia
        where country = '일본'
        order by goods;
        
-- grouping sets절
select period, gubun, sum(loan_jan_amt) totl_jan
    from kor_loan_status
    where period like '2013%'
    group by grouping sets(period, gubun);
    
select period, gubun, region, sum(loan_jan_amt) totl_jan
    from kor_loan_status
    where period like '2013%'
        and region in ('서울', '경기')
    group by grouping sets(period, (gubun, region));