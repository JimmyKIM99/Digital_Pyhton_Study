CREATE DATABASE IF NOT EXISTS school;
USE school;

-- CREATE TABLE students(
-- 	id INT UNSIGNED NOT NULL AUTO_INCREMENT,
--     PRIMARY KEY (id)
-- );

CREATE TABLE students(
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    age INT UNSIGNED,
    grade VARCHAR(10)
);

DESC students;
INSERT INTO students VALUES(1, "강백호", 15, "8");
INSERT INTO students (name, age, grade)
VALUES("서태웅", 15, "8");

INSERT INTO students (grade, name, age)
VALUES("10", "채치수", 17);

SELECT * FROM students;

INSERT INTO students (grade, name, age)
VALUES("9", "정재만", 16);

INSERT INTO students (grade, name, age)
VALUES("9", "송태섭", 16);

SELECT name FROM students;
SELECT * FROM students WHERE age = 16; # 대입연산자
SELECT * FROM students WHERE age != 16; # 부정연산자1
SELECT * FROM students WHERE age <> 16; # 부정연산자2