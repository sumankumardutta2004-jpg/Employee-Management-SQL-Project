-- YuvaIntern Week 3: Implementing Data Security and Access Control Protocols
-- Database: employee_management
-- Run administrator commands from an administrator/root connection.
-- Replace the sample password with a unique secret. Never commit real credentials.

USE employee_management;

-- 1. Create a least-privilege read-only role.
CREATE ROLE IF NOT EXISTS 'employee_readonly';
GRANT SELECT ON employee_management.employees TO 'employee_readonly';
GRANT SELECT ON employee_management.departments TO 'employee_readonly';

-- 2. Create a dedicated reporting account and assign the role.
-- If this account already exists, review its password and grants separately.
CREATE USER IF NOT EXISTS 'report_user'@'localhost'
IDENTIFIED BY 'Replace-With-A-Unique-Strong-Password!';
GRANT 'employee_readonly' TO 'report_user'@'localhost';
SET DEFAULT ROLE 'employee_readonly' TO 'report_user'@'localhost';

-- 3. Verify grants as administrator.
SHOW GRANTS FOR 'report_user'@'localhost';

-- 4. Inspect tables in this project database.
SELECT TABLE_NAME, TABLE_TYPE
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'employee_management';

-- 5. Check SSL support and whether THIS session uses an SSL cipher.
SHOW VARIABLES LIKE 'have_ssl';
SHOW STATUS LIKE 'Ssl_cipher';

-- 6. Parameterized query example (run in employee_management).
PREPARE safe_query FROM
'SELECT * FROM employees WHERE department = ?';
SET @dept = 'IT';
EXECUTE safe_query USING @dept;
DEALLOCATE PREPARE safe_query;

-- 7. Review activity records, if employee_log exists.
SELECT *
FROM employee_log
ORDER BY action_time DESC;

-- 8. Review authentication metadata (administrator privileges required).
SELECT User, Host, plugin, password_expired
FROM mysql.user
WHERE User = 'report_user';

-- 9. Inspect database-level privilege records.
SELECT User, Host, Db, Select_priv, Insert_priv, Update_priv, Delete_priv
FROM mysql.db
WHERE Db = 'employee_management';

-- 10. Basic data-quality check.
SELECT COUNT(*) AS total_employees,
       COUNT(DISTINCT email) AS unique_emails,
       COUNT(*) - COUNT(DISTINCT email) AS duplicate_emails
FROM employees;

-- 11. IMPORTANT: verify read-only behavior in a SEPARATE report_user connection.
-- SELECT should succeed:
-- USE employee_management;
-- SELECT * FROM employees;
-- UPDATE should fail with a permission error. Do NOT run this test as root:
-- UPDATE employees SET salary = 45000 WHERE employee_id = 1;

-- Reporting note:
-- A supported SSL setting does not prove the current session is encrypted.
-- A non-empty Ssl_cipher indicates the current session is using SSL/TLS.
-- Do not claim password policy, TLS, or access-denial tests passed until verified.
