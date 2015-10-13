DROP TABLE if exists dw_prestage.items_insert;

CREATE TABLE dw_prestage.items_insert 
AS
SELECT ALLOW_DROP_SHIP,
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
       CLASS_ID,
       LINE_OF_BUSINESS,
       COSTING_METHOD,
       CREATED,
       DATE_LAST_MODIFIED,
       DEPARTMENT_ID,
       COST_CENTER,
       DISPLAYNAME,
       EXPENSE_ACCOUNT_ID,
       EXPENSE_ACCOUNT_NUMBER,
       FEATUREDITEM,
       FULL_NAME,
       INCOME_ACCOUNT_ID,
       INCOME_ACCOUNT_NUMBER,
       ISBN10,
       ISBN_ANZ_ID,
       ISBN_NAME,
       ISINACTIVE,
       ITEM_EXTID,
       ITEM_ID,
       ITEM_JDE_CODE_ID,
       ITEM_TYPE_ID,
       JDE_ITEM_CODE,
       LOCATION_ID,
       LOCATIONS,
       NAME,
       PARENT_ID,
       PARENT_NAME,
       PRODUCT_CALSSIFICATION_ANZ_ID,
       PRODUCT_CATEGORY_ID,
       PRODUCT_CLASSIFICATION_ID,
       PRODUCT_SERIESFAMILY_ID,
       PRODUCT_TYPE_ANZ_ID,
       PRODUCT_TYPE_ID,
       PROD_PRICE_VAR_ACCOUNT_ID,
       PROD_PRICE_VAR_ACCOUNT_NUMBER,
       PROD_QTY_VAR_ACCOUNT_ID,
       PROD_QTY_VAR_ACCOUNT_NUMBER,
       PUBLISHER_ID,
       PURCHASEDESCRIPTION,
       SALESDESCRIPTION,
       SELLING_RIGHTS_ID,
       SERIAL_NUMBER,
       SPECIALSDESCRIPTION,
       TYPE_NAME,
       VENDOR_ID,
       VENDOR_NAME,
       VENDRETURN_VARIANCE_ACCOUNT_ID
FROM dw_prestage.items
WHERE EXISTS (SELECT 1 FROM (SELECT item_id FROM (SELECT item_id FROM dw_prestage.items MINUS SELECT item_id FROM dw_stage.items)) a WHERE dw_prestage.items.item_id = a.item_id);

DROP TABLE if exists dw_prestage.items_update;

CREATE TABLE dw_prestage.items_update 
AS
SELECT decode(SUM(ch_type),
             3,2,
             SUM(ch_type)
       )  ch_type,
       item_id
