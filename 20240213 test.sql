--1. ��ĺ�����
--2. HAVING��
--3. ������ ���� �̸��� �ι�° ���ڰ� A�� �������� ������
--4. 3��
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
--MODIFY(NOT NULL�� ���), DROP

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
    '�ѹ���',
    '��101ȣ',
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
    'ȸ����',
    '��102ȣ',
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
    '������',
    '��103ȣ',
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
    '�ڹμ�',
    TO_DATE('20120302','YYYYMMDD'),
    '�뱸',
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
    '���ؽ�',
    TO_DATE('20100701','YYYYMMDD'),
    '���',
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
    '���ƶ�',
    TO_DATE('20120302','YYYYMMDD'),
    '�뱸',
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
    '�̹���',
    TO_DATE('20110302','YYYYMMDD'),
    '����',
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
    '������',
    TO_DATE('20120901','YYYYMMDD'),
    '�λ�',
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
WHERE   d.deptname = '�ѹ���';

--11.
DELETE FROM employee
WHERE       addr = '�뱸';

--12.
UPDATE  employee
SET     deptid =    (SELECT deptid
                     FROM   department 
                     WHERE  deptname = 'ȸ����')
WHERE   deptid =    (SELECT deptid
                     FROM   department
                     WHERE  deptname = '������');

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
-- GRANT CREATE VIEW TO hr; <- �̰Ŵ� ������ ��ũ��Ʈ���� ����.
CREATE OR REPLACE VIEW emp_vu
AS
    SELECT  e.empname,
            e.addr,
            d.deptname
    FROM    employee e
            JOIN department d
            ON (d.deptid = e.deptid)
    WHERE   d.deptname = '�ѹ���';

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

-- ��� ����� ����
SELECT  employee_id,
        first_name,
        department_name
FROM departments d
    FULL JOIN employees e
    ON(e.department_id = d.department_id);