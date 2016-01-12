/* prestage - drop intermediate insert table */
DROP TABLE if exists dw_prestage.opportunity_fact_insert;

/* prestage - create intermediate insert table*/
CREATE TABLE dw_prestage.opportunity_fact_insert 
AS
SELECT *
FROM dw_prestage.opportunity_fact
WHERE EXISTS (SELECT 1
FROM (SELECT TRANSACTION_ID FROM (SELECT TRANSACTION_ID FROM dw_prestage.opportunity_fact MINUS SELECT TRANSACTION_ID  FROM dw_stage.opportunity_fact)) a
WHERE dw_prestage.opportunity_fact.TRANSACTION_ID = a.TRANSACTION_ID
);

/* prestage - drop intermediate update table*/
DROP TABLE if exists dw_prestage.opportunity_fact_update;

/* prestage - create intermediate update table*/
CREATE TABLE dw_prestage.opportunity_fact_update 
AS
SELECT TRANSACTION_ID , DOCUMENT_NUMBER   
FROM (SELECT TRANSACTION_ID , DOCUMENT_NUMBER   
      FROM (SELECT TRANSACTION_NUMBER         
	              ,DOCUMENT_NUMBER     
	              ,TRANSACTION_ID         
	              ,SALES_REP_ID           
	              ,TERRITORY_ID           
	              ,OPEN_DATE              
	              ,SHIP_DATE              
	              ,CLOSE_DATE             
	              ,RETURN_DATE            
	              ,FORECAST_TYPE          
	              ,ABCDO_MARKER_ID        
	              ,BOOK_FAIRS_STATUS_ID   
	              ,BOOK_FAIR_TYPE_ID      
	              ,TRUCK_ROUTE_ID         
	              ,INVOICE_OPTION_ID      
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
	              ,STATUS                 
	              ,CURRENCY_ID            
	              ,TRANDATE               
	              ,EXCHANGE_RATE          
	              ,ROLL_SIZE              
	              ,PROJECTED_TOTAL        
	              ,WEIGHTED_TOTAL         
	              ,LOCATION_ID            
	              ,SUBSIDIARY_ID          
	              ,ACCOUNTING_PERIOD_ID   
	              ,CUSTOMER_ID            
	              ,CUSTOM_FORM_ID         
            FROM dw_prestage.opportunity_fact
            MINUS
            SELECT  TRANSACTION_NUMBER         
	              ,DOCUMENT_NUMBER     
	              ,TRANSACTION_ID         
	              ,SALES_REP_ID           
	              ,TERRITORY_ID           
	              ,OPEN_DATE              
	              ,SHIP_DATE              
	              ,CLOSE_DATE             
	              ,RETURN_DATE            
	              ,FORECAST_TYPE          
	              ,ABCDO_MARKER_ID        
	              ,BOOK_FAIRS_STATUS_ID   
	              ,BOOK_FAIR_TYPE_ID      
	              ,TRUCK_ROUTE_ID         
	              ,INVOICE_OPTION_ID      
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
	              ,STATUS                 
	              ,CURRENCY_ID            
	              ,TRANDATE               
	              ,EXCHANGE_RATE          
	              ,ROLL_SIZE              
	              ,PROJECTED_TOTAL        
	              ,WEIGHTED_TOTAL         
	              ,LOCATION_ID            
	              ,SUBSIDIARY_ID          
	              ,ACCOUNTING_PERIOD_ID   
	              ,CUSTOMER_ID            
	              ,CUSTOM_FORM_ID 
            FROM dw_stage.opportunity_fact)) a
WHERE NOT EXISTS (SELECT 1 FROM dw_prestage.opportunity_fact_insert WHERE dw_prestage.opportunity_fact_insert.TRANSACTION_ID = a.TRANSACTION_ID);

/* prestage - drop intermediate no change track table*/
DROP TABLE if exists dw_prestage.opportunity_fact_nochange;

/* prestage - create intermediate no change track table*/
CREATE TABLE dw_prestage.opportunity_fact_nochange 
AS
SELECT TRANSACTION_ID
FROM (SELECT TRANSACTION_ID
      FROM dw_prestage.opportunity_fact
      MINUS
      (SELECT TRANSACTION_ID
      FROM dw_prestage.opportunity_fact_insert
      UNION ALL
      SELECT TRANSACTION_ID
      FROM dw_prestage.opportunity_fact_update));

