SELECT TO_CHAR(TAX_ITEMS.ACCOUNT_CLASSIFICATION_ROYA_ID) AS ACCOUNT_CLASSIFICATION_ROYA_ID,
       APPLY_FRIEGHT,
       REPLACE(REPLACE(TAX_ITEMS.AUTHORPUBLISHER,CHR(10),' '),CHR(13),' ') AS AUTHORPUBLISHER,
       BACKORDERABLE,
       REPLACE(REPLACE(TAX_ITEMS.CARTON_DEPTH,CHR(10),' '),CHR(13),' ') AS CARTON_DEPTH,
       CARTON_HEIGHT,
       CARTON_QUANTITY,
       REPLACE(REPLACE(TAX_ITEMS.CARTON_WEIGHT,CHR(10),' '),CHR(13),' ') AS CARTON_WEIGHT,
       REPLACE(REPLACE(TAX_ITEMS.CARTON_WIDTH,CHR(10),' '),CHR(13),' ') AS CARTON_WIDTH,
       TO_CHAR(TAX_ITEMS.CATALOGUE_USE_ID) AS CATALOGUE_USE_ID,
       COC_TEST_REPORT_REQUIRED,
       COMMODITY_CODE,
       TO_CHAR(TAX_ITEMS.DATE_LAST_MODIFIED,'YYYY-MM-DD HH24:MI:SS') AS DATE_LAST_MODIFIED,
       TO_CHAR(TAX_ITEMS.DEFAULT_WT_CODE_ID) AS DEFAULT_WT_CODE_ID,
       REPLACE(REPLACE(TAX_ITEMS.DESCRIPTION,CHR(10),' '),CHR(13),' ') AS DESCRIPTION,
       REPLACE(REPLACE(TAX_ITEMS.FULL_NAME,CHR(10),' '),CHR(13),' ') AS FULL_NAME,
       TO_CHAR(TAX_ITEMS.INCOME_ACCOUNT_ID) AS INCOME_ACCOUNT_ID,
       REPLACE(REPLACE(TAX_ITEMS.ISBN10,CHR(10),' '),CHR(13),' ') AS ISBN10,
       TO_CHAR(TAX_ITEMS.ISBN_ID) AS ISBN_ANZ_ID,
       ISINACTIVE,
       REPLACE(REPLACE(TAX_ITEMS.ITEM_EXTID,CHR(10),' '),CHR(13),' ') AS ITEM_EXTID,
       TO_CHAR(TAX_ITEMS.ITEM_ID) AS ITEM_ID,
       TO_CHAR(TAX_ITEMS.ITEM_JDE_CODE_ID) AS ITEM_JDE_CODE_ID,
       TO_CHAR(TAX_ITEMS.ITEM_TYPE_ID) AS ITEM_TYPE_ID,
       TO_CHAR(TAX_ITEMS.LAUNCH_DATE,'YYYY-MM-DD HH24:MI:SS') AS LAUNCH_DATE,
       TO_CHAR(TAX_ITEMS.LEVEL_ID) AS LEVEL_ID,
       LEXILE,
       REPLACE(REPLACE(TAX_ITEMS.NAME,CHR(10),' '),CHR(13),' ') AS NAME,
       TO_CHAR(TAX_ITEMS.NATURE_OF_TRANSACTION_CODES_ID) AS NATURE_OF_TRANSACTION_CODES_ID,
       NO__OF_ISSUES,
       PAGE_COUNT,
       REPLACE(REPLACE(TAX_ITEMS.PALM_ISBN,CHR(10),' '),CHR(13),' ') AS PALM_ISBN,
       TO_CHAR(TAX_ITEMS.PARENT_ID) AS PARENT_ID,
       TO_CHAR(TAX_ITEMS.PLANNERBUYER_NUMBER_ID) AS PLANNERBUYER_NUMBER_ID,
       TO_CHAR(TAX_ITEMS.PLANNER_ID) AS PLANNER_ID,
       TO_CHAR(TAX_ITEMS.PRODUCT_CATEGORY_ID) AS PRODUCT_CATEGORY_ID,
       TO_CHAR(TAX_ITEMS.PRODUCT_CLASSIFICATION_ID) AS PRODUCT_CLASSIFICATION_ID,
       TO_CHAR(TAX_ITEMS.PRODUCT_SERIESFAMILY_ID) AS PRODUCT_SERIESFAMILY_ID,
       TO_CHAR(TAX_ITEMS.PRODUCT_TYPE_ANZ_ID) AS PRODUCT_TYPE_ANZ_ID,
       TO_CHAR(TAX_ITEMS.PRODUCT_TYPE_ID) AS PRODUCT_TYPE_ID,
       TO_CHAR(TAX_ITEMS.PUBLISHER_ID) AS PUBLISHER_ID,
       RATE,
       ROYALTY_MARKER,
       TO_CHAR(TAX_ITEMS.SEIS_LAUNCH_DATE,'YYYY-MM-DD HH24:MI:SS') AS SEIS_LAUNCH_DATE,
       TO_CHAR(TAX_ITEMS.SEIS_PRODUCT_CATEGORY_ID) AS SEIS_PRODUCT_CATEGORY_ID,
       TO_CHAR(TAX_ITEMS.SEIS_PRODUCT_SERIESFAMILY_ID) AS SEIS_PRODUCT_SERIESFAMILY_ID,
       TO_CHAR(TAX_ITEMS.SEIS_PRODUCT_TYPE_ID) AS SEIS_PRODUCT_TYPE_ID,
       TO_CHAR(TAX_ITEMS.SELLING_RIGHTS_ID) AS SELLING_RIGHTS_ID,
       TO_CHAR(TAX_ITEMS.SERIAL_MARKER_ID) AS SERIAL_MARKER_ID,
       REPLACE(REPLACE(TAX_ITEMS.SERIAL_NUMBER,CHR(10),' '),CHR(13),' ') AS SERIAL_NUMBER,
       SOR_TAG,
       TO_CHAR(TAX_ITEMS.SYNC_TO_WMS_ID) AS SYNC_TO_WMS_ID,
       REPLACE(REPLACE(TAX_ITEMS.TAX_CITY,CHR(10),' '),CHR(13),' ') AS TAX_CITY,
       TAX_COUNTY,
       TAX_STATE,
       REPLACE(REPLACE(TAX_ITEMS.TAX_ZIPCODE,CHR(10),' '),CHR(13),' ') AS TAX_ZIPCODE,
       TO_CHAR(TAX_ITEMS.TRADE_RELEASE_DATE_1,'YYYY-MM-DD HH24:MI:SS') AS TRADE_RELEASE_DATE_1,
       TO_CHAR(TAX_ITEMS.TRADE_RELEASE_DATE_2,'YYYY-MM-DD HH24:MI:SS') AS TRADE_RELEASE_DATE_2,
       TO_CHAR(TAX_ITEMS.UOM_ID) AS UOM_ID,
       REPLACE(REPLACE(TAX_ITEMS.US_ISBN,CHR(10),' '),CHR(13),' ') AS US_ISBN,
       VENDORNAME,
       TO_CHAR(TAX_ITEMS.VENDOR_ID) AS VENDOR_ID,
       REPLACE(REPLACE(TAX_ITEMS.WANG_ITEM_CODE,CHR(10),' '),CHR(13),' ') AS WANG_ITEM_CODE,
       REPLACE(REPLACE(TAX_ITEMS.WEIGHT,CHR(10),' '),CHR(13),' ') AS WEIGHT,
       WEIGHT_KG,
	   ACCOUNTS.ACCOUNTNUMBER AS INCOME_ACCOUNT_NUMBER,
	   ACCOUNTS.FULL_NAME AS INCOME_ACCOUNT_NAME
   FROM
	 TAX_ITEMS,
	 ACCOUNTS
	 WHERE TAX_ITEMS.INCOME_ACCOUNT_ID = ACCOUNTS.ACCOUNT_ID(+)
	 ORDER BY TAX_ITEMS.ITEM_ID;
	   
