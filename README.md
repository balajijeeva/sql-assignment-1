# sql-assignment-1
assignment Ecommerce

CREATE  database sql_learning_db;
use database sql_learning_db;

CREATE SCHEMA ECOMMERCE;

use schema ECOMMERCE;

create  table CUSTOMERS (
    CUSTOMER_ID INT,
    CUSTOMER_NAME VARCHAR(100),
    EMAIL VARCHAR(100),
    CITY VARCHAR(100),
    STATE VARCHAR(50),
    REGISTRATION_DATE DATE
);
CREATE  TABLE PRODUCTS (
    PRODUCT_ID INT PRIMARY KEY,
    PRODUCT_NAME VARCHAR(100),
    CATEGORY VARCHAR(50),
    PRICE DECIMAL(10,2),
    STOCK_QUANTITY INT
);
CREATE TABLE ORDERS (
    ORDER_ID INT PRIMARY KEY,
    CUSTOMER_ID INT,
    ORDER_DATE DATE,
    TOTAL_AMOUNT DECIMAL(10,2),
    STATUS VARCHAR(20)
);
CREATE  TABLE ORDER_ITEMS (
    ORDER_ITEM_ID INT PRIMARY KEY,
    ORDER_ID INT,
    PRODUCT_ID INT,
    QUANTITY INT,
    UNIT_PRICE DECIMAL(10,2)
    );
    
-- Table 1: CUSTOMERS
create table CUSTOMERS (
    CUSTOMER_ID INT,
    CUSTOMER_NAME VARCHAR(100),
    EMAIL VARCHAR(100),
    CITY VARCHAR(100),
    STATE VARCHAR(50),
    REGISTRATION_DATE DATE
);

-- Table 2: PRODUCTS
CREATE TABLE PRODUCTS (
    PRODUCT_ID INT PRIMARY KEY,
    PRODUCT_NAME VARCHAR(100),
    CATEGORY VARCHAR(50),
    PRICE DECIMAL(10,2),
    STOCK_QUANTITY INT
);

-- Table 3: ORDERS
CREATE TABLE ORDERS (
    ORDER_ID INT PRIMARY KEY,
    CUSTOMER_ID INT,
    ORDER_DATE DATE,
    TOTAL_AMOUNT DECIMAL(10,2),
    STATUS VARCHAR(20)
);

-- Table 4: ORDER_ITEMS
CREATE TABLE ORDER_ITEMS (
    ORDER_ITEM_ID INT PRIMARY KEY,
    ORDER_ID INT,
    PRODUCT_ID INT,
    QUANTITY INT,
    UNIT_PRICE DECIMAL(10,2)
);

SHOW TABLES;

-- Insert Customers
INSERT INTO CUSTOMERS VALUES
(1, 'Amit Kumar', 'amit.kumar@email.com', 'Mumbai', 'Maharashtra', '2023-01-15'),
(2, 'Priya Sharma', 'priya.sharma@email.com', 'Delhi', 'Delhi', '2023-02-20')
,(3, 'Rahul Verma', 'rahul.verma@email.com', 'Bangalore', 'Karnataka', '2023-03-10')
,(4, 'Sneha Patel', 'sneha.patel@email.com', 'Mumbai', 'Maharashtra', '2023-04-05'),
(5, 'Rajesh Singh', 'rajesh.singh@email.com', 'Kolkata', 'West Bengal', '2023-05-12'),
(6, 'Neha Gupta', 'neha.gupta@email.com', 'Chennai', 'Tamil Nadu', '2023-06-18'),
(7, 'Vikram Roy', 'vikram.roy@email.com', 'Pune', 'Maharashtra', '2023-07-22'),
(8, 'Anjali Das', 'anjali.das@email.com', 'Hyderabad', 'Telangana', '2023-08-30');



-- Insert Products
INSERT INTO PRODUCTS VALUES
(101, 'Laptop Pro 15', 'Electronics', 75000.00, 50),
(102, 'Wireless Mouse', 'Electronics', 800.00, 200),
(103, 'USB-C Cable', 'Accessories', 350.00, 500),
(104, 'Mechanical Keyboard', 'Electronics', 4500.00, 80),
(105, 'Monitor 24"', 'Electronics', 15000.00, 40),
(106, 'Laptop Bag', 'Accessories', 1500.00, 150),
(107, 'Webcam HD', 'Electronics', 3500.00, 60),
(108, 'Headphones', 'Electronics', 2500.00, 100),
(109, 'Phone Stand', 'Accessories', 450.00, 300),
(110, 'External SSD 1TB', 'Electronics', 8500.00, 70);

--Insert into Orders table
INSERT INTO ORDERS VALUES
(1001, 1, '2024-01-10', 75800.00, 'Delivered'),
(1002, 2, '2024-01-12', 19500.00, 'Delivered'),
(1003, 3, '2024-01-15', 8150.00, 'Delivered'),
(1004, 1, '2024-01-18', 16300.00, 'Delivered'),
(1005, 4, '2024-01-20', 5300.00, 'Shipped'),
(1006, 5, '2024-01-22', 78000.00, 'Processing'),
(1007, 2, '2024-01-25', 2850.00, 'Delivered'),
(1008, 6, '2024-01-28', 12000.00, 'Delivered');

