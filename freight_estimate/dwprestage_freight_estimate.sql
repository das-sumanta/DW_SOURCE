CREATE SCHEMA if not exists dw_prestage;

DROP TABLE if exists dw_prestage.freight_estimate;

CREATE TABLE dw_prestage.freight_estimate 
(
    RUNID                  INTEGER,
  LANDED_COST_RULE_MATRIX_NZ_ID    INTEGER,
  LANDED_COST_RULE_MATRIX_NZ_NAM   VARCHAR(999),
  DESCRIPTION                      VARCHAR(4000),
  IS_INACTIVE                      VARCHAR(1),
  PERCENT_OF_COST                  DECIMAL(22,0),
  PLUS_AMOUNT                      DECIMAL(22,8),
  SUBSIDIARY_ID                    INTEGER,
  SUBSIDIARY					   VARCHAR(100),
  DATE_CREATED                     TIMESTAMP,
  LAST_MODIFIED_DATE               TIMESTAMP,
  PRIMARY KEY ( LANDED_COST_RULE_MATRIX_NZ_ID ) )
DISTSTYLE ALL
INTERLEAVED SORTKEY (LANDED_COST_RULE_MATRIX_NZ_ID);

