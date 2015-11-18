/* prestage - drop intermediate insert table */ 
DROP TABLE if exists dw_prestage.cost_center_insert;

/* prestage - create intermediate insert table*/ 
CREATE TABLE dw_prestage.cost_center_insert 
AS
SELECT *
FROM dw_prestage.cost_center
WHERE EXISTS (SELECT 1
              FROM (SELECT department_id
                    FROM (SELECT department_id
                          FROM dw_prestage.cost_center
                          MINUS
                          SELECT department_id
                          FROM dw_stage.cost_center)) a
              WHERE dw_prestage.cost_center.department_id = a.department_id);

/* prestage - drop intermediate update table*/ 
DROP TABLE if exists dw_prestage.cost_center_update;

/* prestage - create intermediate update table*/ 
CREATE TABLE dw_prestage.cost_center_update 
AS
SELECT decode(SUM(ch_type),
             3,2,
             SUM(ch_type)
       )  ch_type,
       department_id
FROM (SELECT department_id,
             CH_TYPE
      FROM (SELECT department_id,
                   PARENT_ID,
                   '2' CH_TYPE
            FROM dw_prestage.cost_center
            MINUS
            SELECT department_id,
                   PARENT_ID,
                   '2' CH_TYPE
            FROM dw_stage.cost_center)
      UNION ALL
      SELECT department_id,
             CH_TYPE
      FROM (SELECT department_id,
                   NAME,
                   FULL_NAME,
                   DEPARTMENT_EXTID,
                   ACCPAC_COST_CENTER_CODES,
                   COST_CENTER_CODE,
                   HYPERION_COST_CENTER_CODES,
                   ISINACTIVE,
                   '1' CH_TYPE
            FROM dw_prestage.cost_center
            MINUS
            SELECT department_id,
                   NAME,
                   FULL_NAME,
                   DEPARTMENT_EXTID,
                   ACCPAC_COST_CENTER_CODES,
                   COST_CENTER_CODE,
                   HYPERION_COST_CENTER_CODES,
                   ISINACTIVE,
                   '1' CH_TYPE
            FROM dw_stage.cost_center)) a
WHERE NOT EXISTS (SELECT 1
                  FROM dw_prestage.cost_center_insert
                  WHERE dw_prestage.cost_center_insert.department_id = a.department_id)
GROUP BY department_id;

/* prestage - drop intermediate delete table*/ 
DROP TABLE if exists dw_prestage.cost_center_delete;

/* prestage - create intermediate delete table*/ 
CREATE TABLE dw_prestage.cost_center_delete 
AS
SELECT *
FROM dw_stage.cost_center
WHERE EXISTS (SELECT 1
              FROM (SELECT department_id
                    FROM (SELECT department_id
                          FROM dw_stage.cost_center
                          MINUS
                          SELECT department_id
                          FROM dw_prestage.cost_center)) a
              WHERE dw_stage.cost_center.department_id = a.department_id);

/* prestage-> stage*/ 
SELECT 'no of prestage cost center records identified to inserted -->' ||count(1)
FROM dw_prestage.cost_center_insert;

/* prestage-> stage*/ 
SELECT 'no of prestage cost center records identified to updated -->' ||count(1)
FROM dw_prestage.cost_center_update;

/* prestage-> stage*/ 
SELECT 'no of prestage cost center records identified to deleted -->' ||count(1)
FROM dw_prestage.cost_center_delete;

/* stage -> delete from stage records to be updated */ 
DELETE
FROM dw_stage.cost_center USING dw_prestage.cost_center_update
WHERE dw_stage.cost_center.department_id = dw_prestage.cost_center_update.department_id;

/* stage -> delete from stage records which have been deleted */ 
DELETE
FROM dw_stage.cost_center USING dw_prestage.cost_center_delete
WHERE dw_stage.cost_center.department_id = dw_prestage.cost_center_delete.department_id;

/* stage -> insert into stage records which have been created */ 
INSERT INTO dw_stage.cost_center
(
  ACCPAC_COST_CENTER_CODES,
  COST_CENTER_CODE,
  DATE_LAST_MODIFIED,
  DEPARTMENT_EXTID,
  DEPARTMENT_ID,
  FULL_NAME,
  HYPERION_COST_CENTER_CODES,
  ISINACTIVE,
  NAME,
  PARENT_ID
)
SELECT ACCPAC_COST_CENTER_CODES,
       COST_CENTER_CODE,
       DATE_LAST_MODIFIED,
       DEPARTMENT_EXTID,
       DEPARTMENT_ID,
       FULL_NAME,
       HYPERION_COST_CENTER_CODES,
       ISINACTIVE,
       NAME,
       PARENT_ID
FROM dw_prestage.cost_center_insert;

/* stage -> insert into stage records which have been created */ 
INSERT INTO dw_stage.cost_center
(
  ACCPAC_COST_CENTER_CODES,
  COST_CENTER_CODE,
  DATE_LAST_MODIFIED,
  DEPARTMENT_EXTID,
  DEPARTMENT_ID,
  FULL_NAME,
  HYPERION_COST_CENTER_CODES,
  ISINACTIVE,
  NAME,
  PARENT_ID
)
SELECT ACCPAC_COST_CENTER_CODES,
       COST_CENTER_CODE,
       DATE_LAST_MODIFIED,
       DEPARTMENT_EXTID,
       DEPARTMENT_ID,
       FULL_NAME,
       HYPERION_COST_CENTER_CODES,
       ISINACTIVE,
       NAME,
       PARENT_ID
