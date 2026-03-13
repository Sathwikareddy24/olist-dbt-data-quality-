WITH orders AS (
    SELECT * FROM {{ ref('stg_orders') }}
),

products AS (
    SELECT * FROM {{ ref('stg_products') }}
),

final AS (
    SELECT
        o.order_id,
        o.customer_id,
        o.order_status,
        p.product_id,
        p.product_category_name,
        p.product_name_length
    FROM orders AS o
    LEFT JOIN products AS p 
        ON o.order_id = p.product_id  
)

SELECT * FROM final 

