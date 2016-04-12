CREATE SCHEMA if not exists dw_stage;

DROP TABLE if exists dw_stage.po_fact;

CREATE TABLE dw_stage.po_fact  
(
  RUNID                        INTEGER,
  DOCUMENT_NUMBER              VARCHAR(500),
  TRANSACTION_ID               INTEGER,
  PO_NUMBER                    VARCHAR(200),
  TRANSACTION_LINE_ID          INTEGER,
  REF_TRX_NUMBER               VARCHAR(200),     
  REF_CUSTOM_FORM_ID           INTEGER,        
  VENDOR_ID                    INTEGER,
  APPROVER_LEVEL_ONE_ID        INTEGER,
  APPROVER_LEVEL_TWO_ID        INTEGER,
  AMOUNT_UNBILLED              DECIMAL(20,2),
  APPROVAL_STATUS              VARCHAR(4000),
  BILL_ADDRESS_LINE_1          VARCHAR(500),      
  BILL_ADDRESS_LINE_2          VARCHAR(500),      
  BILL_ADDRESS_LINE_3          VARCHAR(500),       
  BILL_CITY                    VARCHAR(200),      
  BILL_COUNTRY                 VARCHAR(200),      
  BILL_STATE                   VARCHAR(200),       
  BILL_ZIP                     VARCHAR(200),      
  CARRIER_ID                   INTEGER,           
  CLOSED                       TIMESTAMP,
  CREATED_BY_ID                INTEGER,
  REQUESTOR_ID		           INTEGER,
  CREATED_FROM_ID              INTEGER,
  CREATE_DATE                  TIMESTAMP,
  TRANDATE                     TIMESTAMP,
  CURRENCY_ID                  INTEGER,
  CUSTOM_FORM_ID               INTEGER,
  DATE_LAST_MODIFIED           TIMESTAMP,
  EMPLOYEE_CUSTOM_ID           INTEGER,
  EXCHANGE_RATE                DECIMAL(30,15),
  LOCATION_ID                  INTEGER,
  PO_APPROVER_ID               INTEGER,
  SHIP_ADDRESS_LINE_1          VARCHAR(500),           
  SHIP_ADDRESS_LINE_2          VARCHAR(500),          
  SHIP_ADDRESS_LINE_3          VARCHAR(500),          
  SHIP_CITY                    VARCHAR(200),       
  SHIP_COUNTRY                 VARCHAR(200),      
  SHIP_STATE                   VARCHAR(200),       
  SHIP_ZIP                     VARCHAR(200),       
  SHIPMENT_RECEIVED            TIMESTAMP,
  PO_STATUS                    VARCHAR(1000),
  PAYMENT_TERMS_ID             INTEGER,
  FRIGHT_RATE                  DECIMAL(22,0),
  PO_TYPE                      VARCHAR(4000),
  SUBSIDIARY_ID                INTEGER,
  DEPARTMENT_ID                INTEGER,
  ITEM_ID                      INTEGER,
  BC_QUANTITY                  DECIMAL(22,0),                        
  BIH_QUANTITY                 DECIMAL(22,0),                           
  BOOK_FAIR_QUANTITY           DECIMAL(22,0),                           
  EDUCATION_QUANTITY           DECIMAL(22,0),                      
  NZSO_QUANTITY                DECIMAL(22,0),                       
  TRADE_QUANTITY               DECIMAL(22,0),                       
  SCHOOL_ESSENTIALS_QUANTITY   DECIMAL(22,0),          
  ITEM_COUNT                   DECIMAL(18,8),
  ITEM_GROSS_AMOUNT            DECIMAL(18,8),
  AMOUNT                       DECIMAL(22,2),
  AMOUNT_FOREIGN               DECIMAL(22,2),
  NET_AMOUNT                   DECIMAL(22,2),
  NET_AMOUNT_FOREIGN           DECIMAL(22,2),
  GROSS_AMOUNT                 DECIMAL(22,2),
  MATCH_BILL_TO_RECEIPT        VARCHAR(1),
  TRACK_LANDED_COST            VARCHAR(1),
  ITEM_UNIT_PRICE              VARCHAR(42),
  NUMBER_BILLED                DECIMAL(18,8),          
  QUANTITY_RECEIVED_IN_SHIPMENT DECIMAL(18,8),        
  QUANTITY_RETURNED            DECIMAL(22,8),          
  EXPECTED_RECEIPT_DATE        TIMESTAMP,
  ACTUAL_DELIVERY_DATE         TIMESTAMP,
  TAX_ITEM_ID                  INTEGER,
  TAX_TYPE                     VARCHAR(100),
  TAX_AMOUNT                   DECIMAL(20,2),
  FREIGHT_ESTIMATE_METHOD_ID   INTEGER,
  LINE_TYPE                    VARCHAR(500),
  CLASS_ID                      INTEGER,
  PRIMARY KEY (RUNID,SUBSIDIARY_ID,TRANSACTION_ID,TRANSACTION_LINE_ID))
DISTKEY(ITEM_ID) INTERLEAVED SORTKEY (RUNID,SUBSIDIARY_ID,TRANSACTION_ID,TRANSACTION_LINE_ID);