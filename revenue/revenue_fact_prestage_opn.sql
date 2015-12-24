insert into dw.revenue_fact
(
DOCUMENT_NUMBER             
,TRANSACTION_ID             
,TRANSACTION_LINE_ID        
,REF_DOC_NUMBER             
,REF_DOC_TYPE               
,TERMS_KEY                  
,REVENUE_COMMITMENT_STATUS  
,REVENUE_STATUS             
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
,DOCUMENT_STATUS            
,DOCUMENT_TYPE              
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
,LAST_MODIFIED_DATE         
)
select 
TRANSACTION_NUMBER        
,TRANSACTION_ID            
,TRANSACTION_LINE_ID       
,REF_DOC_NUMBER            
,REF_DOC_TYPE              
,b.PAYMENT_TERM_KEY AS TERMS_KEY
,REVENUE_COMMITMENT_STATUS 
,REVENUE_STATUS 
,c.territory_key
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
,STATUS  as DOCUMENT_STATUS  
,TRANSACTION_TYPE       as DOCUMENT_TYPE
,d.currency_key
,e.date_key as TRANSACTION_DATE_KEY       
,EXCHANGE_RATE             
,f.account_key
,AMOUNT                     
,AMOUNT_FOREIGN             
,GROSS_AMOUNT               
,NET_AMOUNT                 
,NET_AMOUNT_FOREIGN         
,QUANTITY                   
 ,g.item_key
 ,ITEM_UNIT_PRICE        as rate
 ,h.TAX_ITEM_KEY
 ,TAX_AMOUNT                 
 ,k.location_key
 ,l.class_key 
 ,j.subsidiary_key
 ,m.customer_key
 ,create_date 
 from dw_prestage.revenue_fact a /* 18555 */
 INNER JOIN DW.PAYMENT_TERMS b ON (NVL (A.PAYMENT_TERMS_ID,-99) = b.PAYMENT_TERMS_ID)
 INNER JOIN DW.territories c ON (NVL (A.sales_rep_ID,-99) = c.territory_ID)
 INNER JOIN DW.CURRENCIES d ON (NVL (A.CURRENCY_ID,-99) = d.CURRENCY_ID)
 INNER JOIN DW.DWDATE e ON (NVL (TO_CHAR (A.tranDATE,'YYYYMMDD'),'0') = e.DATE_ID)
 INNER JOIN DW.ACCOUNTS F ON (NVL (A.account_ID,-99) = f.account_ID)
 INNER JOIN DW.ITEMS g ON (NVL (A.ITEM_ID,-99) = g.ITEM_ID)
 INNER JOIN DW.TAX_ITEMS h ON (NVL (A.TAX_ITEM_ID,-99) = h.ITEM_ID)
 INNER JOIN DW.SUBSIDIARIES j ON (NVL (A.SUBSIDIARY_ID,-99) = j.SUBSIDIARY_ID)  
  INNER JOIN DW.LOCATIONS k ON (NVL (A.LOCATION_ID,-99) = k.LOCATION_ID)
  INNER JOIN DW.CLASSES l ON (NVL(A.CLASS_ID,-99) = l.CLASS_ID) 
  INNER JOIN DW.customers m ON (NVL(A.customer_ID,-99) = m.customer_ID) 
where trx_type in ('INV_LINE','RA_LINE','CN_LINE','JN_LINE' )