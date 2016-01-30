/* error prestage - drop intermediate error prestage table */
DROP TABLE IF EXISTS DW_PRESTAGE.REVENUE_FACT_ERROR;

/* prestage - create intermediate insert table*/
CREATE TABLE DW_PRESTAGE.REVENUE_FACT_ERROR
AS
SELECT
  A.RUNID
, A.DOCUMENT_NUMBER
,A.TRANSACTION_ID
,A.TRANSACTION_LINE_ID
,A.REF_DOC_NUMBER
,NVL(A.REF_DOC_TYPE_KEY,N.TRANSACTION_TYPE_KEY)  REF_DOC_TYPE_KEY
,NVL(A.TERMS_KEY,B.PAYMENT_TERM_KEY)  TERMS_KEY
,A.REVENUE_COMMITMENT_STATUS
,A.REVENUE_STATUS
,NVL(A.SALES_REP_KEY,R.EMPLOYEE_KEY)  SALES_REP_KEY
,NVL(A.TERRITORY_KEY,C.TERRITORY_KEY)  TERRITORY_KEY
,A.BILL_ADDRESS_LINE_1
,A.BILL_ADDRESS_LINE_2
,A.BILL_ADDRESS_LINE_3
,A.BILL_CITY
,A.BILL_COUNTRY
,A.BILL_STATE
,A.BILL_ZIP
,A.SHIP_ADDRESS_LINE_1
,A.SHIP_ADDRESS_LINE_2
,A.SHIP_ADDRESS_LINE_3
,A.SHIP_CITY
,A.SHIP_COUNTRY
,A.SHIP_STATE
,A.SHIP_ZIP
,NVL(A.DOCUMENT_STATUS_KEY,O.TRANSACTION_STATUS_KEY)   DOCUMENT_STATUS_KEY
,NVL(A.DOCUMENT_TYPE_KEY,P.TRANSACTION_TYPE_KEY)     DOCUMENT_TYPE_KEY
,NVL(A.CURRENCY_KEY,D.CURRENCY_KEY)  CURRENCY_KEY
,NVL(A.TRANSACTION_DATE_KEY,E.DATE_KEY)  TRANSACTION_DATE_KEY
,EXCHANGE_RATE
,NVL(A.ACCOUNT_KEY,F.ACCOUNT_KEY)  ACCOUNT_KEY
,A.AMOUNT
,A.AMOUNT_FOREIGN
,A.GROSS_AMOUNT
,A.NET_AMOUNT
,A.NET_AMOUNT_FOREIGN
,A.QUANTITY
 ,NVL(A.ITEM_KEY,G.ITEM_KEY)  ITEM_KEY
 ,A.RATE
 ,NVL(A.TAX_ITEM_KEY,H.TAX_ITEM_KEY)  TAX_ITEM_KEY
 ,TAX_AMOUNT
 ,NVL(A.LOCATION_KEY,K.LOCATION_KEY)  LOCATION_KEY
 ,NVL(A.CLASS_KEY,L.CLASS_KEY)  CLASS_KEY
 ,NVL(A.SUBSIDIARY_KEY,J.SUBSIDIARY_KEY)  SUBSIDIARY_KEY
 ,NVL(A.CUSTOMER_KEY,M.CUSTOMER_KEY)  CUSTOMER_KEY
 ,NVL(A.ACCOUNTING_PERIOD_KEY,Q.ACCOUNTING_PERIOD_KEY)  ACCOUNTING_PERIOD_KEY
 ,A.REF_CUSTOM_FORM_ID
