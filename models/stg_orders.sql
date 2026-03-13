WITH source_data AS (
    SELECT * FROM {{ source('raw_data' , 'RAW_ORDERS')}}

),
renamed_data AS(
    SELECT 
        order_id,
        customer_id,
        order_status,
        order_purchase_timestamp,
        order_approved_at,
        order_delivered_carrier_date,
        order_delivered_customer_date,
        order_estimated_delivery_date
    FROM source_data
)

SELECT * FROM renamed_data