SELECT TB.customer_id, TB.first_name, TB.last_name, total_rent
FROM
(SELECT
	C.customer_id,
    C.first_name,
    C.last_name,
-- 	DENSE_RANK() OVER (PARTITION BY C.customer_id ORDER BY COUNT(*) DESC) Total_rental1,
	COUNT(*) OVER (PARTITION BY C.customer_id) AS total_rent
--     FIRST_VALUE(COUNT(*)) OVER(PARTITION BY CA.category_id RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) TT
-- 	COUNT(*) OVER(PARTITION BY C.customer_id) AS Total_rental2
--     CA.name
FROM customer C
JOIN rental R USING(customer_id)
JOIN inventory I USING(inventory_id)
JOIN film_category F USING(film_id)
JOIN category CA USING(category_id)
GROUP BY C.customer_id, F.film_id) AS TB
union
SELECT TB.customer_id, TB.first_name, TB.last_name, total_rent
FROM
(SELECT
	C.customer_id,
    C.first_name,
    C.last_name,
-- 	DENSE_RANK() OVER (PARTITION BY C.customer_id ORDER BY COUNT(*) DESC) Total_rental1,
	COUNT(*) OVER (PARTITION BY C.customer_id) AS total_rent
--     FIRST_VALUE(COUNT(*)) OVER(PARTITION BY CA.category_id RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) TT
-- 	COUNT(*) OVER(PARTITION BY C.customer_id) AS Total_rental2
--     CA.name
FROM customer C
JOIN rental R USING(customer_id)
JOIN inventory I USING(inventory_id)
JOIN film_category F USING(film_id)
JOIN category CA USING(category_id)
GROUP BY C.customer_id, F.film_id) AS TB
ORDER BY total_rent DESC;
-- WHERE TB.total_rent = MAX(TB.total_rent);
-- WHERE TB.Total_rental1 = 1;
-- ORDER BY TB.Total_rental DESC;
-- ORDER BY Total_rental1 DESC
-- LIMIT 1;

WITH CustomerUniqueFilms AS (
	SELECT 
		C.customer_id,
		CONCAT(C.first_name, ' ', C.last_name) customer_name,
	--     COUNT(*)
		COUNT(DISTINCT I.film_id) AS unique_films_rented
	FROM customer C
	JOIN rental R USING(customer_id)
	JOIN inventory I USING(inventory_id)
	GROUP BY C.customer_id
),
MaxUniqueFilms AS(
	SELECT MAX(unique_films_rented) AS max_unique_films
    FROM CustomerUniqueFilms
)
SELECT
	CUF.customer_id,
    CUF.customer_name,
    CUF.unique_films_rented,
    (
		SELECT GROUP_CONCAT(name ORDER BY name)
        FROM (
			SELECT CAT.name, COUNT(*) AS category_count
            FROM category CAT
            JOIN film_category FC USING(category_id)
            JOIN inventory I USING(film_id)
            JOIN rental REN USING(inventory_id)
            WHERE REN.customer_id = CUF.customer_id
            GROUP BY CAT.name
        ) AS inner_category
        WHERE category_count =(
				SELECT MAX(category_count2)
				FROM (
				SELECT COUNT(*) AS category_count2
				FROM category CAT2
				JOIN film_category FC2 USING(category_id)
				JOIN inventory INV2 USING(film_id)
				JOIN rental REN2 USING(inventory_id)
				WHERE REN2.customer_id = CUF.customer_id
				GROUP BY CAT2.name
            ) AS subquery_cat
        )
    )
FROM CustomerUniqueFilms AS CUF
JOIN MaxUniqueFilms MUF ON CUF.unique_films_rented = MUF.max_unique_films;