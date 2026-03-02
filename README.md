# 📊 Sales Data Warehouse (PostgreSQL)

## 📌 Project Overview

This project simulates a real-world Data Warehouse using PostgreSQL.
It implements a star schema design with incremental ETL logic using high-water mark (row_id) tracking.

The pipeline follows a layered architecture:

Raw Layer → Clean Layer → Dimension Tables → Fact Table

---

## 🏗 Architecture

### 1️⃣ Raw Layer

* `raw_sales`
* Stores raw CSV-like data (all TEXT format)

### 2️⃣ Clean Layer

* `sales_clean`
* Data type casting
* Date conversion
* Numeric validation

### 3️⃣ Star Schema

#### Dimension Tables

* `dim_customer`
* `dim_product`
* `dim_date`

#### Fact Table

* `fact_sales`
* Surrogate keys
* Foreign key constraints
* Indexed for performance

---

## 🔄 Incremental ETL Logic

Implemented high-water mark incremental loading using:

```sql
WHERE row_id > COALESCE((SELECT MAX(row_id) FROM fact_sales), 0)
```

Features:

* Detects new records
* Loads only missing dimension values
* Prevents duplicate inserts
* Simulates real production ETL behavior

---

## ⚡ Performance Optimization

* Foreign key constraints for data integrity
* Indexes on fact table keys
* EXPLAIN ANALYZE used for query validation

---

## 📈 Sample Analytics Queries

* Total Revenue
* Top 5 Customers by Revenue
* Monthly Revenue Trend

---

## 🛠 Tech Stack

* PostgreSQL
* SQL
* Star Schema Modeling
* Incremental ETL Design

---

## 🎯 Key Learnings

* Dimensional modeling (Kimball style)
* Surrogate key design
* Handling late-arriving dimensions
* Incremental fact loading
* Debugging join-based ETL failures

---

