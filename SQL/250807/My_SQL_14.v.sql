CREATE DATABASE IF NOT EXISTS bestproducts;
USE bestproducts;

DESC items;
SELECT COUNT(*) FROM items;

SELECT * FROM items
LIMIT 1;

SELECT provider FROM items
GROUP BY provider;

# 가설 : 베스트 랭킹에 등록되어있는 약 1만개 이상의 업체들 가운데 베스트 업체, 베스트 랭킹 안에 약 100개정도의 자사 OR 위탁 상품을 가지고 운영하지 않을까?

SELECT provider, COUNT(provider >= 100)FROM items
GROUP BY provider;

# SUM, MAX, MIN, AVG, COUNT 등과 같은 집계 한수들은 절대 GROUP BY와 함께 WHERE 절에는 쓸 수 없음
# 결론 : GROUP BY와 집계함수는 WHERE절에서 절대 사용 불가

SELECT provider FROM items
GROUP BY provider
HAVING COUNT(*) >= 100;

# GROUP BY 설정 했다고 해서 집계함수 아예 사용불가 x / WHERE 절 안에 집계합수 사용하고자 할때 x
SELECT provider, COUNT(*) FROM items
WHERE
	provider != "스마일배송" AND
    provider != ""
GROUP BY provider
HAVING COUNT(*) >= 100
ORDER BY COUNT(*) DESC;