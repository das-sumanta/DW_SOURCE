SELECT
   TO_CHAR(BUDGETFORECAST_ID) AS BUDGETFORECAST_ID
  ,BUDGETFORECAST_NAME
  ,TO_CHAR(FISCAL_MONTH_ID) AS FISCAL_MONTH_ID
  ,TO_CHAR(FISCAL_WEEK_ID) AS FISCAL_WEEK_ID
  ,TO_CHAR(LINE_OF_BUSINESS_ID) AS LINE_OF_BUSINESS_ID
  ,TO_CHAR(REGIONSALES_TERRITORY_ID) AS REGIONSALES_TERRITORY_ID
  ,TO_CHAR(SUBSIDIARY_ID) AS SUBSIDIARY_ID
  ,TO_CHAR(MONTH_END_DATE,'YYYY-MM-DD HH24:MI:SS') AS MONTH_END_DATE  
  ,TO_CHAR(MONTH_START_DATE,'YYYY-MM-DD HH24:MI:SS') AS MONTH_START_DATE
  ,TO_CHAR(WEEK_START_DATE,'YYYY-MM-DD HH24:MI:SS') AS WEEK_START_DATE
  ,TO_CHAR(WEEK_END_DATE,'YYYY-MM-DD HH24:MI:SS') AS WEEK_END_DATE
  ,TO_CHAR(AMOUNT) AS AMOUNT
  ,TO_CHAR(DATE_CREATED,'YYYY-MM-DD HH24:MI:SS') AS DATE_CREATED
  ,IS_INACTIVE
  ,TO_CHAR(LAST_MODIFIED_DATE,'YYYY-MM-DD HH24:MI:SS') AS LAST_MODIFIED_DATE
  ,B.LIST_ITEM_NAME AS BUDGETFORECAST_TYPE
  FROM
  BUDGETFORECAST A,
  BUDGETFORECAST_LIST B
  WHERE 
  A.TYPE_ID  = B.LIST_ID
  AND A.SUBSIDIARY_ID = '%s'
  AND A.LAST_MODIFIED_DATE >= TO_TIMESTAMP('%s','YYYY-MM-DD HH24:MI:SS')