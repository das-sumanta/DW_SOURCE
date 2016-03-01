CREATE SCHEMA if not exists dw;

DROP TABLE if exists dw.items;

CREATE TABLE dw.items 
(
  ITEM_KEY                             BIGINT IDENTITY(0,1),
  ITEM_ID                              INTEGER,
  NAME                                 VARCHAR(200),
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
  COSTING_METHOD                       VARCHAR(20),
  CLASS_ID                             INTEGER,
  LINE_OF_BUSINESS                     VARCHAR(100),
  DISPLAYNAME                          VARCHAR(4000),
  DEPARTMENT_ID                        INTEGER,
  COST_CENTER                          VARCHAR(100),
  EXPENSE_ACCOUNT_ID                   INTEGER,
  EXPENSE_ACCOUNT_NUMBER               VARCHAR(2000),
  FEATUREDITEM                         VARCHAR(10),
  FULL_NAME                            VARCHAR(600),
  INCOME_ACCOUNT_ID                    INTEGER,
  INCOME_ACCOUNT_NUMBER                VARCHAR(2000),
  ISBN_ANZ_ID                          INTEGER,
  ISBN_NAME                            VARCHAR(1000),
  ISINACTIVE                           VARCHAR(10),
  ITEM_EXTID                           VARCHAR(300),
  JDE_ITEM_CODE                        VARCHAR(4000),
  ISBN10                               VARCHAR(20),
  ITEM_TYPE_ID                         INTEGER,
  LOCATION_ID                          INTEGER,
  LOCATION                             VARCHAR(500),
  PARENT_ID                            INTEGER,
  PARENT_NAME                          VARCHAR(200),
  PRODUCT_CATEGORY_ID                  INTEGER,
  PRODUCT_TYPE_ANZ_ID                  INTEGER,
  PUBLISHER_ID                         INTEGER,
  SELLING_RIGHTS_ID                    INTEGER,
  SERIAL_NUMBER                        VARCHAR(4000),
  TYPE_NAME                            VARCHAR(50),
  VENDOR_ID                            INTEGER,
  VENDOR_NAME                          VARCHAR(100),
  VENDRETURN_VARIANCE_ACCOUNT_ID       INTEGER,
  VENDRETURN_VARIANCE_ACCOUNT_NUMBER   VARCHAR(2000),
  WANG_ITEM_CODE                       VARCHAR(4000),
  PRODUCT_CATEGORY                     VARCHAR(1000),
  ITEM_TYPE                            VARCHAR(1000),
  PRODUCT_CLASSIFICATION               VARCHAR(5000),
  PRODUCT_TYPE                         VARCHAR(1000),
  PRODUCT_SERIESFAMILY                 VARCHAR(1000),
  DATE_ACTIVE_FROM                     TIMESTAMP,
  DATE_ACTIVE_TO                       TIMESTAMP,
  DW_ACTIVE                            VARCHAR(1),
  PRIMARY KEY (ITEM_KEY)
)
DISTSTYLE ALL INTERLEAVED SORTKEY (ITEM_KEY,ITEM_ID,DW_ACTIVE);