,'PROCESSED'  RECORD_STATUS
,SYSDATE  DW_CREATION_DATE
 FROM DW.REVENUE_FACT_ERROR A
 INNER JOIN DW_REPORT.PAYMENT_TERMS B ON (A.PAYMENT_TERMS_ID = B.PAYMENT_TERMS_ID)
 INNER JOIN DW_REPORT.TERRITORIES C ON (A.SALES_TERRITORY_ID = C.TERRITORY_ID)
 INNER JOIN DW_REPORT.CURRENCIES D ON (A.CURRENCY_ID = D.CURRENCY_ID)
 INNER JOIN DW_REPORT.DWDATE E ON (TO_CHAR (A.TRANDATE,'YYYYMMDD') = E.DATE_ID)
 INNER JOIN DW_REPORT.ACCOUNTS F ON (A.ACCOUNT_ID = F.ACCOUNT_ID)
 INNER JOIN DW_REPORT.ITEMS G ON (A.ITEM_ID = G.ITEM_ID)
 INNER JOIN DW_REPORT.TAX_ITEMS H ON (A.TAX_ITEM_ID = H.ITEM_ID)
 INNER JOIN DW_REPORT.SUBSIDIARIES J ON (A.SUBSIDIARY_ID = J.SUBSIDIARY_ID)
 INNER JOIN DW_REPORT.LOCATIONS K ON (A.LOCATION_ID = K.LOCATION_ID)
 INNER JOIN DW_REPORT.CLASSES L ON (A.CLASS_ID = L.CLASS_ID)
 INNER JOIN DW_REPORT.CUSTOMERS M ON (A.CUSTOMER_ID = M.CUSTOMER_ID)
 INNER JOIN DW_REPORT.TRANSACTION_TYPE N ON (A.REF_CUSTOM_FORM_ID = N.TRANSACTION_TYPE_ID)
 INNER JOIN DW_REPORT.TRANSACTION_STATUS O ON (A.STATUS = O.STATUS AND A.TRANSACTION_TYPE = O.DOCUMENT_TYPE)
 INNER JOIN DW_REPORT.TRANSACTION_TYPE P ON (A.CUSTOM_FORM_ID = P.TRANSACTION_TYPE_ID)
 INNER JOIN DW_REPORT.ACCOUNTING_PERIOD Q ON (A.ACCOUNTING_PERIOD_ID = Q.ACCOUNTING_PERIOD_ID)
 INNER JOIN DW_REPORT.EMPLOYEES R ON (A.SALES_REP_ID = R.EMPLOYEE_ID)
WHERE A.RUNID = NVL('%s',A.RUNID);

/* prestage-> identify new revenue fact records */
UPDATE DW_PRESTAGE.REVENUE_FACT_ERROR A
 SET RECORD_STATUS = 'INSERT'
 WHERE NOT EXISTS
 (SELECT 1 FROM DW_REPORT.REVENUE_FACT B
 WHERE A.TRANSACTION_ID = B.TRANSACTION_ID
 AND A.TRANSACTION_LINE_ID = B.TRANSACTION_LINE_ID
 AND A.SUBSIDIARY_KEY = B.SUBSIDIARY_KEY );

/* prestage-> no of revenue fact records reprocessed in staging*/
SELECT count(1) FROM dw_prestage.revenue_fact_error;

/* prestage-> no of revenue fact records identified as new*/
SELECT count(1) FROM dw_prestage.revenue_fact_error where RECORD_STATUS = 'INSERT';

/* prestage-> no of revenue fact records identified to be updated*/
SELECT count(1) FROM dw_prestage.revenue_fact_error where RECORD_STATUS = 'PROCESSED';

