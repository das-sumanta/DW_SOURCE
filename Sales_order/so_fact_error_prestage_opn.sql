/* error prestage - drop intermediate error prestage table */
DROP TABLE IF EXISTS DW_PRESTAGE.SO_FACT_ERROR;

/* prestage - create intermediate insert table*/
CREATE TABLE DW_PRESTAGE.SO_FACT_ERROR
AS
SELECT
       A.RUNID
     ,A.DOCUMENT_NUMBER                   
     ,A.TRANSACTION_NUMBER               
     ,A.TRANSACTION_ID                   
     ,A.TRANSACTION_LINE_ID              
     ,A.REF_DOC_NUMBER                   
     ,NVL(A.REF_DOC_TYPE_KEY,n.transaction_type_key) AS REF_DOC_TYPE_KEY           
     ,NVL(A.TERMS_KEY,b.PAYMENT_TERM_KEY) AS TERMS_KEY                      
     ,A.REVENUE_COMMITMENT_STATUS                            
     ,A.REVENUE_STATUS                                       
     ,NVL(A.SALES_REP_KEY,r.employee_key) SALES_REP_KEY                         
     ,NVL(A.territory_key,c.territory_key) AS  territory_key                                     
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
     ,NVL(A.DOCUMENT_STATUS_KEY,o.transaction_status_key)  as DOCUMENT_STATUS_KEY 
     ,NVL(A.DOCUMENT_TYPE_KEY,p.transaction_type_key)    as DOCUMENT_TYPE_KEY  
     ,NVL(A.currency_key,d.currency_key) as currency_key                                        
     ,NVL(a.TRANSACTION_DATE_KEY,e.date_key) as TRANSACTION_DATE_KEY                   
     ,EXCHANGE_RATE                                       
     ,NVL(A.account_key,f.account_key) AS  account_key                                       
     ,AMOUNT                                               
     ,AMOUNT_FOREIGN                                       
     ,GROSS_AMOUNT                                         
     ,NET_AMOUNT                                           
     ,NET_AMOUNT_FOREIGN                                   
     ,RRP                                                  
     ,AVG_COST                                             
     ,QUANTITY                                             
     ,COMMITTED_QUANTITY                                   
     ,NVL(A.item_key,g.item_key ) AS  item_key                                         
     ,REWARDS_EARN                                         
     ,REWARD_BALANCE                                       
     ,ITEM_UNIT_PRICE as rate                             
     ,NVL(A.TAX_ITEM_KEY,h.TAX_ITEM_KEY) AS  TAX_ITEM_KEY                                      
     ,TAX_AMOUNT                                            
     ,NVL(A.location_key,k.location_key) AS location_key                                       
     ,NVL(A.class_key,l.class_key ) AS class_key                                          
     ,NVL(A.subsidiary_key,j.subsidiary_key) AS  subsidiary_key                                    
     ,NVL(A.accounting_period_key,q.accounting_period_key) AS  accounting_period_key                             
     ,NVL(A.customer_key,m.customer_key) AS customer_key                                       
     ,PRICE_TYPE_ID                                        
     ,PRICE_TYPE                                           
     ,NVL(A.PRODUCT_CATALOGUE_KEY,t.PRODUCT_CATALOGUE_KEY) AS  PRODUCT_CATALOGUE_KEY     
     ,BROCHURE_CODE              
     ,NVL(A.TEACHER_KEY,u.CUSTOMER_KEY) AS TEACHER_KEY                
     ,NVL(A.BOOK_FAIRS_CONSULTANT_KEY,v.EMPLOYEE_KEY) AS BOOK_FAIRS_CONSULTANT_KEY  
     ,NEXT_ACTION                
     ,NVL(A.prepack_key,s.item_key) AS prepack_key
     ,'PROCESSED'  RECORD_STATUS
     ,SYSDATE  DW_CREATION_DATE
 FROM DW.SO_FACT_ERROR A
 INNER JOIN DW_REPORT.PAYMENT_TERMS b ON (NVL (A.PAYMENT_TERMS_ID,-99) = b.PAYMENT_TERMS_ID)
 INNER JOIN DW_REPORT.territories c ON (NVL (A.sales_territory_ID,-99) = c.territory_ID)
 INNER JOIN DW_REPORT.CURRENCIES d ON (A.CURRENCY_ID = d.CURRENCY_ID)
 INNER JOIN DW_REPORT.DWDATE e ON (TO_CHAR (A.tranDATE,'YYYYMMDD') = e.DATE_ID)
 INNER JOIN DW_REPORT.ACCOUNTS F ON (NVL (A.account_ID,-99) = f.account_ID)
 INNER JOIN DW_REPORT.ITEMS g ON (A.ITEM_ID = g.ITEM_ID)
 INNER JOIN DW_REPORT.TAX_ITEMS h ON (NVL(A.TAX_ITEM_ID,-99) = h.ITEM_ID)
 INNER JOIN DW_REPORT.SUBSIDIARIES j ON (A.SUBSIDIARY_ID = j.SUBSIDIARY_ID)
 INNER JOIN DW_REPORT.LOCATIONS k ON (NVL (A.LOCATION_ID,-99) = k.LOCATION_ID)
 INNER JOIN DW_REPORT.CLASSES l ON (NVL(A.CLASS_ID,-99) = l.CLASS_ID)
 INNER JOIN DW_REPORT.customers m ON (A.customer_ID = m.customer_ID)
 INNER JOIN DW_REPORT.transaction_type n ON (NVL(A.ref_custom_form_id,-99) = n.transaction_type_id)
 INNER JOIN DW_REPORT.transaction_status o ON (NVL(A.STATUS,'NA_GDW') = o.status AND NVL(A.TRANSACTION_TYPE,'NA_GDW') = o.DOCUMENT_TYPE)
 INNER JOIN DW_REPORT.transaction_type p ON (A.custom_form_id = p.transaction_type_id)
 INNER JOIN DW_REPORT.accounting_period q ON (NVL(A.accounting_period_id,-99) = q.accounting_period_id)
 INNER JOIN DW_REPORT.employees r ON (NVL(A.sales_rep_id,-99) = r.employee_id)
 INNER JOIN DW_REPORT.ITEMS s ON (NVL(A.PREPACK_ID,-99) = s.ITEM_ID)
 INNER JOIN DW_REPORT.PRODUCT_CATALOGUE t ON (NVL(A.PRODUCT_CATALOGUE_ID,-99) = t.PRODUCT_CATALOGUE_ID)
 INNER JOIN DW_REPORT.CUSTOMERS u ON (NVL(A.teacher_ID,-99) = u.CUSTOMER_ID)
 INNER JOIN DW_REPORT.employees v ON (NVL(A.BOOK_FAIRS_CONSULTANT_id,-99) = v.employee_id)
