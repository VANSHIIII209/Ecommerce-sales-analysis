-- Average delivery time (in days) from purchase to customer delivery
SELECT 
    AVG(DATEDIFF(
        CAST(order_delivered_customer_date AS DATETIME),
        CAST(order_purchase_timestamp AS DATETIME)
    )) AS avg_delivery_days
FROM olist_orders_dataset
WHERE order_delivered_customer_date IS NOT NULL;