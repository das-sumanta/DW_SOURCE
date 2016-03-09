CREATE SCHEMA if not exists dw;

DROP TABLE if exists dw.amortization_fact;

CREATE TABLE dw.amortization_fact 
( 
  AMORTIZATION_KEY                 BIGINT IDENTITY(0,1), 
  AMORTIZATION_PER_ISSUELEVE_ID    INTEGER,
  AMORTIZE_VALUE_PER_ISSUE_EXCL    DECIMAL(22,8),
  AMORTIZE_VALUE_PER_ISSUE_INCL    DECIMAL(22,8),
  COMPONENTS_KEY                   INTEGER,
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
  STO_END_DATE_KEY                 INTEGER,
  STO_ITEM_KEY                     INTEGER,
  STO_NO_ID                        INTEGER,
  SUBSIDIARY_KEY                   INTEGER,
  STO_START_DATE_KEY               INTEGER,
  DATE_ACTIVE_FROM                 DATE,
  DATE_ACTIVE_TO                   DATE,
  DW_CURRENT                       INTEGER,
PRIMARY KEY (AMORTIZATION_KEY))
DISTKEY(STO_ITEM_KEY) INTERLEAVED SORTKEY (SUBSIDIARY_KEY,STO_NO_ID,STO_START_DATE_KEY,DW_CURRENT);
