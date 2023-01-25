-- 09�� PLSQL����� �������α׷�

-- 01 PL/SQL ���
DECLARE
    vn_num1 NUMBER := 1;
    vn_num2 NUMBER := 2;
BEGIN
    IF vn_num1 >= vn_num2 THEN
        DBMS_OUTPUT.PUT_LINE(vn_num1 || '�� ū ��');
    ELSE
        DBMS_OUTPUT.PUT_LINE(vn_num2 || '�� ū ��');
    END IF;
END;

DECLARE
    vn_name employees.emp_name%TYPE;
    vn_salary NUMBER := 0;
    vn_department_id NUMBER := 0;
BEGIN 
    vn_department_id := ROUND(DBMS_RANDOM.VALUE (10, 120), -1);
    
    SELECT salary, emp_name
        INTO vn_salary, vn_name
        FROM employees
        WHERE department_id = vn_department_id
            AND ROWNUM = 1;
            
    DBMS_OUTPUT.PUT_LINE(vn_name);
    DBMS_OUTPUT.PUT_LINE(vn_salary);
    
    IF vn_salary BETWEEN 1 AND 3000 THEN
        DBMS_OUTPUT.PUT_LINE('����');
    ELSIF vn_salary BETWEEN 3001 AND 6000 THEN
        DBMS_OUTPUT.PUT_LINE('�߰�');
    ELSIF vn_salary BETWEEN 6001 AND 10000 THEN
        DBMS_OUTPUT.PUT_LINE('����');
    ELSE
        DBMS_OUTPUT.PUT_LINE('�ֻ���');
    END IF;
END;
    
DECLARE
    vn_salary NUMBER := 0;
    vn_department_id NUMBER := 0;
    vn_commission NUMBER := 0;
BEGIN
    vn_department_id := ROUND(DBMS_RANDOM.VALUE (10, 120), -1);
    
    SELECT salary, commission_pct
        INTO vn_salary, vn_commission
        FROM employees
        WHERE department_id = vn_department_id
            AND ROWNUM = 1;
            
    DBMS_OUTPUT.PUT_LINE(vn_salary);
    
    IF vn_commission > 0 THEN
        IF vn_commission > 0.15 THEN
            DBMS_OUTPUT.PUT_LINE(vn_salary * vn_commission);
        END IF;
    ELSE
        DBMS_OUTPUT.PUT_LINE(vn_salary);
    END IF;
END;

DECLARE
    vn_salary NUMBER := 0;
    vn_department_id NUMBER := 0;
BEGIN
    vn_department_id := ROUND(DBMS_RANDOM.VALUE (10, 120), -1);
    
    SELECT salary
        INTO vn_salary
        FROM employees
        WHERE department_id = vn_department_id
            AND ROWNUM = 1;
    
    DBMS_OUTPUT.PUT_LINE(vn_salary);
    
    CASE WHEN vn_salary BETWEEN 1 AND 3000 THEN
            DBMS_OUTPUT.PUT_LINE('����');
        WHEN vn_salary BETWEEN 3001 AND 6000 THEN
            DBMS_OUTPUT.PUT_LINE('�߰�');
        WHEN vn_salary BETWEEN 6001 AND 10000 THEN
            DBMS_OUTPUT.PUT_LINE('����');
        ELSE
            DBMS_OUTPUT.PUT_LINE('�ֻ���');
        END CASE;
END;

DECLARE
    vn_base_num NUMBER := 3;
    vn_cnt NUMBER := 1;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE (vn_base_num || '*' || vn_cnt || '= '
                                || vn_base_num * vn_cnt);
        vn_cnt := vn_cnt + 1;   -- ������ ���鼭 vn_cnt �� 1�� ����
        EXIT WHEN vn_cnt > 9;   -- vn_cnt�� 9���� ũ�� ���� ����
    END LOOP;
END;

DECLARE
    vn_base_num NUMBER := 3;
    vn_cnt NUMBER := 1;
BEGIN
    WHILE vn_cnt <= 9   -- vn_cnt�� 9���� �۰ų� ���� ���� �ݺ� ó��
    LOOP
        DBMS_OUTPUT.PUT_LINE (vn_base_num || '*' || vn_cnt || '= '
                                || vn_base_num * vn_cnt);
        vn_cnt := vn_cnt + 1;
    END LOOP;
END;

DECLARE
    vn_base_num NUMBER := 3;
    vn_cnt NUMBER := 1;