INSERT INTO dw.ITEMS
(
  ITEM_ID,
  NAME,
  ALLOW_DROP_SHIP,
  APPLY_FRIEGHT,
  ASSET_ACCOUNT_ID,
  ASSET_ACCOUNT_NUMBER,
  ATP_METHOD,
  AVAILABLE_TO_PARTNERS,
  BACKORDERABLE,
  BILL_EXCH_RATE_VAR_ACCOUNT_ID,
  BILL_EXCH_RATE_VAR_ACCOUNT_NUMBER,
  BILL_PRICE_VARIANCE_ACCOUNT_ID,
  BILL_PRICE_VARIANCE_ACCOUNT_NUMBER,
  BILL_QTY_VARIANCE_ACCOUNT_ID,
  BILL_QTY_VARIANCE_ACCOUNT_NUMBER,
  CARTON_DEPTH,
  CARTON_HEIGHT,
  CARTON_QUANTITY,
  CARTON_WIDTH,
  COSTING_METHOD,
  CLASS_ID,
  LINE_OF_BUSINESS,
  DISPLAYNAME,
  DEPARTMENT_ID,
  COST_CENTER,
  EXPENSE_ACCOUNT_ID,
  EXPENSE_ACCOUNT_NUMBER,
  FEATUREDITEM,
  FULL_NAME,
  INCOME_ACCOUNT_ID,
  INCOME_ACCOUNT_NUMBER,
  ISBN_ANZ_ID,
  ISBN_NAME,
  ISINACTIVE,
  ITEM_EXTID,
  JDE_ITEM_CODE,
  ISBN10,
  ITEM_TYPE_ID,
  LOCATION_ID,
  LOCATION,
  PARENT_ID,
  PARENT_NAME,
  PRODUCT_CATEGORY_ID,
  PRODUCT_TYPE_ANZ_ID,
  PUBLISHER_ID,
  SELLING_RIGHTS_ID,
  SERIAL_NUMBER,
  TYPE_NAME,
  VENDOR_ID,
  VENDOR_NAME,
  VENDRETURN_VARIANCE_ACCOUNT_ID,
  VENDRETURN_VARIANCE_ACCOUNT_NUMBER,
  WANG_ITEM_CODE,
  PRODUCT_CATEGORY, 
  ITEM_TYPE ,
  PRODUCT_CLASSIFICATION, 
  PRODUCT_TYPE ,
  PRODUCT_SERIESFAMILY, 
  DATE_ACTIVE_FROM,
  DATE_ACTIVE_TO,
  DW_ACTIVE
)
SELECT -99 AS ITEM_ID,
       'NA_GDW' AS NAME,
       'NA_GDW' AS ALLOW_DROP_SHIP,
       'NA_GDW' AS APPLY_FRIEGHT,
       -99 AS ASSET_ACCOUNT_ID,
       'NA_GDW' AS ASSET_ACCOUNT_NUMBER,
       'NA_GDW' AS ATP_METHOD,
       'NA_GDW' AS AVAILABLE_TO_PARTNERS,
       'NA_GDW' AS BACKORDERABLE,
       -99 AS BILL_EXCH_RATE_VAR_ACCOUNT_ID,
       'NA_GDW' AS BILL_EXCH_RATE_VAR_ACCOUNT_NUMBER,
       -99 AS BILL_PRICE_VARIANCE_ACCOUNT_ID,
       'NA_GDW' AS BILL_PRICE_VARIANCE_ACCOUNT_NUMBER,
       -99 AS BILL_QTY_VARIANCE_ACCOUNT_ID,
       'NA_GDW' AS BILL_QTY_VARIANCE_ACCOUNT_NUMBER,
       'NA_GDW' AS CARTON_DEPTH,
       -99 AS CARTON_HEIGHT,
       -99 AS CARTON_QUANTITY,
       'NA_GDW' AS CARTON_WIDTH,
       'NA_GDW' AS COSTING_METHOD,
       -99 AS CLASS_ID,
       'NA_GDW' AS LINE_OF_BUSINESS,
       'NA_GDW' AS DISPLAYNAME,
       -99 AS DEPARTMENT_ID,
       'NA_GDW' AS COST_CENTER,
       -99 AS EXPENSE_ACCOUNT_ID,
       'NA_GDW' AS EXPENSE_ACCOUNT_NUMBER,
       'NA_GDW' AS FEATUREDITEM,
       'NA_GDW' AS FULL_NAME,
       -99 AS INCOME_ACCOUNT_ID,
       'NA_GDW' AS INCOME_ACCOUNT_NUMBER,
       -99 AS ISBN_ANZ_ID,
       'NA_GDW' AS ISBN_NAME,
       'NA_GDW' AS ISINACTIVE,
       'NA_GDW' AS ITEM_EXTID,
       'NA_GDW' AS JDE_ITEM_CODE,
       'NA_GDW' AS ISBN10,
       -99 AS ITEM_TYPE_ID,
       -99 AS LOCATION_ID,
       'NA_GDW' AS LOCATION,
       -99 AS PARENT_ID,
       'NA_GDW' AS PARENT_NAME,
       -99 AS PRODUCT_CATEGORY_ID,
       -99 AS PRODUCT_TYPE_ANZ_ID,
       -99 AS PUBLISHER_ID,
       -99 AS SELLING_RIGHTS_ID,
       'NA_GDW' AS SERIAL_NUMBER,
       'NA_GDW' AS TYPE_NAME,
       -99 AS VENDOR_ID,
       'NA_GDW' AS VENDOR_NAME,
       -99 AS VENDRETURN_VARIANCE_ACCOUNT_ID,
       'NA_GDW' AS VENDRETURN_VARIANCE_ACCOUNT_NUMBER,
       'NA_GDW' AS WANG_ITEM_CODE,
	   'NA_GDW' AS PRODUCT_CATEGORY, 
       'NA_GDW' AS ITEM_TYPE ,
       'NA_GDW' AS PRODUCT_CLASSIFICATION, 
       'NA_GDW' AS PRODUCT_TYPE ,
       'NA_GDW' AS PRODUCT_SERIESFAMILY, 
       sysdate AS DATE_ACTIVE_FROM,
       '9999-12-31 23:59:59' AS DATE_ACTIVE_TO,
       'A' AS DW_ACTIVE;

