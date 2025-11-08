-- Run basic data quality checks after loading data

-- 1. Row counts
SELECT 
	'customers' AS table_name, 
	COUNT(*) AS row_count 
FROM customers
UNION ALL
SELECT 
	'products', 
	COUNT(*) 
FROM products
UNION ALL
SELECT 
	'orders', 
	COUNT(*) 
FROM orders
UNION ALL
SELECT 
	'order_items', 
	COUNT(*) 
FROM order_items
UNION ALL
SELECT 
	'marketing_spend', 
	COUNT(*) 
FROM marketing_spend
ORDER BY table_name;

-- 2. Primary key uniqueness checks
SELECT 
	'customers' AS table_name, 
	customer_id, 
	COUNT(*) AS cnt
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

SELECT 
	'products' AS table_name, 
	product_id, 
	COUNT(*) AS cnt
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1;

SELECT 
	'orders' AS table_name, 
	order_id, 
	COUNT(*) AS cnt
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;

-- 3. NOT NULL
SELECT *
FROM customers
WHERE customer_id IS NULL
   OR signup_date IS NULL
   OR region IS NULL;

SELECT *
FROM products
WHERE product_id IS NULL
   OR product_name IS NULL
   OR category IS NULL
   OR unit_cost IS NULL
   OR unit_price IS NULL;

SELECT *
FROM orders
WHERE order_id IS NULL
   OR customer_id IS NULL
   OR order_date IS NULL;

SELECT *
FROM order_items
WHERE order_id IS NULL
   OR product_id IS NULL
   OR quantity IS NULL;

-- 4. Foreign key consistency
SELECT 
	o.order_id, 
	o.customer_id
FROM orders AS o
LEFT JOIN customers c 
	ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

SELECT 
	oi.order_id, 
	COUNT(*) AS orphan_rows
FROM order_items oi
LEFT JOIN orders o 
	ON oi.order_id = o.order_id
WHERE o.order_id IS NULL
GROUP BY oi.order_id;

SELECT 
	oi.product_id, 
	COUNT(*) AS orphan_rows
FROM order_items oi
LEFT JOIN products p 
	ON oi.product_id = p.product_id
WHERE p.product_id IS NULL
GROUP BY oi.product_id;

-- 5. Date range sanity checks
SELECT MIN(order_date) AS min_order_date,
       MAX(order_date) AS max_order_date
FROM orders;

SELECT MIN(signup_date) AS min_signup_date,
       MAX(signup_date) AS max_signup_date
FROM customers;

SELECT MIN(month) AS min_marketing_month,
       MAX(month) AS max_marketing_month
FROM marketing_spend;

-- 6. Check for negative or zero values where not expected
SELECT *
FROM order_items
WHERE quantity <= 0
   OR unit_price < 0
   OR unit_cost < 0;

SELECT *
FROM marketing_spend
WHERE spend < 0;

-- 7. Domain checks
SELECT DISTINCT status
FROM orders
ORDER BY status;

SELECT DISTINCT traffic_source
FROM orders
ORDER BY traffic_source;

SELECT DISTINCT category
FROM products
ORDER BY category;

-- 8. Duplicate detection in order_items
SELECT 
	order_id, 
	product_id, 
	COUNT(*) AS cnt
FROM order_items
GROUP BY order_id, product_id
HAVING COUNT(*) > 1
ORDER BY cnt DESC;