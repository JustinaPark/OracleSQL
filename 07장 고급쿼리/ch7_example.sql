-- self check

-- 1. 계층형 쿼리 응용편에서 LISTAGG 함수를 사용해 다음과 같이 로우를 컬럼으로 분리했다.
select department_id, 
        listagg(emp_name, ',') within group (order by emp_name) as empnames
    from employees
    where department_id is not null
    group by department_id;
-- listagg 함수 대신 계층형 쿼리, 분석함수를 사용해서 위 쿼리와 동일한 결과를 산출하는 쿼리를 작성해보자.
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