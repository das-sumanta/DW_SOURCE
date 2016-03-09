CREATE SCHEMA if not exists dw_prestage;

DROP TABLE if exists dw_prestage.item_group;

CREATE TABLE dw_prestage.item_group 
(
  RUNID                INTEGER,                   
  BOM_QUANTITY         DECIMAL(12,5),
  COMPONENT_YIELD      DECIMAL(22,0),
  EFFECTIVE_DATE       TIMESTAMP,
  EFFECTIVE_REVISION   DECIMAL(22,0),
  ITEM_GROUP_ID        INTEGER,
  LINE_ID              INTEGER,
  MEMBER_ID            INTEGER,
  OBSOLETE_DATE        TIMESTAMP,
  OBSOLETE_REVISION    DECIMAL(22,0),
  PARENT_ID            INTEGER,
  QUANTITY             DECIMAL(12,5),
  RATE_PLAN_ID         INTEGER
);

