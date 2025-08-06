-- USE school;
DESC students;
SELECT * FROM students;

UPDATE students SET age = "15세" WHERE id = 1;
ALTER TABLE students MODIFY COLUMN age VARCHAR(10);
UPDATE students SET age = "15세" WHERE id = 2;
UPDATE students SET age = "17세" WHERE id = 3;
UPDATE students SET age = "16세" WHERE id = 4;
UPDATE students SET age = "16세" WHERE id = 5;

SELECT name FROM students;
SELECT name, age FROM students;
SELECT * FROM students WHERE age = "16세";
SELECT * FROM students WHERE age != "16세";
SELECT * FROM students WHERE age <> "16세";
SELECT * FROM students WHERE age > "16세";
UPDATE students SET grade = "8학년" WHERE id = 1;
UPDATE students SET grade = "8학년" WHERE id = 2;
UPDATE students SET grade = "10학년" WHERE id = 3;
UPDATE students SET grade = "9학년" WHERE id = 4;
UPDATE students SET grade = "9학년" WHERE id = 5;

SELECT * FROM students WHERE grade != "10학년";
SELECT * FROM students
WHERE age >= "15세" AND grade >= "10학년";
SELECT * FROM students
WHERE age <= "16세" OR grade = "8학년";

SELECT * FROM students
WHERE name LIKE "%태%"; # '%'는 0개여도 괜찮고 1개여도 괜찮음

SELECT * FROM students
WHERE name LIKE "_태_"; # '_' 정확한 갯수로 있어야 함

SELECT * FROM students
WHERE name LIKE "___";