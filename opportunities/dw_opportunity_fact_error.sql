CREATE SCHEMA if not exists dw;

DROP TABLE if exists dw.opportunity_fact_error;

CREATE TABLE dw.opportunity_fact_error 
(
  RUNID                    INTEGER,
  OPPORTUNITY_ERROR_KEY    BIGINT IDENTITY(0,1),
  DOCUMENT_NUMBER          VARCHAR(300),
  TRANSACTION_NUMBER       VARCHAR(300),
  TRANSACTION_ID           INTEGER,
  ACCOUNTING_PERIOD_KEY    INTEGER,
  TERRITORY_KEY            INTEGER,
  SALES_REP_KEY            INTEGER,
  BOOK_FAIRS_KEY           INTEGER,
  BILL_ADDRESS_LINE_1      VARCHAR(500),
  BILL_ADDRESS_LINE_2      VARCHAR(500),
  BILL_ADDRESS_LINE_3      VARCHAR(500),
  BILL_CITY                VARCHAR(200),
  BILL_COUNTRY             VARCHAR(200),
  BILL_STATE               VARCHAR(200),
  BILL_ZIP                 VARCHAR(200),
  SHIP_ADDRESS_LINE_1      VARCHAR(500),
  SHIP_ADDRESS_LINE_2      VARCHAR(500),
  SHIP_ADDRESS_LINE_3      VARCHAR(500),
  SHIP_CITY                VARCHAR(200),
  SHIP_COUNTRY             VARCHAR(200),
  SHIP_STATE               VARCHAR(200),
  SHIP_ZIP                 VARCHAR(200),
  OPPORTUNITY_STATUS_KEY   VARCHAR(500),
  OPPORTUNITY_TYPE_KEY     VARCHAR(50),
  FORECAST_TYPE            VARCHAR(300),
  CURRENCY_KEY             INTEGER,
  TRANSACTION_DATE_KEY     INTEGER,
  OPEN_DATE_KEY            INTEGER,
  SHIP_DATE_KEY            INTEGER,
  CLOSE_DATE_KEY           INTEGER,
  RETURN_DATE_KEY          INTEGER,
  EXCHANGE_RATE            DECIMAL(30,15),
  ROLL_SIZE                INTEGER,
  PROJECTED_TOTAL          DECIMAL(20,2),
  WEIGHTED_TOTAL           INTEGER,
  AMOUNT                   DECIMAL(20,2),
  LOCATION_KEY             INTEGER,
  CLASS_KEY                INTEGER,
  SUBSIDIARY_KEY           INTEGER,
  CUSTOMER_KEY             INTEGER,
  LAST_MODIFIED_DATE       TIMESTAMP,
  SALES_REP_ID             INTEGER,
  TERRITORY_ID             INTEGER,
  OPEN_DATE                TIMESTAMP,
  SHIP_DATE                TIMESTAMP,
  CLOSE_DATE               TIMESTAMP,
  RETURN_DATE              TIMESTAMP,
  ACCOUNTING_PERIOD_ID     INTEGER,
  ABCDO_MARKER_ID          INTEGER,
  BOOK_FAIRS_STATUS_ID     INTEGER,
  BOOK_FAIR_TYPE_ID        INTEGER,
  TRUCK_ROUTE_ID           INTEGER,
  STATUS                   VARCHAR(500),
  CUSTOM_FORM_ID           INTEGER,
  CURRENCY_ID              INTEGER,
  TRANDATE                 TIMESTAMP,
  LOCATION_ID              INTEGER,
  CUSTOMER_ID              INTEGER,
  RECORD_STATUS            VARCHAR(20),
  DW_CREATION_DATE         TIMESTAMP,
  PRIMARY KEY (OPPORTUNITY_ERROR_KEY,DOCUMENT_NUMBER)
)
DISTSTYLE ALL INTERLEAVED SORTKEY (OPPORTUNITY_ERROR_KEY,DOCUMENT_NUMBER);
