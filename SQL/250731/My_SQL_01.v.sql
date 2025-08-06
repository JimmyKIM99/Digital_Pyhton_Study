#　현재 창을 통해 DB 생성
#　해당　공간에　한　줄씩　코드　작성　－＞　쿼리문
#　하나의　쿼리가　종료　의미　－＞　；　／＊　＊／　단락　주석

#1. DB 생성 : CREATE DATABASE dbname;
#2. DB 목록확인 : SHOW DATABASES;
#3. DB 접속 : USE dbname;
#4. Table 생성 : CREATE TABLE;
#5. Data 삽입
#6. DB 삭제 : DROP DATABASE IF EXISTS dbname;

# CREATE DATABASE dbname
# SHOW DATABASES;
# USE dbname;

/*
CREATE TABLE mytable (
	id INT, name VARCHAR(50), PRIMARY
);
*/
-- DROP DATABASE IF EXISTS dbname;
-- CREATE DATABASE Jimmy;
-- USE Jimmy;
/*
CREATE TABLE mytable (
	id TINYINT UNSIGNED, 
    name VARCHAR(50),
    PRIMARY KEY(id)
);
*/
/*
CREATE TABLE mytable (
	id FLOAT UNSIGNED, 
    name VARCHAR(50),
    PRIMARY KEY(id)
);
*/
/*
CREATE TABLE mytable (
	id INT UNSIGNED, 
    name VARCHAR(50),
    PRIMARY KEY(id)
);
*/
/*
CREATE TABLE mytable (
	id INT NOT NULL AUTO_INCREMENT, 
    name VARCHAR(50),
    PRIMARY KEY(id)
); */
/*
CREATE TABLE mytable (
	id INT NOT NULL AUTO_INCREMENT, 
    name CHAR(50), # 50개의 문자열이 들어올 수 있는 공간을 항상 준비
	city VARCHAR(50), # 최대 50개까지 입력 -> 5개
    PRIMARY KEY(id)
);
*/

/*
CREATE TABLE mytable (
	id INT NOT NULL AUTO_INCREMENT, 
    name VARCHAR(50),
    PRIMARY KEY(id, name) # 하나의 레코드 안에 프라이머리 키는 복수 가능
);
*/

CREATE TABLE mytable (
	id INT NOT NULL AUTO_INCREMENT, 
    name VARCHAR(50),
    modelnumber VARCHAR(15) NOT NULL,
	series VARCHAR(30) NOT NULL,
    PRIMARY KEY(id)
);