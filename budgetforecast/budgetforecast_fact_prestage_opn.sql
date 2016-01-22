/* prestage - drop intermediate insert table */
DROP TABLE if exists dw_prestage.budgetforecast_fact_insert;

/* prestage - create intermediate insert table*/
CREATE TABLE dw_prestage.budgetforecast_fact_insert 
AS
SELECT *
FROM dw_prestage.budgetforecast_fact a
WHERE not exists ( select 1 from dw_stage.budgetforecast_fact b
where b.budgetforecast_id = a.budgetforecast_id
AND b.subsidiary_id = a.subsidiary_id);

/* prestage - drop intermediate update table*/
DROP TABLE if exists dw_prestage.budgetforecast_fact_update;

/* prestage - create intermediate update table*/
CREATE TABLE dw_prestage.budgetforecast_fact_update 
AS
SELECT *
FROM dw_prestage.budgetforecast_fact a
WHERE not exists ( select 1 from dw_prestage.budgetforecast_fact_insert b
where b.budgetforecast_id = a.budgetforecast_id);

/* prestage - drop intermediate no change track table*/
DROP TABLE if exists dw_prestage.budgetforecast_fact_nochange;

/* prestage - create intermediate no change track table*/
CREATE TABLE dw_prestage.budgetforecast_fact_nochange 
AS
SELECT budgetforecast_ID
FROM (SELECT budgetforecast_ID
      FROM dw_prestage.budgetforecast_fact
      MINUS
      (SELECT budgetforecast_ID
      FROM dw_prestage.budgetforecast_fact_insert
      UNION ALL
      SELECT budgetforecast_ID
      FROM dw_prestage.budgetforecast_fact_update));

/* prestage-> stage*/
SELECT 'no of budgetforecast fact records ingested in staging -->' ||count(1)
FROM dw_prestage.budgetforecast_fact;

/* prestage-> stage*/
SELECT 'no of budgetforecast fact records identified to inserted -->' ||count(1)
FROM dw_prestage.budgetforecast_fact_insert;

/* prestage-> stage*/
SELECT 'no of budgetforecast fact records identified to updated -->' ||count(1)
FROM dw_prestage.budgetforecast_fact_update;

/* prestage-> stage*/
SELECT 'no of budgetforecast fact records identified as no change -->' ||count(1)
FROM dw_prestage.budgetforecast_fact_nochange;

--D --A = B + C + D
/* stage -> delete from stage records to be updated */ 
DELETE
FROM dw_stage.budgetforecast_fact USING dw_prestage.budgetforecast_fact_update
WHERE dw_stage.budgetforecast_fact.budgetforecast_id = dw_prestage.budgetforecast_fact_update.budgetforecast_id;

/* stage -> insert into stage records which have been created */ 
INSERT INTO dw_stage.budgetforecast_fact
SELECT *
FROM dw_prestage.budgetforecast_fact_insert;

/* stage -> insert into stage records which have been updated */ 
INSERT INTO dw_stage.budgetforecast_fact
SELECT *
FROM dw_prestage.budgetforecast_fact
WHERE EXISTS (SELECT 1
              FROM dw_prestage.budgetforecast_fact_update
              WHERE dw_prestage.budgetforecast_fact_update.budgetforecast_id = dw_prestage.budgetforecast_fact.budgetforecast_id);

COMMIT;

/* fact -> INSERT NEW RECORDS WHICH HAS ALL VALID DIMENSIONS */ 
INSERT INTO dw.budgetforecast_fact
(
  BUDGETFORECAST_ID   
 ,BUDGETFORECAST_NAME   
 ,FISCAL_MONTH_ID       
 ,FISCAL_WEEK_ID        
 ,CLASS_KEY             
 ,TERRITORY_KEY         
 ,SUBSIDIARY_KEY        
 ,BUDGETFORECAST_TYPE   
 ,MONTH_END_DATE        
 ,MONTH_START_DATE      
 ,WEEK_START_DATE       
 ,WEEK_END_DATE         
 ,AMOUNT                
 ,IS_INACTIVE           
 ,CREATION_DATE         
 ,LAST_MODIFIED_DATE    
 ,DATE_ACTIVE_FROM      
 ,DATE_ACTIVE_TO        
 ,DW_CURRENT            
  )  
SELECT 
  A.BUDGETFORECAST_ID   
 ,A.BUDGETFORECAST_NAME   
 ,A.FISCAL_MONTH_ID       
 ,A.FISCAL_WEEK_ID
 ,B.CLASS_KEY
 ,C.TERRITORY_KEY
 ,D.SUBSIDIARY_KEY        
 ,BUDGETFORECAST_TYPE   
 ,MONTH_END_DATE        
 ,MONTH_START_DATE      
 ,WEEK_START_DATE       
 ,WEEK_END_DATE         
 ,AMOUNT                
 ,A.IS_INACTIVE           
 ,DATE_CREATED         
 ,LAST_MODIFIED_DATE    
 ,SYSDATE AS DATE_ACTIVE_FROM
 ,'9999-12-31 11:59:59' AS DATE_ACTIVE_TO
 ,1 AS DW_CURRENT
 FROM
  dw_prestage.budgetforecast_fact_insert A
  INNER JOIN DW_REPORT.CLASSES B ON (A.LINE_OF_BUSINESS_ID = B.CLASS_ID) 
  INNER JOIN DW_REPORT.territories C ON (A.REGIONSALES_TERRITORY_ID = C.TERRITORY_ID)
  INNER JOIN DW_REPORT.SUBSIDIARIES D ON (A.SUBSIDIARY_ID = D.SUBSIDIARY_ID);
  
