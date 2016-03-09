CREATE SCHEMA if not exists dw;

DROP TABLE if exists dw.amortization_fact_error;

CREATE TABLE dw.amortization_fact_error 
( 
  RUNID                            INTEGER,
  AMORTIZATION_ERROR_KEY           BIGINT IDENTITY(0,1), 
  AMORTIZATION_PER_ISSUELEVE_ID    INTEGER,
  AMORTIZE_VALUE_PER_ISSUE_EXCL    DECIMAL(22,8),
  AMORTIZE_VALUE_PER_ISSUE_INCL    DECIMAL(22,8),
  COMPONENTS_ID                    INTEGER,
  COMPONENTS_KEY                   INTEGER,
  COMPONENTS_ID_ERROR              VARCHAR(1000),
  DISCOUNTED_AMOUNT                DECIMAL(22,8),
  DISCOUNTED_PRICE                 DECIMAL(22,8),
  IS_INACTIVE                      VARCHAR(1),
  LAST_SS_YYYYMM                   DECIMAL(22,0),
  LEVEL_ID                         INTEGER,
  LEVEL                            VARCHAR(1000),
  LINE_NO                          DECIMAL(22,0),
  NO_OF_ISSUES                     DECIMAL(22,0),
  NO_OF_SCHEDULED_CREATED          DECIMAL(22,0),
  ORDER_TYPE_ID                    INTEGER,
  ORDER_TYPE                       VARCHAR(1000),
  RRP                              DECIMAL(22,8),
  STO_END_DATE                     TIMESTAMP,
  STO_END_DATE_KEY                 INTEGER,
  STO_END_DATE_ERROR               VARCHAR(1000),
  STO_ITEM_ID                      INTEGER,
  STO_ITEM_KEY                     INTEGER,
  STO_ITEM_ID_ERROR                VARCHAR(1000),
  STO_NO_ID                        INTEGER,
  SUBSIDIARY_ID                    INTEGER,
  SUBSIDIARY_KEY                   INTEGER,
  SUBSIDIARY_ID_ERROR              VARCHAR(1000),
  STO_START_DATE                   TIMESTAMP,
  STO_START_DATE_KEY               INTEGER,
  STO_START_DATE_ERROR             VARCHAR(1000),
  RECORD_STATUS                       VARCHAR(20),   
  DW_CREATION_DATE                    TIMESTAMP, 
PRIMARY KEY (AMORTIZATION_ERROR_KEY))
DISTKEY(STO_ITEM_ID) INTERLEAVED SORTKEY (RECORD_STATUS,AMORTIZATION_ERROR_KEY);
