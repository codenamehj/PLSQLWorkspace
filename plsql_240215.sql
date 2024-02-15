SET SERVEROUTPUT ON

-- 2. 치환변수(&)를 사용하면 숫자를 입력하면 해당 구구단이 출력되도록 하시오.
-- 기본 LOOP => 조건과 관련된 변수 필수!
-- for => 변수를 요구하지 않음
DECLARE
  v_num NUMBER(20) := &구구단;
BEGIN
    FOR i IN 1 .. 9 LOOP -- 특정 범위에 존재하는 정수 값을 내부 변수
        DBMS_OUTPUT.PUT_LINE(v_num || '*' || i || '=' || v_num * i);
    END LOOP;
END;
/

-- while => 조건과 관련된 변수
DECLARE
  v_num NUMBER(5) := &구구단;
  v_count NUMBER(5) := 1; -- 범위 : 1 ~ 9, 정수 모두
BEGIN
    WHILE v_count <= 9 LOOP
        DBMS_OUTPUT.PUT_LINE(v_num || '*' || v_count || '=' || v_num * v_count);
        v_count := v_count + 1;
    END LOOP;
END;
/

-- loop
DECLARE
  v_num CONSTANT NUMBER(5) := &구구단;
  v_count NUMBER(5) := 1;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE(v_num || '*' || v_count || '=' || v_num * v_count);
        v_count := v_count + 1;
        EXIT WHEN v_count > 9 ;
    END LOOP;
END;
/

-- 3. 구구단 2~9단까지 출력되도록 하시오.
-- for 

BEGIN
    FOR i IN 2 .. 9 LOOP 
        FOR j IN 1 .. 9 LOOP 
            DBMS_OUTPUT.PUT(i || '*' || j || '=' || i * j || ' ');
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
END;
/

-- while => 반복조건과 관련된 변수
DECLARE
  v_num NUMBER(5) := 2; -- 2 ~ 9 => 반복조건
  v_num2 NUMBER(5) := 1; -- 1 ~ 9 => 반복조건
BEGIN
    WHILE v_num <= 9 LOOP
        v_num2 := 1;
        WHILE v_num2 <= 9 LOOP
            DBMS_OUTPUT.PUT(v_num || '*' || v_num2 || '=' || v_num * v_num2 || ' ');
            v_num2 := v_num2 + 1;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('');
        v_num := v_num +1;
    END LOOP;
END;
/

-- loop
DECLARE
  v_num NUMBER(5) := 2;
  v_num2 NUMBER(5) := 1;
BEGIN
    LOOP
        v_num2 := 1;
        LOOP
            DBMS_OUTPUT.PUT(v_num || '*' || v_num2 || '=' || v_num * v_num2 || ' ');
            v_num2 := v_num2 + 1;
            EXIT WHEN v_num2 > 9 ;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('');
        v_num := v_num +1;
        EXIT WHEN v_num > 9 ;
    END LOOP;
END;
/

-- 4. 구구단 2~9단까지 출력되도록 하시오.(단, 홀수단 출력)
-- for 

BEGIN
    FOR i IN 2 .. 9 LOOP 
        IF MOD(i,2) <> 0 THEN
            FOR j IN 1 .. 9 LOOP 
                DBMS_OUTPUT.PUT(i || '*' || j || '=' || i * j || ' ');
            END LOOP;
        END IF;
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
END;
/

BEGIN
    FOR i IN 2 .. 9 LOOP 
        IF MOD(i,2) = 0 THEN
            CONTINUE;
        END IF;
            FOR j IN 1 .. 9 LOOP 
                DBMS_OUTPUT.PUT(i || '*' || j || '=' || i * j || ' ');
            END LOOP;
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
END;
/

-- while
DECLARE
  v_num NUMBER(5) := 2; 
  v_num2 NUMBER(5) := 1; 
BEGIN
    WHILE v_num <= 9 LOOP
        v_num2 := 1;
        IF MOD(v_num,2) <> 0 THEN
        WHILE v_num2 <= 9 LOOP
            DBMS_OUTPUT.PUT(v_num || '*' || v_num2 || '=' || v_num * v_num2 || ' ');
            v_num2 := v_num2 + 1;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('');
        END IF;
        v_num := v_num +1;
    END LOOP;