INSERT INTO dw.ITEMS
(
  ITEM_ID,
  NAME,
  ALLOW_DROP_SHIP,
  APPLY_FRIEGHT,
  ASSET_ACCOUNT_ID,
  ASSET_ACCOUNT_NUMBER,
  ATP_METHOD,
  AVAILABLE_TO_PARTNERS,
  BACKORDERABLE,
  BILL_EXCH_RATE_VAR_ACCOUNT_ID,
  BILL_EXCH_RATE_VAR_ACCOUNT_NUMBER,
  BILL_PRICE_VARIANCE_ACCOUNT_ID,
  BILL_PRICE_VARIANCE_ACCOUNT_NUMBER,
  BILL_QTY_VARIANCE_ACCOUNT_ID,
  BILL_QTY_VARIANCE_ACCOUNT_NUMBER,
  CARTON_DEPTH,
  CARTON_HEIGHT,
  CARTON_QUANTITY,
  CARTON_WIDTH,
  COSTING_METHOD,
  CLASS_ID,
  LINE_OF_BUSINESS,
  DISPLAYNAME,
  DEPARTMENT_ID,
  COST_CENTER,
  EXPENSE_ACCOUNT_ID,
  EXPENSE_ACCOUNT_NUMBER,
  FEATUREDITEM,
  FULL_NAME,
  INCOME_ACCOUNT_ID,
  INCOME_ACCOUNT_NUMBER,
  ISBN_ANZ_ID,
  ISBN_NAME,
  ISINACTIVE,
  ITEM_EXTID,
  JDE_ITEM_CODE,
  ISBN10,
  ITEM_TYPE_ID,
  LOCATION_ID,
  LOCATION,
  PARENT_ID,
  PARENT_NAME,
  PRODUCT_CATEGORY_ID,
  PRODUCT_TYPE_ANZ_ID,
  PUBLISHER_ID,
  SELLING_RIGHTS_ID,
  SERIAL_NUMBER,
  TYPE_NAME,
  VENDOR_ID,
  VENDOR_NAME,
  VENDRETURN_VARIANCE_ACCOUNT_ID,
  VENDRETURN_VARIANCE_ACCOUNT_NUMBER,
  WANG_ITEM_CODE,
  PRODUCT_CATEGORY, 
  ITEM_TYPE ,
  PRODUCT_CLASSIFICATION, 
  PRODUCT_TYPE ,
  PRODUCT_SERIESFAMILY, 
  DATE_ACTIVE_FROM,
  DATE_ACTIVE_TO,
  DW_ACTIVE
)
SELECT 0 AS ITEM_ID,
       'NA_ERR' AS NAME,
       'NA_ERR' AS ALLOW_DROP_SHIP,
       'NA_ERR' AS APPLY_FRIEGHT,
       0 AS ASSET_ACCOUNT_ID,
       'NA_ERR' AS ASSET_ACCOUNT_NUMBER,
       'NA_ERR' AS ATP_METHOD,
       'NA_ERR' AS AVAILABLE_TO_PARTNERS,
       'NA_ERR' AS BACKORDERABLE,
       0 AS BILL_EXCH_RATE_VAR_ACCOUNT_ID,
       'NA_ERR' AS BILL_EXCH_RATE_VAR_ACCOUNT_NUMBER,
       0 AS BILL_PRICE_VARIANCE_ACCOUNT_ID,
       'NA_ERR' AS BILL_PRICE_VARIANCE_ACCOUNT_NUMBER,
       0 AS BILL_QTY_VARIANCE_ACCOUNT_ID,
       'NA_ERR' AS BILL_QTY_VARIANCE_ACCOUNT_NUMBER,
       'NA_ERR' AS CARTON_DEPTH,
       0 AS CARTON_HEIGHT,
       0 AS CARTON_QUANTITY,
       'NA_ERR' AS CARTON_WIDTH,
       'NA_ERR' AS COSTING_METHOD,
       0 AS CLASS_ID,
       'NA_ERR' AS LINE_OF_BUSINESS,
       'NA_ERR' AS DISPLAYNAME,
       0 AS DEPARTMENT_ID,
       'NA_ERR' AS COST_CENTER,
       0 AS EXPENSE_ACCOUNT_ID,
       'NA_ERR' AS EXPENSE_ACCOUNT_NUMBER,
       'NA_ERR' AS FEATUREDITEM,
       'NA_ERR' AS FULL_NAME,
       0 AS INCOME_ACCOUNT_ID,
       'NA_ERR' AS INCOME_ACCOUNT_NUMBER,
       0 AS ISBN_ANZ_ID,
       'NA_ERR' AS ISBN_NAME,
       'NA_ERR' AS ISINACTIVE,
       'NA_ERR' AS ITEM_EXTID,
       'NA_ERR' AS JDE_ITEM_CODE,
       'NA_ERR' AS ISBN10,
       0 AS ITEM_TYPE_ID,
       0 AS LOCATION_ID,
       'NA_ERR' AS LOCATION,
       0 AS PARENT_ID,
       'NA_ERR' AS PARENT_NAME,
       0 AS PRODUCT_CATEGORY_ID,
       0 AS PRODUCT_TYPE_ANZ_ID,
       0 AS PUBLISHER_ID,
       0 AS SELLING_RIGHTS_ID,
       'NA_ERR' AS SERIAL_NUMBER,
       'NA_ERR' AS TYPE_NAME,
       0 AS VENDOR_ID,
       'NA_ERR' AS VENDOR_NAME,
       0 AS VENDRETURN_VARIANCE_ACCOUNT_ID,
       'NA_ERR' AS VENDRETURN_VARIANCE_ACCOUNT_NUMBER,
       'NA_ERR' AS WANG_ITEM_CODE,
	   'NA_ERR' AS PRODUCT_CATEGORY, 
       'NA_ERR' AS ITEM_TYPE ,
       'NA_ERR' AS PRODUCT_CLASSIFICATION, 
       'NA_ERR' AS PRODUCT_TYPE ,
       'NA_ERR' AS PRODUCT_SERIESFAMILY, 
       sysdate AS DATE_ACTIVE_FROM,
       '9999-12-31 23:59:59' AS DATE_ACTIVE_TO,
       'A' AS DW_ACTIVE;

COMMIT;




