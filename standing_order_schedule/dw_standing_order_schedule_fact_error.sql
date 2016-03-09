CREATE SCHEMA if not exists dw;

DROP TABLE if exists dw.standing_order_schedule_fact_error;

CREATE TABLE dw.standing_order_schedule_fact_error 
(
  RUNID                               INTEGER,
  STANDING_ORDER_SCHEDULE_ERROR_KEY   BIGINT IDENTITY(0,1),
  STANDING_ORDER_SCHEDULE_ID          INTEGER,
  ACTUAL_SHIPMENT_DATE                TIMESTAMP,
  ACTUAL_SHIPMENT_DATE_KEY            INTEGER,
  ACTUAL_SHIPMENT_DATE_ERROR          VARCHAR(100),
  AMORTIZATION_VALUE_EXCL_GST         DECIMAL(22,8),
  AMORTIZATION_VALUE_INCL_GST         DECIMAL(22,8),
  CUSTOMER_ID                         INTEGER,
  CUSTOMER_KEY                        INTEGER,
  CUSTOMER_ID_ERROR                   VARCHAR(100),
  EXPECTED_SHIPMENT_DATE              TIMESTAMP,
  EXPECTED_SHIPMENT_DATE_KEY          INTEGER,
  EXPECTED_SHIPMENT_DATE_ERROR        VARCHAR(100),
  INVOICE_AMOUNT                      DECIMAL(22,2),
  INVOICE_NO_ID                       INTEGER,
  IS_INACTIVE                         VARCHAR(10),
  LINE_NO                             DECIMAL(22,0),
  ORDER_TYPE                          VARCHAR(1000),
  PICK_SLIP_NUMBER                    DECIMAL(22,0),
  PRODUCT_CATALOGUE_ID                INTEGER,
  PRODUCT_CATALOGUE_KEY               INTEGER,
  PRODUCT_CATALOGUE_ID_ERROR          VARCHAR(100),
  SALES_ORDER_NO_ID                   INTEGER,
  SCHEDULE_CLOSED                     VARCHAR(10),
  SHIPMENT_NO                         DECIMAL(22,0),
  SHIPMENT_YYYYMM                     VARCHAR(4000),
  STO_ITEM_ID                         INTEGER,
  STO_ITEM_KEY                        INTEGER,
  STO_ITEM_ID_ERROR                   VARCHAR(100),
  STO_NO_TEXT                         VARCHAR(4000),
  STO_NO_ID                           INTEGER,
  SUBSIDIARY_ID                       INTEGER,
  SUBSIDIARY_KEY                      INTEGER,
  SUBSIDIARY_ID_ERROR                 VARCHAR(100),
  RECORD_STATUS                       VARCHAR(20),
  DW_CREATION_DATE                    TIMESTAMP,
  PRIMARY KEY (STANDING_ORDER_SCHEDULE_ERROR_KEY)
)
DISTKEY (PRODUCT_CATALOGUE_ID) INTERLEAVED SORTKEY (RECORD_STATUS,STANDING_ORDER_SCHEDULE_ERROR_KEY);

