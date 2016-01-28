/* prestage - drop intermediate insert table */ 
DROP TABLE if exists dw_prestage.subsidiaries_insert;

/* prestage - create intermediate insert table*/ 
CREATE TABLE dw_prestage.subsidiaries_insert 
AS
SELECT *
FROM dw_prestage.subsidiaries
WHERE EXISTS (SELECT 1
              FROM (SELECT subsidiary_id
                    FROM (SELECT subsidiary_id
                          FROM dw_prestage.subsidiaries
                          MINUS
                          SELECT subsidiary_id
                          FROM dw_stage.subsidiaries)) a
              WHERE dw_prestage.subsidiaries.subsidiary_id = a.subsidiary_id);

/* prestage - drop intermediate update table*/ 
DROP TABLE if exists dw_prestage.subsidiaries_update;

/* prestage - create intermediate update table*/ 
CREATE TABLE dw_prestage.subsidiaries_update 
AS
SELECT decode(SUM(ch_type),
             3,2,
             SUM(ch_type)
       )  ch_type,
       subsidiary_id
FROM (SELECT subsidiary_id,
             CH_TYPE
      FROM (SELECT subsidiary_id,
                   FISCAL_CALENDAR_ID,
                   CURRENCY,
                   BASE_CURRENCY_ID,
                   PARENT_ID,
                   '2' CH_TYPE
            FROM dw_prestage.subsidiaries
            MINUS
            SELECT subsidiary_id,
                   FISCAL_CALENDAR_ID,
                   CURRENCY,
                   BASE_CURRENCY_ID,
                   PARENT_ID,
                   '2' CH_TYPE
            FROM dw_stage.subsidiaries)
      UNION ALL
      SELECT subsidiary_id,
             CH_TYPE
      FROM (SELECT subsidiary_id,
                   NAME,
                   ISINACTIVE,
                   EDITION,
                   IS_ELIMINATION,
                   LEGAL_NAME,
                   FEDERAL_NUMBER,
                   LEGAL_ENTITY_ACCOUNT_CODE,
                   '1' CH_TYPE
            FROM dw_prestage.subsidiaries
            MINUS
            SELECT subsidiary_id,
                   NAME,
                   ISINACTIVE,
                   EDITION,
                   IS_ELIMINATION,
                   LEGAL_NAME,
                   FEDERAL_NUMBER,
                   LEGAL_ENTITY_ACCOUNT_CODE,
                   '1' CH_TYPE
            FROM dw_stage.subsidiaries)) a
WHERE NOT EXISTS (SELECT 1
                  FROM dw_prestage.subsidiaries_insert
                  WHERE dw_prestage.subsidiaries_insert.subsidiary_id = a.subsidiary_id)
GROUP BY subsidiary_id;

/* prestage - drop intermediate delete table*/ 
DROP TABLE if exists dw_prestage.subsidiaries_delete;

/* prestage - create intermediate delete table*/ 
CREATE TABLE dw_prestage.subsidiaries_delete 
AS
SELECT *
FROM dw_stage.subsidiaries
WHERE EXISTS (SELECT 1
              FROM (SELECT subsidiary_id
                    FROM (SELECT subsidiary_id
                          FROM dw_stage.subsidiaries
                          MINUS
                          SELECT subsidiary_id
                          FROM dw_prestage.subsidiaries)) a
              WHERE dw_stage.subsidiaries.subsidiary_id = a.subsidiary_id);

/* prestage-> no of prestage subsidiaries records identified to inserted*/ 
SELECT count(1) FROM dw_prestage.subsidiaries_insert;

/* prestage-> no of prestage subsidiaries records identified to updated*/ 
SELECT count(1) FROM dw_prestage.subsidiaries_update;

/* prestage-> no of prestage subsidiaries records identified to deleted*/ 
SELECT count(1) FROM dw_prestage.subsidiaries_delete;

/* stage -> delete from stage records to be updated */ 
DELETE
FROM dw_stage.subsidiaries USING dw_prestage.subsidiaries_update
WHERE dw_stage.subsidiaries.subsidiary_id = dw_prestage.subsidiaries_update.subsidiary_id;

