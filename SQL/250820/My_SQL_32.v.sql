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

# 가장 자주 대여하는 영화 리스트 100개, 영화제목, 렌탈 횟수

SELECT * FROM rental; # rental_id, inventory_id, customer_id
SELECT * FROM film; #film_id
SELECT * FROM inventory; # inventory_id, film_id
SELECT * FROM payment; #customer_id, address_id

-- SELECT COUNT(*) FROM film
-- WHERE 
-- GROUP BY film_id;

SELECT F.title, (
	SELECT COUNT(*)
    FROM rental R
    WHERE R.inventory_id IN (
		SELECT I.inventory_id
        FROM inventory I
        WHERE I.film_id = F.film_id
    )
) AS total_rental
 FROM film F
 GROUP BY F.film_id;
 
 # 각 스토어별로 매출을 확인하고 싶습니다, 관련 데이터를 출력해 주세요 / 관련 데이터는 다음과 같음 / 도시, 국가, 스토어 아이디, 스토어별 총 매출
 
SELECT * FROM rental; # rental_id, inventory_id, customer_id
SELECT * FROM film; #film_id
SELECT * FROM inventory; # inventory_id, film_id
SELECT * FROM payment; #customer_id, address_id
SELECT * FROM address; #address_id, city_id
SELECT * FROM country; #country_id
SELECT * FROM city; # city_id, country_id
SELECT * FROM customer; #customer_id, address_id
SELECT * FROM store; #store_id, address_id
SELECT * FROM staff; #store_id, address_id
 

SELECT store_id,
(SELECT SUM(P.amount)
FROM payment P
WHERE P.staff_id in (
	SELECT staff_id FROM staff ST
	WHERE ST.store_id = S.store_id
	)
),
(SELECT city FROM city C
WHERE C.city_id IN(
	SELECT A.city_id FROM address A
    WHERE A.address_id = S.address_id
	)
),
(SELECT country FROM country CO
	WHERE CO.country_id IN(
	SELECT C.country_id FROM city C
    WHERE C.city_id IN (
		SELECT A.city_id FROM address A
        WHERE A.address_id IN (
			SELECT S.address_id FROM store S
            WHERE A.address_id = S.address_id
			)
		)
    )
)
FROM store S;

# 가장 렌탈비용을 많이 지불한 고객 10명 선물 배송, 주소, 이메일, 각 고객별 비용, 이름
SELECT * FROM rental; # rental_id, inventory_id, customer_id
SELECT * FROM film; #film_id
SELECT * FROM inventory; # inventory_id, film_id
SELECT * FROM payment; #customer_id, address_id
SELECT * FROM address; #address_id, city_id
SELECT * FROM country; #country_id
SELECT * FROM city; # city_id, country_id
SELECT * FROM customer; #customer_id, address_id
SELECT * FROM store; #store_id, address_id
SELECT * FROM staff; #store_id, address_id


SELECT CONCAT(first_name, ' ', last_name), SUM(P.amount) AS PS, C.email, A.address
FROM customer C
JOIN payment P USING(customer_id)
JOIN address A USING(address_id)
GROUP BY customer_id
ORDER BY PS DESC
LIMIT 10;

-- CREATE DATABASE W_db_v5;
USE sakila;
# acotr 테이블의 배우 이름 조합 소문자 조합
SELECT LOWER(CONCAT(first_name, last_name)) FROM actor;

SELECT
	CONCAT(UPPER(LEFT(first_name, 1)), LOWER(SUBSTRING(last_name, 2))) AS actor_name
FROM actor;

# 언어가 영어인 영화 중 영화 타이틀이 KO로 시작하는 영화 타이틀 출력!
SELECT * FROM film; #film_id
SELECT * FROM language; #film_id
SELECT * FROM actor; #film_id
SELECT * FROM film_actor; #film_id

SELECT F.title
FROM film F
WHERE F.language_id IN (
	SELECT L.language_id FROM language L
    WHERE L.name = 'English'
) AND (F.title LIKE 'K%' OR title LIKE 'O%');
USE sakila;
# 문제 17 Alone Trip에 나오는 배우 이름을 모두 출력 -> 하나의 문장으로 출력!!

SELECT CONCAT(first_name," ", last_name)
FROM actor
WHERE actor_id IN (
	SELECT FA.actor_id FROM film_actor FA
    WHERE FA.film_id IN (
		SELECT F.film_id FROM film F
        WHERE title = 'Alone Trip'
    )
);

