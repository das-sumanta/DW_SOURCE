CREATE SCHEMA if not exists dw;

DROP TABLE if exists dw.po_fact;

CREATE TABLE dw.po_fact 
(
  PO_KEY                        BIGINT IDENTITY(0,1),
  PO_NUMBER                    VARCHAR(150),
  VENDOR_KEY                    INTEGER,
  REQUESTER_KEY                 INTEGER,
  APPROVER_LEVEL1_KEY           INTEGER,
  APPROVER_LEVEL2_KEY           INTEGER,
  RECEIVE_DATE_KEY              INTEGER,
  CREATE_DATE_KEY               INTEGER,
  SUBSIDIARY_KEY                INTEGER,
  LOCATION_KEY                  INTEGER,
  COST_CENTER_KEY               INTEGER,
  EXCHANGE_RATE                 DECIMAL(30,15),
  ITEM_KEY                      INTEGER,
  VENDOR_ITEM_KEY               INTEGER,
  BILLADDRESS                   VARCHAR(1000),
  SHIPADDRESS                   VARCHAR(1000),
  QUANTITY                      DECIMAL(18,8),
  BIH_QUANTITY                  DECIMAL(22),
  BC_QUANTITY                   DECIMAL(22),
  TRADE_QUANTITY                DECIMAL(22),
  NZSO_QUANTITY                 DECIMAL(22),
  EDUCATION_QUANTITY            DECIMAL(22),
  SCHOOL_ESSENTIALS_QUANTITY    DECIMAL(22),
  BOOK_FAIR_QUANTITY            DECIMAL(22),
  RATE                          VARCHAR(50),
  AMOUNT                        DECIMAL(20,2),
  ITEM_GROSS_AMOUNT             DECIMAL(20,2),
  AMOUNT_FOREIGN                DECIMAL(22,2),
  NET_AMOUNT                    DECIMAL(22,2),
  NET_AMOUNT_FOREIGN            DECIMAL(22,2),
  GROSS_AMOUNT                  DECIMAL(22,2),
  MATCH_BILL_TO_RECEIPT         VARCHAR(10),
  TRACK_LANDED_COST             VARCHAR(10),
  TAX_ITEM_KEY                  INTEGER,
  TAX_AMOUNT                    DECIMAL(20,2),
  REQUESTED_RECEIPT_DATE_KEY    INTEGER,
  ACTUAL_DELIVERY_DATE_KEY      INTEGER,
  FREIGHT_ESTIMATE_METHOD_KEY   INTEGER,
  FREIGHT_RATE                  DECIMAL(22),
  CARRIER_KEY                   INTEGER,
  TERMS_KEY                     INTEGER,
  PO_TYPE                       VARCHAR(50),
  STATUS                        VARCHAR(100),
  APPROVAL_STATUS               VARCHAR(4000),
  CREATION_DATE                 TIMESTAMP,
  LAST_MODIFIED_DATE            TIMESTAMP,
  DATE_ACTIVE_FROM              DATE,
  DATE_ACTIVE_TO             DATE,
  ACTIVE                        VARCHAR(10),
  CURRENCY_KEY                  INTEGER,
  PRIMARY KEY (PO_KEY,PO_NUMBER))
DISTSTYLE ALL INTERLEAVED SORTKEY (PO_KEY,PO_NUMBER);

