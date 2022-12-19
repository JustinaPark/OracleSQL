-- 6장 테이블 사이를 연결해주는 조인과 서브 쿼리 알아보기

select a.employee_id, a.emp_name, a.department_id, b.department_name
    from employees a, 
        departments b
    where a.department_id = b.department_id;