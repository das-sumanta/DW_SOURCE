create schema if not exists dw_stage ;

drop table if exists dw_stage.carrier;

CREATE TABLE dw_stage.carrier 
(
  CARRIER_ADDRESS       VARCHAR(4000),
  CARRIER_RECORD_ID     INTEGER,
  CARRIER_RECORD_NAME   VARCHAR(999),
  DATE_CREATED          TIMESTAMP,
  IS_INACTIVE           VARCHAR(1),
  DATE_LAST_MODIFIED    TIMESTAMP
);