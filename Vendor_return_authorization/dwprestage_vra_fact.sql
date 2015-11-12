CREATE SCHEMA if not exists dw_prestage;

DROP TABLE if exists dw_prestage.vra_fact;

CREATE TABLE dw_prestage.vra_fact 
(
  RUNID				                 INTEGER,
  TRANSACTION_ID               INTEGER,
  TRANSACTION_LINE_ID          INTEGER,
  VRA_NUMBER                   VARCHAR(200),
  VENDOR_ID                    INTEGER,
  CREATED_FROM_ID              INTEGER,
  CREATED_BY_ID                INTEGER,
  SHIPMENT_RECEIVED_DATE       TIMESTAMP,
  CREATE_DATE                  TIMESTAMP,
  SUBSIDIARY_ID                INTEGER,
  DEPARTMENT_ID                INTEGER,
  ITEM_ID                      INTEGER,
  LOCATION_ID                  INTEGER,
  EXCHANGE_RATE                DECIMAL(30,15),
  VENDOR_ADDRESS_LINE_1        VARCHAR(150),
  BILL_ADDRESS_LINE_2	         VARCHAR(150),
  BILL_ADDRESS_LINE_3	         VARCHAR(150),
  BILL_CITY	                   VARCHAR(50),
  BILL_COUNTRY	               VARCHAR(50),
  BILL_STATE	                 VARCHAR(50),
  BILL_ZIP	                   VARCHAR(50),
  VRA_STATUS                   VARCHAR(1000),
  APPROVAL_STATUS              VARCHAR(4000),
  ITEM_COUNT                   DECIMAL(18,8),
  ITEM_GROSS_AMOUNT            DECIMAL(18,8),
  AMOUNT                       DECIMAL(22,2),
  AMOUNT_FOREIGN               DECIMAL(22,2),
  NET_AMOUNT                   DECIMAL(22,2),
  NET_AMOUNT_FOREIGN           DECIMAL(22,2),
  GROSS_AMOUNT                 DECIMAL(22,2),
  ITEM_UNIT_PRICE              VARCHAR(42),
  QUANTITY_BILLED              DECIMAL(18,8),
  QUANTITY_SHIPPED             DECIMAL(18,8),
  CLOSE_DATE                   TIMESTAMP,
  TAX_ITEM_ID                  INTEGER,
  TRANSACTION_ORDER            INTEGER,
  TAX_AMOUNT                   DECIMAL(20,2),
  TAX_AMOUNT_FOREIGN           DECIMAL(20,2),
  VRA_TYPE                     VARCHAR(100),
  /*REQUESTOR_ID		             INTEGER,*/
  CURRENCY_ID                  INTEGER,
  CUSTOM_FORM_ID               INTEGER,
  DATE_LAST_MODIFIED           TIMESTAMP,
  EMPLOYEE_CUSTOM_ID           INTEGER,
  CLASS_ID                     INTEGER,
  PRIMARY KEY (RUNID,TRANSACTION_ID,TRANSACTION_LINE_ID))
DISTSTYLE ALL INTERLEAVED SORTKEY (RUNID,TRANSACTION_ID,TRANSACTION_LINE_ID);

