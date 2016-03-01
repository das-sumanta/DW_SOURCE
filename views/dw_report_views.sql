/****************DIMENSION VIEWS ********************/ 
CREATE SCHEMA if not exists dw_report;

DROP VIEW if exists dw_report.PAYMENT_TERMS;

CREATE VIEW dw_report.PAYMENT_TERMS 
AS
SELECT *
FROM dw.PAYMENT_TERMS
WHERE dw_active = 'A';

DROP VIEW if exists dw_report.locations;

CREATE VIEW dw_report.locations 
AS
SELECT *
FROM dw.locations
WHERE dw_active = 'A';

DROP VIEW if exists dw_report.currencies;

CREATE VIEW dw_report.currencies 
AS
SELECT *
FROM dw.currencies
WHERE dw_active = 'A';

DROP VIEW if exists dw_report.tax_items;

CREATE VIEW dw_report.tax_items 
AS
SELECT *
FROM dw.tax_items
WHERE dw_active = 'A';

DROP VIEW if exists dw_report.freight_estimate;

CREATE VIEW dw_report.freight_estimate 
AS
SELECT *
FROM dw.freight_estimate
WHERE dw_active = 'A';

DROP VIEW if exists dw_report.subsidiaries;

CREATE VIEW dw_report.subsidiaries 
AS
SELECT *
FROM dw.subsidiaries
WHERE dw_active = 'A';

DROP VIEW if exists dw_report.cost_center;

CREATE VIEW dw_report.cost_center 
AS
SELECT *
FROM dw.cost_center
WHERE dw_active = 'A';

DROP VIEW if exists dw_report.vendors;

CREATE VIEW dw_report.vendors 
AS
SELECT *
FROM dw.vendors
WHERE dw_active = 'A';

DROP VIEW if exists dw_report.items;

CREATE VIEW dw_report.items 
AS
SELECT *
FROM dw.items
WHERE dw_active = 'A';

DROP VIEW if exists dw_report.employees;

CREATE VIEW dw_report.employees 
AS
SELECT *
FROM dw.employees
WHERE dw_active = 'A';

DROP VIEW if exists dw_report.classes;

CREATE VIEW dw_report.classes 
AS
SELECT *
FROM dw.classes
WHERE dw_active = 'A';

DROP VIEW if exists dw_report.accounts;

CREATE VIEW dw_report.accounts 
AS
SELECT *
FROM dw.accounts
WHERE dw_active = 'A';

DROP VIEW if exists dw_report.carrier;

CREATE VIEW dw_report.carrier 
AS
SELECT *
FROM dw.carrier
WHERE dw_active = 'A';

DROP VIEW if exists dw_report.transaction_type;

CREATE VIEW dw_report.transaction_type 
AS
SELECT *
FROM dw.transaction_type
WHERE dw_active = 'A';

DROP VIEW if exists dw_report.transaction_status;

CREATE VIEW dw_report.transaction_status 
AS
SELECT *
FROM dw.transaction_status
WHERE dw_active = 'A';

DROP VIEW if exists dw_report.accounting_period;

CREATE VIEW dw_report.accounting_period 
AS
SELECT *
FROM dw.accounting_period
WHERE dw_active = 'A';

DROP VIEW if exists dw_report.customers;

CREATE VIEW dw_report.customers 
AS
SELECT *
FROM dw.customers
WHERE dw_active = 'A';

DROP VIEW if exists dw_report.territories;

CREATE VIEW dw_report.territories 
AS
SELECT *
FROM dw.territories
WHERE dw_active = 'A';

DROP VIEW if exists dw_report.book_fairs;

CREATE VIEW dw_report.book_fairs 
AS
SELECT *
FROM dw.book_fairs
WHERE dw_active = 'A';

DROP VIEW if exists dw_report.revenue_fact;

CREATE VIEW dw_report.revenue_fact 
AS
SELECT *
FROM dw.revenue_fact
WHERE dw_current = 1;

DROP VIEW if exists dw_report.opportunity_fact;

CREATE VIEW dw_report.opportunity_fact 
AS
SELECT *
FROM dw.opportunity_fact
WHERE dw_current = 1;

DROP VIEW if exists dw_report.dwdate;

CREATE VIEW dw_report.dwdate 
AS
SELECT *
FROM dw.dwdate;

/****************FACT VIEWS *************************/ 
DROP VIEW IF EXISTS dw_report.opportunity_fact CASCADE;

CREATE VIEW dw_report.opportunity_fact 
AS
SELECT *
FROM dw.opportunity_fact
WHERE DW_CURRENT = 1;

/****************REPORT VIEWS ********************/ 
DROP VIEW IF EXISTS dw_report.actual CASCADE;

CREATE VIEW dw_report.actual 
AS
SELECT f.class_key,
       f.subsidiary_key,
       g.fiscal_week_number,
       g.fiscal_month_number,
       g.fiscal_year,
       g.fiscal_year + 1 AS previous_year,
       SUM(NVL (f.net_amount,0)) AS actual
FROM dw.revenue_fact f
  JOIN dw_report.dwdate g ON f.transaction_date_key = g.date_key