WHERE A.RUNID = NVL(RUNID_ERR,A.RUNID)
AND A.RECORD_STATUS = 'ERROR';

/* prestage-> identify new revenue fact records */
UPDATE DW_PRESTAGE.SO_FACT_ERROR
 SET RECORD_STATUS = 'INSERT'
 WHERE NOT EXISTS
 (SELECT 1 FROM DW_REPORT.SO_FACT B
 WHERE DW_PRESTAGE.SO_FACT_ERROR.TRANSACTION_ID = B.TRANSACTION_ID
 AND DW_PRESTAGE.SO_FACT_ERROR.TRANSACTION_LINE_ID = B.TRANSACTION_LINE_ID
 AND DW_PRESTAGE.SO_FACT_ERROR.SUBSIDIARY_KEY = B.SUBSIDIARY_KEY );

/* prestage-> no of sales fact records reprocessed in staging*/
SELECT count(1) FROM dw_prestage.SO_FACT_error;

/* prestage-> no of sales fact records identified as new*/
SELECT count(1) FROM dw_prestage.SO_FACT_error where RECORD_STATUS = 'INSERT';

/* prestage-> no of sales fact records identified to be updated*/
SELECT count(1) FROM dw_prestage.SO_FACT_error where RECORD_STATUS = 'PROCESSED';

/* fact -> INSERT REPROCESSED RECORDS WHICH HAS ALL VALID DIMENSIONS */
INSERT INTO dw.SO_FACT
(
   DOCUMENT_NUMBER             
  ,TRANSACTION_NUMBER         
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
  ,RRP                        
  ,AVG_COST                   
  ,QUANTITY                   
  ,COMMITTED_QUANTITY         
  ,ITEM_KEY                   
  ,REWARDS_EARN               
  ,REWARD_BALANCE             
  ,ITEM_UNIT_PRICE            
  ,TAX_ITEM_KEY               
  ,TAX_AMOUNT                 
  ,LOCATION_KEY               
  ,CLASS_KEY                  
  ,SUBSIDIARY_KEY             
  ,ACCOUNTING_PERIOD_KEY      
  ,CUSTOMER_KEY               
  ,PRICE_TYPE_ID              
  ,PRICE_TYPE                 
  ,PRODUCT_CATALOGUE_KEY      
  ,BROCHURE_CODE              
  ,TEACHER_KEY                
  ,BOOK_FAIRS_CONSULTANT_KEY  
  ,NEXT_ACTION                
  ,PREPACK_KEY                
  ,DATE_ACTIVE_FROM           
  ,DATE_ACTIVE_TO             
  ,DW_CURRENT 
)
SELECT
   A.DOCUMENT_NUMBER             
  ,A.TRANSACTION_NUMBER         
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
  ,A.RRP                        
  ,A.AVG_COST                   
  ,A.QUANTITY                   
  ,A.COMMITTED_QUANTITY         
  ,A.ITEM_KEY                   
  ,A.REWARDS_EARN               
  ,A.REWARD_BALANCE             
  ,A.rate           
  ,A.TAX_ITEM_KEY               
  ,A.TAX_AMOUNT                 
  ,A.LOCATION_KEY               
  ,A.CLASS_KEY                  
  ,A.SUBSIDIARY_KEY             
  ,A.ACCOUNTING_PERIOD_KEY      
  ,A.CUSTOMER_KEY               
  ,A.PRICE_TYPE_ID              
  ,A.PRICE_TYPE                 
  ,A.PRODUCT_CATALOGUE_KEY      
  ,A.BROCHURE_CODE              
  ,A.TEACHER_KEY                
  ,A.BOOK_FAIRS_CONSULTANT_KEY  
  ,A.NEXT_ACTION                
  ,A.PREPACK_KEY                
 ,SYSDATE AS DATE_ACTIVE_FROM
 ,'9999-12-31 11:59:59' AS DATE_ACTIVE_TO
 ,1 AS DW_CURRENT
 FROM
 DW_PRESTAGE.SO_FACT_ERROR A
 WHERE 
 RECORD_STATUS = 'INSERT';
 
 /* fact -> UPDATE THE OLD RECORDS SETTING THE CURRENT FLAG VALUE TO 0 */
