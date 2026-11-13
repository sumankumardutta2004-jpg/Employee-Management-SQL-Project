CREATE DATABASE employee_management;
USE employee_management;
CREATE TABLE employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    department VARCHAR(50),
    salary DECIMAL(10,2),
    joining_date DATE
);
describe empolyees

INSERT INTO employees
(first_name, last_name, email, department, salary, joining_date)
VALUES
('Rahul', 'Sharma', 'rahul@gmail.com', 'IT', 30000, '2025-01-10'),
('Amit', 'Kumar', 'amit@gmail.com', 'HR', 25000, '2025-02-15'),
('Priya', 'Singh', 'priya@gmail.com', 'Finance', 35000, '2025-03-01'),
('Neha', 'Das', 'neha@gmail.com', 'IT', 40000, '2025-04-12'),
('Rohit', 'Verma', 'rohit@gmail.com', 'Sales', 28000, '2025-05-20');
SELECT * FROM employees;
SELECT
    department,
    COUNT(*) AS total_employees,
    AVG(salary) AS average_salary
FROM employees
GROUP BY department;
CREATE INDEX idx_department
ON employees(department);
SHOW INDEX FROM employees;
EXPLAIN
SELECT *
FROM employees
WHERE department = 'IT';
EXPLAIN
SELECT *
FROM employees IGNORE INDEX (idx_department)
WHERE department = 'IT';
CREATE TABLE departments (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(50) NOT NULL,
    location VARCHAR(100)
);
INSERT INTO departments
(department_name, location)
VALUES
('IT', 'Bangalore'),
('HR', 'Mumbai'),
('Finance', 'Delhi'),
('Sales', 'Kolkata');
SELECT * FROM departments;
ALTER TABLE employees
ADD department_id INT;
ALTER TABLE employees
ADD CONSTRAINT fk_employee_department
FOREIGN KEY (department_id)
REFERENCES departments(department_id);
UPDATE employees e
JOIN departments d
ON e.department = d.department_name
SET e.department_id = d.department_id;
SELECT
    e.first_name,
    e.last_name,
    d.department_name,
    d.location
FROM employees e
LEFT JOIN departments d
ON e.department_id = d.department_id;
SELECT
    e.first_name,
    e.last_name,
    d.department_name,
    d.location
FROM employees e
RIGHT JOIN departments d
ON e.department_id = d.department_id;
SELECT first_name, department
FROM employees
WHERE department = 'IT'

UNION

SELECT first_name, department
FROM employees
WHERE department = 'HR';
SELECT first_name, last_name, salary
FROM employees
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
);

CREATE VIEW employee_details AS
SELECT
    e.first_name,
    e.last_name,
    e.salary,
    d.department_name,
    d.location
FROM employees e
JOIN departments d
ON e.department_id = d.department_id;
SELECT * FROM employee_details;
DELIMITER //

CREATE PROCEDURE GetAllEmployees()
BEGIN
    SELECT * FROM employees;
END //

DELIMITER ;
CALL GetAllEmployees();
DELIMITER //

CREATE PROCEDURE GetEmployeesByDept(
    IN dept_name VARCHAR(50)
)
BEGIN
    SELECT *
    FROM employees
    WHERE department = dept_name;
END //

