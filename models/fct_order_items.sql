WITH orders AS (
    SELECT * FROM {{ ref('stg_orders') }}
),

order_items AS (
    SELECT * FROM {{ ref('stg_order_items') }}
),

products AS (
    SELECT * FROM {{ ref('stg_products') }}
),

final AS (
    SELECT
        o.order_id,
        o.customer_id,
        oi.product_id, -- We get the product_id from the items table
        p.product_category_name,
        p.product_name_length
    FROM orders AS o
    INNER JOIN order_items AS oi ON o.order_id = oi.order_id -- Link order to items
    LEFT JOIN products AS p ON oi.product_id = p.product_id -- Link items to product details
)

SELECT * FROM final