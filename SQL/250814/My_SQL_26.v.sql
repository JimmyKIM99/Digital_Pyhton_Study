USE sakila;

SHOW TABLES;

SELECT
	P.customer_id, P.amount , P.payment_date
FROM payment AS P
WHERE P.amount > (
	SELECT AVG(amount)
    FROM payment
    WHERE customer_id = P.customer_id
)
LIMIT 5;

# 중고급 서브쿼리 시작!


SELECT
	first_name,
    last_name
FROM customer
WHERE customer_id IN (
	SELECT customer_id
    FROM payment
    WHERE amount > (SELECT AVG(amount) FROM payment)
);

SELECT
	first_name,
    last_name
FROM customer
WHERE customer_id IN (
	SELECT customer_id
    FROM payment
    WHERE amount > 3
);


# FROM 절 안에는 AS를 써야함

SELECT
	first_name,
    last_name
FROM customer
WHERE customer_id IN (
	SELECT customer_id 
    FROM payment
    GROUP BY customer_id
    HAVING COUNT(*) > (
		SELECT
			AVG(payment_count)
        FROM (
			SELECT COUNT(*) AS payment_count
            FROM payment
            GROUP BY customer_id
		) AS payments_count
    )
);


