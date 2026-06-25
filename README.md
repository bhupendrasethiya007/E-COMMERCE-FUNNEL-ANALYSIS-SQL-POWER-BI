# 🛒 E-Commerce Funnel  Analytics || SQL POWER BI 


## 📊 Project Overview

This project analyzes customer behavior, sales performance, product performance, and conversion funnel effectiveness using SQL and Power BI. The analysis is based on an e-commerce dataset containing over **800,000+ records** and approximately **20,000 customers** across multiple business processes, including customer acquisition, product interactions, orders, and reviews.

The project focuses on understanding the complete customer journey from product views to purchases, identifying conversion bottlenecks, evaluating customer retention, measuring marketing performance, and uncovering opportunities to improve revenue and profitability through data-driven insights.



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

## 📂 Dataset

The dataset used in this project was sourced from Kaggle.

Dataset Link:
https://www.kaggle.com/code/wafaaelhusseini/eda-e-commerce-transactions-clickstream/input?select=sessions.csv




---





# 📊 SQL Analysis Performed

## Sales & Revenue Analysis

### 1. What is the total revenue generated?

```sql
SELECT SUM(line_total_usd) AS total_sales
FROM order_items;
```

### 2. What is the total profit generated?

```sql
SELECT SUM(oi.quantity * p.margin_usd) AS total_profit
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id;
```

### 3. What is the Average Order Value (AOV)?

```sql
SELECT SUM(oi.line_total_usd) / COUNT(o.order_id) AS AOV
FROM order_items oi
JOIN orders o
ON oi.order_id = o.order_id;
```

### 4. How many orders were placed?

```sql
SELECT COUNT(order_id)
FROM orders;
```

### 5. What is the average revenue per customer?

```sql
SELECT AVG(line_total_usd)
FROM order_items;
```

### 6. Which country generates the highest revenue?

```sql
SELECT country,
       SUM(total_usd) AS revenue
FROM orders
GROUP BY country
ORDER BY revenue DESC;
```

---

# 👥 Customer Analysis

### 7. How many customers have signed up?

```sql
SELECT COUNT(*)
FROM customers;
```

### 8. What percentage of customers are repeat buyers?

```sql
SELECT
ROUND(
100.0 * COUNT(*) /
(SELECT COUNT(DISTINCT customer_id) FROM orders),
2
)
FROM (
SELECT customer_id
FROM orders
GROUP BY customer_id
HAVING COUNT(order_id) > 1
) t;
```

### 9. Who are the top 10 customers by revenue?

```sql
SELECT c.customer_id,
       SUM(o.total_usd) AS revenue
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id
ORDER BY revenue DESC
LIMIT 10;
```

### 10. What is the average customer lifetime value (CLV)?

```sql
SELECT c.customer_id,
       AVG(o.total_usd) AS clv
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id;
```

### 11. How long does it take customers to make their first purchase?

```sql
SELECT c.customer_id,
       c.signup_date,
       MIN(o.order_time::date) AS first_order,
       MIN(o.order_time::date) - c.signup_date AS days_to_first_order
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id,c.signup_date;
```

---

# 📉 Churn & Retention Analysis

### 12. What is the customer churn rate?

```sql
WITH last_purchase AS (
SELECT customer_id,
       MAX(order_time::date) AS last_order_date
FROM orders
GROUP BY customer_id
)
SELECT ...
```

### 13. What is the customer retention rate?

```sql
SELECT
ROUND(
100.0 *
COUNT(CASE WHEN order_count > 1 THEN 1 END)
/ COUNT(*),
2
)
FROM (
SELECT customer_id,
       COUNT(*) AS order_count
FROM orders
GROUP BY customer_id
)t;
```

---

# 🔄 Funnel Analysis

### 14. How many users viewed products?

```sql
SELECT COUNT(DISTINCT session_id)
FROM events
WHERE event_type = 'Page_View';
```

### 15. How many users added products to cart?

```sql
SELECT COUNT(DISTINCT session_id)
FROM events
WHERE event_type = 'Add_To_Cart';
```

### 16. How many users reached checkout?

```sql
SELECT COUNT(DISTINCT session_id)
FROM events
WHERE event_type = 'Checkout';
```

### 17. How many users completed purchases?

```sql
SELECT COUNT(DISTINCT session_id)
FROM events
WHERE event_type = 'Purchase';
```

### 18. What is the overall conversion rate?

```sql
WITH funnel AS (
SELECT
COUNT(DISTINCT CASE WHEN event_type='Page_View'
THEN session_id END) AS views,
COUNT(DISTINCT CASE WHEN event_type='Purchase'
THEN session_id END) AS purchases
FROM events
)
SELECT ROUND(
100.0 * purchases / NULLIF(views,0),
2
)
FROM funnel;
```

### 19. What is the View → Cart conversion rate?

```sql
WITH f AS (...)
SELECT ...
```

