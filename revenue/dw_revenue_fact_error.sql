CREATE SCHEMA if not exists dw;

DROP TABLE if exists dw.revenue_fact_error;

CREATE TABLE dw.revenue_fact_error 
(
  RUNID                       BIGINT,
  REVENUE_ERROR_KEY           BIGINT IDENTITY(0,1),
  DOCUMENT_NUMBER             VARCHAR(500),
  TRANSACTION_NUMBER          VARCHAR(150),
  TRANSACTION_ID              INTEGER,
  TRANSACTION_LINE_ID         INTEGER,
  REF_DOC_NUMBER              VARCHAR(200),
  REF_DOC_TYPE_KEY            INTEGER,
  TERMS_KEY                   INTEGER,
  REVENUE_COMMITMENT_STATUS   VARCHAR(500),
  REVENUE_STATUS              VARCHAR(500),
  SALES_REP_KEY               INTEGER,
  TERRITORY_KEY               INTEGER,
  BILL_ADDRESS_LINE_1         VARCHAR(500),
  BILL_ADDRESS_LINE_2         VARCHAR(500),
  BILL_ADDRESS_LINE_3         VARCHAR(500),
  BILL_CITY                   VARCHAR(200),
  BILL_COUNTRY                VARCHAR(200),
  BILL_STATE                  VARCHAR(200),
  BILL_ZIP                    VARCHAR(200),
  SHIP_ADDRESS_LINE_1         VARCHAR(500),
  SHIP_ADDRESS_LINE_2         VARCHAR(500),
  SHIP_ADDRESS_LINE_3         VARCHAR(500),
  SHIP_CITY                   VARCHAR(200),
  SHIP_COUNTRY                VARCHAR(200),
  SHIP_STATE                  VARCHAR(200),
  SHIP_ZIP                    VARCHAR(200),
  DOCUMENT_STATUS_KEY         INTEGER,
  DOCUMENT_TYPE_KEY           INTEGER,
  CURRENCY_KEY                INTEGER,
  TRANSACTION_DATE_KEY        INTEGER,
  EXCHANGE_RATE               DECIMAL(30,15),
  ACCOUNT_KEY                 INTEGER,
  AMOUNT                      DECIMAL(20,2),
  AMOUNT_FOREIGN              DECIMAL(22,2),
  GROSS_AMOUNT                DECIMAL(22,2),
  NET_AMOUNT                  DECIMAL(22,2),
  NET_AMOUNT_FOREIGN          DECIMAL(22,2),
  RRP                         DECIMAL(22,2),
  AVG_COST                    DECIMAL(30,15),
  QUANTITY                    DECIMAL(18,8),
  ITEM_KEY                    INTEGER,
  RATE                        VARCHAR(50),
  TAX_ITEM_KEY                INTEGER,
  TAX_AMOUNT                  DECIMAL(20,2),
  LOCATION_KEY                INTEGER,
  CLASS_KEY                   INTEGER,
  SUBSIDIARY_KEY              INTEGER,
  CUSTOMER_KEY                INTEGER,
  ACCOUNTING_PERIOD_KEY       INTEGER,
  REF_CUSTOM_FORM_ID          INTEGER,
  REF_TRANSACTION_TYPE_ERROR  VARCHAR(100),
  CUSTOM_FORM_ID              INTEGER,
  TRANSACTION_TYPE_ERROR      VARCHAR(100),
  PAYMENT_TERMS_ID            INTEGER,
  PAYMENT_TERMS_ID_ERROR      VARCHAR(100),
  SALES_REP_ID                INTEGER,
  SALES_REP_ID_ERROR          VARCHAR(100),
  SALES_TERRITORY_ID          INTEGER,
  TERRITORY_ID_ERROR          VARCHAR(100),
  STATUS                      VARCHAR(500),
  STATUS_ERROR                VARCHAR(100),
  CURRENCY_ID                 INTEGER,
  CURRENCY_ID_ERROR           VARCHAR(100),
  TRANDATE                    TIMESTAMP,
  TRANDATE_ERROR              VARCHAR(100),
  ACCOUNT_ID                  INTEGER,
  ACCOUNT_ID_ERROR            VARCHAR(100),
  ITEM_ID                     INTEGER,
  ITEM_ID_ERROR               VARCHAR(100),
  TAX_ITEM_ID                 INTEGER,
  TAX_ITEM_ID_ERROR           VARCHAR(100),
  LOCATION_ID                 INTEGER,
  LOCATION_ID_ERROR           VARCHAR(100),
  CLASS_ID                    INTEGER,
  CLASS_ID_ERROR              VARCHAR(100),
  SUBSIDIARY_ID               INTEGER,
  SUBSIDIARY_ID_ERROR         VARCHAR(100),
  CUSTOMER_ID                 INTEGER,
  CUSTOMER_ID_ERROR           VARCHAR(100),
  ACCOUNTING_PERIOD_ID        INTEGER,
  ACCOUNTING_PERIOD_ID_ERROR  VARCHAR(100),
  TRANSACTION_TYPE            VARCHAR(200),
  RECORD_STATUS               VARCHAR(50),
  DW_CREATION_DATE            TIMESTAMP,
  PRIMARY KEY (REVENUE_ERROR_KEY)
)
DISTKEY(ITEM_ID) INTERLEAVED SORTKEY (RUNID,RECORD_STATUS,DOCUMENT_TYPE_KEY,DOCUMENT_NUMBER);

COMMIT;
