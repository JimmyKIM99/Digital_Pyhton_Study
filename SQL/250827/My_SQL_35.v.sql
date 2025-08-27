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