### 20. What is the Cart → Purchase conversion rate?

```sql
WITH f AS (...)
SELECT ...
```

### 21. What is the Checkout → Purchase conversion rate?

```sql
WITH f AS (...)
SELECT ...
```

### 22. What is the cart abandonment rate?

```sql
WITH f AS (...)
SELECT ...
```

### 23. Where does the largest drop-off occur?

```sql
WITH funnel AS (...)
SELECT ...
```

---

# 📦 Product Analysis

### 24. Which products generate the highest revenue?

```sql
SELECT p.name,
       SUM(oi.line_total_usd) AS revenue
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.name
ORDER BY revenue DESC;
```

### 25. Which products sell the most units?

```sql
SELECT p.name,
       SUM(oi.quantity) AS units_sold
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.name
ORDER BY units_sold DESC;
```

### 26. Which categories generate the highest revenue?

```sql
SELECT p.category,
       SUM(oi.quantity) AS revenue
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.category
ORDER BY revenue DESC;
```

### 27. Which products receive the most views?

```sql
SELECT p.name,
       COUNT(*) AS total_views
FROM products p
JOIN events e
ON p.product_id = e.product_id
WHERE e.event_type='Page_View'
GROUP BY p.name
ORDER BY total_views DESC;
```

---

# 📢 Marketing Analysis

### 28. Which acquisition source generates the most revenue?

```sql
SELECT source,
       SUM(total_usd) AS revenue
FROM orders
GROUP BY source
ORDER BY revenue DESC;
```

### 29. Which acquisition source has the highest conversion rate?

```sql
WITH sessions_count AS (...),
orders_count AS (...)
SELECT ...
```

---

# 📱 Device Analysis

### 30. Which device generates the most revenue?

```sql
SELECT device,
       SUM(total_usd) AS revenue
FROM orders
GROUP BY device
ORDER BY revenue DESC;
```

### 31. Which device has the highest conversion rate?

```sql
WITH sessions_count AS (...),
orders_count AS (...)
SELECT ...
```

---

# 💳 Payment Analysis

### 32. Which payment method is used most frequently?

```sql
SELECT payment_method,
       COUNT(*)
FROM orders
GROUP BY payment_method
ORDER BY COUNT(*) DESC;
```

### 33. Which payment method generates the highest revenue?

```sql
SELECT payment_method,
       SUM(total_usd)
FROM orders
GROUP BY payment_method
ORDER BY SUM(total_usd) DESC;
```

---

# ⭐ Review Analysis

### 34. What is the average product rating?

```sql
SELECT AVG(rating)
FROM reviews;
```

### 35. Which products have the highest ratings?

```sql
SELECT p.name,
       r.rating
FROM reviews r
JOIN products p
ON p.product_id = r.product_id
ORDER BY rating DESC;
```

### 36. Which products have the lowest ratings?

```sql
SELECT p.name,
       r.rating
FROM reviews r
JOIN products p
ON p.product_id = r.product_id
ORDER BY rating;
```

### 37. Which categories have the highest average ratings?

```sql
SELECT p.category,
       AVG(r.rating) AS avg_rating
FROM reviews r
JOIN products p
ON p.product_id = r.product_id
GROUP BY p.category
ORDER BY avg_rating DESC;
```
### 38. What is the Bounce Rate?
** What percentage of sessions leave the website after only one interaction without progressing further into the customer journey?
```sql
WITH session_events AS (
    SELECT
        session_id,
        COUNT(*) AS event_count
    FROM events
    GROUP BY session_id
)
SELECT
    ROUND(
        100.0 *
        COUNT(CASE WHEN event_count = 1 THEN 1 END)
        / COUNT(*),
        2
    ) AS bounce_rate
FROM session_events;
```
## 📸 Dashboard Preview

<p align="center">
  <img src="Dashboard.jpg" width="1000">
</p>
## 📈 Business Insights

- The platform generated **$4.49M in total sales** from customer purchases.
- The overall **conversion rate was 27.98%**, indicating that nearly 28% of visitors completed a purchase.
- The **drop-off rate of 72.02%** highlights a significant loss of users before reaching the final purchase stage.
- The **cart abandonment rate reached 58.81%**, suggesting many users added products to their cart but did not complete checkout.
- Out of **120,000 product views**, approximately **33,580 purchases** were completed through the funnel.
- **Mobile devices generated the highest revenue**, making mobile users the most valuable customer segment.
- **Organic traffic was the largest revenue source**, followed by direct traffic, indicating strong organic acquisition performance.
- The largest decline in the funnel occurred between the **Add-to-Cart** and **Purchase** stages, representing an opportunity to optimize the checkout process.
- Revenue contribution varied significantly across traffic sources, highlighting the importance of channel performance analysis.
- Funnel metrics suggest that improving checkout experience and reducing cart abandonment could significantly increase conversions and revenue.
