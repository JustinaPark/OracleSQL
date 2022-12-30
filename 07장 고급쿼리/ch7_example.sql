-- self check

-- 1. ������ ���� �������� LISTAGG �Լ��� ����� ������ ���� �ο츦 �÷����� �и��ߴ�.
select department_id, 
        listagg(emp_name, ',') within group (order by emp_name) as empnames
    from employees
    where department_id is not null
    group by department_id;
-- listagg �Լ� ��� ������ ����, �м��Լ��� ����ؼ� �� ������ ������ ����� �����ϴ� ������ �ۼ��غ���.
select department_id,
    SUBSTR(SYS_CONNECT_BY_PATH(emp_name, ','),2) empnames
 from (select emp_name, 
            department_id,
            count(*) over (partition by department_id) cnt,
            ROW_NUMBER () OVER ( partition BY department_id order BY emp_name) rowseq 
          FROM employees
          WHERE department_id IS NOT NULL)
 WHERE rowseq = cnt
 START WITH rowseq = 1 
CONNECT BY PRIOR rowseq + 1 = rowseq 
    AND PRIOR department_id = department_id; 
    
-- 2. 