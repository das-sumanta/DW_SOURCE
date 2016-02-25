CREATE SCHEMA if not exists dw_stage;

DROP TABLE if exists dw_stage.inventory_snapshot_fact;

CREATE TABLE dw_stage.inventory_snapshot_fact
(
  PRODUCT_CATALOGUE_ID                   INTEGER,
  CLASS_ID                               INTEGER,
  SUBSIDIARY_ID                          INTEGER,
  LOCATION_ID                            INTEGER,
  PUBLISHER_ID                           INTEGER,
  PARENT_ID                              INTEGER,
  COMPONENT_ID                           INTEGER, 
  PREPACK_QTY                            DECIMAL(12,5),
  ON_HAND_COUNT QTY_ON_HAND              DECIMAL(21,11),
  ON_ORDER_COUNT QTY_ON_ORDER            DECIMAL(21,11),
  QUANTITYBACKORDERED QTY_BACKORDERED    DECIMAL(22,0)
  PRIMARY KEY (SUBSIDIARY_ID,CLASS_ID,LOCATION_ID,PRODUCT_CATALOGUE_ID,PARENT_ID,COMPONENT_ID)
)
DISTKEY(PARENT_ID) INTERLEAVED SORTKEY (SUBSIDIARY_ID,CLASS_ID,LOCATION_ID,PRODUCT_CATALOGUE_ID,PARENT_ID,COMPONENT_ID);
