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

commit;