END;
/

-- loop
DECLARE
  v_num NUMBER(5) := 2;
  v_num2 NUMBER(5) := 1;
BEGIN
    LOOP
        IF MOD(v_num,2) <> 0 THEN
        v_num2 := 1;
        LOOP
            DBMS_OUTPUT.PUT(v_num || '*' || v_num2 || '=' || v_num * v_num2 || ' ');
            v_num2 := v_num2 + 1;
            EXIT WHEN v_num2 > 9 ;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('');
        END IF;
        v_num := v_num +1;
        EXIT WHEN v_num > 9 ;
    END LOOP;
END;
/

--RECORD
DECLARE
    -- 1) 정의
    TYPE emp_record_type IS RECORD
        (empno NUMBER(6, 0),
         ename employees.last_name%TYPE,
         sal employees.salary%TYPE := 0);
        
    -- 2) 변수 선언
    v_emp_info emp_record_type;
    v_emp_record emp_record_type;
BEGIN
    SELECT employee_id, last_name, salary
    INTO v_emp_info
    FROM employees
    WHERE employee_id = &사원번호;
    
    DBMS_OUTPUT.PUT('사원번호 : ' || v_emp_info.empno);
    DBMS_OUTPUT.PUT(', 사원이름 : ' || v_emp_info.ename);
    DBMS_OUTPUT.PUT_LINE(', 급여 : ' || v_emp_info.sal);
END;
/

-- RECORD : %ROWTYPE
DECLARE
    v_emp_info employees%ROWTYPE;
BEGIN
    SELECT *
    INTO v_emp_info
    FROM employees
    WHERE employee_id = &사원번호;
    
    DBMS_OUTPUT.PUT('사원번호 : ' || v_emp_info.employee_id);
    DBMS_OUTPUT.PUT(', 사원이름 : ' || v_emp_info.last_name);
    DBMS_OUTPUT.PUT_LINE(', 업무 : ' || v_emp_info.job_id);
END;
/

-- TABLE
DECLARE
    -- 1) 정의
    TYPE num_table_type IS TABLE OF NUMBER
        INDEX BY PLS_INTEGER;
        
    -- 2) 변수선언
    v_num_info num_table_type;
BEGIN
    v_num_info(-1000) := 10000;
    
    DBMS_OUTPUT.PUT_LINE('현재 인덱스 -1000 : ' || v_num_info(-1000));
END;
/

-- 2의 배수 10개를 담는 예제 : 2, 4, 6, 8 , 10, 12, 14, 16, 18, 20
DECLARE
    TYPE num_table_type IS TABLE OF NUMBER
       INDEX BY PLS_INTEGER;
       
    v_num_ary num_table_type;
    
    v_result NUMBER(4, 0) := 0;
BEGIN
    FOR idx IN 1 .. 10 LOOP
        v_num_ary(idx * 5) := idx * 2;
    END LOOP;
    
    FOR i IN v_num_ary.FIRST .. v_num_ary.LAST LOOP
        IF v_num_ary.EXISTS(i) THEN
            DBMS_OUTPUT.PUT(i || ' : ');
            DBMS_OUTPUT.PUT_LINE(v_num_ary(i));
            
            v_result := v_result + v_num_ary(i);
        END IF;
    END LOOP;
    
    DBMS_OUTPUT.PUT('총 갯수 : ' || v_num_ary.COUNT);
    DBMS_OUTPUT.PUT_LINE(', 누적 합 : ' || v_result);
END;
/

-- TABLE + RECORD
SELECT *
FROM employees;

DECLARE
    TYPE emp_table_type IS TABLE OF employees%ROWTYPE
        INDEX BY PLS_INTEGER;
        
    v_emps emp_table_type;
    v_emp_info employees%ROWTYPE;
BEGIN
    FOR eid IN 100 .. 104 LOOP
        SELECT *
        INTO v_emp_info
        FROM employees
        WHERE employee_id = eid;
        
        v_emps(eid) := v_emp_info;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('총 갯수 : ' || v_emps.COUNT);
    DBMS_OUTPUT.PUT_LINE(v_emps(100).last_name);
END;
/

