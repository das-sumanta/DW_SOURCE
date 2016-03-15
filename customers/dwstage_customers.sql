CREATE SCHEMA if not exists dw_stage;

DROP TABLE if exists dw_stage.customers;

CREATE TABLE dw_stage.customers 
(
  CUSTOMER_ID                INTEGER,
  CUSTOMER_EXTID             VARCHAR(500),
  LEGACY_CUSTOMER_IDCUSTOM   VARCHAR(4000),
  NAME                       VARCHAR(100),
  EMAIL                      VARCHAR(500),
  CREDITLIMIT                DECIMAL(20,2),
  ADDRESS_LINE1              VARCHAR(500),
  ADDRESS_LINE2              VARCHAR(500),
  ADDRESS_LINE3              VARCHAR(500),
  ZIPCODE                    VARCHAR(100),
  CITY                       VARCHAR(100),
  STATE                      VARCHAR(100),
  COUNTRY                    VARCHAR(100),
  COMPANYNAME                VARCHAR(90),
  CURRENCY                   VARCHAR(150),
  CURRENCY_ID                INTEGER,
  ISINACTIVE                 VARCHAR(10),
  CUSTOMER_TYPE              VARCHAR(50),
  LINE_OF_BUSINESS           VARCHAR(50),
  LINE_OF_BUSINESS_ID        INTEGER,
  SUBSIDIARY                 VARCHAR(83),
  SUBSIDIARY_ID              INTEGER,
  CUSTOMER_CATEGORY          VARCHAR(83),
  PAYMENT_TERMS              VARCHAR(50),
  PAYMENT_TERM_ID            INTEGER,
  PARENT                     VARCHAR(100),
  PARENT_ID                  INTEGER,
  TERRITORY                  VARCHAR(500),
  ABCDO_MARKER_ID            INTEGER,
  ABCDO_MARKER               VARCHAR(1000),
  DECILE_ID                  INTEGER,
  DECILE                     VARCHAR(1000),
  ROLL_SIZE                  INTEGER,
  PRIMARY KEY (CUSTOMER_ID,NAME)
)
DISTSTYLE ALL INTERLEAVED SORTKEY (CUSTOMER_ID,NAME);
