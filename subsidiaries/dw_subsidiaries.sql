CREATE SCHEMA if not exists dw;

DROP TABLE if exists dw.subsidiaries;

CREATE TABLE dw.subsidiaries 
(
  SUBSIDIARY_KEY         BIGINT IDENTITY(0,1),
  SUBSIDIARY_ID          INTEGER,
  NAME                   VARCHAR(100),
  ISINACTIVE             VARCHAR(10),
  EDITION                VARCHAR(20),
  ELIMINATION            VARCHAR(10),
  LEGAL_NAME             VARCHAR(100),
  VAT_REG_NO             VARCHAR(20),
  LEGAL_ACCOUNT_CODE     VARCHAR(4000),
  FISCAL_CALENDAR_ID     INTEGER,
  CURRENCY               VARCHAR(50),
  CURRENCY_ID            INTEGER,
  PARENT_SUBSIDIARY      VARCHAR(100),
  PARENT_SUBSIDIARY_ID   INTEGER,
  DATE_ACTIVE_FROM       TIMESTAMP,
  DATE_ACTIVE_TO         TIMESTAMP,
  DW_ACTIVE              VARCHAR(1),
  PRIMARY KEY (SUBSIDIARY_KEY,SUBSIDIARY_ID,NAME)
)
DISTSTYLE ALL INTERLEAVED SORTKEY (SUBSIDIARY_KEY,SUBSIDIARY_ID,NAME,DW_ACTIVE);

INSERT INTO dw.subsidiaries
(
  SUBSIDIARY_ID,
  NAME,
  ISINACTIVE,
  EDITION,
  ELIMINATION,
  LEGAL_NAME,
  VAT_REG_NO,
  LEGAL_ACCOUNT_CODE,
  FISCAL_CALENDAR_ID,
  CURRENCY,
  CURRENCY_ID,
  PARENT_SUBSIDIARY,
  PARENT_SUBSIDIARY_ID,
  DATE_ACTIVE_FROM,
  DATE_ACTIVE_TO,
  DW_ACTIVE
)
SELECT -99 AS SUBSIDIARY_ID,
       'NA_GDW' AS NAME,
       'NA_GDW' AS ISINACTIVE,
       'NA_GDW' AS EDITION,
       'NA_GDW' AS ELIMINATION,
       'NA_GDW' AS LEGAL_NAME,
       'NA_GDW' AS VAT_REG_NO,
       'NA_GDW' AS LEGAL_ACCOUNT_CODE,
       -99 AS FISCAL_CALENDAR_ID,
       'NA_GDW' AS CURRENCY,
       -99 AS CURRENCY_ID,
       'NA_GDW' AS PARENT_SUBSIDIARY,
       -99 AS PARENT_SUBSIDIARY_ID,
       sysdate AS DATE_ACTIVE_FROM,
       '9999-12-31 23:59:59' AS DATE_ACTIVE_TO,
       'A' AS DW_ACTIVE;

INSERT INTO dw.subsidiaries
(
  SUBSIDIARY_ID,
  NAME,
  ISINACTIVE,
  EDITION,
  ELIMINATION,
  LEGAL_NAME,
  VAT_REG_NO,
  LEGAL_ACCOUNT_CODE,
  FISCAL_CALENDAR_ID,
  CURRENCY,
  CURRENCY_ID,
  PARENT_SUBSIDIARY,
  PARENT_SUBSIDIARY_ID,
  DATE_ACTIVE_FROM,
  DATE_ACTIVE_TO,
  DW_ACTIVE
)
SELECT 0 AS SUBSIDIARY_ID,
       'NA_ERR' AS NAME,
       'NA_ERR' AS ISINACTIVE,
       'NA_ERR' AS EDITION,
       'NA_ERR' AS ELIMINATION,
       'NA_ERR' AS LEGAL_NAME,
       'NA_ERR' AS VAT_REG_NO,
       'NA_ERR' AS LEGAL_ACCOUNT_CODE,
       0 AS FISCAL_CALENDAR_ID,
       'NA_ERR' AS CURRENCY,
       0 AS CURRENCY_ID,
       'NA_ERR' AS PARENT_SUBSIDIARY,
       0 AS PARENT_SUBSIDIARY_ID,
       sysdate AS DATE_ACTIVE_FROM,
       '9999-12-31 23:59:59' AS DATE_ACTIVE_TO,
       'A' AS DW_ACTIVE;

COMMIT;