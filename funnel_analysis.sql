-------------------------------------------------------------------------------


CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(150),
    country VARCHAR(50),
    age INT,
    signup_date DATE,
    marketing_opt_in BOOLEAN
);

CREATE TABLE sessions (
    session_id INT PRIMARY KEY,
    customer_id INT,
    start_time TIMESTAMP,
    device VARCHAR(50),
    source VARCHAR(50),
    country VARCHAR(50),

    FOREIGN KEY (customer_id)
    REFERENCES customers(customer_id)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    category VARCHAR(100),
    name VARCHAR(200),
    price_usd NUMERIC(10,2),
    cost_usd NUMERIC(10,2),
    margin_usd NUMERIC(10,2)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_time TIMESTAMP,
    payment_method VARCHAR(50),
    discount_pct NUMERIC(5,2),
    subtotal_usd NUMERIC(10,2),
    total_usd NUMERIC(10,2),
    country VARCHAR(50),
    device VARCHAR(50),
    source VARCHAR(50),

    FOREIGN KEY (customer_id)
    REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT,
    product_id INT,
    unit_price_usd NUMERIC(10,2),
    quantity INT,
    line_total_usd NUMERIC(10,2)
);
CREATE TABLE events (
    event_id INT PRIMARY KEY,
    session_id INT,
    timestamp TIMESTAMP,
    event_type VARCHAR(50),
    product_id INT,
    qty INT,
    cart_size INT,
    payment VARCHAR(50),
    discount_pct NUMERIC(5,2),
    amount_usd NUMERIC(10,2),

    FOREIGN KEY (session_id)
    REFERENCES sessions(session_id),

    FOREIGN KEY (product_id)
    REFERENCES products(product_id)
);

CREATE TABLE reviews (
    review_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    rating INT,
    review_text TEXT,
    review_time TIMESTAMP,

    FOREIGN KEY (order_id)
    REFERENCES orders(order_id),

    FOREIGN KEY (product_id)
    REFERENCES products(product_id)
);

-------------------------------------------------------------------------------------------
SELECT * FROM ORDER_ITEMS
SELECT * FROM ORDERS
SELECT * FROM PRODUCTS
SELECT * FROM  REVIEWS
SELECT * FROM SESSIONS
SELECT * FROM CUSTOMERS
SELECT * FROM EVENTS
-------------------------------------------------------------------------------------------

------------------------------Sales & Revenue Analysis------------------------------------
---1.What is the total revenue generated?

SELECT SUM(line_total_usd)
as total_sales
FROM order_items

---2.What is the total profit generated?
   SELECT SUM(oi.quantity*p.margin_usd) as total_profit
   FROM order_items oi
   JOIN
   products p
   ON oi.product_id=p.product_id

---3.What is the Average Order Value (AOV)?
     SELECT SUM(oi.line_total_usd)/COUNT(o.order_id) as AOV
	 FROM order_items oi
	 JOIN 
	 orders o
	 ON oi.order_id=o.order_id
	 
---4.How many orders were placed?
     SELECT COUNT(order_id) FROM orders

--5.What is the average revenue per customer?
    SELECT AVG(line_total_usd)
    as total_sales
    FROM order_items

---6.Which country generates the highest revenue?
      SELECT  country,SUM(total_usd) as total 
	  from orders
	  GROUP BY 1
	  ORDER BY 2 DESC

--------------------------------------------------------------------------------------------

--------------------------Customer Analysis-------------------------------------------------


---7.How many customers have signed up?
     SELECT  COUNT(signup_date) from customers

---8.What percentage of customers are repeat buyers?
       SELECT 
    ROUND(
        100.0 * COUNT(*) / (SELECT COUNT(DISTINCT customer_id) FROM orders),
        2
    ) AS repeat_buyer_percentage
FROM (
    SELECT customer_id
    FROM orders
    GROUP BY customer_id
    HAVING COUNT(order_id) > 1
) t;

---9.Who are the top 10 customers by revenue?
    SELECT c.customer_id, SUM(o.total_usd) as total
	FROM customers c
	JOIN orders o
	ON c.customer_id=o.customer_id
	GROUP BY  c.customer_id
	ORDER BY total DESC
	limit 10

---10.What is the average customer lifetime value (CLV)?
    SELECT c.customer_id, AVG(o.total_usd) as total
	FROM customers c
	JOIN orders o
	ON c.customer_id=o.customer_id
	GROUP BY  c.customer_id

---11.How long does it take a customer to make their first purchase
     SELECT c.customer_id,c.signup_date,
	 MIN(o.order_time::date) AS first_order,
	 MIN(o.order_time:: date) - (c.signup_date)  as days_to_first_order
	 FROM customers c
	 JOIN orders o
	 ON c.customer_id=o.customer_id
	 GROUP BY 1,2
	 ORDER BY days_to_first_order DESC