FROM (SELECT item_id,
             CH_TYPE
      FROM (
      --SCD2 columns
      
           SELECT item_id,CLASS_ID,LINE_OF_BUSINESS,DEPARTMENT_ID,COST_CENTER,LOCATION_ID,LOCATIONS,'2' CH_TYPE 
           FROM dw_prestage.items
      MINUS
      SELECT item_id,
             CLASS_ID,
             LINE_OF_BUSINESS,
             DEPARTMENT_ID,
             COST_CENTER,
             LOCATION_ID,
             LOCATIONS,
             '2' CH_TYPE
      FROM dw_stage.items)
      UNION ALL
      SELECT item_id,
             CH_TYPE
      FROM (
      --SCD1 columns
      
           SELECT item_id,NAME,ALLOW_DROP_SHIP,APPLY_FRIEGHT,ASSET_ACCOUNT_ID,ASSET_ACCOUNT_NUMBER,ATP_METHOD,AVAILABLE_TO_PARTNERS,BACKORDERABLE,BILL_EXCH_RATE_VAR_ACCOUNT_ID,BILL_EXCH_RATE_VAR_ACCOUNT_NUMBER,BILL_PRICE_VARIANCE_ACCOUNT_ID,BILL_PRICE_VARIANCE_ACCOUNT_NUMBER,BILL_QTY_VARIANCE_ACCOUNT_ID,BILL_QTY_VARIANCE_ACCOUNT_NUMBER,CARTON_DEPTH,CARTON_HEIGHT,CARTON_QUANTITY,CARTON_WIDTH,COSTING_METHOD,DISPLAYNAME,EXPENSE_ACCOUNT_ID,EXPENSE_ACCOUNT_NUMBER,FEATUREDITEM,FULL_NAME,INCOME_ACCOUNT_ID,INCOME_ACCOUNT_NUMBER,ISBN_ANZ_ID,ISBN_NAME,ISINACTIVE,ITEM_EXTID,ITEM_JDE_CODE_ID,ISBN10,ITEM_TYPE_ID,JDE_ITEM_CODE,PARENT_ID,PARENT_NAME,PRODUCT_CALSSIFICATION_ANZ_ID,PRODUCT_CATEGORY_ID,PRODUCT_TYPE_ANZ_ID,PUBLISHER_ID,PURCHASEDESCRIPTION,SALESDESCRIPTION,SELLING_RIGHTS_ID,SERIAL_NUMBER,TYPE_NAME,VENDOR_ID,VENDOR_NAME,VENDRETURN_VARIANCE_ACCOUNT_ID,/*VENDRETURN_VARIANCE_ACCOUNT_NUMBER,WANG_ITEM_CODE,*/'1' CH_TYPE 
           FROM dw_prestage.items
      MINUS
      SELECT item_id,
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
             DISPLAYNAME,
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
             ITEM_JDE_CODE_ID,
             ISBN10,
             ITEM_TYPE_ID,
             JDE_ITEM_CODE,
             PARENT_ID,
             PARENT_NAME,
             PRODUCT_CALSSIFICATION_ANZ_ID,
             PRODUCT_CATEGORY_ID,
             PRODUCT_TYPE_ANZ_ID,
             PUBLISHER_ID,
             PURCHASEDESCRIPTION,
             SALESDESCRIPTION,
             SELLING_RIGHTS_ID,
             SERIAL_NUMBER,
             TYPE_NAME,
             VENDOR_ID,
             VENDOR_NAME,
             VENDRETURN_VARIANCE_ACCOUNT_ID,
             /*VENDRETURN_VARIANCE_ACCOUNT_NUMBER,*/
            /* WANG_ITEM_CODE,*/
             '1' CH_TYPE
      FROM dw_stage.items)) a
WHERE NOT EXISTS (SELECT 1 FROM dw_prestage.items_insert WHERE dw_prestage.items_insert.item_id = a.item_id)
GROUP BY item_id;

DROP TABLE if exists dw_prestage.items_delete;

CREATE TABLE dw_prestage.items_delete 
AS
SELECT *
FROM dw_stage.items
WHERE EXISTS (SELECT 1 FROM (SELECT item_id FROM (SELECT item_id FROM dw_stage.items MINUS SELECT item_id FROM dw_prestage.items)) a WHERE dw_stage.items.item_id = a.item_id);

SELECT 'no of prestage item records identified to inserted -->' ||count(1)
FROM dw_prestage.items_insert;

SELECT 'no of prestage item records identified to updated -->' ||count(1)
FROM dw_prestage.items_update;

SELECT 'no of prestage item records identified to deleted -->' ||count(1)
FROM dw_prestage.items_delete;

/* delete from stage records to be updated */ 
DELETE
FROM dw_stage.items USING dw_prestage.items_update
WHERE dw_stage.items.item_id = dw_prestage.items_update.item_id;

/* delete from stage records which have been deleted */ 
DELETE
FROM dw_stage.items USING dw_prestage.items_delete
WHERE dw_stage.items.item_id = dw_prestage.items_delete.item_id;

/* insert into stage records which have been created */ 
INSERT INTO dw_stage.items
SELECT *
FROM dw_prestage.items_insert;

