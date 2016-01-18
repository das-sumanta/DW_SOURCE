/* prestage - drop intermediate insert table */ 
DROP TABLE if exists dw_prestage.accounting_period_insert;

/* prestage - create intermediate insert table*/ 
CREATE TABLE dw_prestage.accounting_period_insert 
AS
SELECT *
FROM dw_prestage.accounting_period
WHERE EXISTS (SELECT 1
              FROM (SELECT accounting_period_id
                    FROM (SELECT accounting_period_id
                          FROM dw_prestage.accounting_period
                          MINUS
                          SELECT accounting_period_id
                          FROM dw_stage.accounting_period)) a
              WHERE dw_prestage.accounting_period.accounting_period_id = a.accounting_period_id);

/* prestage - drop intermediate update table*/ 
DROP TABLE if exists dw_prestage.accounting_period_update;

/* prestage - create intermediate update table*/ 
CREATE TABLE dw_prestage.accounting_period_update 
AS
SELECT decode(SUM(ch_type),
             3,2,
             SUM(ch_type)
       )  ch_type,
       accounting_period_id
FROM (SELECT accounting_period_id,
             PERIOD_NAME,
             START_DATE,
             END_DATE,
             FISCAL_CALENDAR,
             QUARTER_NAME,
             YEAR_NAME,
             CLOSED,
             CLOSED_AP,
             CLOSED_AR,
             CLOSED_PAYROLL,
             CLOSED_ALL,
             CLOSED_ON,
             LOCKED_AP,
             LOCKED_AR,
             LOCKED_PAYROLL,
             LOCKED_ALL,
             ISINACTIVE,
             '1' CH_TYPE
      FROM dw_prestage.accounting_period
      MINUS
      SELECT accounting_period_id,
             PERIOD_NAME,
             START_DATE,
             END_DATE,
             FISCAL_CALENDAR,
             QUARTER_NAME,
             YEAR_NAME,
             CLOSED,
             CLOSED_AP,
             CLOSED_AR,
             CLOSED_PAYROLL,
             CLOSED_ALL,
             CLOSED_ON,
             LOCKED_AP,
             LOCKED_AR,
             LOCKED_PAYROLL,
             LOCKED_ALL,
             ISINACTIVE,
             '1' CH_TYPE
      FROM dw_stage.accounting_period) a
WHERE NOT EXISTS (SELECT 1
                  FROM dw_prestage.accounting_period_insert
                  WHERE dw_prestage.accounting_period_insert.accounting_period_id = a.accounting_period_id)
GROUP BY accounting_period_id;

/* prestage - drop intermediate delete table*/ 
DROP TABLE if exists dw_prestage.accounting_period_delete;

/* prestage - create intermediate delete table*/ 
CREATE TABLE dw_prestage.accounting_period_delete 
AS
SELECT *
FROM dw_stage.accounting_period
WHERE EXISTS (SELECT 1
              FROM (SELECT accounting_period_id
                    FROM (SELECT accounting_period_id
                          FROM dw_stage.accounting_period
                          MINUS
                          SELECT accounting_period_id
                          FROM dw_prestage.accounting_period)) a
              WHERE dw_stage.accounting_period.accounting_period_id = a.accounting_period_id);

/* prestage-> stage*/ 
SELECT 'no of prestage accounting_period records identified to inserted -->' ||count(1)
FROM dw_prestage.accounting_period_insert;

/* prestage-> stage*/ 
SELECT 'no of prestage accounting_period records identified to updated -->' ||count(1)
FROM dw_prestage.accounting_period_update;

/* prestage-> stage*/ 
SELECT 'no of prestage accounting_period records identified to deleted -->' ||count(1)
FROM dw_prestage.accounting_period_delete;

/* stage ->delete from stage records to be updated */ 
DELETE
FROM dw_stage.accounting_period USING dw_prestage.accounting_period_update
WHERE dw_stage.accounting_period.accounting_period_id = dw_prestage.accounting_period_update.accounting_period_id;

/* stage ->delete from stage records which have been deleted */ 
DELETE
FROM dw_stage.accounting_period USING dw_prestage.accounting_period_delete
WHERE dw_stage.accounting_period.accounting_period_id = dw_prestage.accounting_period_delete.accounting_period_id;

/* stage ->insert into stage records which have been created */ 
INSERT INTO dw_stage.accounting_period
(
  ACCOUNTING_PERIOD_ID,
  PERIOD_NAME,
  START_DATE,
  END_DATE,
  FISCAL_CALENDAR,
  FISCAL_CALENDAR_ID,
  QUARTER_NAME,
  YEAR_NAME,
  CLOSED,
  CLOSED_AP,
  CLOSED_AR,
  CLOSED_PAYROLL,
  CLOSED_ALL,
  CLOSED_ON,
  LOCKED_AP,
  LOCKED_AR,
  LOCKED_PAYROLL,
  LOCKED_ALL,
  ISINACTIVE,
  YEAR_ID
)
SELECT ACCOUNTING_PERIOD_ID,
       PERIOD_NAME,
       START_DATE,
       END_DATE,
       FISCAL_CALENDAR,
       FISCAL_CALENDAR_ID,
       QUARTER_NAME,
       YEAR_NAME,
       CLOSED,
       CLOSED_AP,
       CLOSED_AR,
       CLOSED_PAYROLL,
       CLOSED_ALL,
       CLOSED_ON,
       LOCKED_AP,
       LOCKED_AR,
       LOCKED_PAYROLL,
       LOCKED_ALL,
       ISINACTIVE,
       YEAR_ID
