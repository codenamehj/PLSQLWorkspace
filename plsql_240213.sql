SET SERVEROUTPUT ON

BEGIN
    DBMS_OUTPUT.PUT_LINE('Hello, World!');
END;
/

DECLARE
    -- 선언부 : 정의 및 선언
    v_annual NUMBER(9,2) := &연봉;
    v_sal v_annual%TYPE;    
BEGIN
    -- 실행부
    v_sal := v_annual/12;
    DBMS_OUTPUT.PUT_LINE('The monthly salary is ' || TO_CHAR(v_sal));
END;
/