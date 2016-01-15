CREATE SCHEMA if not exists dw_prestage;

DROP TABLE if exists dw_prestage.budgetforecast_fact;

CREATE TABLE dw_prestage.budgetforecast_fact 
(
  RUNID                      INTEGER,
  BUDGETFORECAST_ID          INTEGER,
  BUDGETFORECAST_NAME        VARCHAR(2000),
  FISCAL_MONTH_ID            INTEGER,
  FISCAL_WEEK_ID             INTEGER,
  LINE_OF_BUSINESS_ID        INTEGER,
  REGIONSALES_TERRITORY_ID   INTEGER,
  SUBSIDIARY_ID              INTEGER,
  MONTH_END_DATE             TIMESTAMP,
  MONTH_START_DATE           TIMESTAMP,
  WEEK_START_DATE            TIMESTAMP,
  WEEK_END_DATE              TIMESTAMP,
  AMOUNT                     DECIMAL(22,2),
  DATE_CREATED               TIMESTAMP,
  IS_INACTIVE                VARCHAR(10),
  LAST_MODIFIED_DATE         TIMESTAMP,
  BUDGETFORECAST_TYPE        VARCHAR(500)
);

