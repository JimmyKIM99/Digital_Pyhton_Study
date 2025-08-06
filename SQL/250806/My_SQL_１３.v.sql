CREATE DATABASE IF NOT EXISTS sqlDB_v1;
USE sqlDB_v1;

CREATE TABLE userTbl (
	userID CHAR(8) NOT NULL PRIMARY KEY,
    name VARCHAR(10) UNIQUE NOT NULL,
    birthYear INT NOT NULL,
    addr CHAR(2) NOT NULL,
    mobile1 CHAR(3),
    mobile2 CHAR(8),
    height SMALLINT,
    mDATE DATE
);

INSERT INTO userTbl (userID, name, birthYear, addr, mobile1, mobile2, height, mDATE)
VALUES
("Jimmy", "김용진", 1999, "서울", "010", "28267156", 178, "1999-06-29");

CREATE TABLE buyTbl (
	num INT AUTO_INCREMENT PRIMARY KEY,
    userID CHAR(8) NOT NULL,
    productName CHAR(4),
    groupName CHAR(4),
    price INT NOT NULL,
    amount SMALLINT NOT NULL,
    FOREIGN KEY (userID) REFERENCES userTbl(userID)
);
INSERT INTO buyTbl (userID, productName, groupName, price, amount)
VALUES
("Jimmy", "에어조던", "패션잡화", 30, 2);

DELETE FROM userTbl WHERE userID = "Jimmy";
SELECT * FROM userTbl;