/* fact -> INSERT REPROCESSED RECORDS WHICH HAS ALL VALID DIMENSIONS */
INSERT INTO dw.revenue_fact
(
DOCUMENT_NUMBER
,TRANSACTION_ID
,TRANSACTION_LINE_ID
,REF_DOC_NUMBER
,REF_DOC_TYPE_KEY
,TERMS_KEY
,REVENUE_COMMITMENT_STATUS
,REVENUE_STATUS
,SALES_REP_KEY
,TERRITORY_KEY
,BILL_ADDRESS_LINE_1
,BILL_ADDRESS_LINE_2
,BILL_ADDRESS_LINE_3
,BILL_CITY
,BILL_COUNTRY
,BILL_STATE
,BILL_ZIP
,SHIP_ADDRESS_LINE_1
,SHIP_ADDRESS_LINE_2
,SHIP_ADDRESS_LINE_3
,SHIP_CITY
,SHIP_COUNTRY
,SHIP_STATE
,SHIP_ZIP
,DOCUMENT_STATUS_KEY
,DOCUMENT_TYPE_KEY
,CURRENCY_KEY
,TRANSACTION_DATE_KEY
,EXCHANGE_RATE
,ACCOUNT_KEY
,AMOUNT
,AMOUNT_FOREIGN
,GROSS_AMOUNT
,NET_AMOUNT
,NET_AMOUNT_FOREIGN
,QUANTITY
,ITEM_KEY
,RATE
,TAX_ITEM_KEY
,TAX_AMOUNT
,LOCATION_KEY
,CLASS_KEY
,SUBSIDIARY_KEY
,CUSTOMER_KEY
,ACCOUNTING_PERIOD_KEY
,DATE_ACTIVE_FROM
,DATE_ACTIVE_TO
,DW_CURRENT
)
SELECT
 A.DOCUMENT_NUMBER
,A.TRANSACTION_ID
,A.TRANSACTION_LINE_ID
,A.REF_DOC_NUMBER
,A.REF_DOC_TYPE_KEY
,A.TERMS_KEY
,A.REVENUE_COMMITMENT_STATUS
,A.REVENUE_STATUS
,A.SALES_REP_KEY
,A.TERRITORY_KEY
,A.BILL_ADDRESS_LINE_1
,A.BILL_ADDRESS_LINE_2
,A.BILL_ADDRESS_LINE_3
,A.BILL_CITY
,A.BILL_COUNTRY
,A.BILL_STATE
,A.BILL_ZIP
,A.SHIP_ADDRESS_LINE_1
,A.SHIP_ADDRESS_LINE_2
,A.SHIP_ADDRESS_LINE_3
,A.SHIP_CITY
,A.SHIP_COUNTRY
,A.SHIP_STATE
,A.SHIP_ZIP
,A.DOCUMENT_STATUS_KEY
,A.DOCUMENT_TYPE_KEY
,A.CURRENCY_KEY
,A.TRANSACTION_DATE_KEY
,A.EXCHANGE_RATE
,A.ACCOUNT_KEY
,A.AMOUNT
,A.AMOUNT_FOREIGN
,A.GROSS_AMOUNT
,A.NET_AMOUNT
,A.NET_AMOUNT_FOREIGN
,A.QUANTITY
,A.ITEM_KEY
,A.RATE
,A.TAX_ITEM_KEY
,A.TAX_AMOUNT
,A.LOCATION_KEY
,A.CLASS_KEY
,A.SUBSIDIARY_KEY
,A.CUSTOMER_KEY
,A.ACCOUNTING_PERIOD_KEY  
,SYSDATE AS DATE_ACTIVE_FROM
 ,'9999-12-31 11:59:59' AS DATE_ACTIVE_TO
 ,1 AS DW_CURRENT
 FROM
 DW_PRESTAGE.REVENUE_FACT_ERROR A
 WHERE 
 RECORD_STATUS = 'INSERT';
 
 /* fact -> UPDATE THE OLD RECORDS SETTING THE CURRENT FLAG VALUE TO 0 */
UPDATE dw.revenue_fact SET dw_current = 0,DATE_ACTIVE_TO = (sysdate -1) WHERE dw_current = 1
AND   sysdate>= date_active_from
AND   sysdate< date_active_to
AND   EXISTS (SELECT 1 FROM dw_prestage.revenue_fact_error
  WHERE dw.revenue_fact.transaction_ID = dw_prestage.revenue_fact_error.transaction_id
  AND   dw.revenue_fact.transaction_LINE_ID = dw_prestage.revenue_fact_error.transaction_line_id
  AND dw.revenue_fact.subsidiary_id = dw_prestage.revenue_fact_error.subsidiary_id
  AND dw_prestage.revenue_fact_error.RECORD_STATUS = 'PROCESSED');
  
