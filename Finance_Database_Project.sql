
CREATE DATABASE finance_db;

USE finance_db;




SHOW DATABASES;


USE finance_db;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    city VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE kyc_records (
    kyc_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    document_type VARCHAR(30),
    verification_status VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE companies (
    company_id INT PRIMARY KEY AUTO_INCREMENT,
    company_name VARCHAR(100) UNIQUE NOT NULL,
    sector VARCHAR(50),
    isin VARCHAR(20) UNIQUE
);

CREATE TABLE loans (
    loan_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    principal DECIMAL(14,2) NOT NULL,
    annual_interest_rate DECIMAL(5,2),
    tenure_months INT,
    start_date DATE,
    loan_status VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE repayments (
    repayment_id INT PRIMARY KEY AUTO_INCREMENT,
    loan_id INT NOT NULL,
    due_date DATE,
    paid_date DATE,
    amount_due DECIMAL(14,2),
    amount_paid DECIMAL(14,2),
    payment_status VARCHAR(20),
    FOREIGN KEY (loan_id) REFERENCES loans(loan_id)
);

CREATE TABLE portfolios (
    portfolio_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    company_id INT NOT NULL,
    quantity DECIMAL(18,4),
    average_buy_price DECIMAL(14,2),
    purchased_on DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (company_id) REFERENCES companies(company_id)
);

CREATE TABLE stock_prices (
    stock_price_id INT PRIMARY KEY AUTO_INCREMENT,
    company_id INT NOT NULL,
    price_date DATE,
    close_price DECIMAL(14,2),
    FOREIGN KEY (company_id) REFERENCES companies(company_id)
);

CREATE TABLE financial_results (
    result_id INT PRIMARY KEY AUTO_INCREMENT,
    company_id INT NOT NULL,
    fiscal_year INT,
    fiscal_quarter INT,
    revenue DECIMAL(18,2),
    net_profit DECIMAL(18,2),
    reported_on DATE,
    FOREIGN KEY (company_id) REFERENCES companies(company_id)
);


SHOW TABLES;




USE finance_db;

INSERT INTO customers
(full_name, email, phone, city)
VALUES
('Aarav Shah', 'aarav@gmail.com', '9000000001', 'Ahmedabad'),
('Diya Mehta', 'diya@gmail.com', '9000000002', 'Ahmedabad'),
('Kabir Patel', 'kabir@gmail.com', '9000000003', 'Surat'),
('Anaya Desai', 'anaya@gmail.com', '9000000004', 'Vadodara'),
('Ishaan Rao', 'ishaan@gmail.com', '9000000005', 'Jamshedpur');





INSERT INTO companies
(company_name, sector, isin)
VALUES
('Gujarat Finance Ltd', 'Finance', 'INE100A01010'),
('Western Tech Ltd', 'Technology', 'INE200B01020'),
('Narmada Energy Ltd', 'Energy', 'INE300C01030');




SELECT * FROM customers;
SELECT * FROM companies;




USE finance_db;

INSERT INTO kyc_records
(customer_id, document_type, verification_status)
VALUES
(1, 'PAN', 'VERIFIED'),
(2, 'AADHAAR', 'VERIFIED'),
(3, 'PAN', 'PENDING'),
(4, 'AADHAAR', 'VERIFIED'),
(5, 'PAN', 'REJECTED');




INSERT INTO loans
(customer_id, principal, annual_interest_rate,
tenure_months, start_date, loan_status)
VALUES
(1, 150000, 10.50, 24, '2025-01-15', 'ACTIVE'),
(2, 250000, 11.00, 36, '2025-02-10', 'ACTIVE'),
(3, 100000, 9.50, 12, '2025-03-05', 'CLOSED'),
(4, 300000, 12.00, 48, '2025-04-20', 'ACTIVE'),
(5, 200000, 10.00, 24, '2025-05-12', 'DEFAULTED');




SELECT * FROM kyc_records;

SELECT * FROM loans;




USE finance_db;

INSERT INTO repayments
(loan_id, due_date, paid_date, amount_due, amount_paid, payment_status)
VALUES
(1, '2025-02-15', '2025-02-14', 7000, 7000, 'PAID'),
(1, '2025-03-15', '2025-03-15', 7000, 7000, 'PAID'),
(2, '2025-03-10', '2025-03-10', 8000, 8000, 'PAID'),
(2, '2025-04-10', NULL, 8000, 0, 'PENDING'),
(3, '2025-04-05', '2025-04-05', 9000, 9000, 'PAID'),
(3, '2025-05-05', '2025-05-05', 9000, 9000, 'PAID'),
(4, '2025-05-20', NULL, 10000, 5000, 'PARTIAL'),
(4, '2025-06-20', NULL, 10000, 0, 'PENDING'),
(5, '2025-06-12', NULL, 8500, 0, 'OVERDUE'),
(5, '2025-07-12', NULL, 8500, 0, 'PENDING');




SELECT * FROM repayments;




USE finance_db;

INSERT INTO portfolios
(customer_id, company_id, quantity, average_buy_price, purchased_on)
VALUES
(1, 1, 10, 100, '2025-02-01'),
(1, 2, 15, 200, '2025-02-05'),
(2, 1, 20, 110, '2025-02-10'),
(2, 3, 12, 150, '2025-02-15'),
(3, 2, 25, 190, '2025-03-01'),
(4, 3, 30, 160, '2025-03-05'),
(5, 1, 18, 105, '2025-03-10');



SELECT * FROM portfolios;

SELECT * FROM stock_prices;




USE finance_db;

INSERT INTO financial_results
(company_id, fiscal_year, fiscal_quarter,
 revenue, net_profit, reported_on)
VALUES
(1, 2025, 1, 1500000, 250000, '2025-04-30'),
(1, 2025, 2, 1800000, 300000, '2025-07-30'),
(2, 2025, 1, 2500000, 500000, '2025-04-30'),
(2, 2025, 2, 2800000, 600000, '2025-07-30'),
(3, 2025, 1, 2000000, 400000, '2025-04-30'),
(3, 2025, 2, 2300000, 450000, '2025-07-30');






SELECT * FROM financial_results;






SHOW TABLES;

SELECT COUNT(*) FROM customers;
SELECT COUNT(*) FROM loans;
SELECT COUNT(*) FROM repayments;
SELECT COUNT(*) FROM portfolios;
SELECT COUNT(*) FROM stock_prices;
SELECT COUNT(*) FROM financial_results;


USE finance_db;

SELECT * FROM customers;


SELECT city, COUNT(*) AS total_customers
FROM customers
GROUP BY city;



SELECT SUM(principal) AS total_loan_amount
FROM loans;



USE finance_db;

SELECT SUM(principal) AS total_loan_amount
FROM loans;


SELECT city, COUNT(*) AS total_customers
FROM customers
GROUP BY city;





SELECT
    c.full_name,
    SUM(l.principal) AS total_loan
FROM customers c
JOIN loans l
ON c.customer_id = l.customer_id
GROUP BY c.customer_id, c.full_name;






SELECT
    SUM(amount_paid) AS total_collected
FROM repayments;





SELECT *
FROM repayments
WHERE payment_status = 'PENDING';





SELECT
    loan_status,
    COUNT(*) AS total_loans
FROM loans
GROUP BY loan_status;



USE finance_db;

SELECT *
FROM loans
WHERE principal > (
    SELECT AVG(principal)
    FROM loans
);





SELECT
    c.full_name,
    co.company_name,
    p.quantity,
    p.average_buy_price
FROM portfolios p
JOIN customers c
ON p.customer_id = c.customer_id
JOIN companies co
ON p.company_id = co.company_id;






SELECT
    co.company_name,
    sp.price_date,
    sp.close_price
FROM stock_prices sp
JOIN companies co
ON sp.company_id = co.company_id
ORDER BY sp.close_price DESC;






SELECT
    co.company_name,
    SUM(fr.revenue) AS total_revenue,
    SUM(fr.net_profit) AS total_profit
FROM companies co
JOIN financial_results fr
ON co.company_id = fr.company_id
GROUP BY co.company_id, co.company_name;







SELECT
    payment_status,
    COUNT(*) AS total_records,
    SUM(amount_due) AS total_due,
    SUM(amount_paid) AS total_paid
FROM repayments
GROUP BY payment_status;





USE finance_db;

CREATE TABLE IF NOT EXISTS rejected_rows (
    rejected_id INT PRIMARY KEY AUTO_INCREMENT,
    source_name VARCHAR(100),
    loan_id INT,
    amount_due DECIMAL(14,2),
    amount_paid DECIMAL(14,2),
    rejection_reason VARCHAR(255),
    rejected_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);






USE finance_db;

UPDATE staging_emi
SET due_date = DATE_ADD(
    due_date,
    INTERVAL CASE
        WHEN DAYOFWEEK(due_date) = 7 THEN 2
        WHEN DAYOFWEEK(due_date) = 1 THEN 1
        ELSE 0
    END DAY
);




USE finance_db;

CREATE TEMPORARY TABLE staging_emi (
    loan_id INT,
    due_date DATE,
    amount_due DECIMAL(14,2),
    amount_paid DECIMAL(14,2)
);

INSERT INTO staging_emi VALUES
(1, '2025-08-01', 5000, 5000),
(1, '2025-08-15', -500, 0),
(2, '2025-08-20', 6000, 7000),
(999, '2025-08-25', 5000, 0),
(3, '2025-08-30', 7000, 0);







UPDATE staging_emi
SET due_date = DATE_ADD(
    due_date,
    INTERVAL CASE
        WHEN DAYOFWEEK(due_date) = 7 THEN 2
        WHEN DAYOFWEEK(due_date) = 1 THEN 1
        ELSE 0
    END DAY
);






SET SQL_SAFE_UPDATES = 0;






UPDATE staging_emi
SET due_date = DATE_ADD(
    due_date,
    INTERVAL CASE
        WHEN DAYOFWEEK(due_date) = 7 THEN 2
        WHEN DAYOFWEEK(due_date) = 1 THEN 1
        ELSE 0
    END DAY
);









SELECT * FROM staging_emi;






USE finance_db;

INSERT INTO repayments
(loan_id, due_date, amount_due, amount_paid, payment_status)
SELECT
    s.loan_id,
    s.due_date,
    s.amount_due,
    s.amount_paid,
    CASE
        WHEN s.amount_paid = s.amount_due THEN 'PAID'
        WHEN s.amount_paid > 0 THEN 'PARTIAL'
        ELSE 'PENDING'
    END
FROM staging_emi s
WHERE s.amount_due > 0
AND s.amount_paid BETWEEN 0 AND s.amount_due
AND EXISTS (
    SELECT 1 FROM loans l
    WHERE l.loan_id = s.loan_id
)
AND NOT EXISTS (
    SELECT 1 FROM repayments r
    WHERE r.loan_id = s.loan_id
    AND r.due_date = s.due_date
);











SELECT * FROM repayments
ORDER BY repayment_id DESC;

SELECT * FROM rejected_rows;








USE finance_db;

CREATE OR REPLACE VIEW loan_repayment_summary AS
SELECT
    l.loan_id,
    c.full_name,
    l.principal,
    l.loan_status,
    COALESCE(SUM(r.amount_due), 0) AS total_due,
    COALESCE(SUM(r.amount_paid), 0) AS total_collected,
    COALESCE(SUM(r.amount_due - r.amount_paid), 0) AS balance
FROM loans l
JOIN customers c
    ON l.customer_id = c.customer_id
LEFT JOIN repayments r
    ON l.loan_id = r.loan_id
GROUP BY
    l.loan_id,
    c.full_name,
    l.principal,
    l.loan_status;






CREATE OR REPLACE VIEW customer_portfolio_summary AS
SELECT
    c.full_name,
    co.company_name,
    p.quantity,
    p.average_buy_price,
    (p.quantity * p.average_buy_price) AS investment_value
FROM portfolios p
JOIN customers c
    ON p.customer_id = c.customer_id
JOIN companies co
    ON p.company_id = co.company_id;







SELECT * FROM loan_repayment_summary;

SELECT * FROM customer_portfolio_summary;









USE finance_db;

CREATE TABLE IF NOT EXISTS monthly_summary (
    summary_month DATE PRIMARY KEY,
    total_due DECIMAL(14,2),
    total_collected DECIMAL(14,2),
    collection_rate DECIMAL(7,2),
    generated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);









DELIMITER //

CREATE PROCEDURE refresh_monthly_summary(IN p_month DATE)
BEGIN
    DECLARE v_due DECIMAL(14,2) DEFAULT 0;
    DECLARE v_paid DECIMAL(14,2) DEFAULT 0;
    DECLARE v_month DATE;

    SET v_month = DATE_SUB(
        p_month,
        INTERVAL DAYOFMONTH(p_month) - 1 DAY
    );

    SELECT
        COALESCE(SUM(amount_due), 0),
        COALESCE(SUM(amount_paid), 0)
    INTO v_due, v_paid
    FROM repayments
    WHERE due_date >= v_month
      AND due_date < DATE_ADD(v_month, INTERVAL 1 MONTH);

    INSERT INTO monthly_summary
    (summary_month, total_due, total_collected, collection_rate)
    VALUES (
        v_month,
        v_due,
        v_paid,
        COALESCE(ROUND(100 * v_paid / NULLIF(v_due, 0), 2), 0)
    )
    ON DUPLICATE KEY UPDATE
        total_due = VALUES(total_due),
        total_collected = VALUES(total_collected),
        collection_rate = VALUES(collection_rate),
        generated_at = CURRENT_TIMESTAMP;
END //

DELIMITER ;








CALL refresh_monthly_summary('2025-03-01');







SELECT * FROM monthly_summary;








USE finance_db;

CREATE TABLE IF NOT EXISTS audit_log (
    audit_id INT PRIMARY KEY AUTO_INCREMENT,
    table_name VARCHAR(50),
    operation VARCHAR(20),
    record_id INT,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);







DELIMITER //

CREATE TRIGGER repayment_after_insert
AFTER INSERT ON repayments
FOR EACH ROW
BEGIN
    INSERT INTO audit_log
    (table_name, operation, record_id)
    VALUES ('repayments', 'INSERT', NEW.repayment_id);
END //

DELIMITER ;








DELIMITER //

CREATE TRIGGER repayment_after_update
AFTER UPDATE ON repayments
FOR EACH ROW
BEGIN
    INSERT INTO audit_log
    (table_name, operation, record_id)
    VALUES ('repayments', 'UPDATE', NEW.repayment_id);
END //

DELIMITER ;





DELIMITER //

CREATE TRIGGER repayment_after_delete
AFTER DELETE ON repayments
FOR EACH ROW
BEGIN
    INSERT INTO audit_log
    (table_name, operation, record_id)
    VALUES ('repayments', 'DELETE', OLD.repayment_id);
END //

DELIMITER ;







UPDATE repayments
SET amount_paid = 7000
WHERE repayment_id = 1;

SELECT * FROM audit_log;





USE finance_db;

CREATE INDEX idx_repayments_due_date
ON repayments(due_date);

CREATE INDEX idx_repayments_loan_id
ON repayments(loan_id);

CREATE INDEX idx_loans_customer_id
ON loans(customer_id);

CREATE INDEX idx_portfolios_customer_id
ON portfolios(customer_id);


EXPLAIN
SELECT loan_id,
       SUM(amount_due) AS total_due,
       SUM(amount_paid) AS total_paid
FROM repayments
WHERE due_date >= '2025-01-01'
GROUP BY loan_id;





EXPLAIN ANALYZE
SELECT
    l.loan_id,
    c.full_name,
    SUM(r.amount_due) AS total_due,
    SUM(r.amount_paid) AS total_paid
FROM loans l
JOIN customers c ON l.customer_id = c.customer_id
JOIN repayments r ON l.loan_id = r.loan_id
WHERE r.due_date >= '2025-01-01'
GROUP BY l.loan_id, c.full_name;





USE finance_db;

SET SESSION cte_max_recursion_depth = 1000000;




INSERT INTO repayments
    (loan_id, due_date, paid_date, amount_due, amount_paid, payment_status)
WITH RECURSIVE seq AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM seq WHERE n < 900000
)
SELECT
    1,
    DATE_ADD('2026-01-01', INTERVAL n DAY),
    NULL,
    5000,
    CASE WHEN MOD(n, 4) = 0 THEN 0 ELSE 5000 END,
    CASE WHEN MOD(n, 4) = 0 THEN 'PENDING' ELSE 'PAID' END
FROM seq;




USE finance_db;

SELECT @@cte_max_recursion_depth;

SET SESSION cte_max_recursion_depth = 1000000;


SELECT @@cte_max_recursion_depth;



SELECT @@cte_max_recursion_depth;



SELECT COUNT(*) AS total_records
FROM repayments;




USE finance_db;

SELECT COUNT(*) AS total_records
FROM repayments;



EXPLAIN
SELECT
    loan_id,
    COUNT(*) AS total_payments,
    SUM(amount_due) AS total_due,
    SUM(amount_paid) AS total_paid
FROM repayments
WHERE due_date >= '2026-01-01'
GROUP BY loan_id;





SELECT COUNT(*) AS total_records
FROM repayments;




SHOW TABLES;





SHOW FULL TABLES
WHERE Table_type = 'VIEW';








USE finance_db;

SHOW TABLES;







USE finance_db;

SELECT 
    'customers' AS table_name, COUNT(*) AS total
FROM
    customers 
UNION ALL SELECT 
    'companies', COUNT(*)
FROM
    companies 
UNION ALL SELECT 
    'loans', COUNT(*)
FROM
    loans 
UNION ALL SELECT 
    'repayments', COUNT(*)
FROM
    repayments 
UNION ALL SELECT 
    'portfolios', COUNT(*)
FROM
    portfolios 
UNION ALL SELECT 
    'kyc_records', COUNT(*)
FROM
    kyc_records 
UNION ALL SELECT 
    'financial_results', COUNT(*)
FROM
    financial_results 
UNION ALL SELECT 
    'stock_prices', COUNT(*)
FROM
    stock_prices 
UNION ALL SELECT 
    'rejected_rows', COUNT(*)
FROM
    rejected_rows;
    
    
    
    
    
    
    USE finance_db;

INSERT INTO stock_prices
(company_id, price_date, close_price)
VALUES
(1, '2025-01-01', 120.50),
(1, '2025-02-01', 125.75),
(2, '2025-01-01', 250.00),
(2, '2025-02-01', 265.50),
(3, '2025-01-01', 180.00),
(3, '2025-02-01', 190.25);

SELECT * FROM stock_prices;








USE finance_db;

INSERT INTO rejected_rows
(source_name, loan_id, amount_due, amount_paid, rejection_reason)
SELECT
    'staging_emi',
    s.loan_id,
    s.amount_due,
    s.amount_paid,
    CASE
        WHEN s.amount_due <= 0 THEN 'Invalid amount due'
        WHEN s.amount_paid < 0 THEN 'Negative payment'
        WHEN s.amount_paid > s.amount_due THEN 'Payment exceeds due'
        WHEN l.loan_id IS NULL THEN 'Invalid loan ID'
    END
FROM staging_emi s
LEFT JOIN loans l
ON s.loan_id = l.loan_id
WHERE s.amount_due <= 0
   OR s.amount_paid < 0
   OR s.amount_paid > s.amount_due
   OR l.loan_id IS NULL;

SELECT * FROM rejected_rows;







USE finance_db;

INSERT INTO repayments
(loan_id, due_date, amount_due, amount_paid, payment_status)
SELECT
    s.loan_id,
    s.due_date,
    s.amount_due,
    s.amount_paid,
    CASE
        WHEN s.amount_paid = s.amount_due THEN 'PAID'
        WHEN s.amount_paid > 0 THEN 'PARTIAL'
        ELSE 'PENDING'
    END
FROM staging_emi s
WHERE s.amount_due > 0
AND s.amount_paid BETWEEN 0 AND s.amount_due
AND EXISTS (
    SELECT 1
    FROM loans l
    WHERE l.loan_id = s.loan_id
)
AND NOT EXISTS (
    SELECT 1
    FROM repayments r
    WHERE r.loan_id = s.loan_id
    AND r.due_date = s.due_date
);

SELECT * FROM repayments
ORDER BY repayment_id DESC;

USE finance_db;

CREATE TEMPORARY TABLE staging_emi (
    loan_id INT,
    due_date DATE,
    amount_due DECIMAL(14,2),
    amount_paid DECIMAL(14,2)
);

INSERT INTO staging_emi VALUES
(1, '2025-08-01', 5000, 5000),
(1, '2025-08-15', -500, 0),
(2, '2025-08-20', 6000, 7000),
(999, '2025-08-25', 5000, 0),
(3, '2025-08-30', 7000, 0);

SELECT * FROM staging_emi;











USE finance_db;

SELECT
    (SELECT COUNT(*) FROM customers) AS customers,
    (SELECT COUNT(*) FROM loans) AS loans,
    (SELECT COUNT(*) FROM repayments) AS repayments,
    (SELECT COUNT(*) FROM stock_prices) AS stock_prices,
    (SELECT COUNT(*) FROM rejected_rows) AS rejected_records;
    
    
    
    
    
    
    
    USE finance_db;

EXPLAIN
SELECT
    loan_id,
    COUNT(*) AS total_payments,
    SUM(amount_due) AS total_due,
    SUM(amount_paid) AS total_paid
FROM repayments
WHERE due_date >= '2025-01-01'
GROUP BY loan_id;






USE finance_db;

EXPLAIN ANALYZE
SELECT
    l.loan_id,
    c.full_name,
    SUM(r.amount_due) AS total_due,
    SUM(r.amount_paid) AS total_paid
FROM loans l
JOIN customers c
    ON l.customer_id = c.customer_id
JOIN repayments r
    ON l.loan_id = r.loan_id
WHERE r.due_date >= '2025-01-01'
GROUP BY l.loan_id, c.full_name;






USE finance_db;

SHOW INDEX FROM repayments;






USE finance_db;

CREATE INDEX idx_repayments_due_date
ON repayments(due_date);

SHOW INDEX FROM repayments;








USE finance_db;

EXPLAIN
SELECT *
FROM repayments
WHERE due_date >= '2025-01-01';








USE finance_db;

EXPLAIN
SELECT *
FROM repayments FORCE INDEX (idx_repayments_due_date)
WHERE due_date >= '2025-01-01';









USE finance_db;

SET SESSION cte_max_recursion_depth = 10000;

INSERT INTO repayments
(loan_id, due_date, paid_date, amount_due, amount_paid, payment_status)
WITH RECURSIVE seq AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM seq WHERE n < 10000
)
SELECT
    1,
    DATE_ADD('2026-01-01', INTERVAL n DAY),
    NULL,
    5000,
    CASE WHEN MOD(n, 4) = 0 THEN 0 ELSE 5000 END,
    CASE WHEN MOD(n, 4) = 0 THEN 'PENDING' ELSE 'PAID' END
