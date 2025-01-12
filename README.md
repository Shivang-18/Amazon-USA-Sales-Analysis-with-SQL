# Amazon USA Sales Analysis with SQL

## Project Overview
In this project, I conducted an in-depth analysis of a dataset containing over 20,000 sales records from an e-commerce platform similar to Amazon. Using PostgreSQL, I explored customer behavior, product performance, and sales trends to derive actionable insights.

This project showcases my SQL proficiency, emphasizing complex queries for business problems like revenue analysis, customer segmentation, and inventory management. Additionally, I performed data cleaning, managed null values, and created structured queries to address real-world challenges. An ERD diagram is included to illustrate the database schema and table relationships visually.

![amz erd postgres](https://github.com/user-attachments/assets/31bb6c7a-79ef-4b22-95f1-418b2a0b2319)


## Key Highlights

### 1. Data Cleaning & Preparation:

- Removed duplicate records from customer and order tables.
- Handled missing data, assigning defaults or categorizing as needed (e.g., “Pending” for payment statuses).
  
### 2. Complex Business Queries:

- Revenue and sales trend analysis.
- Customer segmentation and lifetime value computation.
- Inventory management with stock alert thresholds.
- Shipping delay investigations.

### 3. Real-World Problem Solving:

- Identified low-stock products, high return rates, and shipping delays.
- Explored customer retention challenges and seller inactivity.

## Schema Design

Here’s a snippet of the schema design, showcasing relationships between tables such as customers, orders, products, and more. These relationships are key to enabling comprehensive analysis.


```sql
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(10),
    last_name VARCHAR(10),
    state VARCHAR(15),
    address VARCHAR(5) DEFAULT ('XXXX')
);

--orders table
CREATE TABLE orders(

	order_id int PRIMARY KEY,
	order_date DATE, 
	customer_id int ,  --FK
	seller_id int, --FK
	order_status varchar(12),
	FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
 	FOREIGN KEY (seller_id) REFERENCES sellers(seller_id)
);
```

-- Additional table definitions available in the full SQL script.

## Objectives

The project demonstrates advanced SQL skills by solving practical e-commerce challenges, including:

- Analyzing sales trends and product performance.
- Enhancing inventory control and shipping efficiency.
- Identifying top customers and sellers to improve profitability.

## Sample Queries

Here are some of the queries I developed:


### 1. Top-Selling Products

Identify the top 10 products by total sales value.

```sql
SELECT
    p.product_name, 
    SUM(oi.quantity * oi.price_per_unit) AS total_sales
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sales DESC
LIMIT 10;
```

### 2. Monthly Sales Trends

Analyze sales trends grouped by month and compare current vs. previous months.

```sql
SELECT 
	year, month, total_sale as current_month_sale,
	LAG(total_sale, 1) OVER(ORDER BY year, month) as last_month_sale
FROM ---
(
SELECT 
	EXTRACT(MONTH FROM o.order_date) as month,
	EXTRACT(YEAR FROM o.order_date) as year,
	ROUND(
			SUM(oi.total_sale::numeric),2) as total_sale
FROM orders o
JOIN
order_items oi
ON oi.order_id = o.order_id
WHERE o.order_date >= CURRENT_DATE - INTERVAL '1 year'
GROUP BY 1, 2
ORDER BY year, month
) as t1
```

### 3. Customer Lifetime Value (CLTV)

Compute CLTV for each customer and rank them based on total spend.

```sql
SELECT 
	c.customer_id,
	CONCAT(c.first_name, ' ',  c.last_name) as full_name,
	SUM(total_sale) as CLTV,
	DENSE_RANK() OVER( ORDER BY SUM(total_sale) DESC) as cx_ranking
FROM orders o
JOIN customers c
ON c.customer_id = o.customer_id
JOIN order_items oi
ON oi.order_id = o.order_id
GROUP BY 1, 2
```

### 4. Shipping Delays

Identify orders with significant shipping delays.

```sql
SELECT 
	c.*, o.*, s.shipping_providers,
s.shipping_date - o.order_date as days_took_to_ship
FROM orders o
JOIN customers c
ON c.customer_id = o.customer_id
JOIN shippings s
ON o.order_id = s.order_id
WHERE s.shipping_date - o.order_date > 3
```

### 5. Inventory Stock Alerts

Flag products with critically low stock levels.

```sql
SELECT 
 i.inventory_id, p.product_name, i.stock as current_stock_left, 
 i.last_stock_date, i.warehouse_id
FROM inventory i
JOIN products p ON i.product_id = p.product_id
WHERE i.stock < 10;
```

## Key Takeaways

- Developed and optimized queries to derive business insights and solve operational challenges.
- Strengthened my ability to clean and transform data for analysis.
- Gained experience in designing relational databases and understanding schema relationships.
- Applied SQL techniques for advanced data analytics, focusing on scalability and accuracy.
