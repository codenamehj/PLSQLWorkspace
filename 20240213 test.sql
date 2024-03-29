--1. 비식별관계
--2. HAVING절
--3. 선수의 영문 이름의 두번째 문자가 A인 선수들의 데이터
--4. 3개
--5. INLINE VIEW
--6. 
DROP TABLE department;
CREATE TABLE department (
    deptid NUMBER(10) PRIMARY KEY,
    deptname VARCHAR2(10),
    location VARCHAR2(10),
    tel VARCHAR2(15)
);

DROP TABLE employee;
CREATE TABLE employee (
    empid NUMBER(10) PRIMARY KEY,
    empname VARCHAR2(10),
    hiredate DATE,
    addr VARCHAR2(12),
    tel VARCHAR2(15),
--  deptid NUMBER(10) REFERENCES department(deptid)

    deptid NUMBER(10),
    CONSTRAINT emp_dept_deptid_FK FOREIGN KEY(deptid)
    REFERENCES department(deptid)
);

--7.
ALTER TABLE employee
ADD birthday DATE;
--MODIFY(NOT NULL만 사용), DROP

--8.
INSERT INTO department
(
    deptid,
    deptname,
    location,
    tel
)
VALUES 
(
    1001,
    '총무팀',
    '본101호',
    '053-777-8777'
);
INSERT INTO department
(
    deptid,
    deptname,
    location,
    tel
)
VALUES 
(
    1002,
    '회계팀',
    '본102호',
    '053-888-9999'
);
INSERT INTO department
(
    deptid,
    deptname,
    location,
    tel
)
VALUES 
(
    1003,
    '영업팀',
    '본103호',
    '053-222-3333'
);

-- YYYYMMDD
INSERT INTO employee
(
    empid,
    empname,
    hiredate,
    addr,
    tel,
    deptid
)
VALUES 
(
    20211945,
    '박민수',
    TO_DATE('20120302','YYYYMMDD'),
    '대구',
    '010-1111-1234',
    1001
);
INSERT INTO employee
(
    empid,
    empname,
    hiredate,
    addr,
    tel,
    deptid
)
VALUES 
(
    20101817,
    '박준식',
    TO_DATE('20100701','YYYYMMDD'),
    '경산',
    '010-2222-1234',
    1003
);
INSERT INTO employee
(
    empid,
    empname,
    hiredate,
    addr,
    tel,
    deptid
)
VALUES 
(
    20122245,
    '선아라',
    TO_DATE('20120302','YYYYMMDD'),
    '대구',
    '010-3333-1222',
    1002
);
INSERT INTO employee
(
    empid,
    empname,
    hiredate,
    addr,
    tel,
    deptid
)
VALUES 
(
    20121729,
    '이범수',
    TO_DATE('20110302','YYYYMMDD'),
    '서울',
    '010-3333-4444',
    1001
);
INSERT INTO employee
(
    empid,
    empname,
    hiredate,
    addr,
    tel,
    deptid
)
VALUES 
(
    20121646,
    '이융희',
    TO_DATE('20120901','YYYYMMDD'),
    '부산',
    '010-1234-2222',
    1003
);

--9.
ALTER TABLE employee
MODIFY      empname NOT NULL;

DESC employee;

--10.
SELECT  e.empname,
        e.hiredate,
        d.deptname
FROM    department d
        INNER JOIN employee e
        ON (e.deptid = d.deptid)
WHERE   d.deptname = '총무팀';

--11.
DELETE FROM employee
WHERE       addr = '대구';

--12.
UPDATE  employee
SET     deptid =    (SELECT deptid
                     FROM   department 
                     WHERE  deptname = '회계팀')
WHERE   deptid =    (SELECT deptid
                     FROM   department
                     WHERE  deptname = '영업팀');

--13.
SELECT  e.empid,
        e.empname,
        e.birthday,
        d.deptname
FROM    employee e
        JOIN department d 
        ON (e.deptid = d.deptid)
WHERE   e.hiredate >   (SELECT  hiredate
                        FROM    employee
                        WHERE   empid = 20121729);
                        
SELECT * 
FROM employee;

--14.
-- GRANT CREATE VIEW TO hr; <- 이거는 관리자 워크시트에서 실행.
CREATE OR REPLACE VIEW emp_vu
AS
    SELECT  e.empname,
            e.addr,
            d.deptname
    FROM    employee e
            JOIN department d
            ON (d.deptid = e.deptid)
    WHERE   d.deptname = '총무팀';

--Paginging
SELECT r.*
FROM (
        SELECT ROWNUM rn, e.*
        FROM (
            SELECT *
            FROM employees
            ORDER BY first_name) e
    )r
WHERE rn BETWEEN 1 AND 10;

-- 모든 사원의 정보
SELECT  employee_id,
        first_name,
        department_name
FROM departments d
    FULL JOIN employees e
    ON(e.department_id = d.department_id);