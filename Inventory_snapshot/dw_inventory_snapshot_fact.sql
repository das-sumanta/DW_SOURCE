CREATE SCHEMA if not exists dw;

DROP TABLE if exists dw.inventory_snapshot_fact;

CREATE TABLE dw.inventory_snapshot_fact
(
  INVENTORY_SNAPSHOT_KEY      BIGINT IDENTITY(0,1),
  SUBSIDIARY_KEY                          INTEGER,
  LOCATION_KEY                            INTEGER,
  ITEM_KEY                                INTEGER,
  AVG_COST                               DECIMAL(30,15),
  QTY_AVAILABLE                          DECIMAL(22),
  QTY_ON_HAND                            DECIMAL(21,11),
  QTY_ON_ORDER                           DECIMAL(21,11),
  QTY_BACKORDERED                        DECIMAL(22),
  DATE_ACTIVE_FROM              DATE,
  DATE_ACTIVE_TO                DATE,
  DW_CURRENT                    INTEGER,
  PRIMARY KEY (INVENTORY_SNAPSHOT_KEY)
)
DISTKEY(ITEM_KEY) INTERLEAVED SORTKEY (SUBSIDIARY_KEY,LOCATION_KEY,ITEM_KEY,DATE_ACTIVE_FROM,DATE_ACTIVE_TO,DW_CURRENT);  
