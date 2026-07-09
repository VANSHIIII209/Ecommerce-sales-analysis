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