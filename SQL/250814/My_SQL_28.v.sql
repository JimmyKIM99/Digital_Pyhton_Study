SELECT film_id FROM film
UNION
SELECT film_id FROM inventory;

SELECT film_id FROM film
UNION ALL
SELECT film_id FROM inventory;

SELECT film_id FROM film
INTERSECT
SELECT film_id FROM inventory;

SELECT F.film_id
FROM film F
JOIN inventory I USING(film_id);

SELECT F.film_id
FROM film F
LEFT JOIN inventory I ON F.film_id = I.film_id
WHERE I.film_id IS NULL;

SELECT F.film_id
FROM film F
WHERE film_id IN (
	SELECT film_id
    FROM inventory I
);

SELECT F.film_id
FROM film F
WHERE NOT EXISTS (
	SELECT I.film_id
    FROM inventory I
    WHERE F.film_id = I.film_id
);

# MySQL 8.0.31 이상에서만 사용가능한 문법

# film 테이블과 film_category 테이블에서 각각 중복없이 film_id를 조회하는 sql문 작성
SELECT film_id FROM film
UNION
SELECT film_id FROM film_category;

START TRANSACTION;