FROM dw_prestage.cost_center
WHERE EXISTS (SELECT 1
              FROM dw_prestage.cost_center_update
              WHERE dw_prestage.cost_center_update.department_id = dw_prestage.cost_center.department_id);

COMMIT;

/* dimension ->insert new records in dim cost_center */ 
INSERT INTO dw.cost_center
(
  DEPARTMENT_ID,
  NAME,
  FULL_NAME,
  DEPARTMENT_EXTID,
  ACCPAC_COST_CENTER_CODES,
  COST_CENTER_CODE,
  HYPERION_COST_CENTER_CODES,
  PARENT_COST_CENTER,
  PARENT_COST_CENTER_ID,
  ISINACTIVE,
  DATE_ACTIVE_FROM,
  DATE_ACTIVE_TO,
  DW_ACTIVE
)
SELECT A.department_id,
       NVL(A.NAME,'NA_GDW'),
       NVL(A.FULL_NAME,'NA_GDW'),
       NVL(A.DEPARTMENT_EXTID,'NA_GDW'),
       NVL(A.ACCPAC_COST_CENTER_CODES,'NA_GDW'),
       NVL(A.COST_CENTER_CODE,'NA_GDW'),
       NVL(A.HYPERION_COST_CENTER_CODES,'NA_GDW'),
       NVL(B.FULL_NAME,'NA_GDW'),
       NVL(A.PARENT_ID,-99),
       NVL(A.ISINACTIVE,'NA_GDW'),
       sysdate,
       '9999-12-31 23:59:59',
       'A'
FROM dw_prestage.cost_center_insert A,
     dw_prestage.cost_center B
WHERE A.PARENT_ID = B.department_id (+);

/* dimension -> update old record as part of SCD2 maintenance*/ 
UPDATE dw.cost_center
   SET dw_active = 'I',
       DATE_ACTIVE_TO = (sysdate -1)
WHERE dw_active = 'A'
AND   sysdate>= date_active_from
AND   sysdate< date_active_to
AND   EXISTS (SELECT 1
              FROM dw_prestage.cost_center_update
              WHERE dw.cost_center.department_id = dw_prestage.cost_center_update.department_id
              AND   dw_prestage.cost_center_update.ch_type = 2);

/* dimension -> insert the new records as part of SCD2 maintenance*/ 
INSERT INTO dw.cost_center
(
  DEPARTMENT_ID,
  NAME,
  FULL_NAME,
  DEPARTMENT_EXTID,
  ACCPAC_COST_CENTER_CODES,
  COST_CENTER_CODE,
  HYPERION_COST_CENTER_CODES,
  PARENT_COST_CENTER,
  PARENT_COST_CENTER_ID,
  ISINACTIVE,
  DATE_ACTIVE_FROM,
  DATE_ACTIVE_TO,
  DW_ACTIVE
)
SELECT A.department_id,
       NVL(A.NAME,'NA_GDW'),
       NVL(A.FULL_NAME,'NA_GDW'),
       NVL(A.DEPARTMENT_EXTID,'NA_GDW'),
       NVL(A.ACCPAC_COST_CENTER_CODES,'NA_GDW'),
       NVL(A.COST_CENTER_CODE,'NA_GDW'),
       NVL(A.HYPERION_COST_CENTER_CODES,'NA_GDW'),
       NVL(B.FULL_NAME,'NA_GDW'),
       NVL(A.PARENT_ID,-99),
       NVL(A.ISINACTIVE,'NA_GDW'),
       sysdate,
       '9999-12-31 23:59:59',
       'A'
FROM dw_prestage.cost_center A,
     dw_prestage.cost_center B
WHERE A.PARENT_ID = B.department_id (+)
AND   EXISTS (SELECT 1
              FROM dw_prestage.cost_center_update
              WHERE a.department_id = dw_prestage.cost_center_update.department_id
              AND   dw_prestage.cost_center_update.ch_type = 2);

/* dimension -> update records as part of SCD1 maintenance */ 
UPDATE dw.cost_center
   SET NAME = NVL(dw_prestage.cost_center.NAME,'NA_GDW'),
       FULL_NAME = NVL(dw_prestage.cost_center.FULL_NAME,'NA_GDW'),
       DEPARTMENT_EXTID = NVL(dw_prestage.cost_center.DEPARTMENT_EXTID,'NA_GDW'),
       ACCPAC_COST_CENTER_CODES = NVL(dw_prestage.cost_center.ACCPAC_COST_CENTER_CODES,'NA_GDW'),
       COST_CENTER_CODE = NVL(dw_prestage.cost_center.COST_CENTER_CODE,'NA_GDW'),
       HYPERION_COST_CENTER_CODES = NVL(dw_prestage.cost_center.HYPERION_COST_CENTER_CODES,'NA_GDW'),
       ISINACTIVE = NVL(dw_prestage.cost_center.ISINACTIVE,'NA_GDW')
FROM dw_prestage.cost_center
WHERE dw.cost_center.department_id = dw_prestage.cost_center.department_id
AND   EXISTS (SELECT 1
              FROM dw_prestage.cost_center_update
              WHERE dw_prestage.cost_center.department_id = dw_prestage.cost_center_update.department_id
              AND   dw_prestage.cost_center_update.ch_type = 1);

/* dimension -> logically delete dw records */ 
UPDATE dw.cost_center
   SET DATE_ACTIVE_TO = sysdate -1,
       dw_active = 'I'
FROM dw_prestage.cost_center_delete
WHERE dw.cost_center.department_id = dw_prestage.cost_center_delete.department_id;

COMMIT;

