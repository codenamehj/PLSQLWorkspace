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
        employee_id = &사원번호;

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
        dbms_output.put_line('정상적으로 삭제되지 않았습니다.');
    END IF;
END;
/

ROLLBACK;

SELECT *
FROM employees
WHERE employee_id = 1000;

-- 1. 사원번호를 입력(치환변수사용&)할 경우 사원번호, 사원이름, 부서이름을 출력하는 PL/SQL을 작성하시오.
-- 1) SQL문
SELECT
    employee_id,
    last_name,
    depatment_name
FROM
    employees JOIN departments 
        ON employees.department_id = departments.department_id
WHERE
    employees.employee_id = &사원번호;
-- 2) PL/SQL 블록
DECLARE
    v_empid    employees.employee_id%TYPE;
    v_lname    employees.last_name%TYPE;
    v_deptname departments.department_name%TYPE;
    v_deptid   employees.department_id%TYPE;
BEGIN
    --PL/SQL이라서 가능한 경우 -> 2개의 SELECT
--    SELECT employee_id, last_name, department_id
--    INTO v_empid, v_lname, v_deptid
--    FROM employees
--    WHERE employee_id = &사원번호;
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
        e.employee_id = &사원번호;

    dbms_output.put_line('사원번호 : ' || v_empid);
    dbms_output.put_line('사원이름 : ' || v_lname);
    dbms_output.put_line('부서이름 : ' || v_deptname);
END;
/

-- 2. 사원번호를 입력(치환변수사용&)할 경우 사원이름, 급여, 연봉->(급여*12+NVL(급여,0)*NVL(커미션퍼센트,0)*12)을 출력하는 PL/SQL을 작성하시오.
-- 1) SQL문
SELECT
    last_name,
    salary,
    ( salary * 12 + ( nvl(salary, 0) * nvl(commission_pct, 0) * 12 ) ) AS annual
FROM
    employees
WHERE
    employee_id = &사원번호;
-- 2) PL/SQL 블럭
DECLARE
    v_lname  employees.last_name%TYPE;
    v_sal    employees.salary%TYPE;
    v_annual v_sal%TYPE;
    v_comm   employees.commission_pct%TYPE;
BEGIN
    --PL/SQL이라서 가능한 경우 -> 별도의 연산 
--    SELECT  last_name, salary, commission_pct
--    INTO    v_lname, v_sal, v_comm
--    FROM    employees
--    WHERE   employee_id = &사원번호;
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
        employee_id = &사원번호;

    dbms_output.put_line('사원이름 : ' || v_lname);
    dbms_output.put_line('급여 : ' || v_sal);
    dbms_output.put_line('연봉 : ' || v_annual);
END;
/

CREATE TABLE test_employees
    AS
        SELECT *
        FROM employees;

SELECT *
FROM test_employees;

ROLLBACK;

-- 기본 IF 문
DECLARE BEGIN
    DELETE FROM test_employees
    WHERE
        employee_id = &사원번호;

    IF SQL%rowcount = 0 THEN
        dbms_output.put_line('정상적으로 삭제되지 않았습니다.');
        dbms_output.put_line('사원번호를 확인해주세요.');
    END IF;

END;
/

-- IF - ELSE 문 : 하나의 조건식, 결과는 참과 거짓으로 각각
DECLARE
    v_result NUMBER(4, 0);
BEGIN
    SELECT
        COUNT(employee_id)
    INTO v_result
    FROM
        employees
    WHERE
        manager_id = &사원번호;

    IF v_result = 0 THEN
        dbms_output.put_line('일반 사원입니다.');
    ELSE
        dbms_output.put_line('팀장입니다.');
    END IF;

END;
/

