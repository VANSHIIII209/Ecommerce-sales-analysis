-- RFM (Recency, Frequency, Monetary) customer segmentation
-- Segments customers into: Champion, Big Spender, At Risk, Lost, Regular
-- Note: Frequency scoring uses custom CASE WHEN buckets instead of NTILE,
-- since most customers placed only 1 order, which caused NTILE to produce
-- inconsistent scores for identical order counts.

WITH customer_last_order AS (
    SELECT 
        c.customer_unique_id,
        MAX(CAST(o.order_purchase_timestamp AS DATETIME)) AS last_order_date
    FROM olist_orders_dataset o
    JOIN olist_customers_dataset c ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
),
customer_frequency AS (
    SELECT 
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS total_orders
    FROM olist_orders_dataset o
    JOIN olist_customers_dataset c ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
),
customer_monetary AS (
    SELECT 
        c.customer_unique_id,
        SUM(oi.price) AS total_spent
    FROM olist_orders_dataset o
    JOIN olist_customers_dataset c ON o.customer_id = c.customer_id
    JOIN olist_order_items_dataset oi ON o.order_id = oi.order_id
    GROUP BY c.customer_unique_id
),
rfm_combined AS (
    SELECT 
        r.customer_unique_id,
        r.last_order_date,
        f.total_orders,
        m.total_spent
    FROM customer_last_order r
    JOIN customer_frequency f ON r.customer_unique_id = f.customer_unique_id
    JOIN customer_monetary m ON r.customer_unique_id = m.customer_unique_id
),
rfm_scored AS (
    SELECT 
        customer_unique_id,
        last_order_date,
        total_orders,
        total_spent,
        NTILE(5) OVER (ORDER BY last_order_date ASC) AS recency_score,
        CASE 
            WHEN total_orders = 1 THEN 1
            WHEN total_orders = 2 THEN 3
            WHEN total_orders BETWEEN 3 AND 4 THEN 4
            ELSE 5
        END AS frequency_score,
        NTILE(5) OVER (ORDER BY total_spent ASC) AS monetary_score
    FROM rfm_combined
),
rfm_segmented AS (
    SELECT 
        customer_unique_id,
        CASE 
            WHEN recency_score >= 4 AND frequency_score >= 4 AND monetary_score >= 4 THEN 'Champion'
            WHEN recency_score >= 4 AND monetary_score >= 4 THEN 'Big Spender'
            WHEN recency_score <= 2 AND frequency_score >= 3 THEN 'At Risk'
            WHEN recency_score <= 2 AND frequency_score <= 2 THEN 'Lost'
            ELSE 'Regular'
        END AS customer_segment
    FROM rfm_scored
)
SELECT 
    customer_segment,
    COUNT(*) AS num_customers,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS pct_of_customers
FROM rfm_segmented
GROUP BY customer_segment
ORDER BY num_customers DESC;