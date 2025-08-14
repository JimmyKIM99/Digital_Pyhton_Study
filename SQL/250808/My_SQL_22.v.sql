USE musinsa_db_v4;
DESC reviews;
SELECT * FROM reviews;

SELECT 
	상품명,
	AVG(CHAR_LENGTH(리뷰)) AS 평균_리뷰길이
FROM reviews
GROUP BY 상품명
ORDER BY 평균_리뷰길이 DESC;

SELECT COUNT(*)
FROM reviews
WHERE 리뷰 LIKE '%별로%' OR 리뷰 LIKE '%뷸편%';

