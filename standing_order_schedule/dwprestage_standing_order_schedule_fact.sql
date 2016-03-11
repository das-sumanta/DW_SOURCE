CREATE SCHEMA if not exists dw_prestage;

DROP TABLE if exists dw_prestage.standing_order_schedule_fact;

CREATE TABLE dw_prestage.standing_order_schedule_fact 
(
  RUNID                          INTEGER, 
  STANDING_ORDER_SCHEDULE_ID     INTEGER,                      
  ACTUAL_SHIPMENT_DATE           TIMESTAMP,
  AMORTIZATION_VALUE_EXCL__GST   DECIMAL(22,8),
  AMORTIZATION_VALUE_INCL__GST   DECIMAL(22,8),
  CUSTOMER_ID                    INTEGER,
  DATE_CREATED                   TIMESTAMP,
  EXPECTED_SHIPMENT_DATE         TIMESTAMP,
  INVOICE_AMOUNT                 DECIMAL(22,2),
  INVOICE_NO__ID                 INTEGER,
  IS_INACTIVE                    VARCHAR(1),
  LAST_MODIFIED_DATE             TIMESTAMP,
  LEVEL_ID                       INTEGER,
  LINE_NO                        DECIMAL(22,0),
  ORDER_TYPE_ID                  INTEGER,
  ORDER_TYPE                     VARCHAR(1000),
  PICK_SLIP_NUMBER               DECIMAL(22,0),
  PRODUCT_CATALOGUE_LIST_ID      INTEGER,
  SALES_ORDER_NO__ID             INTEGER,
  SCHEDULE_CLOSED                VARCHAR(1),
  SHIPMENT_NO_                   DECIMAL(22,0),
  SHIPMENT_YYYYMM                VARCHAR(4000),
  STO_ITEM_ID                    INTEGER,
  STO_NO_TEXT                    VARCHAR(4000),
  STO_NO__ID                     INTEGER,
  SUBSIDIARY_ID                  INTEGER,
  STO_START_DATE                 TIMESTAMP,
  STO_END_DATE                   TIMESTAMP)
;

