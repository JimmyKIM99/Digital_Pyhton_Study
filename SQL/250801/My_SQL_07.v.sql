-- CREATE DATABASE membership;
-- USE membership;
-- CREATE TABLE member_list (
-- 	number INT AUTO_INCREMENT NOT NULL,
--     name VARCHAR(10) NOT NULL,
--     email VARCHAR(30) NOT NULL,
--     birthday INT NOT NULL,
--     enterday INT NOT NULL,
--     point INT NOT NULL,
--     sex VARCHAR(2) NOT NULL,
--     PRIMARY KEY (number)
-- );

CREATE TABLE member_list (
	number INT AUTO_INCREMENT NOT NULL,
    name VARCHAR(10) NOT NULL,
    email VARCHAR(30) NOT NULL,
    birthday DATE NOT NULL,
    enterday DATE NOT NULL,
    point INT NOT NULL,
    sex VARCHAR(2) NOT NULL,
    PRIMARY KEY (number)
);


INSERT INTO member_list (name, email, birthday, enterday, point, sex)
VALUES ("김용진", "sagejin@naver.com", "1999-06-29", "2025-07-01", "2000", "m"),
("김예진", "sage999@google.com", "1996-09-21", "2024-02-01", "1000", "f"),
("박지민", "jeiinn02@naver.com", "1991-08-09", "2023-04-22", "500", "m");
SELECT * FROM member_list;
SELECT * FROM member_list WHERE email LIKE "%@google.com";
SELECT * FROM member_list WHERE point >= 1000;

-- DROP TABLE member_list;

CREATE DATABASE IF NOT EXISTS membership2;
USE membership2;
CREATE TABLE members(
	id TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(10) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    birthday_date DATE, # '0000-00-00'
    signup_date DATETIME DEFAULT CURRENT_TIMESTAMP, # 'YYYY-MM-DD HH:MM:SS' / 현재 시간 DEFAULT CURRENT_TIMESTAMP
    points DECIMAL(10, 2),
    gender ENUM ('남', '녀') NOT NULL
);
DESC members;

INSERT INTO members (name, email, birthday_date, points, gender)
VALUES
('마동석', 'dong@google.com', '1990-01-01', 1000.50, '남'),
('장첸', 'jang@naver.com', '1992-05-10', 3500.75, '남'),
('정마담', 'jung@google.com', '1998-11-22', 120.10, '녀');

SELECT name, points FROM members
WHERE email LIKE '%@google.com';

SELECT name, birthday_date FROM members
ORDER BY birthday_date DESC;