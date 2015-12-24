CREATE SCHEMA if not exists dw;

DROP TABLE if exists dw.revenue_summary_fiscal_week;

CREATE TABLE dw.revenue_summary_fiscal_week
(
  REVENUE_SUMMARY_KEY BIGINT IDENTITY(0,1), 
  FISCAL_YEAR         INTEGER
 ,FISCAL_MONTH        INTEGER
 ,MONTH_ENDED         DATE
 ,FISCAL_WEEK         INTEGER
 ,WEEK_ENDED          DATE
 ,LINE_OF_BUSINESS     VARCHAR(50)
 ,REGION              VARCHAR(100)
 ,TYPE                VARCHAR(50)
 ,AMOUNT              DECIMAL(22,2)
 ,DATE_ACTIVE_FROM    DATE  
 ,DATE_ACTIVE_TO      DATE   
 ,DW_CURRENT          INTEGER
 );