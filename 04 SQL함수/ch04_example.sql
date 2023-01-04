-- self check

-- 1. 사원 테이블(employees)에는 phone_number라는 컬럼에 사원의 전화번호가 '###.###.####' 형태로 저장되어 있다.
--  여기서 처음 세 자리 숫자 대신 서울 지역 번호인 '(02)'를 붙여 전화번호를 출력하도록 쿼리를 작성해보자.
select lpad(substr(phone_number, 5), 12, '(02)')
    from employees;
    
-- 2. 현재일자를 기준으로 사원 테이블의 입사일자(hire_date)를 참조해서 근속년수가 10년 이상인 사원을 다음과 같은
--  형태의 결과를 출력하도록 쿼리를 작성해 보자 (근속년수가 높은 사원 순서대로 결과가 나오도록 하자.)
select * from employees;

select employee_id, emp_name, hire_date, 
    round((sysdate - hire_date) / 365) as service_year
from employees
where round((sysdate - hire_date) / 365) >= 10
order by service_year desc;

-- 3. 고객 테이블(customers)에는 고객 전화번호(cust_main_phone_number)컬럼이 있다.
--  이 컬럼 값은 '###-###-####' 형태인데, '-' 대신 '/'로 바꿔 출력하는 쿼리를 작성해 보자.
select * from customers;

select cust_name, replace(cust_main_phone_number, '-', '/') new_phone_number
    from customers;
    
-- 4. 고객 테이블(customers)의 고객 전화번호(cust_main_phone_number)컬럼을 다른 문자로
--  대체(일종의 암호화)하도록 쿼리를 작성해보자.
select cust_name, translate(cust_main_phone_number, '1234567890', 'dkseoglqkh') enc_phone_number
    from customers;
    
-- 5. 고객 테이블(customers)에는 고객의 출생년도(cust_year_of_birth)컬럼이 있다.
--  현재일자 기준으로 이 컬럼을 활용해 30대, 40대, 50대를 구분해 출력하고, 나머지 연령대는
--  '기타'로 출력하는 쿼리를 작성해 보자.
select cust_name, cust_year_of_birth,
        decode( trunc(((to_char(sysdate, 'YYYY')) - cust_year_of_birth), -1) , 30, '30대',
                                                                                40, '40대',
                                                                                50, '50대',
                                                                                '기타') generation
    from customers;
    
-- 6. 5번 문제는 30~50대까지만 표시했다. 모든 연령대를 표시하도록 쿼리를 작성하는데, 이번에는 DECODE 대신
--  CASE 표현식을 사용해보자.
select cust_name, cust_year_of_birth,
    case when trunc(((to_char(sysdate, 'YYYY')) - cust_year_of_birth), -1) = 10 then '10대'
            when trunc(((to_char(sysdate, 'YYYY')) - cust_year_of_birth), -1) = 20 then '20대'
            when trunc(((to_char(sysdate, 'YYYY')) - cust_year_of_birth), -1) = 30 then '30대'
            when trunc(((to_char(sysdate, 'YYYY')) - cust_year_of_birth), -1) = 40 then '40대'
            when trunc(((to_char(sysdate, 'YYYY')) - cust_year_of_birth), -1) = 50 then '50대'
            when trunc(((to_char(sysdate, 'YYYY')) - cust_year_of_birth), -1) = 60 then '60대'
            when trunc(((to_char(sysdate, 'YYYY')) - cust_year_of_birth), -1) = 70 then '70대'
        else '기타' end as new_generation
    from customers;