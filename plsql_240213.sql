SET SERVEROUTPUT ON

BEGIN
    DBMS_OUTPUT.PUT_LINE('Hello, World!');
END;
/

DECLARE
    -- ����� : ���� �� ����
    v_annual NUMBER(9,2) := &����;
    v_sal v_annual%TYPE;    
BEGIN
    -- �����
    v_sal := v_annual/12;
    DBMS_OUTPUT.PUT_LINE('The monthly salary is ' || TO_CHAR(v_sal));
END;
/