BEGIN
    WHILE vn_cnt <= 9   -- vn_cnt�� 9���� �۰ų� ���� ���� �ݺ� ó��
    LOOP
        DBMS_OUTPUT.PUT_LINE (vn_base_num || '*' || vn_cnt || '= '
                                || vn_base_num * vn_cnt);
        EXIT WHEN vn_cnt = 5;   -- vn_cnt ���� 5�� �Ǹ� ���� ����
        vn_cnt := vn_cnt + 1;
    END LOOP;
END;

DECLARE
    vn_base_num NUMBER := 3;
BEGIN
    FOR i IN 1..9
    LOOP
        DBMS_OUTPUT.PUT_LINE (vn_base_num || '*' || i || '= ' || vn_base_num * i);
    END LOOP;
END;

DECLARE
    vn_base_num NUMBER := 3;
BEGIN
    FOR i IN REVERSE 1..9
    LOOP
        DBMS_OUTPUT.PUT_LINE (vn_base_num || '*' || i || '= ' || vn_base_num * i);
    END LOOP;
END;

DECLARE
    vn_base_num NUMBER := 3;
BEGIN
    FOR i IN 1..9
    LOOP
        CONTINUE WHEN i=5;
        DBMS_OUTPUT.PUT_LINE (vn_base_num || '*' || i || '= ' || vn_base_num * i);
    END LOOP;
END;

DECLARE
    vn_base_num NUMBER := 3;
BEGIN
    <<third>>
    FOR i IN 1..9
    LOOP
        DBMS_OUTPUT.PUT_LINE (vn_base_num || '*' || i || '= ' || vn_base_num * i);
        IF i = 3 THEN
            GOTO fourth;
        END IF;
    END LOOP;
    
    <<fourth>>
    vn_base_num := 4;
    FOR i IN 1..9
    LOOP
        DBMS_OUTPUT.PUT_LINE (vn_base_num || '*' || i || '= ' || vn_base_num * i);
    END LOOP;
END;

-- 02 PL/SQL�� ����� ���� �Լ�
CREATE OR REPLACE FUNCTION my_mod ( num1 NUMBER, num2 NUMBER )
    RETURN NUMBER       -- ��ȯ ������ Ÿ���� NUMBER
IS
    vn_remainder NUMBER := 0;   -- ��ȯ�� ������
    vn_quotient NUMBER := 0;    -- ��
BEGIN
    vn_quotient := FLOOR ( num1 / num2 );   -- ������/���� ������� ���� �κ��� �ɷ�����.
    vn_remainder := num1 - ( num2 * vn_quotient );  -- ������ = ������ - ( ���� * �� )
    
    RETURN vn_remainder;
END;

SELECT my_mod(14, 3) reminder
    FROM DUAL;
    
CREATE OR REPLACE FUNCTION fn_get_country_name ( p_country_id NUMBER )
    RETURN VARCHAR2     -- �������� ��ȯ�ϹǷ� ��ȯ ������ Ÿ���� VARCHAR2
IS 
    vs_country_name COUNTRIES.COUNTRY_NAME%TYPE;
BEGIN
    SELECT country_name
        INTO vs_country_name
        FROM countries
        WHERE country_id = p_country_id;
        
    RETURN vs_country_name;     -- ������ ��ȯ
END;

SELECT fn_get_country_name(52777) COUN1, fn_get_country_name(10000) COUN2
    FROM dual;
    
CREATE OR REPLACE FUNCTION fn_get_country_name ( p_country_id NUMBER )
    RETURN VARCHAR2     -- �������� ��ȯ�ϹǷ� ��ȯ ������ Ÿ���� VARCHAR2
IS 
    vs_country_name COUNTRIES.COUNTRY_NAME%TYPE;
    vn_count NUMBER := 0;
BEGIN
    SELECT COUNT(*)
        INTO vn_count
        FROM countries
        WHERE country_id = p_country_id;
        
        IF vn_count = 0 THEN
            vs_country_name := '�ش籹�� ����';
        ELSE
            SELECT country_name
                INTO vs_country_name
                FROM countries
                WHERE country_id = p_country_id;
        END IF;
        
    RETURN vs_country_name;     -- ������ ��ȯ
END;

CREATE OR REPLACE FUNCTION fn_get_user
    RETURN VARCHAR2
IS vs_user_name VARCHAR2(80);
BEGIN 
    SELECT USER
        INTO vs_user_name
        FROM dual;
        
    RETURN vs_user_name;
