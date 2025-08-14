USE sqldb_v1;
DESC usertbl;
DESC buytbl;

# 클러스터형 인덱스 : userID

SHOW INDEX FROM buyTbl;
SHOW INDEX FROM usertbl;

ALTER TABLE usertbl ADD CONSTRAINT TESTDate UNIQUE(mDATE);
CREATE INDEX idx_birth ON usertbl(birthYear);
ALTER TABLE usertbl ADD INDEX index_addr(addr);
ALTER TABLE usertbl DROP INDEX index_addr;