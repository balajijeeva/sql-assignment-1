1 #Write an SQL query to identify the top 2 performing employees in each region
 based on their total sales.

The query should:
    - Use a CTE to calculate total sales per employee per region
    - Use ROW_NUMBER() window function to rank employees within each region
    - Join with EMPLOYEES table to get employee names and departments
    - Display: employee_name, department, region, total_sales, and rank_in_region
    - Only show the top 2 employees per region
    - Sort results by region, then by rank

CREATE TABLE SALES (
    ID INT,
    EMPLOYEE_ID INT,
    REGION VARCHAR(50),
    SALES_AMOUNT DECIMAL(10,2)
);

CREATE TABLE EMPLOYEES (
    EMPLOYEE_ID INT,
    EMPLOYEE_NAME VARCHAR(100),
    DEPARTMENT VARCHAR(50),
    REGION VARCHAR(50)
    
);


CREATE TABLE SALES (
    ID INT,
    EMPLOYEE_ID INT,
    REGION VARCHAR(50),
    SALES_AMOUNT DECIMAL(10,2)
);

CREATE TABLE PURCHASE (
    ID INT,
    PRODUCT_ID INT,
    SUPPLIER_NAME VARCHAR(100),
    PURCHASE_AMOUNT DECIMAL(10,2)
);

SHOW TABLES;
INSERT INTO EMPLOYEES (EMPLOYEE_ID, EMPLOYEE_NAME, DEPARTMENT, REGION)
VALUES
(1, 'Priya Sharma', 'Sales', 'North'),
(2, 'Vikram Singh', 'Sales', 'North'),
(3, 'Sneha Reddy', 'Sales', 'South'),
(4, 'Rahul Mehta', 'Sales', 'South');


INSERT INTO SALES (ID, EMPLOYEE_ID, REGION, SALES_AMOUNT)
VALUES
(1, 1, 'North', 80000),
(2, 1, 'North', 72000),
(3, 2, 'North', 90000),
(4, 2, 'North', 58000),
(5, 3, 'South', 100000),
(6, 3, 'South', 72000),
(7, 4, 'South', 60000);

WITH employee_sales AS (
    SELECT 
        e.EMPLOYEE_ID,
        e.EMPLOYEE_NAME,
        e.DEPARTMENT,
        e.REGION,
        SUM(s.SALES_AMOUNT) AS TOTAL_SALES
    FROM SALES s
    JOIN EMPLOYEES e
        ON s.EMPLOYEE_ID = e.EMPLOYEE_ID
    GROUP BY 
        e.EMPLOYEE_ID,
        e.EMPLOYEE_NAME,
        e.DEPARTMENT,
        e.REGION
)

SELECT 
    EMPLOYEE_NAME,
    DEPARTMENT,
    REGION,
    TOTAL_SALES,
    ROW_NUMBER() OVER (
        PARTITION BY REGION
        ORDER BY TOTAL_SALES DESC
    ) AS RANK_IN_REGION
FROM employee_sales;

Question 2: Employee Target Achievement Analysis
--------------------------------------------------

Write an SQL query to analyze target achievement for all sales employees
across all months, including employees who haven't made any sales.

The query should:
    - Use LEFT JOIN to include all employees even without sales
    - Use a subquery or CTE to calculate actual monthly sales per employee
    - Compare actual sales vs monthly targets
    - Calculate achievement percentage: (actual_sales / target_amount * 100)
    - Display: employee_name, month, target_amount, actual_sales, 
               variance (actual - target), achievement_percentage, status
    - Status: 'Exceeded' if >= 100%, 'Met' if >= 90%, 'Below' if < 90%
    - Sort by month, then achievement percentage descending

    
CREATE DATABASE SALES_DB;
USE DATABASE SALES_DB;

CREATE SCHEMA PUBLIC;
USE SCHEMA PUBLIC;

CREATE TABLE EMPLOYEES (
    EMPLOYEE_ID INT,
    EMPLOYEE_NAME STRING,
    DEPARTMENT STRING,
    REGION STRING,
    TARGET_AMOUNT  NUMBER(12,2)

);
    
CREATE TABLE SALES (
    SALE_ID INT,
    EMPLOYEE_ID INT,
    SALE_DATE DATE,
    SALE_AMOUNT NUMBER(10,2)
); 


INSERT INTO EMPLOYEES (EMPLOYEE_ID, EMPLOYEE_NAME, REGION, TARGET_AMOUNT) VALUES
(1, 'Amit', 'North', 100000),
(2, 'Priya', 'North', 120000),
(3, 'Rahul', 'South', 90000),
(4, 'Sneha', 'South', 95000),
(5, 'Karan', 'West', 110000);

INSERT INTO SALES (SALE_ID, EMPLOYEE_ID, SALE_DATE, SALE_AMOUNT) VALUES
(101, 1, '2024-01-10', 40000),
(102, 5, '2024-01-20', 70000),
(103, 2, '2024-01-15', 100000),
(104, 3, '2024-01-12', 50000),
(105, 3, '2024-01-25', 30000),
(106, 1, '2024-02-05', 20000),
(107, 2, '2024-02-14', 90000),
(108, 4, '2024-02-20', 40000);