UPDATE dw.SO_FACT SET dw_current = 0,DATE_ACTIVE_TO = (sysdate -1) WHERE dw_current = 1
AND   sysdate>= date_active_from
AND   sysdate< date_active_to
AND   EXISTS (SELECT 1 FROM dw_prestage.SO_FACT_error
  WHERE dw.SO_FACT.transaction_ID = dw_prestage.SO_FACT_error.transaction_id
  AND   dw.SO_FACT.transaction_LINE_ID = dw_prestage.SO_FACT_error.transaction_line_id
  AND dw.SO_FACT.subsidiary_KEY = dw_prestage.SO_FACT_error.subsidiary_key
  AND dw_prestage.SO_FACT_error.RECORD_STATUS = 'PROCESSED');
  
/* fact -> INSERT UPDATED REPROCESSED RECORDS WHICH HAVE ALL VALID DIMENSIONS*/
INSERT INTO dw.SO_FACT
(
   DOCUMENT_NUMBER             
  ,TRANSACTION_NUMBER         
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
  ,RRP                        
  ,AVG_COST                   
  ,QUANTITY                   
  ,COMMITTED_QUANTITY         
  ,ITEM_KEY                   
  ,REWARDS_EARN               
  ,REWARD_BALANCE             
  ,ITEM_UNIT_PRICE            
  ,TAX_ITEM_KEY               
  ,TAX_AMOUNT                 
  ,LOCATION_KEY               
  ,CLASS_KEY                  
  ,SUBSIDIARY_KEY             
  ,ACCOUNTING_PERIOD_KEY      
  ,CUSTOMER_KEY               
  ,PRICE_TYPE_ID              
  ,PRICE_TYPE                 
  ,PRODUCT_CATALOGUE_KEY      
  ,BROCHURE_CODE              
  ,TEACHER_KEY                
  ,BOOK_FAIRS_CONSULTANT_KEY  
  ,NEXT_ACTION                
  ,PREPACK_KEY                
  ,DATE_ACTIVE_FROM           
  ,DATE_ACTIVE_TO             
  ,DW_CURRENT 
)
SELECT
   A.DOCUMENT_NUMBER             
  ,A.TRANSACTION_NUMBER         
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
  ,A.RRP                        
  ,A.AVG_COST                   
  ,A.QUANTITY                   
  ,A.COMMITTED_QUANTITY         
  ,A.ITEM_KEY                   
  ,A.REWARDS_EARN               
  ,A.REWARD_BALANCE             
  ,A.RATE            
  ,A.TAX_ITEM_KEY               
  ,A.TAX_AMOUNT                 
  ,A.LOCATION_KEY               
  ,A.CLASS_KEY                  
  ,A.SUBSIDIARY_KEY             
  ,A.ACCOUNTING_PERIOD_KEY      
  ,A.CUSTOMER_KEY               
  ,A.PRICE_TYPE_ID              
  ,A.PRICE_TYPE                 
  ,A.PRODUCT_CATALOGUE_KEY      
  ,A.BROCHURE_CODE              
  ,A.TEACHER_KEY                
  ,A.BOOK_FAIRS_CONSULTANT_KEY  
  ,A.NEXT_ACTION                
  ,A.PREPACK_KEY                
 ,SYSDATE AS DATE_ACTIVE_FROM
 ,'9999-12-31 11:59:59' AS DATE_ACTIVE_TO
 ,1 AS DW_CURRENT
 FROM
 DW_PRESTAGE.SO_FACT_ERROR A
 WHERE 
 RECORD_STATUS = 'PROCESSED';
 
/* fact -> UPDATE THE ERROR TABLE TO SET THE SATUS AS PROCESSED */
UPDATE dw.SO_FACT_error SET RECORD_STATUS = 'PROCESSED'
where exists ( select 1 from dw_prestage.SO_FACT_error b
  WHERE dw.SO_FACT_error.RUNID = b.RUNID
  AND dw.SO_FACT_error.transaction_id = b.transaction_id
  AND dw.SO_FACT_error.transaction_line_id = b.transaction_line_id);