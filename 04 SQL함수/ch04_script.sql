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
    

-- 문자함수

-- initcap(char), lower(char), upper(char)
select initcap('never say goodbye'), initcap('never6say*good가bye') -- 첫 문자 대문자로
    from dual;
    
select lower('NEVER SAY GOODBYE'), upper('never say goodbye') -- 모두 소문자로 / 모두 대문자로
    from dual;
    
-- concat(char1, char2), substr(char, pos, len), substrb(char, pos, len)
select concat('I have', 'a dream'), 'I have' || 'a dream'
    from dual;
    
select substr('ABCDEFG', 1, 4), substr('ABCDEFG', -1, 4)
    from dual;
    
select substrb('ABCDEFG', 1, 4), substrb('가나다라마바사', 1, 4)
    from dual;
    
-- ltrim(char, set), rtrim(char, set)
select ltrim('ABCDEFGABC', 'ABC'),
        ltrim('가나다라', '가'),
        rtrim('ABCDEFGABC', 'ABC'),
        rtrim('가나다라', '라')
    from dual;
    
select ltrim('가나다라', '나'), rtrim('가나다라', '나')
    from dual;
    
-- lpad(expr1, n, expr2), rpad(expr1, n, expr2)
create table ex4_1 (
        phone_num varchar2(30)
        );
        
insert into ex4_1 values ('111-1111');
insert into ex4_1 values ('111-2222');
insert into ex4_1 values ('111-3333');

select *
    from ex4_1;
    
select lpad(phone_num, 12, '(02)')
    from ex4_1;
    
select rpad(phone_num, 12, '(02)')
    from ex4_1;
    
-- replace(char, search_str, replace_str), translate(expr, from_str, to_str)
select replace('나는 너를 모르는데 너는 나를 알겠는가', '나', '너')
    from dual;
    
select ltrim(' ABC DEF '),
        rtrim(' ABC DEF '), 
        replace(' ABC DEF ', ' ', '')   -- 문자열 전체 공백 제거 가능
    from dual;
    
select replace('나는 너를 모르는데 너는 나를 알겠는가?', '나는', '너를') as rep,
        translate('나는 너를 모르는데 너는 나를 알겠는가?', '나는', '너를') as trn
    from dual;
    
-- instr(str, substr, pos, occur), length(chr), lengthb(chr)
select instr('내가 만약 외로울 때면, 내가 만약 괴로울 때면, 내가 만약 즐거울 때면', '만약') as instr1,
        instr('내가 만약 외로울 때면, 내가 만약 괴로울 때면, 내가 만약 즐거울 때면', '만약', 5) as instr2,
        instr('내가 만약 외로울 때면, 내가 만약 괴로울 때면, 내가 만약 즐거울 때면', '만약', 5, 2) as instr3
    from dual;
    
select length ('대한민국'),
        lengthb ('대한민국')
    from dual;
    
-- 날짜 함수
-- sysdate, systimestamp
select sysdate, systimestamp
    from dual;
    
-- add_months(date, integer)
select add_months(sysdate, 1), add_months(sysdate, -1)
    from dual;
    
-- months_between(date1, date2)
select months_between(sysdate, add_months(sysdate, 1)) mon1,
        months_between(add_months(sysdate, 1), sysdate) mon2
    from dual;
    
-- last_day(date)
select last_day(sysdate)
    from dual;
    
-- round(date, format), trunc(date, format)
select sysdate, round(sysdate, 'month'), trunc(sysdate, 'month')
    from dual;
    
-- next_day(date, char)
select next_day(sysdate, '금요일')
    from dual;
    
-- 변환함수
-- to_char(숫자 혹은 날짜, format)
select to_char(123456789, '999,999,999')
    from dual;

select to_char(sysdate, 'yyyy-mm-dd')
    from dual;
    
-- to_number(expr, format)
select to_number('123456')
    from dual;
    
-- to_date(char, format), to_timestamp(char, format)
select to_date('20140101', 'yyyy-mm-dd')
    from dual;
    
select to_timestamp('20140101 13:44:50', 'YYYY-MM-DD HH24:MI:SS')
    from dual;
    
-- null 관련 함수
-- nvl(expr1, expr2), nvl2(expr1, expr2, expr3)
select nvl(manager_id, employee_id)
    from employees
    where manager_id is null;
    
select employee_id, 
        nvl2(commission_pct, salary + (salary * commission_pct), salary) as salary2
    from employees;
    
-- coalesce(expr1, expr2, ..)
select employee_id, salary, commission_pct,
        coalesce ( salary * commission_pct, salary) as salary2
    from employees;
    
-- lnnvl(조건식)
select employee_id, commission_pct
    from employees
    where commission_pct < 0.2;
    
select count(*)
    from employees
    where nvl(commission_pct, 0) < 0.2; -- commission_pct가 null일 때 0으로 표시
    
select count(*)
    from employees
    where lnnvl(commission_pct >= 0.2);
    
-- nullif(expr1, expr2)
select employee_id,
        to_char(start_date, 'YYYY') start_year,
        to_char(end_date, 'YYYY') end_year,
        nullif(to_char(end_date, 'YYYY'), to_char(start_date, 'YYYY')) nullif_year
    from job_history;
    
    
-- 기타함수
-- greatest(expr1, expr2, ...), least(expr1, expr2, ...)
select greatest(1, 2, 3, 2), 
        least(1, 2, 3, 2)
    from dual;
    
select greatest('이순신', '강감찬', '세종대왕'),
        least('이순신', '강감찬', '세종대왕')
    from dual;
    
-- decode(expr, search1, result1, search2, result2, ..., default)
select prod_id,
        decode(channel_id, 3, 'direct',
                            9, 'direct', 
                            5, 'indirect', 
                            4, 'indirect',
                                'oters') decodes
    from sales
    where rownum < 10;