SELECT * FROM EMPLOYEES LIMIT 5;

WITH monthly_sales AS (
    SELECT 
        EMPLOYEE_ID,
        DATE_TRUNC('MONTH', SALE_DATE) AS SALE_MONTH,
        SUM(SALE_AMOUNT) AS ACTUAL_SALES
    FROM SALES
    GROUP BY EMPLOYEE_ID, DATE_TRUNC('MONTH', SALE_DATE)
)

SELECT 
    e.EMPLOYEE_NAME,
    ms.SALE_MONTH,
    e.TARGET_AMOUNT,
    COALESCE(ms.ACTUAL_SALES, 0) AS ACTUAL_SALES,
    COALESCE(ms.ACTUAL_SALES, 0) - e.TARGET_AMOUNT  AS VARIANCE,
    
    ROUND(
        (COALESCE(ms.ACTUAL_SALES, 0) / e.TARGET_AMOUNT ) * 100,
        2
    ) AS ACHIEVEMENT_PERCENTAGE,
    
    CASE
        WHEN (COALESCE(ms.ACTUAL_SALES, 0) / e.TARGET_AMOUNT ) * 100 >= 100 
            THEN 'Exceeded'
        WHEN (COALESCE(ms.ACTUAL_SALES, 0) / e.TARGET_AMOUNT ) * 100 >= 90 
            THEN 'Met'
        ELSE 'Below'
    END AS STATUS

FROM EMPLOYEES e
LEFT JOIN monthly_sales ms
    ON e.EMPLOYEE_ID = ms.EMPLOYEE_ID

ORDER BY ms.SALE_MONTH, ACHIEVEMENT_PERCENTAGE DESC;

Question 3: Product Category Performance with Rankings
--------------------------------------------------

# Write an SQL query to analyze product category performance across all regions
        and identify top categories.

#The query should:
    - Calculate total sales, total quantity, and transaction count per category per region
    - Use RANK() and DENSE_RANK() to rank categories by sales within each region
    - Use a subquery to find the overall best-selling category
    - Calculate what percentage each category contributes to regional sales
    - Display: region, product_category, total_sales, total_quantity, 
               transaction_count, sales_rank, dense_rank, pct_of_regional_sales
    - Only show categories with sales > 50000
    - Sort by region, then sales_rank

    CREATE TABLE REGIONAL_SALES_SUMMARY (
    REGION VARCHAR(50),
    PRODUCT_CATEGORY VARCHAR(100),
    
    TOTAL_SALES DECIMAL(12,2),
    TOTAL_QUANTITY INT,
    TRANSACTION_COUNT INT,
    
    SALES_RANK INT,
    DENSE_RANK INT,
    
    PCT_OF_REGIONAL_SALES DECIMAL(5,2)
);

CREATE TABLE ORDERS (
    ORDER_ID INT,
    CUSTOMER_ID INT,
    PRODUCT_ID INT,
    SALES_AMOUNT DECIMAL(12,2),
    QUANTITY INT,
    ORDER_DATE DATE
);

SHOW TABLES ;

INSERT INTO REGIONAL_SALES_SUMMARY
(REGION, PRODUCT_CATEGORY, TOTAL_SALES, TOTAL_QUANTITY,
 TRANSACTION_COUNT, SALES_RANK, DENSE_RANK, PCT_OF_REGIONAL_SALES)
VALUES
('North', 'Electronics', 230000, 15, 8, 1, 1, 68.45),
('North', 'Home', 57000, 18, 4, 2, 2, 16.96),
('South', 'Electronics', 172000, 12, 6, 1, 1, 72.58);

SHOW TABLES ;

WITH regional_data AS (
    SELECT
        C.REGION,
        P.CATEGORY AS PRODUCT_CATEGORY,
        SUM(O.SALES_AMOUNT) AS CATEGORY_SALES,
        SUM(O.QUANTITY) AS TOTAL_QUANTITY,
        COUNT(*) AS TRANSACTION_COUNT
    FROM ORDERS O
    JOIN CUSTOMERS C 
        ON O.CUSTOMER_ID = C.CUSTOMER_ID
    JOIN PRODUCTS P 
        ON O.PRODUCT_ID = P.PRODUCT_ID
    GROUP BY C.REGION, P.CATEGORY
)

SELECT
    REGION,
    PRODUCT_CATEGORY,
    CATEGORY_SALES,
    TOTAL_QUANTITY,
    TRANSACTION_COUNT,

    RANK() OVER (
        PARTITION BY REGION
        ORDER BY CATEGORY_SALES DESC
    ) AS SALES_RANK,

    DENSE_RANK() OVER (
        PARTITION BY REGION
        ORDER BY CATEGORY_SALES DESC
    ) AS DENSE_RANK,

    ROUND(
        (CATEGORY_SALES /
         SUM(CATEGORY_SALES) OVER (PARTITION BY REGION)
        ) * 100,
    2) AS PCT_OF_REGIONAL_SALES

