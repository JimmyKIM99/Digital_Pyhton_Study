# 여러분들은 모두 나이키 브랜드의 데이터 마케팅 담당자 -> 
# 어떤 데이터가 존재 -> 최근 1년간 제품별 평균 매출을 산출 미션

CREATE DATABASE nike;
USE nike;
CREATE TABLE items (
	item_num INT PRIMARY KEY,
    item_price INT
);
CREATE TABLE orders (
    order_num INT PRIMARY KEY,
    item_num INT,
    oder_date DATETIME,
    FOREIGN KEY (item_num) REFERENCES items(item_num)
);

CREATE TABLE sale_record (
    years INT PRIMARY KEY,
    months INT
);
S
INSERT INTO items (item_num, item_price)
VALUES
(1, 25000),
(2, 25000),
(3, 40000),
(4, 35000),
(4, 35000);

INSERT INTO orders (order_num, item_num, oder_date)
VALUES
(101, 2 ,2025-05-24),
(102, 4 ,2025-05-24),
(103, 5 ,2025-05-24),
(104, 2 ,2025-05-24),
(105, 3 ,2025-05-24),
(106, 4 ,2025-05-24);









-----------------------
CREATE DATABASE IF NOT EXISTS nike_db;
USE nike_db;
CREATE table sales(
	sales_id INT PRIMARY KEY,
    product_id INT,
    sales_date DATE,
    amount INT
);

INSERT INTO sales (sales_id, product_id, sales_date,amount)
VALUES
(201, 1000, "2025-07-15", 200),
(202, 1000, "2025-07-15", 200),
(203, 1000, "2025-07-15", 200),
(204, 1000, "2025-07-15", 200),
(205, 1000, "2025-07-15", 200),
(206, 1000, "2025-07-15", 200),
(207, 1000, "2025-07-15", 200),
(208, 1000, "2025-07-15", 200);

SELECT * FROM sales;

SELECT 
	product_id,
	DATE_FORMAT(sales_date, '%Y-%M') AS sales_month,
    AVG(amount) AS avg_monthly_sales
FROM sales
WHERE sales_date >= CURDATE() - INTERVAL 1 YEAR
GROUP BY product_id, sales_month
ORDER BY product_id, sales_month;