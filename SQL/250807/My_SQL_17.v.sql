-- DROP DATABASE musinsa_db_v3;

CREATE DATABASE IF NOT EXISTS musinsa_db_v3;
USE musinsa_db_v3;
CREATE table customers (
	customer_id INT PRIMARY KEY,
    name VARCHAR(20),
    age TINYINT,
    gender VARCHAR(10),
    address TEXT, # 2바이트 메모리 값을 고정값으로 가져감
    email VARCHAR(100),
    phone VARCHAR(50),
    grade VARCHAR(20)
);

CREATE table products (
	product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    stock INT,
    main_category VARCHAR(20),
    sub_category VARCHAR(30),
    price INT,
    discount_price INT,
    discount_rate INT
);

CREATE table orders (
	order_id INT PRIMARY KEY,
    product_id INT,
    customer_id INT,
    quantity INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE table reviews (
	review_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    rating INT,
    review_text TEXT,
    review_date DATE,
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

SELECT grade, COUNT(*) FROM customers
GROUP BY grade
ORDER BY COUNT(*) DESC;

SELECT * FROM orders
LIMIT 10;

SELECT product_name FROM products
	WHERE product_id in
    (SELECT product_id FROM reviews
    WHERE AVG(rating) > 0)
GROUP BY product_name;

SELECT product_name, AVG(rating) RT
FROM products
JOIN reviews
ON products.product_id = reviews.product_id
GROUP BY product_name
ORDER BY RT DESC;

SELECT SUM(quantity)
FROM orders
WHERE order_date >= (CURDATE() - 30);