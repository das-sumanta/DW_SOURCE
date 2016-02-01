CREATE SCHEMA if not exists dw;

DROP TABLE if exists dw.budgetforecast_fact;

CREATE TABLE dw.budgetforecast_fact 
(
  BUDGETFORECAST_KEY         BIGINT IDENTITY(0,1),
  BUDGETFORECAST_ID          INTEGER,
  BUDGETFORECAST_NAME        VARCHAR(2000),
  FISCAL_MONTH_ID            INTEGER,
  FISCAL_WEEK_ID             INTEGER,
  CLASS_KEY                  INTEGER,
  TERRITORY_KEY              INTEGER,
  SUBSIDIARY_KEY             INTEGER,
  BUDGETFORECAST_TYPE        VARCHAR(500),
  MONTH_END_DATE             TIMESTAMP,
  MONTH_START_DATE           TIMESTAMP,
  WEEK_START_DATE            TIMESTAMP,
  WEEK_END_DATE              TIMESTAMP,
  AMOUNT                     DECIMAL(22,2),
  IS_INACTIVE                VARCHAR(10),
  CREATION_DATE                 TIMESTAMP,
  LAST_MODIFIED_DATE            TIMESTAMP,
  DATE_ACTIVE_FROM              DATE,
  DATE_ACTIVE_TO             DATE,
  DW_CURRENT                  INTEGER,
  PRIMARY KEY (BUDGETFORECAST_KEY)
DISTSTYLE ALL INTERLEAVED SORTKEY (SUBSIDIARY_KEY,BUDGETFORECAST_TYPE,BUDGETFORECAST_ID,BUDGETFORECAST_NAME,FISCAL_MONTH_ID,FISCAL_WEEK_ID);

