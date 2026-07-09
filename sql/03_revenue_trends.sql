-- Monthly order count and revenue trend
SELECT 
    DATE_FORMAT(CAST(o.order_purchase_timestamp AS DATETIME), '%Y-%m') AS order_month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.price) AS total_revenue
FROM olist_orders_dataset o
JOIN olist_order_items_dataset oi 
    ON o.order_id = oi.order_id
GROUP BY order_month
ORDER BY order_month;