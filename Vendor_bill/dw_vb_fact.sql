CREATE SCHEMA if not exists dw;

DROP TABLE if exists dw.vb_fact;

CREATE TABLE dw.vb_fact 
(
  VB_KEY                      BIGINT IDENTITY(0,1),
  VB_NUMBER                   VARCHAR(150),
  VB_ID                       INTEGER,
  VB_LINE_ID                  INTEGER,
  VENDOR_KEY                  INTEGER,
  SOURCE_TRANSACTION_NUMBER   VARCHAR(200),
  SOURCE_TRANSACTION_TYPE     VARCHAR(200),
  TERMS_KEY                   INTEGER,
  DUE_DATE_KEY                INTEGER,
  CREATE_DATE_KEY             INTEGER,
  ACCOUNT_KEY                 INTEGER,
  PAYMENT_HOLD                VARCHAR(10),
  GL_POST_DATE_KEY            INTEGER,
  VENDOR_BILL_DATE_KEY        INTEGER,
  REQUESTER_KEY               INTEGER,
  APPROVER_LEVEL1_KEY         INTEGER,
  APPROVER_LEVEL2_KEY         INTEGER,
  SUBSIDIARY_KEY              INTEGER,
  LOCATION_KEY                INTEGER,
  ITEM_KEY                    INTEGER,
  COST_CENTER_KEY             INTEGER,
  EXCHANGE_RATE               DECIMAL(30,15),
  VENDOR_ADDRESS_LINE_1       VARCHAR(200),
  VENDOR_ADDRESS_LINE_2       VARCHAR(200),
  VENDOR_ADDRESS_LINE_3       VARCHAR(200),
  VENDOR_CITY                 VARCHAR(100),
  VENDOR_COUNTRY              VARCHAR(100),
  VENDOR_STATE                VARCHAR(100),
  VENDOR_ZIP                  VARCHAR(50),
  STATUS                      VARCHAR(100),
  APPROVAL_STATUS             VARCHAR(4000),
  QUANTITY                    DECIMAL(18,8),
  ITEM_GROSS_AMOUNT           DECIMAL(18,8),
  AMOUNT                      DECIMAL(22,2),
  AMOUNT_FOREIGN              DECIMAL(22,2),
  NET_AMOUNT                  DECIMAL(22,2),
  NET_AMOUNT_FOREIGN          DECIMAL(22,2),
  GROSS_AMOUNT                DECIMAL(22,2),
  RATE                        VARCHAR(50),
  CLOSE_DATE_KEY              INTEGER,
  TAX_ITEM_KEY                INTEGER,
  TAX_AMOUNT                  DECIMAL(20,2),
  TAX_AMOUNT_FOREIGN          DECIMAL(22,2),
  VB_TYPE                     VARCHAR(50),
  CURRENCY_KEY                INTEGER,
  CLASS_KEY                   INTEGER,
  MATCH_EXCEPTION             VARCHAR(10),
  EXCEPTION_MESSAGE           VARCHAR(4000),
  CREATION_DATE               TIMESTAMP,
  LAST_MODIFIED_DATE          TIMESTAMP,
  DATE_ACTIVE_FROM            TIMESTAMP,
  DATE_ACTIVE_TO              TIMESTAMP,
  DW_CURRENT                  INTEGER,
  PRIMARY KEY (VB_KEY,VB_NUMBER)
)
DISTSTYLE ALL INTERLEAVED SORTKEY (VB_KEY,VB_NUMBER);