END;

SELECT fn_get_user(), fn_get_user
    FROM dual;
    
-- ���ν���
CREATE OR REPLACE PROCEDURE my_new_job_proc
    ( p_job_id IN JOBS.JOB_ID%TYPE,
        p_job_title IN JOBS.JOB_TITLE%TYPE,
        p_min_sal IN JOBS.MIN_SALARY%TYPE,
        p_max_sal IN JOBS.MAX_SALARY%TYPE )
IS
BEGIN
    INSERT INTO JOBS ( job_id, job_title, min_salary, max_salary, create_date, update_date )
        VALUES ( p_job_id, p_job_title, p_min_sal, p_max_sal, SYSDATE, SYSDATE );
    COMMIT;
END;

EXEC my_new_job_proc ('SM_JOB1', 'Sample JOB1', 1000, 5000);

SELECT *
    FROM jobs
    WHERE job_id = 'SM_JOB1';
    
CREATE OR REPLACE PROCEDURE my_new_job_proc
    ( p_job_id IN JOBS.JOB_ID%TYPE,
        p_job_title IN JOBS.JOB_TITLE%TYPE,
        p_min_sal IN JOBS.MIN_SALARY%TYPE,
        p_max_sal IN JOBS.MAX_SALARY%TYPE )
IS
    vn_cnt NUMBER := 0;
BEGIN
    -- ������ job_id�� �ִ��� üũ
    SELECT COUNT(*)
        INTO vn_cnt
        FROM JOBS
        WHERE job_id = p_job_id;
        
    -- ������ insert
    IF vn_cnt = 0 THEN
        INSERT INTO JOBS ( job_id, job_title, min_salary, max_salary, create_date, update_date )
            VALUES ( p_job_id, p_job_title, p_min_sal, p_max_sal, SYSDATE, SYSDATE );
    ELSE -- ������ update
        UPDATE JOBS
            SET job_title = p_job_title,
                min_salary = p_min_sal,
                max_salary = p_max_sal,
                update_date = SYSDATE
            WHERE job_id = p_job_id;
    END IF;
    COMMIT;
END;

EXEC my_new_job_proc ('SM_JOB1', 'Sample JOB1', 2000, 6000);

SELECT *
    FROM jobs
    WHERE job_id = 'SM_JOB1';
    
EXECUTE my_new_job_proc ( p_job_id => 'SM_JOB1', p_job_title => 'Sample JOB1', p_min_sal => 2000, p_max_sal => 7000 );

EXECUTE my_new_job_proc ('SM_JOB1', 'Sample JOB1');

CREATE OR REPLACE PROCEDURE my_new_job_proc
    ( p_job_id IN JOBS.JOB_ID%TYPE,
        p_job_title IN JOBS.JOB_TITLE%TYPE,
        p_min_sal IN JOBS.MIN_SALARY%TYPE := 10,    -- ����Ʈ �� ����
        p_max_sal IN JOBS.MAX_SALARY%TYPE := 100,   -- ����Ʈ �� ����
        p_upd_date OUT JOBS.UPDATE_DATE%TYPE )
IS
    vn_cnt NUMBER := 0;
    vn_cur_date JOBS.UPDATE_DATE%TYPE := SYSDATE;
BEGIN
    -- ������ job_id�� �ִ��� üũ
    SELECT COUNT(*)
        INTO vn_cnt
        FROM JOBS
        WHERE job_id = p_job_id;
        
    -- ������ insert
    IF vn_cnt = 0 THEN
        INSERT INTO JOBS ( job_id, job_title, min_salary, max_salary, create_date, update_date )
            VALUES ( p_job_id, p_job_title, p_min_sal, p_max_sal, SYSDATE, SYSDATE );
    ELSE -- ������ update
        UPDATE JOBS
            SET job_title = p_job_title,
                min_salary = p_min_sal,
                max_salary = p_max_sal,
                update_date = vn_cur_date
            WHERE job_id = p_job_id;
    END IF;
    
    -- OUT �Ű������� ���� �Ҵ�
    p_upd_date := vn_cur_date;
    
    COMMIT;
END;

DECLARE
    vd_cur_date JOBS.UPDATE_DATE%TYPE;
BEGIN
    my_new_job_proc ('SM_JOB1', 'Sample JOB1', 2000, 6000, vd_cur_date);    -- EXEC, EXECUTE (X)
    DBMS_OUTPUT.PUT_LINE(vd_cur_date);
END;