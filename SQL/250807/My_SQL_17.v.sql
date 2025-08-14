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

SELECT count(*)
FROM orders
-- WHERE order_date >= (CURDATE() - 30);
WHERE order_date >= (CURDATE() - INTERVAL 30 DAY);

# 상품별 최근 한달간 주문 건수를 구하세요
SELECT * FROM orders 
LIMIT 1 ;

SELECT * FROM customers
LIMIT 1 ;


SELECT * FROM products LIMIT 1;

SELECT O.product_id, P.product_name ,COUNT(*) recent_order_count
FROM orders O
JOIN products P ON O.product_id = P.product_id
WHERE O.order_date >= (CURRENT_DATE() - INTERVAL 30 DAY)
GROUP BY product_id
ORDER BY recent_order_count DESC;

# 고객별 총 구매 건수 + 수량

SELECT C.customer_id, C.name, COUNT(O.order_id) order_count , SUM(O.quantity) order_quantity FROM customers C
JOIN orders O ON O.customer_id = C.customer_id
GROUP BY customer_id
ORDER BY order_count DESC;
----
SELECT O.customer_id, C.name, COUNT(*) order_count, SUM(O.quantity) total_quantity
FROM orders O
JOIN customers C ON O.customer_id = C.customer_id
GROUP BY customer_id;

# 고객별 총 구매금액 계산 후 출력
SELECT C.customer_id, C.name, SUM(O.quantity * P.discount_price) AS total_buying  FROM orders O
JOIN products P ON O.product_id = P.product_id
JOIN customers C ON C.customer_id = O.customer_id
GROUP BY customer_id
ORDER BY total_buying DESC;
----
SELECT 
	O.customer_id,
    C.name,
    SUM(O.quantity * P.discount_price) total_spent
FROM orders O 
JOIN customers C ON O.customer_id = C.customer_id
JOIN products P ON O.product_id = P.product_id
GROUP BY O.customer_id
ORDER BY total_spent DESC;

# 지금까지 가장 많이 판매된 상품 T(*수량)OP 5를 출력해 주세요!
SELECT O.product_id, product_name, SUM(quantity) FROM orders O
JOIN products P ON O.product_id = P.product_id
GROUP BY product_id
ORDER BY SUM(quantity) DESC
LIMIT 5;
----
SELECT P.product_name, SUM(O.quantity) total_sold FROM orders O
JOIN products P ON O.product_id = P.product_id
GROUP BY O.product_id
ORDER BY total_sold DESC
LIMIT 5;

# 평균 평점이 4.5 이상인 상품명과 평점 출력
SELECT P.product_id, product_name, AVG(R.rating) FROM products P
JOIN reviews R ON R.product_id = P.product_id
GROUP BY product_id
HAVING AVG(rating) >= 4.5
ORDER BY AVG(rating) DESC;
-----
SELECT P.product_name, AVG(rating) avg_rating
FROM reviews R
JOIN products P ON R.product_id = P.product_id
GROUP BY R.product_id
HAVING AVG(rating) >= 4.5;