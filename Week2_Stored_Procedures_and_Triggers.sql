-- YuvaIntern Virtual SQL Developer Internship
-- Week 2: Advanced Stored Procedures and Trigger Implementation
-- Database: employee_management | MySQL Workbench 8.0
--
-- This script recreates the Week 2 procedures and triggers.
-- It drops objects with the same names before creating them.
-- Confirm that the existing tables/columns match this project schema.
-- This script does not create or alter tables.

USE employee_management;

-- 1. Stored procedures
DROP PROCEDURE IF EXISTS GetAllEmployees;
DROP PROCEDURE IF EXISTS GetEmployeeDetails;
DROP PROCEDURE IF EXISTS GetEmployeeCountByDept;
DROP PROCEDURE IF EXISTS GetEmployeesByDept;
DROP PROCEDURE IF EXISTS UpdateEmployeeSalary;
DROP PROCEDURE IF EXISTS UpdateSalaryTransaction;

DELIMITER $$

CREATE PROCEDURE GetAllEmployees()
BEGIN
    SELECT * FROM employees ORDER BY employee_id;
END$$

CREATE PROCEDURE GetEmployeeDetails(IN p_emp_id INT)
BEGIN
    IF EXISTS (SELECT 1 FROM employees WHERE employee_id = p_emp_id) THEN
        SELECT * FROM employees WHERE employee_id = p_emp_id;
    ELSE
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Employee ID not found';
    END IF;
END$$

CREATE PROCEDURE GetEmployeeCountByDept(
    IN p_department VARCHAR(50),
    OUT p_total INT
)
BEGIN
    SELECT COUNT(*) INTO p_total
    FROM employees
    WHERE department = p_department;
END$$

CREATE PROCEDURE GetEmployeesByDept(IN p_department VARCHAR(50))
BEGIN
    SELECT * FROM employees
    WHERE department = p_department
    ORDER BY employee_id;
END$$

CREATE PROCEDURE UpdateEmployeeSalary(
    IN p_emp_id INT,
    IN p_new_salary DECIMAL(10,2)
)
BEGIN
    IF p_new_salary <= 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Salary must be greater than zero';
    ELSEIF NOT EXISTS (SELECT 1 FROM employees WHERE employee_id = p_emp_id) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Employee ID not found';
    ELSE
        UPDATE employees
        SET salary = p_new_salary
        WHERE employee_id = p_emp_id;
    END IF;
END$$

CREATE PROCEDURE UpdateSalaryTransaction(
    IN p_emp_id INT,
    IN p_new_salary DECIMAL(10,2)
)
BEGIN
    DECLARE v_employee_count INT DEFAULT 0;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    IF p_new_salary <= 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Salary must be greater than zero';
    END IF;

    SELECT COUNT(*) INTO v_employee_count
    FROM employees
    WHERE employee_id = p_emp_id;

    IF v_employee_count = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Employee ID not found; transaction rolled back';
    END IF;

    UPDATE employees
    SET salary = p_new_salary
    WHERE employee_id = p_emp_id;

    COMMIT;
END$$

DELIMITER ;

-- 2. Triggers
DROP TRIGGER IF EXISTS after_employee_update;
DROP TRIGGER IF EXISTS before_employee_insert;
DROP TRIGGER IF EXISTS after_employee_delete;
DROP TRIGGER IF EXISTS before_employee_salary_update;

DELIMITER $$

CREATE TRIGGER after_employee_update
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
    INSERT INTO employee_log (employee_name, action_type, action_time)
    VALUES (CONCAT(NEW.first_name, ' ', NEW.last_name), 'UPDATE', CURRENT_TIMESTAMP);
END$$

CREATE TRIGGER before_employee_insert
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    IF NEW.salary < 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Salary cannot be negative';
    END IF;
END$$

CREATE TRIGGER after_employee_delete
AFTER DELETE ON employees
FOR EACH ROW
BEGIN
    INSERT INTO employee_log (employee_name, action_type, action_time)
    VALUES (CONCAT(OLD.first_name, ' ', OLD.last_name), 'DELETE', CURRENT_TIMESTAMP);
END$$

CREATE TRIGGER before_employee_salary_update
BEFORE UPDATE ON employees
FOR EACH ROW
BEGIN
    IF NEW.salary <= 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Updated salary must be greater than zero';
    END IF;
END$$

DELIMITER ;

-- 3. Verification queries
SHOW PROCEDURE STATUS WHERE Db = 'employee_management';
SHOW TRIGGERS FROM employee_management;

-- Example calls (run individually when needed):
-- CALL GetAllEmployees();
-- CALL GetEmployeeDetails(2);
-- CALL GetEmployeesByDept('IT');
-- CALL GetEmployeeCountByDept('IT', @total);
-- SELECT @total AS total_employees;
-- CALL UpdateEmployeeSalary(1, 43000);
-- CALL UpdateSalaryTransaction(1, 42000);
-- SELECT * FROM employee_log ORDER BY log_id DESC;
