SET SERVEROUTPUT ON

DECLARE
    v_deptno departments.department_id%TYPE;
    v_comm   employees.commission_pct%TYPE :=.1;
BEGIN
    SELECT
        department_id
    INTO v_deptno
    FROM
        employees
    WHERE
        employee_id = &�����ȣ;

    INSERT INTO employees (
        employee_id,
        last_name,
        email,
        hire_date,
        job_id,
        department_id
    ) VALUES (
        1000,
        'Hong',
        'hkd@google.com',
        sysdate,
        'IT_PROG',
        v_deptno
    );

    UPDATE employees
    SET
        salary = ( nvl(salary, 0) + 10000 ) * v_comm
    WHERE
        employee_id = 1000;

END;
/

BEGIN
    DELETE FROM employees
    WHERE
        employee_id = 1000;

    UPDATE employees
    SET
        salary = salary *.1
    WHERE
        employee_id = 0;

    IF SQL%rowcount = 0 THEN
        dbms_output.put_line('���������� �������� �ʾҽ��ϴ�.');
    END IF;
END;
/

ROLLBACK;

SELECT *
FROM employees
WHERE employee_id = 1000;

-- 1. �����ȣ�� �Է�(ġȯ�������&)�� ��� �����ȣ, ����̸�, �μ��̸��� ����ϴ� PL/SQL�� �ۼ��Ͻÿ�.
-- 1) SQL��
SELECT
    employee_id,
    last_name,
    depatment_name
FROM
    employees JOIN departments 
        ON employees.department_id = departments.department_id
WHERE
    employees.employee_id = &�����ȣ;
-- 2) PL/SQL ���
DECLARE
    v_empid    employees.employee_id%TYPE;
    v_lname    employees.last_name%TYPE;
    v_deptname departments.department_name%TYPE;
    v_deptid   employees.department_id%TYPE;
BEGIN
    --PL/SQL�̶� ������ ��� -> 2���� SELECT
--    SELECT employee_id, last_name, department_id
--    INTO v_empid, v_lname, v_deptid
--    FROM employees
--    WHERE employee_id = &�����ȣ;
--    
--    SELECT department_name
--    INTO v_deptname
--    FROM departments
--    WHERE department_id = v_deptid;

    SELECT
        e.employee_id,
        e.last_name,
        d.department_name
    INTO
        v_empid,
        v_lname,
        v_deptname
    FROM
             employees e
        JOIN departments d ON e.department_id = d.department_id
    WHERE
        e.employee_id = &�����ȣ;

    dbms_output.put_line('�����ȣ : ' || v_empid);
    dbms_output.put_line('����̸� : ' || v_lname);
    dbms_output.put_line('�μ��̸� : ' || v_deptname);
END;
/

-- 2. �����ȣ�� �Է�(ġȯ�������&)�� ��� ����̸�, �޿�, ����->(�޿�*12+NVL(�޿�,0)*NVL(Ŀ�̼��ۼ�Ʈ,0)*12)�� ����ϴ� PL/SQL�� �ۼ��Ͻÿ�.
-- 1) SQL��
SELECT
    last_name,
    salary,
    ( salary * 12 + ( nvl(salary, 0) * nvl(commission_pct, 0) * 12 ) ) AS annual
FROM
    employees
WHERE
    employee_id = &�����ȣ;
-- 2) PL/SQL ��
DECLARE
    v_lname  employees.last_name%TYPE;
    v_sal    employees.salary%TYPE;
    v_annual v_sal%TYPE;
    v_comm   employees.commission_pct%TYPE;
BEGIN
    --PL/SQL�̶� ������ ��� -> ������ ���� 
--    SELECT  last_name, salary, commission_pct
--    INTO    v_lname, v_sal, v_comm
--    FROM    employees
--    WHERE   employee_id = &�����ȣ;
--    
--    v_annual := (v_sal * 12 + (NVL(v_sal, 0) * NVL(v_comm, 0) * 12));

    SELECT
        last_name,
        salary,
        ( ( salary * 12 ) + nvl(salary, 0) * nvl(commission_pct, 0) * 12 ) AS annual
    INTO
        v_lname,
        v_sal,
        v_annual
    FROM
        employees
    WHERE
        employee_id = &�����ȣ;

    dbms_output.put_line('����̸� : ' || v_lname);
    dbms_output.put_line('�޿� : ' || v_sal);
    dbms_output.put_line('���� : ' || v_annual);
