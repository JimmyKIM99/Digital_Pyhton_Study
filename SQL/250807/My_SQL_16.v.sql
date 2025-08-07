USE sakila;
SELECT * FROM address
LIMIT 1;

SELECT * FROM customer
LIMIT 1;

SELECT COUNT(*) FROM customer
RIGHT OUTER JOIN address
ON customer.address_id = address.address_id
WHERE customer_id IS NULL
;

# 서브 카테고리가 "여성신발"인 상품 타이틀만 가져오기
USE bestproducts;
DESC items;
DESC ranking;

SELECT title FROM items
JOIN ranking
ON items.item_code = ranking.item_code
WHERE ranking.sub_category = "여성신발";

# 서브쿼리 구문을 활용해서 서로 다른 두개의 테이블을 연결해서 값을 찾아온다면?

SELECT item_code FROM items
LIMIT 3;

# WHERE IN 문으로 반복 요소 축약
SELECT title FROM items
WHERE item_code IN (
	"102425348",
    "104914497",
    "106332300"
);

SELECT title FROM items
WHERE item_code IN 
	(SELECT item_code FROM ranking
    WHERE sub_category =  "여성신발");
    
USE sakila;

SELECT * FROM category;

SELECT category_id, COUNT(*)
FROM film_category
WHERE film_category.category_id >
	(SELECT category.category_id FROM category
    WHERE category.name = "Comedy")
GROUP BY film_category.category_id;

# bestproduct > 메인 카테고리별로 할인 가격이 10만원 이상인 상품이 몇 개 있는지를 출력
SELECT * FROM items
LIMIT 1;
USE bestproducts;

SELECT RA.main_category, COUNT(*) FROM items IT
JOIN ranking RA
ON IT.item_code = RA.item_code
WHERE IT.dis_price > "100000"
GROUP BY RA.main_category;
----
SELECT main_category, COUNT(*) FROM items
JOIN ranking
ON items.item_code = ranking.item_code
WHERE items.dis_price >= "100000"
GROUP BY main_category
ORDER BY COUNT(*) DESC;

# 작성했던 코드를 서브쿼리로 구현하기
SELECT main_category, COUNT(*) FROM ranking
WHERE item_code IN
	(SELECT items.item_code FROM items
    WHERE items.dis_price > 100000)
GROUP BY main_category
ORDER BY COUNT(*) DESC;

# dis_price 20만원 이상인 아이템들의  서브 카테고리별 상품 갯수 출력
SELECT sub_category, COUNT(*) FROM ranking
WHERE item_code IN
	(SELECT items.item_code FROM items
    WHERE items.dis_price > 200000)
GROUP BY sub_category
ORDER BY COUNT(*) DESC;
---
SELECT sub_category, COUNT(*)
FROM ranking
JOIN items
ON ranking.item_code = items.item_code
WHERE dis_price >= 200000
GROUP BY sub_category
ORDER BY COUNT(*) DESC;