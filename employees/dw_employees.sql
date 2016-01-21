CREATE SCHEMA if not exists dw;

DROP TABLE if exists dw.employees cascade;

CREATE TABLE dw.employees 
(
  EMPLOYEE_KEY          BIGINT IDENTITY(0,1),
  EMPLOYEE_ID           INTEGER,
  NAME                  VARCHAR(200),
  FULL_NAME             VARCHAR(4000),
  FIRSTNAME             VARCHAR(500),
  LASTNAME              VARCHAR(500),
  INITIALS              VARCHAR(50),
  JOB_TITLE             VARCHAR(100),
  EMAIL                 VARCHAR(300),
  LINE1                 VARCHAR(500),
  LINE2                 VARCHAR(500),
  LINE3                 VARCHAR(500),
  ZIPCODE               VARCHAR(100),
  CITY                  VARCHAR(100),
  STATE                 VARCHAR(100),
  COUNTRY               VARCHAR(100),
  SUPERVISOR_NAME       VARCHAR(200),
  SUPERVISOR_ID         INTEGER,
  APPROVER_ID           INTEGER,
  APPROVER_NAME         VARCHAR(200),
  SUBSIDIARY            VARCHAR(83),
  SUBSIDIARY_ID         INTEGER,
  LINE_OF_BUSINESS      VARCHAR(2000),
  LINE_OF_BUSINESS_ID   INTEGER,
  LOCATION              VARCHAR(31),
  LOCATION_ID           INTEGER,
  COST_CENTER           VARCHAR(2000),
  COST_CENTER_ID        INTEGER,
  HIRE_DATE             DATE,
  RELEASE_DATE          DATE,
  DATE_ACTIVE_FROM      TIMESTAMP,
  DATE_ACTIVE_TO        TIMESTAMP,
  DW_ACTIVE             VARCHAR(1),
  PRIMARY KEY (EMPLOYEE_KEY,EMPLOYEE_ID)
)
DISTSTYLE ALL COMPOUND SORTKEY (EMPLOYEE_KEY,EMPLOYEE_ID,NAME,DW_ACTIVE);

INSERT INTO dw.employees
(
  EMPLOYEE_ID,
  NAME,
  FULL_NAME,
  FIRSTNAME,
  LASTNAME,
  INITIALS,
  JOB_TITLE,
  EMAIL,
  LINE1,
  LINE2,
  LINE3,
  ZIPCODE,
  CITY,
  STATE,
  COUNTRY,
  SUPERVISOR_NAME,
  SUPERVISOR_ID,
  APPROVER_ID,
  APPROVER_NAME,
  SUBSIDIARY,
  SUBSIDIARY_ID,
  LINE_OF_BUSINESS,
  LINE_OF_BUSINESS_ID,
  LOCATION,
  LOCATION_ID,
  COST_CENTER,
  COST_CENTER_ID,
  HIRE_DATE,
  RELEASE_DATE,
  DATE_ACTIVE_FROM,
  DATE_ACTIVE_TO,
  DW_ACTIVE
)
SELECT -99 AS EMPLOYEE_ID,
       'NA_GDW' AS NAME,
       'NA_GDW' AS FULL_NAME,
       'NA_GDW' AS FIRSTNAME,
       'NA_GDW' AS LASTNAME,
       'NA_GDW' AS INITIALS,
       'NA_GDW' AS JOB_TITLE,
       'NA_GDW' AS EMAIL,
       'NA_GDW' AS LINE1,
       'NA_GDW' AS LINE2,
       'NA_GDW' AS LINE3,
       'NA_GDW' AS ZIPCODE,
       'NA_GDW' AS CITY,
       'NA_GDW' AS STATE,
       'NA_GDW' AS COUNTRY,
       'NA_GDW' AS SUPERVISOR_NAME,
       -99 AS SUPERVISOR_ID,
       -99 AS APPROVER_ID,
       'NA_GDW' AS APPROVER_NAME,
       'NA_GDW' AS SUBSIDIARY,
       -99 AS SUBSIDIARY_ID,
       'NA_GDW' AS LINE_OF_BUSINESS,
       -99 AS LINE_OF_BUSINESS_ID,
       'NA_GDW' AS LOCATION,
       -99 AS LOCATION_ID,
       'NA_GDW' AS COST_CENTER,
       -99 AS COST_CENTER_ID,
       '9999-12-31 11:59:59' AS HIRE_DATE,
       '9999-12-31 11:59:59' AS RELEASE_DATE,
       SYSDATE AS DATE_ACTIVE_FROM,
       '9999-12-31 11:59:59' AS DATE_ACTIVE_TO,
       'A' AS DW_ACTIVE;

INSERT INTO dw.employees
(
  EMPLOYEE_ID,
  NAME,
  FULL_NAME,
  FIRSTNAME,
  LASTNAME,
  INITIALS,
  JOB_TITLE,
  EMAIL,
  LINE1,
  LINE2,
  LINE3,
  ZIPCODE,
  CITY,
  STATE,
  COUNTRY,
  SUPERVISOR_NAME,
  SUPERVISOR_ID,
  APPROVER_ID,
  APPROVER_NAME,
  SUBSIDIARY,
  SUBSIDIARY_ID,
  LINE_OF_BUSINESS,
  LINE_OF_BUSINESS_ID,
  LOCATION,
  LOCATION_ID,
  COST_CENTER,
  COST_CENTER_ID,
  HIRE_DATE,
  RELEASE_DATE,
  DATE_ACTIVE_FROM,
  DATE_ACTIVE_TO,
  DW_ACTIVE
)
SELECT 0 AS EMPLOYEE_ID,
       'NA_ERR' AS NAME,
       'NA_ERR' AS FULL_NAME,
       'NA_ERR' AS FIRSTNAME,
       'NA_ERR' AS LASTNAME,
       'NA_ERR' AS INITIALS,
       'NA_ERR' AS JOB_TITLE,
       'NA_ERR' AS EMAIL,
       'NA_ERR' AS LINE1,
       'NA_ERR' AS LINE2,
       'NA_ERR' AS LINE3,
       'NA_ERR' AS ZIPCODE,
       'NA_ERR' AS CITY,
       'NA_ERR' AS STATE,
       'NA_ERR' AS COUNTRY,
       'NA_ERR' AS SUPERVISOR_NAME,
       0 AS SUPERVISOR_ID,
       0 AS APPROVER_ID,
       'NA_ERR' AS APPROVER_NAME,
       'NA_ERR' AS SUBSIDIARY,
       0 AS SUBSIDIARY_ID,
       'NA_ERR' AS LINE_OF_BUSINESS,
       0 AS LINE_OF_BUSINESS_ID,
       'NA_ERR' AS LOCATION,
       0 AS LOCATION_ID,
       'NA_ERR' AS COST_CENTER,
       0 AS COST_CENTER_ID,
       '9999-12-31 11:59:59' AS HIRE_DATE,
       '9999-12-31 11:59:59' AS RELEASE_DATE,
       SYSDATE AS DATE_ACTIVE_FROM,
       '9999-12-31 11:59:59' AS DATE_ACTIVE_TO,
       'A' AS DW_ACTIVE;

COMMIT;