-- IF - ELSEIF - ELSE 문 : 다중 조건식이 필요, 각각 결과처리
-- 연차를 구하는 공식
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
        employee_id = &사원번호;

    IF v_hyear < 5 THEN
        dbms_output.put_line('입사한 지 5년 미만입니다.');
    ELSIF v_hyear < 10 THEN
        dbms_output.put_line('입사한 지 5년 이상 10년 미만입니다.');
    ELSIF v_hyear < 15 THEN
        dbms_output.put_line('입사한 지 10년 이상 15년 미만입니다.');
    ELSIF v_hyear < 20 THEN
        dbms_output.put_line('입사한 지 15년 이상 20년 미만입니다.');
    ELSE
        dbms_output.put_line('입사한 지 20년 이상입니다.');
    END IF;

END;
/

-- 3-1. 사원번호를 입력(치환변수 사용&)할 경우 입사일이 2015년 이후(2015년 포함)이면 'New employee' 출력, 2015년 이전이면 'Career employee' 출력
-- 3-2. 사원번호를 입력(치환변수 사용&)할 경우 입사일이 2015년 이후(2015년 포함)이면 'New employee' 출력, 2015년 이전이면 'Career employee' 출력
--      단, DBMS_OUTPUT.PUT_LINE ~ 은 한번만 사용
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
        employee_id = &사원번호;
    
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

-- 5.   사원번호를 입력(치환변수)하면 사원이름, 급여, 인상된 급여가 출력되도록 PL/SQL 블록을 생성하시오.   
--      급여가  5000 이하이면 20% 인상된 급여
--      급여가 10000 이하이면 15% 인상된 급여
--      급여가 15000 이하이면 10% 인상된 급여
--      급여가 15000 이상이면 급여 인상 없음
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
        employee_id = &사원번호;

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
    DBMS_OUTPUT.PUT_LINE('사원이름 : ' || v_empname);
    DBMS_OUTPUT.PUT_LINE('급여 : ' || v_salary);
    DBMS_OUTPUT.PUT_LINE('인상된 급여 : ' || v_result);
END;
/

-- 기본 LOOP 문
DECLARE
    v_num NUMBER(38) := 0;
BEGIN
    LOOP
        v_num := v_num + 1;
        DBMS_OUTPUT.PUT_LINE(v_num);
        EXIT WHEN v_num >= 10; -- *종료조건
    END LOOP;
END;
/

-- WHILE LOOP 문
DECLARE
    v_num NUMBER(38, 0) := 1;
BEGIN
    WHILE v_num < 5 LOOP -- 반복조건
        DBMS_OUTPUT.PUT_LINE(v_num);
        v_num := v_num + 1;
    END LOOP;
END;
/

-- 예제 : 1에서 10까지 정수 값의 합
DECLARE
    v_sum NUMBER(2, 0) := 0;
    v_num NUMBER(2, 0) := 1;
BEGIN
    -- 1) 기본 LOOP
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
-- 주의사항 1) 범위 지정
    FOR idx IN REVERSE -10 .. 5 LOOP
        IF MOD(idx, 2) <> 0 THEN -- 여기서의 <> 는 != 와 같음.
            DBMS_OUTPUT.PUT_LINE(idx);
        END IF;
    END LOOP;
END;
/

-- 주위사항 2) 카운터(counter)
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

-- 예제 : 1에서 10까지의 정수값의 합
-- FOR LOOP 문
DECLARE
    -- 정수값 : 1 ~ 10 => FOR LOOP의 카운터로 처리
    -- 합계
    v_total NUMBER(2, 0) := 0;
BEGIN
    FOR num IN 1 .. 10 LOOP
        v_total := v_total + num;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE(v_total);
END;
/

/*
1. 다음과 같이 출력 되도록 하시오.
*
**
***
****
*****

*/

-- 기본 LOOOP 문
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

-- FOR LOOP 문
DECLARE
    v_star VARCHAR2(10) := '';
BEGIN
    FOR idx IN 1..5 LOOP
        v_star := v_star || '*';
        DBMS_OUTPUT.PUT_LINE(v_star);
    END LOOP;
END;
/

-- WHILE LOOP 문
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
