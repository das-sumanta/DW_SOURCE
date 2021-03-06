SELECT 1 as runid,
       TO_CHAR(TRANSACTIONS.TRANSACTION_ID) AS TRANSACTION_ID,
       REPLACE(REPLACE(TRANSACTIONS.TRANSACTION_NUMBER,CHR (10),' '),CHR (13),' ') AS PO_NUMBER,
       TRANSACTION_LINES.TRANSACTION_LINE_ID,
       TO_CHAR(TRANSACTIONS.ENTITY_ID) AS VENDOR_ID,
       TO_CHAR(TRANSACTIONS.APPROVER_LEVEL_ONE_ID) AS APPROVER_LEVEL_ONE_ID,
       TO_CHAR(TRANSACTIONS.APPROVER_LEVEL_TWO_ID) AS APPROVER_LEVEL_TWO_ID,
       TRANSACTIONS.AMOUNT_UNBILLED,   /* header level amount */
       REPLACE(REPLACE(TRANSACTIONS.APPROVAL_STATUS,CHR (10),' '),CHR (13),' ') AS APPROVAL_STATUS,
       REPLACE(REPLACE(TRANSACTIONS.BILLADDRESS,CHR (10),' '),CHR (13),' ') AS BILLADDRESS,
       REPLACE(REPLACE(TRANSACTIONS.CARRIER,CHR (10),' '),CHR (13),' ') AS CARRIER,
       REPLACE(REPLACE(TRANSACTIONS.CARRIER_ADDRESS,CHR (10),' '),CHR (13),' ') AS CARRIER_ADDRESS,
       TO_CHAR(TRANSACTIONS.CARRIER_LEBEL_ID) AS CARRIER_LEBEL_ID,
       TO_CHAR(TRANSACTIONS.CLOSED,'YYYY-MM-DD HH24:MI:SS') AS CLOSED,
       TO_CHAR(TRANSACTIONS.CREATED_BY_ID) AS CREATED_BY_ID,
       TO_CHAR(TRANSACTIONS.SALES_REP_ID) AS REQUESTOR_ID,
       TO_CHAR(TRANSACTIONS.CREATED_FROM_ID) AS CREATED_FROM_ID,
       TO_CHAR(TRANSACTIONS.CREATE_DATE,'YYYY-MM-DD HH24:MI:SS') AS CREATE_DATE,
       TO_CHAR(TRANSACTIONS.CURRENCY_ID) AS CURRENCY_ID,
       TO_CHAR(TRANSACTIONS.CUSTOM_FORM_ID) AS CUSTOM_FORM_ID,
       TO_CHAR(TRANSACTIONS.DATE_LAST_MODIFIED,'YYYY-MM-DD HH24:MI:SS') AS DATE_LAST_MODIFIED,
       TO_CHAR(TRANSACTIONS.EMPLOYEE_CUSTOM_ID) AS EMPLOYEE_CUSTOM_ID,
       TRANSACTIONS.EXCHANGE_RATE,
       TO_CHAR(TRANSACTIONS.LOCATION_ID) AS LOCATION_ID,
       TO_CHAR(TRANSACTIONS.PO_APPROVER_ID) AS PO_APPROVER_ID,
       REPLACE(REPLACE(TRANSACTIONS.SHIPADDRESS,CHR (10),' '),CHR (13),' ') AS SHIPADDRESS,
       TO_CHAR(TRANSACTION_LINES.SHIPMENT_RECEIVED,'YYYY-MM-DD HH24:MI:SS') AS SHIPMENT_RECEIVED,
       REPLACE(REPLACE(TRANSACTIONS.STATUS,CHR (10),' '),CHR (13),' ') AS PO_STATUS,
       TO_CHAR(TRANSACTIONS.PAYMENT_TERMS_ID) AS PAYMENT_TERMS_ID,
       TRANSACTION_LINES.FRIGHT_RATE,
       DECODE(CUSTOM_FORM_ID,
             199,'INTL Inventory Purchase Order',
             201,'INTL Drop Ship Purchase Order',
             202,'INTL Non-Inventory Purchase Order'
       ) AS PO_TYPE,
       TO_CHAR(TRANSACTION_LINES.SUBSIDIARY_ID) AS SUBSIDIARY_ID,
       TO_CHAR(TRANSACTION_LINES.DEPARTMENT_ID) AS DEPARTMENT_ID,
       TO_CHAR(TRANSACTION_LINES.ITEM_ID) AS ITEM_ID,
       TRANSACTION_LINES.BC_QUANTITY,
       TRANSACTION_LINES.BIH_QUANTITY,
       TRANSACTION_LINES.BOOK_FAIR_QUANTITY,
       TRANSACTION_LINES.EDUCATION_QUANTITY,
       TRANSACTION_LINES.NZSO_QUANTITY,
       TRANSACTION_LINES.TRADE_QUANTITY,
       TRANSACTION_LINES.SCHOOL_ESSENTIALS_QUANTITY,
       TRANSACTION_LINES.ITEM_COUNT,
       TRANSACTION_LINES.ITEM_GROSS_AMOUNT,
       TRANSACTION_LINES.AMOUNT,
	TRANSACTION_LINES.AMOUNT_FOREIGN,
	TRANSACTION_LINES.NET_AMOUNT,
	TRANSACTION_LINES.NET_AMOUNT_FOREIGN,
	TRANSACTION_LINES.GROSS_AMOUNT ,
	TRANSACTION_LINES.MATCH_BILL_TO_RECEIPT ,
	TRANSACTION_LINES.TRACK_LANDED_COST  ,
       TRANSACTION_LINES.ITEM_UNIT_PRICE,
       TO_CHAR(TRANSACTION_LINES.EXPECTED_RECEIPT_DATE,'YYYY-MM-DD HH24:MI:SS') AS EXPECTED_RECEIPT_DATE,
       TO_CHAR(TRANSACTION_LINES.ACTUAL_DELIVERY_DATE,'YYYY-MM-DD HH24:MI:SS') AS ACTUAL_DELIVERY_DATE,
       TO_CHAR(TRANSACTION_LINES.TAX_ITEM_ID) AS TAX_ITEM_ID,
       TRANSACTION_LINES.TAX_TYPE,
	   C.AMOUNT_FOREIGN AS TAX_AMOUNT,
       TO_CHAR(TRANSACTION_LINES.FREIGHT_ESTIMATE_METHOD_ID) AS FREIGHT_ESTIMATE_METHOD_ID,
       /* custom fields for po lines */  Decode(b.name,
             'Purchase Orders','PO_HDR',
             decode(c.transaction_line_id,NULL,'PO_TAX','PO_LINE')
       )  AS line_type,
       TRANSACTION_LINES.CLASS_ID
FROM TRANSACTION_LINES
  LEFT OUTER JOIN accounts b ON (TRANSACTION_LINES.account_id = accounts.account_id)
  LEFT OUTER JOIN transaction_tax_detail c
               ON (TRANSACTION_LINES.transaction_id = transaction_tax_detail.transaction_id
              AND TRANSACTION_LINES.transaction_line_id = transaction_tax_detail.transaction_line_id)
  INNER JOIN transactions d ON (TRANSACTION_LINES.transaction_id = transactions.transaction_id)
WHERE transactions.transaction_type = 'Purchase Order'
AND   (TRANSACTION_LINES.DATE_LAST_MODIFIED >= '2015-06-01 00:00:00' OR TRANSACTIONS.DATE_LAST_MODIFIED >= '2015-06-01 00:00:00')
and transaction_lines.subsidiary_id = 27
AND TRANSACTION_LINES.transaction_id  = 378175
ORDER BY TRANSACTION_LINES.transaction_id,
         TRANSACTION_LINES.transaction_line_id;
