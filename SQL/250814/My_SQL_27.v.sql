SELECT
	first_name,
    last_name
FROM customer
WHERE customer_id = (
	SELECT customer_id
    FROM(
		SELECT customer_id, COUNT(*) AS payment_count
        FROM payment
        GROUP BY customer_id
    ) AS payment_counts
    ORDER BY payment_count DESC
    LIMIT 1
);

# file 테이블에서 평균 영화길이 (Length)보다 긴 영화들의 제목 찾아주세요
SELECT title 
FROM film F
WHERE length > (SELECT AVG(length) FROM film);

# rental 테이블에서 고객별 평균 대여 횟수보다 많은 대여를 한 고개들의 이름 firts last

SELECT first_name, last_name 
FROM customer
WHERE customer_id = (
SELECT customer_id 
FROM
(SELECT rental.customer_id, count(*) 
FROM rental
GROUP BY customer_id
HAVING AVG(COUNT(*)) > COUNT(*)
) AS payment_count
); 


SELECT
first_name, last_name
FROM customer
WHERE customer_id IN (SELECT customer_id
FROM rental
GROUP BY customer_id
HAVING COUNT(*)> (
	SELECT
	AVG(rental_count)
	FROM
(SELECT
	COUNT(*) AS rental_count
FROM rental
GROUP BY customer_id) AS rental_counts));

# 가장 많은 영화를 대여한 고객의 이름(first, last)를 찾아주세요

SELECT
first_name, last_name
FROM customer
WHERE customer_id = (SELECT customer_id FROM (SELECT customer_id, COUNT(*) AS vip1 FROM rental GROUP BY customer_id) AS vip ORDER BY vip1 DESC LIMIT 1)
;

SELECT
	first_name,
    last_name
FROM customer
WHERE customer_id = (SELECT customer_id FROM(
	SELECT customer_id, COUNT(*) AS rental_count
    FROM rental
    GROUP BY customer_id) AS rental_counts
    ORDER BY rental_count DESC
    LIMIT 1
);

# 각 고객에 대해 자신이 대여한 평균 영화 길이보다  긴 영화들의 제목
SELECT * FROM customer; # customer_id
SELECT * FROM rental; # customer_id, inventory_id
SELECT * FROM film; # film_id
SELECT * FROM inventory; # inventory_id, film_id

SELECT C.first_name, C.last_name, F.title FROM customer C
JOIN rental R ON R.customer_id = C.customer_id
JOIN inventory I ON I.inventory_id = R.inventory_id
JOIN film F ON F.film_id = I.film_id
WHERE AVG(F.length) > (
	SELECT AVG(FIL.length)
    FROM film FIL
    JOIN inventory INV ON INV.film_id = FIL.film_id
    JOIN rental REN ON REN.inventory_id = INV.inventory_id
    WHERE REN.customer_id = C.customer_id
);

# RENTAL과 INVENTORY 테이블을 JOIN하고, FILM TABLE에 있는 REPLACEMENT_COST가 20 이상인 영화를 대여한 고객의 이름을 찾아줘 고객의 이름은 소문자
SELECT DISTINCT CONCAT(LOWER(first_name)," ", LOWER(last_name)) FROM customer C
JOIN rental R ON R.customer_id = C.customer_id
JOIN inventory I ON I.inventory_id = R.inventory_id
JOIN film F ON F.film_id = I.film_id
WHERE F.replacement_cost >= 20;

# film 테이블에서 rating 이 'PG - 13'등급인 영화들에서, discription의 길이가 평균 디스크립션 길이보다 긴 것들

SELECT * FROM customer; # customer_id
SELECT * FROM rental; # customer_id, inventory_id
SELECT * FROM film; # film_id
SELECT * FROM inventory; # inventory_id, film_id

SELECT title FROM film
WHERE rating = 'PG-13' 
AND 
(length(description) > (SELECT AVG(LENGTH(description)) FROM film WHERE rating = 'PG-13')
);

SELECT title
FROM film
WHERE rating = 'PG-13' AND LENGTH(description) > (
	SELECT LENGTH(AVG(description)) FROM film WHERE rating = 'PG-13'
);

# CUSTOMER와 RENTAL, INVENTORY, FILM 테이블을 JOIN하여 2005년 8월 대여된 모든 "R"등급 영화의 제목과 해당 영화를 대여한 고객의 이메일
SELECT * FROM customer; # customer_id
SELECT * FROM rental; # customer_id, inventory_id
SELECT * FROM film; # film_id
SELECT * FROM inventory; # inventory_id, film_id
SELECT * FROM payment; # inventory_id, film_id

SELECT title, C.email FROM film F
JOIN inventory I ON F.film_id = I.film_id
JOIN rental R ON R.inventory_id = I.inventory_id
JOIN customer C ON C.customer_id = R.customer_id
WHERE F.rating = 'R'AND R.rental_date > 2005-08-01;


SELECT DISTINCT title, C.email FROM film F
JOIN inventory I USING(film_id)
JOIN rental R USING(inventory_id)
-- JOIN rental R ON R.inventory_id = I.inventory_id
JOIN customer C ON C.customer_id = R.customer_id
WHERE
	YEAR(R.rental_date) = 2005 
    AND MONTH(R.rental_date) = 8
    AND F.rating = 'R';

# payment 테이블에서 가장 마지막에 결제된 일시에서 30일 이전까지의 모든 결제 내역을 찾고 해당 결제 내역에 대해서 각 고객별 총 결재 금액을 소수점 둘째자리에서 반올림
SELECT ROUND(SUM(amount), 1) 
FROM payment
WHERE payment_date > (SELECT MAX(payment_date) -  INTERVAL 30 DAY FROM payment)
GROUP BY customer_id;

SELECT ROUND(AVG(amount), 1)
FROM payment P
GROUP BY customer_id
HAVING P.payment_date > DATE_SUB((SELECT MAX(payment_date) FROM payment), INTERVAL 30 DAY);

SELECT 
customer_id, ROUND(SUM(amount), 1), ROUND(AVG(amount), 1)
FROM payment
WHERE payment_date >= DATE_SUB((SELECT MAX(payment_date) FROM payment), INTERVAL 30 DAY)
GROUP BY customer_id;

# ACTOR 와 FILM_actor 테이블을  JOIN하고 "sci_fi" 카테고리에 속한 영화에 출현한 이름, 성과 이름을 연결
SELECT * FROM film_actor; # actor_id, flim_id
SELECT * FROM film; # film_id
SELECT * FROM film_category; # category_id, film_id
SELECT * FROM actor; # actor_id
SELECT * FROM category; # category_id, film_id

SELECT UPPER(CONCAT(first_name," " ,last_name)) FROM actor
JOIN film_actor FA USING(actor_id)
JOIN film F USING(film_id)
JOIN film_category FC USING(film_id)
JOIN category C USING (category_id)
WHERE C.category_id = 14;

SELECT UPPER(CONCAT(A.first_name, ' ',A.last_name)) AS actor_full_name
FROM actor A
JOIN film_actor F USING(actor_id)
JOIN film_category FC USING(film_id)
JOIN category C USING(category_id)
WHERE name = 'Sci-Fi';