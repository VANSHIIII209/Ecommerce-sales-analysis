# Key Insights — Olist E-Commerce Analysis

## Overview
- Total unique orders: 98,666
- Total revenue: R$13,591,643.70 (from order items, excluding freight)
- Note: raw item-count was 112,650 — the gap reflects orders containing multiple items, so distinct order count was needed for an accurate figure.

## Delivery Performance
- Average delivery time (purchase to customer delivery): 12.44 days
- Only 6.50% of orders (2,700 out of 41,570) arrived later than the estimated delivery date — suggests Olist builds a reliability buffer into its delivery estimates rather than promising the fastest possible date.
- Data quality note: a small number of orders have delivery date values that fail to convert via CAST — likely malformed text in the original CSV. Flagged for further investigation/cleaning.

## Data Cleaning Notes
- Date columns (`order_purchase_timestamp`, `order_delivered_customer_date`, etc.) were imported as `text` type, not native dates — required CAST(... AS DATETIME) before any date-based calculations.
- `olist_customers_dataset` has two identifiers: `customer_id` (unique per order) and `customer_unique_id` (unique per real customer) — must use the latter for any "number of unique customers" type questions.

## Revenue Trends
- Strong, consistent month-over-month growth from Jan 2017 through Nov 2017 (from 316 to 3,182 orders/month).
- Nov 2017 was the peak month (3,182 orders, R$434,671 revenue) — likely tied to Black Friday seasonality.
- From Jan 2018 onward, order volume plateaus in the 2,500–3,000/month range rather than continuing to grow.
- Caveat: the dataset appears to have incomplete data toward the end (Aug 2018 shows fewer orders) — likely a data collection cutoff rather than a genuine decline. This should be verified before concluding the business was shrinking.

## Customer Segmentation (RFM Analysis)
- Built using Recency (days since last order), Frequency (order count), and Monetary (total spend), combined via CTEs and window functions.
- Frequency scoring required custom business-defined buckets instead of NTILE, because most customers (the vast majority) placed only 1 order — NTILE's equal-split logic produced misleading, inconsistent scores for identical order counts.
- Segment breakdown:
  - Regular: 43.57% (17,702 customers)
  - Lost: 39.49% (16,043 customers)
  - Big Spender: 16.40% (6,665 customers)
  - At Risk: 0.51% (209 customers)
  - Champion: 0.02% (10 customers)
- Key insight: "Champion" customers (high recency + high frequency + high monetary) are almost nonexistent, because repeat purchasing is rare on this platform — the vast majority of customers are one-time buyers. This suggests Olist's growth is driven primarily by new customer acquisition rather than repeat/loyal customers, and could indicate an opportunity for retention-focused strategies.

## Payment Behavior
- Credit card is the dominant payment method: 76,509 payments (out of ~103,500 total), processing R$12.49M — the large majority of total revenue.
- Credit card is the only method with meaningful installment usage (avg 3.5 installments per payment). Boleto, voucher, and debit card are always paid in full (avg 1.0 installment) — consistent with how these payment types work in Brazil.
- Data quality note: 3 records have payment_type = 'not_defined' with payment_value = 0 — likely incomplete/erroneous records, worth excluding from deeper monetary analysis.