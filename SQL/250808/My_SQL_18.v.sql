USE bestproducts;
# 메인 카테고리, 서브 카테고리별 평균 할인 가격과 평균 할인률
SELECT * FROM items LIMIT 10;
SELECT * FROM ranking LIMIT 1000;

SELECT main_category, sub_category, AVG(ori_price), AVG(discount_percent) FROM ranking R
JOIN items I ON R.item_code = I.item_code
GROUP BY main_category, sub_category;

SELECT sub_category, AVG(ori_price), AVG(discount_percent) FROM ranking R
JOIN items I ON R.item_code = I.item_code
GROUP BY sub_category;

-----
SELECT AVG(dis_price), AVG(discount_percent)
FROM items I
JOIN ranking R
ON I.item_code = R.item_code
GROUP BY main_category, sub_category;

# 2. 판매자별 베스트상품 갯수, 평균할인가격, 평균할인률을 출력해주세요.
# - 상품갯수 순으로 내림차순 정렬해주세요.
SELECT provider, COUNT(*), AVG(dis_price), AVG(discount_percent) FROM items I
JOIN ranking R ON I.item_code = R.item_code
GROUP BY provider
ORDER BY count(*) DESC;
-----
SELECT
	provider,
    COUNT(*) count,
    AVG(dis_price) dis_price,
    AVG(discount_price) dis_percent
FROM items
GROUP BY provider
ORDER BY count DESC;

# 3. 메인 카테고리별 베스트 상품 갯수가 20개 이상인 판매자의 판매자별 평균할인가격, 평균할인률, 베스트 상품 갯수를 출력
SELECT main_category, provider, AVG(dis_price), AVG(discount_percent), COUNT(*) FROM items I
JOIN ranking R ON I.item_code = R.item_code
GROUP BY provider, main_category
HAVING COUNT(*) >=20
ORDER BY count(*) DESC;
-----
SELECT
	R.main_category,
	provider,
    COUNT(*),
	AVG(dis_price),
    AVG(discount_percent)
FROM items AS I
JOIN ranking R ON I.item_code = R.item_code
WHERE I.provider IS NOT NULL AND I.provider!= ''
GROUP BY I.provider, R.main_category
ORDER BY COUNT(*) DESC;

# dis_price 5만원 이상 상품 main category별 평균 DIS PRICE DIS PERCET
SELECT main_category, AVG(dis_price), AVG(discount_percent) FROM ranking R
JOIN items I ON I.item_code = R.item_code
WHERE dis_price >= 50000
GROUP BY main_category
ORDER BY AVG(dis_price) DESC;
-----

SELECT
	main_category,
	AVG(dis_price) dis_price,
    AVG(discount_percent) discount_percent
FROM items
JOIN ranking ON items.item_code = ranking.item_code
WHERE dis_price >= 50000
GROUP BY ranking.main_category;