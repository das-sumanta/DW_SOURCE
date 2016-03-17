SELECT
REPLACE(REPLACE(LOCATIONS.ADDRESS,CHR(10),' '),CHR(13),' ') AS ADDRESS , 
REPLACE(REPLACE(LOCATIONS.ADDRESSEE,CHR(10),' '),CHR(13),' ') AS ADDRESSEE , 
REPLACE(REPLACE(LOCATIONS.ADDRESS_ONE,CHR(10),' '),CHR(13),' ') AS ADDRESS_ONE , 
REPLACE(REPLACE(LOCATIONS.ADDRESS_THREE,CHR(10),' '),CHR(13),' ') AS ADDRESS_THREE , 
REPLACE(REPLACE(LOCATIONS.ADDRESS_TWO,CHR(10),' '),CHR(13),' ') AS ADDRESS_TWO , 
REPLACE(REPLACE(LOCATIONS.ATTENTION,CHR(10),' '),CHR(13),' ') AS ATTENTION , 
REPLACE(REPLACE(LOCATIONS.BRANCH_ID,CHR(10),' '),CHR(13),' ') AS BRANCH_ID , 
CITY , 
COUNTRY , 
TO_CHAR(LOCATIONS.DATE_LAST_MODIFIED,'YYYY-MM-DD HH24:MI:SS') AS DATE_LAST_MODIFIED , 
REPLACE(REPLACE(LOCATIONS.FULL_NAME,CHR(10),' '),CHR(13),' ') AS FULL_NAME , 
INVENTORY_AVAILABLE , 
INVENTORY_AVAILABLE_WEB_STORE , 
ISINACTIVE , 
IS_INCLUDE_IN_SUPPLY_PLANNING , 
TO_CHAR(LOCATIONS.LINE_OF_BUSINESS_ID) AS LINE_OF_BUSINESS_ID , 
REPLACE(REPLACE(LOCATIONS.LOCATION_EXTID,CHR(10),' '),CHR(13),' ') AS LOCATION_EXTID , 
TO_CHAR(LOCATIONS.LOCATION_ID) AS LOCATION_ID , 
NAME , 
TO_CHAR(LOCATIONS.PARENT_ID) AS PARENT_ID , 
REPLACE(REPLACE(LOCATIONS.PHONE,CHR(10),' '),CHR(13),' ') AS PHONE , 
REPLACE(REPLACE(LOCATIONS.RETURNADDRESS,CHR(10),' '),CHR(13),' ') AS RETURNADDRESS , 
REPLACE(REPLACE(LOCATIONS.RETURN_ADDRESS_ONE,CHR(10),' '),CHR(13),' ') AS RETURN_ADDRESS_ONE , 
REPLACE(REPLACE(LOCATIONS.RETURN_ADDRESS_TWO,CHR(10),' '),CHR(13),' ') AS RETURN_ADDRESS_TWO , 
RETURN_CITY , 
RETURN_COUNTRY , 
RETURN_STATE , 
RETURN_ZIPCODE , 
STATE , 
TRAN_NUM_PREFIX , 
ZIPCODE 
FROM
 LOCATIONS
ORDER BY LOCATIONS.LOCATION_ID , NAME ;
