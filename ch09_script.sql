-- 09�� PLSQL����� �������α׷�

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
