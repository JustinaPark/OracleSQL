-- 4�� SQL �Լ�

-- �����Լ�

-- abs : ���밪 ��ȯ
select abs(10), abs(-10), abs(-10.123)
    from dual;
    
-- ceil(n) �� floor(n) : n�� ���ų� ���� ū/���� ���� ��ȯ
select ceil(10.123), ceil(10.541), ceil(11.001)
    from dual;
    
select floor(10.123), floor(10.541), floor(11.001)
    from dual;
    
-- round(n,i)�� trunc(n1,n2)
select round(10.154), round(10.541), round(11.001)
    from dual;
    
select round(10.154, 1), round(10.154, 2), round(10.154, 3)
    from dual;
    
select round(0, 3), round(115.155, -1), round(115.155, -2)
    from dual;
    
select trunc(115.155), trunc(115.155, 1), trunc(115.155, 2), trunc(115.155, -2)
    from dual;
    
-- power(n2, n1)�� sqrt(n)
select power(3, 2), power(3, 3), power(3, 3.0001)
    from dual;
    
select power(-3, 3.0001)
    from dual;      -- (X) '-3' �μ��� ������ ������ϴ�. n2�� ������ �� n1�� ������ �� �� �ִ�.
    
select sqrt(2), sqrt(5) -- ������
    from dual;
    
-- mod(n2, n1)�� remainder(n2, n1)
select mod(19, 4), mod(19.123, 4.2)    -- ������ ��
    from dual;
    
select remainder(19, 4), mod(19.123, 4.2)
    from dual;
    
select exp(2), ln(2.713), log(10, 100)
    from dual;
    

-- �����Լ�

-- initcap(char), lower(char), upper(char)
select initcap('never say goodbye'), initcap('never6say*good��bye') -- ù ���� �빮�ڷ�
    from dual;
    
select lower('NEVER SAY GOODBYE'), upper('never say goodbye') -- ��� �ҹ��ڷ� / ��� �빮�ڷ�
    from dual;
    
-- concat(char1, char2), substr(char, pos, len), substrb(char, pos, len)
select concat('I have', 'a dream'), 'I have' || 'a dream'
    from dual;
    
select substr('ABCDEFG', 1, 4), substr('ABCDEFG', -1, 4)
    from dual;
    
select substrb('ABCDEFG', 1, 4), substrb('�����ٶ󸶹ٻ�', 1, 4)
    from dual;
    
-- ltrim(char, set), rtrim(char, set)
select ltrim('ABCDEFGABC', 'ABC'),
        ltrim('�����ٶ�', '��'),
        rtrim('ABCDEFGABC', 'ABC'),
        rtrim('�����ٶ�', '��')
    from dual;
    
select ltrim('�����ٶ�', '��'), rtrim('�����ٶ�', '��')
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
select replace('���� �ʸ� �𸣴µ� �ʴ� ���� �˰ڴ°�', '��', '��')
    from dual;
    
select ltrim(' ABC DEF '),
        rtrim(' ABC DEF '), 
        replace(' ABC DEF ', ' ', '')   -- ���ڿ� ��ü ���� ���� ����
    from dual;
    
select replace('���� �ʸ� �𸣴µ� �ʴ� ���� �˰ڴ°�?', '����', '�ʸ�') as rep,
        translate('���� �ʸ� �𸣴µ� �ʴ� ���� �˰ڴ°�?', '����', '�ʸ�') as trn
    from dual;
    
-- instr(str, substr, pos, occur), length(chr), lengthb(chr)
select instr('���� ���� �ܷο� ����, ���� ���� ���ο� ����, ���� ���� ��ſ� ����', '����') as instr1,
        instr('���� ���� �ܷο� ����, ���� ���� ���ο� ����, ���� ���� ��ſ� ����', '����', 5) as instr2,
        instr('���� ���� �ܷο� ����, ���� ���� ���ο� ����, ���� ���� ��ſ� ����', '����', 5, 2) as instr3
    from dual;
    
select length ('���ѹα�'),
        lengthb ('���ѹα�')
    from dual;
    
-- ��¥ �Լ�
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
select next_day(sysdate, '�ݿ���')
    from dual;
    
-- ��ȯ�Լ�
-- to_char(���� Ȥ�� ��¥, format)
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
    
-- null ���� �Լ�
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
    
-- lnnvl(���ǽ�)
select employee_id, commission_pct
    from employees
    where commission_pct < 0.2;
    
select count(*)
    from employees
    where nvl(commission_pct, 0) < 0.2; -- commission_pct�� null�� �� 0���� ǥ��
    
select count(*)
    from employees
    where lnnvl(commission_pct >= 0.2);
    
-- nullif(expr1, expr2)
select employee_id,
        to_char(start_date, 'YYYY') start_year,
        to_char(end_date, 'YYYY') end_year,
        nullif(to_char(end_date, 'YYYY'), to_char(start_date, 'YYYY')) nullif_year
    from job_history;
    
    
-- ��Ÿ�Լ�
-- greatest(expr1, expr2, ...), least(expr1, expr2, ...)
select greatest(1, 2, 3, 2), 
        least(1, 2, 3, 2)
    from dual;
    
select greatest('�̼���', '������', '�������'),
        least('�̼���', '������', '�������')
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