FROM seq;







USE finance_db;

SELECT COUNT(*) AS total_repayments
FROM repayments;







SELECT
    payment_status,
    COUNT(*) AS total_records
FROM repayments
GROUP BY payment_status;






USE finance_db;

SELECT
    payment_status,
    COUNT(*) AS total_records,
    SUM(amount_due) AS total_due,
    SUM(amount_paid) AS total_paid
FROM repayments
GROUP BY payment_status
ORDER BY total_records DESC;







USE finance_db;

EXPLAIN
SELECT *
FROM repayments
WHERE due_date >= '2026-01-01'
AND due_date < '2026-02-01';





USE finance_db;

EXPLAIN ANALYZE
SELECT *
FROM repayments
WHERE due_date >= '2026-01-01'
AND due_date < '2026-02-01';







USE finance_db;

CREATE OR REPLACE VIEW monthly_payment_summary AS
SELECT
    DATE_FORMAT(due_date, '%Y-%m') AS payment_month,
    COUNT(*) AS total_payments,
    SUM(amount_due) AS total_due,
    SUM(amount_paid) AS total_paid,
    SUM(amount_due - amount_paid) AS outstanding_amount
FROM repayments
GROUP BY DATE_FORMAT(due_date, '%Y-%m');







SELECT * FROM monthly_payment_summary;





USE finance_db;

SELECT
    COUNT(*) AS total_months,
    MIN(payment_month) AS first_month,
    MAX(payment_month) AS last_month,
    SUM(total_payments) AS total_payments,
    SUM(total_due) AS total_due,
    SUM(total_paid) AS total_paid,
    SUM(outstanding_amount) AS total_outstanding
FROM monthly_payment_summary;






USE finance_db;

SELECT
    COUNT(*) AS total_repayments,
    SUM(amount_due) AS original_total_due,
    SUM(amount_paid) AS original_total_paid
FROM repayments;