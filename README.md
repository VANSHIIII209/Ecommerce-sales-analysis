# 📊 Ecommerce Sales Analysis — Olist Brazilian E-Commerce

A complete SQL + Power BI analysis of the Olist Brazilian E-Commerce dataset, covering revenue trends, delivery performance, customer segmentation (RFM), payment behavior, product category performance, and seller-level insights.

## 🎯 Business Problem

Olist is a Brazilian e-commerce marketplace connecting small businesses (sellers) to customers across the country. This project analyzes ~99,000 orders to answer real business questions: How is revenue trending? Are deliveries reliable? Who are our best and worst customers? Which sellers drive revenue — and do they maintain customer satisfaction while doing it?

## 🛠️ Tools Used

- **MySQL Workbench** — data cleaning, querying, and analysis (CTEs, window functions, joins, aggregations)
- **Power BI Desktop** — interactive dashboard and visualization
- **Git & GitHub** — version control and project hosting

## 📁 Project Structure

- **`sql/`** — All analysis queries, organized by topic (overview, delivery, revenue, RFM, payments, categories, sellers)
- **`findings/key_insights.md`** — Full write-up of findings for each analysis
- **`dashboard_overview.jpeg`** — Power BI dashboard, Page 1
- **`seller_performance.jpeg`** — Power BI dashboard, Page 2
- **`README.md`** — This file

## 🔍 Key Findings

### Overview
- **98,666 unique orders**, generating **R$13.59M** in total product revenue (excluding freight).

### Delivery Performance
- Average delivery time: **12.44 days** from purchase to customer delivery.
- Only **6.50%** of orders arrived later than the estimated delivery date — suggesting Olist builds a reliability buffer into its delivery estimates rather than promising the fastest possible date.

### Revenue Trends
- Strong, consistent month-over-month growth from Jan 2017 through Nov 2017.
- Nov 2017 was the peak month, likely tied to Black Friday seasonality.
- Order volume plateaus from 2018 onward rather than continuing to grow (with the final month appearing lower, likely due to an incomplete data collection cutoff rather than a genuine decline).

### Customer Segmentation (RFM)
Built using Recency, Frequency, and Monetary value via layered CTEs and window functions:
- **Regular**: 43.57% | **Lost**: 39.49% | **Big Spender**: 16.40% | **At Risk**: 0.51% | **Champion**: 0.02%
- **Key insight**: "Champion" customers are almost nonexistent because repeat purchasing is rare on this platform — the vast majority of customers are one-time buyers. This suggests Olist's growth is driven primarily by new customer acquisition rather than loyalty, pointing to a potential opportunity in retention strategy.
- **Technical note**: Frequency scoring required custom business-defined buckets instead of `NTILE()`, since most customers placed exactly one order — NTILE's equal-split logic produced misleading, inconsistent scores for identical order counts.

### Payment Behavior
- **Credit card** is the dominant payment method (76,509 of ~103,500 payments), processing R$12.49M — the large majority of total revenue.
- Credit card is the only method with meaningful installment usage (avg. 3.5 installments); boleto, voucher, and debit card are always paid in full.

### Product Categories
- Top revenue category: **beleza_saude** (health & beauty) — 8,551 orders, R$1.22M revenue.
- **relogios_presentes** (watches/gifts) has the highest average item price despite lower order volume — a premium, lower-volume category.
- **cama_mesa_banho** (bed/bath/table) has the highest order count but a lower average item price — a high-volume, lower-value category.

### Seller Performance (10+ orders)
- The highest-revenue seller (1,132 orders, R$2,29,472 revenue) shows a notably low average review score of **2.33** — high sales volume does not guarantee customer satisfaction.
- Another high-volume seller (1,806 orders, R$2,00,472 revenue) achieved a **5.00** average review score, proving strong volume and strong satisfaction can coexist.

## 📸 Dashboard

**Page 1 — Overview**
![Dashboard Overview](dashboard_overview.jpeg)

**Page 2 — Seller Performance**
![Seller Performance](seller_performance.jpeg)

## 🧹 Data Cleaning Notes

- Date columns (`order_purchase_timestamp`, `order_delivered_customer_date`, etc.) were imported as `text` rather than native date types, requiring `CAST(... AS DATETIME)` before any date-based calculations.
- `olist_customers_dataset` contains two identifiers: `customer_id` (unique per order) and `customer_unique_id` (unique per real customer) — the latter was used for all customer-level analysis (e.g., RFM) to avoid overcounting.
- A small number of orders had delivery date values that failed to convert via `CAST`, likely due to malformed source data — flagged rather than silently dropped.

## 🚀 What I'd Explore Next

- Correlation between delivery delay and review score (attempted, but limited by a CSV import issue in the reviews dataset caused by embedded line breaks in review text — a good candidate for a future data-cleaning pass using Python).
- Sales forecasting for the upcoming year using historical monthly trends.
- Deeper regional/logistics analysis — does distance between seller and customer predict delivery delay or freight cost?

---

*Dataset: [Olist Brazilian E-Commerce (Kaggle)](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)*
