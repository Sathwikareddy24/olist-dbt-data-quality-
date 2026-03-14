SELECT
    order_id,
    payment_type,
    payment_value
FROM {{ source('raw_data', 'RAW_PAYMENTS') }}