# 2005년 8월에 각 스태프 멤버가 올린 매출을 출력해주세요
SELECT * FROM rental; # rental_id, inventory_id, customer_id
SELECT * FROM film; #film_id
SELECT * FROM inventory; # inventory_id, film_id
SELECT * FROM payment; #customer_id, address_id
SELECT * FROM address; #address_id, city_id
SELECT * FROM country; #country_id
SELECT * FROM city; # city_id, country_id
SELECT * FROM customer; #customer_id, address_id
SELECT * FROM store; #store_id, address_id
SELECT * FROM staff; #store_id, address_id

SELECT (SELECT CONCAT(last_name, " ", first_name)
	FROM staff S
	WHERE S.staff_id = P.staff_id), 
SUM(amount) 
FROM payment P
WHERE payment_date BETWEEN DATE('2005-08-01') AND DATE('2005-08-31')
GROUP BY staff_id;

SELECT (SELECT CONCAT(last_name, " ", first_name)
	FROM staff S
	WHERE S.staff_id = P.staff_id), 
SUM(amount) 
FROM payment P
WHERE payment_date LIKE "2005-08%"
GROUP BY staff_id;

SELECT (SELECT CONCAT(last_name, " ", first_name)
	FROM staff S
	WHERE S.staff_id = P.staff_id), 
SUM(amount) 
FROM payment P
WHERE 
	EXTRACT(YEAR FROM payment_date) = 2005 AND
    EXTRACT(MONTH FROM payment_date) = 8
GROUP BY staff_id;

# 각 카테고리의 평균 영화 러닝타임이 전체 평균 러닝타임보다 큰 카테고리들의 카테고리명과 해당 카테고리의 평균 러닝 타임
SELECT * FROM film; #film_id
SELECT * FROM film_category; #film_id, cateogry_id
SELECT * FROM category; # category_id -> Family

SELECT
(SELECT name FROM category C
WHERE C.category_id IN (
	SELECT category_id FROM film_category FC
    WHERE FC.film_id IN (
		SELECT film_id FROM film F
        WHERE AVG(F.length)
		)
	)
)
FROM film;

SELECT C.name
FROM film F
JOIN film_cateogry FC USING(film_id)
JOIN category C USING(category_id)
GROUP BY C.name
HAVING AVG(F.lenght) > (SELECT AVG(length) FROM film);

# 각 카테고리별 평균 영화 대여 시간과 해당 카테고리명 출력 / 영화대여시간 영화 대여및 반납 시간의 차이

SELECT name, AVG(TIMESTAMPDIFF(HOUR,R.return_date, R.rental_date))
FROM category C
JOIN film_category USING(category_id)
JOIN inventory USING(film_id)
JOIN rental R USING(inventory_id)
GROUP BY category_id;

# 총 매출액 상위 5개 확인 / 각 장르별 총 매출액 / 장르이름 해당 데이터를 수시로 확인할 수 있는 VIEW생성
#총 매출액 장르 매출액 노출


CREATE OR REPLACE VIEW top5_genres AS (
	SELECT name, SUM(P.amount) AS Total_Sales FROM category C
    JOIN film_category USING(category_id)
    JOIN inventory USING(film_id)
    JOIN rental R USING(inventory_id)
    JOIN payment P USING(rental_id)
    GROUP BY C.category_id
    ORDER BY Total_Sales DESC
    LIMIT 5
);
SELECT * FROM top5_genres;

# 2005년 5월에 가장 많이 대여된 영화 3개


SELECT title, COUNT(*) 
FROM film F
JOIN inventory I USING(film_id)
JOIN rental R USING(inventory_id)
WHERE R.rental_date LIKE '2005-05%'
GROUP BY film_id
ORDER BY COUNT(inventory_id) DESC
LIMIT 3;

SELECT title, COUNT(*) 
FROM film F
JOIN inventory I USING(film_id)
JOIN rental R USING(inventory_id)
WHERE MONTH(R.rental_date) = 5
AND   YEAR(R.rental_date) = 2005
GROUP BY film_id
ORDER BY COUNT(inventory_id) DESC
LIMIT 3;

# 대여된 적이 없는 영화
SELECT
	title
FROM film F
WHERE NOT EXISTS (
	SELECT film_id FROM inventory
    JOIN rental USING(inventory_id)
);

# 각 고객의 총 지출 금액의 평균보다 총 지출금액이 더 큰 고객 리스트를 찾으세요. 그들의 이름과 그들이 지출한 총 금액을 보여주세요.


SELECT first_name, last_name, SUM(amount) as T
FROM customer
JOIN payment USING (customer_id)
GROUP BY customer_id
HAVING T >= (
	SELECT AVG(sub.total_mount) 
    FROM (
		SELECT SUM(amount) total_mount
		FROM customer
		JOIN payment USING (customer_id)
		GROUP BY customer_id
	) AS sub
);