FROM regional_data
WHERE CATEGORY_SALES > 50000
ORDER BY REGION, CATEGORY_SALES DESC;

SELECT CURRENT_DATABASE(), CURRENT_SCHEMA();

-- CTE to calculate total sales per employee
WITH employee_sales AS (
    SELECT 
        e.employee_id,
        COALESCE(SUM(s.sale_amount), 0) AS total_sales
    FROM employees e
    LEFT JOIN sales s 
        ON e.employee_id = s.employee_id
    GROUP BY e.employee_id
),

-- CTE to rank employees within department
ranked_employees AS (
    SELECT
        e.employee_id,
        e.employee_name,
        e.manager_id,
        e.department,
        e.salary,
        es.total_sales,
        RANK() OVER (
            PARTITION BY e.department 
            ORDER BY es.total_sales DESC
        ) AS dept_sales_rank
    FROM employees e
    LEFT JOIN employee_sales es
        ON e.employee_id = es.employee_id
)

SELECT
    re.employee_name,
    m.employee_name AS manager_name,         -- Self Join
    re.department,
    re.salary,
    re.total_sales,
    re.dept_sales_rank,
    CASE 
        WHEN re.dept_sales_rank = 1 THEN 'Y'
        ELSE 'N'
    END AS is_top_in_dept
FROM ranked_employees re
LEFT JOIN employees m                 -- Self-join for manager relationship
    ON re.manager_id = m.employee_id
ORDER BY 
    re.department,
    re.dept_sales_rank;

-- =====================================================
-- 1️⃣ CREATE TABLES
-- =====================================================

CREATE OR REPLACE TABLE employees (
    employee_id     INT PRIMARY KEY,
    employee_name   VARCHAR(100) NOT NULL
);

CREATE OR REPLACE TABLE sales (
    sale_id         INT,
    employee_id     INT,
    sale_date       DATE,
    sales_amount    DECIMAL(12,2)
);

-- =====================================================
-- 2️⃣ INSERT SAMPLE DATA
-- =====================================================

INSERT INTO employees VALUES
(1, 'Priya Sharma'),
(2, 'Sneha Reddy'),
(3, 'Vikram Singh'),
(4, 'Amit Patel');

INSERT INTO sales VALUES
-- January 2024
(101, 1, '2024-01-05', 70000),
(102, 1, '2024-01-20', 64000),
(103, 2, '2024-01-10', 101000),
(104, 3, '2024-01-12', 74000),
(105, 4, '2024-01-18', 68000),

-- February 2024
(106, 1, '2024-02-08', 92000),
(107, 2, '2024-02-14', 35000),
(108, 4, '2024-02-25', 51500);

-- =====================================================
-- 3️⃣ ANALYTICS QUERY USING 3 CTEs
-- =====================================================

WITH MonthlySales AS (
    -- CTE 1: Monthly sales per employee
    SELECT
        employee_id,
        DATE_TRUNC('MONTH', sale_date) AS month,
        SUM(sales_amount) AS monthly_sales
    FROM sales
    GROUP BY employee_id, DATE_TRUNC('MONTH', sale_date)
),

EmployeeAvg AS (
    -- CTE 2: Average of monthly totals per employee
    SELECT
        employee_id,
        AVG(monthly_sales) AS employee_avg_monthly_sales
    FROM MonthlySales
    GROUP BY employee_id
),

MonthlyRanking AS (
    -- CTE 3: Rank employees within each month
    SELECT
        ms.employee_id,
        ms.month,
        ms.monthly_sales,
        ea.employee_avg_monthly_sales,

        RANK() OVER (
            PARTITION BY ms.month
            ORDER BY ms.monthly_sales DESC
        ) AS rank_in_month

    FROM MonthlySales ms
    JOIN EmployeeAvg ea
        ON ms.employee_id = ea.employee_id
)

-- =====================================================
-- 4️⃣ FINAL OUTPUT
-- =====================================================

SELECT
    e.employee_name,
    TO_CHAR(mr.month, 'YYYY-MM') AS month,
    mr.monthly_sales,
    ROUND(mr.employee_avg_monthly_sales, 2) AS employee_avg_monthly_sales,
    mr.rank_in_month,

    CASE
        WHEN mr.monthly_sales > mr.employee_avg_monthly_sales THEN 'Above Average'
        WHEN mr.monthly_sales = mr.employee_avg_monthly_sales THEN 'At Average'
        ELSE 'Below Average'
    END AS performance_vs_own_avg,

    ROUND(mr.monthly_sales - mr.employee_avg_monthly_sales, 2) AS variance_from_avg,

    CASE
        WHEN mr.rank_in_month = 1 THEN 'Y'
        ELSE 'N'
    END AS best_month

FROM MonthlyRanking mr
JOIN employees e
    ON mr.employee_id = e.employee_id

ORDER BY mr.month, mr.rank_in_month;