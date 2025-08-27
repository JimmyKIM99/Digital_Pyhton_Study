USE sakila;
SHOW TABLES;
DESC actor;
SELECT * FROM actor LIMIT 1;

#  각 고객이 어떤 영화 카테고리를 가장 자주 대여하는지 알고 싶습니다. 각 고객별로 가장 많이 대여한 영화 카테고리와 해당 카테고리에서의 총 대여 횟수
# customer_id, inventory_id, film_id, category_id

SELECT
	C.first_name,
    C.last_name,
    CAT.name,
    COUNT(*)
FROM customer C
JOIN rental R USING(customer_id)
JOIN inventory I USING(inventory_id)
JOIN film_category FC USING(film_id)
JOIN category CAT USING(category_id)
GROUP BY 
	C.customer_id,
	CAT.category_id
HAVING COUNT(*) = (
	SELECT COUNT(*) FROM rental R2
    JOIN inventory I2 USING(inventory_id)
    JOIN film_category FC2 USING(film_id)
    WHERE R2.customer_id = C.customer_id
    GROUP BY FC2.category_id
    ORDER BY COUNT(*) DESC
    LIMIT 1
);

# 2006-02-14 날짜를 기준으로, 2006-01-15부터, 2006-02-14날짜까지 영화를 대여하지 않은 고객 찾아주세요

SELECT first_name, last_name 
FROM customer C
JOIN rental R USING(customer_id)
WHERE NOT EXISTS(
	SELECT R2.customer_id 
    FROM customer C2
    JOIN rental R2 USING(customer_id)
    WHERE R2.customer_id = C.customer_id
	GROUP BY customer_id
    HAVING rental_date BETWEEN '2006-01-15' AND '2006-02-14'
)
GROUP BY C.customer_id;

SELECT 
	C.first_name, C.last_name
FROM customer C
LEFT OUTER JOIN rental R 
ON C.customer_id = R.customer_id
AND TIMESTAMPDIFF(DAY, R.rental_date, '2006-02-14') <= 30
WHERE R.rental_id IS NULL
;

# 가장 최근에 영화를 반납한 상위 10명의 고객 이름과 해당 고객들이 대여한 영화의 이름

SELECT 
	C.first_name, 
    C.last_name,
    F.title
FROM customer C
JOIN rental R USING(customer_id)
JOIN inventory I USING(inventory_id)
JOIN film F USING(film_id)
GROUP BY C.customer_id, F.title
HAVING customer_id IN (
	SELECT R2.customer_id FROM rental R2
    ORDER BY return_date DESC
    LIMIT 10
); 

SELECT
	C.first_name,
    C.last_name,
    F.title,
    TIMESTAMPDIFF(DAY, R.rental_date, R.return_date)
FROM customer C
JOIN rental R USING(customer_id)
JOIN inventory I USING(inventory_id)
JOIN film F USING (film_id)
ORDER BY R.return_date DESC
LIMIT 10;

# 각 직원의 매출을 찾으세요, 각 지원의 매출이 회사 전체의 매출중 어느정도의 비율을 차지하는지 찾아보세요
SELECT * FROM film; #film_id
SELECT * FROM film_category; #film_id, cateogry_id
SELECT * FROM category; # category_id
SELECT * FROM rental; # rental_id, inventory_id, customer_id
SELECT * FROM inventory; # inventory_id, film_id
SELECT * FROM payment; # payment_id, staff_id
SELECT * FROM film; #film_id
SELECT * FROM inventory; # inventory_id, film_id
SELECT * FROM customer; #customer_id, address_id, store_id
SELECT * FROM store; #store_id, address_id
SELECT * FROM staff; #staff_id

SELECT 
	S.staff_id,
	SUM(amount) Total_SELL,
    SUM(amount)/(SELECT SUM(amount) PS FROM payment) AS contribution,
    S.first_name,
    S.last_name
FROM staff S
JOIN payment USING(staff_id)
GROUP BY S.staff_id;

SELECT
	S.staff_id,
    S.first_name, S.last_name,
    SUM(P.amount) AS staff_revenue,
    (SUM(P.amount) / (SELECT SUM(amount) FROM payment) * 100) revenue_percentage
FROM staff S
JOIN payment P USING(staff_id)
GROUP BY S.staff_id;







