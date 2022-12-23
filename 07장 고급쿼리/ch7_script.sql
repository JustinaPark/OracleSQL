-- 7�� ��� ���� �ٷ��

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

-- ������ ����
select department_id, lpad(' ', 3 * (level-1)) || department_name, level
    from departments
    start with parent_id is null
    connect by prior department_id = parent_id;
    
--start with ���� : ������ �������� �ֻ��� ������ �ο츦 �ĺ��ϴ� ������ ���. �� ���ǿ� �´� �ο���� ������ ������ ������ Ǯ�� ������.
--connect by ���� : ������ ������ � ������ ����Ǵ��� ����ϴ� �κ�. 
    
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
        and a.department_id = 30            -- �ֻ��� �ο� ���ܵ�.
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
        
--������ ������ ������ ó�� ����
--1. ������ ������ ������ ���� ó��
--2. start with ���� ������ �ֻ��� ���� �ο� ����
--3. connect by ���� ��õ� ������ ���� ������ ����(�θ�-�ڽ� ����)�� �ľ��� �ڽ� �ο츦 ���ʷ� ����.
--    �ֻ��� �ο츦 �������� �ڽ� �ο츦 �����ϰ�, �� �ڽ� �ο쿡 ���� �� �ٸ� �ڽ� �ο찡 ������ �����ϴ� ��.
--4. �ڽ� �ο� ã�Ⱑ ������ ������ ������ where ���ǿ� �ش��ϴ� �ο츦 �ɷ����µ�, �ο캰�� ���ǿ� ���� ���� ���� �ɷ���.

select department_id, lpad(' ', 3 * (level-1)) || department_name, level
    from departments
    start with parent_id is null
    connect by prior department_id = parent_id
    order by department_name;   -- ������ ���� ����. order siblings by �� ����ؾ�.
    
select department_id, lpad(' ', 3 * (level-1)) || department_name, level
    from departments
    start with parent_id is null
    connect by prior department_id = parent_id
    order siblings by department_name;

select department_id, lpad(' ', 3 * (level-1)) || department_name, level,
        CONNECT_BY_ROOT department_name as root_name    -- connect_by_root : �ֻ��� �ο� ��ȯ ������, �������� ǥ������ ��
    from departments
    start with parent_id is null
    connect by prior department_id = parent_id;
    
select department_id, lpad(' ', 3 * (level-1)) || department_name, level,
        CONNECT_BY_ISLEAF
    from departments
    start with parent_id is null
    connect by prior department_id = parent_id;