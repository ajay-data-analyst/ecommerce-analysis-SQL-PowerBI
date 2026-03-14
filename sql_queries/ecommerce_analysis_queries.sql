
-- =====================================================
-- E-Commerce Sales Intelligence – SQL Analysis
-- Author: Ajay Thakur
-- Database: ecommerce_analysis
-- =====================================================

-- 1. Monthly Revenue Trend
SELECT
DATE_FORMAT(o.order_purchase_timestamp,'%Y-%m') AS order_month,
ROUND(SUM(p.payment_value),2) AS revenue
FROM orders o
JOIN payments p ON o.order_id = p.order_id
GROUP BY order_month
ORDER BY order_month;

-- 2. Revenue by Product Category
SELECT
p.product_category_name,
ROUND(SUM(oi.price),2) AS revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY revenue DESC;

-- 3. Top 10 Revenue Generating Products
SELECT
oi.product_id,
ROUND(SUM(oi.price),2) AS product_revenue
FROM order_items oi
GROUP BY oi.product_id
ORDER BY product_revenue DESC
LIMIT 10;

-- 4. Revenue by Customer State
SELECT
c.customer_state,
ROUND(SUM(p.payment_value),2) AS revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN payments p ON o.order_id = p.order_id
GROUP BY c.customer_state
ORDER BY revenue DESC;

-- 5. Average Delivery Time
SELECT
AVG(DATEDIFF(order_delivered_customer_date,
order_purchase_timestamp)) AS avg_delivery_days
FROM orders
WHERE order_delivered_customer_date IS NOT NULL;

-- 6. Monthly Revenue Growth Rate
SELECT
DATE_FORMAT(order_purchase_timestamp,'%Y-%m') AS order_month,
SUM(payment_value) AS revenue,
LAG(SUM(payment_value)) OVER(ORDER BY DATE_FORMAT(order_purchase_timestamp,'%Y-%m')) AS prev_month_revenue,
ROUND(
(SUM(payment_value) -
LAG(SUM(payment_value)) OVER(ORDER BY DATE_FORMAT(order_purchase_timestamp,'%Y-%m')))
/
LAG(SUM(payment_value)) OVER(ORDER BY DATE_FORMAT(order_purchase_timestamp,'%Y-%m')) * 100
,2) AS growth_rate
FROM orders o
JOIN payments p ON o.order_id = p.order_id
GROUP BY order_month;

-- 7. Top Performing Product Categories
SELECT
p.product_category_name,
COUNT(DISTINCT oi.order_id) AS total_orders,
ROUND(SUM(oi.price),2) AS revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY revenue DESC
LIMIT 10;

-- 8. Order Volume and Revenue by State
SELECT
c.customer_state,
COUNT(DISTINCT o.order_id) AS total_orders,
ROUND(SUM(p.payment_value),2) AS revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN payments p ON o.order_id = p.order_id
GROUP BY c.customer_state
ORDER BY revenue DESC;

-- 9. Customer Lifetime Value
SELECT
c.customer_unique_id,
COUNT(o.order_id) AS total_orders,
ROUND(SUM(p.payment_value),2) AS lifetime_value
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN payments p ON o.order_id = p.order_id
GROUP BY c.customer_unique_id
ORDER BY lifetime_value DESC
LIMIT 20;

-- 10. Product Demand by Category
SELECT
p.product_category_name,
COUNT(oi.order_item_id) AS total_products_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY total_products_sold DESC;

-- 11. Average Delivery Time by State
SELECT
c.customer_state,
AVG(DATEDIFF(order_delivered_customer_date,
order_purchase_timestamp)) AS avg_delivery_days
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE order_delivered_customer_date IS NOT NULL
GROUP BY c.customer_state
ORDER BY avg_delivery_days;

-- 12. Most Active Customers
SELECT
customer_id,
COUNT(order_id) AS order_count
FROM orders
GROUP BY customer_id
ORDER BY order_count DESC
LIMIT 10;

-- 13. Yearly Revenue Trend
SELECT
YEAR(order_purchase_timestamp) AS order_year,
ROUND(SUM(payment_value),2) AS revenue
FROM orders o
JOIN payments p ON o.order_id = p.order_id
GROUP BY order_year
ORDER BY order_year;

-- 14. Monthly Order Volume
SELECT
DATE_FORMAT(order_purchase_timestamp,'%Y-%m') AS order_month,
COUNT(order_id) AS total_orders
FROM orders
GROUP BY order_month
ORDER BY order_month;

-- 15. Average Order Value by State
SELECT
c.customer_state,
ROUND(AVG(p.payment_value),2) AS avg_order_value
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN payments p ON o.order_id = p.order_id
GROUP BY c.customer_state
ORDER BY avg_order_value DESC;

-- 16. Total Items Sold by Category
SELECT
p.product_category_name,
COUNT(oi.order_item_id) AS total_items_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY total_items_sold DESC;

-- 17. Repeat Customers
SELECT
customer_unique_id,
COUNT(o.order_id) AS order_count
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY customer_unique_id
HAVING order_count > 1
ORDER BY order_count DESC;

-- 18. Delivery Performance by Product Category
SELECT
p.product_category_name,
AVG(DATEDIFF(o.order_delivered_customer_date,
o.order_purchase_timestamp)) AS avg_delivery_days
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.order_delivered_customer_date IS NOT NULL
GROUP BY p.product_category_name
ORDER BY avg_delivery_days;
