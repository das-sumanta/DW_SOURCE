
CREATE SCHEMA if not exists dw_prestage;

DROP TABLE if exists dw_prestage.book_fairs;

CREATE TABLE dw_prestage.book_fairs 
(
  RUNID               INTEGER,
  FAIR_STATUS_ID      INTEGER,
  FAIR_STATUS         VARCHAR(1000),
  ROUTE_ID            INTEGER,
  ROUTE               VARCHAR(1000),
  MARKER_ID           INTEGER,
  MARKER              VARCHAR(1000),
  FAIR_TYPE_ID        INTEGER,
  FAIR_TYPE           VARCHAR(1000),
  INVOICE_OPTION_ID   INTEGER,
  INVOICE_OPTION      VARCHAR(1000)
);

