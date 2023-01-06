-- 5�� �׷����� ���տ�����

-- �⺻ ���� �Լ�
-- count(expr)
select count(*)
    from employees;
    
select count(employee_id)
    from employees;
    
select count(department_id) -- null�� �ƴ� �ǿ� ���ؼ��� ��ȯ
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
select min(salary), max(salary) -- distinct �ʿ�X
    from employees;
    
-- vriance(expr), stddev(expr)
select variance(salary), stddev(salary)
    from employees;
    
-- group by���� having��
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
    group by region     -- (X) select ����Ʈ�� �ִ� �÷����̳� ǥ���� �� �����Լ� �����ϰ�� ��� �������� ��.
    order by region;
    
select period, region, sum(loan_jan_amt) totl_jan
    from kor_loan_status
    where period = '201311'
    group by period, region
    having sum(loan_jan_amt) > 100000
    order by region;
    
-- rollup���� cube��
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
    
-- ���տ�����
-- union 
select goods
    from exp_goods_asia
    where country = '�ѱ�'
    order by seq;
    
select goods
    from exp_goods_asia
    where country = '�Ϻ�'
    order by seq;
    
select goods
    from exp_goods_asia
    where country = '�ѱ�'
    union
    select goods
        from exp_goods_asia
        where country = '�Ϻ�';
        
-- union all
select goods
    from exp_goods_asia
    where country = '�ѱ�'
    union all
    select goods
        from exp_goods_asia
        where country = '�Ϻ�';
        
-- intersect
select goods
    from exp_goods_asia
    where country = '�ѱ�'
    intersect
    select goods
        from exp_goods_asia
        where country = '�Ϻ�';
        
-- minus
select goods
    from exp_goods_asia
    where country = '�ѱ�'
    minus
    select goods
        from exp_goods_asia
        where country = '�Ϻ�';       -- �ѱ����� ������ �Ϻ����� ���� �� ���, ���� �߿�
        
-- ���� ������ ���ѻ���
select goods
    from exp_goods_asia
    where country = '�ѱ�'
    union
    select seq, goods
        from exp_goods_asia
        where country = '�Ϻ�';   -- (X) ����Ʈ ������ ������ Ÿ�� ��ġ�ؾ�
        
select seq, goods
    from exp_goods_asia
    where country = '�ѱ�'
    union
    select seq, goods
        from exp_goods_asia
        where country = '�Ϻ�';
        
select seq, goods
    from exp_goods_asia
    where country = '�ѱ�'
    INTERSECT
    select seq, goods
        from exp_goods_asia
        where country = '�Ϻ�';
        
select seq
    from exp_goods_asia
    where country = '�ѱ�'
    union
    select goods            -- (X) ������ Ÿ�� ���ƾ�
        from exp_goods_asia
        where country = '�Ϻ�';
        
select goods
    from exp_goods_asia
    where country = '�ѱ�'
    order by goods      -- (X) order by���� �� ������ ���忡���� ���
    union
    select goods
        from exp_goods_asia
        where country = '�Ϻ�';
        
select goods
    from exp_goods_asia
    where country = '�ѱ�'
    union
    select goods
        from exp_goods_asia
        where country = '�Ϻ�'
        order by goods;
        
-- grouping sets��
select period, gubun, sum(loan_jan_amt) totl_jan
    from kor_loan_status
    where period like '2013%'
    group by grouping sets(period, gubun);
    
select period, gubun, region, sum(loan_jan_amt) totl_jan
    from kor_loan_status
    where period like '2013%'
        and region in ('����', '���')
    group by grouping sets(period, (gubun, region));