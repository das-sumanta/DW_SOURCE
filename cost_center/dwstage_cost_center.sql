CREATE SCHEMA if not exists dw_stage;

DROP TABLE if exists dw_stage.cost_center;

CREATE TABLE dw_stage.cost_center 
(
  ACCPAC_COST_CENTER_CODES     VARCHAR(4000),
  COST_CENTER_CODE             VARCHAR(4000),
  DATE_LAST_MODIFIED           TIMESTAMP,
  DEPARTMENT_EXTID             VARCHAR(255),
  DEPARTMENT_ID                INTEGER,
  FULL_NAME                    VARCHAR(1791),
  HYPERION_COST_CENTER_CODES   VARCHAR(4000),
  ISINACTIVE                   VARCHAR(3),
  NAME                         VARCHAR(31),
  PARENT_ID                    INTEGER
);


