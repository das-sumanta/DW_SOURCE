create schema if not exists dw ;

drop table if exists dw.transaction_type;

CREATE TABLE dw.transaction_type
(
   transaction_type_key  BIGINT IDENTITY(0,1),
   transaction_type_id   integer,
   transaction_type      varchar(500),
   document_type         varchar(500),
   preferred             varchar(10),
   DATE_ACTIVE_FROM      TIMESTAMP,
   DATE_ACTIVE_TO          TIMESTAMP,
   DW_ACTIVE               VARCHAR(1),
   PRIMARY KEY (transaction_type_key  ,transaction_type_id)
)
DISTSTYLE ALL INTERLEAVED SORTKEY (transaction_type_key  ,transaction_type_id,DW_ACTIVE);

INSERT INTO dw.transaction_type
(
  transaction_type_id,
  transaction_type,
  document_type,
  preferred,
  DATE_ACTIVE_FROM,
  DATE_ACTIVE_TO,
  DW_ACTIVE
)
SELECT -99 AS transaction_type_id,
       'NA_GDW' AS transaction_type,
       'NA_GDW' AS document_type,
       'NA_GDW' AS preferred,
       SYSDATE AS DATE_ACTIVE_FROM,
       '9999-12-31 23:59:59' AS DATE_ACTIVE_TO,
       'A' AS dw_active;

INSERT INTO dw.transaction_type
(
  transaction_type_id,
  transaction_type,
  document_type,
  preferred,
  DATE_ACTIVE_FROM,
  DATE_ACTIVE_TO,
  DW_ACTIVE
)
SELECT  0 AS transaction_type_id,
       'NA_ERR' AS transaction_type,
       'NA_ERR' AS document_type,
       'NA_ERR' AS preferred,
       SYSDATE AS DATE_ACTIVE_FROM,
       '9999-12-31 23:59:59' AS DATE_ACTIVE_TO,
       'A' AS dw_active;