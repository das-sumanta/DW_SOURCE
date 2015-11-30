CREATE SCHEMA if not exists dw_stage;

DROP TABLE if exists dw_stage.accounts;

CREATE TABLE dw_stage.accounts 
(
  ACCOUNTNUMBER                   VARCHAR(60),
  ACCOUNT_EXTID                   VARCHAR(255),
  ACCOUNT_ID                      INTEGER,
  ACCPAC_CODES                    VARCHAR(4000),
  BANK_ACCOUNT_NUMBER             VARCHAR(4000),
  CASHFLOW_RATE_TYPE              VARCHAR(10),
  CATEGORY_1099_MISC              VARCHAR(60),
  CATEGORY_1099_MISC_MTHRESHOLD   DECIMAL(20,2),
  CLASS_ID                        INTEGER,
  LINE_OF_BUSINESS                VARCHAR(100),
  CURRENCY_ID                     INTEGER,
  CURRENCY_NAME                   VARCHAR(200),
  DATE_LAST_MODIFIED              TIMESTAMP,
  DEFERRAL_ACCOUNT_ID             INTEGER,
  DEPARTMENT_ID                   INTEGER,
  COST_CENTER_NAME                VARCHAR(100),
  DESCRIPTION                     VARCHAR(25),
  FULL_DESCRIPTION                VARCHAR(60),
  FULL_NAME                       VARCHAR(1791),
  GENERAL_RATE_TYPE               VARCHAR(10),
  HYPERION_CODES                  VARCHAR(4000),
  ISINACTIVE                      VARCHAR(3),
  IS_BALANCESHEET                 VARCHAR(1),
  IS_INCLUDED_IN_ELIMINATION      VARCHAR(1),
  IS_INCLUDED_IN_REVAL            VARCHAR(1),
  IS_LEFTSIDE                     VARCHAR(1),
  IS_SUMMARY                      VARCHAR(3),
  LOCATION_ID                     INTEGER,
  LOCATION_NAME                   VARCHAR(100),
  NAME                            VARCHAR(93),
  OPENBALANCE                     DECIMAL(22,0),
  PARENT_ID                       INTEGER,
  PARENT_ACCOUNT_NAME             VARCHAR(200),
  PARENT_ACCOUNT_NUMBER           VARCHAR(60),
  TYPE_NAME                       VARCHAR(64),
  TYPE_SEQUENCE                   DECIMAL(22,0)
);