---12. Which age group spends the most?
      SELECT c.age,SUM(o.total_usd) as total
	  FROM customers c
	  JOIN orders o
	  ON c.customer_id=o.customer_id
	  GROUP BY c.age
	  ORDER BY total DESC
	  limit 10
	  
---13.Which age group places the most orders?	
      SELECT c.age,COUNT(o.order_id) as total
	  FROM customers c
	  JOIN orders o
	  ON c.customer_id=o.customer_id
	  GROUP BY c.age
	  ORDER BY total DESC
	  limit 10
	  
------------------------------------------------------------------------------------

------------------------------Churn & Retention Analysis---------------------------

---14.What is the Customer Churn Rate?
     WITH last_purchase AS (
    SELECT
        customer_id,
        MAX(order_time::date) AS last_order_date
    FROM orders
    GROUP BY customer_id
),
max_date AS (
    SELECT MAX(order_time::date) AS latest_date
    FROM orders
)
SELECT
    ROUND(
        100.0 * COUNT(*) /
        (SELECT COUNT(DISTINCT customer_id) FROM orders),
        2
    ) AS churn_rate
FROM last_purchase lp
CROSS JOIN max_date md
WHERE md.latest_date - lp.last_order_date > 90;


---15.What is the Customer Retention Rate?
      SELECT
    ROUND(
        100.0 *
        COUNT(CASE WHEN order_count > 1 THEN 1 END)
        / COUNT(*),
        2
    ) AS retention_rate
FROM (
    SELECT customer_id, COUNT(*) AS order_count
    FROM orders
    GROUP BY customer_id
) t;


---------------------------------------------------------------------------------------------

-----------------------------------FUNNEL ANALYSIS--------------------------------------------

---16.How many users viewed products?
     SELECT COUNT(DISTINCT session_id) AS users_viewed
FROM events
WHERE event_type = 'Page_View';

---17.How many users added products to cart?
      SELECT COUNT(DISTINCT session_id) AS users_viewed
FROM events
WHERE event_type = 'Add_To_Cart';

---18.How many users reached checkout?
         SELECT COUNT(DISTINCT session_id) AS users_viewed
FROM events
WHERE event_type = 'Checkout'; 

---19.How many users completed purchase?
           SELECT COUNT(DISTINCT session_id) AS users_viewed
FROM events
WHERE event_type = 'Purchase'; 

---20.Overall Conversion Rate
      WITH funnel AS (
       SELECT
        COUNT(DISTINCT CASE WHEN event_type='Page_View' THEN session_id END) AS views,
        COUNT(DISTINCT CASE WHEN event_type='Purchase' THEN session_id END) AS purchases
       FROM events
)
SELECT
    ROUND(
        100.0 * purchases / NULLIF(views, 0),
        2
    ) AS conversion_rate
FROM funnel;


---21.View  to Cart Rate
       WITH f AS (
    SELECT
        COUNT(DISTINCT CASE WHEN event_type='Page_View' THEN session_id END) AS views,
        COUNT(DISTINCT CASE WHEN event_type='Add_To_Cart' THEN session_id END) AS carts
    FROM events
)
SELECT
    ROUND(
        100.0 * carts / NULLIF(views, 0),
        2
    ) AS view_to_cart_rate
FROM f;

---22.Cart to Purchase
          WITH f AS (
    SELECT
        COUNT(DISTINCT CASE WHEN event_type='Add_To_Cart' THEN session_id END) AS views,
        COUNT(DISTINCT CASE WHEN event_type='Purchase' THEN session_id END) AS carts
    FROM events
)
SELECT
    ROUND(
        100.0 * carts / NULLIF(views, 0),
        2
    ) AS view_to_cart_rate
FROM f;

---23. Checkout to Purchase
              WITH f AS (
    SELECT
        COUNT(DISTINCT CASE WHEN event_type='Checkout' THEN session_id END) AS views,
        COUNT(DISTINCT CASE WHEN event_type='Purchase' THEN session_id END) AS carts
    FROM events
)
SELECT
    ROUND(
        100.0 * carts / NULLIF(views, 0),
        2
    ) AS view_to_cart_rate
FROM f;

---24.CART Abandonment Rate
WITH f AS (
    SELECT
        COUNT(DISTINCT CASE WHEN event_type='Add_To_Cart' THEN session_id END) AS carts,
        COUNT(DISTINCT CASE WHEN event_type='Purchase' THEN session_id END) AS purchases
    FROM events
)
SELECT
    ROUND(100.0 * (carts - purchases) / carts, 2) AS cart_abandonment_rate
FROM f;

---25 Where is the largest drop-off?
       WITH funnel AS (
    SELECT
        COUNT(DISTINCT CASE WHEN event_type='Page_View' THEN session_id END) AS views,
        COUNT(DISTINCT CASE WHEN event_type='Add_To_Cart' THEN session_id END) AS carts,
        COUNT(DISTINCT CASE WHEN event_type='Checkout' THEN session_id END) AS checkout,
        COUNT(DISTINCT CASE WHEN event_type='Purchase' THEN session_id END) AS purchases
    FROM events
)
SELECT 'View → Cart' AS step,
       views - carts AS dropoff
