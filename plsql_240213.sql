SET SERVEROUTPUT ON

DECLARE

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

ACCEPT p_annual_sal PROMPT 'Please enter the annual salary: '
DECLARE
    v_sal NUMBER(9,2) := &p_annual_sal;
BEGIN
    v_sal := v_sal/12;
    DBMS_OUTPUT.PUT_LINE('The monthly salary is ' || TO_CHAR(v_sal));
END;
/

DECLARE
    v_sal NUMBER(7,2) := 60000;
    v_comm v_sal%TYPE := v_sal * .20;
    v_message VARCHAR2(255) := ' eligible for commission';
BEGIN
    DBMS_OUTPUT.PUT_LINE('v_sal ' || v_sal);                        -- v_sal 60000
    DBMS_OUTPUT.PUT_LINE('v_comm ' || v_comm);                      -- v_comm 12000
    DBMS_OUTPUT.PUT_LINE('v_message ' || v_message);                -- v_message eligible for commission
    DBMS_OUTPUT.PUT_LINE('================================');       -- ================================
    DECLARE 
        v_sal NUMBER(7,2) := 50000;
        v_comm v_sal%TYPE := 0;
        v_total_comp NUMBER(7,2) := v_sal + v_comm;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('v_sal ' || v_sal);                    -- v_sal 50000
        DBMS_OUTPUT.PUT_LINE('v_comm ' || v_comm);                  -- v_comm 0
        DBMS_OUTPUT.PUT_LINE('v_message ' || v_message);            -- v_message  eligible for commission
        DBMS_OUTPUT.PUT_LINE('v_total_comp ' || v_total_comp);      -- v_total_comp 50000
        DBMS_OUTPUT.PUT_LINE('================================');   -- ================================
        v_message := 'CLERK not ' || v_message;
        v_comm := v_sal * .30; -- 적용 안됨.
    END;
    DBMS_OUTPUT.PUT_LINE('v_sal ' || v_sal);                        -- v_sal 60000
    DBMS_OUTPUT.PUT_LINE('v_comm ' || v_comm);                      -- v_comm 12000
    DBMS_OUTPUT.PUT_LINE('v_message ' || v_message);                -- v_message CLERK not  eligible for commission
    DBMS_OUTPUT.PUT_LINE('================================');       -- ================================
    v_message := 'SALESMAN ' || v_message;
    DBMS_OUTPUT.PUT_LINE('v_message ' || v_message);                -- v_message SALESMAN CLERK not  eligible for commission
END;
/