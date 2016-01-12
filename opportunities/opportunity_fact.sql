SELECT
 TRANID AS DOCUMENT_NUMBER
,TRANSACTION_NUMBER
,TRANSACTION_ID
,BOOK_FAIRS_CONSULTANT_ID AS SALES_REP_ID
,SALES_REP_ID AS TERRITORY_ID
,OPEN_DATE
,SHIP_DATE
,CLOSE_DATE
,RETURN_DATE
,FORECAST_TYPE
,ABCDO_MARKER_ID
,BOOK_FAIRS_STATUS_ID
,BOOK_FAIR_TYPE_ID
,TRUCK_ROUTE_ID
,BOOK_FAIRS_INV__OPTIONS_ID AS INVOICE_OPTION_ID
,c.BILL_ADDRESS_LINE_1
,c.BILL_ADDRESS_LINE_2
,c.BILL_ADDRESS_LINE_3
,c.BILL_CITY
,c.BILL_COUNTRY
,c.BILL_STATE
,c.BILL_ZIP
,c.SHIP_ADDRESS_LINE_1
,c.SHIP_ADDRESS_LINE_2
,c.SHIP_ADDRESS_LINE_3
,c.SHIP_CITY
,c.SHIP_COUNTRY
,c.SHIP_STATE
,c.SHIP_ZIP
,STATUS
,CURRENCY_ID
,TRANDATE
,EXCHANGE_RATE
,ROLL_SIZE
,PROJECTED_TOTAL
,WEIGHTED_TOTAL
,LOCATION_ID
,'27' AS SUBSIDIARY_ID
,ACCOUNTING_PERIOD_ID
,ENTITY_ID AS CUSTOMER_ID
,CUSTOM_FORM_ID
,CREATED_BY_ID
,CREATE_DATE
,DATE_LAST_MODIFIED
FROM
TRANSACTIONS A
 LEFT OUTER JOIN transaction_address c ON (TRANSACTIONS.transaction_id = transaction_address.transaction_id)
WHERE TRANSACTION_TYPE = 'Opportunity'
AND EXISTS ( SELECT 1 FROM TRANSACTION_LINES B
WHERE A.TRANSACTION_ID = B.TRANSACTION_ID 
AND B.SUBSIDIARY_ID = 27)
AND   (TRANSACTIONS.DATE_LAST_MODIFIED >= to_timestamp('%s','YYYY-MM-DD HH24:MI:SS')
ORDER BY DOCUMENT_NUMBER,TRANSACTION_ID;