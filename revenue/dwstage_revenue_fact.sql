CREATE SCHEMA if not exists dw_stage;

DROP TABLE if exists dw_stage.revenue_fact;

CREATE TABLE dw_stage.revenue_fact 
(
  RUNID                       INTEGER,
  TRANSACTION_NUMBER          VARCHAR(150),
  TRANSACTION_ID              INTEGER,
  TRANSACTION_LINE_ID         INTEGER,
  TRANSACTION_ORDER           INTEGER,
  REF_DOC_NUMBER              VARCHAR(200),
  REF_CUSTOM_FORM_ID          INTEGER,
  PAYMENT_TERMS_ID            INTEGER,
  REVENUE_COMMITMENT_STATUS   VARCHAR(500),
  REVENUE_STATUS              VARCHAR(500),
  SALES_REP_ID                INTEGER,
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
  STATUS                      VARCHAR(500),
  TRANSACTION_TYPE            VARCHAR(200),
  CURRENCY_ID                 INTEGER,
  TRANDATE                    TIMESTAMP,
  EXCHANGE_RATE               DECIMAL(30,15),
  ACCOUNT_ID                  INTEGER,
  AMOUNT                      DECIMAL(20,2),
  AMOUNT_FOREIGN              DECIMAL(22,2),
  GROSS_AMOUNT                DECIMAL(22,2),
  NET_AMOUNT                  DECIMAL(22,2),
  NET_AMOUNT_FOREIGN          DECIMAL(22,2),
  QUANTITY                    DECIMAL(18,8),
  ITEM_ID                     INTEGER,
  ITEM_UNIT_PRICE             VARCHAR(42),
  TAX_ITEM_ID                 INTEGER,
  TAX_AMOUNT                  DECIMAL(20,2),
  LOCATION_ID                 INTEGER,
  CLASS_ID                    INTEGER,
  SUBSIDIARY_ID               INTEGER,
  ACCOUNTING_PERIOD_ID        INTEGER,
  CUSTOMER_ID                 INTEGER,
  TRX_TYPE                    VARCHAR(50),
  CUSTOM_FORM_ID              INTEGER,
  CREATED_BY_ID               INTEGER,
  CREATE_DATE                 TIMESTAMP,
  PRICE_TYPE_ID               INTEGER,
  DATE_LAST_MODIFIED          TIMESTAMP,
  PRIMARY KEY (RUNID,TRANSACTION_ID,TRANSACTION_LINE_ID)
)
DISTSTYLE ALL INTERLEAVED SORTKEY (RUNID,TRANSACTION_ID,TRANSACTION_LINE_ID);