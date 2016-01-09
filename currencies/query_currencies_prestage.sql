SELECT
REPLACE(REPLACE(CURRENCIES.CURRENCY_EXTID,CHR(10),' '),CHR(13),' ') AS CURRENCY_EXTID , 
TO_CHAR(CURRENCIES.CURRENCY_ID) AS CURRENCY_ID , 
TO_CHAR(CURRENCIES.DATE_LAST_MODIFIED,'YYYY-MM-DD HH24:MI:SS') AS DATE_LAST_MODIFIED , 
IS_INACTIVE , 
REPLACE(REPLACE(CURRENCIES.NAME,CHR(10),' '),CHR(13),' ') AS NAME , 
PRECISION_0 , 
SYMBOL 
FROM
CURRENCIES;