/* insert into stage records which have been updated */ 
INSERT INTO dw_stage.items
SELECT ALLOW_DROP_SHIP,
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
       CLASS_ID,
       LINE_OF_BUSINESS,
       COSTING_METHOD,
       CREATED,
       DATE_LAST_MODIFIED,
       DEPARTMENT_ID,
       COST_CENTER,
       DISPLAYNAME,
       EXPENSE_ACCOUNT_ID,
       EXPENSE_ACCOUNT_NUMBER,
       FEATUREDITEM,
       FULL_NAME,
       INCOME_ACCOUNT_ID,
       INCOME_ACCOUNT_NUMBER,
       ISBN10,
       ISBN_ANZ_ID,
       ISBN_NAME,
       ISINACTIVE,
       ITEM_EXTID,
       ITEM_ID,
       ITEM_JDE_CODE_ID,
       ITEM_TYPE_ID,
       JDE_ITEM_CODE,
       LOCATION_ID,
       LOCATIONS,
       NAME,
       PARENT_ID,
       PARENT_NAME,
       PRODUCT_CALSSIFICATION_ANZ_ID,
       PRODUCT_CATEGORY_ID,
       PRODUCT_CLASSIFICATION_ID,
       PRODUCT_SERIESFAMILY_ID,
       PRODUCT_TYPE_ANZ_ID,
       PRODUCT_TYPE_ID,
       PROD_PRICE_VAR_ACCOUNT_ID,
       PROD_PRICE_VAR_ACCOUNT_NUMBER,
       PROD_QTY_VAR_ACCOUNT_ID,
       PROD_QTY_VAR_ACCOUNT_NUMBER,
       PUBLISHER_ID,
       PURCHASEDESCRIPTION,
       SALESDESCRIPTION,
       SELLING_RIGHTS_ID,
       SERIAL_NUMBER,
       SPECIALSDESCRIPTION,
       TYPE_NAME,
       VENDOR_ID,
       VENDOR_NAME,
       VENDRETURN_VARIANCE_ACCOUNT_ID
FROM dw_prestage.items
WHERE EXISTS (SELECT 1 FROM dw_prestage.items_update WHERE dw_prestage.items_update.item_id = dw_prestage.items.item_id);

COMMIT;

