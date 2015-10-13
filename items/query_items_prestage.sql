SELECT
1 as runid,
ALLOW_DROP_SHIP , 
APPLY_FRIEGHT , 
TO_CHAR(A.ASSET_ACCOUNT_ID) AS ASSET_ACCOUNT_ID , 
E.ACCOUNTNUMBER AS ASSET_ACCOUNT_NUMBER,
REPLACE(REPLACE(A.ATP_METHOD,CHR(10),' '),CHR(13),' ') AS ATP_METHOD , 
AVAILABLE_TO_PARTNERS , 
BACKORDERABLE , 
TO_CHAR(A.BILL_EXCH_RATE_VAR_ACCOUNT_ID) AS BILL_EXCH_RATE_VAR_ACCOUNT_ID , 
F.ACCOUNTNUMBER AS BILL_EXCH_RATE_VAR_ACCOUNT_NUMBER,
TO_CHAR(A.BILL_PRICE_VARIANCE_ACCOUNT_ID) AS BILL_PRICE_VARIANCE_ACCOUNT_ID , 
G.ACCOUNTNUMBER AS BILL_PRICE_VARIANCE_ACCOUNT_NUMBER,
TO_CHAR(A.BILL_QTY_VARIANCE_ACCOUNT_ID) AS BILL_QTY_VARIANCE_ACCOUNT_ID , 
H.ACCOUNTNUMBER AS BILL_QTY_VARIANCE_ACCOUNT_NUMBER,
REPLACE(REPLACE(A.CARTON_DEPTH,CHR(10),' '),CHR(13),' ') AS CARTON_DEPTH , 
CARTON_HEIGHT , 
CARTON_QUANTITY , 
/*REPLACE(REPLACE(A.CARTON_WEIGHT,CHR(10),' '),CHR(13),' ') AS CARTON_WEIGHT , */
REPLACE(REPLACE(A.CARTON_WIDTH,CHR(10),' '),CHR(13),' ') AS CARTON_WIDTH , 
TO_CHAR(A.CLASS_ID) AS CLASS_ID , 
I.NAME AS LINE_OF_BUSINESS,
COSTING_METHOD , 
TO_CHAR(A.CREATED,'YYYY-MM-DD HH24:MI:SS') AS CREATED , 
TO_CHAR(A.DATE_LAST_MODIFIED,'YYYY-MM-DD HH24:MI:SS') AS DATE_LAST_MODIFIED , 
TO_CHAR(A.DEPARTMENT_ID) AS DEPARTMENT_ID , 
J.NAME AS COST_CENTER,
REPLACE(REPLACE(A.DISPLAYNAME,CHR(10),' '),CHR(13),' ') AS DISPLAYNAME , 
TO_CHAR(A.EXPENSE_ACCOUNT_ID) AS EXPENSE_ACCOUNT_ID , 
K.ACCOUNTNUMBER AS EXPENSE_ACCOUNT_NUMBER,
FEATUREDITEM , 
REPLACE(REPLACE(A.FULL_NAME,CHR(10),' '),CHR(13),' ') AS FULL_NAME , 
TO_CHAR(A.INCOME_ACCOUNT_ID) AS INCOME_ACCOUNT_ID , 
L.ACCOUNTNUMBER AS INCOME_ACCOUNT_NUMBER,
REPLACE(REPLACE(A.ISBN10,CHR(10),' '),CHR(13),' ') AS ISBN10 , 
TO_CHAR(A.ISBN_ANZ_ID) AS ISBN_ANZ_ID ,
M.ISBN_NAME ,  
ISINACTIVE , 
REPLACE(REPLACE(A.ITEM_EXTID,CHR(10),' '),CHR(13),' ') AS ITEM_EXTID , 
TO_CHAR(A.ITEM_ID) AS ITEM_ID , 
TO_CHAR(A.ITEM_JDE_CODE_ID) AS ITEM_JDE_CODE_ID , 
TO_CHAR(A.ITEM_TYPE_ID) AS ITEM_TYPE_ID , 
REPLACE(REPLACE(A.JDE_ITEM_CODE,CHR(10),' '),CHR(13),' ') AS JDE_ITEM_CODE , 
TO_CHAR(A.LOCATION_ID) AS LOCATION_ID , 
X.NAME AS LOCATIONS,
REPLACE(REPLACE(A.NAME,CHR(10),' '),CHR(13),' ') AS NAME , 
TO_CHAR(A.PARENT_ID) AS PARENT_ID , 
O.NAME AS PARENT_NAME,
TO_CHAR(A.PRODUCT_CALSSIFICATION_ANZ_ID) AS PRODUCT_CALSSIFICATION_ANZ_ID , 
TO_CHAR(A.PRODUCT_CATEGORY_ID) AS PRODUCT_CATEGORY_ID , 
TO_CHAR(A.PRODUCT_CLASSIFICATION_ID) AS PRODUCT_CLASSIFICATION_ID , 
TO_CHAR(A.PRODUCT_SERIESFAMILY_ID) AS PRODUCT_SERIESFAMILY_ID , 
TO_CHAR(A.PRODUCT_TYPE_ANZ_ID) AS PRODUCT_TYPE_ANZ_ID , 
TO_CHAR(A.PRODUCT_TYPE_ID) AS PRODUCT_TYPE_ID , 
TO_CHAR(A.PROD_PRICE_VAR_ACCOUNT_ID) AS PROD_PRICE_VAR_ACCOUNT_ID , 
P.ACCOUNTNUMBER AS PROD_PRICE_VAR_ACCOUNT_NUMBER,
TO_CHAR(A.PROD_QTY_VAR_ACCOUNT_ID) AS PROD_QTY_VAR_ACCOUNT_ID , 
P.ACCOUNTNUMBER AS PROD_QTY_VAR_ACCOUNT_NUMBER,
TO_CHAR(A.PUBLISHER_ID) AS PUBLISHER_ID , 
REPLACE(REPLACE(A.PURCHASEDESCRIPTION,CHR(10),' '),CHR(13),' ') AS PURCHASEDESCRIPTION , 
REPLACE(REPLACE(A.SALESDESCRIPTION,CHR(10),' '),CHR(13),' ') AS SALESDESCRIPTION , 
TO_CHAR(A.SELLING_RIGHTS_ID) AS SELLING_RIGHTS_ID , 
REPLACE(REPLACE(A.SERIAL_NUMBER,CHR(10),' '),CHR(13),' ') AS SERIAL_NUMBER , 
REPLACE(REPLACE(A.SPECIALSDESCRIPTION,CHR(10),' '),CHR(13),' ') AS SPECIALSDESCRIPTION , 
TYPE_NAME , 
TO_CHAR(A.VENDOR_ID) AS VENDOR_ID , 
R.NAME AS VENDOR_NAME,
TO_CHAR(A.VENDRETURN_VARIANCE_ACCOUNT_ID) AS VENDRETURN_VARIANCE_ACCOUNT_ID 
/*REPLACE(REPLACE(A.WANG_ITEM_CODE,CHR(10),' '),CHR(13),' ') AS WANG_ITEM_CODE */
FROM
ITEMS A
INNER JOIN ITEM_SUBSIDIARY_MAP B ON (A.ITEM_ID = B.ITEM_ID  )
INNER JOIN SUBSIDIARIES C ON (B.SUBSIDIARY_ID = C.SUBSIDIARY_ID AND C.NAME = 'Scholastic New Zealand Limited' )
LEFT OUTER JOIN ACCOUNTS E ON (A.ASSET_ACCOUNT_ID = E.ACCOUNT_ID)
LEFT OUTER JOIN ACCOUNTS F ON (A.BILL_EXCH_RATE_VAR_ACCOUNT_ID = F.ACCOUNT_ID)
LEFT OUTER JOIN ACCOUNTS G ON (A.BILL_PRICE_VARIANCE_ACCOUNT_ID = G.ACCOUNT_ID)
LEFT OUTER JOIN ACCOUNTS H ON (A.BILL_QTY_VARIANCE_ACCOUNT_ID = H.ACCOUNT_ID)
LEFT OUTER JOIN CLASSES I ON (A.CLASS_ID = I.CLASS_ID)
LEFT OUTER JOIN DEPARTMENTS J ON (A.DEPARTMENT_ID = J.DEPARTMENT_ID)
LEFT OUTER JOIN ACCOUNTS K ON (A.EXPENSE_ACCOUNT_ID = K.ACCOUNT_ID)
LEFT OUTER JOIN ACCOUNTS L ON (A.INCOME_ACCOUNT_ID = L.ACCOUNT_ID)
LEFT OUTER JOIN ISBN M ON (A.ISBN_ANZ_ID = M.ISBN_ID)
LEFT OUTER JOIN LOCATIONS X ON (A.LOCATION_ID = X.LOCATION_ID)
LEFT OUTER JOIN ITEMS O ON (A.PARENT_ID = O.ITEM_ID)
LEFT OUTER JOIN ACCOUNTS P ON (A.PROD_PRICE_VAR_ACCOUNT_ID = P.ACCOUNT_ID)
LEFT OUTER JOIN ACCOUNTS Q ON (A.PROD_QTY_VAR_ACCOUNT_ID = Q.ACCOUNT_ID)
LEFT OUTER JOIN VENDORS R ON (A.VENDOR_ID = R.VENDOR_ID)
where not exists ( select 1 from tax_items D
where D.item_id = A.item_id )
AND A.DATE_LAST_MODIFIED >= '1900-01-01 00:00:00';