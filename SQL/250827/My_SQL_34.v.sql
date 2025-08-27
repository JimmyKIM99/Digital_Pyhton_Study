SELECT
	title,
    length,
    RANK() OVER (ORDER BY length DESC) ranking,
    DENSE_RANK() OVER (ORDER BY length DESC) dense_ranking,
    ROW_NUMBER() OVER (ORDER BY length DESC) row_numvers
FROM film
ORDER BY length DESC;

SELECT
	C.customer_id,
    CONCAT(C.first_name, ' ', C.last_name) AS customer_name,
    SUM(P.amount) total_amount,
    RANK () OVER (ORDER BY SUM(P.amount) DESC) ranking,
    DENSE_RANK () OVER (ORDER BY SUM(P.amount) DESC) dense_ranking,
    ROW_NUMBER () OVER (ORDER BY SUM(P.amount) DESC) row_numbers
FROM customer C
JOIN payment P USING(customer_id)
GROUP BY C.customer_id;

SELECT
	customer_id,
    rental_date,
    COUNT(*) OVER (PARTITION BY customer_id ORDER BY rental_date
					ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) cumulative_date
FROM rental;

SELECT
	R.customer_id,
    R.rental_date,
    P.amount,
    SUM(P.amount) OVER (PARTITION BY R.customer_id ORDER BY DATE(R.rental_date))
FROM rental R
JOIN payment P USING(customer_id);

# customer 테이블에서 고객의 총 지출 금액을 계산하고, 총 지출 금액에 따라 고객의 순위를 메기세요 출력되어질 결과값은 고객 id, 고객이름, 총 지출 금액, 순위

SELECT 
	C.customer_id,
    C.first_name,
    C.last_name,
    SUM(P.amount) OVER (PARTITION BY C.customer_id ORDER BY SUM(P.amount))
FROM customer C
JOIN payment P USING(customer_id)
;
    
# film 테이블에서 각 영화의 대여횟수를 계산하고 대여횟수에 따라 영화의 순위를 매겨주세요 / 만약 같은 대여횟수가 발생했을 때에는 다음번째 순위를 건너뛰지 않고 출력해 주세요.
# 영화제목, 대여횟수, 순위


SELECT 
	F.title,
    COUNT(*),
    DENSE_RANK () OVER (ORDER BY COUNT(*) DESC)
FROM film F
JOIN inventory I USING(film_id)
JOIN rental R USING(inventory_id)
GROUP BY film_id;

SELECT
	F.title,
    COUNT(*)
FROM film F
JOIN inventory I USING(film_id)
JOIN rental R USING(inventory_id)
GROUP BY F.film_id;