DECLARE
    v_min employees.employee_id%TYPE; -- 최소 사원번호
    v_max employees.employee_id%TYPE; -- 최대 사원번호
    v_result NUMBER(1,0);             -- 사원의 존재유무를 확인
    v_emp_record employees%ROWTYPE;     -- Employees 테이블의 한 행에 대응
    
    TYPE emp_table_type IS TABLE OF v_emp_record%TYPE
        INDEX BY PLS_INTEGER;
    
    v_emp_table emp_table_type;
BEGIN
    -- 최소 사원번호, 최대 사원번호
    SELECT MIN(employee_id), MAX(employee_id)
    INTO v_min, v_max
    FROM employees;
    
    FOR eid IN v_min .. v_max LOOP
        SELECT COUNT(*)
        INTO v_result
        FROM employees
        WHERE employee_id = eid;
        
        IF v_result = 0 THEN
            CONTINUE;
        END IF;
        
        SELECT *
        INTO v_emp_record
        FROM employees
        WHERE employee_id = eid;
        
        v_emp_table(eid) := v_emp_record;     
    END LOOP;
    
    FOR eid IN v_emp_table.FIRST .. v_emp_table.LAST LOOP
        IF v_emp_table.EXISTS(eid) THEN
            DBMS_OUTPUT.PUT(v_emp_table(eid).employee_id || ', ');
            DBMS_OUTPUT.PUT(v_emp_table(eid).last_name || ', ');
            DBMS_OUTPUT.PUT_LINE(v_emp_table(eid).hire_date);
        END IF;
    END LOOP;    
END;
/

-- CURSOR
DECLARE
    -- 커서를 선언
    CURSOR emp_cursor IS
        SELECT employee_id, last_name
        FROM employees;
        
    v_eid employees.employee_id%TYPE;
    v_ename employees.last_name%TYPE;
BEGIN
    OPEN emp_cursor;
    
    FETCH emp_cursor INTO v_eid, v_ename;
    
    DBMS_OUTPUT.PUT('사원 번호 : ' || v_eid);
    DBMS_OUTPUT.PUT_LINE(', 사원 이름 : ' || v_ename);
    
    CLOSE emp_cursor;
END;
/

DECLARE
    CURSOR emp_cursor IS
        SELECT
            employee_id,
            last_name,
            job_id
        FROM employees;

    v_emp_record emp_cursor%ROWTYPE;
    
BEGIN
    OPEN emp_cursor;
    
    LOOP
        FETCH emp_cursor INTO v_emp_record;
        EXIT WHEN emp_cursor%NOTFOUND;
        
        -- 실제 연산 진행
        DBMS_OUTPUT.PUT(emp_cursor%ROWCOUNT || ', ');
        DBMS_OUTPUT.PUT_LINE(v_emp_record.last_name);
    END LOOP;
    
    -- FETCH emp_cursor INTO v_emp_record;
    -- DBMS_OUTPUT.PUT(emp_cursor%ROWCOUNT || ', ');
    -- DBMS_OUTPUT.PUT_LINE(v_emp_record.last_name);
    
    CLOSE emp_cursor;
   
    -- *주의 CLOSE 된 후에는 
    -- FETCH emp_cursor INTO v_emp_record;
    -- DBMS_OUTPUT.PUT(emp_cursor%ROWCOUNT || ', ');
    
END;
/

-- employees
DECLARE
    CURSOR emp_cursor IS
        SELECT *
        FROM employees;
        
    v_emp_record employees%ROWTYPE;

    TYPE emp_table_type IS TABLE OF employees%ROWTYPE
        INDEX BY PLS_INTEGER;
    
    v_emp_table emp_table_type;
BEGIN
    OPEN emp_cursor;
    
    LOOP
        FETCH emp_cursor INTO v_emp_record;
        EXIT WHEN emp_cursor%NOTFOUND;
            
        v_emp_table(v_emp_record.employee_id) := v_emp_record;
    END LOOP;
    
    CLOSE emp_cursor;

    FOR eid IN v_emp_table.FIRST .. v_emp_table.LAST LOOP
        IF v_emp_table.EXISTS(eid) THEN
            DBMS_OUTPUT.PUT(v_emp_table(eid).employee_id || ', ');
            DBMS_OUTPUT.PUT(v_emp_table(eid).last_name || ', ');
            DBMS_OUTPUT.PUT_LINE(v_emp_table(eid).hire_date);
        END IF;
    END LOOP;    
