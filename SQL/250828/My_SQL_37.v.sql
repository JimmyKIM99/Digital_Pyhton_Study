# 영화 길이에 대한 백분위 순위와 누적분포 계산
# 백분위 순위 : 전체를 100% -> 0 ~ 1 사이의 값으로 판단 => PERCENT_RANK()
# 누적분포 : 전체를 기준으로 각 그룹의 비율이 몇프로대까지인지를 누적해서 보는것 => CUME_DISTINT
SELECT 
	title, length,
    PERCENT_RANK() OVER (ORDER BY length) AS percent,
    CUME_DIST() OVER (ORDER BY length) AS cume
FROM film;

SELECT
	customer_id,
    CONCAT(first_name, ' ',last_name) AS DD,
    NTILE(4) OVER (ORDER BY customer_id) AS customer_GROUP
FROM customer;


# payment 테이블에서 고객들의 각 고객들의 결제금액을 출력하세요, 단 출력 내용은 다음과 같이 처리
# 고객 ID, 고객 결제금액, 해당 행의 결제 금액의 이전 결제금액, 해당 행의 결제금액의 다음 결제금액

SELECT 
	customer_id,
    LAG(amount) OVER(PARTITION BY customer_id ORDER BY payment_date),
    LEAD(amount) OVER (PARTITION BY customer_id ORDER BY payment_date)
FROM payment
ORDER BY customer_id;

# rental 테이블에서 각 고객별로 첫번째 대여일자와 마지막 대여일자


