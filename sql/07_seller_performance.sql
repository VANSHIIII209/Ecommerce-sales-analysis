-- Seller performance: total orders, revenue, and average review score (sellers with 10+ orders)
SELECT 
    s.seller_id,
    s.seller_city,
    s.seller_state,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    SUM(oi.price) AS total_revenue,
    ROUND(AVG(r.review_score), 2) AS avg_review_score
FROM olist_order_items_dataset oi
JOIN olist_sellers_dataset s 
    ON oi.seller_id = s.seller_id
LEFT JOIN olist_orders_dataset o 
    ON oi.order_id = o.order_id
LEFT JOIN olist_order_reviews_dataset r 
    ON o.order_id = r.order_id
GROUP BY s.seller_id, s.seller_city, s.seller_state
HAVING total_orders >= 10
ORDER BY total_revenue DESC
LIMIT 15;