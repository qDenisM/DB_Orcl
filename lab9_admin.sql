GRANT CREATE TABLE, 
      CREATE SEQUENCE, 
      CREATE CLUSTER, 
      CREATE SYNONYM, 
      CREATE VIEW, 
      CREATE MATERIALIZED VIEW, 
      CREATE DATABASE LINK,
      CREATE PROCEDURE,
      CREATE PUBLIC SYNONYM TO MDS;
      
CREATE USER MDS_TNS IDENTIFIED BY 123
DEFAULT TABLESPACE USERS QUOTA UNLIMITED ON USERS
TEMPORARY TABLESPACE TEMP;

GRANT CREATE SESSION TO MDS_TNS;

ALTER USER MDS_TNS QUOTA 10m ON USERS;

SELECT * FROM DBA_DB_LINKS;

SHOW PARAMETER SERVICE_NAMES;

ALTER USER MDS_TNS IDENTIFIED BY "mds123";

SELECT * FROM C_SYN;

SELECT * FROM B_PSYN;






      
