CREATE SCHEMA if not exists dw_stage;

DROP TABLE if exists dw_stage.opportunity_fact;

CREATE TABLE dw_stage.opportunity_fact 
(
  RUNID                  INTEGER,
  DOCUMENT_NUMBER        VARCHAR(300),
  TRANSACTION_NUMBER     VARCHAR(300),
  TRANSACTION_ID         INTEGER,
  BOOK_FAIRS_CONSULTANT_ID INTEGER,
  SALES_REP_ID           INTEGER,
  TERRITORY_ID           INTEGER,
  OPEN_DATE              TIMESTAMP,
  SHIP_DATE              TIMESTAMP,
  CLOSE_DATE             TIMESTAMP,
  RETURN_DATE            TIMESTAMP,
  FORECAST_TYPE          VARCHAR(300),
  ABCDO_MARKER_ID        INTEGER,
  BOOK_FAIRS_STATUS_ID   INTEGER,
  BOOK_FAIR_TYPE_ID      INTEGER,
  TRUCK_ROUTE_ID         INTEGER,
  INVOICE_OPTION_ID      INTEGER,
  BILL_ADDRESS_LINE_1    VARCHAR(500),
  BILL_ADDRESS_LINE_2    VARCHAR(500),
  BILL_ADDRESS_LINE_3    VARCHAR(500),
  BILL_CITY              VARCHAR(200),
  BILL_COUNTRY           VARCHAR(200),
  BILL_STATE             VARCHAR(200),
  BILL_ZIP               VARCHAR(200),
  SHIP_ADDRESS_LINE_1    VARCHAR(500),
  SHIP_ADDRESS_LINE_2    VARCHAR(500),
  SHIP_ADDRESS_LINE_3    VARCHAR(500),
  SHIP_CITY              VARCHAR(200),
  SHIP_COUNTRY           VARCHAR(200),
  SHIP_STATE             VARCHAR(200),
  SHIP_ZIP               VARCHAR(200),
  STATUS                 VARCHAR(500),
  CURRENCY_ID            INTEGER,
  TRANDATE               TIMESTAMP,
  EXCHANGE_RATE          DECIMAL(30,15),
  ROLL_SIZE              INTEGER,
  PROJECTED_TOTAL        DECIMAL(20,2),
  WEIGHTED_TOTAL         DECIMAL(20,2),
  LOCATION_ID            INTEGER,
  SUBSIDIARY_ID          INTEGER,
  ACCOUNTING_PERIOD_ID   INTEGER,
  CUSTOMER_ID            INTEGER,
  CLASS_ID               INTEGER,
  CUSTOM_FORM_ID         INTEGER,
  CREATED_BY_ID          INTEGER,
  CREATE_DATE            TIMESTAMP,
  DATE_LAST_MODIFIED     TIMESTAMP,
PRIMARY KEY (RUNID,DOCUMENT_NUMBER,TRANSACTION_ID))
DISTKEY(CUSTOMER_ID) INTERLEAVED SORTKEY (SUBSIDIARY_ID,CUSTOMER_ID,DOCUMENT_NUMBER,TRANSACTION_ID);

