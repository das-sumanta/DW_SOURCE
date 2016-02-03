/* prestage - drop intermediate insert table */ 
DROP TABLE if exists dw_prestage.tax_items_insert;

/* prestage - create intermediate insert table*/ 
CREATE TABLE dw_prestage.tax_items_insert 
AS
SELECT *
FROM dw_prestage.tax_items
WHERE EXISTS (SELECT 1
              FROM (SELECT item_id
                    FROM (SELECT item_id
                          FROM dw_prestage.tax_items
                          MINUS
                          SELECT item_id
                          FROM dw_stage.tax_items)) a
              WHERE dw_prestage.tax_items.item_id = a.item_id);

/* prestage - drop intermediate update table*/ 
DROP TABLE if exists dw_prestage.tax_items_update;

/* prestage - create intermediate update table*/ 
CREATE TABLE dw_prestage.tax_items_update 
AS
SELECT decode(SUM(ch_type),
             3,2,
             SUM(ch_type)
       )  ch_type,
       item_id
FROM (SELECT item_id,
             CH_TYPE
      FROM (SELECT item_id,
                   INCOME_ACCOUNT_ID,
                   INCOME_ACCOUNT_NUMBER,
                   INCOME_ACCOUNT_NAME,
                   '2' CH_TYPE
            FROM dw_prestage.tax_items
            MINUS
            SELECT item_id,
                   INCOME_ACCOUNT_ID,
                   INCOME_ACCOUNT_NUMBER,
                   INCOME_ACCOUNT_NAME,
                   '2' CH_TYPE
            FROM dw_stage.tax_items)
      UNION ALL
      SELECT item_id,
             CH_TYPE
      FROM (SELECT item_id,
                   NAME,
                   FULL_NAME,
                   DESCRIPTION,
                   RATE,
                   ISINACTIVE,
                   '1' CH_TYPE
            FROM dw_prestage.tax_items
            MINUS
            SELECT item_id,
                   NAME,
                   FULL_NAME,
                   DESCRIPTION,
                   RATE,
                   ISINACTIVE,
                   '1' CH_TYPE
            FROM dw_stage.tax_items)) a
WHERE NOT EXISTS (SELECT 1
                  FROM dw_prestage.tax_items_insert
                  WHERE dw_prestage.tax_items_insert.item_id = a.item_id)
GROUP BY item_id;

/* prestage - drop intermediate delete table*/ 
DROP TABLE if exists dw_prestage.tax_items_delete;

/* prestage - create intermediate delete table*/ 
CREATE TABLE dw_prestage.tax_items_delete 
AS
SELECT *
FROM dw_stage.tax_items
WHERE EXISTS (SELECT 1
              FROM (SELECT item_id
                    FROM (SELECT item_id
                          FROM dw_stage.tax_items
                          MINUS
                          SELECT item_id
                          FROM dw_prestage.tax_items)) a
              WHERE dw_stage.tax_items.item_id = a.item_id);

/* prestage-> no of prestage tax item records identified to inserted */ 
SELECT count(1) FROM dw_prestage.tax_items_insert;

/* prestage-> no of prestage tax item records identified to updated*/ 
SELECT count(1) FROM dw_prestage.tax_items_update;

/* prestage-> no of prestage tax item records identified to deleted*/ 
SELECT count(1) FROM dw_prestage.tax_items_delete;

/* stage ->delete from stage records to be updated */ 
DELETE
FROM dw_stage.tax_items USING dw_prestage.tax_items_update
WHERE dw_stage.tax_items.item_id = dw_prestage.tax_items_update.item_id;

/* stage ->delete from stage records which have been deleted */ 
DELETE
FROM dw_stage.tax_items USING dw_prestage.tax_items_delete
WHERE dw_stage.tax_items.item_id = dw_prestage.tax_items_delete.item_id;