GROUP BY f.class_key,
         f.subsidiary_key,
         g.fiscal_week_number,
         g.fiscal_month_number,
         g.fiscal_year;

DROP VIEW IF EXISTS dw_report.budget CASCADE;

CREATE VIEW dw_report.budget 
AS
SELECT b.fiscal_week_id AS fiscal_week_number,
       b.fiscal_month_id AS fiscal_month_number,
       b.budgetforecast_name AS fiscal_year,
       b.class_key,
       b.subsidiary_key,
       SUM(NVL (b.amount,0)) AS budget
FROM dw.budgetforecast_fact b
WHERE b.budgetforecast_type = 'BUDGET'
GROUP BY b.fiscal_week_id,
         b.fiscal_month_id,
         b.budgetforecast_name,
         b.class_key,
         b.subsidiary_key;

DROP VIEW IF EXISTS dw_report.forecast CASCADE;

CREATE VIEW dw_report.forecast 
AS
SELECT d.fiscal_week_id AS fiscal_week_number,
       d.fiscal_month_id AS fiscal_month_number,
       d.budgetforecast_name AS fiscal_year,
       d.class_key,
       d.subsidiary_key,
       SUM(NVL (d.amount,0)) AS forecast
FROM dw.budgetforecast_fact d
WHERE d.budgetforecast_type = 'FORECAST3'
GROUP BY d.fiscal_week_id,
         d.fiscal_month_id,
         d.budgetforecast_name,
         d.class_key,
         d.subsidiary_key;

DROP VIEW if exists dw_report.timeline CASCADE;

CREATE VIEW dw_report.timeline 
AS
SELECT c.subsidiary_key,
       c.subsidiary,
       a.class_key,
       a.line_of_business,
       b.FISCAL_WEEK_NUMBER,
       b.FISCAL_MONTH_NUMBER,
       b.FISCAL_YEAR
FROM (SELECT class_key,
             name line_of_business
      FROM dw_report.classes
      WHERE class_id <> 0) a,
     (SELECT DISTINCT FISCAL_WEEK_NUMBER,
             FISCAL_MONTH_NUMBER,
             FISCAL_YEAR
      FROM DW_report.DWDATE /*WHERE FISCAL_YEAR = 2016*/) b,
     (SELECT subsidiary_key,
             name subsidiary
      FROM dw_report.subsidiaries
      WHERE subsidiary_id <> 0) c;

DROP VIEW if exists dw_report.sales_timeline CASCADE;

CREATE VIEW dw_report.sales_timeline 
AS
SELECT d.territory_key,
       d.territory,
       c.subsidiary_key,
       c.subsidiary,
       a.class_key,
       a.line_of_business,
       b.calendar_month_number,
       b.calendar_year,
       b.FISCAL_WEEK_NUMBER,
       b.FISCAL_MONTH_NUMBER,
       b.FISCAL_YEAR
FROM (SELECT class_key,
             name line_of_business
      FROM dw_report.classes
      WHERE class_id <> 0) a,
     (SELECT DISTINCT FISCAL_WEEK_NUMBER,
             FISCAL_MONTH_NUMBER,
             FISCAL_YEAR,
             calendar_month_number,
             calendar_year
      FROM DW_report.DWDATE /*WHERE FISCAL_YEAR = 2016*/) b,
     (SELECT subsidiary_key,
             name subsidiary
      FROM dw_report.subsidiaries
      WHERE subsidiary_id <> 0) c,
     (SELECT territory_key,
             territory
      FROM dw_report.territories
      WHERE territory_id <> 0) d;

CREATE VIEW dw_report.sales_actual 
AS
SELECT f.class_key,
       f.subsidiary_key,
       f.territory_key,
       g.fiscal_week_number,
       g.fiscal_month_number,
       g.fiscal_year,
       g.fiscal_year + 1 AS previous_fiscal_year,
       g.calendar_week_number,
       g.calendar_month_number,
       g.calendar_year,
       g.calendar_year + 1 AS previous_calendar_year,
       SUM(NVL (f.net_amount,0)) AS actual
FROM dw.revenue_fact f
  JOIN dw_report.dwdate g ON f.transaction_date_key = g.date_key
GROUP BY f.class_key,
         f.subsidiary_key,
         f.territory_key,
         g.fiscal_week_number,
         g.fiscal_month_number,
         g.fiscal_year,
         g.fiscal_year + 1,
         g.calendar_week_number,
         g.calendar_month_number,
         g.calendar_year,
         g.calendar_year + 1;

DROP VIEW IF EXISTS dw_report.sales_target CASCADE;

CREATE OR REPLACE VIEW dw_report.sales_target 
AS
SELECT d.fiscal_week_id AS fiscal_week_number,
       d.fiscal_month_id AS fiscal_month_number,
       d.budgetforecast_name AS fiscal_year,
       d.class_key,
       d.subsidiary_key,
       d.territory_key,
       SUM(NVL (d.amount,0)) AS target
FROM dw.budgetforecast_fact d
WHERE d.budgetforecast_type = 'FORECAST3'
GROUP BY d.fiscal_week_id,
         d.fiscal_month_id,
         d.budgetforecast_name,
         d.class_key,
         d.subsidiary_key,
         d.territory_key;

COMMIT;

