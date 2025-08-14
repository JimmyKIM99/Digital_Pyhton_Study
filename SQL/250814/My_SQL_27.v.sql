SELECT
	first_name,
    last_name
FROM customer
WHERE customer_id = (
	SELECT customer_id
    FROM(
		SELECT customer_id, COUNT(*) AS payment_count
        FROM payment
        GROUP BY customer_id
    ) AS payment_counts
    ORDER BY payment_count DESC
    LIMIT 1
);