/* prestage-> stage*/
SELECT 'no of opportunity fact records ingested in staging -->' ||count(1)
FROM dw_prestage.opportunity_fact;

/* prestage-> stage*/
SELECT 'no of opportunity fact records identified to inserted -->' ||count(1)
FROM dw_prestage.opportunity_fact_insert;

/* prestage-> stage*/
SELECT 'no of opportunity fact records identified to updated -->' ||count(1)
FROM dw_prestage.opportunity_fact_update;

/* prestage-> stage*/
SELECT 'no of opportunity fact records identified as no change -->' ||count(1)
FROM dw_prestage.opportunity_fact_nochange;

--D --A = B + C + D
/* stage -> delete from stage records to be updated */ 
DELETE
FROM dw_stage.opportunity_fact USING dw_prestage.opportunity_fact_update
WHERE dw_stage.opportunity_fact.transaction_id = dw_prestage.opportunity_fact_update.transaction_id;

/* stage -> insert into stage records which have been created */ 
INSERT INTO dw_stage.opportunity_fact
SELECT *
FROM dw_prestage.opportunity_fact_insert;

/* stage -> insert into stage records which have been updated */ 
INSERT INTO dw_stage.opportunity_fact
SELECT *
FROM dw_prestage.opportunity_fact
WHERE EXISTS (SELECT 1
              FROM dw_prestage.opportunity_fact_update
              WHERE dw_prestage.opportunity_fact_update.transaction_id = dw_prestage.opportunity_fact.transaction_id);

COMMIT;