FROM dw_prestage.accounting_period_insert;

/* stage ->insert into stage records which have been updated */ 
INSERT INTO dw_stage.accounting_period
(
  ACCOUNTING_PERIOD_ID,
  PERIOD_NAME,
  START_DATE,
  END_DATE,
  FISCAL_CALENDAR,
  FISCAL_CALENDAR_ID,
  QUARTER_NAME,
  YEAR_NAME,
  CLOSED,
  CLOSED_AP,
  CLOSED_AR,
  CLOSED_PAYROLL,
  CLOSED_ALL,
  CLOSED_ON,
  LOCKED_AP,
  LOCKED_AR,
  LOCKED_PAYROLL,
  LOCKED_ALL,
  ISINACTIVE,
  YEAR_ID
)
SELECT ACCOUNTING_PERIOD_ID,
       PERIOD_NAME,
       START_DATE,
       END_DATE,
       FISCAL_CALENDAR,
       FISCAL_CALENDAR_ID,
       QUARTER_NAME,
       YEAR_NAME,
       CLOSED,
       CLOSED_AP,
       CLOSED_AR,
       CLOSED_PAYROLL,
       CLOSED_ALL,
       CLOSED_ON,
       LOCKED_AP,
       LOCKED_AR,
       LOCKED_PAYROLL,
       LOCKED_ALL,
       ISINACTIVE,
       YEAR_ID
FROM dw_prestage.accounting_period
WHERE EXISTS (SELECT 1
              FROM dw_prestage.accounting_period_update
              WHERE dw_prestage.accounting_period_update.accounting_period_id = dw_prestage.accounting_period.accounting_period_id);

commit;


/* dimension ->insert new records in dim accounting_period */

INSERT INTO dw.accounting_period
(
  ACCOUNTING_PERIOD_ID,
  PERIOD_NAME,
  START_DATE,
  END_DATE,
  FISCAL_CALENDAR,
  QUARTER_NAME,
  YEAR_NAME,
  CLOSED,
  CLOSED_AP,
  CLOSED_AR,
  CLOSED_PAYROLL,
  CLOSED_ALL,
  CLOSED_ON,
  LOCKED_AP,
  LOCKED_AR,
  LOCKED_PAYROLL,
  LOCKED_ALL,
  ISINACTIVE,
  DATE_ACTIVE_FROM,
  DATE_ACTIVE_TO,
  DW_ACTIVE
)
SELECT NVL(A.accounting_period_ID,-99) AS accounting_period_ID,
       DECODE(LENGTH(A.PERIOD_NAME),
             0,'NA_GDW',
             A.PERIOD_NAME
       ) AS PERIOD_NAME,
       A.START_DATE,
       A.END_DATE,
       DECODE(LENGTH(A.FISCAL_CALENDAR),
             0,'NA_GDW',
             A.FISCAL_CALENDAR
       ) AS FISCAL_CALENDAR,
       DECODE(LENGTH(A.QUARTER_NAME),
             0,'NA_GDW',
             A.QUARTER_NAME
       ) AS QUARTER_NAME,
       DECODE(LENGTH(A.YEAR_NAME),
             0,'NA_GDW',
             A.YEAR_NAME
       ) AS YEAR_NAME,
       A.CLOSED,
       A.CLOSED_AP,
       A.CLOSED_AR,
       A.CLOSED_PAYROLL,
       A.CLOSED_ALL,
       A.CLOSED_ON,
       A.LOCKED_AP,
       A.LOCKED_AR,
       A.LOCKED_PAYROLL,
       A.LOCKED_ALL,
       A.ISINACTIVE,
       sysdate,
       '9999-12-31 23:59:59',
       'A'
FROM dw_prestage.accounting_period_insert A;

/* dimension ->update old record as part of SCD2 maintenance*/ 
UPDATE dw.accounting_period
   SET dw_active = 'I',
       DATE_ACTIVE_TO = (sysdate -1)
WHERE dw_active = 'A'
AND   sysdate>= date_active_from
AND   sysdate< date_active_to
AND   EXISTS (SELECT 1
              FROM dw_prestage.accounting_period_update
              WHERE dw.accounting_period.accounting_period_id = dw_prestage.accounting_period_update.accounting_period_id
              AND   dw_prestage.accounting_period_update.ch_type = 2);