/* stage -> delete from stage records which have been deleted */ 
DELETE
FROM dw_stage.subsidiaries USING dw_prestage.subsidiaries_delete
WHERE dw_stage.subsidiaries.subsidiary_id = dw_prestage.subsidiaries_delete.subsidiary_id;

/* stage -> insert into stage records which have been created */ 
INSERT INTO dw_stage.subsidiaries
(
  BASE_CURRENCY_ID,
  BRANCH_ID,
  BRN,
  DATE_LAST_MODIFIED,
  EDITION,
  FEDERAL_NUMBER,
  FISCAL_CALENDAR_ID,
  FULL_NAME,
  ISINACTIVE,
  IS_ELIMINATION,
  IS_MOSS,
  LEGAL_ENTITY_ACCOUNT_CODE,
  LEGAL_NAME,
  MOSS_NEXUS_ID,
  NAME,
  PARENT_ID,
  PURCHASEORDERAMOUNT,
  PURCHASEORDERQUANTITY,
  PURCHASEORDERQUANTITYDIFF,
  RECEIPTAMOUNT,
  RECEIPTQUANTITY,
  RECEIPTQUANTITYDIFF,
  STATE_TAX_NUMBER,
  SUBSIDIARY_EXTID,
  SUBSIDIARY_ID,
  TRAN_NUM_PREFIX,
  UEN,
  URL,
  CURRENCY
)
SELECT BASE_CURRENCY_ID,
       BRANCH_ID,
       BRN,
       DATE_LAST_MODIFIED,
       EDITION,
       FEDERAL_NUMBER,
       FISCAL_CALENDAR_ID,
       FULL_NAME,
       ISINACTIVE,
       IS_ELIMINATION,
       IS_MOSS,
       LEGAL_ENTITY_ACCOUNT_CODE,
       LEGAL_NAME,
       MOSS_NEXUS_ID,
       NAME,
       PARENT_ID,
       PURCHASEORDERAMOUNT,
       PURCHASEORDERQUANTITY,
       PURCHASEORDERQUANTITYDIFF,
       RECEIPTAMOUNT,
       RECEIPTQUANTITY,
       RECEIPTQUANTITYDIFF,
       STATE_TAX_NUMBER,
       SUBSIDIARY_EXTID,
       SUBSIDIARY_ID,
       TRAN_NUM_PREFIX,
       UEN,
       URL,
       CURRENCY
FROM dw_prestage.subsidiaries_insert;

/* stage -> insert into stage records which have been created */ 
INSERT INTO dw_stage.subsidiaries
(
  BASE_CURRENCY_ID,
  BRANCH_ID,
  BRN,
  DATE_LAST_MODIFIED,
  EDITION,
  FEDERAL_NUMBER,
  FISCAL_CALENDAR_ID,
  FULL_NAME,
  ISINACTIVE,
  IS_ELIMINATION,
  IS_MOSS,
  LEGAL_ENTITY_ACCOUNT_CODE,
  LEGAL_NAME,
  MOSS_NEXUS_ID,
  NAME,
  PARENT_ID,
  PURCHASEORDERAMOUNT,
  PURCHASEORDERQUANTITY,
  PURCHASEORDERQUANTITYDIFF,
  RECEIPTAMOUNT,
  RECEIPTQUANTITY,
  RECEIPTQUANTITYDIFF,
  STATE_TAX_NUMBER,
  SUBSIDIARY_EXTID,
  SUBSIDIARY_ID,
  TRAN_NUM_PREFIX,
  UEN,
  URL,
  CURRENCY
)
SELECT BASE_CURRENCY_ID,
       BRANCH_ID,
       BRN,
       DATE_LAST_MODIFIED,
       EDITION,
       FEDERAL_NUMBER,
       FISCAL_CALENDAR_ID,
       FULL_NAME,
       ISINACTIVE,
       IS_ELIMINATION,
       IS_MOSS,
       LEGAL_ENTITY_ACCOUNT_CODE,
       LEGAL_NAME,
       MOSS_NEXUS_ID,
       NAME,
       PARENT_ID,
       PURCHASEORDERAMOUNT,
       PURCHASEORDERQUANTITY,
       PURCHASEORDERQUANTITYDIFF,
       RECEIPTAMOUNT,
       RECEIPTQUANTITY,
       RECEIPTQUANTITYDIFF,
       STATE_TAX_NUMBER,
       SUBSIDIARY_EXTID,
       SUBSIDIARY_ID,
       TRAN_NUM_PREFIX,
       UEN,
       URL,
       CURRENCY
