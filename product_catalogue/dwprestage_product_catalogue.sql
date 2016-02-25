CREATE SCHEMA if not exists dw_prestage;

DROP TABLE if exists dw_prestage.product_catalogue;

CREATE TABLE dw_prestage.product_catalogue 
(
  RUNID                            BIGINT,
  PRODUCT_CATALOGUE_ID             INTEGER,
  PRODUCT_CATALOGUE_NAME           VARCHAR(3000),
  CLUBLEVELREADING_LEVEL_ID        INTEGER,
  CLUBLEVELREADING_LEVEL_NAME      VARCHAR(3000),
  DATE_CREATED                     TIMESTAMP,
  IN_MARKET_END_DATE               TIMESTAMP,
  IN_MARKET_START_DATE             TIMESTAMP,
  ISSUEOFFERMONTH_ID               INTEGER,
  ISSUEOFFERMONTH_NAME             VARCHAR(3000),
  ISSUEOFFERMONTH_DESC             VARCHAR(4000),
  IS_INACTIVE                      VARCHAR(1),
  LAST_MODIFIED_DATE               TIMESTAMP,
  LINE_OF_BUSINESS_ID              INTEGER,
  LINE_OF_BUSINESS                 VARCHAR(200),
  NO__OF_BOOKS_IN_OFFER_BIH_O_ID   INTEGER,
  OFFER_DESCRIPTION                VARCHAR(4000),
  SUBSIDIARY_ID                    INTEGER,
  SUBSIDIARY                       VARCHAR(400),
  YEARMONTH_YYYYMM                 DECIMAL(22,0),
  YEARMONTH_YYYYMM__REMOVE         DECIMAL(22,0),
  YEAR_ID                          INTEGER,
  PRODUCT_CATALOGUE_YEAR           VARCHAR(1000)
);
