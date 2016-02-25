CREATE SCHEMA if not exists dw_prestage;

DROP TABLE if exists dw_prestage.inventory_snapshot_fact;

CREATE TABLE dw_prestage.inventory_snapshot_fact
(
  RUNID                                  INTEGER,
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
  QUANTITYBACKORDERED QTY_BACKORDERED    DECIMAL(22,0));