FROM funnel

UNION ALL

SELECT 'Cart → Checkout',
       carts - checkout
FROM funnel

UNION ALL

SELECT 'Checkout → Purchase',
       checkout - purchases
FROM funnel
ORDER BY dropoff DESC;

----------------------------------------------------------------------------------------------------

------------------------------Product Analysis-----------------------------------------------------
---26.Which products generate the highest revenue?
     SELECT p.name , sum(oi.line_total_usd) as total
	 FROM products p
	 JOIN 
	 order_items oi
	 ON p.product_id=oi.product_id
	 GROUP BY p.name
	 ORDER BY total DESC
	 LIMIT 1
     
---27.Which products sell the most units?
     SELECT p.name , sum(oi.quantity) as total
	 FROM products p
	 JOIN 
	 order_items oi
	 ON p.product_id=oi.product_id
	 GROUP BY p.name
	 ORDER BY total DESC
	 LIMIT 1
---28.Which categories generate the highest revenue?
     SELECT p.category , sum(oi.quantity) as total
	 FROM products p
	 JOIN 
	 order_items oi
	 ON p.product_id=oi.product_id
	 GROUP BY p.category
	 ORDER BY total DESC
	
---29.Which products have high views ?
      SELECT p.name,COUNT(e.event_type) as total_views
	  FROM products p
	  JOIN
	  events e
	  ON p.product_id=e.product_id
	  WHERE e.event_type='Page_View'
	  GROUP BY p.name
	  ORDER BY total_views DESC

----------------------------------------------------------------------------------------------
	  
--------------------------------Marketing Analysis---------------------------------------------

---30.Which acquisition source generates the most revenue?
       SELECT source,SUM(total_usd) as total
	   FROM orders
	   GROUP BY source
	   ORDER BY total DESC


       
---31.Which acquisition source has the highest conversion rate?

WITH sessions_count AS (
    SELECT
        source,
        COUNT(DISTINCT session_id) AS total_sessions
    FROM sessions
    GROUP BY source
),
orders_count AS (
    SELECT
        source,
        COUNT(order_id) AS total_orders
    FROM orders
    GROUP BY source
)
SELECT
    s.source,
    ROUND(
        100.0 * COALESCE(o.total_orders,0) /
        NULLIF(s.total_sessions,0),
        2
    ) AS conversion_rate
FROM sessions_count s
LEFT JOIN orders_count o
ON s.source = o.source
ORDER BY conversion_rate DESC;

--------------------------------------------------------------------------------------------

-----------------------------------Device Analysis------------------------------------------

---32.Which device generates the most revenue?
     SELECT device,SUM(total_usd) as total
	   FROM orders
	   GROUP BY device
	   ORDER BY total DESC
   

--33.Which device has the highest conversion rate?
      WITH sessions_count AS (
    SELECT
        device,
        COUNT(DISTINCT session_id) AS total_sessions
    FROM sessions
    GROUP BY  device
),
orders_count AS (
    SELECT
        device,
        COUNT(order_id) AS total_orders
    FROM orders
    GROUP BY  device
)
SELECT
    s.device,
    ROUND(
        100.0 * COALESCE(o.total_orders,0) /
        NULLIF(s.total_sessions,0),
        2
    ) AS conversion_rate
FROM sessions_count s
LEFT JOIN orders_count o
ON s.device = o.device
ORDER BY conversion_rate DESC;

---------------------------------------------------------------------------------------------------------

-------------------------------------------Payment Analysis----------------------------------------------

---34.Which payment method is used most frequently?
      SELECT payment_method ,COUNT(*) as total
	  FROM orders
	  GROUP BY payment_method
	  ORDER BY total DESC


---35.Which payment method generates the highest revenue?
        SELECT payment_method ,sum(total_usd) as total
	  FROM orders
	  GROUP BY payment_method
	  ORDER BY total DESC



--------------------------------------------------------------------------------------------------------------

-----------------------------------------Review Analysis-----------------------------------------------------
---36.What is the average product rating?
       SELECT AVG(rating) from reviews
	   
---37.Which products have the highest ratings?
      SELECT p.name,r.rating
	  FROM reviews r
	  JOIN products p
	  ON p.product_id=r.product_id
	  ORDER BY rating DESC
	  
---38.Which products have the lowest ratings?
       SELECT p.name,r.rating
	  FROM reviews r
	  JOIN products p
	  ON p.product_id=r.product_id
	  ORDER BY rating 
	  
---39.Which categories have the highest average ratings?
         SELECT p.category,	AVG(r.rating) AS Ratings
	  FROM reviews r
	  JOIN products p
	  ON p.product_id=r.product_id
	  GROUP BY category
	  ORDER BY Ratings DESC 



SELECT * FROM ORDERS