DELIMITER ;
CALL GetEmployeesByDept('IT');
CREATE TABLE employee_log (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_name VARCHAR(100),
    action_type VARCHAR(20),
    action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
DELIMITER //

CREATE TRIGGER after_employee_insert
AFTER INSERT ON employees
FOR EACH ROW
BEGIN
    INSERT INTO employee_log
    (employee_name, action_type)
    VALUES
    (NEW.first_name, 'INSERT');
END //

DELIMITER ;
INSERT INTO employees
(first_name, last_name, email, department, salary, joining_date, department_id)
VALUES
('Arjun', 'Roy', 'arjun@gmail.com', 'IT', 32000, '2025-06-01', 1);
SELECT * FROM employee_log;
SELECT
    first_name,
    UPPER(first_name) AS uppercase_name,
    LOWER(first_name) AS lowercase_name
FROM employees;
SELECT
    first_name,
    LENGTH(first_name) AS name_length
FROM employees;
SELECT
    AVG(salary) AS average_salary,
    ROUND(AVG(salary), 2) AS rounded_salary
FROM employees;
SELECT
    CONCAT(first_name, ' ', last_name) AS full_name
FROM employees;
START TRANSACTION;
UPDATE employees
SET salary = 35000
WHERE employee_id = 1;
SELECT * FROM employees
WHERE employee_id = 1;
COMMIT;
START TRANSACTION;

UPDATE employees
SET salary = 50000
WHERE employee_id = 1;

ROLLBACK;
SELECT * FROM employees
WHERE employee_id = 1;
SELECT
    first_name,
    salary,
    CASE
        WHEN salary >= 35000 THEN 'High Salary'
        WHEN salary >= 30000 THEN 'Medium Salary'
        ELSE 'Low Salary'
    END AS salary_status
FROM employees;
SELECT
    first_name,
    salary,
    IF(salary >= 30000, 'Eligible', 'Not Eligible') AS status
FROM employees;
SELECT
    first_name,
    IFNULL(department, 'Not Assigned') AS department_name
FROM employees;
SELECT
    first_name,
    COALESCE(department, 'Unknown') AS department_name
FROM employees;
USE employee_management;
SELECT
    first_name,
    department,
    salary,
    ROW_NUMBER() OVER (
        ORDER BY salary DESC
    ) AS row_num
FROM employees;
SELECT
    first_name,
    salary,
    RANK() OVER (
        ORDER BY salary DESC
    ) AS salary_rank
FROM employees;

SELECT
    first_name,
    department,
    salary,
    RANK() OVER (
        PARTITION BY department
        ORDER BY salary DESC
    ) AS dept_rank
FROM employees;
WITH high_salary AS (
    SELECT first_name, department, salary
    FROM employees
    WHERE salary > 30000
)
SELECT *
FROM high_salary;


SELECT
    first_name,
    last_name,
    department
FROM employees e
WHERE EXISTS (
    SELECT 1
    FROM departments d
    WHERE d.department_name = e.department
);

SELECT first_name, department
FROM employees
WHERE department = 'IT'

UNION ALL

SELECT first_name, department
FROM employees
WHERE department = 'HR';
EXPLAIN ANALYZE
SELECT *
FROM employees
WHERE department = 'IT';

CREATE INDEX idx_dept_salary
ON employees(department, salary);

SHOW INDEX FROM employees;


EXPLAIN
SELECT *
FROM employees
WHERE department = 'IT'
AND salary > 30000;

DESCRIBE employees;



SELECT
    email,
    COUNT(*) AS total
FROM employees
GROUP BY email
HAVING COUNT(*) > 1;

SELECT *
FROM employees
WHERE department_id IS NULL
   OR email IS NULL;
   
   SHOW TABLES;
   
   USE employee_management;

SHOW PROCEDURE STATUS
WHERE Db = 'employee_management';


USE employee_management;

SHOW TRIGGERS;


USE employee_management;

DELIMITER $$

CREATE PROCEDURE GetEmployeeCountByDept(
    IN p_department VARCHAR(50),
    OUT p_total INT
)
BEGIN
    SELECT COUNT(*)
    INTO p_total
    FROM employees
    WHERE department = p_department;
END $$

DELIMITER ;

CALL GetEmployeeCountByDept('IT', @total);

SELECT @total AS total_employees;


USE employee_management;

DELIMITER $$

CREATE TRIGGER after_employee_update
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
    INSERT INTO employee_log
    (employee_name, action_type, action_time)
    VALUES
    (NEW.first_name, 'UPDATE', NOW());
END $$

DELIMITER ; 

SHOW TRIGGERS;

USE employee_management;

DELIMITER $$

CREATE TRIGGER before_employee_insert
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    IF NEW.salary < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Salary cannot be negative';
    END IF;
END $$

DELIMITER ;

SHOW TRIGGERS;

USE employee_management;

DELIMITER $$

CREATE TRIGGER after_employee_delete
AFTER DELETE ON employees
FOR EACH ROW
BEGIN
    INSERT INTO employee_log
    (employee_name, action_type, action_time)
    VALUES
    (OLD.first_name, 'DELETE', NOW());
END $$

DELIMITER ;

SHOW TRIGGERS;


USE employee_management;

UPDATE employees
SET salary = 38000
WHERE employee_id = 1;

SHOW TRIGGERS;

USE employee_management;

DELIMITER $$

CREATE PROCEDURE UpdateEmployeeSalary(
    IN p_emp_id INT,
    IN p_new_salary DECIMAL(10,2)
)
BEGIN
    UPDATE employees
    SET salary = p_new_salary
    WHERE employee_id = p_emp_id;
END $$

DELIMITER ;


CALL UpdateEmployeeSalary(1, 40000);

SELECT employee_id, first_name, salary
FROM employees
WHERE employee_id = 1;

USE employee_management;

DELIMITER $$

CREATE PROCEDURE GetEmployeeDetails(
    IN p_emp_id INT
)
BEGIN
    DECLARE emp_count INT DEFAULT 0;

    SELECT COUNT(*)
    INTO emp_count
    FROM employees
    WHERE employee_id = p_emp_id;

    IF emp_count = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Employee not found';
    ELSE
        SELECT *
        FROM employees
        WHERE employee_id = p_emp_id;
    END IF;
END $$

DELIMITER ;

CALL GetEmployeeDetails(1);

CALL GetEmployeeDetails(999);

USE employee_management;

DELIMITER $$

CREATE TRIGGER before_employee_salary_update
BEFORE UPDATE ON employees
FOR EACH ROW
BEGIN
    IF NEW.salary <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Salary must be greater than zero';
    END IF;
END $$

DELIMITER ;

UPDATE employees
SET salary = -1000
WHERE employee_id = 1;

UPDATE employees
SET salary = 40000
WHERE employee_id = 1;

SELECT employee_id, first_name, salary
FROM employees
WHERE employee_id = 1;

USE employee_management;

SELECT *
FROM employee_log
ORDER BY log_id DESC;

SHOW TRIGGERS;

USE employee_management;

DELIMITER $$

CREATE PROCEDURE UpdateSalaryTransaction(
    IN p_emp_id INT,
    IN p_salary DECIMAL(10,2)
)
BEGIN
    DECLARE emp_count INT DEFAULT 0;

    START TRANSACTION;

    SELECT COUNT(*)
    INTO emp_count
    FROM employees
    WHERE employee_id = p_emp_id;

    IF emp_count = 0 THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Employee not found';
    ELSE
        UPDATE employees
        SET salary = p_salary
        WHERE employee_id = p_emp_id;

        COMMIT;
    END IF;
END $$

DELIMITER ;



CALL UpdateSalaryTransaction(1, 42000);



SELECT first_name, salary
FROM employees
WHERE employee_id = 1;

CALL UpdateSalaryTransaction(999, 45000);

USE employee_management;

SHOW PROCEDURE STATUS
WHERE Db = 'employee_management';

SHOW TRIGGERS
FROM employee_management;

SHOW TABLES;

SELECT * FROM employees;

SELECT * FROM departments;

SELECT * FROM employee_log;

SHOW TABLES;

SELECT * FROM employees;

SELECT * FROM departments;

SELECT * FROM employee_log;

SHOW TABLES;

SELECT * FROM departments;

SELECT * FROM employees;
SHOW TRIGGERS FROM employee_management;

SHOW PROCEDURE STATUS
WHERE Db = 'employee_management';

USE employee_management;

SELECT
    COUNT(*) AS total_employees,
    AVG(salary) AS average_salary,
    MAX(salary) AS highest_salary,
    MIN(salary) AS lowest_salary
FROM employees;

SELECT
    employee_name,
    action_type,
    COUNT(*) AS total_actions
FROM employee_log
GROUP BY employee_name, action_type
ORDER BY employee_name;


SELECT
    employee_id,
    first_name,
    salary,
    CASE
        WHEN salary >= 40000 THEN 'High'
        WHEN salary >= 30000 THEN 'Medium'
        ELSE 'Low'
    END AS salary_category
FROM employees
ORDER BY salary DESC;


INSERT INTO employees
(first_name, last_name, email, department, salary, joining_date, department_id)
VALUES
('Test', 'User', 'testuser@gmail.com', 'IT', 25000, '2026-11-04', 1);




DELETE FROM employees
WHERE email = 'testuser@gmail.com';


SELECT *
FROM employee_log
ORDER BY log_id DESC;


SELECT
    employee_id,
    first_name,
    salary,
    CASE
        WHEN salary IS NULL THEN 'Salary Missing'
        WHEN salary <= 0 THEN 'Invalid Salary'
        ELSE 'Valid Salary'
    END AS validation_status
FROM employees;


UPDATE employees
SET department = 'Finance'
WHERE employee_id = 1;



SELECT *
FROM employee_log
ORDER BY log_id DESC
LIMIT 5;


SELECT
    action_type,
    COUNT(*) AS total_actions
FROM employee_log
GROUP BY action_type;  


USE employee_management;

CALL GetEmployeeDetails(2);

USE employee_management;

SHOW TRIGGERS;


USE employee_management;

EXPLAIN
SELECT employee_id, first_name, last_name, salary
FROM employees
WHERE department = 'IT';

EXPLAIN
SELECT d.department_name, COUNT(e.employee_id) AS employee_count
FROM departments AS d
JOIN employees AS e
ON e.department_id = d.department_id
GROUP BY d.department_id, d.department_name;

SHOW INDEX FROM employees;

EXPLAIN
SELECT employee_id, first_name, salary
FROM employees
WHERE department = 'IT'
AND salary > 30000;


SELECT
    department,
    COUNT(*) AS total_employees,
    AVG(salary) AS average_salary
FROM employees
GROUP BY department;


SELECT * FROM employee_details;



USE employee_management;

SHOW GRANTS FOR CURRENT_USER();


USE employee_management;

SHOW GRANTS FOR CURRENT_USER();


USE employee_management;
SHOW GRANTS FOR CURRENT_USER();


CREATE ROLE IF NOT EXISTS 'employee_readonly';




GRANT SELECT ON employee_management.employees
TO 'employee_readonly';

GRANT SELECT ON employee_management.departments
TO 'employee_readonly';


CREATE USER IF NOT EXISTS 'report_user'@'localhost'
IDENTIFIED BY 'Report@2026Secure!';


GRANT 'employee_readonly' TO 'report_user'@'localhost';

SET DEFAULT ROLE 'employee_readonly'
TO 'report_user'@'localhost';



SHOW GRANTS FOR 'report_user'@'localhost';



SELECT CURRENT_USER();


USE employee_management;

SELECT * FROM employees;


UPDATE employees
SET salary = 45000
WHERE employee_id = 1;



SHOW GRANTS;

UPDATE employees
SET salary = 45000
WHERE employee_id = 1;


SELECT User, Host, account_locked
FROM mysql.user
WHERE User IN ('root', 'report_user');


SHOW GRANTS FOR 'report_user'@'localhost';



SELECT
    TABLE_SCHEMA,
    TABLE_NAME,
    TABLE_TYPE
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'employee_management';



SHOW GRANTS FOR 'report_user'@'localhost';





SELECT
    TABLE_NAME,
    TABLE_TYPE
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'employee_management';





SHOW VARIABLES LIKE 'have_ssl';




SHOW STATUS LIKE 'Ssl_cipher';


PREPARE safe_query FROM
'SELECT * FROM employees WHERE department = ?';

SET @dept = 'IT';

EXECUTE safe_query USING @dept;

DEALLOCATE PREPARE safe_query;


USE employee_management;


PREPARE safe_query FROM
'SELECT * FROM employees WHERE department = ?';

SET @dept = 'IT';

EXECUTE safe_query USING @dept;

DEALLOCATE PREPARE safe_query;


SHOW VARIABLES LIKE 'validate_password%';



USE employee_management;

SELECT * FROM employees;



UPDATE employees
SET salary = 45000
WHERE employee_id = 1;




USE employee_management;

SELECT *
FROM employee_log
ORDER BY action_time DESC;




SELECT
    User,
    Host,
    plugin,
    password_expired
FROM mysql.user
WHERE User = 'report_user';



SELECT
    User,
    Host,
    Db,
    Select_priv,
    Insert_priv,
    Update_priv,
    Delete_priv
FROM mysql.db
WHERE Db = 'employee_management';




SELECT
    COUNT(*) AS total_employees,
    COUNT(DISTINCT email) AS unique_emails,
    COUNT(*) - COUNT(DISTINCT email) AS duplicate_emails
FROM employees;




SELECT
    'Read Only Role' AS security_feature,
    'SELECT permission only' AS security_description
UNION ALL
SELECT
    'Access Control',
    'Role based permissions'
UNION ALL
SELECT
    'SQL Injection Prevention',
    'Prepared statements'
UNION ALL
SELECT
    'Audit Logging',
    'Employee activity logs'
UNION ALL
SELECT
    'Authentication',
    'MySQL user authentication';
    
    
    
    USE employee_management;

SHOW TABLES;

SELECT
    TABLE_NAME,
    TABLE_ROWS
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'employee_management';



USE employee_management;

SELECT
    TABLE_NAME,
    COLUMN_NAME,
    COLUMN_TYPE,
    IS_NULLABLE,
    COLUMN_KEY
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'employee_management'
ORDER BY TABLE_NAME, ORDINAL_POSITION;





USE employee_management;

SELECT
    TABLE_NAME,
    INDEX_NAME,
    COLUMN_NAME,
    NON_UNIQUE,
    SEQ_IN_INDEX
FROM INFORMATION_SCHEMA.STATISTICS
WHERE TABLE_SCHEMA = 'employee_management'
ORDER BY TABLE_NAME, INDEX_NAME;

USE employee_management;

SELECT COUNT(*) AS total_employees
FROM employees;



USE employee_management;

SELECT COUNT(*) AS total_employees
FROM employees;


USE employee_management;

SET @index_exists = (
    SELECT COUNT(*)
    FROM INFORMATION_SCHEMA.STATISTICS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'employees'
      AND INDEX_NAME = 'idx_employees_department'
);

SET @sql = IF(
    @index_exists = 0,
    'CREATE INDEX idx_employees_department ON employees(department)',
    'SELECT "Index already exists" AS message'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;




EXPLAIN
SELECT *
FROM employees
WHERE department = 'IT';



USE employee_management;

SELECT
    'Before Index' AS test_name,
    COUNT(*) AS matching_records
FROM employees IGNORE INDEX (idx_employees_department)
WHERE department = 'IT';

SELECT
    'After Index' AS test_name,
    COUNT(*) AS matching_records
FROM employees FORCE INDEX (idx_employees_department)
WHERE department = 'IT';








USE employee_management;

DESCRIBE employees;




USE employee_management;

DESCRIBE employees;




USE employee_management;

SHOW COLUMNS FROM employees;



USE employee_management;

-- 1. Create Performance Monitoring Table

CREATE TABLE IF NOT EXISTS performance_monitoring (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    check_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    table_name VARCHAR(100),
    total_rows BIGINT,
    data_size_kb DECIMAL(12,2),
    index_size_kb DECIMAL(12,2),
    total_size_kb DECIMAL(12,2)
);

-- 2. Collect Database Performance Metrics

INSERT INTO performance_monitoring
(table_name, total_rows, data_size_kb,
 index_size_kb, total_size_kb)

SELECT
    TABLE_NAME,
    TABLE_ROWS,
    ROUND(DATA_LENGTH / 1024, 2),
    ROUND(INDEX_LENGTH / 1024, 2),
    ROUND((DATA_LENGTH + INDEX_LENGTH) / 1024, 2)
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'employee_management';

-- 3. Display Monitoring Report

SELECT * FROM performance_monitoring;

-- 4. Database Size Analysis

SELECT
    TABLE_NAME,
    TABLE_ROWS,
    ROUND(DATA_LENGTH / 1024, 2) AS data_kb,
    ROUND(INDEX_LENGTH / 1024, 2) AS index_kb
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'employee_management';

-- 5. Monitoring Summary

SELECT
    COUNT(*) AS total_monitoring_records,
    SUM(total_rows) AS estimated_total_rows,
    ROUND(SUM(total_size_kb), 2) AS total_database_size_kb
FROM performance_monitoring;




-- Check existing indexes
SHOW INDEX FROM employees;

-- Check table status
SHOW TABLE STATUS
FROM employee_management;

-- Analyze table
ANALYZE TABLE employees;

-- Check execution plan
EXPLAIN
SELECT COUNT(*)
FROM employees;

-- Actual execution analysis (MySQL 8)
EXPLAIN ANALYZE
SELECT COUNT(*)
FROM employees;


SELECT
    TABLE_NAME,
    ENGINE,
    TABLE_ROWS,
    ROUND(DATA_LENGTH / 1024, 2) AS DATA_KB,
    ROUND(INDEX_LENGTH / 1024, 2) AS INDEX_KB,
    ROUND(DATA_FREE / 1024, 2) AS FREE_SPACE_KB
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'employee_management';




SELECT
    table_name,
    COUNT(*) AS monitoring_checks,
    MAX(total_rows) AS latest_estimated_rows,
    MAX(total_size_kb) AS latest_size_kb,
    MAX(check_time) AS last_checked
FROM performance_monitoring
GROUP BY table_name;




SHOW TABLES;

DESCRIBE employees;

SHOW INDEX FROM employees;

SELECT * FROM performance_monitoring;




-- Test 1: Employee count
SELECT COUNT(*) FROM employees;

-- Test 2: Department analysis
SELECT department, COUNT(*)
FROM employees
GROUP BY department;

-- Test 3: Salary analysis
SELECT ROUND(AVG(salary), 2)
FROM employees;

-- Test 4: Query execution plan
EXPLAIN
SELECT *
FROM employees
WHERE department = 'IT';



USE employee_management;

-- 1. Verify Department Index
SHOW INDEX FROM employees;

-- 2. Analyze Employee Table
ANALYZE TABLE employees;

-- 3. Check Optimized Query
EXPLAIN
SELECT *
FROM employees
WHERE department = 'IT';

-- 4. Check Monitoring Records
SELECT * FROM performance_monitoring;

-- 5. Final Database Tables
SHOW TABLES;





USE employee_management;

SELECT
    'Employee Management System' AS project_name,
    (SELECT COUNT(*) FROM employees) AS total_employees,
    (SELECT COUNT(DISTINCT department) FROM employees) AS total_departments,
    (SELECT COUNT(*) FROM performance_monitoring) AS monitoring_records;
    
    
    
    
    USE employee_management;
SHOW TABLES;



USE employee_management;

DESCRIBE employees;




USE employee_management;

SHOW INDEX FROM employees;




USE employee_management;

EXPLAIN
SELECT *
FROM employees
WHERE department = 'IT';




USE employee_management;

SELECT
    COUNT(*) AS total_employees,
    COUNT(DISTINCT department) AS total_departments,
    ROUND(AVG(salary), 2) AS average_salary,
    MAX(salary) AS highest_salary,
    MIN(salary) AS lowest_salary
FROM employees;



USE employee_management;

SELECT *
FROM performance_monitoring;




USE employee_management;

SELECT
    TABLE_NAME,
    ENGINE,
    TABLE_ROWS,
    ROUND(DATA_LENGTH / 1024, 2) AS DATA_KB,
    ROUND(INDEX_LENGTH / 1024, 2) AS INDEX_KB,
    ROUND(DATA_FREE / 1024, 2) AS FREE_SPACE_KB
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'employee_management';



USE employee_management;

SELECT
    'Employee Management System' AS project_name,
    (SELECT COUNT(*) FROM employees) AS total_employees,
    (SELECT COUNT(DISTINCT department)
     FROM employees) AS total_departments,
    (SELECT COUNT(*) FROM performance_monitoring)
     AS monitoring_records;