/****************DIMENSION VIEWS ********************/

CREATE SCHEMA if not exists dw_report;

DROP VIEW if exists dw_report.PAYMENT_TERMS;

create view dw_report.PAYMENT_TERMS
AS select * from dw.PAYMENT_TERMS
where dw_active = 'A';

DROP VIEW if exists dw_report.locations;

create view dw_report.locations
AS select * from dw.locations
where dw_active = 'A';

DROP VIEW if exists dw_report.currencies;

create view dw_report.currencies
AS select * from dw.currencies
where dw_active = 'A';

DROP VIEW if exists dw_report.tax_items;

create view dw_report.tax_items
AS select * from dw.tax_items
where dw_active = 'A';

DROP VIEW if exists dw_report.freight_estimate;

create view dw_report.freight_estimate
AS select * from dw.freight_estimate
where dw_active = 'A';

DROP VIEW if exists dw_report.subsidiaries;

create view dw_report.subsidiaries
AS select * from dw.subsidiaries
where dw_active = 'A';

DROP VIEW if exists dw_report.cost_center;

create view dw_report.cost_center
AS select * from dw.cost_center
where dw_active = 'A';

DROP VIEW if exists dw_report.vendors;

create view dw_report.vendors
AS select * from dw.vendors
where dw_active = 'A';


DROP VIEW if exists dw_report.items;

create view dw_report.items
AS select * from dw.items
where dw_active = 'A';

DROP VIEW if exists dw_report.employees;

create view dw_report.employees
AS select * from dw.employees
where dw_active = 'A';

DROP VIEW if exists dw_report.classes;

create view dw_report.classes
AS select * from dw.classes
where dw_active = 'A';

DROP VIEW if exists dw_report.accounts;

create view dw_report.accounts
AS select * from dw.accounts
where dw_active = 'A';

DROP VIEW if exists dw_report.carrier;

create view dw_report.carrier
AS select * from dw.carrier
where dw_active = 'A';

DROP VIEW if exists dw_report.transaction_type;

create view dw_report.transaction_type
AS select * from dw.transaction_type
where dw_active = 'A';

DROP VIEW if exists dw_report.transaction_status;

create view dw_report.transaction_status
AS select * from dw.transaction_status
where dw_active = 'A';

DROP VIEW if exists dw_report.accounting_period;

create view dw_report.accounting_period
AS select * from dw.accounting_period
where dw_active = 'A';

DROP VIEW if exists dw_report.customers;

create view dw_report.customers
AS select * from dw.customers
where dw_active = 'A';

DROP VIEW if exists dw_report.territories;

create view dw_report.territories
AS select * from dw.territories
where dw_active = 'A';

DROP VIEW if exists dw_report.book_fairs;

create view dw_report.book_fairs
AS select * from dw.book_fairs
where dw_active = 'A';

DROP VIEW if exists dw_report.revenue_fact;

create view dw_report.revenue_fact
AS select * from dw.revenue_fact
where dw_current = 1;

DROP VIEW if exists dw_report.opportunity_fact;

create view dw_report.opportunity_fact
AS select * from dw.opportunity_fact
where dw_current = 1;

DROP VIEW if exists dw_report.dwdate;

create view dw_report.dwdate
AS select * from dw.dwdate;

/****************FACT VIEWS *************************/
DROP VIEW IF EXISTS dw_report.opportunity_fact CASCADE;

CREATE VIEW dw_report.opportunity_fact
AS 
 SELECT * from dw.opportunity_fact
 where DW_CURRENT = 1;




/****************REPORT VIEWS ********************/

DROP VIEW IF EXISTS dw_report.actual CASCADE;

CREATE VIEW dw_report.actual
AS 
 SELECT f.class_key, f.subsidiary_key, g.fiscal_week_number, g.fiscal_month_number, g.fiscal_year, g.fiscal_year + 1 AS previous_year, sum(NVL(f.net_amount, 0)) AS actual
   FROM dw.revenue_fact f
   JOIN dw_report.dwdate g ON f.transaction_date_key = g.date_key
  GROUP BY f.class_key, f.subsidiary_key, g.fiscal_week_number, g.fiscal_month_number, g.fiscal_year;

DROP VIEW IF EXISTS dw_report.budget CASCADE;

CREATE VIEW dw_report.budget
AS 
 SELECT b.fiscal_week_id AS fiscal_week_number, b.fiscal_month_id AS fiscal_month_number, b.budgetforecast_name AS fiscal_year, b.class_key, b.subsidiary_key, sum(NVL(b.amount, 0)) AS budget
   FROM dw.budgetforecast_fact b
  WHERE b.budgetforecast_type = 'BUDGET'
  GROUP BY b.fiscal_week_id, b.fiscal_month_id, b.budgetforecast_name, b.class_key, b.subsidiary_key;

DROP VIEW IF EXISTS dw_report.forecast CASCADE;

CREATE VIEW dw_report.forecast
AS 
 SELECT d.fiscal_week_id AS fiscal_week_number, d.fiscal_month_id AS fiscal_month_number, d.budgetforecast_name AS fiscal_year, d.class_key, d.subsidiary_key, sum(NVL(d.amount, 0)) AS forecast
   FROM dw.budgetforecast_fact d
  WHERE d.budgetforecast_type = 'FORECAST3'
  GROUP BY d.fiscal_week_id, d.fiscal_month_id, d.budgetforecast_name, d.class_key, d.subsidiary_key;

drop view if exists dw_report.timeline cascade;

create view dw_report.timeline as
select c.subsidiary_key , c.subsidiary , a.class_key , a.line_of_business , b.FISCAL_WEEK_NUMBER, b.FISCAL_MONTH_NUMBER, b.FISCAL_YEAR from
(select class_key , name line_of_business from dw_report.classes
where class_id <> 0) a,
(SELECT DISTINCT FISCAL_WEEK_NUMBER , FISCAL_MONTH_NUMBER, FISCAL_YEAR FROM DW_report.DWDATE 
/*WHERE FISCAL_YEAR = 2016*/ ) b,
(select subsidiary_key , name subsidiary from dw_report.subsidiaries
where subsidiary_id <> 0) c;


commit;