-- Insert Order Items
INSERT INTO ORDER_ITEMS VALUES
(1, 1001, 101, 1, 75000.00),  
(2, 1001, 102, 1, 800.00),     
(3, 1002, 105, 1, 15000.00),   
(4, 1002, 104, 1, 4500.00),    -- Priya: Keyboard
(5, 1003, 107, 1, 3500.00),    -- Rahul: Webcam
(6, 1003, 104, 1, 4500.00),    -- Rahul: Keyboard
(7, 1003, 103, 5, 350.00),     -- Rahul: 5 Cables
(8, 1004, 105, 1, 15000.00),   -- Amit: Monitor
(9, 1004, 106, 1, 1500.00),    -- Amit: Bag
(10, 1005, 108, 2, 2500.00),   -- Sneha: 2 Headphones
(11, 1005, 109, 1, 450.00),    -- Sneha: Phone Stand
(12, 1006, 101, 1, 75000.00),  -- Rajesh: Laptop
(13, 1006, 110, 1, 8500.00),   -- Rajesh: SSD
(14, 1007, 108, 1, 2500.00),   -- Priya: Headphones
(15, 1007, 103, 1, 350.00),    -- Priya: Cable
(16, 1008, 105, 1, 15000.00);  -- Neha: Monitor


#Question 1: Monthly Sales Query

    #Write an SQL query to retrieve the monthly sales summary
    from the ORDERS table.

    #The query should:
        - Display the order month and year
        - Calculate the total number of orders per month
        - Calculate the total revenue per month
        - Calculate the average order value per month
        - Sort the result by month in ascending order
    
select  
    month(  order_Date  ) as "Month", 
    year(  order_Date   ) AS "Year",
    count(Order_id) as "NoOfOrders" ,
    SUM(TOTAL_AMOUNT) as "TotalRevenuePerMonth",
    round( AVG(TOTAL_AMOUNT) ,2) as "AverageOrderValuePerMonth"
from orders
group by month(  order_Date ) ,   year(  order_Date )
order by "Year" ,"Month";

#Question 2: City-wise Customer and Order Query

   # Write an SQL query using the CUSTOMERS and ORDERS tables
    to display city-wise and state-wise statistics.

    #The query should:
        - Show city and state
        - Count the total number of distinct customers
        - Count the total number of orders
        - Calculate the total revenue per city
        - Include customers who have not placed any orders
        - Sort the result by total revenue in descending order




select c.city, c.state, 
count(distinct(o.customer_id)),
count(o.order_id),
coalesce(sum(o.total_amount),0) as totalrevenue 
from customers c
left join  orders o on c.customer_id = o.customer_id
group by c.city, c.state
order by totalrevenue desc;


#Question 3: Product Category Performance Query

   # Write an SQL query using the PRODUCTS and ORDER_ITEMS tables
    to analyze product category performance.

    The query should:
        - Display product category
        - Count the number of distinct products in each category
        - Calculate the total units sold per category
        - Calculate total revenue per category
        - Include categories with no sales
        - Sort the result by revenue in descending order

SELECT
    p.CATEGORY,
    COUNT(DISTINCT p.PRODUCT_ID) AS DISTINCT_PRODUCTS,
    COALESCE(SUM(oi.QUANTITY), 0) AS TOTAL_UNITS_SOLD,
    COALESCE(SUM(oi.QUANTITY * oi.UNIT_PRICE), 0) AS TOTAL_REVENUE
FROM PRODUCTS p
LEFT JOIN ORDER_ITEMS oi
    ON p.PRODUCT_ID = oi.PRODUCT_ID
GROUP BY
    p.CATEGORY
ORDER BY
    TOTAL_REVENUE DESC;

#Question 4: Customer Purchase History Query

#Write an SQL query to display the complete purchase history
    of a customer named "Amit Kumar".

    #The query should:
        - Retrieve customer details, order details, and product details
        - Display product quantity, unit price, and line total
        - Include order status
        - Sort the results by order date in descending order

SELECT
    c.CUSTOMER_ID,
    c.CUSTOMER_NAME,
    c.EMAIL,
    c.CITY,
    o.ORDER_ID,
    o.ORDER_DATE,
    o.STATUS,
    p.PRODUCT_NAME,
    oi.QUANTITY,
    oi.UNIT_PRICE,
    (oi.QUANTITY * oi.UNIT_PRICE) AS LINE_TOTAL
FROM CUSTOMERS c
JOIN ORDERS o
    ON c.CUSTOMER_ID = o.CUSTOMER_ID
JOIN ORDER_ITEMS oi
    ON o.ORDER_ID = oi.ORDER_ID
JOIN PRODUCTS p
    ON oi.PRODUCT_ID = p.PRODUCT_ID
WHERE c.CUSTOMER_NAME = 'Amit Kumar'
ORDER BY
    o.ORDER_DATE DESC;

#Question 5: Pending Orders Query
#Write an SQL query to list all orders that are pending delivery.
# The query should:
        - Include orders with statuses Processing and Shipped
        - Display order details along with customer name, email, and city
        - Sort the results by order date

    
SELECT
    o.ORDER_ID,
    o.ORDER_DATE,
    o.STATUS,
    o.TOTAL_AMOUNT,
    c.CUSTOMER_NAME,
    c.EMAIL,
    c.CITY
FROM ORDERS o
JOIN CUSTOMERS c
    ON o.CUSTOMER_ID = c.CUSTOMER_ID
WHERE o.STATUS IN ('Processing', 'Shipped')
ORDER BY
    o.ORDER_DATE;

#Question 6: Product Inventory Value Query

    #Write an SQL query to calculate the inventory value for each
    product in the PRODUCTS table.

   # The query should:
        - Display product name, category, price, and stock quantity
        - Calculate inventory value for each product
        - Include only products with available stock
        - Sort the result by inventory value in descending order

SELECT
    PRODUCT_NAME,
    CATEGORY,
    PRICE,
    STOCK_QUANTITY,
    (PRICE * STOCK_QUANTITY) AS INVENTORY_VALUE
FROM PRODUCTS
WHERE STOCK_QUANTITY > 0
ORDER BY
    INVENTORY_VALUE DESC;
