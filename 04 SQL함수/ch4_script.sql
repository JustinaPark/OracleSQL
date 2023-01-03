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
    