END;
/

--
DECLARE
    CURSOR emp_dept_cursor IS
        SELECT employee_id, last_name, job_id
        FROM employees
        WHERE department_id = &부서번호;
        
    v_emp_info emp_dept_cursor%ROWTYPE;
BEGIN
    -- 1) 해당 부서에 속한 사원의 정보를 출력
    -- 2) 해당 부서에 속한 사원이 없는 경우 '해당 부서에 소속된 직원이 없습니다.'라는 메세지 출력
    OPEN emp_dept_cursor;
    
    LOOP
        FETCH emp_dept_cursor INTO v_emp_info;
        EXIT WHEN emp_dept_cursor%NOTFOUND;
        
        -- 첫번째 => 몇 번째 행
--        DBMS_OUTPUT.PUT_LINE('첫번째 : ' || emp_dept_cursor%ROWCOUNT);

        DBMS_OUTPUT.PUT(v_emp_info.employee_id || ', ');
        DBMS_OUTPUT.PUT(v_emp_info.last_name || ', ');
        DBMS_OUTPUT.PUT_LINE(v_emp_info.job_id);
    END LOOP;
    
    -- 두번째 => 현재 커서의 데이터 총 갯수
--    DBMS_OUTPUT.PUT_LINE('두번째 : ' || emp_dept_cursor%ROWCOUNT);

    IF emp_dept_cursor%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('해당 부서에 소속된 직원이 없습니다.');
    END IF;

    CLOSE emp_dept_cursor;

END;
/

-- 1) 모든 사원의 사원번호, 이름, 부서이름 출력
-- SELECT 문
SELECT e.employee_id, e.last_name, d.department_name
FROM employees e 
    LEFT OUTER JOIN departments d
    ON e.department_id = d.department_id;
-- PL/SQL 블록
DECLARE
    CURSOR emp_dept_cursor IS
        SELECT e.employee_id eid, e.last_name ename, d.department_name dept_name
        FROM employees e 
            LEFT OUTER JOIN departments d
            ON e.department_id = d.department_id;

     v_emp_info emp_dept_cursor%ROWTYPE;
BEGIN
    OPEN emp_dept_cursor;
        LOOP
            FETCH emp_dept_cursor INTO v_emp_info;
            EXIT WHEN emp_dept_cursor%NOTFOUND;
            
            DBMS_OUTPUT.PUT('사원번호 : ' || v_emp_info.eid);
            DBMS_OUTPUT.PUT(', 사원이름 : ' || v_emp_info.ename);
            DBMS_OUTPUT.PUT_LINE(', 부서이름 : ' || v_emp_info.dept_name);
        END LOOP;
        
    CLOSE emp_dept_cursor;
END;
/

-- 2) 부서번호가 50이거나 80인 사원들의 사원이름, 급여, 연봉 출력
-- 연봉 : (급여 * 12) + (NVL(급여, 0) * NVL(커미션, 0) * 12)
-- SQL 문
SELECT last_name ename, salary sal, (salary * 12 + (NVL(salary, 0) * NVL(commission_pct, 0) * 12)) annual
FROM employees
WHERE department_id IN(50, 80);
-- PL/SQL 블록
DECLARE
    CURSOR emp_cursor IS
        SELECT last_name ename, salary sal, (salary * 12 + (NVL(salary, 0) * NVL(commission_pct, 0) * 12)) as annual
        FROM employees
        WHERE department_id IN (50, 80);
        
    v_emp_info emp_cursor%ROWTYPE;
BEGIN
    OPEN emp_cursor;
        LOOP
            FETCH emp_cursor INTO v_emp_info;
            EXIT WHEN emp_cursor%NOTFOUND;
            
            DBMS_OUTPUT.PUT('사원이름 : ' || v_emp_info.ename);
            DBMS_OUTPUT.PUT(', 급여 : ' || v_emp_info.sal);
            DBMS_OUTPUT.PUT_LINE(', 연봉 : ' || v_emp_info.annual);
        END LOOP;
    CLOSE emp_cursor;
END;
/