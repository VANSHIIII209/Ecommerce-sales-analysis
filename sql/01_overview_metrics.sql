SELECT
COUNT(DISTINCT order_id) AS total_orders,
SUM(price) AS total_revenue
FROM olist_order_items_dataset