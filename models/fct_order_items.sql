WITH orders AS (
    SELECT * FROM {{ ref('stg_orders') }}
),

payments AS (
    SELECT * FROM {{ ref('stg_payments') }}
),

final AS (
    SELECT
        o.order_id,
        o.customer_id,
        o.order_status,
        pay.payment_type,
        pay.payment_value
    FROM orders AS o
    LEFT JOIN payments AS pay ON o.order_id = pay.order_id
)

SELECT * FROM final