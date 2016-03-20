/* error prestage - drop intermediate error prestage table */
DROP TABLE IF EXISTS DW_PRESTAGE.OPPORTUNITY_FACT_ERROR;

/* prestage - create intermediate insert table*/
CREATE TABLE DW_PRESTAGE.OPPORTUNITY_FACT_ERROR
AS
SELECT
  A.RUNID
 ,A.DOCUMENT_NUMBER
 ,A.TRANSACTION_NUMBER
 ,A.TRANSACTION_ID
 ,NVL(A.ACCOUNTING_PERIOD_KEY,B.ACCOUNTING_PERIOD_KEY) ACCOUNTING_PERIOD_KEY
 ,A.ACCOUNTING_PERIOD_ID_ERROR
 ,NVL(A.TERRITORY_KEY,C.TERRITORY_KEY) TERRITORY_KEY
 ,A.TERRITORY_ID_ERROR
 ,NVL(A.BOOK_FAIRS_CONSULTANT_KEY,R.EMPLOYEE_KEY) BOOK_FAIRS_CONSULTANT_KEY       
 ,A.BOOK_FAIRS_CONSULTANT_ID        
 ,A.BOOK_FAIRS_CONSULTANT_ID_ERROR  
 ,NVL(A.SALES_REP_KEY,D.EMPLOYEE_KEY) SALES_REP_KEY
 ,A.SALES_REP_ID_ERROR
 ,NVL(A.BOOK_FAIRS_KEY,E.BOOK_FAIR_KEY) BOOK_FAIRS_KEY
 ,A.BOOK_FAIRS_ID_ERROR
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
 ,NVL(A.OPPORTUNITY_STATUS_KEY,f.transaction_status_key) OPPORTUNITY_STATUS_KEY
 ,A.OPPORTUNITY_STATUS_ID_ERROR
 ,NVL(A.OPPORTUNITY_TYPE_KEY,M.TRANSACTION_TYPE_KEY) OPPORTUNITY_TYPE_KEY
 ,A.OPPORTUNITY_TYPE_ID_ERROR
 ,A.FORECAST_TYPE
 ,NVL(A.CURRENCY_KEY,G.CURRENCY_KEY) CURRENCY_KEY
 ,A.CURRENCY_ID_ERROR
 ,NVL(A.TRANSACTION_DATE_KEY, H.DATE_KEY)   TRANSACTION_DATE_KEY
 ,NVL(A.OPEN_DATE_KEY,I.DATE_KEY )  OPEN_DATE_KEY
 ,A.OPEN_DATE_ERROR           
 ,NVL(A.SHIP_DATE_KEY, J.DATE_KEY )  SHIP_DATE_KEY           
 ,A.SHIP_DATE_ERROR           
 ,NVL(A.CLOSE_DATE_KEY,K.DATE_KEY )  CLOSE_DATE_KEY
 ,A.CLOSE_DATE_ERROR
 ,NVL(A.RETURN_DATE_KEY,L.DATE_KEY )  RETURN_DATE_KEY
 ,A.RETURN_DATE_ERROR
 ,A.EXCHANGE_RATE
 ,A.ROLL_SIZE
 ,A.PROJECTED_TOTAL
 ,A.WEIGHTED_TOTAL
 ,A.AMOUNT
 ,NVL(A.LOCATION_KEY,N.LOCATION_KEY) LOCATION_KEY  
 ,A.LOCATION_ID_ERROR        
 ,NVL(A.CLASS_KEY,O.CLASS_KEY)  CLASS_KEY  
 ,A.CLASS_ID_ERROR         
 ,NVL(A.SUBSIDIARY_KEY,P.SUBSIDIARY_KEY) SUBSIDIARY_KEY
 ,A.SUBSIDIARY_ID_ERROR
 ,NVL(A.CUSTOMER_KEY,Q.CUSTOMER_KEY) CUSTOMER_KEY 
 ,A.CUSTOMER_ID_ERROR
 ,A.LAST_MODIFIED_DATE
 ,A.SALES_REP_ID         
 ,A.TERRITORY_ID         
 ,A.OPEN_DATE            
 ,A.SHIP_DATE            
 ,A.CLOSE_DATE           
 ,A.RETURN_DATE          
 ,A.ACCOUNTING_PERIOD_ID 
 ,A.ABCDO_MARKER_ID      
 ,A.BOOK_FAIRS_STATUS_ID 
 ,A.BOOK_FAIR_TYPE_ID    
 ,A.TRUCK_ROUTE_ID       
 ,A.STATUS               
 ,A.CUSTOM_FORM_ID       
 ,A.CURRENCY_ID          
 ,A.TRANDATE             
 ,A.LOCATION_ID          
 ,A.CUSTOMER_ID  
 ,A.CLASS_ID        
 ,'PROCESSED' RECORD_STATUS        
 ,SYSDATE DW_CREATION_DATE     
 FROM
 DW.OPPORTUNITY_FACT_ERROR A
  INNER JOIN DW_REPORT.ACCOUNTING_PERIOD B ON (NVL (A.ACCOUNTING_PERIOD_ID,-99) = B.ACCOUNTING_PERIOD_ID)
  INNER JOIN DW_REPORT.TERRITORIES C ON (NVL (A.TERRITORY_ID,-99) = C.TERRITORY_ID)
  INNER JOIN DW_REPORT.EMPLOYEES D ON (NVL (A.SALES_REP_ID,-99) = D.EMPLOYEE_ID)
  INNER JOIN DW_REPORT.BOOK_FAIRS E
          ON (NVL (A.ABCDO_MARKER_ID,-99) = E.MARKER_ID
         AND NVL (A.BOOK_FAIRS_STATUS_ID,-99) = E.FAIR_STATUS_ID
         AND NVL (A.BOOK_FAIR_TYPE_ID,-99) = E.FAIR_TYPE_ID
         AND NVL (A.TRUCK_ROUTE_ID,-99) = E.ROUTE_ID
         AND NVL (A.INVOICE_OPTION_ID,-99) = E.INVOICE_OPTION_ID)
  INNER JOIN DW_REPORT.TRANSACTION_STATUS F
          ON (F.DOCUMENT_TYPE = 'Opportunity'
         AND NVL (F.STATUS,'NA_GDW') = A.STATUS)
  INNER JOIN DW_REPORT.CURRENCIES G ON (NVL (A.CURRENCY_ID,-99) = G.CURRENCY_ID)
  INNER JOIN DW.DWDATE H ON (TO_CHAR (A.TRANDATE,'YYYYMMDD') = H.DATE_ID)
  INNER JOIN DW.DWDATE I ON (TO_CHAR (A.OPEN_DATE,'YYYYMMDD') = I.DATE_ID)
  INNER JOIN DW.DWDATE J ON (TO_CHAR (A.SHIP_DATE,'YYYYMMDD') = J.DATE_ID)
  INNER JOIN DW.DWDATE K ON (TO_CHAR (A.CLOSE_DATE,'YYYYMMDD') = K.DATE_ID)
  INNER JOIN DW.DWDATE L ON (TO_CHAR (A.RETURN_DATE,'YYYYMMDD') = L.DATE_ID)
  INNER JOIN DW_REPORT.TRANSACTION_TYPE M ON (A.CUSTOM_FORM_ID = M.TRANSACTION_TYPE_ID)
  INNER JOIN DW_REPORT.LOCATIONS N ON (NVL (A.LOCATION_ID,-99) = N.LOCATION_ID)
  INNER JOIN DW_REPORT.CLASSES O ON ( NVL(A.CLASS_ID,-99) = O.CLASS_ID)
  INNER JOIN DW_REPORT.SUBSIDIARIES P ON (A.SUBSIDIARY_ID = P.SUBSIDIARY_ID)
  INNER JOIN DW_REPORT.CUSTOMERS Q ON (A.CUSTOMER_ID = Q.CUSTOMER_ID)
  INNER JOIN DW_REPORT.EMPLOYEES R ON (NVL (A.BOOK_FAIRS_CONSULTANT_ID,-99) = R.EMPLOYEE_ID)
  WHERE A.RUNID = NVL(RUNID_ERR,A.RUNID)
  AND RECORD_STATUS = 'ERROR';
  
  /* prestage-> identify new revenue fact records */