END;
/

CREATE TABLE test_employees
    AS
        SELECT *
        FROM employees;

SELECT *
FROM test_employees;

ROLLBACK;

-- �⺻ IF ��
DECLARE BEGIN
    DELETE FROM test_employees
    WHERE
        employee_id = &�����ȣ;

    IF SQL%rowcount = 0 THEN
        dbms_output.put_line('���������� �������� �ʾҽ��ϴ�.');
        dbms_output.put_line('�����ȣ�� Ȯ�����ּ���.');
    END IF;

END;
/

-- IF - ELSE �� : �ϳ��� ���ǽ�, ����� ���� �������� ����
DECLARE
    v_result NUMBER(4, 0);
BEGIN
    SELECT
        COUNT(employee_id)
    INTO v_result
    FROM
        employees
    WHERE
        manager_id = &�����ȣ;

    IF v_result = 0 THEN
        dbms_output.put_line('�Ϲ� ����Դϴ�.');
    ELSE
        dbms_output.put_line('�����Դϴ�.');
    END IF;

END;
/

-- IF - ELSEIF - ELSE �� : ���� ���ǽ��� �ʿ�, ���� ���ó��
-- ������ ���ϴ� ����
SELECT
    employee_id,
    trunc(months_between(sysdate, hire_date) / 12) AS hyear
FROM
    employees;

DECLARE
    v_hyear NUMBER(2, 0);
BEGIN
    SELECT
        trunc(months_between(sysdate, hire_date) / 12)
    INTO v_hyear
    FROM
        employees
    WHERE
        employee_id = &�����ȣ;

    IF v_hyear < 5 THEN
        dbms_output.put_line('�Ի��� �� 5�� �̸��Դϴ�.');
    ELSIF v_hyear < 10 THEN
        dbms_output.put_line('�Ի��� �� 5�� �̻� 10�� �̸��Դϴ�.');
    ELSIF v_hyear < 15 THEN
        dbms_output.put_line('�Ի��� �� 10�� �̻� 15�� �̸��Դϴ�.');
    ELSIF v_hyear < 20 THEN
        dbms_output.put_line('�Ի��� �� 15�� �̻� 20�� �̸��Դϴ�.');
    ELSE
        dbms_output.put_line('�Ի��� �� 20�� �̻��Դϴ�.');
    END IF;

END;
/

-- 3-1. �����ȣ�� �Է�(ġȯ���� ���&)�� ��� �Ի����� 2015�� ����(2015�� ����)�̸� 'New employee' ���, 2015�� �����̸� 'Career employee' ���
-- 3-2. �����ȣ�� �Է�(ġȯ���� ���&)�� ��� �Ի����� 2015�� ����(2015�� ����)�̸� 'New employee' ���, 2015�� �����̸� 'Career employee' ���
--      ��, DBMS_OUTPUT.PUT_LINE ~ �� �ѹ��� ���
DECLARE
    v_hdate employees.hire_date%TYPE;
    v_msg   VARCHAR2(20) := 'Career employee';
BEGIN
    SELECT
        hire_date
    INTO v_hdate
    FROM
        employees
    WHERE
        employee_id = &�����ȣ;
    
    -- 3.1
--    IF v_hdate >= TO_DATE('20150101', 'yyyyMMdd') THEN
--        DBMS_OUTPUT.PUT_LINE('New employee');
--    ELSE
--        DBMS_OUTPUT.PUT_LINE('Career employee');
--    END IF;
    
    -- 3.2
    IF v_hdate >= TO_DATE('20150101', 'yyyyMMdd') THEN
        v_msg := 'New employee';
    END IF;

    dbms_output.put_line(v_msg);
END;
/

-- 5.   �����ȣ�� �Է�(ġȯ����)�ϸ� ����̸�, �޿�, �λ�� �޿��� ��µǵ��� PL/SQL ����� �����Ͻÿ�.   
--      �޿���  5000 �����̸� 20% �λ�� �޿�
--      �޿��� 10000 �����̸� 15% �λ�� �޿�
--      �޿��� 15000 �����̸� 10% �λ�� �޿�
--      �޿��� 15000 �̻��̸� �޿� �λ� ����
DECLARE
    v_empname employees.last_name%TYPE;
    v_sal     employees.salary%TYPE;
    v_raise   NUMBER(4, 1);
    v_result  v_salary%TYPE;
