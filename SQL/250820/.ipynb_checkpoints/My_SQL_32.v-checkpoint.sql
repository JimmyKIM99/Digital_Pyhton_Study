# category 테이블에서 Comedy, Sports, Family 카테고리의 category_id 출력

SELECT * FROM category;

SELECT category_id, name
FROM category
WHERE name = 'Comedy' OR name = 'Sports' OR name = 'Family';

SELECT 
	category_id,
    name
FROM category
WHERE 
	name = 'Comedy' OR
    name = 'Family' OR
    name = 'Sports';
    
SELECT 
	category_id,
    name
FROM category
WHERE 
	name IN ('Comedy', 'Family', 'Sports');
    
    
# film_category 테이블에서 카테고리 id별 영화 갯수
SELECT category_id, COUNT(*) num
FROM film_category
GROUP BY category_id;

SELECT category_id, COUNT(*)
FROM film_category
GROUP BY category_id;

# 카테고리 Comedy인 영화 갯수 확인 및 출력
SELECT * FROM film_category;
SELECT * FROM category;

SELECT 
	COUNT(*) 
FROM film_category
WHERE category_id = 5;

SELECT 
	COUNT(*) 
FROM film_category FC
JOIN category C ON FC.category_id = C.category_id
WHERE C.name = 'Comedy';

# 4
SELECT 
	COUNT(*) 
FROM 
	film_category FC
WHERE FC.category_id IN 
(SELECT C.category_id 
FROM category C
WHERE name = 'Comedy');

SELECT COUNT(*) FROM film_category
WHERE category_id IN (
	SELECT category_id FROM category
    WHERE name = 'Comedy'
);

# Comedy, Sports, Fmaily, 각각의 카테고리별 영화 수 확인하기 
-- SELECT 
-- 	COUNT(*) 
-- FROM film_category
-- WHERE category_id IN (
-- 	SELECT category_id
--     FROM category
-- )
-- GROUP BY category_id
-- HAVING name IN ('Comedy', 'Sports', 'Family');


SELECT 
	COUNT(*) 
FROM film_category
WHERE category_id IN (
	SELECT category_id
    FROM category C
    WHERE name IN ('Comedy', 'Sports', 'Family')
)
GROUP BY category_id;

SELECT COUNT(*)
FROM category C
JOIN film_category USING(category_id)
WHERE C.name IN ('Comedy', 'Sports', 'Family')
GROUP BY category_id;

# 각 카테고리를 기준으로 영화 수가 70이상인 카테고리명
SELECT * FROM category;
SELECT * FROM film_category;

SELECT name
FROM category
WHERE category_id IN (
	SELECT category_id 
    FROM film_category
    GROUP BY category_id
    HAVING COUNT(*) >= 70
);

SELECT
	C.name, COUNT(*)
FROM category C
JOIN film_category F USING(category_id)
GROUP BY C.category_id
HAVING COUNT(*) >= 70;

# 각 카테고리에 포함된 영화들의 렌탈 횟수 구하기
SELECT * FROM category; #category_id
SELECT * FROM film_category; #category_id / film_id
SELECT * FROM rental; # rental_id / inventory_id
SELECT * FROM inventory; #inventory_id / film_id


SELECT C.name, C.category_id, COUNT(R.inventory_id) total_rental
FROM category C
JOIN film_category FC USING(category_id)
JOIN inventory I USING(film_id)
JOIN rental R USING(inventory_id)
GROUP BY C.category_id
;

SELECT
	C.name, COUNT(*)
FROM category C
JOIN film_category USING(category_id)
JOIN inventory USING(film_id)
JOIN rental USING(inventory_id)
GROUP BY C.category_id
;
USE sakila;
#

SELECT 
	COUNT(*) 
FROM film_category
GROUP BY category_id
HAVING category_id IN ('5', '15', '8');

SELECT
	C.name, COUNT(*)
FROM category C
JOIN film_category USING(category_id)
JOIN inventory USING(film_id)
JOIN rental USING(inventory_id)
GROUP BY C.category_id
;

# 카테고리가 Comedy인 데이터의 렌탈 횟수 출력, (*서브쿼리 문법)

SELECT COUNT(*) FROM category
WHERE category_id IN (
	SELECT category_id FROM film_category
    WHERE film_id IN (
		SELECT film_id FROM inventory
        WHERE inventory_id IN (
			SELECT inventory_id FROM rental
            WHERE name = 'Comedy'
        )
    )
)
GROUP BY category_id;

SELECT COUNT(*) FROM rental
WHERE inventory_id IN (
	SELECT inventory_id FROM inventory
    WHERE film_id IN (
		SELECT film_id FROM film_category
        WHERE category_id IN (
         SELECT category_id FROM category
         WHERE name = 'Comedy'
         )
    )
);

# address 테이블에는 address_id가 있지만, customer 테이블에는 없는 데이터의 갯수
SELECT * FROM address;
SELECT * FROM customer;

-- SELECT * FROM address A
-- RIGHT JOIN customer C ON A.address_id = C.address_id;

SELECT COUNT(A.address_id) FROM customer C
RIGHT JOIN address A ON A.address_id = C.address_id
WHERE C.address_id IS NULL;	

-- SELECT address_id FROM customer
-- EXCEPT # MINUS
-- SELECT address_id FROM address;

SELECT
	COUNT(A.address_id)
FROM address A
JOIN customer C USING(address_id);

SELECT
	(SELECT COUNT(*) FROM address) - 
	(SELECT
		COUNT(A.address_id)
	FROM address A
	JOIN customer C USING(address_id));

# 캐나다 고객에게 이메일 마케팅 캠페인을 진행하고자 합니다, 캐나다 고개그이 이름과 이메일 주소 리스트를 출력해 주세요
SELECT * FROM address; #address_id, city_id
SELECT * FROM country; #country_id
SELECT * FROM city; # city_id, country_id
SELECT * FROM customer; #customer_id, address_id

SELECT CONCAT(first_name, ' ', last_name), email FROM customer
WHERE address_id IN (
	SELECT address_id FROM address
    WHERE city_id IN (
		SELECT city_id FROM city
        WHERE country_id IN (
			SELECT country_id FROM country
            WHERE country = 'Canada'
            )
		)
	);
	

-- SELECT
-- 	first_name,
--     last_name,
--     email
-- FROM customer
-- JOIN address AD USING()
-- JOIN address AD USING()
-- JOIN address AD USING();

# 가족영화를 홍보대상으로 삼고자 함, 가영화든 영화리스트를 출력

SELECT * FROM film; #film_id
SELECT * FROM film_category; #film_id, cateogry_id
SELECT * FROM category; # category_id -> Family

SELECT title FROM film
WHERE film_id IN (
	SELECT film_id FROM film_category
    WHERE category_id IN (
		SELECT category_id FROM category
        WHERE name = 'Family'
    )
);


SELECT F.title
FROM film F
JOIN film_category FC USING(film_id)
JOIN category CA USING(category_id)
WHERE CA.name = 'Family';