UPDATE DW_PRESTAGE.OPPORTUNITY_FACT_ERROR
 SET RECORD_STATUS = 'INSERT'
 WHERE NOT EXISTS
 (SELECT 1 FROM DW_REPORT.OPPORTUNITY_FACT B
 WHERE DW_PRESTAGE.OPPORTUNITY_FACT_ERROR.TRANSACTION_ID = B.TRANSACTION_ID
 AND DW_PRESTAGE.OPPORTUNITY_FACT_ERROR.SUBSIDIARY_KEY = B.SUBSIDIARY_KEY );

/* prestage-> no of revenue fact records reprocessed in staging*/
SELECT count(1) FROM dw_prestage.OPPORTUNITY_FACT_ERROR;

/* prestage-> no of revenue fact records identified as new*/
SELECT count(1) FROM dw_prestage.OPPORTUNITY_FACT_ERROR where RECORD_STATUS = 'INSERT';

/* prestage-> no of revenue fact records identified to be updated*/
SELECT count(1) FROM dw_prestage.OPPORTUNITY_FACT_ERROR where RECORD_STATUS = 'PROCESSED';

/* fact -> INSERT REPROCESSED RECORDS WHICH HAS ALL VALID DIMENSIONS */
INSERT INTO dw.opportunity_fact
(
  DOCUMENT_NUMBER
 ,TRANSACTION_NUMBER
 ,TRANSACTION_ID
 ,ACCOUNTING_PERIOD_KEY
 ,TERRITORY_KEY
 ,BOOK_FAIRS_CONSULTANT_KEY
 ,SALES_REP_KEY
 ,BOOK_FAIRS_KEY
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
 ,OPPORTUNITY_STATUS_KEY
 ,OPPORTUNITY_TYPE_KEY
 ,FORECAST_TYPE
 ,CURRENCY_KEY
 ,TRANSACTION_DATE_KEY
 ,OPEN_DATE_KEY
 ,SHIP_DATE_KEY
 ,CLOSE_DATE_KEY
 ,RETURN_DATE_KEY
 ,EXCHANGE_RATE
 ,ROLL_SIZE
 ,PROJECTED_TOTAL
 ,WEIGHTED_TOTAL
 ,AMOUNT
 ,LOCATION_KEY
 ,CLASS_KEY
 ,SUBSIDIARY_KEY
 ,CUSTOMER_KEY
 ,LAST_MODIFIED_DATE
 ,DATE_ACTIVE_FROM
 ,DATE_ACTIVE_TO
 ,DW_CURRENT
)
SELECT
  A.DOCUMENT_NUMBER
 ,A.TRANSACTION_NUMBER
 ,A.TRANSACTION_ID
 ,A.ACCOUNTING_PERIOD_KEY
 ,A.TERRITORY_KEY 
 ,A.BOOK_FAIRS_CONSULTANT_KEY
 ,A.SALES_REP_KEY
 ,A.BOOK_FAIRS_KEY
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
 ,A.OPPORTUNITY_STATUS_KEY
 ,A.OPPORTUNITY_TYPE_KEY
 ,A.FORECAST_TYPE
 ,A.CURRENCY_KEY
 ,A.TRANSACTION_DATE_KEY
 ,A.OPEN_DATE_KEY
 ,A.SHIP_DATE_KEY
 ,A.CLOSE_DATE_KEY
 ,A.RETURN_DATE_KEY
 ,A.EXCHANGE_RATE
 ,A.ROLL_SIZE
 ,A.PROJECTED_TOTAL
 ,A.WEIGHTED_TOTAL
 ,A.AMOUNT
 ,A.LOCATION_KEY
 ,A.CLASS_KEY
 ,A.SUBSIDIARY_KEY
 ,A.CUSTOMER_KEY
 ,A.LAST_MODIFIED_DATE
 ,SYSDATE AS DATE_ACTIVE_FROM
 ,'9999-12-31 11:59:59' AS DATE_ACTIVE_TO
 ,1 AS DW_CURRENT
 FROM
 DW_PRESTAGE.OPPORTUNITY_FACT_ERROR A
 WHERE 
 RECORD_STATUS = 'INSERT'; 
 
  /* fact -> UPDATE THE OLD RECORDS SETTING THE CURRENT FLAG VALUE TO 0 */                       
 UPDATE dw.opportunity_fact SET dw_current = 0,DATE_ACTIVE_TO = (sysdate -1) WHERE dw_current = 1    
 AND   sysdate>= date_active_from                                                                
 AND   sysdate< date_active_to                                                                   
 AND   EXISTS (SELECT 1 FROM dw_prestage.opportunity_fact_error                                      
   WHERE dw.opportunity_fact.transaction_ID = dw_prestage.opportunity_fact_error.transaction_id
   AND dw.opportunity_fact.subsidiary_KEY = dw_prestage.opportunity_fact_error.subsidiary_key            
   AND dw_prestage.opportunity_fact_error.RECORD_STATUS = 'PROCESSED');  
   