/* insert new records in dim items */ /*==========================assumed that dimensions will be full extraction and hence dw_prestage.items will have all the records  =====*/ /*==========================for the first run. =====================================================================================================================================*/ 
INSERT INTO dw.items
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
  ITEM_JDE_CODE_ID,
  ISBN10,
  ITEM_TYPE_ID,
  JDE_ITEM_CODE,
  LOCATION_ID,
  LOCATION,
  PARENT_ID,
  PARENT_NAME,
  PRODUCT_CALSSIFICATION_ANZ_ID,
  PRODUCT_CATEGORY_ID,
  PRODUCT_TYPE_ANZ_ID,
  PUBLISHER_ID,
  PURCHASEDESCRIPTION,
  SALESDESCRIPTION,
  SELLING_RIGHTS_ID,
  SERIAL_NUMBER,
  TYPE_NAME,
  VENDOR_ID,
  VENDOR_NAME,
  VENDRETURN_VARIANCE_ACCOUNT_ID,
 /* VENDRETURN_VARIANCE_ACCOUNT_NUMBER,
  WANG_ITEM_CODE, */
  DATE_ACTIVE_FROM,
  DATE_ACTIVE_TO,
  DW_ACTIVE
)
SELECT ITEM_ID,
       NVL(NAME,'NA_GDW'),
       NVL(ALLOW_DROP_SHIP,'NA_GDW'),
       NVL(APPLY_FRIEGHT,'NA_GDW'),
       NVL(ASSET_ACCOUNT_ID,-99),
       NVL(ASSET_ACCOUNT_NUMBER,'NA_GDW'),
       NVL(ATP_METHOD,'NA_GDW'),
       NVL(AVAILABLE_TO_PARTNERS,'NA_GDW'),
       NVL(BACKORDERABLE,'NA_GDW'),
       NVL(BILL_EXCH_RATE_VAR_ACCOUNT_ID,-99),
       NVL(BILL_EXCH_RATE_VAR_ACCOUNT_NUMBER,'NA_GDW'),
       NVL(BILL_PRICE_VARIANCE_ACCOUNT_ID,-99),
       NVL(BILL_PRICE_VARIANCE_ACCOUNT_NUMBER,'NA_GDW'),
       NVL(BILL_QTY_VARIANCE_ACCOUNT_ID,-99),
       NVL(BILL_QTY_VARIANCE_ACCOUNT_NUMBER,'NA_GDW'),
       NVL(CARTON_DEPTH,'NA_GDW'),
       NVL(CARTON_HEIGHT,-99),
       NVL(CARTON_QUANTITY,-99),
       NVL(CARTON_WIDTH,'NA_GDW'),
       NVL(COSTING_METHOD,'NA_GDW'),
       NVL(CLASS_ID,-99),
       NVL(LINE_OF_BUSINESS,'NA_GDW'),
       NVL(DISPLAYNAME,'NA_GDW'),
       NVL(DEPARTMENT_ID,-99),
       NVL(COST_CENTER,'NA_GDW'),
       NVL(EXPENSE_ACCOUNT_ID,-99),
       NVL(EXPENSE_ACCOUNT_NUMBER,'NA_GDW'),
       NVL(FEATUREDITEM,'NA_GDW'),
       NVL(FULL_NAME,'NA_GDW'),
       NVL(INCOME_ACCOUNT_ID,-99),
       NVL(INCOME_ACCOUNT_NUMBER,'NA_GDW'),
       NVL(ISBN_ANZ_ID,-99),
       NVL(ISBN_NAME,'NA_GDW'),
       NVL(ISINACTIVE,'NA_GDW'),
       NVL(ITEM_EXTID,'NA_GDW'),
       NVL(ITEM_JDE_CODE_ID,-99),
       NVL(ISBN10,'NA_GDW'),
       NVL(ITEM_TYPE_ID,-99),
       NVL(JDE_ITEM_CODE,'NA_GDW'),
       NVL(LOCATION_ID,-99),
       NVL(LOCATIONS,'NA_GDW'),
       NVL(PARENT_ID,-99),
       NVL(PARENT_NAME,'NA_GDW'),
       NVL(PRODUCT_CALSSIFICATION_ANZ_ID,-99),
       NVL(PRODUCT_CATEGORY_ID,-99),
       NVL(PRODUCT_TYPE_ANZ_ID,-99),
       NVL(PUBLISHER_ID,-99),
       NVL(PURCHASEDESCRIPTION,'NA_GDW'),
       NVL(SALESDESCRIPTION,'NA_GDW'),
       NVL(SELLING_RIGHTS_ID,-99),
       NVL(SERIAL_NUMBER,'NA_GDW'),
       NVL(TYPE_NAME,'NA_GDW'),
       NVL(VENDOR_ID,-99),
       NVL(VENDOR_NAME,'NA_GDW'),
       NVL(VENDRETURN_VARIANCE_ACCOUNT_ID,-99),
 /*      NVL(VENDRETURN_VARIANCE_ACCOUNT_NUMBER,'NA_GDW'),
       NVL(WANG_ITEM_CODE,'NA_GDW'), */
       sysdate,
       '9999-12-31 23:59:59',
       'A'
FROM dw_prestage.items_insert A;

/*==============================================assumed since this is an update the record/s already exists in dim table===========================================================*/ /*===============================================only one record will be there with dw_active column as 'A'========================================================================*/ /* update old record as part of SCD2 maintenance*/ 
UPDATE dw.items
   SET dw_active = 'I',
       DATE_ACTIVE_TO = (sysdate -1)
WHERE dw_active = 'A'
AND   sysdate>= date_active_from
AND   sysdate< date_active_to
AND   EXISTS (SELECT 1 FROM dw_prestage.items_update WHERE dw.items.item_id = dw_prestage.items_update.item_id AND   dw_prestage.items_update.ch_type = 2);