/* dimension ->insert the new records as part of SCD2 maintenance*/ 
INSERT INTO dw.accounting_period
(
  ACCOUNTING_PERIOD_ID,
  PERIOD_NAME,
  START_DATE,
  END_DATE,
  FISCAL_CALENDAR,
  QUARTER_NAME,
  YEAR_NAME,
  CLOSED,
  CLOSED_AP,
  CLOSED_AR,
  CLOSED_PAYROLL,
  CLOSED_ALL,
  CLOSED_ON,
  LOCKED_AP,
  LOCKED_AR,
  LOCKED_PAYROLL,
  LOCKED_ALL,
  ISINACTIVE,
  DATE_ACTIVE_FROM,
  DATE_ACTIVE_TO,
  DW_ACTIVE
)
SELECT NVL(A.accounting_period_ID,-99) AS accounting_period_ID,
       DECODE(LENGTH(A.PERIOD_NAME),
             0,'NA_GDW',
             A.PERIOD_NAME
       ) AS PERIOD_NAME,
       A.START_DATE,
       A.END_DATE,
       DECODE(LENGTH(A.FISCAL_CALENDAR),
             0,'NA_GDW',
             A.FISCAL_CALENDAR
       ) AS FISCAL_CALENDAR,
       DECODE(LENGTH(A.QUARTER_NAME),
             0,'NA_GDW',
             A.QUARTER_NAME
       ) AS QUARTER_NAME,
       DECODE(LENGTH(A.YEAR_NAME),
             0,'NA_GDW',
             A.YEAR_NAME
       ) AS YEAR_NAME,
       A.CLOSED,
       A.CLOSED_AP,
       A.CLOSED_AR,
       A.CLOSED_PAYROLL,
       A.CLOSED_ALL,
       A.CLOSED_ON,
       A.LOCKED_AP,
       A.LOCKED_AR,
       A.LOCKED_PAYROLL,
       A.LOCKED_ALL,
       A.ISINACTIVE,
       sysdate,
       '9999-12-31 23:59:59',
       'A'
FROM dw_prestage.accounting_period A
WHERE EXISTS (SELECT 1
              FROM dw_prestage.accounting_period_update
              WHERE a.accounting_period_id = dw_prestage.accounting_period_update.accounting_period_id
              AND   dw_prestage.accounting_period_update.ch_type = 2);

/* dimension -> update records as part of SCD1 maintenance */ 
UPDATE dw.accounting_period
   SET PERIOD_NAME = NVL(dw_prestage.accounting_period.PERIOD_NAME,'NA_GDW'),
       START_DATE = dw_prestage.accounting_period.START_DATE,
       END_DATE = dw_prestage.accounting_period.END_DATE,
       FISCAL_CALENDAR = NVL(dw_prestage.accounting_period.FISCAL_CALENDAR,'NA_GDW'),
       QUARTER_NAME = NVL(dw_prestage.accounting_period.QUARTER_NAME,'NA_GDW'),
       YEAR_NAME = NVL(dw_prestage.accounting_period.YEAR_NAME,'NA_GDW'),
       CLOSED = NVL(dw_prestage.accounting_period.CLOSED,'NA_GDW'),
       CLOSED_AP = NVL(dw_prestage.accounting_period.CLOSED_AP,'NA_GDW'),
       CLOSED_AR = NVL(dw_prestage.accounting_period.CLOSED_AR,'NA_GDW'),
       CLOSED_PAYROLL = NVL(dw_prestage.accounting_period.CLOSED_PAYROLL,'NA_GDW'),
       CLOSED_ALL = NVL(dw_prestage.accounting_period.CLOSED_ALL,'NA_GDW'),
       CLOSED_ON = dw_prestage.accounting_period.CLOSED_ON,
       LOCKED_AP = NVL(dw_prestage.accounting_period.LOCKED_AP,'NA_GDW'),
       LOCKED_AR = NVL(dw_prestage.accounting_period.LOCKED_AR,'NA_GDW'),
       LOCKED_PAYROLL = NVL(dw_prestage.accounting_period.LOCKED_PAYROLL,'NA_GDW'),
       LOCKED_ALL = NVL(dw_prestage.accounting_period.LOCKED_ALL,'NA_GDW'),
       ISINACTIVE = NVL(dw_prestage.accounting_period.ISINACTIVE,'NA_GDW')
FROM dw_prestage.accounting_period
WHERE dw.accounting_period.accounting_period_id = dw_prestage.accounting_period.accounting_period_id
AND   EXISTS (SELECT 1
              FROM dw_prestage.accounting_period_update
              WHERE dw_prestage.accounting_period.accounting_period_id = dw_prestage.accounting_period_update.accounting_period_id
              AND   dw_prestage.accounting_period_update.ch_type = 1);

/* dimension ->logically delete dw records */ 
UPDATE dw.accounting_period
   SET DATE_ACTIVE_TO = sysdate -1,
       dw_active = 'I'
FROM dw_prestage.accounting_period_delete
WHERE dw.accounting_period.accounting_period_id = dw_prestage.accounting_period_delete.accounting_period_id;

COMMIT;
