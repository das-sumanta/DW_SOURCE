CREATE SCHEMA if not exists dw_stage;

DROP TABLE if exists dw_stage.amortization_fact;

CREATE TABLE dw_stage.amortization_fact 
(
  RUNID                            INTEGER,
  AMORTIZATION_PER_ISSUELEVE_ID   INTEGER,
  AMORTIZE_VALUE_PER_ISSUE_EXCL    DECIMAL(22,8),
  AMORTIZE_VALUE_PER_ISSUE_INCL    DECIMAL(22,8),
  COMPONENTS_ID                    INTEGER,
  DATE_CREATED                     TIMESTAMP,
  DISCOUNTED_AMOUNT                DECIMAL(22,8),
  DISCOUNTED_PRICE                 DECIMAL(22,8),
  IS_INACTIVE                      VARCHAR(1),
  LAST_MODIFIED_DATE               TIMESTAMP,
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
  STO_ITEM_ID                      INTEGER,
  STO_NO_ID                        INTEGER,
  SUBSIDIARY_ID                    INTEGER,
  STO_START_DATE                   TIMESTAMP,
PRIMARY KEY (RUNID,AMORTIZATION_PER_ISSUELEVE_ID))
DISTKEY(STO_ITEM_ID) INTERLEAVED SORTKEY (AMORTIZATION_PER_ISSUELEVE_ID,SUBSIDIARY_ID,STO_ITEM_ID,STO_START_DATE);