/* fact -> INSERT NEW RECORDS WHICH HAS ALL VALID DIMENSIONS */ 
INSERT INTO dw.opportunity_fact
(
  DOCUMENT_NUMBER
 ,TRANSACTION_NUMBER
 ,TRANSACTION_ID
 ,ACCOUNTING_PERIOD_KEY
 ,TERRITORY_KEY
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
SELECT A.DOCUMENT_NUMBER,
       A.TRANSACTION_NUMBER,
       A.TRANSACTION_ID,
       B.ACCOUNTING_PERIOD_KEY,
       C.TERRITORY_KEY,
       D.EMPLOYEE_KEY AS SALES_REP_KEY,
       E.BOOK_FAIR_KEY AS BOOK_FAIRS_KEY,
       A.BILL_ADDRESS_LINE_1,
       A.BILL_ADDRESS_LINE_2,
       A.BILL_ADDRESS_LINE_3,
       A.BILL_CITY,
       A.BILL_COUNTRY,
       A.BILL_STATE,
       A.BILL_ZIP,
       A.SHIP_ADDRESS_LINE_1,
       A.SHIP_ADDRESS_LINE_2,
       A.SHIP_ADDRESS_LINE_3,
       A.SHIP_CITY,
       A.SHIP_COUNTRY,
       A.SHIP_STATE,
       A.SHIP_ZIP,
       f.transaction_status_key AS OPPORTUNITY_STATUS_KEY,
       M.TRANSACTION_TYPE_KEY AS OPPORTUNITY_TYPE_KEY,
       A.FORECAST_TYPE,
       G.CURRENCY_KEY,
       H.DATE_KEY AS TRANSACTION_DATE_KEY,
       I.DATE_KEY AS OPEN_DATE_KEY,
       J.DATE_KEY AS SHIP_DATE_KEY,
       K.DATE_KEY AS CLOSE_DATE_KEY,
       L.DATE_KEY AS RETURN_DATE_KEY,
       A.EXCHANGE_RATE,
       A.ROLL_SIZE,
       A.PROJECTED_TOTAL,
       A.WEIGHTED_TOTAL,
       A.PROJECTED_TOTAL AS AMOUNT,
       N.LOCATION_KEY,
       O.CLASS_KEY,
       P.SUBSIDIARY_KEY,
       Q.CUSTOMER_KEY,
       A.DATE_LAST_MODIFIED,
       SYSDATE AS DATE_ACTIVE_FROM,
       '9999-12-31 11:59:59' AS DATE_ACTIVE_TO,
       1 AS DW_CURRENT
FROM dw_prestage.opportunity_fact_insert A
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
  INNER JOIN DW_REPORT.TRANSACTION_TYPE M ON (NVL (A.CUSTOM_FORM_ID,-99) = M.TRANSACTION_TYPE_ID)
  INNER JOIN DW_REPORT.LOCATIONS N ON (A.LOCATION_ID = N.LOCATION_ID)
  INNER JOIN DW_REPORT.CLASSES O ON ('Book Fairs' = O.NAME)
  INNER JOIN DW_REPORT.SUBSIDIARIES P ON (27 = P.SUBSIDIARY_ID)
  INNER JOIN DW_REPORT.CUSTOMERS Q ON (A.CUSTOMER_ID = Q.CUSTOMER_ID);
  
/* fact -> INSERT NEW RECORDS IN ERROR TABLE WHICH DOES NOT HAVE VALID DIMENSIONS */ 
INSERT INTO dw.opportunity_fact_error
(
  RUNID
 ,DOCUMENT_NUMBER
 ,TRANSACTION_NUMBER
 ,TRANSACTION_ID
 ,ACCOUNTING_PERIOD_KEY
 ,TERRITORY_KEY
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
 ,SALES_REP_ID         
 ,TERRITORY_ID         
 ,OPEN_DATE            
 ,SHIP_DATE            
 ,CLOSE_DATE           
 ,RETURN_DATE          
 ,ACCOUNTING_PERIOD_ID 
 ,ABCDO_MARKER_ID      
 ,BOOK_FAIRS_STATUS_ID 
 ,BOOK_FAIR_TYPE_ID    
 ,TRUCK_ROUTE_ID       
 ,STATUS               
 ,CUSTOM_FORM_ID       
 ,CURRENCY_ID          
 ,TRANDATE             
 ,LOCATION_ID          
 ,CUSTOMER_ID          
 ,RECORD_STATUS        
 ,DW_CREATION_DATE     
)
SELECT A.RUNID,
       A.DOCUMENT_NUMBER,
       A.TRANSACTION_NUMBER,
       A.TRANSACTION_ID,
       B.ACCOUNTING_PERIOD_KEY,
       C.TERRITORY_KEY,
       D.EMPLOYEE_KEY AS SALES_REP_KEY,
       E.BOOK_FAIR_KEY AS BOOK_FAIRS_KEY,
       A.BILL_ADDRESS_LINE_1,
       A.BILL_ADDRESS_LINE_2,
       A.BILL_ADDRESS_LINE_3,
       A.BILL_CITY,
       A.BILL_COUNTRY,
       A.BILL_STATE,
       A.BILL_ZIP,
       A.SHIP_ADDRESS_LINE_1,
       A.SHIP_ADDRESS_LINE_2,
       A.SHIP_ADDRESS_LINE_3,
       A.SHIP_CITY,
       A.SHIP_COUNTRY,
       A.SHIP_STATE,
       A.SHIP_ZIP,
       f.transaction_status_key AS OPPORTUNITY_STATUS_KEY,
       M.TRANSACTION_TYPE_KEY AS OPPORTUNITY_TYPE_KEY,
       A.FORECAST_TYPE,
       G.CURRENCY_KEY,
       H.DATE_KEY AS TRANSACTION_DATE_KEY,
       I.DATE_KEY AS OPEN_DATE_KEY,
       J.DATE_KEY AS SHIP_DATE_KEY,
       K.DATE_KEY AS CLOSE_DATE_KEY,
       L.DATE_KEY AS RETURN_DATE_KEY,
       A.EXCHANGE_RATE,
       A.ROLL_SIZE,
       A.PROJECTED_TOTAL,
       A.WEIGHTED_TOTAL,
       A.PROJECTED_TOTAL AS AMOUNT,
       N.LOCATION_KEY,
       O.CLASS_KEY,
       P.SUBSIDIARY_KEY,
       Q.CUSTOMER_KEY,
       A.DATE_LAST_MODIFIED,
       A.SALES_REP_ID,         
       A.TERRITORY_ID,         
       A.OPEN_DATE,            
       A.SHIP_DATE,            
       A.CLOSE_DATE,           
       A.RETURN_DATE,          
       A.ACCOUNTING_PERIOD_ID, 
       A.ABCDO_MARKER_ID,      
       A.BOOK_FAIRS_STATUS_ID, 
       A.BOOK_FAIR_TYPE_ID,    
       A.TRUCK_ROUTE_ID,       
       A.STATUS,               
       A.CUSTOM_FORM_ID,       
       A.CURRENCY_ID,          
       A.TRANDATE,             
       A.LOCATION_ID,          
       A.CUSTOMER_ID,
       'ERROR' AS RECORD_STATUS,
       SYSDATE AS DW_CREATION_DATE	   
FROM dw_prestage.opportunity_fact_insert A
  LEFT OUTER JOIN DW_REPORT.ACCOUNTING_PERIOD B ON (A.ACCOUNTING_PERIOD_ID = B.ACCOUNTING_PERIOD_ID)
  LEFT OUTER JOIN DW_REPORT.TERRITORIES C ON (A.TERRITORY_ID = C.TERRITORY_ID)
  LEFT OUTER JOIN DW_REPORT.EMPLOYEES D ON (A.SALES_REP_ID = D.EMPLOYEE_ID)
  LEFT OUTER JOIN DW_REPORT.BOOK_FAIRS E
          ON (NVL (A.ABCDO_MARKER_ID,-99) = E.MARKER_ID
         AND NVL (A.BOOK_FAIRS_STATUS_ID,-99) = E.FAIR_STATUS_ID
         AND NVL (A.BOOK_FAIR_TYPE_ID,-99) = E.FAIR_TYPE_ID
         AND NVL (A.TRUCK_ROUTE_ID,-99) = E.ROUTE_ID
         AND NVL (A.INVOICE_OPTION_ID,-99) = E.INVOICE_OPTION_ID)
  LEFT OUTER JOIN DW_REPORT.TRANSACTION_STATUS F
          ON (F.DOCUMENT_TYPE = 'Opportunity'
         AND NVL (F.STATUS,'NA_GDW') = A.STATUS)
  LEFT OUTER JOIN DW_REPORT.CURRENCIES G ON (A.CURRENCY_ID = G.CURRENCY_ID)
  LEFT OUTER JOIN DW.DWDATE H ON (TO_CHAR (A.TRANDATE,'YYYYMMDD') = H.DATE_ID)
  LEFT OUTER JOIN DW.DWDATE I ON (TO_CHAR (A.OPEN_DATE,'YYYYMMDD') = I.DATE_ID)
  LEFT OUTER JOIN DW.DWDATE J ON (TO_CHAR (A.SHIP_DATE,'YYYYMMDD') = J.DATE_ID)
  LEFT OUTER JOIN DW.DWDATE K ON (TO_CHAR (A.CLOSE_DATE,'YYYYMMDD') = K.DATE_ID)
  LEFT OUTER JOIN DW.DWDATE L ON (TO_CHAR (A.RETURN_DATE,'YYYYMMDD') = L.DATE_ID)
  LEFT OUTER JOIN DW_REPORT.TRANSACTION_TYPE M ON (NVL (A.CUSTOM_FORM_ID,-99) = M.TRANSACTION_TYPE_ID)
  LEFT OUTER JOIN DW_REPORT.LOCATIONS N ON (NVL (A.LOCATION_ID,-99) = N.LOCATION_ID)
  LEFT OUTER JOIN DW_REPORT.CLASSES O ON ('Book Fairs' = O.NAME)
  LEFT OUTER JOIN DW_REPORT.SUBSIDIARIES P ON (27 = P.SUBSIDIARY_ID)
  LEFT OUTER JOIN DW_REPORT.CUSTOMERS Q ON (A.CUSTOMER_ID = Q.CUSTOMER_ID) 
  WHERE 
  ((B.ACCOUNTING_PERIOD_KEY IS NULL AND A.ACCOUNTING_PERIOD_ID IS NOT NULL ) OR
  (C.TERRITORY_KEY IS NULL AND A.TERRITORY_ID IS NOT NULL ) OR
  (D.EMPLOYEE_KEY IS NULL AND A.SALES_REP_ID IS NOT NULL ) OR
  E.BOOK_FAIR_KEY IS NULL OR
  F.TRANSACTION_STATUS_KEY IS NULL OR
  (G.CURRENCY_KEY IS NULL AND A.CURRENCY_ID IS NOT NULL ) OR
  H.DATE_KEY IS NULL OR
  I.DATE_KEY IS NULL OR
  J.DATE_KEY IS NULL OR
  K.DATE_KEY IS NULL OR
  L.DATE_KEY IS NULL OR
  M.TRANSACTION_TYPE_KEY IS NULL OR
  N.LOCATION_KEY IS NULL OR
  O.CLASS_KEY IS NULL OR
  P.SUBSIDIARY_KEY IS NULL OR
  Q.CUSTOMER_KEY IS NULL );

/* fact -> UPDATE THE OLD RECORDS SETTING THE CURRENT FLAG VALUE TO 0 */  
UPDATE dw.opportunity_fact SET dw_current = 0,DATE_ACTIVE_TO = (sysdate -1) WHERE dw_current = 1
AND   sysdate>= date_active_from
AND   sysdate< date_active_to
AND   EXISTS (SELECT 1 FROM dw_prestage.opportunity_fact_update WHERE dw.opportunity_fact.transaction_id = dw_prestage.opportunity_fact_update.transaction_id);

/* fact -> NOW INSERT THE FACT RECORDS WHICH HAVE BEEN UPDATED AT THE SOURCE */ 
INSERT INTO dw.opportunity_fact
(
  DOCUMENT_NUMBER
 ,TRANSACTION_NUMBER
 ,TRANSACTION_ID
 ,ACCOUNTING_PERIOD_KEY
 ,TERRITORY_KEY
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
SELECT A.DOCUMENT_NUMBER,
       A.TRANSACTION_NUMBER,
       A.TRANSACTION_ID,
       B.ACCOUNTING_PERIOD_KEY,
       C.TERRITORY_KEY,
       D.EMPLOYEE_KEY AS SALES_REP_KEY,
       E.BOOK_FAIR_KEY AS BOOK_FAIRS_KEY,
       A.BILL_ADDRESS_LINE_1,
       A.BILL_ADDRESS_LINE_2,
       A.BILL_ADDRESS_LINE_3,
       A.BILL_CITY,
       A.BILL_COUNTRY,
       A.BILL_STATE,
       A.BILL_ZIP,
       A.SHIP_ADDRESS_LINE_1,
       A.SHIP_ADDRESS_LINE_2,
       A.SHIP_ADDRESS_LINE_3,
       A.SHIP_CITY,
       A.SHIP_COUNTRY,
       A.SHIP_STATE,
       A.SHIP_ZIP,
       f.transaction_status_key AS OPPORTUNITY_STATUS_KEY,
       M.TRANSACTION_TYPE_KEY AS OPPORTUNITY_TYPE_KEY,
       A.FORECAST_TYPE,
       G.CURRENCY_KEY,
       H.DATE_KEY AS TRANSACTION_DATE_KEY,
       I.DATE_KEY AS OPEN_DATE_KEY,
       J.DATE_KEY AS SHIP_DATE_KEY,
       K.DATE_KEY AS CLOSE_DATE_KEY,
       L.DATE_KEY AS RETURN_DATE_KEY,
       A.EXCHANGE_RATE,
       A.ROLL_SIZE,
       A.PROJECTED_TOTAL,
       A.WEIGHTED_TOTAL,
       A.PROJECTED_TOTAL AS AMOUNT,
       N.LOCATION_KEY,
       O.CLASS_KEY,
       P.SUBSIDIARY_KEY,
       Q.CUSTOMER_KEY,
       A.DATE_LAST_MODIFIED,
       SYSDATE AS DATE_ACTIVE_FROM,
       '9999-12-31 11:59:59' AS DATE_ACTIVE_TO,
       1 AS DW_CURRENT
FROM dw_prestage.opportunity_fact A
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
  INNER JOIN DW_REPORT.TRANSACTION_TYPE M ON (NVL (A.CUSTOM_FORM_ID,-99) = M.TRANSACTION_TYPE_ID)
  INNER JOIN DW_REPORT.LOCATIONS N ON (NVL (A.LOCATION_ID,-99) = N.LOCATION_ID)
  INNER JOIN DW_REPORT.CLASSES O ON ('Book Fairs' = O.NAME)
  INNER JOIN DW_REPORT.SUBSIDIARIES P ON (27 = P.SUBSIDIARY_ID)
  INNER JOIN DW_REPORT.CUSTOMERS Q ON (A.CUSTOMER_ID = Q.CUSTOMER_ID)
WHERE   EXISTS (SELECT 1 FROM dw_prestage.opportunity_fact_update WHERE a.transaction_id = dw_prestage.opportunity_fact_update.transaction_id );

/* fact -> INSERT UPDATED RECORDS IN ERROR TABLE WHICH DOES NOT HAVE VALID DIMENSIONS */ 
INSERT INTO dw.opportunity_fact_error
(
  RUNID
 ,DOCUMENT_NUMBER
 ,TRANSACTION_NUMBER
 ,TRANSACTION_ID
 ,ACCOUNTING_PERIOD_KEY
 ,TERRITORY_KEY
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
 ,SALES_REP_ID         
 ,TERRITORY_ID         
 ,OPEN_DATE            
 ,SHIP_DATE            
 ,CLOSE_DATE           
 ,RETURN_DATE          
 ,ACCOUNTING_PERIOD_ID 
 ,ABCDO_MARKER_ID      
 ,BOOK_FAIRS_STATUS_ID 
 ,BOOK_FAIR_TYPE_ID    
 ,TRUCK_ROUTE_ID       
 ,STATUS               
 ,CUSTOM_FORM_ID       
 ,CURRENCY_ID          
 ,TRANDATE             
 ,LOCATION_ID          
 ,CUSTOMER_ID          
 ,RECORD_STATUS        
 ,DW_CREATION_DATE     
)
SELECT A.RUNID,
       A.DOCUMENT_NUMBER,
       A.TRANSACTION_NUMBER,
       A.TRANSACTION_ID,
       B.ACCOUNTING_PERIOD_KEY,
       C.TERRITORY_KEY,
       D.EMPLOYEE_KEY AS SALES_REP_KEY,
       E.BOOK_FAIR_KEY AS BOOK_FAIRS_KEY,
       A.BILL_ADDRESS_LINE_1,
       A.BILL_ADDRESS_LINE_2,
       A.BILL_ADDRESS_LINE_3,
       A.BILL_CITY,
       A.BILL_COUNTRY,
       A.BILL_STATE,
       A.BILL_ZIP,
       A.SHIP_ADDRESS_LINE_1,
       A.SHIP_ADDRESS_LINE_2,
       A.SHIP_ADDRESS_LINE_3,
       A.SHIP_CITY,
       A.SHIP_COUNTRY,
       A.SHIP_STATE,
       A.SHIP_ZIP,
       f.transaction_status_key AS OPPORTUNITY_STATUS_KEY,
       M.TRANSACTION_TYPE_KEY AS OPPORTUNITY_TYPE_KEY,
       A.FORECAST_TYPE,
       G.CURRENCY_KEY,
       H.DATE_KEY AS TRANSACTION_DATE_KEY,
       I.DATE_KEY AS OPEN_DATE_KEY,
       J.DATE_KEY AS SHIP_DATE_KEY,
       K.DATE_KEY AS CLOSE_DATE_KEY,
       L.DATE_KEY AS RETURN_DATE_KEY,
       A.EXCHANGE_RATE,
       A.ROLL_SIZE,
       A.PROJECTED_TOTAL,
       A.WEIGHTED_TOTAL,
       A.PROJECTED_TOTAL AS AMOUNT,
       N.LOCATION_KEY,
       O.CLASS_KEY,
       P.SUBSIDIARY_KEY,
       Q.CUSTOMER_KEY,
       A.DATE_LAST_MODIFIED,
       A.SALES_REP_ID,         
       A.TERRITORY_ID,         
       A.OPEN_DATE,            
       A.SHIP_DATE,            
       A.CLOSE_DATE,           
       A.RETURN_DATE,          
       A.ACCOUNTING_PERIOD_ID, 
       A.ABCDO_MARKER_ID,      
       A.BOOK_FAIRS_STATUS_ID, 
       A.BOOK_FAIR_TYPE_ID,    
       A.TRUCK_ROUTE_ID,       
       A.STATUS,               
       A.CUSTOM_FORM_ID,       
       A.CURRENCY_ID,          
       A.TRANDATE,             
       A.LOCATION_ID,          
       A.CUSTOMER_ID,
       'ERROR' AS RECORD_STATUS,
       SYSDATE AS DW_CREATION_DATE	   
FROM dw_prestage.opportunity_fact A
  LEFT OUTER JOIN DW_REPORT.ACCOUNTING_PERIOD B ON (A.ACCOUNTING_PERIOD_ID = B.ACCOUNTING_PERIOD_ID)
  LEFT OUTER JOIN DW_REPORT.TERRITORIES C ON (A.TERRITORY_ID = C.TERRITORY_ID)
  LEFT OUTER JOIN DW_REPORT.EMPLOYEES D ON (A.SALES_REP_ID = D.EMPLOYEE_ID)
  LEFT OUTER JOIN DW_REPORT.BOOK_FAIRS E
          ON (NVL (A.ABCDO_MARKER_ID,-99) = E.MARKER_ID
         AND NVL (A.BOOK_FAIRS_STATUS_ID,-99) = E.FAIR_STATUS_ID
         AND NVL (A.BOOK_FAIR_TYPE_ID,-99) = E.FAIR_TYPE_ID
         AND NVL (A.TRUCK_ROUTE_ID,-99) = E.ROUTE_ID
         AND NVL (A.INVOICE_OPTION_ID,-99) = E.INVOICE_OPTION_ID)
  LEFT OUTER JOIN DW_REPORT.TRANSACTION_STATUS F
          ON (F.DOCUMENT_TYPE = 'Opportunity'
         AND NVL (F.STATUS,'NA_GDW') = A.STATUS)
  LEFT OUTER JOIN DW_REPORT.CURRENCIES G ON (A.CURRENCY_ID = G.CURRENCY_ID)
  LEFT OUTER JOIN DW.DWDATE H ON (TO_CHAR (A.TRANDATE,'YYYYMMDD') = H.DATE_ID)
  LEFT OUTER JOIN DW.DWDATE I ON (TO_CHAR (A.OPEN_DATE,'YYYYMMDD') = I.DATE_ID)
  LEFT OUTER JOIN DW.DWDATE J ON (TO_CHAR (A.SHIP_DATE,'YYYYMMDD') = J.DATE_ID)
  LEFT OUTER JOIN DW.DWDATE K ON (TO_CHAR (A.CLOSE_DATE,'YYYYMMDD') = K.DATE_ID)
  LEFT OUTER JOIN DW.DWDATE L ON (TO_CHAR (A.RETURN_DATE,'YYYYMMDD') = L.DATE_ID)
  LEFT OUTER JOIN DW_REPORT.TRANSACTION_TYPE M ON (NVL (A.CUSTOM_FORM_ID,-99) = M.TRANSACTION_TYPE_ID)
  LEFT OUTER JOIN DW_REPORT.LOCATIONS N ON (NVL (A.LOCATION_ID,-99) = N.LOCATION_ID)
  LEFT OUTER JOIN DW_REPORT.CLASSES O ON ('Book Fairs' = O.NAME)
  LEFT OUTER JOIN DW_REPORT.SUBSIDIARIES P ON (27 = P.SUBSIDIARY_ID)
  LEFT OUTER JOIN DW_REPORT.CUSTOMERS Q ON (A.CUSTOMER_ID = Q.CUSTOMER_ID) 
  WHERE 
  ((B.ACCOUNTING_PERIOD_KEY IS NULL AND A.ACCOUNTING_PERIOD_ID IS NOT NULL ) OR
  (C.TERRITORY_KEY IS NULL AND A.TERRITORY_ID IS NOT NULL ) OR
  (D.EMPLOYEE_KEY IS NULL AND A.SALES_REP_ID IS NOT NULL ) OR
  E.BOOK_FAIR_KEY IS NULL OR
  F.TRANSACTION_STATUS_KEY IS NULL OR
  (G.CURRENCY_KEY IS NULL AND A.CURRENCY_ID IS NOT NULL ) OR
  H.DATE_KEY IS NULL OR
  I.DATE_KEY IS NULL OR
  J.DATE_KEY IS NULL OR
  K.DATE_KEY IS NULL OR
  L.DATE_KEY IS NULL OR
  M.TRANSACTION_TYPE_KEY IS NULL OR
  N.LOCATION_KEY IS NULL OR
  O.CLASS_KEY IS NULL OR
  P.SUBSIDIARY_KEY IS NULL OR
  Q.CUSTOMER_KEY IS NULL )
AND   EXISTS (SELECT 1 FROM dw_prestage.opportunity_fact_update WHERE a.transaction_id = dw_prestage.opportunity_fact_update.transaction_id
                                                                      AND a.document_number = dw_prestage.opportunity_fact_update.document_number );