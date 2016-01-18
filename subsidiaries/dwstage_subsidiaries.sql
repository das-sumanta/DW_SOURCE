CREATE SCHEMA if not exists dw_stage;

DROP TABLE if exists dw_stage.subsidiaries;

CREATE TABLE dw_stage.subsidiaries 
(
  BASE_CURRENCY_ID            INTEGER,
  BRANCH_ID                   VARCHAR(4000),
  BRN                         VARCHAR(16),
  DATE_LAST_MODIFIED          TIMESTAMP,
  EDITION                     VARCHAR(20),
  FEDERAL_NUMBER              VARCHAR(15),
  FISCAL_CALENDAR_ID          INTEGER,
  FULL_NAME                   VARCHAR(1791),
  ISINACTIVE                  VARCHAR(3),
  IS_ELIMINATION              VARCHAR(3),
  IS_MOSS                     VARCHAR(3),
  LEGAL_ENTITY_ACCOUNT_CODE   VARCHAR(4000),
  LEGAL_NAME                  VARCHAR(83),
  MOSS_NEXUS_ID               INTEGER,
  NAME                        VARCHAR(83),
  PARENT_ID                   INTEGER,
  PURCHASEORDERAMOUNT         DECIMAL(20,2),
  PURCHASEORDERQUANTITY       DECIMAL(18,8),
  PURCHASEORDERQUANTITYDIFF   DECIMAL(18,8),
  RECEIPTAMOUNT               DECIMAL(20,2),
  RECEIPTQUANTITY             DECIMAL(18,8),
  RECEIPTQUANTITYDIFF         DECIMAL(18,8),
  STATE_TAX_NUMBER            VARCHAR(20),
  SUBSIDIARY_EXTID            VARCHAR(255),
  SUBSIDIARY_ID               INTEGER,
  TRAN_NUM_PREFIX             VARCHAR(8),
  UEN                         VARCHAR(16),
  URL                         VARCHAR(64),
  CURRENCY                    VARCHAR(100),
  PRIMARY KEY (SUBSIDIARY_ID,NAME)
)
DISTSTYLE ALL INTERLEAVED SORTKEY (SUBSIDIARY_ID,NAME);

