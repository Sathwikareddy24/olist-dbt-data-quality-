# 📊 Olist Data Quality with Snowflake and dbt

![dbt](https://img.shields.io/badge/dbt-FF694B?style=for-the-badge&logo=dbt&logoColor=white)
![Snowflake](https://img.shields.io/badge/Snowflake-29B5E8?style=for-the-badge&logo=snowflake&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-4479A1?style=for-the-badge&logo=postgresql&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

A production-ready data quality and transformation pipeline for the Olist e-commerce dataset, built with dbt Core and Snowflake.

---

## 📑 Table of Contents

- [About the Project](#-about-the-project)
- [Architecture & Workflow](#-architecture--workflow)
- [Project Structure](#-project-structure)
- [Prerequisites](#-prerequisites)
- [Installation & Setup](#-installation--setup)
- [Snowflake Configuration](#️-snowflake-configuration)
- [dbt Project Configuration](#-dbt-project-configuration)
- [Data Models](#-data-models)
- [Data Quality Tests](#-data-quality-tests)
- [Seeds](#-seeds)
- [Snapshots](#-snapshots)
- [Macros](#-macros)
- [Usage & Commands](#-usage--commands)
- [Development Workflow](#-development-workflow)
- [Data Lineage & Documentation](#-data-lineage--documentation)
- [Troubleshooting](#-troubleshooting)
- [Contributing](#-contributing)
- [Project Roadmap](#-project-roadmap)
- [License](#-license)
- [Contact & Acknowledgments](#-contact--acknowledgments)

---

## 🎯 About the Project

This project implements a comprehensive data quality and transformation pipeline for the **Olist dataset** - a Brazilian e-commerce public dataset containing information about 100,000+ orders from 2016 to 2018 made at multiple marketplaces.

### Purpose

The primary goal is to build a robust, scalable data pipeline that:

- ✅ **Validates data quality** at every transformation layer
- 🔄 **Transforms raw e-commerce data** into analytics-ready models
- 📈 **Enables business intelligence** through clean, reliable data marts
- 🔍 **Tracks data lineage** and maintains comprehensive documentation
- ⚡ **Ensures data integrity** through automated testing

### Key Objectives

1. **Data Quality Assurance**: Implement multi-layered validation to catch data issues early
2. **Modular Transformations**: Build reusable, maintainable SQL models following best practices
3. **Business Value**: Create analytics-ready datasets for customer behavior, seller performance, and order analytics
4. **Scalability**: Design a pipeline that can handle growing data volumes efficiently
5. **Documentation**: Maintain clear, auto-generated documentation for all data assets

### Business Value

- 📊 Enable data-driven decision making for e-commerce operations
- 🎯 Provide reliable metrics for customer segmentation and retention
- 💰 Support revenue analysis and seller performance tracking
- 🚀 Reduce time-to-insight with pre-built analytical models

---

## 🏗️ Architecture & Workflow

This project follows the **medallion architecture** pattern with dbt and Snowflake:

```
┌─────────────────┐
│   Raw Data      │  ← Olist CSV files loaded into Snowflake
│   (Landing)     │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Staging Layer  │  ← Data cleaning, type casting, renaming
│   (Bronze)      │  ← One-to-one with source tables
└────────┬────────┘  ← Basic quality tests (not_null, unique)
         │
         ▼
┌─────────────────┐
│ Intermediate    │  ← Business logic, joins, calculations
│   (Silver)      │  ← Reusable components
└────────┬────────┘  ← Relationship tests, custom validations
         │
         ▼
┌─────────────────┐
│  Marts Layer    │  ← Analytics-ready dimensional models
│   (Gold)        │  ← Fact and dimension tables
└─────────────────┘  ← Comprehensive quality checks
```

### Data Flow

1. **Raw → Staging**: Clean column names, standardize data types, filter invalid records
2. **Staging → Intermediate**: Apply business logic, join related entities, create derived metrics
3. **Intermediate → Marts**: Build final fact and dimension tables optimized for analytics

### Data Quality Enforcement

- **Staging Layer**: Schema validation, null checks, uniqueness constraints
- **Intermediate Layer**: Referential integrity, business rule validation, data consistency
- **Marts Layer**: Aggregate validation, metric accuracy, completeness checks

---

## 📁 Project Structure

```
olist-dq-snowflake-dbt/
│
├── dbt_project.yml              # Main dbt project configuration
├── 01_snowflake_setup.sql       # Snowflake initialization script
├── .gitignore                   # Git ignore patterns for dbt artifacts
│
├── models/                      # dbt SQL transformation models
│   ├── staging/                 # Raw data cleaning & standardization
│   │   ├── stg_orders.sql
│   │   ├── stg_customers.sql
│   │   ├── stg_order_items.sql
│   │   └── ...
│   ├── intermediate/            # Business logic & joins
│   │   ├── int_order_enriched.sql
│   │   ├── int_customer_metrics.sql
│   │   └── ...
│   └── marts/                   # Analytics-ready models
│       ├── dim_customers.sql
│       ├── dim_products.sql
│       ├── fact_orders.sql
│       └── ...
│
├── tests/                       # Custom data quality tests
│   ├── assert_positive_revenue.sql
│   ├── assert_valid_dates.sql
│   └── ...
│
├── seeds/                       # Reference/lookup data (CSV)
│   ├── product_categories.csv
│   ├── state_mappings.csv
│   └── ...
│
├── snapshots/                   # Slowly changing dimension tracking
│   ├── snap_customers.sql
│   └── snap_sellers.sql
│
├── macros/                      # Reusable SQL functions
│   ├── generate_schema_name.sql
│   ├── test_data_quality.sql
│   └── ...
│
├── analyses/                    # Ad-hoc analytical queries
│   ├── customer_cohort_analysis.sql
│   └── revenue_trends.sql
│
└── scripts/                     # Automation & helper scripts
    ├── load_data.sh
    └── run_full_refresh.sh
```

### Key Files Explained

#### `dbt_project.yml`
The central configuration file that defines:
- Project name, version, and profile
- Model materialization strategies (view vs table)
- Schema naming conventions
- Test severity levels
- Documentation settings

#### `01_snowflake_setup.sql`
Initialization script that creates:
- Databases (`OLIST_RAW`, `OLIST_ANALYTICS`)
- Schemas (`STAGING`, `INTERMEDIATE`, `MARTS`)
- Warehouses with appropriate sizing
- Roles and permission grants
- Initial table structures for raw data

#### `models/`
Contains all SQL transformation logic organized by layer:
- **staging/**: 1:1 mapping with source tables, basic cleaning
- **intermediate/**: Complex joins and business logic
- **marts/**: Final dimensional models for BI tools

#### `tests/`
Custom SQL-based tests that return failing records:
- Revenue validation (no negative amounts)
- Date logic checks (delivery after purchase)
- Cross-table consistency checks

#### `seeds/`
Static reference data loaded as tables:
- Product category translations
- Geographic mappings
- Business rules lookup tables

#### `snapshots/`
Type-2 slowly changing dimension tracking:
- Historical customer data
- Seller profile changes over time

#### `macros/`
Reusable Jinja + SQL functions:
- Custom test generators
- Schema name overrides
- Data quality utilities

---

## ✅ Prerequisites

Before you begin, ensure you have the following:

### Required Software

- **Snowflake Account** with:
  - `ACCOUNTADMIN` or sufficient privileges to create databases, schemas, and warehouses
  - Active warehouse for compute
  - Storage quota available

- **dbt Core** (version 1.5.0 or higher)
  ```bash
  pip install dbt-core>=1.5.0
  pip install dbt-snowflake>=1.5.0
  ```

- **Python** 3.8 or higher
- **pip** (Python package manager)
- **Git** for version control

### Data Requirements

- Access to the **Olist dataset** (available on [Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce))
- CSV files downloaded and ready to load into Snowflake

### Knowledge Prerequisites

- Basic SQL and data modeling concepts
- Familiarity with command-line interfaces
- Understanding of data warehousing principles (helpful but not required)

---

## 🚀 Installation & Setup

Follow these steps to get the project up and running:

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/olist-dq-snowflake-dbt.git
cd olist-dq-snowflake-dbt
```

### 2. Set Up Snowflake Environment

Run the initialization script in your Snowflake worksheet:

```bash
# Copy the contents of 01_snowflake_setup.sql
# Execute in Snowflake UI or using SnowSQL
snowsql -f 01_snowflake_setup.sql
```

This creates all necessary databases, schemas, warehouses, and permissions.

### 3. Load Raw Data

Upload the Olist CSV files to Snowflake using the web UI or SnowSQL:

```sql
-- Example: Load orders data
PUT file:///path/to/olist_orders_dataset.csv @OLIST_RAW.PUBLIC.%orders_raw;
COPY INTO OLIST_RAW.PUBLIC.orders_raw
FROM @OLIST_RAW.PUBLIC.%orders_raw
FILE_FORMAT = (TYPE = 'CSV' FIELD_OPTIONALLY_ENCLOSED_BY = '"' SKIP_HEADER = 1);
```

### 4. Configure dbt Profile

Create or update `~/.dbt/profiles.yml`:

```yaml
olist_dq_snowflake_dbt:
  target: dev
  outputs:
    dev:
      type: snowflake
      account: your_account.region
      user: your_username
      password: your_password  # Or use key-pair authentication
      role: TRANSFORMER
      database: OLIST_ANALYTICS
      warehouse: TRANSFORMING
      schema: dbt_dev
      threads: 4
      client_session_keep_alive: False
    
    prod:
      type: snowflake
      account: your_account.region
      user: your_username
      password: your_password
      role: TRANSFORMER
      database: OLIST_ANALYTICS
      warehouse: TRANSFORMING
      schema: dbt_prod
      threads: 8
      client_session_keep_alive: False
```

### 5. Test Connection

```bash
dbt debug
```

You should see all checks pass with green checkmarks ✅

### 6. Install dbt Dependencies

```bash
dbt deps
```

This installs any dbt packages defined in `packages.yml`.

### 7. Load Seed Data

```bash
dbt seed
```

This loads all CSV files from the `seeds/` directory into Snowflake.

### 8. Run Initial Build

```bash
# Run all models
dbt run

# Run all tests
dbt test

# Or run everything at once
dbt build
```

🎉 **Success!** Your data pipeline is now operational.

---

## ☁️ Snowflake Configuration

The `01_snowflake_setup.sql` script performs the following setup:

### Database Creation

```sql
-- Raw data storage
CREATE DATABASE IF NOT EXISTS OLIST_RAW;

-- Analytics/transformed data
CREATE DATABASE IF NOT EXISTS OLIST_ANALYTICS;
```

### Schema Organization

```sql
-- Staging layer
CREATE SCHEMA IF NOT EXISTS OLIST_ANALYTICS.STAGING;

-- Intermediate transformations
CREATE SCHEMA IF NOT EXISTS OLIST_ANALYTICS.INTERMEDIATE;

-- Final marts
CREATE SCHEMA IF NOT EXISTS OLIST_ANALYTICS.MARTS;

-- dbt development schemas
CREATE SCHEMA IF NOT EXISTS OLIST_ANALYTICS.DBT_DEV;
CREATE SCHEMA IF NOT EXISTS OLIST_ANALYTICS.DBT_PROD;
```

### Warehouse Configuration

```sql
-- For data transformations
CREATE WAREHOUSE IF NOT EXISTS TRANSFORMING
  WITH WAREHOUSE_SIZE = 'SMALL'
  AUTO_SUSPEND = 300
  AUTO_RESUME = TRUE
  INITIALLY_SUSPENDED = TRUE;

-- For loading raw data
CREATE WAREHOUSE IF NOT EXISTS LOADING
  WITH WAREHOUSE_SIZE = 'XSMALL'
  AUTO_SUSPEND = 60
  AUTO_RESUME = TRUE;
```

### Role & Permission Setup

```sql
-- Create transformation role
CREATE ROLE IF NOT EXISTS TRANSFORMER;

-- Grant necessary privileges
GRANT USAGE ON DATABASE OLIST_ANALYTICS TO ROLE TRANSFORMER;
GRANT USAGE ON ALL SCHEMAS IN DATABASE OLIST_ANALYTICS TO ROLE TRANSFORMER;
GRANT CREATE TABLE ON ALL SCHEMAS IN DATABASE OLIST_ANALYTICS TO ROLE TRANSFORMER;
GRANT SELECT ON ALL TABLES IN DATABASE OLIST_RAW TO ROLE TRANSFORMER;
```

### Connection Details Needed

To connect dbt to Snowflake, you'll need:

- **Account Identifier**: `your_account.region` (e.g., `xy12345.us-east-1`)
- **Username**: Your Snowflake user
- **Password**: Or private key for key-pair authentication
- **Role**: `TRANSFORMER` (or your custom role)
- **Warehouse**: `TRANSFORMING`
- **Database**: `OLIST_ANALYTICS`

---

## ⚙️ dbt Project Configuration

The `dbt_project.yml` file controls all project settings:

### Basic Settings

```yaml
name: 'olist_dq_snowflake_dbt'
version: '1.0.0'
config-version: 2

profile: 'olist_dq_snowflake_dbt'
```

### Model Paths

```yaml
model-paths: ["models"]
analysis-paths: ["analyses"]
test-paths: ["tests"]
seed-paths: ["seeds"]
macro-paths: ["macros"]
snapshot-paths: ["snapshots"]
```

### Materialization Strategies

```yaml
models:
  olist_dq_snowflake_dbt:
    # Staging models as views (lightweight, always fresh)
    staging:
      +materialized: view
      +schema: staging
      
    # Intermediate models as views (reusable components)
    intermediate:
      +materialized: view
      +schema: intermediate
      
    # Marts as tables (performance-optimized for queries)
    marts:
      +materialized: table
      +schema: marts
```

**Materialization Types:**
- **view**: Virtual table, no storage, always up-to-date
- **table**: Physical table, faster queries, requires refresh
- **incremental**: Append/update only new records (for large datasets)
- **ephemeral**: CTE, not materialized, used in other models

### Schema Naming

```yaml
# Custom schema naming: <target_schema>_<custom_schema>
# Example: dbt_dev_staging, dbt_prod_marts
```

### Test Configurations

```yaml
tests:
  olist_dq_snowflake_dbt:
    +severity: error  # Tests fail the build
    +store_failures: true  # Save failing rows for inspection
```

### Seeds Configuration

```yaml
seeds:
  olist_dq_snowflake_dbt:
    +schema: seeds
    +quote_columns: false
```

---

## 🗂️ Data Models

### Staging Models (`models/staging/`)

**Purpose**: Clean and standardize raw data with minimal transformation.

**Characteristics**:
- 1:1 relationship with source tables
- Rename columns to consistent naming convention
- Cast data types appropriately
- Filter out invalid records
- Add basic metadata (loaded_at timestamps)

**Example**: `stg_orders.sql`

```sql
WITH source AS (
    SELECT * FROM {{ source('olist_raw', 'orders') }}
),

cleaned AS (
    SELECT
        order_id,
        customer_id,
        order_status,
        order_purchase_timestamp::TIMESTAMP AS purchased_at,
        order_approved_at::TIMESTAMP AS approved_at,
        order_delivered_carrier_date::TIMESTAMP AS shipped_at,
        order_delivered_customer_date::TIMESTAMP AS delivered_at,
        order_estimated_delivery_date::TIMESTAMP AS estimated_delivery_at,
        CURRENT_TIMESTAMP() AS loaded_at
    FROM source
    WHERE order_id IS NOT NULL
)

SELECT * FROM cleaned
```

**Naming Convention**: `stg_<source>_<entity>.sql`

### Intermediate Models (`models/intermediate/`)

**Purpose**: Apply business logic and create reusable components.

**Characteristics**:
- Join multiple staging models
- Calculate derived metrics
- Apply business rules
- Create reusable building blocks for marts

**Example**: `int_order_enriched.sql`

```sql
WITH orders AS (
    SELECT * FROM {{ ref('stg_orders') }}
),

order_items AS (
    SELECT * FROM {{ ref('stg_order_items') }}
),

customers AS (
    SELECT * FROM {{ ref('stg_customers') }}
),

order_aggregates AS (
    SELECT
        order_id,
        COUNT(*) AS item_count,
        SUM(price) AS total_price,
        SUM(freight_value) AS total_freight
    FROM order_items
    GROUP BY order_id
)

SELECT
    o.order_id,
    o.customer_id,
    c.customer_city,
    c.customer_state,
    o.order_status,
    o.purchased_at,
    o.delivered_at,
    oa.item_count,
    oa.total_price,
    oa.total_freight,
    oa.total_price + oa.total_freight AS order_total,
    DATEDIFF(day, o.purchased_at, o.delivered_at) AS delivery_days
FROM orders o
LEFT JOIN customers c ON o.customer_id = c.customer_id
LEFT JOIN order_aggregates oa ON o.order_id = oa.order_id
```

**Naming Convention**: `int_<entity>_<description>.sql`

### Marts Models (`models/marts/`)

**Purpose**: Create analytics-ready dimensional models.

**Characteristics**:
- Fact tables (transactions, events)
- Dimension tables (customers, products, dates)
- Optimized for BI tool consumption
- Comprehensive documentation
- Extensive quality tests

**Example**: `fact_orders.sql`

```sql
{{
    config(
        materialized='table',
        tags=['daily', 'core']
    )
}}

WITH order_enriched AS (
    SELECT * FROM {{ ref('int_order_enriched') }}
),

final AS (
    SELECT
        order_id,
        customer_id,
        purchased_at,
        delivered_at,
        order_status,
        item_count,
        total_price,
        total_freight,
        order_total,
        delivery_days,
        CASE 
            WHEN delivery_days <= 7 THEN 'Fast'
            WHEN delivery_days <= 14 THEN 'Normal'
            ELSE 'Slow'
        END AS delivery_speed_category
    FROM order_enriched
    WHERE order_status = 'delivered'
)

SELECT * FROM final
```

**Naming Convention**: 
- `fact_<entity>.sql` for fact tables
- `dim_<entity>.sql` for dimension tables

---

## ✅ Data Quality Tests

### Built-in dbt Tests

Applied in model YAML files (`schema.yml`):

```yaml
models:
  - name: stg_orders
    columns:
      - name: order_id
        tests:
          - unique
          - not_null
      
      - name: customer_id
        tests:
          - not_null
          - relationships:
              to: ref('stg_customers')
              field: customer_id
      
      - name: order_status
        tests:
          - accepted_values:
              values: ['delivered', 'shipped', 'canceled', 'processing']
```

**Test Types**:
- `unique`: No duplicate values
- `not_null`: No NULL values
- `relationships`: Foreign key validation
- `accepted_values`: Value must be in allowed list

### Custom Tests (`tests/`)

SQL queries that return failing records:

**Example**: `tests/assert_positive_revenue.sql`

```sql
-- Orders should have positive revenue
SELECT
    order_id,
    order_total
FROM {{ ref('fact_orders') }}
WHERE order_total <= 0
```

**Example**: `tests/assert_valid_delivery_dates.sql`

```sql
-- Delivery date should be after purchase date
SELECT
    order_id,
    purchased_at,
    delivered_at
FROM {{ ref('fact_orders') }}
WHERE delivered_at < purchased_at
```

### Running Tests

```bash
# Run all tests
dbt test

# Run tests for specific model
dbt test --select stg_orders

# Run tests for specific tag
dbt test --select tag:core

# Store failures for inspection
dbt test --store-failures
```

### Test Coverage

Track data quality metrics:
- **Coverage**: % of columns with tests
- **Pass Rate**: % of tests passing
- **Failure Analysis**: Review stored failures in Snowflake

---

## 🌱 Seeds

Seeds are CSV files with static reference data loaded as tables.

### Included Seeds

**`seeds/product_categories.csv`**
```csv
category_name_portuguese,category_name_english
beleza_saude,health_beauty
informatica_acessorios,computers_accessories
moveis_decoracao,furniture_decor
```

**`seeds/state_mappings.csv`**
```csv
state_code,state_name,region
SP,São Paulo,Southeast
RJ,Rio de Janeiro,Southeast
MG,Minas Gerais,Southeast
```

### Loading Seeds

```bash
# Load all seeds
dbt seed

# Load specific seed
dbt seed --select product_categories

# Full refresh (drop and recreate)
dbt seed --full-refresh
```

### Using Seeds in Models

```sql
SELECT
    p.product_category_name,
    pc.category_name_english,
    COUNT(*) AS product_count
FROM {{ ref('stg_products') }} p
LEFT JOIN {{ ref('product_categories') }} pc
    ON p.product_category_name = pc.category_name_portuguese
GROUP BY 1, 2
```

---

## 📸 Snapshots

Snapshots implement **Type-2 Slowly Changing Dimensions** to track historical changes.

### Snapshot Strategy

**`snapshots/snap_customers.sql`**

```sql
{% snapshot snap_customers %}

{{
    config(
      target_schema='snapshots',
      unique_key='customer_id',
      strategy='timestamp',
      updated_at='updated_at'
    )
}}

SELECT * FROM {{ ref('stg_customers') }}

{% endsnapshot %}
```

### How It Works

- **First Run**: Captures current state with `dbt_valid_from`
- **Subsequent Runs**: Detects changes and:
  - Sets `dbt_valid_to` on old record
  - Inserts new record with updated `dbt_valid_from`

### Running Snapshots

```bash
# Create/update snapshots
dbt snapshot

# Query historical data
SELECT * FROM snapshots.snap_customers
WHERE customer_id = '12345'
ORDER BY dbt_valid_from;
```

### Use Cases

- Track customer address changes over time
- Monitor seller rating evolution
- Audit product category reclassifications

---

## 🔧 Macros

Reusable Jinja + SQL functions for DRY (Don't Repeat Yourself) code.

### Custom Macros

**`macros/generate_schema_name.sql`**

```sql
{% macro generate_schema_name(custom_schema_name, node) -%}
    {%- set default_schema = target.schema -%}
    {%- if custom_schema_name is none -%}
        {{ default_schema }}
    {%- else -%}
        {{ custom_schema_name | trim }}
    {%- endif -%}
{%- endmacro %}
```

**`macros/cents_to_dollars.sql`**

```sql
{% macro cents_to_dollars(column_name, scale=2) %}
    ROUND({{ column_name }} / 100, {{ scale }})
{% endmacro %}
```

### Using Macros in Models

```sql
SELECT
    order_id,
    {{ cents_to_dollars('price_cents') }} AS price_dollars
FROM {{ ref('stg_order_items') }}
```

### Testing Macros

**`macros/test_valid_percentage.sql`**

```sql
{% test valid_percentage(model, column_name) %}

SELECT *
FROM {{ model }}
WHERE {{ column_name }} < 0 OR {{ column_name }} > 100

{% endtest %}
```

Apply in schema.yml:

```yaml
- name: discount_percentage
  tests:
    - valid_percentage
```

---

## 💻 Usage & Commands

### Essential dbt Commands

#### Connection & Setup

```bash
# Test Snowflake connection
dbt debug

# Install package dependencies
dbt deps

# Load seed files
dbt seed
```

#### Running Models

```bash
# Run all models
dbt run

# Run specific model
dbt run --select stg_orders

# Run model and all downstream dependencies
dbt run --select stg_orders+

# Run model and all upstream dependencies
dbt run --select +fact_orders

# Run models by folder
dbt run --select staging
dbt run --select marts

# Run models by tag
dbt run --select tag:daily

# Full refresh (rebuild incremental models)
dbt run --full-refresh
```

#### Testing

```bash
# Run all tests
dbt test

# Test specific model
dbt test --select stg_orders

# Test specific column
dbt test --select stg_orders,column:order_id
```

#### Snapshots

```bash
# Run all snapshots
dbt snapshot

# Run specific snapshot
dbt snapshot --select snap_customers
```

#### Documentation

```bash
# Generate documentation
dbt docs generate

# Serve documentation locally (opens browser)
dbt docs serve --port 8080
```

#### Combined Commands

```bash
# Run everything (seeds, models, snapshots, tests)
dbt build

# Run with specific target
dbt run --target prod

# Compile without executing
dbt compile
```

### Advanced Options

```bash
# Run with multiple threads (parallel execution)
dbt run --threads 8

# Exclude specific models
dbt run --exclude staging

# Run modified models only
dbt run --select state:modified

# Fail fast (stop on first error)
dbt run --fail-fast
```

---

## 👨‍💻 Development Workflow

### Adding New Models

1. **Create SQL file** in appropriate folder:
   ```bash
   touch models/staging/stg_new_table.sql
   ```

2. **Write transformation logic**:
   ```sql
   WITH source AS (
       SELECT * FROM {{ source('olist_raw', 'new_table') }}
   )
   
   SELECT
       id,
       name,
       created_at
   FROM source
   ```

3. **Add documentation** in `schema.yml`:
   ```yaml
   - name: stg_new_table
     description: "Staging model for new table"
     columns:
       - name: id
         description: "Primary key"
         tests:
           - unique
           - not_null
   ```

4. **Run and test**:
   ```bash
   dbt run --select stg_new_table
   dbt test --select stg_new_table
   ```

### Adding New Tests

1. **Create test file** in `tests/`:
   ```bash
   touch tests/assert_new_validation.sql
   ```

2. **Write test query** (returns failing records):
   ```sql
   SELECT *
   FROM {{ ref('fact_orders') }}
   WHERE some_invalid_condition
   ```

3. **Run test**:
   ```bash
   dbt test --select assert_new_validation
   ```

### Best Practices

✅ **DO**:
- Use meaningful model names (`stg_`, `int_`, `fact_`, `dim_` prefixes)
- Add descriptions to all models and columns
- Write tests for critical business logic
- Use CTEs for readability
- Reference models with `{{ ref() }}` and sources with `{{ source() }}`
- Keep models focused (single responsibility)
- Use consistent formatting (sqlfluff recommended)

❌ **DON'T**:
- Hard-code database/schema names
- Use `SELECT *` in production models
- Skip documentation
- Create circular dependencies
- Mix business logic in staging models

### Git Workflow

```bash
# Create feature branch
git checkout -b feature/new-customer-metrics

# Make changes and test locally
dbt run --select +new_model
dbt test --select +new_model

# Commit changes
git add models/marts/new_model.sql
git commit -m "Add new customer lifetime value model"

# Push and create PR
git push origin feature/new-customer-metrics
```

### Code Review Checklist

- [ ] Model runs successfully
- [ ] All tests pass
- [ ] Documentation added
- [ ] Follows naming conventions
- [ ] No hard-coded values
- [ ] Efficient SQL (no unnecessary joins)
- [ ] Appropriate materialization strategy

---

## 📊 Data Lineage & Documentation

### Generating Documentation

```bash
# Generate docs
dbt docs generate

# Serve locally
dbt docs serve
```

This creates an interactive website with:
- **Model descriptions** and column details
- **Data lineage graph** (DAG visualization)
- **Source freshness** information
- **Test results** and coverage
- **SQL code** for each model

### Understanding the DAG

The **Directed Acyclic Graph** shows:
- **Dependencies**: Which models depend on others
- **Layers**: Visual separation of staging → intermediate → marts
- **Complexity**: Identify bottlenecks and optimization opportunities

**Example DAG Flow**:
```
source('olist_raw', 'orders')
    ↓
stg_orders
    ↓
int_order_enriched
    ↓
fact_orders
```

### Navigating Documentation

1. **Project Overview**: High-level project information
2. **Database Tab**: Browse all models by schema
3. **Graph Tab**: Interactive lineage visualization
4. **Model Details**: Click any model to see:
   - Description and metadata
   - Column definitions
   - SQL code
   - Tests applied
   - Upstream/downstream dependencies

### Adding Rich Documentation

**In `schema.yml`**:

```yaml
models:
  - name: fact_orders
    description: |
      # Order Facts
      
      This table contains one row per delivered order with:
      - Order totals and item counts
      - Delivery performance metrics
      - Customer and geographic dimensions
      
      **Grain**: One row per order
      **Refresh**: Daily at 2 AM UTC
    
    columns:
      - name: order_id
        description: "Unique identifier for each order (PK)"
      
      - name: order_total
        description: "Total order value including freight (in BRL)"
```

---

## 🔧 Troubleshooting

### Common Issues & Solutions

#### ❌ Connection Failed

**Error**: `Database Error: 250001 (08001): Failed to connect to DB`

**Solutions**:
- Verify Snowflake account identifier in `profiles.yml`
- Check username/password credentials
- Ensure warehouse is running (not suspended)
- Verify network connectivity and firewall rules
- Test with `dbt debug`

#### ❌ Compilation Error

**Error**: `Compilation Error: Model 'stg_orders' depends on a node named 'source.olist_raw.orders' which was not found`

**Solutions**:
- Verify source is defined in `sources.yml`
- Check database and schema names match Snowflake
- Ensure you have SELECT permissions on source tables
- Run `dbt compile` to see detailed error

#### ❌ Test Failures

**Error**: `Failure in test unique_stg_orders_order_id`

**Solutions**:
- Query the model to find duplicates:
  ```sql
  SELECT order_id, COUNT(*)
  FROM stg_orders
  GROUP BY order_id
  HAVING COUNT(*) > 1
  ```
- Check source data quality
- Review transformation logic for unintended duplication
- Use `--store-failures` to save failing rows

#### ❌ Incremental Model Issues

**Error**: Incremental model not updating correctly

**Solutions**:
- Run with `--full-refresh` to rebuild
- Verify `unique_key` is correctly defined
- Check `incremental_strategy` configuration
- Ensure `is_incremental()` logic is correct

#### ❌ Permission Denied

**Error**: `SQL access control error: Insufficient privileges`

**Solutions**:
- Grant necessary permissions:
  ```sql
  GRANT USAGE ON DATABASE OLIST_ANALYTICS TO ROLE TRANSFORMER;
  GRANT CREATE TABLE ON SCHEMA MARTS TO ROLE TRANSFORMER;
  ```
- Verify role has warehouse usage rights
- Check if role is assigned to your user

### Performance Optimization

#### Slow Model Execution

**Strategies**:
1. **Use appropriate materialization**:
   - Views for small, frequently changing data
   - Tables for large, stable datasets
   - Incremental for append-only large tables

2. **Optimize SQL**:
   - Filter early in CTEs
   - Avoid unnecessary joins
   - Use `QUALIFY` for window function filtering
   - Leverage Snowflake clustering keys

3. **Increase warehouse size**:
   ```yaml
   # In profiles.yml
   warehouse: TRANSFORMING_LARGE  # XS → S → M → L
   ```

4. **Parallelize execution**:
   ```bash
   dbt run --threads 8
   ```

#### Large dbt Runs

**Strategies**:
- Use `state:modified` to run only changed models
- Implement incremental models for large fact tables
- Schedule different model groups at different times
- Use dbt Cloud for orchestration

### Getting Help

1. **Check dbt logs**: `logs/dbt.log`
2. **Review compiled SQL**: `target/compiled/`
3. **dbt Documentation**: https://docs.getdbt.com
4. **dbt Community Slack**: https://www.getdbt.com/community/
5. **Snowflake Documentation**: https://docs.snowflake.com

---

## 🤝 Contributing

We welcome contributions! Here's how to get involved:

### How to Contribute

1. **Fork the repository**
2. **Create a feature branch**:
   ```bash
   git checkout -b feature/amazing-feature
   ```
3. **Make your changes** following our style guidelines
4. **Test thoroughly**:
   ```bash
   dbt run --select +your_model
   dbt test --select +your_model
   ```
5. **Commit with clear messages**:
   ```bash
   git commit -m "Add customer segmentation model"
   ```
6. **Push to your fork**:
   ```bash
   git push origin feature/amazing-feature
   ```
7. **Open a Pull Request** with detailed description

### Code Review Process

1. **Automated checks** must pass (if CI/CD configured)
2. **Peer review** by at least one maintainer
3. **Documentation** must be updated
4. **Tests** must be included for new models
5. **Approval** required before merge

### Style Guidelines

#### SQL Style

- Use **lowercase** for SQL keywords
- **Indent** with 4 spaces (no tabs)
- **One column per line** in SELECT statements
- **Trailing commas** for easier diffs
- **Meaningful aliases** (avoid `a`, `b`, `c`)

**Example**:

```sql
select
    order_id,
    customer_id,
    sum(price) as total_price,
    count(*) as item_count
from {{ ref('stg_order_items') }}
where order_status = 'delivered'
group by
    order_id,
    customer_id
```

#### Naming Conventions

- **Models**: `<layer>_<entity>_<description>.sql`
- **Tests**: `assert_<validation_description>.sql`
- **Macros**: `<verb>_<noun>.sql`
- **Columns**: `snake_case`

#### Documentation Standards

- All models must have descriptions
- Key columns must be documented
- Business logic should be explained
- Include grain and refresh frequency for marts

### Reporting Issues

Use GitHub Issues with:
- **Clear title** describing the problem
- **Steps to reproduce**
- **Expected vs actual behavior**
- **dbt version** and environment details
- **Relevant logs** or error messages

---

## 🗺️ Project Roadmap

### ✅ Completed

- [x] Initial project setup with Snowflake and dbt
- [x] Staging models for all Olist tables
- [x] Core fact and dimension tables
- [x] Basic data quality tests
- [x] Documentation framework

### 🚧 In Progress

- [ ] Advanced customer segmentation models
- [ ] Seller performance analytics
- [ ] Product recommendation features
- [ ] Incremental model optimization

### 📋 Planned Features

#### Q2 2026
- [ ] **Real-time data ingestion** with Snowflake Streams
- [ ] **dbt Cloud integration** for orchestration
- [ ] **Data quality dashboards** in Preset/Tableau
- [ ] **Machine learning features** for churn prediction

#### Q3 2026
- [ ] **Multi-language support** for product categories
- [ ] **Advanced anomaly detection** tests
- [ ] **Cost optimization** analysis and recommendations
- [ ] **API integration** for external data enrichment

#### Q4 2026
- [ ] **Cross-database support** (BigQuery, Redshift)
- [ ] **dbt Mesh** implementation for modular architecture
- [ ] **Automated data profiling** and cataloging
- [ ] **Governance framework** with data contracts

### 💡 Ideas & Suggestions

Have an idea? Open an issue with the `enhancement` label!

---

## 📄 License

This project is licensed under the **MIT License**.

```
MIT License

Copyright (c) 2026 Sathwika Reddy Papaiahgari

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

See [LICENSE](LICENSE) file for full details.

---

## 📧 Contact & Acknowledgments

### Contact

**Sathwika Reddy Papaiahgari**

- 📧 Email: sathwikap1012@gmail.com
- 🐙 GitHub:https://github.com/Sathwikareddy24 

### Acknowledgments

- **Olist**: For providing the [Brazilian E-Commerce Public Dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) on Kaggle
- **dbt Labs**: For the incredible dbt framework and community
- **Snowflake**: For the powerful cloud data platform
- **Analytics Engineering Community**: For best practices and inspiration

### Dataset Citation

```
Olist Brazilian E-Commerce Dataset
Source: Kaggle (https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)
License: CC BY-NC-SA 4.0
```

### Built With

- [dbt Core](https://www.getdbt.com/) - Data transformation framework
- [Snowflake](https://www.snowflake.com/) - Cloud data platform
- [SQL](https://en.wikipedia.org/wiki/SQL) - Query language
- [Jinja](https://jinja.palletsprojects.com/) - Templating engine

---

<div align="center">

**⭐ If you found this project helpful, please consider giving it a star!**

Made with ❤️ and ☕ by Sathwika Reddy Papaiahgari

</div>
