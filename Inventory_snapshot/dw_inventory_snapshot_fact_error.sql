CREATE SCHEMA if not exists dw;

DROP TABLE if exists dw.inventory_snapshot_fact_error;

CREATE TABLE dw.inventory_snapshot_fact_error 
(
  RUNID                          INTEGER,
  INVENTORY_SNAPSHOT_ERROR_KEY   BIGINT IDENTITY(0,1),
  SUBSIDIARY_ID                  INTEGER,
  SUBSIDIARY_KEY                 INTEGER,
  SUBSIDIARY_ID_ERROR            VARCHAR(100),
  LOCATION_ID                    INTEGER,
  LOCATION_KEY                   INTEGER,
  LOCATION_ID_ERROR              VARCHAR(100),
  ITEM_ID                        INTEGER,
  ITEM_KEY                       INTEGER,
  ITEM_ID_ERROR                  VARCHAR(100),
  AVG_COST                       DECIMAL(30,15),
  QTY_AVAILABLE                  DECIMAL(22),
  QTY_ON_HAND                    DECIMAL(21,11),
  QTY_ON_ORDER                   DECIMAL(21,11),
  QTY_BACKORDERED                DECIMAL(22),
  RECORD_STATUS                  VARCHAR(20),
  DW_CREATION_DATE               TIMESTAMP,
  PRIMARY KEY (INVENTORY_SNAPSHOT_ERROR_KEY)
)
DISTKEY (ITEM_KEY) INTERLEAVED SORTKEY (RECORD_STATUS,INVENTORY_SNAPSHOT_ERROR_KEY);