/* stage ->insert into stage records which have been created */ 
INSERT INTO dw_stage.tax_items
(
  ACCOUNT_CLASSIFICATION_ROYA_ID,
  APPLY_FRIEGHT,
  AUTHORPUBLISHER,
  BACKORDERABLE,
  CARTON_DEPTH,
  CARTON_HEIGHT,
  CARTON_QUANTITY,
  CARTON_WEIGHT,
  CARTON_WIDTH,
  CATALOGUE_USE_ID,
  COC_TEST_REPORT_REQUIRED,
  COMMODITY_CODE,
  DATE_LAST_MODIFIED,
  DEFAULT_WT_CODE_ID,
  DESCRIPTION,
  FULL_NAME,
  INCOME_ACCOUNT_ID,
  ISBN10,
  ISBN_ANZ_ID,
  ISINACTIVE,
  ITEM_EXTID,
  ITEM_ID,
  ITEM_JDE_CODE_ID,
  ITEM_TYPE_ID,
  LAUNCH_DATE,
  LEVEL_ID,
  LEXILE,
  NAME,
  NATURE_OF_TRANSACTION_CODES_ID,
  NO__OF_ISSUES,
  PAGE_COUNT,
  PALM_ISBN,
  PARENT_ID,
  PLANNERBUYER_NUMBER_ID,
  PLANNER_ID,
  PRODUCT_CATEGORY_ID,
  PRODUCT_CLASSIFICATION_ID,
  PRODUCT_SERIESFAMILY_ID,
  PRODUCT_TYPE_ANZ_ID,
  PRODUCT_TYPE_ID,
  PUBLISHER_ID,
  RATE,
  ROYALTY_MARKER,
  SEIS_LAUNCH_DATE,
  SEIS_PRODUCT_CATEGORY_ID,
  SEIS_PRODUCT_SERIESFAMILY_ID,
  SEIS_PRODUCT_TYPE_ID,
  SELLING_RIGHTS_ID,
  SERIAL_MARKER_ID,
  SERIAL_NUMBER,
  SOR_TAG,
  SYNC_TO_WMS_ID,
  TAX_CITY,
  TAX_COUNTY,
  TAX_STATE,
  TAX_ZIPCODE,
  TRADE_RELEASE_DATE_1,
  TRADE_RELEASE_DATE_2,
  UOM_ID,
  US_ISBN,
  VENDORNAME,
  VENDOR_ID,
  WANG_ITEM_CODE,
  WEIGHT,
  WEIGHT_KG,
  INCOME_ACCOUNT_NUMBER,
  INCOME_ACCOUNT_NAME
)
SELECT ACCOUNT_CLASSIFICATION_ROYA_ID,
       APPLY_FRIEGHT,
       AUTHORPUBLISHER,
       BACKORDERABLE,
       CARTON_DEPTH,
       CARTON_HEIGHT,
       CARTON_QUANTITY,
       CARTON_WEIGHT,
       CARTON_WIDTH,
       CATALOGUE_USE_ID,
       COC_TEST_REPORT_REQUIRED,
       COMMODITY_CODE,
       DATE_LAST_MODIFIED,
       DEFAULT_WT_CODE_ID,
       DESCRIPTION,
       FULL_NAME,
       INCOME_ACCOUNT_ID,
       ISBN10,
       ISBN_ANZ_ID,
       ISINACTIVE,
       ITEM_EXTID,
       ITEM_ID,
       ITEM_JDE_CODE_ID,
       ITEM_TYPE_ID,
       LAUNCH_DATE,
       LEVEL_ID,
       LEXILE,
       NAME,
       NATURE_OF_TRANSACTION_CODES_ID,
       NO__OF_ISSUES,
       PAGE_COUNT,
       PALM_ISBN,
       PARENT_ID,
       PLANNERBUYER_NUMBER_ID,
       PLANNER_ID,
       PRODUCT_CATEGORY_ID,
       PRODUCT_CLASSIFICATION_ID,
       PRODUCT_SERIESFAMILY_ID,
       PRODUCT_TYPE_ANZ_ID,
       PRODUCT_TYPE_ID,
       PUBLISHER_ID,
       RATE,
       ROYALTY_MARKER,
       SEIS_LAUNCH_DATE,
       SEIS_PRODUCT_CATEGORY_ID,
       SEIS_PRODUCT_SERIESFAMILY_ID,
       SEIS_PRODUCT_TYPE_ID,
       SELLING_RIGHTS_ID,
       SERIAL_MARKER_ID,
       SERIAL_NUMBER,
       SOR_TAG,
       SYNC_TO_WMS_ID,
       TAX_CITY,
       TAX_COUNTY,
       TAX_STATE,
       TAX_ZIPCODE,
       TRADE_RELEASE_DATE_1,
       TRADE_RELEASE_DATE_2,
       UOM_ID,
       US_ISBN,
       VENDORNAME,
       VENDOR_ID,
       WANG_ITEM_CODE,
       WEIGHT,
       WEIGHT_KG,
       INCOME_ACCOUNT_NUMBER,
       INCOME_ACCOUNT_NAME
