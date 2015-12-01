CREATE SCHEMA if not exists dw_prestage;

DROP TABLE if exists dw_prestage.po_fact;

CREATE TABLE dw_prestage.po_fact 
(
  RUNID				                 INTEGER,
  TRANSACTION_ID               INTEGER,
  PO_NUMBER                    VARCHAR(200),
  TRANSACTION_LINE_ID          INTEGER,
  REF_TRX_NUMBER               VARCHAR(200),      /* ADDD */
  REF_TRX_TYPE                 VARCHAR(200),      /* ADDD */
  VENDOR_ID                    INTEGER,
  APPROVER_LEVEL_ONE_ID        INTEGER,
  APPROVER_LEVEL_TWO_ID        INTEGER,
  AMOUNT_UNBILLED              DECIMAL(20,2),
  APPROVAL_STATUS              VARCHAR(4000), 
  BILL_ADDRESS_LINE_1          VARCHAR(500),       /* ADDD */
  BILL_ADDRESS_LINE_2          VARCHAR(500),       /* ADDD */
  BILL_ADDRESS_LINE_3          VARCHAR(500),       /* ADDD */
  BILL_CITY                    VARCHAR(200),       /* ADDD */
  BILL_COUNTRY                 VARCHAR(200),       /* ADDD */
  BILL_STATE                   VARCHAR(200),       /* ADDD */
  BILL_ZIP                     VARCHAR(200),       /* ADDD */
/*  CARRIER                      VARCHAR(500),*/   /* REMOVED */
/*  CARRIER_ADDRESS              VARCHAR(4000),*/  /* REMOVED */
/*  CARRIER_LEBEL_ID             INTEGER, */       /* REMOVED */
  CARRIER_ID                   INTEGER,            /* ADDD */
  CLOSED                       TIMESTAMP,
  CREATED_BY_ID                INTEGER,
  REQUESTOR_ID		             INTEGER,
  CREATED_FROM_ID              INTEGER,
  CREATE_DATE                  TIMESTAMP,
  CURRENCY_ID                  INTEGER,
  CUSTOM_FORM_ID               INTEGER,
  DATE_LAST_MODIFIED           TIMESTAMP,
  EMPLOYEE_CUSTOM_ID           INTEGER,
  EXCHANGE_RATE                DECIMAL(30,15),
  LOCATION_ID                  INTEGER,
  PO_APPROVER_ID               INTEGER,
  SHIP_ADDRESS_LINE_1          VARCHAR(500),       /* ADDD */     
  SHIP_ADDRESS_LINE_2          VARCHAR(500),       /* ADDD */     
  SHIP_ADDRESS_LINE_3          VARCHAR(500),       /* ADDD */    
  SHIP_CITY                    VARCHAR(200),       /* ADDD */     
  SHIP_COUNTRY                 VARCHAR(200),       /* ADDD */     
  SHIP_STATE                   VARCHAR(200),       /* ADDD */    
  SHIP_ZIP                     VARCHAR(200),       /* ADDD */    
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
  NUMBER_BILLED                DECIMAL(18,8),           /* ADDD */
  QUANTITY_RECEIVED_IN_SHIPMENT DECIMAL(18,8),          /* ADDD */
  QUANTITY_RETURNED            DECIMAL(22,8),           /* ADDD */
  EXPECTED_RECEIPT_DATE        TIMESTAMP,
  ACTUAL_DELIVERY_DATE         TIMESTAMP,
  TAX_ITEM_ID                  INTEGER,
  TAX_TYPE                     VARCHAR(100),
  TAX_AMOUNT                   DECIMAL(20,2),
  FREIGHT_ESTIMATE_METHOD_ID   INTEGER,
  LINE_TYPE                    VARCHAR(500),
  CLASS_ID                     INTEGER,
  PRIMARY KEY (RUNID,TRANSACTION_ID,TRANSACTION_LINE_ID))
DISTSTYLE ALL INTERLEAVED SORTKEY (RUNID,TRANSACTION_ID,TRANSACTION_LINE_ID);

