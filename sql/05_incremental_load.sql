
-- Insert NEW record into raw_sales

INSERT INTO raw_sales VALUES (
'10000',
'CA-2026-000001',
'12/01/2026',
'12/03/2026',
'Second Class',
'CG-99999',
'New Customer',
'Consumer',
'United States',
'Boston',
'Massachusetts',
'12345',
'East',
'PR-NEW001',
'Furniture',
'Chairs',
'New Chair Model',
'500.00',
'2',
'0.10',
'120.00'
);



INSERT INTO sales_clean
SELECT
    row_id::INT,
    order_id,
    TO_DATE(order_date, 'MM/DD/YYYY'),
    TO_DATE(ship_date, 'MM/DD/YYYY'),
    ship_mode,
    customer_id,
    customer_name,
    segment,
    country,
    city,
    state,
    postal_code::INT,
    region,
    product_id,
    category,
    sub_category,
    product_name,
    sales::NUMERIC(10,2),
    quantity::INT,
    discount::NUMERIC(4,2),
    profit::NUMERIC(10,4)
FROM raw_sales
WHERE row_id::INT > COALESCE(
    (SELECT MAX(row_id) FROM sales_clean),
    0
);

SELECT COUNT(*) FROM sales_clean;


-- Incremental Dimension Updates

INSERT INTO dim_customer (
    customer_id,
    customer_name,
    segment,
    country,
    city,
    state,
    postal_code,
    region
)
SELECT DISTINCT
    s.customer_id,
    s.customer_name,
    s.segment,
    s.country,
    s.city,
    s.state,
    s.postal_code,
    s.region
FROM sales_clean s
LEFT JOIN dim_customer d
ON s.customer_id = d.customer_id
WHERE d.customer_id IS NULL;



INSERT INTO dim_product (
    product_id,
    product_name,
    category,
    sub_category
)
SELECT DISTINCT
    s.product_id,
    s.product_name,
    s.category,
    s.sub_category
FROM sales_clean s
LEFT JOIN dim_product d
ON s.product_id = d.product_id
WHERE d.product_id IS NULL;


INSERT INTO dim_date
SELECT DISTINCT
    TO_CHAR(s.order_date, 'YYYYMMDD')::INT AS date_key,
    s.order_date AS full_date,
    EXTRACT(YEAR FROM s.order_date)::INT,
    EXTRACT(MONTH FROM s.order_date)::INT,
    TO_CHAR(s.order_date, 'Month'),
    EXTRACT(QUARTER FROM s.order_date)::INT,
    EXTRACT(DAY FROM s.order_date)::INT,
    EXTRACT(DOW FROM s.order_date)::INT,
    TO_CHAR(s.order_date, 'Day')
FROM sales_clean s
LEFT JOIN dim_date d
ON s.order_date = d.full_date
WHERE d.full_date IS NULL;


SELECT COUNT(*) FROM dim_date;


SELECT COUNT(*) FROM dim_product;


-- Incremental Fact Load

INSERT INTO fact_sales (
    order_id,
    customer_key,
    product_key,
    date_key,
    sales,
    quantity,
    discount,
    profit,
    row_id
)
SELECT
    s.order_id,
    c.customer_key,
    p.product_key,
    d.date_key,
    s.sales,
    s.quantity,
    s.discount,
    s.profit,
    s.row_id
FROM sales_clean s
JOIN dim_customer c ON s.customer_id = c.customer_id
JOIN dim_product p ON s.product_id = p.product_id
JOIN dim_date d ON s.order_date = d.full_date
WHERE s.row_id > COALESCE(
    (SELECT MAX(row_id) FROM fact_sales),
    0
);



SELECT COUNT(*) FROM fact_sales;


SELECT COUNT(*) FROM raw_sales;
SELECT COUNT(*) FROM sales_clean;
