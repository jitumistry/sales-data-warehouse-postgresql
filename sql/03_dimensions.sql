-- Create Dimension table 

CREATE TABLE dim_customer (
    customer_key SERIAL PRIMARY KEY,
    customer_id TEXT UNIQUE,
    customer_name TEXT,
    segment TEXT,
    country TEXT,
    city TEXT,
    state TEXT,
    postal_code INT,
    region TEXT
);


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
SELECT
    customer_id,
    MAX(customer_name),
    MAX(segment),
    MAX(country),
    MAX(city),
    MAX(state),
    MAX(postal_code),
    MAX(region)
FROM sales_clean
GROUP BY customer_id;

SELECT COUNT(*) FROM dim_customer;


CREATE TABLE dim_product (
    product_key SERIAL PRIMARY KEY,
    product_id TEXT UNIQUE,
    product_name TEXT,
    category TEXT,
    sub_category TEXT
);


INSERT INTO dim_product (
    product_id,
    product_name,
    category,
    sub_category
)
SELECT
    product_id,
    MAX(product_name),
    MAX(category),
    MAX(sub_category)
FROM sales_clean
GROUP BY product_id;

SELECT COUNT(*) FROM dim_product;

SELECT COUNT(DISTINCT product_id) FROM sales_clean;


CREATE TABLE dim_date (
    date_key INT PRIMARY KEY,
    full_date DATE,
    year INT,
    month INT,
    month_name TEXT,
    quarter INT,
    day INT,
    day_of_week INT,
    day_name TEXT
);

INSERT INTO dim_date
SELECT DISTINCT
    TO_CHAR(order_date, 'YYYYMMDD')::INT AS date_key,
    order_date AS full_date,
    EXTRACT(YEAR FROM order_date)::INT,
    EXTRACT(MONTH FROM order_date)::INT,
    TO_CHAR(order_date, 'Month'),
    EXTRACT(QUARTER FROM order_date)::INT,
    EXTRACT(DAY FROM order_date)::INT,
    EXTRACT(DOW FROM order_date)::INT,
    TO_CHAR(order_date, 'Day')
FROM sales_clean;


SELECT COUNT(*) FROM dim_date;


