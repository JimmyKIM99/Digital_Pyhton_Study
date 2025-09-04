SELECT
	customer_id,
    rental_date,
    COUNT(*) OVER (PARTITION BY customer_id ORDER BY rental_date) AS count
FROM rental;

# 고객별 대여 날짜별 누적 대여 횟수 계산

SELECT
	rental_date,
    customer_id,
    COUNT(*) OVER (PARTITION BY customer_id ORDER BY rental_date
					ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) COUNTS
FROM rental;

SELECT
	rental_date,
    customer_id,
    COUNT(*) OVER (PARTITION BY customer_id ORDER BY rental_date
					ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) COUNTS
FROM rental;

SELECT
	rental_date,
    customer_id,
    COUNT(*) OVER (PARTITION BY customer_id ORDER BY rental_date
					ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) COUNTS
FROM rental;

SELECT
	R.customer_id,
	R.rental_date,
	P.amount,
    SUM(P.amount) OVER (PARTITION BY R.customer_id ORDER BY rental_date
						ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
FROM payment P
JOIN rental R USING(rental_id);

SELECT
	R.customer_id,
	R.rental_date,
	P.amount,
    DATE (R.rental_date),
    SUM(P.amount) OVER (PARTITION BY R.customer_id ORDER BY rental_date
						ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
FROM payment P
JOIN rental R USING(rental_id);

SELECT
	R.customer_id,
	R.rental_date,
	P.amount,
    DATE (R.rental_date),
    SUM(P.amount) OVER (PARTITION BY R.customer_id ORDER BY DATE(rental_date)
						RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
FROM payment P
JOIN rental R USING(rental_id);

SELECT
	I.film_id,
	P.amount,
    P.payment_date,
    SUM(P.amount) OVER (PARTITION BY I.film_id ORDER BY P.payment_date
						ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
FROM payment P
JOIN rental R USING(rental_id)
JOIN inventory I USING(inventory_id);


# 장르별 영화 대여 수익 / 영화 장르의 수익성 분석 / 누적 합계, 전체 대여 수익 대비 비율
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
	C.name,
    SUM(P.amount) OVER (PARTITION BY C.category_id ORDER BY P.amount
						ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
FROM category C
JOIN film_category FC USING(category_id)
JOIN inventory I USING(film_id)
JOIN rental R USING(inventory_id)
JOIN payment P USING(rental_id);

WITH genre_revenue AS(
	SELECT
		C.name genre,
		SUM(P.amount) revenue
	FROM payment P
	JOIN rental R USING(rental_id)
	JOIN inventory I USING(inventory_id)
	JOIN film_category FC USING(film_id)
	JOIN category C USING(category_id)
	GROUP BY C.name
)
SELECT 
	genre,
    revenue,
    SUM(revenue) OVER (ORDER BY revenue DESC
						ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) revenue2,
	revenue / SUM(revenue) OVER () AS revenue_ratio
FROM genre_revenue;

SELECT 
	rental_id,
    rental_date,
    LAG(rental_id, 1, 0) OVER (ORDER BY rental_date) prev_rental,
    LEAD(rental_id, 1, 0) OVER (ORDER BY rental_date) next_rental
FROM rental;

SELECT
	I.film_id,
    R.rental_date,
    FIRST_VALUE(R.rental_date) OVER (PARTITION BY I.film_id ORDER BY R.rental_date) FIRST,
    LAST_VALUE(R.rental_date) OVER (PARTITION BY I.film_id ORDER BY R.rental_date
									ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) LAST
FROM rental R
JOIN inventory I USING(inventory_id);

#Sakila DB를 참고해서, 가장 많은 영화를 대여한 고객(*단,  가장 많은 영화의 기준 -> 동일한 영화를 반복해서 대여한 경우의 수는 제외, 오직 서로 다른 영화를 대여했다는 기준으로만) 을 찾아내고, 
# 해당 고객이 대여한 영화 갯수를 찾아주세요. 또한 해당 고객이 대여한 영화가 가장 많이 속한 카테고리(*단, 이때에는 동일한 영화를 반복해서 대여한 경우의 수도 포함)도 찾아주세요.
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



SELECT TB.customer_id, TB.Total_rental1, total_rent, TB.TT, TB.TA-- , TB.first_name, TB.last_name
FROM
(SELECT 
	DISTINCT C.customer_id,
--     DISTINCT C.first_name,
--     DISTINCT C.last_name,
	COUNT(*) OVER (PARTITION BY C.customer_id) AS total_rent,
	FIRST_VALUE(COUNT(*)) OVER(PARTITION BY C.customer_id, CA.category_id  ORDER BY COUNT(*) DESC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) TT,
	FIRST_VALUE(CA.name) OVER(PARTITION BY CA.category_id  ORDER BY COUNT(*) DESC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) TA,
	DENSE_RANK() OVER (PARTITION BY C.customer_id ORDER BY COUNT(*) DESC) Total_rental1
-- 	COUNT(*) OVER(PARTITION BY C.customer_id) AS Total_rental2
--     CA.name
FROM customer C
JOIN rental R USING(customer_id)
JOIN inventory I USING(inventory_id)
JOIN film_category F USING(film_id)
JOIN category CA USING(category_id)
GROUP BY C.customer_id, F.film_id, CA.category_id) AS TB
WHERE TB.Total_rental1 = 1
-- ORDER BY TB.Total_rental DESC;

-- ORDER BY Total_rental1 DESC
-- LIMIT 1;


