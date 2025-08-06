# Netflix Data 분석 마케터
# 특정 데이터 존재= 사용자별 일일
# A 사용자 10일 5시간 30분시험
# B 사용자 15일 3시간시청
# ...

# STP => Segment => Target => Positioning => Persona

# 주요 고객 DB
CREATE DATABASE netflix;
USE netflix;
DROP TABLE cumstomers;
CREATE TABLE customers (
	user_id INT PRIMARY KEY,
    user_name VARCHAR(50)
);

INSERT INTO customers (user_id, user_name)
VALUES (1, "ALICE"), (2, "DAVID"), (3, "CATHY");

SELECT * FROM customers;

CREATE TABLE watch_history (
	watch_id INT PRIMARY KEY,
    user_id INT,
    date_time DATE,
    hours_watched DECIMAL(4, 1),
    FOREIGN KEY(user_id) REFERENCES customers(user_id)
);

DESC watch_history;
INSERT INTO watch_history (watch_id, user_id, date_time, hours_watched)
VALUES
(101, 1, "2025-07-25", 5.5),
(102, 1, "2025-07-27", 3.0),
(103, 2, "2025-07-28", 2.5),
(104, 3, "2025-07-31", 7.5),
(105, 2, "2025-08-01", 6.0),
(106, 2, "2025-08-04", 2.5),
(107, 3, "2025-08-05", 3.0),
(108, 1, "2025-08-05", 1.5);

SELECT * FROM watch_history;

SELECT c.user_id, c.user_name, SUM(w.hours_watched) AS total_hours
FROM customers c
JOIN watch_history w ON c.user_id = w.user_id
WHERE w.date_time >= CURDATE() - INTERVAL 1 MONTH
GROUP BY c.user_id, c.user_name
ORDER BY total_hours DESC
LIMIT 10;