/* fact -> INSERT UPDATED REPROCESSED RECORDS WHICH HAVE ALL VALID DIMENSIONS*/
INSERT INTO dw.opportunity_fact
(
  DOCUMENT_NUMBER
 ,TRANSACTION_NUMBER
 ,TRANSACTION_ID
 ,ACCOUNTING_PERIOD_KEY
 ,TERRITORY_KEY
 ,BOOK_FAIRS_CONSULTANT_KEY
 ,SALES_REP_KEY
 ,BOOK_FAIRS_KEY
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
 ,OPPORTUNITY_STATUS_KEY
 ,OPPORTUNITY_TYPE_KEY
 ,FORECAST_TYPE
 ,CURRENCY_KEY
 ,TRANSACTION_DATE_KEY
 ,OPEN_DATE_KEY
 ,SHIP_DATE_KEY
 ,CLOSE_DATE_KEY
 ,RETURN_DATE_KEY
 ,EXCHANGE_RATE
 ,ROLL_SIZE
 ,PROJECTED_TOTAL
 ,WEIGHTED_TOTAL
 ,AMOUNT
 ,LOCATION_KEY
 ,CLASS_KEY
 ,SUBSIDIARY_KEY
 ,CUSTOMER_KEY
 ,LAST_MODIFIED_DATE
 ,DATE_ACTIVE_FROM
 ,DATE_ACTIVE_TO
 ,DW_CURRENT
)
SELECT
  A.DOCUMENT_NUMBER
 ,A.TRANSACTION_NUMBER
 ,A.TRANSACTION_ID
 ,A.ACCOUNTING_PERIOD_KEY
 ,A.TERRITORY_KEY 
 ,A.BOOK_FAIRS_CONSULTANT_KEY
 ,A.SALES_REP_KEY
 ,A.BOOK_FAIRS_KEY
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
 ,A.OPPORTUNITY_STATUS_KEY
 ,A.OPPORTUNITY_TYPE_KEY
 ,A.FORECAST_TYPE
 ,A.CURRENCY_KEY
 ,A.TRANSACTION_DATE_KEY
 ,A.OPEN_DATE_KEY
 ,A.SHIP_DATE_KEY
 ,A.CLOSE_DATE_KEY
 ,A.RETURN_DATE_KEY
 ,A.EXCHANGE_RATE
 ,A.ROLL_SIZE
 ,A.PROJECTED_TOTAL
 ,A.WEIGHTED_TOTAL
 ,A.AMOUNT
 ,A.LOCATION_KEY
 ,A.CLASS_KEY
 ,A.SUBSIDIARY_KEY
 ,A.CUSTOMER_KEY
 ,A.LAST_MODIFIED_DATE
 ,SYSDATE AS DATE_ACTIVE_FROM
 ,'9999-12-31 11:59:59' AS DATE_ACTIVE_TO
 ,1 AS DW_CURRENT
 FROM
 DW_PRESTAGE.OPPORTUNITY_FACT_ERROR A
 WHERE 
 RECORD_STATUS = 'PROCESSED'; 
                            
  /* fact -> UPDATE THE ERROR TABLE TO SET THE SATUS AS PROCESSED */
UPDATE dw.opportunity_fact_error SET RECORD_STATUS = 'PROCESSED'
where exists ( select 1 from dw_prestage.opportunity_fact_error b
  WHERE dw.opportunity_fact_error.RUNID = b.RUNID
  AND dw.opportunity_fact_error.transaction_id = b.transaction_id);        
