-- Average delivery time (in days) from purchase to customer delivery
SELECT 
    AVG(DATEDIFF(
        CAST(order_delivered_customer_date AS DATETIME),
        CAST(order_purchase_timestamp AS DATETIME)
    )) AS avg_delivery_days
FROM olist_orders_dataset
WHERE order_delivered_customer_date IS NOT NULL;


-- Percentage of orders delivered later than the estimated delivery date
SELECT 
    COUNT(*) AS total_delivered_orders,
    SUM(CASE WHEN DATEDIFF(
            CAST(order_delivered_customer_date AS DATETIME),
            CAST(order_estimated_delivery_date AS DATETIME)
        ) > 0 THEN 1 ELSE 0 END) AS late_orders,
    ROUND(
        SUM(CASE WHEN DATEDIFF(
                CAST(order_delivered_customer_date AS DATETIME),
                CAST(order_estimated_delivery_date AS DATETIME)
            ) > 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 
    2) AS pct_late
FROM olist_orders_dataset
WHERE order_delivered_customer_date IS NOT NULL
    AND order_estimated_delivery_date IS NOT NULL;