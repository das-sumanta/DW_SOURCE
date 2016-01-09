SELECT
TO_CHAR(BASE_CURRENCY_ID) AS BASE_CURRENCY_ID , 
REPLACE(REPLACE(BRANCH_ID,CHR(10),'\'||CHR(10)),CHR(13),'\'||CHR(13)) AS BRANCH_ID , 
BRN , 
TO_CHAR(DATE_LAST_MODIFIED,'YYYY-MM-DD HH24:MI:SS') AS DATE_LAST_MODIFIED , 
EDITION , 
FEDERAL_NUMBER , 
TO_CHAR(FISCAL_CALENDAR_ID) AS FISCAL_CALENDAR_ID , 
REPLACE(REPLACE(FULL_NAME,CHR(10),'\'||CHR(10)),CHR(13),'\'||CHR(13)) AS FULL_NAME , 
ISINACTIVE , 
IS_ELIMINATION , 
IS_MOSS , 
REPLACE(REPLACE(LEGAL_ENTITY_ACCOUNT_CODE,CHR(10),'\'||CHR(10)),CHR(13),'\'||CHR(13)) AS LEGAL_ENTITY_ACCOUNT_CODE , 
LEGAL_NAME , 
TO_CHAR(MOSS_NEXUS_ID) AS MOSS_NEXUS_ID , 
NAME , 
TO_CHAR(PARENT_ID) AS PARENT_ID , 
PURCHASEORDERAMOUNT , 
PURCHASEORDERQUANTITY , 
PURCHASEORDERQUANTITYDIFF , 
RECEIPTAMOUNT , 
RECEIPTQUANTITY , 
RECEIPTQUANTITYDIFF , 
STATE_TAX_NUMBER , 
REPLACE(REPLACE(SUBSIDIARY_EXTID,CHR(10),'\'||CHR(10)),CHR(13),'\'||CHR(13)) AS SUBSIDIARY_EXTID , 
TO_CHAR(SUBSIDIARY_ID) AS SUBSIDIARY_ID , 
TRAN_NUM_PREFIX , 
UEN , 
URL ,
CURRENCIES.NAME AS CURRENCY
FROM
SUBSIDIARIES ,
CURRENCIES
WHERE SUBSIDIARIES.BASE_CURRENCY_ID = CURRENCIES.CURRENCY_ID(+);
