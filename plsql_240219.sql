SET SERVEROUTPUT ON

-- FUNCTION
DROP FUNCTION test_fun;
CREATE FUNCTION test_fun
        ( p_msg IN VARCHAR2 )
RETURN  VARCHAR2
IS
        --�����
BEGIN
        RETURN p_msg;
EXCEPTION
        WHEN NO_DATA_FOUND THEN
                RETURN '�����Ͱ� �������� �ʽ��ϴ�.';
END;
/

DECLARE
        v_result VARCHAR2(1000);   
BEGIN
        v_result := test_fun('�׽�Ʈ');
        DBMS_OUTPUT.PUT_LINE(v_result);
END;
/

--dual : ���� ���̺�
SELECT * FROM dual;

SELECT test_fun('SELECT������ ȣ��')
FROM dual;

--��ɾ�� ���ν��� ����
--SELECT *
--FROM user_source
--WHERE type IN ('PROCEDURE');

-- ���ϱ�
DROP FUNCTION y_sum;
CREATE FUNCTION y_sum
        ( p_x IN NUMBER,
          p_y IN NUMBER )
RETURN NUMBER
IS
        v_result NUMBER;
BEGIN
        v_result := p_x + p_y;
        RETURN v_result;
END;
/

SELECT y_sum(100,200)
FROM dual;

-- �����ȣ�� �������� ���ӻ�� �̸��� ���
DROP FUNCTION get_mgr;
CREATE FUNCTION get_mgr
        (p_eid employees.employee_id%TYPE)
RETURN VARCHAR2
IS
       v_mgr_name employees.last_name%TYPE;
       
BEGIN
        SELECT m.last_name
        INTO v_mgr_name
        FROM employees e JOIN employees m
                ON (e.manager_id = m.employee_id)
        WHERE e.employee_id = p_eid;
        
        RETURN v_mgr_name;
EXCEPTION
        WHEN NO_DATA_FOUND THEN
                RETURN '���� ��簡 �������� �ʽ��ϴ�.';
END;
/

SELECT employee_id, last_name, get_mgr(employee_id) as manager
FROM employees;

/* 1. �����ȣ�� �Է��ϸ� 
last_name + first_name �� ��µǴ� 
y_yedam �Լ��� �����Ͻÿ�.

����) EXECUTE DBMS_OUTPUT.PUT_LINE(y_yedam(174))
��� ��)  Abel Ellen

SELECT employee_id, y_yedam(employee_id)
FROM   employees;
*/
DROP FUNCTION y_yedam;
CREATE FUNCTION y_yedam
        (p_eid employees.employee_id%TYPE) -- �ܺ� ������ p_ ���
RETURN VARCHAR2
IS
        v_full_name VARCHAR2(1000);
BEGIN
        SELECT last_name || ' ' || first_name
        INTO v_full_name
        FROM employees
        WHERE employee_id = p_eid;
        
        RETURN v_full_name;
END;
/

SELECT employee_id, y_yedam(employee_id)
FROM   employees;

EXECUTE DBMS_OUTPUT.PUT_LINE(y_yedam(174));

/* 2. �����ȣ�� �Է��� ��� ���� ������ �����ϴ� ����� ��µǴ� ydinc �Լ��� �����Ͻÿ�.
- �޿��� 5000 �����̸� 20% �λ�� �޿� ���
- �޿��� 10000 �����̸� 15% �λ�� �޿� ���
- �޿��� 20000 �����̸� 10% �λ�� �޿� ���
- �޿��� 20000 �ʰ��̸� �޿� �״�� ���
����) SELECT last_name, salary, YDINC(employee_id)
     FROM   employees;
*/
DROP FUNCTION ydinc;
CREATE FUNCTION ydinc
        (p_eid employees.employee_id%TYPE)
RETURN NUMBER
IS
        v_incrsal employees.salary%TYPE;
        v_sal employees.salary%TYPE;
BEGIN
        -- 1) SELECT => salary
        SELECT salary
        INTO v_sal
        FROM employees
        WHERE employee_id = p_eid;
        
        -- 2) salary �� ���� ������ �ٸ��� ����
        IF v_sal <=5000 THEN
                v_incrsal := v_sal * 1.2;
        ELSIF v_sal <= 10000 THEN
                v_incrsal := v_sal * 1.15;
        ELSIF v_sal <= 20000 THEN
                v_incrsal := v_sal * 1.1;
        ELSE
                v_incrsal := v_sal;
        END IF;

        RETURN v_incrsal;
END;
/
SELECT last_name, salary, YDINC(employee_id)
FROM   employees;

/* 3. �����ȣ�� �Է��ϸ� �ش� ����� ������ ��µǴ� yd_func �Լ��� �����Ͻÿ�.
->������� : (�޿�+(�޿�*�μ�Ƽ���ۼ�Ʈ))*12
����) SELECT last_name, salary, YD_FUNC(employee_id)
     FROM   employees;
*/
DROP FUNCTION yd_func;
CREATE FUNCTION yd_func
        (p_eid employees.employee_id%TYPE)
RETURN NUMBER
IS
        v_annual employees.salary%TYPE;
BEGIN
        SELECT (salary  + (NVL(salary, 0) * NVL(commission_pct, 0))) * 12
        INTO v_annual
        FROM employees
        WHERE employee_id = p_eid;

        RETURN v_annual;
END;
/
SELECT last_name, salary, YD_FUNC(employee_id)
FROM   employees;

/* 4. SELECT last_name, subname(last_name)
FROM   employees;

LAST_NAME     SUBNAME(LA
------------ ------------
King                    K***
Smith                  S****
...
������ ���� ��µǴ� subname �Լ��� �ۼ��Ͻÿ�.
*/
DROP FUNCTION subname;
CREATE FUNCTION subname
        (p_lname employees.last_name%TYPE)
RETURN VARCHAR2
IS
        v_result VARCHAR2(1000);
BEGIN
        v_result := RPAD(SUBSTR(p_lname, 1, 1), LENGTH(p_lname), '*');
        
        RETURN v_result;
END;
/
SELECT last_name, subname(last_name)
FROM   employees;