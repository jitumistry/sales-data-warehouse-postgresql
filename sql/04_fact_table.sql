
CREATE TABLE fact_sales (
    sales_key SERIAL PRIMARY KEY,
    order_id TEXT,
    customer_key INT,
    product_key INT,
    date_key INT,
    sales NUMERIC(10,2),
    quantity INT,
    discount NUMERIC(4,2),
    profit NUMERIC(10,4)
);

INSERT INTO fact_sales (
    order_id,
    customer_key,
    product_key,
    date_key,
    sales,
    quantity,
    discount,
    profit
)
SELECT
    sc.order_id,
    dc.customer_key,
    dp.product_key,
    dd.date_key,
    sc.sales,
    sc.quantity,
    sc.discount,
    sc.profit
FROM sales_clean sc
JOIN dim_customer dc
    ON sc.customer_id = dc.customer_id
JOIN dim_product dp
    ON sc.product_id = dp.product_id
JOIN dim_date dd
    ON sc.order_date = dd.full_date;


SELECT COUNT(*) FROM fact_sales;

-- Total Revenue
SELECT ROUND(SUM(sales),2) 
FROM fact_sales;


-- Top 5 Customers by Revenue

SELECT dc.customer_name, ROUND(SUM(sales),2) AS Revenue
FROM fact_sales fs
INNER JOIN dim_customer dc ON fs.customer_key = dc.customer_key
GROUP BY dc.customer_name
Order by Revenue DESC
LIMIT 5;


-- Monthly Revenue Trend

SELECT dd.Year, dd.Month, ROUND(SUM(sales),2) AS Revenue
FROM fact_sales fs
INNER JOIN dim_date dd ON fs.date_key = dd.date_key
GROUP BY dd.Year, dd.Month
ORDER BY dd.Year, dd.Month;


-- Add Foreign Keys (Data Integrity)

ALTER TABLE fact_sales
ADD CONSTRAINT fk_customer
FOREIGN KEY(customer_key)
REFERENCES dim_customer(customer_key);

ALTER TABLE fact_sales
ADD CONSTRAINT fk_product
FOREIGN KEY (product_key)
REFERENCES dim_product(product_key);

ALTER TABLE fact_sales
ADD CONSTRAINT fk_date
FOREIGN KEY (date_key)
REFERENCES dim_date(date_key);


-- Add Indexes (Performance)

CREATE INDEX idx_fact_customer
ON fact_sales(customer_key);


CREATE INDEX idx_fact_product
ON fact_sales(product_key);


CREATE INDEX idx_fact_date
ON fact_sales(date_key);


-- Performance Check

EXPLAIN ANALYZE
SELECT dc.customer_name, SUM(fs.sales)
FROM fact_sales fs 
JOIN dim_customer dc ON fs.customer_key = dc.customer_key
GROUP BY dc.customer_name;



-- Add row_id to fact table

ALTER TABLE fact_sales
ADD COLUMN row_id INT;

-- Backfill row_id for existing data

UPDATE fact_sales f
SET row_id = s.row_id
FROM sales_clean s
WHERE f.order_id = s.order_id;


SELECT MAX(row_id) FROM fact_sales;