SELECT
	SUM(amount) AS total
FROM customer
JOIN payment USING(customer_id)
GROUP BY customer_id
HAVING total >= 
	(SELECT
		AVG(sum_amount)
	FROM(
		SELECT SUM(amount) AS sum_amount
		FROM payment
		GROUP BY customer_id
	) AS sub_query)
;


# 가장 많은 결제건을 처리한 직원

SELECT staff_id, COUNT(*) FROM payment
GROUP BY staff_id
ORDER BY COUNT(*) DESC
LIMIT 1;

SELECT 
	S.staff_id,
    S.first_name,
    S.last_name,
    COUNT(*) AS count_many
FROM staff S
JOIN payment P USING(staff_id)
GROUP BY S.staff_id
ORDER BY COUNT(*) DESC
LIMIT 1;

# "액션" 카테고리에서 높은 영화 상영 등급을 받은 순으로, 상위 5개의 영화를 보여주세요


SELECT title, rating FROM film
JOIN film_category USING(film_id)
JOIN category C USING (category_id)
WHERE C.name = 'Action'
ORDER BY rating DESC
LIMIT 5;

SELECT
	F.title, F.rating
FROM film F
JOIN film_category FC USING(film_id)
JOIN category C USING(category_id)
WHERE C.name = 'Action'
ORDER BY rating DESC
LIMIT 5;

SELECT
	DISTINCT rating
FROM film;

DESC film;

# 각 영화 영상 등급의 영화별 대여기간의 평균


SELECT rating, AVG(rental_duration)
FROM film
GROUP BY rating;

# 매장 id 별 총 매출을 보여주는 VIEW 생성
CREATE VIEW store_sum AS (
SELECT SUM(amount) FROM payment
JOIN staff USING(staff_id)
JOIN store S USING(store_id)
GROUP BY S.store_id
);

SELECT * FROM store_sum;

# 가장 많은 고객이 있는 상위 5개 국가를 보여주세요
SELECT * FROM film; #film_id
SELECT * FROM film_category; #film_id, cateogry_id
SELECT * FROM category; # category_id
SELECT * FROM rental; # rental_id, inventory_id, customer_id
SELECT * FROM inventory; # inventory_id, film_id
SELECT * FROM payment; # payment_id, staff_id
SELECT * FROM customer; # rental_id, customer_id
SELECT * FROM staff; # staff_id address_id
SELECT * FROM store; # store_id, address id
SELECT * FROM rental; # rental_id, inventory_id, customer_id
SELECT * FROM film; #film_id
SELECT * FROM inventory; # inventory_id, film_id
SELECT * FROM address; #address_id, city_id
SELECT * FROM country; #country_id
SELECT * FROM city; # city_id, country_id
SELECT * FROM customer; #customer_id, address_id
SELECT * FROM store; #store_id, address_id
SELECT * FROM staff; #store_id, address_id

SELECT C.country, COUNT(customer_id) AS customer_num
FROM country C
JOIN city USING(country_id)
JOIN address USING(city_id)
JOIN customer USING(address_id)
GROUP BY country_id
ORDER BY customer_num DESC
LIMIT 5
;

# 각 고객이 어떤 영화 카테고리를 가장 자주 대여하는지 알고 싶습니다.
# 각 고객별로 가장많이 대여한 영화 카테고리와 해당 카테고리에서의 총 대여 횟수, 그리고 해당 고객 이름을 조회하는 SQL 구문을 작성해주세요.
# 자주 대여하는 카테고리에 동률이 있을 경우 모두 보여주세요.
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

SELECT  
    T.customer_id,
	T.first_name,
    T.last_name,
    T.name AS category_name,
    T.rental_cnt
FROM(
SELECT 
	C.customer_id,
	C.first_name,
    C.last_name,
    CA.name, 
    COUNT(*) AS rental_cnt,
	ROW_NUMBER() OVER(
    PARTITION BY customer_id
    ORDER BY COUNT(*) DESC, CA.category_id
    ) AS rn
FROM customer C
JOIN rental R USING(customer_id)
JOIN inventory I USING(inventory_id)
JOIN film_category FC USING(film_id)
JOIN category CA USING(category_id)
GROUP BY 
	C.customer_id,
    C.first_name,
    C.last_name,
    CA.category_id,
    CA.name) AS T
WHERE T.rn = 1
ORDER BY T.customer_id;




SELECT COUNT(I.inventory_id) FROM customer
JOIN rental R USING(customer_id)
JOIN inventory I USING(inventory_id)
JOIN film_category FC USING(film_id)
JOIN category CA USING(category_id)
GROUP BY category_id;

