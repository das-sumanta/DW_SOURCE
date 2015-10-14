CREATE SCHEMA if not exists dw_prestage;

DROP TABLE if exists dw_prestage.payment_terms;

CREATE TABLE dw_prestage.payment_terms 
(
  RUNID                  INTEGER,
  DATE_DRIVEN           VARCHAR(3),
  DATE_LAST_MODIFIED    TIMESTAMP,
  DAYS_UNTIL_DUE        DECIMAL(22,0),
  DISCOUNT_DAYS         DECIMAL(22,0),
  ISINACTIVE            VARCHAR(3),
  IS_PREFERRED          VARCHAR(1),
  MINIMUM_DAYS          DECIMAL(22,0),
  NAME                  VARCHAR(31),
  PAYMENT_TERMS_EXTID   VARCHAR(255),
  PAYMENT_TERMS_ID      INTEGER,
  PERCENTAGE_DISCOUNT   DECIMAL(10,5)
);

