# 📊 Olist Data Quality with Snowflake and dbt

![dbt](https://img.shields.io/badge/dbt-FF694B?style=for-the-badge&logo=dbt&logoColor=white)
![Snowflake](https://img.shields.io/badge/Snowflake-29B5E8?style=for-the-badge&logo=snowflake&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-4479A1?style=for-the-badge&logo=postgresql&logoColor=white)

A data quality and transformation pipeline for the Olist Brazilian e-commerce dataset using dbt Core and Snowflake.

---

## 📑 Table of Contents

- [About](#-about)
- [Architecture](#-architecture)
- [Project Structure](#-project-structure)
- [Quick Start](#-quick-start)
- [Usage](#-usage)
- [Data Models](#-data-models)
- [Contributing](#-contributing)
  
---

## 🎯 About

This project transforms raw Olist e-commerce data into analytics-ready models with comprehensive data quality checks. The Olist dataset contains 100,000+ orders from Brazilian marketplaces (2016-2018).

**Key Features:**
- ✅ Multi-layered data quality validation
- 🔄 Modular transformation pipeline (Staging → Intermediate → Marts)
- 📊 Analytics-ready dimensional models
- 📈 Automated testing and documentation
- ⚡ Optimized for Snowflake performance

---

## 🏗️ Architecture

**Data Flow:**

```
Raw Data (Snowflake)
    ↓
Staging Layer (Bronze)
    • Clean column names
    • Standardize data types
    • Basic validation
    ↓
Intermediate Layer (Silver)
    • Business logic
    • Join tables
    • Calculate metrics
    ↓
Marts Layer (Gold)
    • Fact tables
    • Dimension tables
    • Analytics-ready
```

**Tech Stack:**
- **Data Warehouse**: Snowflake
- **Transformation**: dbt Core
- **Language**: SQL + Jinja
- **Version Control**: Git

---

## 📁 Project Structure

```
olist-dq-snowflake-dbt/
│
├── dbt_project.yml              # dbt configuration
├── 01_snowflake_setup.sql       # Snowflake setup script
├── README.md                    # This file
│
├── models/                      # SQL transformation models
│   ├── staging/                 # Raw data cleaning
│   │   ├── stg_orders.sql
│   │   ├── stg_customers.sql
│   │   └── stg_order_items.sql
│   │
│   ├── intermediate/            # Business logic
│   │   ├── int_order_enriched.sql
│   │   └── int_customer_metrics.sql
│   │
│   └── marts/                   # Final analytics models
│       ├── fact_orders.sql
│       ├── dim_customers.sql
│       └── dim_products.sql
│
├── tests/                       # Custom data quality tests
│   ├── assert_positive_revenue.sql
│   └── assert_valid_dates.sql
│
├── seeds/                       # Reference data (CSV)
│   └── product_categories.csv
│
├── snapshots/                   # Historical tracking
│   └── snap_customers.sql
│
└── macros/                      # Reusable SQL functions
    └── generate_schema_name.sql
```

**Key Files:**
- `dbt_project.yml`: Project settings, materialization strategies
- `01_snowflake_setup.sql`: Creates databases, schemas, warehouses
- `models/`: All SQL transformations organized by layer
- `tests/`: Custom validation logic

---

## 🚀 Quick Start

### Prerequisites

- Snowflake account with appropriate permissions
- Python 3.8+ and pip
- Git

### Installation

**1. Clone the repository**
```bash
git clone https://github.com/yourusername/olist-dq-snowflake-dbt.git
cd olist-dq-snowflake-dbt
```

**2. Install dbt**
```bash
pip install dbt-core dbt-snowflake
```

**3. Set up Snowflake**
```bash
# Run the setup script in Snowflake
snowsql -f 01_snowflake_setup.sql
```

**4. Configure dbt profile** (`~/.dbt/profiles.yml`)
```yaml
olist_dq_snowflake_dbt:
  target: dev
  outputs:
    dev:
      type: snowflake
      account: your_account.region
      user: your_username
      password: your_password
      role: TRANSFORMER
      database: OLIST_ANALYTICS
      warehouse: TRANSFORMING
      schema: dbt_dev
      threads: 4
```

**5. Test connection**
```bash
dbt debug
```

**6. Run the pipeline**
```bash
# Load reference data
dbt seed

# Run all models
dbt run

# Run all tests
dbt test

# Or run everything at once
dbt build
```

---

## 💻 Usage

### Essential Commands

```bash
# Run all models
dbt run

# Run specific model
dbt run --select stg_orders

# Run model and downstream dependencies
dbt run --select stg_orders+

# Run all tests
dbt test

# Load seed files
dbt seed

# Generate documentation
dbt docs generate
dbt docs serve
```

### Development Workflow

```bash
# 1. Create new model
touch models/marts/new_model.sql

# 2. Write SQL transformation
# 3. Run and test
dbt run --select new_model
dbt test --select new_model

# 4. Commit changes
git add models/marts/new_model.sql
git commit -m "Add new model"
git push
```

---

## 🗂️ Data Models

### Staging Models
**Purpose**: Clean and standardize raw data

**Example**: `stg_orders.sql`
```sql
WITH source AS (
    SELECT * FROM {{ source('olist_raw', 'orders') }}
)

SELECT
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp::TIMESTAMP AS purchased_at,
    order_delivered_customer_date::TIMESTAMP AS delivered_at
FROM source
WHERE order_id IS NOT NULL
```

### Intermediate Models
**Purpose**: Apply business logic and joins

**Example**: `int_order_enriched.sql`
```sql
SELECT
    o.order_id,
    o.customer_id,
    c.customer_city,
    c.customer_state,
    SUM(oi.price) AS total_price,
    COUNT(oi.order_item_id) AS item_count
FROM {{ ref('stg_orders') }} o
LEFT JOIN {{ ref('stg_customers') }} c ON o.customer_id = c.customer_id
LEFT JOIN {{ ref('stg_order_items') }} oi ON o.order_id = oi.order_id
GROUP BY 1, 2, 3, 4
```

### Marts Models
**Purpose**: Analytics-ready fact and dimension tables

**Example**: `fact_orders.sql`
```sql
SELECT
    order_id,
    customer_id,
    purchased_at,
    delivered_at,
    order_status,
    total_price,
    item_count,
    DATEDIFF(day, purchased_at, delivered_at) AS delivery_days
FROM {{ ref('int_order_enriched') }}
WHERE order_status = 'delivered'
```

---

## 🧪 Data Quality Tests

### Built-in Tests
Applied in `schema.yml`:
```yaml
models:
  - name: stg_orders
    columns:
      - name: order_id
        tests:
          - unique
          - not_null
      - name: order_status
        tests:
          - accepted_values:
              values: ['delivered', 'shipped', 'canceled']
```

### Custom Tests
SQL queries that return failing records:
```sql
-- tests/assert_positive_revenue.sql
SELECT *
FROM {{ ref('fact_orders') }}
WHERE total_price <= 0
```

---

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/new-feature`)
3. Make changes and test (`dbt run --select +your_model`)
4. Commit (`git commit -m "Add new feature"`)
5. Push (`git push origin feature/new-feature`)
6. Open a Pull Request

---

## 📧 Contact

**Sathwika Reddy**

- 📧 Email: sathwikap@1012

- 🐙 GitHub: https://github.com/Sathwikareddy24 

---

## 🙏 Acknowledgments

- **Olist** for the [Brazilian E-Commerce Dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)
- **dbt Labs** for the transformation framework
- **Snowflake** for the cloud data platform

---

<div align="center">

**⭐ Star this repo if you find it helpful!**



</div>