SELECT 
	DISTINCT customer_id,
	FIRST_VALUE(rental_date) OVER(PARTITION BY customer_id ORDER BY rental_date) AS First,
	LAST_VALUE(rental_date) OVER(PARTITION BY customer_id ORDER BY rental_date
								ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS Final
FROM rental;

# payment 테이블에서 각 직원이 처리한 첫번쨰 결제와 마지막 결제 금액을 출력
SELECT 
	DISTINCT staff_id,
	FIRST_VALUE(amount) OVER(PARTITION BY staff_id ORDER BY payment_date) AS First,
	LAST_VALUE(amount) OVER(PARTITION BY staff_id ORDER BY payment_date
								ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS Final	
FROM payment;

# film 테이블에서 각 영화의 대여기간에 대한 백분위 순위, 누적분포를 계산해주세요
# 영화제목, 대여기간, 백분위 순위, 누적분포

SELECT 
	title,
    rental_duration,
    PERCENT_RANK() OVER (ORDER BY rental_duration),
    CUME_DIST() OVER (ORDER BY rental_duration)
FROM film;

# customer 테이블에서 각 고객의 결제 금액에 대한 백분위 순위와 누적분포를 계산해 주세요
# 고객ID, 총 결제금액, 백분위 순위, 누적분포 -> 출력되어야 할 대상

SELECT 
	customer_id,
-- 	SUM(amount) OVER (PARTITION BY customer_id), 
    PERCENT_RANK() OVER (ORDER BY SUM(amount) DESC) AS total_amount,
    CUME_DIST() OVER (ORDER BY SUM(amount) DESC) AS total
FROM customer
JOIN payment USING(customer_id)
GROUP BY customer_id
ORDER BY SUM(amount);

# rental 테이블에서 각 고객별로 대여순서에 따른 누적 대여 횟수를 출력해주세요
# 대여 ID, 고객 ID, 대여 날짜, 누적 대여 횟수 -> 출력되어야 합니다

SELECT 
	customer_id,
    rental_id,
    rental_date,
	COUNT(*) OVER(PARTITION BY customer_id ORDER BY rental_date
					ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
FROM rental;

# payment 테이블에서 각 고객별로 결제 일자에 따른 누적 결제 금액을 출력해주세요
# 결제 ID, 고객 ID, 결제 날짜, 결제 금액, 누적 결제 금액

SELECT 
	customer_id,
    payment_id,
    payment_date,
    SUM(amount) OVER (PARTITION BY customer_id ORDER BY amount
						ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
FROM payment;

# rental 테이블에서 각 직원들의 대여 날짜에 따른 대여횟수와 각 직원별 누적 대여 횟수를 출력
# 대여ID, 직원ID, 대여날짜, 대여횟수, 누적대여횟수 -> 출력해야하는 값
SELECT 
	rental_id,
    staff_id,
    rental_date,
    COUNT(*) OVER (PARTITION BY staff_id, DATE(rental_date) ORDER BY DATE(rental_date)
					ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS rental_count,
    COUNT(*) OVER (PARTITION BY staff_id ORDER BY DATE(rental_date)
					ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
FROM rental;

# customer 테이블과 payment 테이블을 사용해서 각 도시별 고객의 총 결제 금액 순위를 출력!
# 고객 ID, 도시, 총 결제 금액, 도시 순위
SELECT 
	DISTINCT customer_id,
	CI.city,
	sum(amount) OVER (PARTITION BY city_id, customer_id)-- ,
--     RANK() OVER (PARTITION BY city_id ORDER BY SUM(amount))
FROM customer C
JOIN address USING(address_id)
JOIN city CI USING(city_id)
JOIN payment USING(customer_id);
-- GROUP BY C.customer_id

# customer 테이블에서 고객별 대여 횟수에 따라 4개의 그룹으로 나눠주세요. 고객 ID, 대여횟수, 그룹 - 출력될 수 있도록!
SELECT
	customer_id,
	NTILE(4) OVER(ORDER BY COUNT(*) DESC),
    COUNT(*)
FROM customer
JOIN rental USING(customer_id)
GROUP BY customer_id;

# film 테이블에서 영화를 대여기간에 따라 5개의 그룹으로 나누어주세요
# 영화 ID, 대여기간, 그룹 -> 출력해야 할 데이터

SELECT
	film_id,
    rental_duration,
    NTILE(5) OVER (ORDER BY rental_duration)
FROM film;

# payment 테이블에서 각 고객별 지불 내역에 행 번호를 부여해주세요.
# 고객별 지불 내역의 행 번호는 payment_date가 낮은 순으로 부여해주세요, 지불 ID, 지불 금액, 고객 ID, 지불 일자

SELECT
	payment_id,
    amount,
    customer_id,
    payment_date,
	ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY payment_date)
FROM payment;

# film 테이블에서 각 등급별로 영화에 행 번호를 부여하세요
# 영화는 대여기간에 따라 정렬될 수 있도록 해주세요, 영화 ID, 등급, 대여기간, 행번호 -> 출력!
SELECT * FROM film; #film_id
SELECT * FROM film_category; #film_id, cateogry_id
SELECT * FROM category; # category_id
SELECT * FROM rental; # rental_id, inventory_id, customer_id
SELECT * FROM inventory; # inventory_id, film_id
SELECT * FROM payment; # payment_id, staff_id, customer_id
SELECT * FROM film; #film_id
SELECT * FROM inventory; # inventory_id, film_id
SELECT * FROM customer; #customer_id, address_id, store_id
SELECT * FROM store; #store_id, address_id
SELECT * FROM staff; #staff_id
SELECT * FROM city; #city_id
SELECT * FROM address; #address_id, city_id

SELECT
	film_id,
	rating,
    rental_duration,
	ROW_NUMBER() OVER (PARTITION BY rating ORDER BY rental_duration)
FROM film;

# customer 테이블과 payment 테이블을 사용해서 고객을 총 결제금액에 따라 10개의 그룹으로 나누고
# 각 그룹 내에서 고객별 총 결제금액에 따라 번호를 부여하세요.
# 고객 ID, 총 결제금액, 그룹, 그룹 네 행 번호

SELECT 
	OP.customer_id,
    OP.TT,
    OP.TS,
	ROW_NUMBER() OVER (PARTITION BY OP.TT ORDER BY OP.TS)
FROM
(SELECT
    customer_id,
    SUM(P.amount) AS TS,
	NTILE(10) OVER(ORDER BY SUM(P.amount)) AS TT
FROM customer
JOIN payment P USING(customer_id)
GROUP BY customer_id) AS OP;


WITH CustomerPayments AS(
	SELECT
		C.customer_id,
        SUM(P.amount) AS total_amount
	FROM customer C
    JOIN payment P USING(customer_id)
    GROUP BY C.customer_id
),
CustomerGroup AS (
	SELECT
		customer_id, total_amount,
        NTILE(1) OVER (ORDER BY total_amount) AS ten
        FROM CustomerPayments
)
SELECT
	customer_id, total_amount, ten,
    ROW_NUMBER() OVER (PARTITION BY ten ORDER BY total_amount) AS row_numbers
FROM CustomerGroup;


