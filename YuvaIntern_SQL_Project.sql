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