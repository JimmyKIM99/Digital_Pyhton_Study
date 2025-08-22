SELECT
	title, rental_rate,
CASE 
	WHEN rental_rate < 0 THEN "Cheap"
    WHEN rental_rate BETWEEN 1 AND 3 THEN 'Moderate'
    ELSE "Expensive"
END AS PriceCategory
FROM film;

# WITH를 사용해서, sakila 데이터베이스의 각 등급별 영화의 평균 길이를 알아보세요
SELECT * FROM film;
WITH ratings AS (
	SELECT DISTINCT rating FROM film
)
SELECT F.rating, AVG(F.length)
FROM film F
JOIN ratings R ON R.rating = F.rating
GROUP BY F.rating;


WITH average_film AS 
(SELECT
	rating,
    AVG(length)
FROM film
GROUP BY rating)
SELECT * FROM average_film;
SELECT * FROM customer;

# WHEN절을 사용해서 customer 테이블의 고객들은 active 컬럼에 따라 "Active" 또는 "Inactive"로 분류 출력해주세요.
SELECT 
CASE 
	WHEN active = 1 THEN "Active"
    ELSE "Inactive"
END AS status
FROM customer;

SELECT
	customer_id,
    CASE
		WHEN active = 1 THEN "Active"
        ELSE "Inactive"
	END AS CustomerStatus
FROM customer;

# WITH를 사용해서, sakila의 film 테이블에서 각 rating에 따른 평균 rental_duration을 계산해 보세요.
SELECT * FROM film;

WITH avg_duration AS (
SELECT rating, avg(rental_duration)
FROM film
GROUP BY rating)
SELECT * FROM avg_duration;

WITH AvgRentalDuration AS (
	SELECT
		rating,
		AVG(rental_duration)
	FROM film
	GROUP by rating)
SELECT * FROM AvgRentalDuration;

# WITH를 사용해서 sakila의 payment 테이블에서 각 고객별 총 지불액을 계산하고,
# 그 지불액에 따라 고객을 "LOW, MEDIUM, HIGH"로 분류하세요


WITH Customer_Payinfo AS (
SELECT 
	CASE 
		WHEN SUM(amount) < 50 THEN "LOW"
        WHEN SUM(amount) BETWEEN 51 AND 100 THEN "Medium" 
        ELSE "High"
	END AS customer_grade
FROM payment
GROUP BY customer_id)
SELECT * FROM Customer_Payinfo;

WITH Customer_Payinfo AS (
 SELECT SUM(amount) AS SUM
 FROM payment
 GROUP BY customer_id
)
SELECT 
	CASE 
		WHEN SUM < 50 THEN "LOW"
        WHEN SUM BETWEEN 50 AND 100 THEN "Medium" 
        ELSE "High"
	END AS customer_grade
FROM Customer_Payinfo;


WITH CustomPayments AS (
	SELECT
		customer_id, SUM(amount) AS total_payment
	FROM payment
	GROUP BY customer_id)
SELECT 
	customer_id,
    total_payment,
    CASE
		WHEN ROUND(total_payment) BETWEEN 0 AND 50 THEN "LOW"
        WHEN ROUND(total_payment) BETWEEN 51 AND 100 THEN "Medium"
        ELSE "High"
    END AS PaymentStatus
FROM CustomPayments;


SELECT * FROM customer;

SELECT
	C.customer_id,
    CONCAT(C.first_name, " " ,C.last_name) AS customer_name,
    GROUP_CONCAT(F.title ORDER BY F.title ASC separator" / ") AS seen_movie
FROM customer C
JOIN rental R USING (customer_id)
JOIN inventory I USING (inventory_id)
JOIN film F USING (film_id)
GROUP BY C.customer_id
LIMIT 5;
SELECT * FROM actor;
SELECT * FROM inventory;
SELECT * FROM film;
SELECT * FROM film_actor;
# 각 배우(actor)가 출연한 영화들의 제목을 세미콜론으로 구분하여 하나의 문자열로 출력하세요 결과에는 배우 ID, 배우이름, 출연영화 제목 리스트 포함

SELECT 
	A.actor_id,
    CONCAT(A.first_name, " ", A.last_name) actor_name,
    GROUP_CONCAT(F.title SEPARATOR " ; ") title
FROM actor A
JOIN film_actor FA USING (actor_id)
JOIN film F USING (film_id)
GROUP BY A.actor_id;

# actor -> actor_id, first_name, last_name
# film_actor -> actor_id, film_id
# film -> film_id, title

SELECT
	A.actor_id,
    CONCAT(A.first_name, " ", A.last_name) AS actor_name,
    GROUP_CONCAT(F.title ORDER BY F.title ASC SEPARATOR " / ")
FROM actor AS A
JOIN film_actor FA ON FA.actor_id = A.actor_id
JOIN film F USING(film_id)
GROUP BY A.actor_id;
