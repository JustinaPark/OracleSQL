-- self check

-- 1. ��� ���̺�(employees)���� phone_number��� �÷��� ����� ��ȭ��ȣ�� '###.###.####' ���·� ����Ǿ� �ִ�.
--  ���⼭ ó�� �� �ڸ� ���� ��� ���� ���� ��ȣ�� '(02)'�� �ٿ� ��ȭ��ȣ�� ����ϵ��� ������ �ۼ��غ���.
select lpad(substr(phone_number, 5), 12, '(02)')
    from employees;
    
-- 2. �������ڸ� �������� ��� ���̺��� �Ի�����(hire_date)�� �����ؼ� �ټӳ���� 10�� �̻��� ����� ������ ����
--  ������ ����� ����ϵ��� ������ �ۼ��� ���� (�ټӳ���� ���� ��� ������� ����� �������� ����.)
select * from employees;

select employee_id, emp_name, hire_date, 
    round((sysdate - hire_date) / 365) as service_year
from employees
where round((sysdate - hire_date) / 365) >= 10
order by service_year desc;

-- 3. �� ���̺�(customers)���� �� ��ȭ��ȣ(cust_main_phone_number)�÷��� �ִ�.
--  �� �÷� ���� '###-###-####' �����ε�, '-' ��� '/'�� �ٲ� ����ϴ� ������ �ۼ��� ����.
select * from customers;

select cust_name, replace(cust_main_phone_number, '-', '/') new_phone_number
    from customers;
    
-- 4. �� ���̺�(customers)�� �� ��ȭ��ȣ(cust_main_phone_number)�÷��� �ٸ� ���ڷ�
--  ��ü(������ ��ȣȭ)�ϵ��� ������ �ۼ��غ���.
select cust_name, translate(cust_main_phone_number, '1234567890', 'dkseoglqkh') enc_phone_number
    from customers;
    
-- 5. �� ���̺�(customers)���� ���� ����⵵(cust_year_of_birth)�÷��� �ִ�.
--  �������� �������� �� �÷��� Ȱ���� 30��, 40��, 50�븦 ������ ����ϰ�, ������ ���ɴ��
--  '��Ÿ'�� ����ϴ� ������ �ۼ��� ����.
select cust_name, cust_year_of_birth,
        decode( trunc(((to_char(sysdate, 'YYYY')) - cust_year_of_birth), -1) , 30, '30��',
                                                                                40, '40��',
                                                                                50, '50��',
                                                                                '��Ÿ') generation
    from customers;
    
-- 6. 5�� ������ 30~50������� ǥ���ߴ�. ��� ���ɴ븦 ǥ���ϵ��� ������ �ۼ��ϴµ�, �̹����� DECODE ���
--  CASE ǥ������ ����غ���.
select cust_name, cust_year_of_birth,
    case when trunc(((to_char(sysdate, 'YYYY')) - cust_year_of_birth), -1) = 10 then '10��'
            when trunc(((to_char(sysdate, 'YYYY')) - cust_year_of_birth), -1) = 20 then '20��'
            when trunc(((to_char(sysdate, 'YYYY')) - cust_year_of_birth), -1) = 30 then '30��'
            when trunc(((to_char(sysdate, 'YYYY')) - cust_year_of_birth), -1) = 40 then '40��'
            when trunc(((to_char(sysdate, 'YYYY')) - cust_year_of_birth), -1) = 50 then '50��'
            when trunc(((to_char(sysdate, 'YYYY')) - cust_year_of_birth), -1) = 60 then '60��'
            when trunc(((to_char(sysdate, 'YYYY')) - cust_year_of_birth), -1) = 70 then '70��'
        else '��Ÿ' end as new_generation
    from customers;