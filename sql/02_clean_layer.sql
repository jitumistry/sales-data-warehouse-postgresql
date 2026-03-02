SELECT * FROM raw_sales LIMIT 5;



CREATE TABLE sales_clean AS
SELECT
    row_id::INT AS row_id,
    order_id,
    TO_DATE(order_date, 'MM/DD/YYYY') AS order_date,
    TO_DATE(ship_date, 'MM/DD/YYYY') AS ship_date,
    ship_mode,
    customer_id,
    customer_name,
    segment,
    country,
    city,
    state,
    postal_code::INT AS postal_code,
    region,
    product_id,
    category,
    sub_category,
    product_name,
    sales::NUMERIC(10,2) AS sales,
    quantity::INT AS quantity,
    discount::NUMERIC(4,2) AS discount,
    profit::NUMERIC(10,4) AS profit
FROM raw_sales;



SELECT * FROM sales_clean LIMIT 5;


-- CHECK THE DATA TYPES

SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'sales_clean';


SELECT COUNT(*) FROM sales_clean;

SELECT MIN(order_date), MAX(order_date) from sales_clean;

SELECT SUM(sales) FROM sales_clean;

SELECT ROUND(SUM(sales),2) FROM sales_clean;

