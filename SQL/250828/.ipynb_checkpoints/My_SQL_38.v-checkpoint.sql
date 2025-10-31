# 1. 각 고객별 결제 금액에 따른 순위를 출력해 주세요. 고객 ID, 렌탈ID, 고객의 결제 금액에 따른 순위
# 순위를 출력할 때, 동일한 값이 있을 경우, 순위를 부여하고, 다음 순위는 건너뛰지 않습니다.

SELECT 
	customer_id,
--     rental_id,
SUM(amount),
    DENSE_RANK() OVER(ORDER BY SUM(amount)) 
FROM payment
GROUP BY customer_id;

SELECT
	customer_id, rental_id, amount,
    DENSE_RANK() OVER
		(PARTITION BY customer_id ORDER BY amount DESC)
FROM payment;

# 2. 고객별 대여날짜 시간 순으로 정렬 후 아래 내용을 출력해주세요
# 고객 ID, 렌탈 ID, 대여날짜 시간, 해당 대여날짜 시간을 기준으로 다음 대여날짜 시간

SELECT 
	customer_id,
    rental_id,
    rental_date,
    LEAD(rental_date, 1, 0) OVER(PARTITION BY customer_id ORDER BY rental_date) AS next_rental_date
FROM rental;

SELECT
	customer_id,
    rental_id,
    rental_date
FROM rental;


# 3. 각 등급별로 대여 기간이 가장 긴 영화의 제목을 출력하세요
SELECT * FROM film;

SELECT
	title,
    rating,
	FIRST_VALUE(rental_duration) OVER (PARTITION BY rating ORDER BY rental_duration DESC)
FROM film;


SELECT
	DISTINCT rating,
    FIRST_VALUE(title) OVER 
		(PARTITION BY rating ORDER BY rental_duration DESC) AS longest_rental_movie
FROM film;

# 각 고객을 활동상태가 높은 순으로 정렬하고, 이를 기준으로 3개의 그룹으로 나누세요
# 정렬 후 행 번호
# 그룹 내 고객의 순서를 customer_id가 낮은 순으로 정렬해주세요, customer_id, first_name, last_name, active, active_group, group_rownumber

SELECT
	GA.customer_id,
    GA.first_name,
    GA.last_name,
    GA.active,
    GAA,
    ROW_NUMBER() OVER (PARTITION BY GA.GAA ORDER BY GA.GAA) group_row_number
FROM(
SELECT 
	customer_id,
    first_name,
    last_name,
    active,
    NTILE(3) OVER(ORDER BY active DESC) AS GAA
FROM customer C) AS GA


#문제1. sakila DB의 “영화 대여 내역”을 바탕으로 다음 항목을 모두 출력하는 SQL 쿼리문을 작성해주세요.
# 고객별 대여 순위, 이전 대여와의 간격(날짜), 다음 대여와의 간격,고객별 첫 번째 및 마지막 대여 일자,고객별 대여 건의 백분위 순위 및 누적분포,
# 고객별 대여 내역의 3개 그룹 분할, 분할된 그룹 내 대여날짜 기준 오름차순 정렬
# 위 항목들을 customer_id, rental_date와 함께 “모두 포함하여 출력”하는 SQL 쿼리를 작성해주세요.
SELECT * FROM film; #film_id
SELECT * FROM film_category; #film_id, cateogry_id
SELECT * FROM category; # category_id
SELECT * FROM rental; # rental_id, inventory_id, customer_id
SELECT * FROM inventory; # inventory_id, film_id
SELECT * FROM payment; # payment_id, staff_id, customer_id
SELECT * FROM film; #film_id
SELECT * FROM inventory; # inventory_id, film_id
SELECT * FROM customer; #customer_id, address_id, store_id

SELECT 
	TC.customer_id,
    TC.rental_id,
    TC.total_rent,
    DATEDIFF(TC.current_date1, TC.next_rental_date)
FROM
(SELECT
	customer_id,
    rental_id,
    DATE(rental_date) AS current_date1,
	DATE(LEAD(rental_date, 1, NULL) OVER (PARTITION BY customer_id ORDER BY rental_date)) AS next_rental_date,
    COUNT(*) OVER (PARTITION BY customer_id) AS total_rent
FROM customer C
JOIN rental R USING(customer_id)
) AS TC
;



SELECT
	customer_id,
    rental_id,
-- 	LEAD(rental_date, 0) OVER (PARTITION BY customer_id ORDER BY rental_date DESC),
	DATE(RENTAL_date) - DATE(LEAD(rental_date, 1, 0) OVER (ORDER BY rental_date DESC)),
    COUNT(*) OVER (PARTITION BY customer_id) AS total_rent
FROM customer C
JOIN rental R USING(customer_id);
