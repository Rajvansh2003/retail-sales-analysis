CREATE DATABASE superstore_db;
USE superstore_db;

CREATE TABLE superstore_orders (
    row_id INT,
    order_id VARCHAR(50),
    order_date VARCHAR(20),
    ship_date VARCHAR(20),
    ship_mode VARCHAR(50),
    customer_id VARCHAR(50),
    customer_name VARCHAR(100),
    segment VARCHAR(50),
    country VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50),
    postal_code VARCHAR(20),
    region VARCHAR(50),
    product_id VARCHAR(50),
    category VARCHAR(50),
    sub_category VARCHAR(50),
    product_name VARCHAR(255),
    sales DECIMAL(10,2),
    quantity INT,
    discount DECIMAL(5,2),
    profit DECIMAL(10,2)
);

SHOW VARIABLES LIKE 'secure_file_priv';

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 9.7/Uploads/superstore_clean.csv'
INTO TABLE superstore_orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT COUNT(*) 
FROM superstore_orders;

SELECT * 
FROM superstore_orders
LIMIT 10;

ALTER TABLE superstore_orders
ADD COLUMN order_date_clean DATE,
ADD COLUMN ship_date_clean DATE;

SET SQL_SAFE_UPDATES = 0;

UPDATE superstore_orders
SET 
order_date_clean = STR_TO_DATE(order_date, '%m/%d/%Y'),
ship_date_clean = STR_TO_DATE(ship_date, '%m/%d/%Y');

SELECT 
    order_date,
    order_date_clean
FROM superstore_orders
LIMIT 10;

/* 1. Total Sales, Profit & Profit Margin */
SELECT 
    ROUND(SUM(sales),2) AS total_sales,
    ROUND(SUM(profit),2) AS total_profit,
    ROUND((SUM(profit)/SUM(sales))*100,2) AS profit_margin_percent
FROM superstore_orders;

/* 2. Sales by Category */
SELECT 
    category,
    ROUND(SUM(sales),2) AS total_sales
FROM superstore_orders
GROUP BY category
ORDER BY total_sales DESC;

/* 3. Profit by Category */
SELECT 
    category,
    ROUND(SUM(profit),2) AS total_profit
FROM superstore_orders
GROUP BY category
ORDER BY total_profit DESC;

/* 4. Top 10 Most Profitable Products */
SELECT 
    product_name,
    ROUND(SUM(profit),2) AS total_profit
FROM superstore_orders
GROUP BY product_name
ORDER BY total_profit DESC
LIMIT 10;

/* 5. Top 10 Loss-Making Products */
SELECT 
    product_name,
    ROUND(SUM(profit),2) AS total_loss
FROM superstore_orders
GROUP BY product_name
ORDER BY total_loss ASC
LIMIT 10;

/* 6. Regional Performance*/
SELECT 
    region,
    ROUND(SUM(sales),2) AS total_sales,
    ROUND(SUM(profit),2) AS total_profit
FROM superstore_orders
GROUP BY region
ORDER BY total_sales DESC;

/*7. Monthly Sales Trend */
SELECT 
    DATE_FORMAT(order_date_clean,'%Y-%m') AS month,
    ROUND(SUM(sales),2) AS monthly_sales
FROM superstore_orders
GROUP BY month
ORDER BY month;

/* 8. Segment Wise Profitability*/
SELECT 
    segment,
    ROUND(SUM(profit),2) AS total_profit
FROM superstore_orders
GROUP BY segment
ORDER BY total_profit DESC;

/* 9. Top 10 Cities by Sales*/
SELECT 
    city,
    ROUND(SUM(sales),2) AS total_sales
FROM superstore_orders
GROUP BY city
ORDER BY total_sales DESC
LIMIT 10;

/* 10. Discount Impact on Profit */
SELECT 
    discount,
    ROUND(AVG(profit),2) AS avg_profit
FROM superstore_orders
GROUP BY discount
ORDER BY discount;