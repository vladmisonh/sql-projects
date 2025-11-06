CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    signup_date DATE,
    region VARCHAR(50),
    acquisition_channel VARCHAR(50)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    category VARCHAR(50),
    unit_cost NUMERIC(10,2),
    unit_price NUMERIC(10,2)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    status VARCHAR(20),
    traffic_source VARCHAR(50),
    coupon_code VARCHAR(50),
    order_amount NUMERIC(12,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_id INT,
    product_id INT,
    quantity INT,
    unit_price NUMERIC(10,2),
    unit_cost NUMERIC(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE marketing_spend (
    month DATE,
    channel VARCHAR(50),
    spend NUMERIC(12,2)
);