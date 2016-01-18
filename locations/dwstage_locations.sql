CREATE SCHEMA if not exists dw_stage;

DROP TABLE if exists dw_stage.locations;

CREATE TABLE dw_stage.locations 
(
  ADDRESS                         VARCHAR(999),
  ADDRESSEE                       VARCHAR(100),
  ADDRESS_ONE                     VARCHAR(150),
  ADDRESS_THREE                   VARCHAR(150),
  ADDRESS_TWO                     VARCHAR(150),
  ATTENTION                       VARCHAR(100),
  BRANCH_ID                       VARCHAR(4000),
  CITY                            VARCHAR(50),
  COUNTRY                         VARCHAR(50),
  DATE_LAST_MODIFIED              TIMESTAMP,
  FULL_NAME                       VARCHAR(1791),
  INVENTORY_AVAILABLE             VARCHAR(3),
  INVENTORY_AVAILABLE_WEB_STORE   VARCHAR(3),
  ISINACTIVE                      VARCHAR(3),
  IS_INCLUDE_IN_SUPPLY_PLANNING   VARCHAR(3),
  LINE_OF_BUSINESS_ID             INTEGER,
  LOCATION_EXTID                  VARCHAR(255),
  LOCATION_ID                     INTEGER,
  NAME                            VARCHAR(31),
  PARENT_ID                       INTEGER,
  PHONE                           VARCHAR(100),
  RETURNADDRESS                   VARCHAR(999),
  RETURN_ADDRESS_ONE              VARCHAR(150),
  RETURN_ADDRESS_TWO              VARCHAR(150),
  RETURN_CITY                     VARCHAR(50),
  RETURN_COUNTRY                  VARCHAR(50),
  RETURN_STATE                    VARCHAR(50),
  RETURN_ZIPCODE                  VARCHAR(36),
  STATE                           VARCHAR(50),
  TRAN_NUM_PREFIX                 VARCHAR(8),
  ZIPCODE                         VARCHAR(36),
  PRIMARY KEY (LOCATION_ID,NAME)
)
DISTSTYLE ALL INTERLEAVED SORTKEY (LOCATION_ID,NAME);


