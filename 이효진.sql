SET SERVEROUTPUT ON

-- 2)
DECLARE
        v_dname departments.department_name%TYPE;
        v_job_id employees.job_id%TYPE;
        v_sal employees.salary%TYPE;
        v_annual v_sal%TYPE;
BEGIN
        SELECT d.department_name, e.job_id, e.salary, ((e.salary  + (NVL(e.salary, 0) * NVL(e.commission_pct, 0))) * 12) as annual
        INTO v_dname, v_job_id, v_sal, v_annual
        FROM employees e JOIN departments d
                ON e.department_id = d.department_id
        WHERE e.employee_id = &사원번호;
        
        DBMS_OUTPUT.PUT_LINE('부서이름 : ' || v_dname || ', Job Id : ' || v_job_id || ', 급여 : ' || v_sal || ', 연간 총 수입 : ' || v_annual);
END;
/

-- 3)
DECLARE
    v_hdate employees.hire_date%TYPE;
    v_msg   VARCHAR2(20) := 'Career employee';
BEGIN
    SELECT hire_date
    INTO v_hdate
    FROM employees
    WHERE employee_id = &사원번호;

    IF v_hdate >= TO_DATE('20150101', 'yyyyMMdd') THEN
        v_msg := 'New employee';
    END IF;

    DBMS_OUTPUT.PUT_LINE(v_msg);
END;
/

-- 4)
BEGIN
    FOR i IN 1 .. 9 LOOP 
        IF MOD(i,2) <> 0 THEN -- MOD(m,n) : m을 n으로 나누었을 때 나머지를 반환한다. -- <> 는 != 와 같다.
            FOR j IN 1 .. 9 LOOP 
                DBMS_OUTPUT.PUT(i || '*' || j || '=' || i * j || ' ');
            END LOOP;
        END IF;
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
END;
/

-- 5)
DECLARE
    CURSOR emp_cursor IS
        SELECT employee_id, last_name, salary
        FROM employees
        WHERE department_id = &부서번호;

     v_emp_info emp_cursor%ROWTYPE;
BEGIN
    OPEN emp_cursor;
        LOOP
            FETCH emp_cursor INTO v_emp_info;
            EXIT WHEN emp_cursor%NOTFOUND;
            
            DBMS_OUTPUT.PUT('사원번호 : ' || v_emp_info.employee_id);
            DBMS_OUTPUT.PUT(', 사원이름 : ' || v_emp_info.last_name);
            DBMS_OUTPUT.PUT_LINE(', 급여 : ' || v_emp_info.salary);
        END LOOP;
        
    CLOSE emp_cursor;
END;
/

-- 6)
CREATE PROCEDURE update_salary
    (p_empno IN employees.employee_id%TYPE,
     p_incrsal IN NUMBER)
IS
    e_emp_sel_fail EXCEPTION;
BEGIN
    UPDATE employees
    SET salary = salary * (1 + p_incrsal / 100)
    WHERE employee_id = p_empno;
    
    IF SQL%ROWCOUNT = 0 THEN
        RAISE e_emp_sel_fail;
    END IF;
    
EXCEPTION
    WHEN e_emp_sel_fail THEN
        DBMS_OUTPUT.PUT_LINE('No search employee!!');
END;
/

EXECUTE update_salary(100, 10);
ROLLBACK;

-- 7)
DROP PROCEDURE ju_age_gender;
CREATE PROCEDURE ju_age_gender
 (p_ju_no IN VARCHAR2)
IS
        v_age NUMBER;
        v_gender VARCHAR2(50);
BEGIN
        IF SUBSTR(p_ju_no, 7, 1) IN ('1', '2', '5', '6') THEN
                v_age := SUBSTR(TO_CHAR(sysdate, 'yyyy'), 3, 2) + 100 - SUBSTR(p_ju_no, 1, 2) - 1;
        ELSE
                v_age := SUBSTR(TO_CHAR(sysdate, 'yyyy'), 3, 2) - SUBSTR(p_ju_no, 1, 2) - 1;
        END IF;
        
        IF SUBSTR(p_ju_no, 7, 1)IN ('1', '3') THEN
                v_gender := '남자';
        ELSIF SUBSTR(p_ju_no, 7, 1) IN ('2', '4') THEN
                v_gender := '여자';
        ELSE
                v_gender := '외국인';
        END IF;
        
        DBMS_OUTPUT.PUT_LINE('만 ' || v_age || '세 ' || v_gender);
END;
/
EXECUTE ju_age_gender('0211023234567');

-- 8)
DROP FUNCTION get_hyear;
CREATE FUNCTION get_hyear
        (p_eid employees.employee_id%TYPE)
RETURN NUMBER
IS
        v_hyear NUMBER;
BEGIN
        SELECT TRUNC(months_between(sysdate, hire_date) / 12)
        INTO v_hyear
        FROM employees
        WHERE employee_id = p_eid;
        
        RETURN v_hyear;
END;
/
SELECT employee_id, last_name, get_hyear(employee_id)
FROM employees;

-- 9)
DROP FUNCTION dept_mgr;
CREATE FUNCTION dept_mgr
        (p_dept_name departments.department_name%TYPE)
RETURN VARCHAR2
IS
       v_mgr_name employees.last_name%TYPE;
       
BEGIN
        SELECT last_name
        INTO v_mgr_name
        FROM employees
        WHERE employee_id = 
                (
                         SELECT manager_id
                         FROM departments
                        WHERE department_name = p_dept_name
                );
        
        RETURN v_mgr_name;
EXCEPTION
        WHEN NO_DATA_FOUND THEN
                RETURN '해당 부서의 책임자가 없습니다.';
END;
/
SELECT department_name, dept_mgr(department_name) as manager
FROM departments;

EXECUTE DBMS_OUTPUT.PUT_LINE(dept_mgr('Contracting'));


-- 10)
SELECT name, text
FROM user_source
WHERE type IN ('PROCEDURE', 'FUNCTION', 'PACKAGE', 'PACKAGE BODY');

-- 11)
DECLARE
    v_star VARCHAR2(20) := '';
BEGIN
        FOR idx IN 1 .. 9 LOOP
                v_star := '';
                FOR h IN 1 .. (10 - idx) LOOP
                        v_star := v_star || '-';
                END LOOP;
                FOR s IN 1 .. idx LOOP
                        v_star := v_star || '*';
                END LOOP;
                DBMS_OUTPUT.PUT_LINE(v_star);
        END LOOP;
END;
/