/* insert the new records as part of SCD2 maintenance*/ 
INSERT INTO dw.items
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
  ITEM_JDE_CODE_ID,
  ISBN10,
  ITEM_TYPE_ID,
  JDE_ITEM_CODE,
  LOCATION_ID,
  LOCATION,
  PARENT_ID,
  PARENT_NAME,
  PRODUCT_CALSSIFICATION_ANZ_ID,
  PRODUCT_CATEGORY_ID,
  PRODUCT_TYPE_ANZ_ID,
  PUBLISHER_ID,
  PURCHASEDESCRIPTION,
  SALESDESCRIPTION,
  SELLING_RIGHTS_ID,
  SERIAL_NUMBER,
  TYPE_NAME,
  VENDOR_ID,
  VENDOR_NAME,
  VENDRETURN_VARIANCE_ACCOUNT_ID,
 /* VENDRETURN_VARIANCE_ACCOUNT_NUMBER,
  WANG_ITEM_CODE, */
  DATE_ACTIVE_FROM,
  DATE_ACTIVE_TO,
  DW_ACTIVE
)
SELECT ITEM_ID,
       NVL(NAME,'NA_GDW'),
       NVL(ALLOW_DROP_SHIP,'NA_GDW'),
       NVL(APPLY_FRIEGHT,'NA_GDW'),
       NVL(ASSET_ACCOUNT_ID,-99),
       NVL(ASSET_ACCOUNT_NUMBER,'NA_GDW'),
       NVL(ATP_METHOD,'NA_GDW'),
       NVL(AVAILABLE_TO_PARTNERS,'NA_GDW'),
       NVL(BACKORDERABLE,'NA_GDW'),
       NVL(BILL_EXCH_RATE_VAR_ACCOUNT_ID,-99),
       NVL(BILL_EXCH_RATE_VAR_ACCOUNT_NUMBER,'NA_GDW'),
       NVL(BILL_PRICE_VARIANCE_ACCOUNT_ID,-99),
       NVL(BILL_PRICE_VARIANCE_ACCOUNT_NUMBER,'NA_GDW'),
       NVL(BILL_QTY_VARIANCE_ACCOUNT_ID,-99),
       NVL(BILL_QTY_VARIANCE_ACCOUNT_NUMBER,'NA_GDW'),
       NVL(CARTON_DEPTH,'NA_GDW'),
       NVL(CARTON_HEIGHT,-99),
       NVL(CARTON_QUANTITY,-99),
       NVL(CARTON_WIDTH,'NA_GDW'),
       NVL(COSTING_METHOD,'NA_GDW'),
       NVL(CLASS_ID,-99),
       NVL(LINE_OF_BUSINESS,'NA_GDW'),
       NVL(DISPLAYNAME,'NA_GDW'),
       NVL(DEPARTMENT_ID,-99),
       NVL(COST_CENTER,'NA_GDW'),
       NVL(EXPENSE_ACCOUNT_ID,-99),
       NVL(EXPENSE_ACCOUNT_NUMBER,'NA_GDW'),
       NVL(FEATUREDITEM,'NA_GDW'),
       NVL(FULL_NAME,'NA_GDW'),
       NVL(INCOME_ACCOUNT_ID,-99),
       NVL(INCOME_ACCOUNT_NUMBER,'NA_GDW'),
       NVL(ISBN_ANZ_ID,-99),
       NVL(ISBN_NAME,'NA_GDW'),
       NVL(ISINACTIVE,'NA_GDW'),
       NVL(ITEM_EXTID,'NA_GDW'),
       NVL(ITEM_JDE_CODE_ID,-99),
       NVL(ISBN10,'NA_GDW'),
       NVL(ITEM_TYPE_ID,-99),
       NVL(JDE_ITEM_CODE,'NA_GDW'),
       NVL(LOCATION_ID,-99),
       NVL(LOCATIONS,'NA_GDW'),
       NVL(PARENT_ID,-99),
       NVL(PARENT_NAME,'NA_GDW'),
       NVL(PRODUCT_CALSSIFICATION_ANZ_ID,-99),
       NVL(PRODUCT_CATEGORY_ID,-99),
       NVL(PRODUCT_TYPE_ANZ_ID,-99),
       NVL(PUBLISHER_ID,-99),
       NVL(PURCHASEDESCRIPTION,'NA_GDW'),
       NVL(SALESDESCRIPTION,'NA_GDW'),
       NVL(SELLING_RIGHTS_ID,-99),
       NVL(SERIAL_NUMBER,'NA_GDW'),
       NVL(TYPE_NAME,'NA_GDW'),
       NVL(VENDOR_ID,-99),
       NVL(VENDOR_NAME,'NA_GDW'),
       NVL(VENDRETURN_VARIANCE_ACCOUNT_ID,-99),
   /*    NVL(VENDRETURN_VARIANCE_ACCOUNT_NUMBER,'NA_GDW'),
       NVL(WANG_ITEM_CODE,'NA_GDW'), */
       sysdate,
       '9999-12-31 23:59:59',
       'A'
