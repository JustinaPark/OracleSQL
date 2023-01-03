-- 4장 SQL 함수

-- 숫자함수

-- abs : 절대값 반환
select abs(10), abs(-10), abs(-10.123)
    from dual;
    
-- ceil(n) 과 floor(n) : n과 같거나 가장 큰/작은 정수 반환
select ceil(10.123), ceil(10.541), ceil(11.001)
    from dual;
    
select floor(10.123), floor(10.541), floor(11.001)
    from dual;
    
-- round(n,i)와 trunc(n1,n2)
select round(10.154), round(10.541), round(11.001)
    from dual;
    
select round(10.154, 1), round(10.154, 2), round(10.154, 3)
    from dual;
    
select round(0, 3), round(115.155, -1), round(115.155, -2)
    from dual;
    
select trunc(115.155), trunc(115.155, 1), trunc(115.155, 2), trunc(115.155, -2)
    from dual;
    
-- power(n2, n1)와 sqrt(n)
select power(3, 2), power(3, 3), power(3, 3.0001)
    from dual;
    
select power(-3, 3.0001)
    from dual;      -- (X) '-3' 인수가 범위를 벗어났습니다. n2가 음수일 때 n1은 정수만 올 수 있다.
    
select sqrt(2), sqrt(5) -- 제곱근
    from dual;
    
-- mod(n2, n1)와 remainder(n2, n1)
select mod(19, 4), mod(19.123, 4.2)    -- 나머지 값
    from dual;
    
select remainder(19, 4), mod(19.123, 4.2)
    from dual;
    
select exp(2), ln(2.713), log(10, 100)
    from dual;
    