FROM dw_prestage.subsidiaries
WHERE EXISTS (SELECT 1
              FROM dw_prestage.subsidiaries_update
              WHERE dw_prestage.subsidiaries_update.subsidiary_id = dw_prestage.subsidiaries.subsidiary_id);



/* dimension ->insert new records in dim subsidiaries */ 
INSERT INTO dw.subsidiaries
(
  SUBSIDIARY_ID,
  NAME,
  ISINACTIVE,
  EDITION,
  ELIMINATION,
  LEGAL_NAME,
  VAT_REG_NO,
  LEGAL_ACCOUNT_CODE,
  FISCAL_CALENDAR_ID,
  CURRENCY,
  CURRENCY_ID,
  PARENT_SUBSIDIARY,
  PARENT_SUBSIDIARY_ID,
  DATE_ACTIVE_FROM,
  DATE_ACTIVE_TO,
  DW_ACTIVE
)
SELECT A.subsidiary_id,
       DECODE(LENGTH(A.NAME),
             0,'NA_GDW',
             A.NAME
       ) ,
       DECODE(LENGTH(A.ISINACTIVE),
             0,'NA_GDW',
             A.ISINACTIVE 
       ) ,
       DECODE(LENGTH(A.EDITION),
             0,'NA_GDW',
             A.EDITION   
       ) ,
       DECODE(LENGTH(A.IS_ELIMINATION),
             0,'NA_GDW',
             A.IS_ELIMINATION   
       ) ,
       DECODE(LENGTH(A.LEGAL_NAME),
             0,'NA_GDW',
             A.LEGAL_NAME 
       ) ,
       DECODE(LENGTH(A.FEDERAL_NUMBER),
             0,'NA_GDW',
             A.FEDERAL_NUMBER 
       ) ,
       DECODE(LENGTH(A.LEGAL_ENTITY_ACCOUNT_CODE),
             0,'NA_GDW',
             A.LEGAL_ENTITY_ACCOUNT_CODE   
       ) ,
       NVL(A.FISCAL_CALENDAR_ID,-99),
       DECODE(LENGTH(A.CURRENCY),
             0,'NA_GDW',
              A.CURRENCY  
       ) ,
       NVL(A.BASE_CURRENCY_ID,-99),
       DECODE(LENGTH(B.NAME),
             0,'NA_GDW',
              B.NAME
       ) ,
       NVL(A.PARENT_ID,-99),
       sysdate,
       '9999-12-31 23:59:59',
       'A'
FROM dw_prestage.subsidiaries_insert A,
     dw_prestage.subsidiaries B
WHERE A.PARENT_ID = B.subsidiary_id (+);

/* dimension -> update old record as part of SCD2 maintenance*/ 
UPDATE dw.subsidiaries
   SET dw_active = 'I',
       DATE_ACTIVE_TO = (sysdate -1)
WHERE dw_active = 'A'
AND   sysdate>= date_active_from
AND   sysdate< date_active_to
AND   EXISTS (SELECT 1
              FROM dw_prestage.subsidiaries_update
              WHERE dw.subsidiaries.subsidiary_id = dw_prestage.subsidiaries_update.subsidiary_id
              AND   dw_prestage.subsidiaries_update.ch_type = 2);

