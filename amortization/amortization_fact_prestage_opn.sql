/* prestage - drop intermediate insert table */
DROP TABLE if exists dw_prestage.amortization_fact_insert;

/* prestage - create intermediate insert table*/
CREATE TABLE dw_prestage.amortization_fact_insert 
AS
SELECT *
FROM dw_prestage.amortization_fact a
WHERE not exists ( select 1 from dw_stage.amortization_fact b
where b.AMORTIZATION_PER_ISSUELEVE_ID = a.AMORTIZATION_PER_ISSUELEVE_ID);

/* prestage - drop intermediate update table*/
DROP TABLE if exists dw_prestage.amortization_fact_update;

/* prestage - create intermediate update table*/
CREATE TABLE dw_prestage.amortization_fact_update 
AS
SELECT *
FROM dw_prestage.amortization_fact a
WHERE
EXISTS
( 
SELECT 1 FROM
(
SELECT
   AMORTIZATION_PER_ISSUELEVE_ID 
  ,AMORTIZE_VALUE_PER_ISSUE_EXCL 
  ,AMORTIZE_VALUE_PER_ISSUE_INCL 
  ,COMPONENTS_ID                 
  ,DATE_CREATED                  
  ,DISCOUNTED_AMOUNT             
  ,DISCOUNTED_PRICE              
  ,IS_INACTIVE                   
  ,LAST_MODIFIED_DATE            
  ,LAST_SS_YYYYMM                
  ,LEVEL_ID                      
  ,LEVEL                         
  ,LINE_NO                       
  ,NO_OF_ISSUES                  
  ,NO_OF_SCHEDULED_CREATED       
  ,ORDER_TYPE_ID                 
  ,ORDER_TYPE                    
  ,RRP                           
  ,STO_END_DATE                  
  ,STO_ITEM_ID                   
  ,STO_NO_ID                     
  ,SUBSIDIARY_ID                 
  ,STO_START_DATE                           
FROM
 dw_prestage.amortization_fact A2
 WHERE NOT EXISTS ( select 1 from dw_prestage.amortization_fact_insert B2
where B2.AMORTIZATION_PER_ISSUELEVE_ID = A2.AMORTIZATION_PER_ISSUELEVE_ID)
MINUS
SELECT
   AMORTIZATION_PER_ISSUELEVE_ID 
  ,AMORTIZE_VALUE_PER_ISSUE_EXCL 
  ,AMORTIZE_VALUE_PER_ISSUE_INCL 
  ,COMPONENTS_ID                 
  ,DATE_CREATED                  
  ,DISCOUNTED_AMOUNT             
  ,DISCOUNTED_PRICE              
  ,IS_INACTIVE                   
  ,LAST_MODIFIED_DATE            
  ,LAST_SS_YYYYMM                
  ,LEVEL_ID                      
  ,LEVEL                         
  ,LINE_NO                       
  ,NO_OF_ISSUES                  
  ,NO_OF_SCHEDULED_CREATED       
  ,ORDER_TYPE_ID                 
  ,ORDER_TYPE                    
  ,RRP                           
  ,STO_END_DATE                  
  ,STO_ITEM_ID                   
  ,STO_NO_ID                     
  ,SUBSIDIARY_ID                 
  ,STO_START_DATE                       
FROM
 dw_stage.amortization_fact a1
WHERE EXISTS ( select 1 from dw_prestage.amortization_fact b1
where b1.AMORTIZATION_PER_ISSUELEVE_ID = a1.AMORTIZATION_PER_ISSUELEVE_ID)
AND NOT EXISTS ( select 1 from dw_prestage.amortization_fact_insert c1
where c1.AMORTIZATION_PER_ISSUELEVE_ID = a1.AMORTIZATION_PER_ISSUELEVE_ID)
) b
where b.AMORTIZATION_PER_ISSUELEVE_ID = a.AMORTIZATION_PER_ISSUELEVE_ID) ;    

/* prestage - drop intermediate no change track table*/
DROP TABLE if exists dw_prestage.amortization_fact_nochange;