/* fact -> INSERT UPDATED REPROCESSED RECORDS WHICH HAVE ALL VALID DIMENSIONS*/
INSERT INTO dw.revenue_fact
(
DOCUMENT_NUMBER
,TRANSACTION_ID
,TRANSACTION_LINE_ID
,REF_DOC_NUMBER
,REF_DOC_TYPE_KEY
,TERMS_KEY
,REVENUE_COMMITMENT_STATUS
,REVENUE_STATUS
,SALES_REP_KEY
,TERRITORY_KEY
,BILL_ADDRESS_LINE_1
,BILL_ADDRESS_LINE_2
,BILL_ADDRESS_LINE_3
,BILL_CITY
,BILL_COUNTRY
,BILL_STATE
,BILL_ZIP
,SHIP_ADDRESS_LINE_1
,SHIP_ADDRESS_LINE_2
,SHIP_ADDRESS_LINE_3
,SHIP_CITY
,SHIP_COUNTRY
,SHIP_STATE
,SHIP_ZIP
,DOCUMENT_STATUS_KEY
,DOCUMENT_TYPE_KEY
,CURRENCY_KEY
,TRANSACTION_DATE_KEY
,EXCHANGE_RATE
,ACCOUNT_KEY
,AMOUNT
,AMOUNT_FOREIGN
,GROSS_AMOUNT
,NET_AMOUNT
,NET_AMOUNT_FOREIGN
,QUANTITY
,ITEM_KEY
,RATE
,TAX_ITEM_KEY
,TAX_AMOUNT
,LOCATION_KEY
,CLASS_KEY
,SUBSIDIARY_KEY
,CUSTOMER_KEY
,ACCOUNTING_PERIOD_KEY
,DATE_ACTIVE_FROM
,DATE_ACTIVE_TO
,DW_CURRENT
)
SELECT
 A.DOCUMENT_NUMBER
,A.TRANSACTION_ID
,A.TRANSACTION_LINE_ID
,A.REF_DOC_NUMBER
,A.REF_DOC_TYPE_KEY
,A.TERMS_KEY
,A.REVENUE_COMMITMENT_STATUS
,A.REVENUE_STATUS
,A.SALES_REP_KEY
,A.TERRITORY_KEY
,A.BILL_ADDRESS_LINE_1
,A.BILL_ADDRESS_LINE_2
,A.BILL_ADDRESS_LINE_3
,A.BILL_CITY
,A.BILL_COUNTRY
,A.BILL_STATE
,A.BILL_ZIP
,A.SHIP_ADDRESS_LINE_1
,A.SHIP_ADDRESS_LINE_2
,A.SHIP_ADDRESS_LINE_3
,A.SHIP_CITY
,A.SHIP_COUNTRY
,A.SHIP_STATE
,A.SHIP_ZIP
,A.DOCUMENT_STATUS_KEY
,A.DOCUMENT_TYPE_KEY
,A.CURRENCY_KEY
,A.TRANSACTION_DATE_KEY
,A.EXCHANGE_RATE
,A.ACCOUNT_KEY
,A.AMOUNT
,A.AMOUNT_FOREIGN
,A.GROSS_AMOUNT
,A.NET_AMOUNT
,A.NET_AMOUNT_FOREIGN
,A.QUANTITY
,A.ITEM_KEY
,A.RATE
,A.TAX_ITEM_KEY
,A.TAX_AMOUNT
,A.LOCATION_KEY
,A.CLASS_KEY
,A.SUBSIDIARY_KEY
,A.CUSTOMER_KEY
,A.ACCOUNTING_PERIOD_KEY  
,SYSDATE AS DATE_ACTIVE_FROM
 ,'9999-12-31 11:59:59' AS DATE_ACTIVE_TO
 ,1 AS DW_CURRENT
 FROM
 DW_PRESTAGE.REVENUE_FACT_ERROR A
 WHERE 
 RECORD_STATUS = 'PROCESSED';

 

 
 
 
 
 