CREATE DATABASE IF NOT EXISTS index_demo_v1;
USE index_demo_v1;
CREATE TABLE customers(
	id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    age INT,
    city VARCHAR(100)
);
DESC customers;

SHOW VARIABLES LIKE 'default_storage_engine';

# 클러스터형 인덱스, 보조형 인덱스가 다른 필드값에 있는 요소들을 이용시보다 연산 처리 속도 빠르다
# 우선, 스토리지 엔진 (STORAGE ENGINE 구성) 확인
# ENGINE = InnoDB
# MySQL 8.0 이상 버전 부터, 기본값으로 
# MyISAM

INSERT INTO customers (name, email, age, city) VALUES ();

INSERT INTO customers (name, email, age, city)
SELECT 
	CONCAT('User', LPAD(FLOOR(RAND() * 1000000 ), 5, '0')), # 소수점 난수로 반환
    CONCAT('user', FLOOR(RAND() * 1000000 ), '@test.com'),
    FLOOR(18 + RAND() * 50),
    ELT(FLOOR(1 + (RAND() * 5)),'Seoul', 'Busan', 'Incheon', 'Deagu', 'Deajeon')
FROM information_schema.tables LIMIT 1000;

SELECT * FROM customers;

SHOW INDEX FROM customers;
CREATE INDEX idx_email ON customers(email);
CREATE INDEX idx_age ON customers(age);

SELECT * FROM customers;
EXPLAIN SELECT * FROM customers; # ALL 377

EXPLAIN SELECT * FROM customers WHERE id = 300; # const(상수) -> PRIMARY KEY 찾기 빠름
EXPLAIN SELECT * FROM customers WHERE email = 'user746199@test.com'; # ref(참조) -> CONST 다음 빠름
EXPLAIN SELECT * FROM customers WHERE city = 'Busan'; # 빅데이터, INDEX 중요


# information_schema.table
# 현재 내가 사용하고 있는 MySQL 워크벤치 안에 안에 있는 전체 테이블 정보 값을 가지고 있는 시스템 테이블 = 메타 테이블
# MySQL 워크벤치 -> 대략적인 테이블 수의 정보를 기준으로 / 가상테이블