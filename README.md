# 🛒 E-Commerce Funnel & Customer Analytics Using SQL

## 📌 Project Overview

This project analyzes an e-commerce business using SQL to uncover insights related to customer behavior, sales performance, funnel conversion, retention, marketing effectiveness, product performance, and customer satisfaction.

The analysis focuses on identifying revenue drivers, customer purchasing patterns, conversion bottlenecks, and opportunities to improve business performance through data-driven decision-making.

---

## 🎯 Business Objectives

- Analyze sales and revenue performance.
- Measure customer acquisition and retention.
- Track customer journey through the conversion funnel.
- Identify top-performing products and categories.
- Evaluate marketing channel effectiveness.
- Measure customer churn and repeat purchase behavior.
- Analyze customer satisfaction using product reviews.

---

## 🗂️ Database Schema

### Customers
| Column |
|----------|
| customer_id |
| name |
| email |
| country |
| age |
| signup_date |
| marketing_opt_in |

### Sessions
| Column |
|----------|
| session_id |
| customer_id |
| start_time |
| device |
| source |
| country |

### Events
| Column |
|----------|
| event_id |
| session_id |
| timestamp |
| event_type |
| product_id |
| qty |
| cart_size |
| payment |
| discount_pct |
| amount_usd |

### Orders
| Column |
|----------|
| order_id |
| customer_id |
| order_time |
| payment_method |
| discount_pct |
| subtotal_usd |
| total_usd |
| country |
| device |
| source |

### Order_Items
| Column |
|----------|
| order_id |
| product_id |
| unit_price_usd |
| quantity |
| line_total_usd |

### Products
| Column |
|----------|
| product_id |
| category |
| name |
| price_usd |
| cost_usd |
| margin_usd |

### Reviews
| Column |
|----------|
| review_id |
| order_id |
| product_id |
| rating |
| review_text |
| review_time |

---

## 📊 Key Business Questions

### Sales & Revenue Analysis
- What is the total revenue generated?
- What is the total profit generated?
- What is the Average Order Value (AOV)?
- How many orders were placed?
- Which country generates the highest revenue?

### Customer Analysis
- How many customers signed up?
- What percentage of customers are repeat buyers?
- Who are the top 10 customers by revenue?
- What is Customer Lifetime Value (CLV)?
- How long does it take customers to make their first purchase?

### Churn & Retention Analysis
- What is the customer churn rate?
- What is the customer retention rate?

### Funnel Analysis
- How many users viewed products?
- How many users added products to cart?
- How many users reached checkout?
- How many users completed purchases?
- What is the overall conversion rate?
- What is the cart abandonment rate?
- What is the overall drop-off rate?

### Product Analysis
- Which products generate the highest revenue?
- Which products sell the most units?
- Which categories generate the highest revenue?

### Marketing Analysis
- Which acquisition source generates the most revenue?
- Which acquisition source generates the highest conversion?

### Device Analysis
- Which device generates the most revenue?
- Which device contributes the most orders?

### Review Analysis
- What is the average product rating?
- Which products have the highest ratings?
- Which products have the lowest ratings?

---

## 📈 Key KPIs

- Total Revenue
- Total Profit
- Total Orders
- Total Customers
- Average Order Value (AOV)
- Conversion Rate
- Cart Abandonment Rate
- Drop-Off Rate
- Customer Churn Rate
- Customer Retention Rate
- Average Product Rating

---

## 🔄 Funnel Analysis

The customer journey is analyzed through the following funnel stages:

View → Add To Cart → Checkout → Purchase

The funnel analysis helps identify:

- Conversion bottlenecks
- Customer drop-off points
- Cart abandonment behavior
- Revenue optimization opportunities

---

## 🛠️ SQL Concepts Used

- Joins
- Common Table Expressions (CTEs)
- Aggregate Functions
- CASE Statements
- Window Functions
- Conversion Rate Analysis
- Funnel Analysis
- Churn Analysis
- Retention Analysis
- Customer Segmentation Logic
- Business KPI Calculations

---

## 📋 Dashboard Overview

### Page 1: Funnel Dashboard

KPIs:
- Total Revenue
- Total Orders
- Total Profit
- Conversion Rate
- Cart Abandonment Rate
- Drop-Off Rate

Visuals:
- Funnel Chart
- Revenue Trend
- Funnel Breakdown by Source / Device / Category
- Conversion Rate Analysis
- Drop-Off Analysis

### Page 2: Customer & Product Dashboard

KPIs:
- Total Customers
- Repeat Purchase Rate
- Churn Rate
- Average Rating

Visuals:
- Top Products
- Top Categories
- Revenue by Country
- Revenue by Source
- Customer Analysis
- Ratings Analysis

---

## 🚀 Conclusion

This project demonstrates how SQL can be used to solve real-world e-commerce business problems by analyzing customer behavior, sales performance, marketing effectiveness, funnel conversion, and customer retention. The insights generated can help businesses optimize customer experience, improve conversion rates, and drive revenue growth.