FROM dw_prestage.tax_items_insert;

/* stage ->insert into stage records which have been updated */ 
INSERT INTO dw_stage.tax_items
(
  ACCOUNT_CLASSIFICATION_ROYA_ID,
  APPLY_FRIEGHT,
  AUTHORPUBLISHER,
  BACKORDERABLE,
  CARTON_DEPTH,
  CARTON_HEIGHT,
  CARTON_QUANTITY,
  CARTON_WEIGHT,
  CARTON_WIDTH,
  CATALOGUE_USE_ID,
  COC_TEST_REPORT_REQUIRED,
  COMMODITY_CODE,
  DATE_LAST_MODIFIED,
  DEFAULT_WT_CODE_ID,
  DESCRIPTION,
  FULL_NAME,
  INCOME_ACCOUNT_ID,
  ISBN10,
  ISBN_ANZ_ID,
  ISINACTIVE,
  ITEM_EXTID,
  ITEM_ID,
  ITEM_JDE_CODE_ID,
  ITEM_TYPE_ID,
  LAUNCH_DATE,
  LEVEL_ID,
  LEXILE,
  NAME,
  NATURE_OF_TRANSACTION_CODES_ID,
  NO__OF_ISSUES,
  PAGE_COUNT,
  PALM_ISBN,
  PARENT_ID,
  PLANNERBUYER_NUMBER_ID,
  PLANNER_ID,
  PRODUCT_CATEGORY_ID,
  PRODUCT_CLASSIFICATION_ID,
  PRODUCT_SERIESFAMILY_ID,
  PRODUCT_TYPE_ANZ_ID,
  PRODUCT_TYPE_ID,
  PUBLISHER_ID,
  RATE,
  ROYALTY_MARKER,
  SEIS_LAUNCH_DATE,
  SEIS_PRODUCT_CATEGORY_ID,
  SEIS_PRODUCT_SERIESFAMILY_ID,
  SEIS_PRODUCT_TYPE_ID,
  SELLING_RIGHTS_ID,
  SERIAL_MARKER_ID,
  SERIAL_NUMBER,
  SOR_TAG,
  SYNC_TO_WMS_ID,
  TAX_CITY,
  TAX_COUNTY,
  TAX_STATE,
  TAX_ZIPCODE,
  TRADE_RELEASE_DATE_1,
  TRADE_RELEASE_DATE_2,
  UOM_ID,
  US_ISBN,
  VENDORNAME,
  VENDOR_ID,
  WANG_ITEM_CODE,
  WEIGHT,
  WEIGHT_KG,
  INCOME_ACCOUNT_NUMBER,
  INCOME_ACCOUNT_NAME
)
SELECT ACCOUNT_CLASSIFICATION_ROYA_ID,
       APPLY_FRIEGHT,
       AUTHORPUBLISHER,
       BACKORDERABLE,
       CARTON_DEPTH,
       CARTON_HEIGHT,
       CARTON_QUANTITY,
       CARTON_WEIGHT,
       CARTON_WIDTH,
       CATALOGUE_USE_ID,
       COC_TEST_REPORT_REQUIRED,
       COMMODITY_CODE,
       DATE_LAST_MODIFIED,
       DEFAULT_WT_CODE_ID,
       DESCRIPTION,
       FULL_NAME,
       INCOME_ACCOUNT_ID,
       ISBN10,
       ISBN_ANZ_ID,
       ISINACTIVE,
       ITEM_EXTID,
       ITEM_ID,
       ITEM_JDE_CODE_ID,
       ITEM_TYPE_ID,
       LAUNCH_DATE,
       LEVEL_ID,
       LEXILE,
       NAME,
       NATURE_OF_TRANSACTION_CODES_ID,
       NO__OF_ISSUES,
       PAGE_COUNT,
       PALM_ISBN,
       PARENT_ID,
       PLANNERBUYER_NUMBER_ID,
       PLANNER_ID,
       PRODUCT_CATEGORY_ID,
       PRODUCT_CLASSIFICATION_ID,
       PRODUCT_SERIESFAMILY_ID,
       PRODUCT_TYPE_ANZ_ID,
       PRODUCT_TYPE_ID,
       PUBLISHER_ID,
       RATE,
       ROYALTY_MARKER,
       SEIS_LAUNCH_DATE,
       SEIS_PRODUCT_CATEGORY_ID,
       SEIS_PRODUCT_SERIESFAMILY_ID,
       SEIS_PRODUCT_TYPE_ID,
       SELLING_RIGHTS_ID,
       SERIAL_MARKER_ID,
       SERIAL_NUMBER,
       SOR_TAG,
       SYNC_TO_WMS_ID,
       TAX_CITY,
       TAX_COUNTY,
       TAX_STATE,
       TAX_ZIPCODE,
       TRADE_RELEASE_DATE_1,
       TRADE_RELEASE_DATE_2,
       UOM_ID,
       US_ISBN,
       VENDORNAME,
       VENDOR_ID,
       WANG_ITEM_CODE,
       WEIGHT,
       WEIGHT_KG,
       INCOME_ACCOUNT_NUMBER,
       INCOME_ACCOUNT_NAME
