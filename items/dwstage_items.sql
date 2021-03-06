CREATE SCHEMA if not exists dw_stage;

DROP TABLE if exists dw_stage.ITEMS;

CREATE TABLE dw_stage.ITEMS 
(
  ALLOW_DROP_SHIP                      VARCHAR(10),
  APPLY_FRIEGHT                        VARCHAR(10),
  ASSET_ACCOUNT_ID                     INTEGER,
  ASSET_ACCOUNT_NUMBER                 VARCHAR(2000),
  ATP_METHOD                           VARCHAR(200),
  AVAILABLE_TO_PARTNERS                VARCHAR(10),
  BACKORDERABLE                        VARCHAR(10),
  BILL_EXCH_RATE_VAR_ACCOUNT_ID        INTEGER,
  BILL_EXCH_RATE_VAR_ACCOUNT_NUMBER    VARCHAR(2000),
  BILL_PRICE_VARIANCE_ACCOUNT_ID       INTEGER,
  BILL_PRICE_VARIANCE_ACCOUNT_NUMBER   VARCHAR(2000),
  BILL_QTY_VARIANCE_ACCOUNT_ID         INTEGER,
  BILL_QTY_VARIANCE_ACCOUNT_NUMBER     VARCHAR(2000),
  CARTON_DEPTH                         VARCHAR(4000),
  CARTON_HEIGHT                        DECIMAL(22,8),
  CARTON_QUANTITY                      DECIMAL(22,8),
  CARTON_WIDTH                         VARCHAR(4000),
  CLASS_ID                             INTEGER,
  LINE_OF_BUSINESS                     VARCHAR(100),
  COSTING_METHOD                       VARCHAR(20),
  CREATED                              TIMESTAMP,
  DATE_LAST_MODIFIED                   TIMESTAMP,
  DEPARTMENT_ID                        INTEGER,
  COST_CENTER                          VARCHAR(100),
  DISPLAYNAME                          VARCHAR(4000),
  EXPENSE_ACCOUNT_ID                   INTEGER,
  EXPENSE_ACCOUNT_NUMBER               VARCHAR(2000),
  FEATUREDITEM                         VARCHAR(10),
  FULL_NAME                            VARCHAR(600),
  INCOME_ACCOUNT_ID                    INTEGER,
  INCOME_ACCOUNT_NUMBER                VARCHAR(2000),
  ISBN10                               VARCHAR(20),
  ISBN_ANZ_ID                          INTEGER,
  ISBN_NAME                            VARCHAR(1000),
  ISINACTIVE                           VARCHAR(10),
  ITEM_EXTID                           VARCHAR(300),
  ITEM_ID                              INTEGER,
  ITEM_JDE_CODE_ID                     INTEGER,
  ITEM_TYPE_ID                         INTEGER,
  JDE_ITEM_CODE                        VARCHAR,
  LOCATION_ID                          INTEGER,
  LOCATIONS                            VARCHAR(100),
  NAME                                 VARCHAR(200),
  PARENT_ID                            INTEGER,
  PARENT_NAME                          VARCHAR(200),
  PRODUCT_CALSSIFICATION_ANZ_ID        INTEGER,
  PRODUCT_CATEGORY_ID                  INTEGER,
  PRODUCT_CLASSIFICATION_ID            INTEGER,
  PRODUCT_SERIESFAMILY_ID              INTEGER,
  PRODUCT_TYPE_ANZ_ID                  INTEGER,
  PRODUCT_TYPE_ID                      INTEGER,
  PROD_PRICE_VAR_ACCOUNT_ID            INTEGER,
  PROD_PRICE_VAR_ACCOUNT_NUMBER        VARCHAR(2000),
  PROD_QTY_VAR_ACCOUNT_ID              INTEGER,
  PROD_QTY_VAR_ACCOUNT_NUMBER          VARCHAR(2000),
  PUBLISHER_ID                         INTEGER,
  PURCHASEDESCRIPTION                  VARCHAR(4000),
  SALESDESCRIPTION                     VARCHAR(4000),
  SELLING_RIGHTS_ID                    INTEGER,
  SERIAL_NUMBER                        VARCHAR(4000),
  SPECIALSDESCRIPTION                  VARCHAR(4000),
  TYPE_NAME                            VARCHAR(50),
  VENDOR_ID                            INTEGER,
  VENDOR_NAME                          VARCHAR(100),
  VENDRETURN_VARIANCE_ACCOUNT_ID       INTEGER,
  PRODUCT_CATEGORY                     VARCHAR(1000),
  ITEM_TYPE                            VARCHAR(1000),
  PRODUCT_CLASSIFICATION               VARCHAR(5000),
  PRODUCT_TYPE                         VARCHAR(1000),
  PRODUCT_SERIESFAMILY                 VARCHAR(1000)
);

