SELECT
  TO_CHAR(STANDING_ORDER_SCHEDULE_ID) AS STANDING_ORDER_SCHEDULE_ID
  ,ACTUAL_SHIPMENT_DATE          
  ,AMORTIZATION_VALUE_EXCL__GST  
  ,AMORTIZATION_VALUE_INCL__GST  
  ,TO_CHAR(CUSTOMER_ID) AS CUSTOMER_ID                   
  ,DATE_CREATED                  
  ,EXPECTED_SHIPMENT_DATE        
  ,INVOICE_AMOUNT                
  ,TO_CHAR(INVOICE_NO__ID) AS  INVOICE_NO__ID               
  ,IS_INACTIVE                   
  ,LAST_MODIFIED_DATE            
  ,TO_CHAR(LEVEL_ID) AS  LEVEL_ID                    
  ,LINE_NO                       
  ,TO_CHAR(A.ORDER_TYPE_ID) AS  ORDER_TYPE_ID                
  ,B.LIST_ITEM_NAME AS ORDER_TYPE                    
  ,PICK_SLIP_NUMBER              
  ,TO_CHAR(PRODUCT_CATALOGUE_LIST_ID) AS  PRODUCT_CATALOGUE_LIST_ID    
  ,TO_CHAR(SALES_ORDER_NO__ID) AS  SALES_ORDER_NO__ID          
  ,SCHEDULE_CLOSED               
  ,SHIPMENT_NO_                  
  ,SHIPMENT_YYYYMM               
  ,TO_CHAR(STO_ITEM_ID) AS STO_ITEM_ID                   
  ,STO_NO_TEXT                   
  ,TO_CHAR(STO_NO__ID) AS STO_NO__ID                    
  ,TO_CHAR(C.SUBSIDIARY_ID) AS SUBSIDIARY_ID
  FROM
 STANDING_ORDER_SCHEDULE A
 LEFT OUTER JOIN ORDER_TYPE B ON (A.ORDER_TYPE_ID = B.LIST_ID )
 LEFT OUTER JOIN PRODUCT_CATALOGUE C ON (A.PRODUCT_CATALOGUE_LIST_ID = C.PRODUCT_CATALOGUE_ID)
WHERE C.SUBSIDIARY_ID = '%s'
AND A.LAST_MODIFIED_DATE >= to_timestamp('%s','YYYY-MM-DD HH24:MI:SS')
ORDER BY STANDING_ORDER_SCHEDULE_ID,SUBSIDIARY_ID,CUSTOMER_ID,PRODUCT_CATALOGUE_LIST_ID ;
                 