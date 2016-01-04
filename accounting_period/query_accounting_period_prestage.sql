select A.ACCOUNTING_PERIOD_ID,
       A.NAME AS PERIOD_NAME,
       A.STARTING AS START_DATE,
       A.ENDING AS END_DATE,
       'Scholastic NZ Fiscal Calendar' AS FISCAL_CALENDAR,
       A.fiscal_calendar_id,
       c.name as subsidiary,
       d.name as quarter_name,
       e.name as year_name,
       a.closed,
       a.closed_accounts_payable,
       a.closed_accounts_receivable,
       a.closed_payroll,
       a.closed_all,
       a.closed_on,
       a.locked_accounts_payable,
       a.locked_accounts_receivable,
       a.locked_payroll,
       a.locked_all,
       a.isinactive,
       a.year_id
 from accounting_periods A
INNER JOIN SUBSIDIARIES C ON (C.fiscal_calendar_id = A.fiscal_calendar_id)
LEFT OUTER JOIN accounting_periods D ON ( A.PARENT_ID= D.ACCOUNTING_PERIOD_ID  )
LEFT OUTER JOIN accounting_periods E ON ( D.PARENT_ID = E.ACCOUNTING_PERIOD_ID )
WHERE NOT EXISTS ( SELECT 1 FROM accounting_periods B
WHERE A.ACCOUNTING_PERIOD_ID = B.PARENT_ID )
AND C.SUBSIDIARY_ID = 27
AND C.FISCAL_CALENDAR_ID = A.FISCAL_CALENDAR_ID
AND D.Quarter = 'Yes'
AND D.YEAR_0 = 'No'
AND A.Quarter = 'No'
AND A.year_0 = 'No'
AND E.Quarter = 'No'
AND E.YEAR_0 = 'Yes'