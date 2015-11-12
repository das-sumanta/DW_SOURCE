CREATE SCHEMA if not exists dw;

DROP TABLE if exists dw.vra_fact;

CREATE TABLE dw.vra_fact  
(
  VRA_KEY                      BIGINT IDENTITY(0,1),
  VRA_NUMBER                   VARCHAR(150),
  TRANSACTION_ID               INTEGER,
  TRANSACTION_LINE_ID          INTEGER,
  VENDOR_KEY                   INTEGER,
  REF_TRX_NUMBER                VARCHAR(150),
/*  REF_PO_KEY                   INTEGER,*/
/*  REQUESTER_KEY                INTEGER, */
/*  APPROVER_LEVEL1_KEY          INTEGER, */
  RECEIVE_DATE_KEY             INTEGER,
  CREATE_DATE_KEY              INTEGER,
  SUBSIDIARY_KEY               INTEGER,
  LOCATION_KEY                 INTEGER,
  COST_CENTER_KEY              INTEGER,
  EXCHANGE_RATE                DECIMAL(30,15),
  ITEM_KEY                     INTEGER,
/*  VENDOR_ITEM_KEY              INTEGER, */
  VENDOR_ADDRESS_LINE_1        VARCHAR(150),
  VENDOR_ADDRESS_LINE_2        VARCHAR(150),
  VENDOR_ADDRESS_LINE_3        VARCHAR(150),
  VENDOR_CITY                  VARCHAR(50),
  VENDOR_COUNTRY               VARCHAR(50),
  VENDOR_STATE                 VARCHAR(50),
  VENDOR_ZIP                   VARCHAR(50),
  QUANTITY                     DECIMAL(18,8),
  RATE                         VARCHAR(50),
  AMOUNT                       DECIMAL(20,2),
  QUANTITY_BILLED              DECIMAL(18,8),
  QUANTITY_SHIPPED             DECIMAL(18,8),
  ITEM_GROSS_AMOUNT            DECIMAL(20,2),
  AMOUNT_FOREIGN               DECIMAL(22,2),
  NET_AMOUNT                   DECIMAL(22,2),
  NET_AMOUNT_FOREIGN           DECIMAL(22,2),
  GROSS_AMOUNT                 DECIMAL(22,2),
  MATCH_BILL_TO_RECEIPT        VARCHAR(10),
  TAX_ITEM_KEY                 INTEGER,
  TAX_AMOUNT_FOREIGN           DECIMAL(20,2),
  TAX_AMOUNT                   DECIMAL(20,2),
  CLOSE_DATE_KEY               INTEGER,
  VRA_TYPE                     VARCHAR(50),
  STATUS                       VARCHAR(100),
  APPROVAL_STATUS              VARCHAR(4000),
  CREATION_DATE                TIMESTAMP,
  LAST_MODIFIED_DATE           TIMESTAMP,
  DATE_ACTIVE_FROM             DATE,
  DATE_ACTIVE_TO               DATE,
  DW_CURRENT                   INTEGER,
  CURRENCY_KEY                 INTEGER,
  CLASS_KEY                    INTEGER,
 PRIMARY KEY (VRA_KEY,VRA_NUMBER))
DISTSTYLE ALL INTERLEAVED SORTKEY (VRA_KEY,VRA_NUMBER);

