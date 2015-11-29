create schema if not exists dw_prestage ;

drop table if exists dw_prestage.carrier;

CREATE TABLE dw_prestage.carrier 
(
  RUNID                 INTEGER,
  CARRIER_ADDRESS       VARCHAR(4000),
  CARRIER_RECORD_ID     INTEGER,
  CARRIER_RECORD_NAME   VARCHAR(999),
  DATE_CREATED          TIMESTAMP,
  IS_INACTIVE           VARCHAR(1),
  LAST_MODIFIED_DATE    TIMESTAMP
);