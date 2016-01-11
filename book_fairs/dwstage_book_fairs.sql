
CREATE SCHEMA if not exists dw_stage;

DROP TABLE if exists dw_stage.book_fairs;

CREATE TABLE dw_stage.book_fairs 
(
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

