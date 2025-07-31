-- DROP DATABASE Jimmy;
-- CREATE DATABASE IF NOT EXISTS Jimmy;
-- USE Jimmy;
-- CREATE TABLE My_Table (
-- 	id INT UNSIGNED NOT NULL AUTO_INCREMENT,
--     name VARCHAR(50) NOT NULL,
--     modelnumber VARCHAR(15) NOT NULL,
--     series VARCHAR(30) NOT NULL,
--     PRIMARY KEY (id)
-- );
-- ALTER TABLE mytable MODIFY COLUMN name VARCHAR(30) NOT NULL;
-- ALTER TABLE mytable MODIFY COLUMN model_number VARCHAR(10) NOT NULL;
-- ALTER TABLE mytable MODIFY COLUMN model_type VARCHAR(10) NOT NULL;
-- DESC mytable;mytablemytable
-- DROP TABLE mytable;
CREATE TABLE model_info(
	id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    name VARCHAR(20) NOT NULL,
    model_num VARCHAR(10) NOT NULL,
    model_type VARCHAR(10) NOT NULL,
    PRIMARY KEY (id)
);
DESC model_info
-- USE Jimmy;
-- DROP TABLE IF EXISTS mytable;

-- ALTER TABLE model_info MODIFY COLUMN id INT UNSIGNED NOT NULL;