FROM dw_prestage.tax_items
WHERE EXISTS (SELECT 1
              FROM dw_prestage.tax_items_update
              WHERE dw_prestage.tax_items_update.item_id = dw_prestage.tax_items.item_id);



/* dimension->insert new records in dim tax_items */ 
INSERT INTO dw.tax_items
(
  item_id,
  NAME,
  FULL_NAME,
  DESCRIPTION,
  INCOME_ACCOUNT_ID,
  INCOME_ACCOUNT_NUMBER,
  INCOME_ACCOUNT_NAME,
  ISINACTIVE,
  RATE,
  DATE_ACTIVE_FROM,
  DATE_ACTIVE_TO,
  DW_ACTIVE
)
SELECT item_id,
       DECODE(LENGTH(NAME),
             0,'NA_GDW',
             NAME
       ) ,
       DECODE(LENGTH(FULL_NAME),
             0,'NA_GDW',
             FULL_NAME 
       ) ,
       DECODE(LENGTH(DESCRIPTION),
             0,'NA_GDW',
             DESCRIPTION   
       ) ,
       NVL(INCOME_ACCOUNT_ID,-99),
       DECODE(LENGTH(INCOME_ACCOUNT_NUMBER),
             0,'NA_GDW',
              INCOME_ACCOUNT_NUMBER 
       ) ,
       DECODE(LENGTH(INCOME_ACCOUNT_NAME),
             0,'NA_GDW',
              INCOME_ACCOUNT_NAME 
       ) ,
       NVL(ISINACTIVE,'NA_GDW'),
       DECODE(LENGTH(RATE),
             0,'NA_GDW',
              RATE
       ) ,
       sysdate,
       '9999-12-31 23:59:59',
       'A'
