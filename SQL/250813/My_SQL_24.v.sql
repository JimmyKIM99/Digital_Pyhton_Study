USE sakila;
SHOW TABLES;
SELECT * FROM actor LIMIT 10;

SELECT 
	title, LENGTH(title) AS title_length
FROM film LIMIT 10;

SELECT 
	title,
    LOWER(title) AS lowercased_titles,
    UPPER(title) AS uppercased_titles,
    LOWER(UPPER(title)) AS special_titles,
    LENGTH(title) AS title_length
FROM film LIMIT 10;

SELECT 
	CONCAT(first_name, " ",last_name),
	first_name,
    last_name
FROM actor LIMIT 10;

SELECT 
	description,
    SUBSTRING(description, 1, 10) AS SHORT_DESCRIPTION
FROM film LIMIT 10;

SELECT 
	description,
    SUBSTRING(description, 2, 10) AS SHORT_DESCRIPTION
FROM film LIMIT 10;

SELECT *
FROM film
WHERE LENGTH(title) = 15;

SELECT 
	UPPER(CONCAT(first_name, " ", last_name))
FROM actor
WHERE LOWER(first_name) = "john";

# film 테이블에서 description의 3번쨰 글자부터 6글자가 Acrion인 영화의 제목을 찾아서 출력해주세요.
SELECT 
title,
description 
FROM film
WHERE SUBSTRING(description, 3, 6) = 'ACTION';

SELECT NOW();
SELECT CURDATE();
SELECT CURTIME();

# 일 단위 값 추가
SHOW TABLES;
SELECT
	rental_date,
    DATE_ADD(rental_date, INTERVAL 7 DAY)
FROM rental
LIMIT 5;

# 월 단위 값 추가
SHOW TABLES;
SELECT
	rental_date,
    DATE_ADD(rental_date, INTERVAL 8 MONTH)
FROM rental
LIMIT 5;

# 시간 단위 값 추가
SHOW TABLES;
SELECT
	rental_date,
    DATE_ADD(rental_date, INTERVAL 8 HOUR)
FROM rental
LIMIT 5;

# 분 단위 값 추가
SHOW TABLES;
SELECT
	rental_date,
    DATE_ADD(rental_date, INTERVAL 155 MINUTE)
FROM rental
LIMIT 5;

# 초 단위 값 추가
SHOW TABLES;
SELECT
	rental_date,
    DATE_ADD(rental_date, INTERVAL 155 SECOND)
FROM rental
LIMIT 5;

SELECT * FROM payment LIMIT 5;

SELECT
	payment_date,
    EXTRACT(YEAR FROM payment_date)
FROM payment;

# 구체적으로 특정 년도에 해당되는 데이터값을 추출해서 찾아오고자 할 때, 유용한 문법
SELECT
	payment_date
FROM payment
WHERE EXTRACT(YEAR FROM payment_date) = 2006;

SELECT
	payment_date
FROM payment
WHERE EXTRACT(DAY FROM payment_date) = 27 AND EXTRACT(YEAR FROM payment_date) = 2005;

# 렌탈되고 있는 각 월 마다의 빌려가는 횟수 등을 확인

SELECT * FROM PAYMENT LIMIT 10;

SELECT 
	EXTRACT(MONTH FROM payment_date) AS payment_month,
    COUNT(*) AS monthly_count
FROM payment
GROUP BY payment_month;

SELECT 
	YEAR(payment_date) AS payment_year,
    MONTH(payment_date),
    DAY(payment_date)
--     COUNT(*) AS yearly_count
FROM payment
GROUP BY payment_year,
MONTH(payment_date),
DAY(payment_date);

SELECT DAYOFWEEK(payment_date, "%W") AS payment_dayofweek 
FROM payment
GROUP BY payment_dayofweek;

SELECT
	DATE_FORMAT(payment_date, "%W") AS payment_dayname,
    COUNT(*)
FROM payment
GROUP BY payment_dayname;

SELECT
	CASE DAYOFWEEK(payment_date)
		WHEN 1 THEN '월요일'
        WHEN 2 THEN '화요일'
        WHEN 3 THEN '수요일'
        WHEN 4 THEN '목요일'
        WHEN 5 THEN '금요일'
        WHEN 6 THEN '토요일'
        WHEN 7 THEN '일요일'
	END AS payment_dayname,
    COUNT(*) AS total_count
FROM payment
GROUP BY payment_dayname;

SHOW TABLES;

SELECT
	rental_date,
    return_date,
	TIMESTAMPDIFF(MONTH, rental_date, return_date) AS rental_days
FROM rental LIMIT 5;

SELECT
	rental_id,
    rental_date,
    DATE_FORMAT(rental_date, '%Y-%M-%D') AS formatted_rental_date
FROM rental
LIMIT 5;

SELECT
	rental_id,
    rental_date,
    DATE_FORMAT(rental_date, '%y:%m:%d') AS formatted_rental_date
FROM rental
LIMIT 5;

# rental 테이블에서 대여 시작날짜가 2006년 1월 1일 이후인 모든 대여에 대해 예상 날짜를 대여 날짜로 5일 뒤로 설정하여, 출력alter

SELECT 
	rental_date,
	DATE_ADD(rental_date, INTERVAL 5 DAY) AS expect_return_date
FROM rental
WHERE YEAR(rental_date) >= 2006;

SELECT
	-amount,
    ABS(-amount),
    ceil(-amount),
    FLOOR(-amount),
    ROUND(-amount, 1)
FROM payment;

# payment 테이블에서 결제금액(amount)이 5이하인 모든 결제에 대해 절대값을 계산하여 출력
SELECT
	ABS(amount)
FROM payment
WHERE amount <= 5;

SELECT
	SQRT(length)
FROM film
WHERE length >= 120;

# payment 테이블에서 결제금액을 소수점 첫번째 자리에서 반올림하여 출력해 주세요.
SELECT
	ROUND(amount, 0) AS r_payment
FROM payment;