/* fact -> INSERT NEW RECORDS IN ERROR TABLE WHICH DOES NOT HAVE VALID DIMENSIONS */ 
INSERT INTO dw.budgetforecast_fact_error
(
  RUNID,
  BUDGETFORECAST_ID,
  BUDGETFORECAST_NAME,
  FISCAL_MONTH_ID,
  FISCAL_WEEK_ID,
  CLASS_KEY,
  CLASS_ID,
  CLASS_ID_ERROR,
  TERRITORY_KEY,
  TERRITORY_ID,
  TERRITORY_ID_ERROR,
  SUBSIDIARY_KEY,
  SUBSIDIARY_ID,
  SUBSIDIARY_ID_ERROR,
  BUDGETFORECAST_TYPE,
  MONTH_END_DATE,
  MONTH_START_DATE,
  WEEK_START_DATE,
  WEEK_END_DATE,
  AMOUNT,
  IS_INACTIVE,
  CREATION_DATE,
  LAST_MODIFIED_DATE,
  RECORD_STATUS,
  DW_CREATION_DATE
)
SELECT A.RUNID,
       A.BUDGETFORECAST_ID,
       A.BUDGETFORECAST_NAME,
       A.FISCAL_MONTH_ID,
       A.FISCAL_WEEK_ID,
       B.CLASS_KEY,
       A.LINE_OF_BUSINESS_ID,
       CASE
         WHEN (B.CLASS_KEY IS NULL AND A.LINE_OF_BUSINESS_ID IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (B.CLASS_KEY IS NULL AND A.LINE_OF_BUSINESS_ID IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END 
,
       C.TERRITORY_KEY,
       A.REGIONSALES_TERRITORY_ID,
       CASE
         WHEN (C.TERRITORY_KEY IS NULL AND A.REGIONSALES_TERRITORY_ID IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (C.TERRITORY_KEY IS NULL AND A.REGIONSALES_TERRITORY_ID IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END 
,
       D.SUBSIDIARY_KEY,
       A.SUBSIDIARY_ID,
       CASE
         WHEN (D.SUBSIDIARY_KEY IS NULL AND A.SUBSIDIARY_ID IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (D.SUBSIDIARY_KEY IS NULL AND A.SUBSIDIARY_ID IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END 
,
       BUDGETFORECAST_TYPE,
       MONTH_END_DATE,
       MONTH_START_DATE,
       WEEK_START_DATE,
       WEEK_END_DATE,
       AMOUNT,
       A.IS_INACTIVE,
       DATE_CREATED,
       LAST_MODIFIED_DATE,
       'ERROR' AS RECORD_STATUS,
       SYSDATE AS DW_CREATION_DATE
FROM dw_prestage.budgetforecast_fact_insert A
  LEFT OUTER JOIN DW_REPORT.CLASSES B ON (A.LINE_OF_BUSINESS_ID = B.CLASS_ID)
  LEFT OUTER JOIN DW_REPORT.territories C ON (A.REGIONSALES_TERRITORY_ID = C.TERRITORY_ID)
  LEFT OUTER JOIN DW_REPORT.SUBSIDIARIES D
               ON (A.SUBSIDIARY_ID = D.SUBSIDIARY_ID)
              AND (B.CLASS_KEY IS NULL
               OR C.TERRITORY_KEY IS NULL
               OR D.SUBSIDIARY_KEY IS NULL);

/* fact -> UPDATE THE OLD RECORDS SETTING THE CURRENT FLAG VALUE TO 0 */  
UPDATE dw.budgetforecast_fact SET dw_current = 0,DATE_ACTIVE_TO = (sysdate -1) WHERE dw_current = 1
AND   sysdate>= date_active_from
AND   sysdate< date_active_to
AND   EXISTS (SELECT 1 FROM dw_prestage.budgetforecast_fact_update WHERE dw.budgetforecast_fact.budgetforecast_id = dw_prestage.budgetforecast_fact_update.budgetforecast_id);

/* fact -> NOW INSERT THE FACT RECORDS WHICH HAVE BEEN UPDATED AT THE SOURCE */ 
INSERT INTO dw.budgetforecast_fact
(
  BUDGETFORECAST_ID   
 ,BUDGETFORECAST_NAME   
 ,FISCAL_MONTH_ID       
 ,FISCAL_WEEK_ID        
 ,CLASS_KEY             
 ,TERRITORY_KEY         
 ,SUBSIDIARY_KEY        
 ,BUDGETFORECAST_TYPE   
 ,MONTH_END_DATE        
 ,MONTH_START_DATE      
 ,WEEK_START_DATE       
 ,WEEK_END_DATE         
 ,AMOUNT                
 ,IS_INACTIVE           
 ,CREATION_DATE         
 ,LAST_MODIFIED_DATE    
 ,DATE_ACTIVE_FROM      
 ,DATE_ACTIVE_TO        
 ,DW_CURRENT            
  )  
SELECT 
  A.BUDGETFORECAST_ID   
 ,A.BUDGETFORECAST_NAME   
 ,A.FISCAL_MONTH_ID       
 ,A.FISCAL_WEEK_ID
 ,B.CLASS_KEY
 ,C.TERRITORY_KEY
 ,D.SUBSIDIARY_KEY        
 ,BUDGETFORECAST_TYPE   
 ,MONTH_END_DATE        
 ,MONTH_START_DATE      
 ,WEEK_START_DATE       
 ,WEEK_END_DATE         
 ,AMOUNT                
 ,A.IS_INACTIVE           
 ,DATE_CREATED         
 ,LAST_MODIFIED_DATE    
 ,SYSDATE AS DATE_ACTIVE_FROM
 ,'9999-12-31 11:59:59' AS DATE_ACTIVE_TO
 ,1 AS DW_CURRENT
 FROM
  dw_prestage.budgetforecast_fact_update A
  INNER JOIN DW_REPORT.CLASSES B ON (A.LINE_OF_BUSINESS_ID = B.CLASS_ID) 
  INNER JOIN DW_REPORT.territories C ON (A.REGIONSALES_TERRITORY_ID = C.TERRITORY_ID)
  INNER JOIN DW_REPORT.SUBSIDIARIES D ON (A.SUBSIDIARY_ID = D.SUBSIDIARY_ID);


/* fact -> INSERT UPDATED RECORDS IN ERROR TABLE WHICH DOES NOT HAVE VALID DIMENSIONS */ 
INSERT INTO dw.budgetforecast_fact_error
(
  RUNID,
  BUDGETFORECAST_ID,
  BUDGETFORECAST_NAME,
  FISCAL_MONTH_ID,
  FISCAL_WEEK_ID,
  CLASS_KEY,
  CLASS_ID,
  CLASS_ID_ERROR,
  TERRITORY_KEY,
  TERRITORY_ID,
  TERRITORY_ID_ERROR,
  SUBSIDIARY_KEY,
  SUBSIDIARY_ID,
  SUBSIDIARY_ID_ERROR,
  BUDGETFORECAST_TYPE,
  MONTH_END_DATE,
  MONTH_START_DATE,
  WEEK_START_DATE,
  WEEK_END_DATE,
  AMOUNT,
  IS_INACTIVE,
  CREATION_DATE,
  LAST_MODIFIED_DATE,
  RECORD_STATUS,
  DW_CREATION_DATE
)
SELECT A.RUNID,
       A.BUDGETFORECAST_ID,
       A.BUDGETFORECAST_NAME,
       A.FISCAL_MONTH_ID,
       A.FISCAL_WEEK_ID,
       B.CLASS_KEY,
       A.LINE_OF_BUSINESS_ID,
       CASE
         WHEN (B.CLASS_KEY IS NULL AND A.LINE_OF_BUSINESS_ID IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (B.CLASS_KEY IS NULL AND A.LINE_OF_BUSINESS_ID IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END 
,
       C.TERRITORY_KEY,
       A.REGIONSALES_TERRITORY_ID,
       CASE
         WHEN (C.TERRITORY_KEY IS NULL AND A.REGIONSALES_TERRITORY_ID IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (C.TERRITORY_KEY IS NULL AND A.REGIONSALES_TERRITORY_ID IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END 
,
       D.SUBSIDIARY_KEY,
       A.SUBSIDIARY_ID,
       CASE
         WHEN (D.SUBSIDIARY_KEY IS NULL AND A.SUBSIDIARY_ID IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (D.SUBSIDIARY_KEY IS NULL AND A.SUBSIDIARY_ID IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END 
,
       BUDGETFORECAST_TYPE,
       MONTH_END_DATE,
       MONTH_START_DATE,
       WEEK_START_DATE,
       WEEK_END_DATE,
       AMOUNT,
       A.IS_INACTIVE,
       DATE_CREATED,
       LAST_MODIFIED_DATE,
       'ERROR' AS RECORD_STATUS,
       SYSDATE AS DW_CREATION_DATE
FROM dw_prestage.budgetforecast_fact_update A
  LEFT OUTER JOIN DW_REPORT.CLASSES B ON (A.LINE_OF_BUSINESS_ID = B.CLASS_ID)
  LEFT OUTER JOIN DW_REPORT.territories C ON (A.REGIONSALES_TERRITORY_ID = C.TERRITORY_ID)
  LEFT OUTER JOIN DW_REPORT.SUBSIDIARIES D
               ON (A.SUBSIDIARY_ID = D.SUBSIDIARY_ID)
              AND (B.CLASS_KEY IS NULL
               OR C.TERRITORY_KEY IS NULL
               OR D.SUBSIDIARY_KEY IS NULL);

commit;