BEGIN
    SELECT
        last_name,
        salary
    INTO
        v_empname,
        v_sal
    FROM
        employees
    WHERE
        employee_id = &�����ȣ;

    IF v_sal <= 5000 THEN
        v_raise := 20;
    ELSIF v_sal <= 10000 THEN
        v_raise := 15;
    ELSIF v_sal <= 15000 THEN
        v_raise := 10;
    ELSE
        v_raise := 0;
    END IF;

    v_result := v_sal + ( v_sal * v_raise / 100 );
    DBMS_OUTPUT.PUT_LINE('����̸� : ' || v_empname);
    DBMS_OUTPUT.PUT_LINE('�޿� : ' || v_salary);
    DBMS_OUTPUT.PUT_LINE('�λ�� �޿� : ' || v_result);
END;
/

-- �⺻ LOOP ��
DECLARE
    v_num NUMBER(38) := 0;
BEGIN
    LOOP
        v_num := v_num + 1;
        DBMS_OUTPUT.PUT_LINE(v_num);
        EXIT WHEN v_num >= 10; -- *��������
    END LOOP;
END;
/

-- WHILE LOOP ��
DECLARE
    v_num NUMBER(38, 0) := 1;
BEGIN
    WHILE v_num < 5 LOOP -- �ݺ�����
        DBMS_OUTPUT.PUT_LINE(v_num);
        v_num := v_num + 1;
    END LOOP;
END;
/

-- ���� : 1���� 10���� ���� ���� ��
DECLARE
    v_sum NUMBER(2, 0) := 0;
    v_num NUMBER(2, 0) := 1;
BEGIN
    -- 1) �⺻ LOOP
    LOOP
        v_sum := v_sum + v_num;
        v_num := v_num + 1;
        EXIT WHEN v_num > 10;
    END LOOP;
    
    -- 2) WHILE LOOP
--    WHILE v_num <= 10 LOOP
--        v_sum := v_sum + v_num;
--        v_num := v_num + 1;
--    END LOOP;

    DBMS_OUTPUT.PUT_LINE(v_sum);
END;
/

-- FOR LOOP
DECLARE

BEGIN
-- ���ǻ��� 1) ���� ����
    FOR idx IN REVERSE -10 .. 5 LOOP
        IF MOD(idx, 2) <> 0 THEN -- ���⼭�� <> �� != �� ����.
            DBMS_OUTPUT.PUT_LINE(idx);
        END IF;
    END LOOP;
END;
/

-- �������� 2) ī����(counter)
DECLARE
    v_num NUMBER(2,0) := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE(v_num);
    v_num := v_num * 2;
    DBMS_OUTPUT.PUT_LINE(v_num);
    DBMS_OUTPUT.PUT_LINE('================================');
    FOR v_num IN 1 .. 10 LOOP
--      v_num := v_num * 2;
--      v_num := 0;
        DBMS_OUTPUT.PUT_LINE(v_num * 2);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(v_num);
END;
/

-- ���� : 1���� 10������ �������� ��
-- FOR LOOP ��
DECLARE
    -- ������ : 1 ~ 10 => FOR LOOP�� ī���ͷ� ó��
    -- �հ�
    v_total NUMBER(2, 0) := 0;
BEGIN
    FOR num IN 1 .. 10 LOOP
        v_total := v_total + num;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE(v_total);
END;
/

/*
1. ������ ���� ��� �ǵ��� �Ͻÿ�.
*
**
***
****
*****

*/

-- �⺻ LOOOP ��
DECLARE
    v_idx NUMBER(2,0) := 1;
    v_star VARCHAR2(10) := '';
BEGIN
    LOOP
        v_star := v_star || '*';
        v_idx := v_idx + 1;
        DBMS_OUTPUT.PUT_LINE(v_star);
        EXIT WHEN v_idx > 5;
    END LOOP;
END;
/

-- FOR LOOP ��
DECLARE
    v_star VARCHAR2(10) := '';
BEGIN
    FOR idx IN 1..5 LOOP
        v_star := v_star || '*';
        DBMS_OUTPUT.PUT_LINE(v_star);
    END LOOP;
END;
/

-- WHILE LOOP ��
DECLARE
    v_idx NUMBER(2,0) := 1;
    v_star VARCHAR2(10) := '';
BEGIN
    WHILE v_idx <= 5 LOOP
        v_star := v_star || '*';
        v_idx := v_idx + 1;
        DBMS_OUTPUT.PUT_LINE(v_star);
    END LOOP;    
END;
/
