CREATE SCHEMA if not exists dw;

DROP TABLE if exists dw.inventory_snapshot_fact;

CREATE TABLE dw.inventory_snapshot_fact; 
(
  INVENTORY_SNAPSHOT_KEY      BIGINT IDENTITY(0,1),
  PRODUCT_CATALOGUE_KEY                   INTEGER,
  CLASS_KEY                               INTEGER,
  SUBSIDIARY_KEY                          INTEGER,
  LOCATION_KEY                            INTEGER,
  PUBLISHER_KEY                           INTEGER,
  PARENT_KEY                              INTEGER,
  COMPONENT_KEY                           INTEGER, 
  PREPACK_QTY                            DECIMAL(12,5),
  ON_HAND_COUNT QTY_ON_HAND              DECIMAL(21,11),
  ON_ORDER_COUNT QTY_ON_ORDER            DECIMAL(21,11),
  QUANTITYBACKORDERED QTY_BACKORDERED    DECIMAL(22,0)
  SNAPSHOT_DATE_KEY           INTEGER
)
DISTKEY(ITEM_KEY) INTERLEAVED SORTKEY (TRANSACTION_DATE_KEY,SUBSIDIARY_KEY,DOCUMENT_TYPE_KEY,DOCUMENT_NUMBER,TRANSACTION_ID,TRANSACTION_LINE_ID,DW_CURRENT);  

commit;