/* prestage - create intermediate no change track table*/
CREATE TABLE dw_prestage.amortization_fact_nochange 
AS
SELECT AMORTIZATION_PER_ISSUELEVE_ID
FROM (SELECT AMORTIZATION_PER_ISSUELEVE_ID
      FROM dw_prestage.amortization_fact
      MINUS
      (SELECT AMORTIZATION_PER_ISSUELEVE_ID
      FROM dw_prestage.amortization_fact_insert
      UNION ALL
      SELECT AMORTIZATION_PER_ISSUELEVE_ID
      FROM dw_prestage.amortization_fact_update));

/* prestage-> no of amortization fact records ingested in staging */
SELECT count(1) FROM dw_prestage.amortization_fact;

/* prestage-> no of amortization fact records identified to inserted  */
SELECT count(1) FROM dw_prestage.amortization_fact_insert;

/* prestage-> no of amortization fact records identified to updated */
SELECT count(1) FROM dw_prestage.amortization_fact_update;

/* prestage-> no of amortization fact records identified as no change */
SELECT count(1) FROM dw_prestage.amortization_fact_nochange;

--D --A = B + C + D
/* stage -> delete from stage records to be updated */ 
DELETE
FROM dw_stage.amortization_fact USING dw_prestage.amortization_fact_update
WHERE dw_stage.amortization_fact.AMORTIZATION_PER_ISSUELEVE_ID = dw_prestage.amortization_fact_update.AMORTIZATION_PER_ISSUELEVE_ID;

/* stage -> insert into stage records which have been created */ 
INSERT INTO dw_stage.amortization_fact
SELECT *
FROM dw_prestage.amortization_fact_insert;

/* stage -> insert into stage records which have been updated */ 
INSERT INTO dw_stage.amortization_fact
SELECT *
FROM dw_prestage.amortization_fact
WHERE EXISTS (SELECT 1
              FROM dw_prestage.amortization_fact_update
              WHERE dw_prestage.amortization_fact_update.AMORTIZATION_PER_ISSUELEVE_ID = dw_prestage.amortization_fact.AMORTIZATION_PER_ISSUELEVE_ID);

/* fact -> INSERT NEW RECORDS WHICH HAS ALL VALID DIMENSIONS */ 
INSERT INTO dw.amortization_fact
(
   AMORTIZATION_PER_ISSUELEVE_ID 
  ,AMORTIZE_VALUE_PER_ISSUE_EXCL 
  ,AMORTIZE_VALUE_PER_ISSUE_INCL 
  ,COMPONENTS_KEY                
  ,DISCOUNTED_AMOUNT             
  ,DISCOUNTED_PRICE              
  ,IS_INACTIVE                   
  ,LAST_SS_YYYYMM                
  ,LEVEL_ID                      
  ,LEVEL                         
  ,LINE_NO                       
  ,NO_OF_ISSUES                  
  ,NO_OF_SCHEDULED_CREATED       
  ,ORDER_TYPE_ID                 
  ,ORDER_TYPE                    
  ,RRP                           
  ,STO_END_DATE_KEY              
  ,STO_ITEM_KEY                  
  ,STO_NO_ID                     
  ,SUBSIDIARY_KEY                
  ,STO_START_DATE_KEY            
  ,DATE_ACTIVE_FROM              
  ,DATE_ACTIVE_TO                
  ,DW_CURRENT  
)
SELECT
   AMORTIZATION_PER_ISSUELEVE_ID 
  ,AMORTIZE_VALUE_PER_ISSUE_EXCL 
  ,AMORTIZE_VALUE_PER_ISSUE_INCL  
  ,B.ITEM_KEY AS COMPONENTS_KEY
  ,DISCOUNTED_AMOUNT             
  ,DISCOUNTED_PRICE              
  ,IS_INACTIVE                   
  ,LAST_SS_YYYYMM                
  ,LEVEL_ID                      
  ,LEVEL                         
  ,LINE_NO                       
  ,NO_OF_ISSUES                  
  ,NO_OF_SCHEDULED_CREATED       
  ,ORDER_TYPE_ID                 
  ,ORDER_TYPE                    
  ,RRP                         
  ,C.DATE_KEY STO_END_DATE_KEY
  ,D.ITEM_KEY STO_ITEM_KEY  
  ,STO_NO_ID
  ,E.SUBSIDIARY_KEY   
  ,F.DATE_KEY STO_START_DATE_KEY
  ,SYSDATE AS DATE_ACTIVE_FROM
  ,'9999-12-31 11:59:59' AS DATE_ACTIVE_TO
  ,1 AS DW_CURRENT