/* dimension -> insert the new records as part of SCD2 maintenance*/ 
INSERT INTO dw.subsidiaries
(
  SUBSIDIARY_ID,
  NAME,
  ISINACTIVE,
  EDITION,
  ELIMINATION,
  LEGAL_NAME,
  VAT_REG_NO,
  LEGAL_ACCOUNT_CODE,
  FISCAL_CALENDAR_ID,
  CURRENCY,
  CURRENCY_ID,
  PARENT_SUBSIDIARY,
  PARENT_SUBSIDIARY_ID,
  DATE_ACTIVE_FROM,
  DATE_ACTIVE_TO,
  DW_ACTIVE
)
SELECT A.subsidiary_id,
       DECODE(LENGTH(A.NAME),
             0,'NA_GDW',
             A.NAME
       ) ,
       DECODE(LENGTH(A.ISINACTIVE),
             0,'NA_GDW',
             A.ISINACTIVE 
       ) ,
       DECODE(LENGTH(A.EDITION),
             0,'NA_GDW',
             A.EDITION   
       ) ,
       DECODE(LENGTH(A.IS_ELIMINATION),
             0,'NA_GDW',
             A.IS_ELIMINATION   
       ) ,
       DECODE(LENGTH(A.LEGAL_NAME),
             0,'NA_GDW',
             A.LEGAL_NAME 
       ) ,
       DECODE(LENGTH(A.FEDERAL_NUMBER),
             0,'NA_GDW',
             A.FEDERAL_NUMBER 
       ) ,
       DECODE(LENGTH(A.LEGAL_ENTITY_ACCOUNT_CODE),
             0,'NA_GDW',
             A.LEGAL_ENTITY_ACCOUNT_CODE   
       ) ,
       NVL(A.FISCAL_CALENDAR_ID,-99),
       DECODE(LENGTH(A.CURRENCY),
             0,'NA_GDW',
              A.CURRENCY  
       ) ,
       NVL(A.BASE_CURRENCY_ID,-99),
       DECODE(LENGTH(B.NAME),
             0,'NA_GDW',
              B.NAME
       ) ,
       NVL(A.PARENT_ID,-99),
       sysdate,
       '9999-12-31 23:59:59',
       'A'
FROM dw_prestage.subsidiaries A,
     dw_prestage.subsidiaries B
WHERE A.PARENT_ID = B.subsidiary_id (+)
AND   EXISTS (SELECT 1
              FROM dw_prestage.subsidiaries_update
              WHERE a.subsidiary_id = dw_prestage.subsidiaries_update.subsidiary_id
              AND   dw_prestage.subsidiaries_update.ch_type = 2);

/* dimension -> update records as part of SCD1 maintenance */ 
UPDATE dw.subsidiaries
   SET NAME = DECODE(LENGTH(dw_prestage.subsidiaries.NAME),0,'NA_GDW',dw_prestage.subsidiaries.NAME),
       ISINACTIVE = DECODE(LENGTH(dw_prestage.subsidiaries.ISINACTIVE),0,'NA_GDW',dw_prestage.subsidiaries.ISINACTIVE),
       EDITION = DECODE(LENGTH(dw_prestage.subsidiaries.EDITION),0,'NA_GDW',dw_prestage.subsidiaries.EDITION),
       ELIMINATION = DECODE(LENGTH(dw_prestage.subsidiaries.IS_ELIMINATION),0,'NA_GDW',dw_prestage.subsidiaries.IS_ELIMINATION),
       LEGAL_NAME = DECODE(LENGTH(dw_prestage.subsidiaries.LEGAL_NAME),0,'NA_GDW',dw_prestage.subsidiaries.LEGAL_NAME),
       VAT_REG_NO = DECODE(LENGTH(dw_prestage.subsidiaries.FEDERAL_NUMBER),0,'NA_GDW',dw_prestage.subsidiaries.FEDERAL_NUMBER),
       LEGAL_ACCOUNT_CODE = DECODE(LENGTH(dw_prestage.subsidiaries.LEGAL_ENTITY_ACCOUNT_CODE),0,'NA_GDW',dw_prestage.subsidiaries.LEGAL_ENTITY_ACCOUNT_CODE)
FROM dw_prestage.subsidiaries
WHERE dw.subsidiaries.subsidiary_id = dw_prestage.subsidiaries.subsidiary_id
AND   EXISTS (SELECT 1
              FROM dw_prestage.subsidiaries_update
              WHERE dw_prestage.subsidiaries.subsidiary_id = dw_prestage.subsidiaries_update.subsidiary_id
              AND   dw_prestage.subsidiaries_update.ch_type = 1);

/* dimension -> logically delete dw records */ 
UPDATE dw.subsidiaries
   SET DATE_ACTIVE_TO = sysdate -1,
       dw_active = 'I'
FROM dw_prestage.subsidiaries_delete
WHERE dw.subsidiaries.subsidiary_id = dw_prestage.subsidiaries_delete.subsidiary_id;