FROM dw_prestage.items A
WHERE EXISTS (SELECT 1 FROM dw_prestage.items_update WHERE a.item_id = dw_prestage.items_update.item_id AND   dw_prestage.items_update.ch_type = 2);

/* update SCD1 */ 
UPDATE dw.items
   SET NAME = NVL(dw_prestage.items.NAME,'NA_GDW'),
       ALLOW_DROP_SHIP = NVL(dw_prestage.items.ALLOW_DROP_SHIP,'NA_GDW'),
       APPLY_FRIEGHT = NVL(dw_prestage.items.APPLY_FRIEGHT,'NA_GDW'),
       ASSET_ACCOUNT_ID = NVL(dw_prestage.items.ASSET_ACCOUNT_ID,-99),
       ASSET_ACCOUNT_NUMBER = NVL(dw_prestage.items.ASSET_ACCOUNT_NUMBER,'NA_GDW'),
       ATP_METHOD = NVL(dw_prestage.items.ATP_METHOD,'NA_GDW'),
       AVAILABLE_TO_PARTNERS = NVL(dw_prestage.items.AVAILABLE_TO_PARTNERS,'NA_GDW'),
       BACKORDERABLE = NVL(dw_prestage.items.BACKORDERABLE,'NA_GDW'),
       BILL_EXCH_RATE_VAR_ACCOUNT_ID = NVL(dw_prestage.items.BILL_EXCH_RATE_VAR_ACCOUNT_ID,-99),
       BILL_EXCH_RATE_VAR_ACCOUNT_NUMBER = NVL(dw_prestage.items.BILL_EXCH_RATE_VAR_ACCOUNT_NUMBER,'NA_GDW'),
       BILL_PRICE_VARIANCE_ACCOUNT_ID = NVL(dw_prestage.items.BILL_PRICE_VARIANCE_ACCOUNT_ID,-99),
       BILL_PRICE_VARIANCE_ACCOUNT_NUMBER = NVL(dw_prestage.items.BILL_PRICE_VARIANCE_ACCOUNT_NUMBER,'NA_GDW'),
       BILL_QTY_VARIANCE_ACCOUNT_ID = NVL(dw_prestage.items.BILL_QTY_VARIANCE_ACCOUNT_ID,-99),
       BILL_QTY_VARIANCE_ACCOUNT_NUMBER = NVL(dw_prestage.items.BILL_QTY_VARIANCE_ACCOUNT_NUMBER,'NA_GDW'),
       CARTON_DEPTH = NVL(dw_prestage.items.CARTON_DEPTH,'NA_GDW'),
       CARTON_HEIGHT = NVL(dw_prestage.items.CARTON_HEIGHT,-99),
       CARTON_QUANTITY = NVL(dw_prestage.items.CARTON_QUANTITY,-99),
       CARTON_WIDTH = NVL(dw_prestage.items.CARTON_WIDTH,'NA_GDW'),
       COSTING_METHOD = NVL(dw_prestage.items.COSTING_METHOD,'NA_GDW'),
       CLASS_ID = NVL(dw_prestage.items.CLASS_ID,-99),
       LINE_OF_BUSINESS = NVL(dw_prestage.items.LINE_OF_BUSINESS,'NA_GDW'),
       DISPLAYNAME = NVL(dw_prestage.items.DISPLAYNAME,'NA_GDW'),
       DEPARTMENT_ID = NVL(dw_prestage.items.DEPARTMENT_ID,-99),
       COST_CENTER = NVL(dw_prestage.items.COST_CENTER,'NA_GDW'),
       EXPENSE_ACCOUNT_ID = NVL(dw_prestage.items.EXPENSE_ACCOUNT_ID,-99),
       EXPENSE_ACCOUNT_NUMBER = NVL(dw_prestage.items.EXPENSE_ACCOUNT_NUMBER,'NA_GDW'),
       FEATUREDITEM = NVL(dw_prestage.items.FEATUREDITEM,'NA_GDW'),
       FULL_NAME = NVL(dw_prestage.items.FULL_NAME,'NA_GDW'),
       INCOME_ACCOUNT_ID = NVL(dw_prestage.items.INCOME_ACCOUNT_ID,-99),
       INCOME_ACCOUNT_NUMBER = NVL(dw_prestage.items.INCOME_ACCOUNT_NUMBER,'NA_GDW'),
       ISBN_ANZ_ID = NVL(dw_prestage.items.ISBN_ANZ_ID,-99),
       ISBN_NAME = NVL(dw_prestage.items.ISBN_NAME,'NA_GDW'),
       ISINACTIVE = NVL(dw_prestage.items.ISINACTIVE,'NA_GDW'),
       ITEM_EXTID = NVL(dw_prestage.items.ITEM_EXTID,'NA_GDW'),
       ITEM_JDE_CODE_ID = NVL(dw_prestage.items.ITEM_JDE_CODE_ID,-99),
       ISBN10 = NVL(dw_prestage.items.ISBN10,'NA_GDW'),
       ITEM_TYPE_ID = NVL(dw_prestage.items.ITEM_TYPE_ID,-99),
       JDE_ITEM_CODE = NVL(dw_prestage.items.JDE_ITEM_CODE,'NA_GDW'),
       LOCATION_ID = NVL(dw_prestage.items.LOCATION_ID,-99),
       LOCATION = NVL(dw_prestage.items.LOCATIONS,'NA_GDW'),
       PARENT_ID = NVL(dw_prestage.items.PARENT_ID,-99),
       PARENT_NAME = NVL(dw_prestage.items.PARENT_NAME,'NA_GDW'),
       PRODUCT_CALSSIFICATION_ANZ_ID = NVL(dw_prestage.items.PRODUCT_CALSSIFICATION_ANZ_ID,-99),
       PRODUCT_CATEGORY_ID = NVL(dw_prestage.items.PRODUCT_CATEGORY_ID,-99),
       PRODUCT_TYPE_ANZ_ID = NVL(dw_prestage.items.PRODUCT_TYPE_ANZ_ID,-99),
       PUBLISHER_ID = NVL(dw_prestage.items.PUBLISHER_ID,-99),
       PURCHASEDESCRIPTION = NVL(dw_prestage.items.PURCHASEDESCRIPTION,'NA_GDW'),
       SALESDESCRIPTION = NVL(dw_prestage.items.SALESDESCRIPTION,'NA_GDW'),
       SELLING_RIGHTS_ID = NVL(dw_prestage.items.SELLING_RIGHTS_ID,-99),
       SERIAL_NUMBER = NVL(dw_prestage.items.SERIAL_NUMBER,'NA_GDW'),
       TYPE_NAME = NVL(dw_prestage.items.TYPE_NAME,'NA_GDW'),
       VENDOR_ID = NVL(dw_prestage.items.VENDOR_ID,-99),
       VENDOR_NAME = NVL(dw_prestage.items.VENDOR_NAME,'NA_GDW'),
       VENDRETURN_VARIANCE_ACCOUNT_ID = NVL(dw_prestage.items.VENDRETURN_VARIANCE_ACCOUNT_ID,-99)
    /*   VENDRETURN_VARIANCE_ACCOUNT_NUMBER = NVL(dw_prestage.items.VENDRETURN_VARIANCE_ACCOUNT_NUMBER,'NA_GDW'), */
    /*   WANG_ITEM_CODE = NVL(dw_prestage.items.WANG_ITEM_CODE,'NA_GDW') */
FROM dw_prestage.items
WHERE dw.items.item_id = dw_prestage.items.item_id
AND   EXISTS (SELECT 1 FROM dw_prestage.items_update WHERE dw_prestage.items.item_id = dw_prestage.items_update.item_id AND   dw_prestage.items_update.ch_type = 1);

/* logically delete dw records */ 
UPDATE dw.items
   SET DATE_ACTIVE_TO = sysdate -1,
       dw_active = 'I'
FROM dw_prestage.items_delete
WHERE dw.items.item_id = dw_prestage.items_delete.item_id;

COMMIT;