FROM dw_prestage.amortization_fact_insert A
    INNER JOIN DW_REPORT.ITEMS B ON (NVL (A.COMPONENTS_ID,-99) = B.ITEM_ID)
    INNER JOIN DW.DWDATE C ON (NVL(TO_CHAR (A.STO_END_DATE,'YYYYMMDD'),'19000101') = C.DATE_ID)
    INNER JOIN DW_REPORT.ITEMS D ON (NVL (A.STO_ITEM_ID,-99) = D.ITEM_ID)
    INNER JOIN DW_REPORT.SUBSIDIARIES E ON (NVL (A.SUBSIDIARY_ID,-99) = E.SUBSIDIARY_ID)
    INNER JOIN DW.DWDATE F ON (NVL(TO_CHAR(A.STO_START_DATE,'YYYYMMDD'),'19000101') = F.DATE_ID); 
    
  
/* fact -> INSERT NEW RECORDS IN ERROR TABLE WHICH DOES NOT HAVE VALID DIMENSIONS */ 
INSERT INTO dw.amortization_fact_error
(
  RUNID
 ,AMORTIZATION_PER_ISSUELEVE_ID                                
 ,AMORTIZE_VALUE_PER_ISSUE_EXCL
 ,AMORTIZE_VALUE_PER_ISSUE_INCL
 ,COMPONENTS_ID                
 ,COMPONENTS_KEY               
 ,COMPONENTS_ID_ERROR          
 ,DISCOUNTED_AMOUNT            
 ,DISCOUNTED_PRICE             
 ,IS_INACTIVE                  
 ,LAST_SS_YYYYMM               
 ,LEVEL_ID                     
 ,LEVEL                        
 ,LINE_NO                      
 ,NO_OF_ISSUES                 
 ,NO_OF_SCHEDULED_CREATED      
 ,ORDER_TYPE_ID                
 ,ORDER_TYPE                   
 ,RRP                          
 ,STO_END_DATE                 
 ,STO_END_DATE_KEY             
 ,STO_END_DATE_ERROR           
 ,STO_ITEM_ID                  
 ,STO_ITEM_KEY                 
 ,STO_ITEM_ID_ERROR            
 ,STO_NO_ID                    
 ,SUBSIDIARY_ID                
 ,SUBSIDIARY_KEY               
 ,SUBSIDIARY_ID_ERROR          
 ,STO_START_DATE               
 ,STO_START_DATE_KEY           
 ,STO_START_DATE_ERROR         
 ,RECORD_STATUS                
 ,DW_CREATION_DATE
)
SELECT RUNID
      ,AMORTIZATION_PER_ISSUELEVE_ID 
      ,AMORTIZE_VALUE_PER_ISSUE_EXCL 
      ,AMORTIZE_VALUE_PER_ISSUE_INCL  
      ,COMPONENTS_ID           
      ,B.ITEM_KEY COMPONENTS_KEY          
      ,CASE
         WHEN (B.ITEM_KEY IS NULL AND A.COMPONENTS_ID  IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (B.ITEM_KEY IS NULL AND A.COMPONENTS_ID IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END COMPONENTS_ID_ERROR
        ,DISCOUNTED_AMOUNT             
        ,DISCOUNTED_PRICE              
        ,IS_INACTIVE                   
        ,LAST_SS_YYYYMM                
        ,LEVEL_ID                      
        ,LEVEL                         
        ,LINE_NO                       
        ,NO_OF_ISSUES                  
        ,NO_OF_SCHEDULED_CREATED       
        ,ORDER_TYPE_ID                 
        ,ORDER_TYPE                    
        ,RRP 
        ,STO_END_DATE                 
        ,C.DATE_KEY STO_END_DATE_KEY                             
       ,CASE
         WHEN (C.DATE_KEY  IS NULL AND A.STO_END_DATE IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (C.DATE_KEY IS NULL AND A.STO_END_DATE IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END STO_END_DATE_ERROR
      ,STO_ITEM_ID                  
      ,D.ITEM_KEY STO_ITEM_KEY  
      ,CASE
         WHEN (D.ITEM_KEY IS NULL AND A.STO_ITEM_ID  IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (D.ITEM_KEY IS NULL AND A.STO_ITEM_ID IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END STO_ITEM_ID_ERROR
       ,STO_NO_ID                    
        ,A.SUBSIDIARY_ID                
        ,E.SUBSIDIARY_KEY
       ,CASE
         WHEN (E.SUBSIDIARY_KEY IS NULL AND A.SUBSIDIARY_ID  IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (E.SUBSIDIARY_KEY IS NULL AND A.SUBSIDIARY_ID IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END SUBSIDIARY_ID_ERROR 
        ,STO_START_DATE               
        ,F.DATE_KEY STO_START_DATE_KEY  
        ,CASE
         WHEN (F.DATE_KEY  IS NULL AND A.STO_START_DATE IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (F.DATE_KEY IS NULL AND A.STO_START_DATE IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END STO_START_DATE_ERROR
      ,'ERROR' AS RECORD_STATUS
      ,SYSDATE AS DW_CREATION_DATE	   
FROM dw_prestage.amortization_fact_insert A
    LEFT OUTER  JOIN DW_REPORT.ITEMS B ON (A.COMPONENTS_ID = B.ITEM_ID)
    LEFT OUTER  JOIN DW.DWDATE C ON (TO_CHAR(A.STO_END_DATE,'YYYYMMDD') = C.DATE_ID)
    LEFT OUTER  JOIN DW_REPORT.ITEMS D ON (A.STO_ITEM_ID = D.ITEM_ID)
    LEFT OUTER  JOIN DW_REPORT.SUBSIDIARIES E ON (A.SUBSIDIARY_ID = E.SUBSIDIARY_ID)
    LEFT OUTER  JOIN DW.DWDATE F ON (TO_CHAR(A.STO_START_DATE,'YYYYMMDD') = F.DATE_ID)
  WHERE 
  ((B.ITEM_KEY IS NULL AND A.COMPONENTS_ID IS NOT NULL ) OR
  (D.ITEM_KEY IS NULL AND A.STO_ITEM_ID IS NOT NULL ) OR
  (C.DATE_KEY IS NULL AND A.STO_END_DATE IS NOT NULL ) OR
  (E.SUBSIDIARY_KEY IS NULL AND A.SUBSIDIARY_ID IS NOT NULL ) OR
  (F.DATE_KEY IS NULL AND A.STO_START_DATE IS NOT NULL ));

/* fact -> UPDATE THE OLD RECORDS SETTING THE CURRENT FLAG VALUE TO 0 */  
UPDATE dw.amortization_fact SET dw_current = 0,DATE_ACTIVE_TO = (sysdate -1) WHERE dw_current = 1
AND   sysdate>= date_active_from
AND   sysdate< date_active_to
AND   EXISTS (SELECT 1 FROM dw_prestage.amortization_fact_update 
WHERE dw.amortization_fact.AMORTIZATION_PER_ISSUELEVE_ID = dw_prestage.amortization_fact_update.AMORTIZATION_PER_ISSUELEVE_ID);

/* fact -> NOW INSERT THE FACT RECORDS WHICH HAVE BEEN UPDATED AT THE SOURCE */ 
INSERT INTO dw.amortization_fact
(
   AMORTIZATION_PER_ISSUELEVE_ID 
  ,AMORTIZE_VALUE_PER_ISSUE_EXCL 
  ,AMORTIZE_VALUE_PER_ISSUE_INCL 
  ,COMPONENTS_KEY                
  ,DISCOUNTED_AMOUNT             
  ,DISCOUNTED_PRICE              
  ,IS_INACTIVE                   
  ,LAST_SS_YYYYMM                
  ,LEVEL_ID                      
  ,LEVEL                         
  ,LINE_NO                       
  ,NO_OF_ISSUES                  
  ,NO_OF_SCHEDULED_CREATED       
  ,ORDER_TYPE_ID                 
  ,ORDER_TYPE                    
  ,RRP                           
  ,STO_END_DATE_KEY              
  ,STO_ITEM_KEY                  
  ,STO_NO_ID                     
  ,SUBSIDIARY_KEY                
  ,STO_START_DATE_KEY            
  ,DATE_ACTIVE_FROM              
  ,DATE_ACTIVE_TO                
  ,DW_CURRENT  
)
SELECT
   AMORTIZATION_PER_ISSUELEVE_ID 
  ,AMORTIZE_VALUE_PER_ISSUE_EXCL 
  ,AMORTIZE_VALUE_PER_ISSUE_INCL  
  ,B.ITEM_KEY AS COMPONENTS_KEY
  ,DISCOUNTED_AMOUNT             
  ,DISCOUNTED_PRICE              
  ,IS_INACTIVE                   
  ,LAST_SS_YYYYMM                
  ,LEVEL_ID                      
  ,LEVEL                         
  ,LINE_NO                       
  ,NO_OF_ISSUES                  
  ,NO_OF_SCHEDULED_CREATED       
  ,ORDER_TYPE_ID                 
  ,ORDER_TYPE                    
  ,RRP                         
  ,C.DATE_KEY STO_END_DATE_KEY
  ,D.ITEM_KEY STO_ITEM_KEY  
  ,STO_NO_ID
  ,E.SUBSIDIARY_KEY   
  ,F.DATE_KEY STO_START_DATE_KEY
  ,SYSDATE AS DATE_ACTIVE_FROM
  ,'9999-12-31 11:59:59' AS DATE_ACTIVE_TO
  ,1 AS DW_CURRENT
FROM dw_prestage.amortization_fact_update A
    INNER JOIN DW_REPORT.ITEMS B ON (NVL (A.COMPONENTS_ID,-99) = B.ITEM_ID)
    INNER JOIN DW.DWDATE C ON (NVL(TO_CHAR (A.STO_END_DATE,'YYYYMMDD'),'19000101') = C.DATE_ID)
    INNER JOIN DW_REPORT.ITEMS D ON (NVL (A.STO_ITEM_ID,-99) = D.ITEM_ID)
    INNER JOIN DW_REPORT.SUBSIDIARIES E ON (NVL (A.SUBSIDIARY_ID,-99) = E.SUBSIDIARY_ID)
    INNER JOIN DW.DWDATE F ON (NVL(TO_CHAR(A.STO_START_DATE,'YYYYMMDD'),'19000101') = F.DATE_ID); 

/* fact -> INSERT UPDATED RECORDS IN ERROR TABLE WHICH DOES NOT HAVE VALID DIMENSIONS */ 
INSERT INTO dw.amortization_fact_error
(
  RUNID 
 ,AMORTIZATION_PER_ISSUELEVE_ID                               
 ,AMORTIZE_VALUE_PER_ISSUE_EXCL
 ,AMORTIZE_VALUE_PER_ISSUE_INCL
 ,COMPONENTS_ID                
 ,COMPONENTS_KEY               
 ,COMPONENTS_ID_ERROR          
 ,DISCOUNTED_AMOUNT            
 ,DISCOUNTED_PRICE             
 ,IS_INACTIVE                  
 ,LAST_SS_YYYYMM               
 ,LEVEL_ID                     
 ,LEVEL                        
 ,LINE_NO                      
 ,NO_OF_ISSUES                 
 ,NO_OF_SCHEDULED_CREATED      
 ,ORDER_TYPE_ID                
 ,ORDER_TYPE                   
 ,RRP                          
 ,STO_END_DATE                 
 ,STO_END_DATE_KEY             
 ,STO_END_DATE_ERROR           
 ,STO_ITEM_ID                  
 ,STO_ITEM_KEY                 
 ,STO_ITEM_ID_ERROR            
 ,STO_NO_ID                    
 ,SUBSIDIARY_ID                
 ,SUBSIDIARY_KEY               
 ,SUBSIDIARY_ID_ERROR          
 ,STO_START_DATE               
 ,STO_START_DATE_KEY           
 ,STO_START_DATE_ERROR         
 ,RECORD_STATUS                
 ,DW_CREATION_DATE
)
SELECT RUNID
      ,AMORTIZATION_PER_ISSUELEVE_ID 
      ,AMORTIZE_VALUE_PER_ISSUE_EXCL 
      ,AMORTIZE_VALUE_PER_ISSUE_INCL  
      ,COMPONENTS_ID           
      ,B.ITEM_KEY COMPONENTS_KEY          
      ,CASE
         WHEN (B.ITEM_KEY IS NULL AND A.COMPONENTS_ID  IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (B.ITEM_KEY IS NULL AND A.COMPONENTS_ID IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END COMPONENTS_ID_ERROR
        ,DISCOUNTED_AMOUNT             
        ,DISCOUNTED_PRICE              
        ,IS_INACTIVE                   
        ,LAST_SS_YYYYMM                
        ,LEVEL_ID                      
        ,LEVEL                         
        ,LINE_NO                       
        ,NO_OF_ISSUES                  
        ,NO_OF_SCHEDULED_CREATED       
        ,ORDER_TYPE_ID                 
        ,ORDER_TYPE                    
        ,RRP 
        ,STO_END_DATE                 
        ,C.DATE_KEY STO_END_DATE_KEY                             
       ,CASE
         WHEN (C.DATE_KEY  IS NULL AND A.STO_END_DATE IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (C.DATE_KEY IS NULL AND A.STO_END_DATE IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END STO_END_DATE_ERROR
      ,STO_ITEM_ID                  
      ,D.ITEM_KEY STO_ITEM_KEY  
      ,CASE
         WHEN (D.ITEM_KEY IS NULL AND A.STO_ITEM_ID  IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (D.ITEM_KEY IS NULL AND A.STO_ITEM_ID IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END STO_ITEM_ID_ERROR
       ,STO_NO_ID                    
        ,A.SUBSIDIARY_ID                
        ,E.SUBSIDIARY_KEY
       ,CASE
         WHEN (E.SUBSIDIARY_KEY IS NULL AND A.SUBSIDIARY_ID  IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (E.SUBSIDIARY_KEY IS NULL AND A.SUBSIDIARY_ID IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END SUBSIDIARY_ID_ERROR 
        ,STO_START_DATE               
        ,F.DATE_KEY STO_START_DATE_KEY  
        ,CASE
         WHEN (F.DATE_KEY  IS NULL AND A.STO_START_DATE IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (F.DATE_KEY IS NULL AND A.STO_START_DATE IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END STO_START_DATE_ERROR
      ,'ERROR' AS RECORD_STATUS
      ,SYSDATE AS DW_CREATION_DATE	   
FROM dw_prestage.amortization_fact_update A
    LEFT OUTER  JOIN DW_REPORT.ITEMS B ON (A.COMPONENTS_ID = B.ITEM_ID)
    LEFT OUTER  JOIN DW.DWDATE C ON (TO_CHAR(A.STO_END_DATE,'YYYYMMDD') = C.DATE_ID)
    LEFT OUTER  JOIN DW_REPORT.ITEMS D ON (A.STO_ITEM_ID = D.ITEM_ID)
    LEFT OUTER  JOIN DW_REPORT.SUBSIDIARIES E ON (A.SUBSIDIARY_ID = E.SUBSIDIARY_ID)
    LEFT OUTER  JOIN DW.DWDATE F ON (TO_CHAR(A.STO_START_DATE,'YYYYMMDD') = F.DATE_ID)
  WHERE 
  ((B.ITEM_KEY IS NULL AND A.COMPONENTS_ID IS NOT NULL ) OR
  (D.ITEM_KEY IS NULL AND A.STO_ITEM_ID IS NOT NULL ) OR
  (C.DATE_KEY IS NULL AND A.STO_END_DATE IS NOT NULL ) OR
  (E.SUBSIDIARY_KEY IS NULL AND A.SUBSIDIARY_ID IS NOT NULL ) OR
  (F.DATE_KEY IS NULL AND A.STO_START_DATE IS NOT NULL ));
