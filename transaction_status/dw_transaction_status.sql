create schema if not exists dw ;

drop table if exists dw.transaction_status;

CREATE TABLE dw.transaction_status
(
   transaction_status_key  BIGINT IDENTITY(0,1),
   document_type           varchar(500),
   status                  varchar(500),
   DATE_ACTIVE_FROM        TIMESTAMP,
   DATE_ACTIVE_TO          TIMESTAMP,
   DW_ACTIVE               VARCHAR(1),
   PRIMARY KEY (transaction_status_key )
)
DISTSTYLE ALL INTERLEAVED SORTKEY (transaction_status_key,document_type,status,DW_ACTIVE);

INSERT INTO dw.transaction_status
(
  document_type,
  status,
  DATE_ACTIVE_FROM,
  DATE_ACTIVE_TO,
  DW_ACTIVE
)
SELECT 
       'NA_GDW' AS document_type,
       'NA_GDW' AS status,
       SYSDATE AS DATE_ACTIVE_FROM,
       '9999-12-31 23:59:59' AS DATE_ACTIVE_TO,
       'A' AS dw_active;

INSERT INTO dw.transaction_status
(
  document_type,
  status,
  DATE_ACTIVE_FROM,
  DATE_ACTIVE_TO,
  DW_ACTIVE
)
SELECT 'NA_ERR' AS document_type,
       'NA_ERR' AS status,
       SYSDATE AS DATE_ACTIVE_FROM,
       '9999-12-31 23:59:59' AS DATE_ACTIVE_TO,
       'A' AS dw_active;