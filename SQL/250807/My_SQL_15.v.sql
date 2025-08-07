DESC items;
DESC ranking;

SELECT * FROM ranking
LIMIT 1000;

SELECT * FROM items
INNER JOIN ranking
ON ranking.item_code = items.item_code
WHERE ranking.main_category = "ALL";


# 에러가 발생하는 주요 원인
DESC items;
DESC ranking;

SELECT * FROM ranking
LIMIT 1000;

SELECT * FROM items A
INNER JOIN ranking B
ON B.item_code = A.item_code # ON 사용시 어떤 테이블의 컬럼값인지 따져야 함
WHERE main_category = "ALL"; # 만약 조건절에서 렂어한 데이터값이 특정 테이블에서만 사용시, 테이블 값 생략 가능

# 관습적으로 특정 테이블을 생략해서 키워드를 입력 => 해당 테이블의 첫단어를 사용! / 보통 2개까지도 가져감
SELECT * FROM items IT
INNER JOIN ranking RA
ON RA.item_code = IT.item_code 
WHERE main_category = "ALL";

 # 전체 베스트 상품 > 메인카테고리가 ALL에서 판매자별 베스트 상품 갯수를 출력
 
 SELECT GROUP_CONCAT(IT.item_code), COUNT(*), provider  FROM items IT
 INNER JOIN ranking RA
 ON RA.item_code = IT.item_code 
 WHERE RA.main_category = 'ALL'
 GROUP BY IT.provider
 ;
 
 SELECT provider, COUNT(*) FROM items I
 JOIN ranking R
 ON ranking.item_code = items.item_code
 WHERE ranking.main_category = "ALL"
 GROUP BY provider
 ORDER BY COUNT(*) DESC
 ;

# 메인 카테고리가 패션의류인 서브 카테고리 포함, 패션의류 best 상품에서 베스트 상품에서 판매자별 베스트 ㅅ ㅏㅇ품 갯수가 5이상인 판매자와 해당 베스트 상품에 대한 갯수
SELECT provider, COUNT(*) FROM items IT
JOIN ranking RA
ON RA.item_code = IT.item_code
WHERE (RA.main_category = "패션의류" OR RA.sub_category = "패션의류") # AND COUNT(*) >= 5
GROUP BY provider
HAVING COUNT(*) >= 5
ORDER BY COUNT(*) DESC;
---
SELECT DISTINCT main_category FROM ranking AS ra;

SELECT provider, COUNT(*) FROM items
JOIN ranking
ON ranking.item_code = items.item_code
WHERE main_category = "패션의류"
GROUP BY provider
HAVING COUNT(*) >= 5
ORDER BY COUNT(*) DESC;


# 메인 카테고리 신발잡화
# 판매자별 상품갯수가 01개 이상인 판매자명 & 상품갯수 출력
SELECT provider, COUNT(*) FROM items IT
JOIN ranking RA
ON RA.item_code = IT.item_code
WHERE RA.main_category = "신발/잡화"
GROUP BY provider
HAVING COUNT(*) >= 10
ORDER BY COUNT(*) DESC;

# 메인 카테고리 화장품 / 헤어, 해당 카테고리 내 평균, 최대, 최소 할인 가격을 출력
SELECT AVG(dis_price), MIN(dis_price), MAX(dis_price) FROM items IT
JOIN ranking RA
ON RA.item_code = IT.item_code
WHERE RA.main_category = "화장품/헤어";
---
SELECT
	AVG(dis_price),
    MIN(dis_pirce),
    MAX(dis_price)
FROM items IT
JOIN ranking RA
ON RA.item_code = IT.item_code
WHERE main_category = "화장품/헤어";


