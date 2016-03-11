CREATE SCHEMA if not exists dw_stage;

DROP TABLE if exists dw_stage.inventory_snapshot_fact;

CREATE TABLE dw_stage.inventory_snapshot_fact
(
  RUNID                                  INTEGER,
  SUBSIDIARY_ID                          INTEGER,
  LOCATION_ID                            INTEGER,
  ITEM_ID                                INTEGER,
  AVG_COST                               DECIMAL(30,15),
  QTY_AVAILABLE                          DECIMAL(22),
  QTY_ON_HAND                            DECIMAL(21,11),
  QTY_ON_ORDER                           DECIMAL(21,11),
  QTY_BACKORDERED                        DECIMAL(22),
  PRIMARY KEY (SUBSIDIARY_ID,LOCATION_ID,ITEM_ID)
)
DISTKEY(ITEM_ID) INTERLEAVED SORTKEY (SUBSIDIARY_ID,LOCATION_ID,ITEM_ID);
