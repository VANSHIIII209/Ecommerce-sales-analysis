-- Payment method breakdown: count, total value, and average installments per method
SELECT 
    payment_type,
    COUNT(*) AS num_payments,
    SUM(payment_value) AS total_value,
    ROUND(AVG(payment_installments), 1) AS avg_installments
FROM olist_order_payments_dataset
GROUP BY payment_type
ORDER BY num_payments DESC;