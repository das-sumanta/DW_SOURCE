CREATE SCHEMA if not exists dw_stage;

DROP TABLE if exists dw_stage.accounting_period;

CREATE TABLE dw_stage.accounting_period 
(
  ACCOUNTING_PERIOD_ID   INTEGER,
  PERIOD_NAME            VARCHAR(300),
  START_DATE             TIMESTAMP,
  END_DATE               TIMESTAMP,
  FISCAL_CALENDAR        VARCHAR(100),
  FISCAL_CALENDAR_ID     INTEGER,
  SUBSIDIARY             VARCHAR(100),
  QUARTER_NAME           VARCHAR(300),
  YEAR_NAME              VARCHAR(300),
  CLOSED                 VARCHAR(10),
  CLOSED_AP              VARCHAR(10),
  CLOSED_AR              VARCHAR(10),
  CLOSED_PAYROLL         VARCHAR(10),
  CLOSED_ALL             VARCHAR(10),
  CLOSED_ON              TIMESTAMP,
  LOCKED_AP              VARCHAR(10),
  LOCKED_AR              VARCHAR(10),
  LOCKED_PAYROLL         VARCHAR(10),
  LOCKED_ALL             VARCHAR(10),
  ISINACTIVE             VARCHAR(10),
  YEAR_ID                INTEGER
);

