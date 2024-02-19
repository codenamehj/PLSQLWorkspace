SET SERVEROUTPUT ON

-- FUNCTION
DROP FUNCTION test_fun;
CREATE FUNCTION test_fun
        ( p_msg IN VARCHAR2 )
RETURN  VARCHAR2
IS
        --선언부
BEGIN
        RETURN p_msg;
EXCEPTION
        WHEN NO_DATA_FOUND THEN
                RETURN '데이터가 존재하지 않습니다.';
END;
/

DECLARE
        v_result VARCHAR2(1000);   
BEGIN
        v_result := test_fun('테스트');
        DBMS_OUTPUT.PUT_LINE(v_result);
END;
/

--dual : 더미 테이블
SELECT * FROM dual;

SELECT test_fun('SELECT문에서 호출')
FROM dual;

--명령어로 프로시저 보기
--SELECT *
--FROM user_source
--WHERE type IN ('PROCEDURE');

-- 더하기
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

-- 사원번호를 기준으로 직속상사 이름을 출력
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
                RETURN '직속 상사가 존재하지 않습니다.';
END;
/

SELECT employee_id, last_name, get_mgr(employee_id) as manager
FROM employees;

/* 1. 사원번호를 입력하면 
last_name + first_name 이 출력되는 
y_yedam 함수를 생성하시오.

실행) EXECUTE DBMS_OUTPUT.PUT_LINE(y_yedam(174))
출력 예)  Abel Ellen

SELECT employee_id, y_yedam(employee_id)
FROM   employees;
*/
DROP FUNCTION y_yedam;
CREATE FUNCTION y_yedam
        (p_eid employees.employee_id%TYPE) -- 외부 변수는 p_ 사용
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

/* 2. 사원번호를 입력할 경우 다음 조건을 만족하는 결과가 출력되는 ydinc 함수를 생성하시오.
- 급여가 5000 이하이면 20% 인상된 급여 출력
- 급여가 10000 이하이면 15% 인상된 급여 출력
- 급여가 20000 이하이면 10% 인상된 급여 출력
- 급여가 20000 초과이면 급여 그대로 출력
실행) SELECT last_name, salary, YDINC(employee_id)
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
        
        -- 2) salary 에 따라 비율을 다르게 적용
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

/* 3. 사원번호를 입력하면 해당 사원의 연봉이 출력되는 yd_func 함수를 생성하시오.
->연봉계산 : (급여+(급여*인센티브퍼센트))*12
실행) SELECT last_name, salary, YD_FUNC(employee_id)
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
예제와 같이 출력되는 subname 함수를 작성하시오.
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