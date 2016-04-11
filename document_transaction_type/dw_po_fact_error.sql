CREATE SCHEMA if not exists dw;

DROP TABLE if exists dw.po_fact_error;

CREATE TABLE dw.po_fact_error 
(
  RUNID                         BIGINT,
  PO_ERROR_KEY                  BIGINT IDENTITY(0,1),
  DOCUMENT_NUMBER               VARCHAR(500),
  PO_NUMBER                     VARCHAR(150),
  PO_ID                        INTEGER,         
  PO_LINE_ID                   INTEGER,        
  REF_TRX_NUMBER               VARCHAR(200),   
  REF_TRX_TYPE_KEY             INTEGER,   
  VENDOR_KEY                    INTEGER,
  REQUESTER_KEY                 INTEGER,
  APPROVER_LEVEL1_KEY           INTEGER,
  APPROVER_LEVEL2_KEY           INTEGER,
  CREATE_DATE_KEY               INTEGER,
  TRANSACTION_DATE_KEY          INTEGER,
  SUBSIDIARY_KEY                INTEGER,
  LOCATION_KEY                  INTEGER,
  COST_CENTER_KEY               INTEGER,
  EXCHANGE_RATE                 DECIMAL(30,15),
  ITEM_KEY                      INTEGER,
  BILL_ADDRESS_LINE_1          VARCHAR(500),      
  BILL_ADDRESS_LINE_2          VARCHAR(500),      
  BILL_ADDRESS_LINE_3          VARCHAR(500),      
  BILL_CITY                    VARCHAR(200),      
  BILL_COUNTRY                 VARCHAR(200),    
  BILL_STATE                   VARCHAR(200),      
  BILL_ZIP                     VARCHAR(200),     
  SHIP_ADDRESS_LINE_1          VARCHAR(500),      
  SHIP_ADDRESS_LINE_2          VARCHAR(500),       
  SHIP_ADDRESS_LINE_3          VARCHAR(500),     
  SHIP_CITY                    VARCHAR(200),      
  SHIP_COUNTRY                 VARCHAR(200),    
  SHIP_STATE                   VARCHAR(200),     
  SHIP_ZIP                     VARCHAR(200),    
  QUANTITY                      DECIMAL(18,8),
  BIH_QUANTITY                  DECIMAL(22),
  BC_QUANTITY                   DECIMAL(22),
  TRADE_QUANTITY                DECIMAL(22),
  NZSO_QUANTITY                 DECIMAL(22),
  EDUCATION_QUANTITY            DECIMAL(22),
  SCHOOL_ESSENTIALS_QUANTITY    DECIMAL(22),
  BOOK_FAIR_QUANTITY            DECIMAL(22),
  NUMBER_BILLED                DECIMAL(18,8),         
  QUANTITY_RECEIVED_IN_SHIPMENT DECIMAL(18,8),        
  QUANTITY_RETURNED            DECIMAL(22,8),         
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
  TERMS_KEY                     INTEGER,
  PO_TYPE_KEY                   INTEGER,
  PO_STATUS_KEY                 INTEGER,
  PO_STATUS_ERROR               VARCHAR(100),
  APPROVAL_STATUS               VARCHAR(4000),
  CREATION_DATE                 TIMESTAMP,
  LAST_MODIFIED_DATE            TIMESTAMP,
  CURRENCY_KEY                  INTEGER,
  CLASS_KEY                     INTEGER,
  CARRIER_KEY                   INTEGER,       
  CARRIER_ID                    INTEGER,      
  CARRIER_ID_ERROR              VARCHAR(100),    
  VENDOR_ID                     INTEGER,
  VENDOR_ID_ERROR               VARCHAR(100),
  REQUESTER_ID                  INTEGER,
  REQUESTER_ID_ERROR            VARCHAR(100),
  APPROVER_LEVEL1_ID            INTEGER,
  APPROVER_LEVEL1_ID_ERROR      VARCHAR(100),
  APPROVER_LEVEL2_ID            INTEGER,
  APPROVER_LEVEL2_ID_ERROR      VARCHAR(100),
  CREATE_DATE_ERROR             VARCHAR(100),
  SUBSIDIARY_ID                 INTEGER,
  SUBSIDIARY_ID_ERROR           VARCHAR(100),
  LOCATION_ID                   INTEGER,
  LOCATION_ID_ERROR             VARCHAR(100),
  COST_CENTER_ID                INTEGER,
  COST_CENTER_ID_ERROR          VARCHAR(100),
  ITEM_ID                       INTEGER,
  ITEM_ID_ERROR                 VARCHAR(100),
  TAX_ITEM_ID                   INTEGER,
  TAX_ITEM_ID_ERROR             VARCHAR(100),
  REQUESTED_RECEIPT_DATE        TIMESTAMP,
  REQUESTED_RECEIPT_DATE_ERROR  VARCHAR(100),
  ACTUAL_DELIVERY_DATE          TIMESTAMP,
  ACTUAL_DELIVERY_DATE_ERROR    VARCHAR(100),
  FREIGHT_ESTIMATE_METHOD_ID    INTEGER,
  FREIGHT_ESTIMATE_METHOD_ID_ERROR VARCHAR(100),
  TERMS_ID                      INTEGER,
  TERMS_ID_ERROR                VARCHAR(100),      
  CURRENCY_ID                   INTEGER,
  CURRENCY_ID_ERROR             VARCHAR(100),      
  CLASS_ID                      INTEGER,
  CLASS_ID_ERROR                VARCHAR(100),      
  CUSTOM_FORM_ID                INTEGER,
  PO_TYPE_ERROR                 VARCHAR(100),
  REF_CUSTOM_FORM_ID            INTEGER,
  REF_TRX_TYPE_ERROR            VARCHAR(100),
  TRANDATE                      TIMESTAMP,
  TRANDATE_ERROR                VARCHAR(100),
  PO_STATUS                     VARCHAR(1000),
  RECORD_STATUS                 VARCHAR,
  DW_CREATION_DATE              TIMESTAMP,
  PRIMARY KEY (PO_ERROR_KEY)
)
DISTKEY(ITEM_ID) INTERLEAVED SORTKEY (RUNID,RECORD_STATUS,PO_NUMBER);