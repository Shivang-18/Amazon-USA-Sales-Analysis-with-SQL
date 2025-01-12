 --Amazon sales project

DROP TABLE IF EXISTS shipping;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS inventory;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS sellers;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS category;
	
--category table
CREATE TABLE category(
	category_id INT PRIMARY KEY,
	category_name varchar(20)
);

--customers table
CREATE TABLE customers(
	customer_id int PRIMARY KEY,
	first_name varchar(10),
	last_name varchar(10),
	state varchar(15),
	address varchar(5) DEFAULT ('XXXX')
);

--sellers table
CREATE TABLE sellers(
	seller_id int PRIMARY KEY,
	seller_name varchar(20),
	origin varchar(10)
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

--products table
CREATE TABLE products(
	product_id int PRIMARY KEY,
	product_name varchar(50),
	price float,
	cogs float,
	category_id int, --FK
	FOREIGN KEY (category_id) REFERENCES category(category_id)
);

--order_items table
CREATE TABLE order_items(
	order_item_id int PRIMARY KEY,
	order_id int, --FK
	product_id int, --FK
	quantity int,
	price_per_unit float,
	FOREIGN KEY (order_id) REFERENCES orders(order_id),
	FOREIGN KEY (product_id) REFERENCES products(product_id)
	
);

--payments table
CREATE TABLE payments(
	payment_id int PRIMARY KEY,
	order_id int, --FK
	payment_date date,
	payment_status varchar(20),
	FOREIGN KEY (order_id) REFERENCES orders(order_id)
	
);


--shipping table
CREATE TABLE shipping(
	shipping_id int PRIMARY KEY,
	order_id int, --FK
	shipping_date date,
	return_date date,
	shipping_providers varchar(15),
	delivery_status varchar(15),
	FOREIGN KEY (order_id) REFERENCES orders(order_id)
	
);

--inventory table
CREATE TABLE inventory(
	inventory_id int PRIMARY KEY,
	product_id int, --FK
	stock int,
	warehouse_id int,
	last_stock_date date,
	FOREIGN KEY (product_id) REFERENCES products(product_id)
	
);




























	