FROM dw_prestage.tax_items_insert A;

/* dimension->update old record as part of SCD2 maintenance*/ 
UPDATE dw.tax_items
   SET dw_active = 'I',
       DATE_ACTIVE_TO = (sysdate -1)
WHERE dw_active = 'A'
AND   sysdate>= date_active_from
AND   sysdate< date_active_to
AND   EXISTS (SELECT 1
              FROM dw_prestage.tax_items_update
              WHERE dw.tax_items.item_id = dw_prestage.tax_items_update.item_id
              AND   dw_prestage.tax_items_update.ch_type = 2);

/* dimension->insert the new records as part of SCD2 maintenance*/ 
INSERT INTO dw.tax_items
(
  item_id,
  NAME,
  FULL_NAME,
  DESCRIPTION,
  INCOME_ACCOUNT_ID,
  INCOME_ACCOUNT_NUMBER,
  INCOME_ACCOUNT_NAME,
  ISINACTIVE,
  RATE,
  DATE_ACTIVE_FROM,
  DATE_ACTIVE_TO,
  DW_ACTIVE
)
SELECT item_id,
       DECODE(LENGTH(NAME),
             0,'NA_GDW',
             NAME
       ) ,
       DECODE(LENGTH(FULL_NAME),
             0,'NA_GDW',
             FULL_NAME 
       ) ,
       DECODE(LENGTH(DESCRIPTION),
             0,'NA_GDW',
             DESCRIPTION   
       ) ,
       NVL(INCOME_ACCOUNT_ID,-99),
       DECODE(LENGTH(INCOME_ACCOUNT_NUMBER),
             0,'NA_GDW',
              INCOME_ACCOUNT_NUMBER 
       ) ,
       DECODE(LENGTH(INCOME_ACCOUNT_NAME),
             0,'NA_GDW',
              INCOME_ACCOUNT_NAME 
       ) ,
       NVL(ISINACTIVE,'NA_GDW'),
       DECODE(LENGTH(RATE),
             0,'NA_GDW',
              RATE
       ) ,
       sysdate,
       '9999-12-31 23:59:59',
       'A'
FROM dw_prestage.tax_items A
WHERE EXISTS (SELECT 1
              FROM dw_prestage.tax_items_update
              WHERE a.item_id = dw_prestage.tax_items_update.item_id
              AND   dw_prestage.tax_items_update.ch_type = 2);

/* dimension->update SCD1 */ 
UPDATE dw.tax_items
   SET NAME = DECODE(LENGTH(dw_prestage.tax_items.NAME),0,'NA_GDW',dw_prestage.tax_items.NAME),
       FULL_NAME = DECODE(LENGTH(dw_prestage.tax_items.FULL_NAME),0,'NA_GDW',dw_prestage.tax_items.FULL_NAME),
       DESCRIPTION = DECODE(LENGTH(dw_prestage.tax_items.DESCRIPTION),0,'NA_GDW',dw_prestage.tax_items.DESCRIPTION),
       RATE = DECODE(LENGTH(dw_prestage.tax_items.RATE),0,'NA_GDW',dw_prestage.tax_items.RATE),
       ISINACTIVE = DECODE(LENGTH(dw_prestage.tax_items.ISINACTIVE),0,'NA_GDW',dw_prestage.tax_items.ISINACTIVE)
FROM dw_prestage.tax_items
WHERE dw.tax_items.item_id = dw_prestage.tax_items.item_id
AND   EXISTS (SELECT 1
              FROM dw_prestage.tax_items_update
              WHERE dw_prestage.tax_items.item_id = dw_prestage.tax_items_update.item_id
              AND   dw_prestage.tax_items_update.ch_type = 1);

/* dimension->logically delete dw records */ 
UPDATE dw.tax_items
   SET DATE_ACTIVE_TO = sysdate -1,
       dw_active = 'I'
FROM dw_prestage.tax_items_delete
WHERE dw.tax_items.item_id = dw_prestage.tax_items_delete.item_id;
