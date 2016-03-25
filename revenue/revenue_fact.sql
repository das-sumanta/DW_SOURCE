SELECT b.tranid AS document_number,
       b.transaction_number AS transaction_number,
       to_char(a.transaction_id) as transaction_id,
       to_char(a.transaction_line_id) as transaction_line_id,
       to_char(a.transaction_order) as transaction_order,
       f.transaction_number AS REF_DOC_NUMBER,
       TO_CHAR(f.custom_form_id) as ref_custom_form_id,
       TO_CHAR(b.payment_terms_id) AS payment_terms_id,
       b.revenue_commitment_status,
       b.revenue_status,
       TO_CHAR(NVL(b.sales_rep_id,h.sales_rep_id)) AS sales_rep_id,
       TO_CHAR(B.SALES_TERRITORY_ID) AS SALES_TERRITORY_ID,
       e.BILL_ADDRESS_LINE_1,
       e.BILL_ADDRESS_LINE_2,
       e.BILL_ADDRESS_LINE_3,
       e.BILL_CITY,
       e.BILL_COUNTRY,
       e.BILL_STATE,
       e.BILL_ZIP,
       e.SHIP_ADDRESS_LINE_1,
       e.SHIP_ADDRESS_LINE_2,
       e.SHIP_ADDRESS_LINE_3,
       e.SHIP_CITY,
       e.SHIP_COUNTRY,
       e.SHIP_STATE,
       e.SHIP_ZIP,
       status AS document_status,
       b.transaction_type AS transaction_type,
       TO_CHAR(b.currency_id) as currency_id,
       TO_CHAR(b.trandate,'YYYY-MM-DD HH24:MI:SS') AS trandate,
       b.EXCHANGE_RATE,
       to_char(a.account_id) as account_id,
       to_char(a.AMOUNT) as AMOUNT,
       to_char(a.AMOUNT_FOREIGN) as AMOUNT_FOREIGN,
       to_char(a.GROSS_AMOUNT) as GROSS_AMOUNT,
       to_char(a.NET_AMOUNT) as NET_AMOUNT,
       to_char(a.NET_AMOUNT_FOREIGN) as NET_AMOUNT_FOREIGN,
       to_char(a.rrp) as rrp,
       to_char(j.average_cost) as avg_cost,
       to_char(a.item_count) as quantity,
       to_char(a.item_id) as item_id,
       TO_CHAR(a.ITEM_UNIT_PRICE) AS ITEM_UNIT_PRICE,
       TO_CHAR(a.TAX_ITEM_ID) AS TAX_ITEM_ID,
       TO_CHAR(d.AMOUNT) AS TAX_AMOUNT,
       TO_CHAR(b.LOCATION_ID) AS LOCATION_ID,
       TO_CHAR(a.CLASS_ID) as CLASS_ID,
       TO_CHAR(a.SUBSIDIARY_ID) AS SUBSIDIARY_ID,
       TO_CHAR(B.accounting_period_ID) AS accounting_period_ID,
       TO_CHAR(B.entity_ID) AS customer_ID,
       TO_CHAR(a.price_type_ID) AS price_type_ID,
       TO_CHAR(B.custom_form_ID) AS custom_form_ID,
       TO_CHAR(b.created_by_ID) AS created_by_ID,
       TO_CHAR(B.create_date,'YYYY-MM-DD HH24:MI:SS') AS create_date,
       TO_CHAR(a.date_last_modified,'YYYY-MM-DD HH24:MI:SS') AS date_last_modified,
       DECODE(c.name,
             'AR-General','INV_HDR',
             decode(a.transaction_line_id,0,'INV_HDR',decode(d.transaction_line_id,NULL,decode(i.item_id,NULL,'INV_LINE','INV_TAX'),'INV_LINE'))
       ) AS line_type,
       NULL prepack_id,
       to_char(a.product_catalogue_id) product_catalogue_id
FROM transaction_lines a
  INNER JOIN transactions b ON (TRANSACTION_LINES.transaction_id = transactions.transaction_id)
  LEFT OUTER JOIN accounts c ON (TRANSACTION_LINES.account_id = accounts.account_id)
  LEFT OUTER JOIN transaction_tax_detail d
               ON (TRANSACTION_LINES.transaction_id = transaction_tax_detail.transaction_id
              AND TRANSACTION_LINES.transaction_line_id = transaction_tax_detail.transaction_line_id)
  LEFT OUTER JOIN transaction_address e ON (TRANSACTION_LINES.transaction_id = transaction_address.transaction_id)
  LEFT OUTER JOIN transactions f ON (b.created_from_id = f.transaction_id)
  LEFT OUTER JOIN customers h ON (b.ENTITY_ID = h.customer_id)
  LEFT OUTER JOIN tax_items i ON (a.item_id = i.item_id)
  LEFT OUTER JOIN item_location_map j ON (a.item_id = j.item_id AND a.location_id = j.location_id)
WHERE a.subsidiary_id = '%s'
AND   b.transaction_type = 'Invoice'
AND EXISTS (SELECT 1
              FROM transactions i
              WHERE i.transaction_id = a.transaction_id
              AND   i.transaction_type = 'Invoice'
	      AND i.date_last_modified >= to_timestamp('%s','YYYY-MM-DD HH24:MI:SS'))
UNION ALL
SELECT b.tranid AS document_number,
       b.transaction_number AS transaction_number,
       to_char(a.transaction_id) as transaction_id,
       to_char(a.transaction_line_id) as transaction_line_id,
       to_char(a.transaction_order) as transaction_order,
       f.transaction_number AS REF_DOC_NUMBER,
       TO_CHAR(f.custom_form_id) as ref_custom_form_id,
       TO_CHAR(b.payment_terms_id) AS payment_terms_id,
       b.revenue_commitment_status,
       b.revenue_status,
       TO_CHAR(NVL(b.sales_rep_id,h.sales_rep_id)) AS sales_rep_id,
       TO_CHAR(B.SALES_TERRITORY_ID) AS SALES_TERRITORY_ID,
       e.BILL_ADDRESS_LINE_1,
       e.BILL_ADDRESS_LINE_2,
       e.BILL_ADDRESS_LINE_3,
       e.BILL_CITY,
       e.BILL_COUNTRY,
       e.BILL_STATE,
       e.BILL_ZIP,
       e.SHIP_ADDRESS_LINE_1,
       e.SHIP_ADDRESS_LINE_2,
       e.SHIP_ADDRESS_LINE_3,
       e.SHIP_CITY,
       e.SHIP_COUNTRY,
       e.SHIP_STATE,
       e.SHIP_ZIP,
       status AS document_status,
       b.transaction_type AS transaction_type,
       TO_CHAR(b.currency_id) as currency_id,
       TO_CHAR(b.trandate,'YYYY-MM-DD HH24:MI:SS') AS trandate,
       b.EXCHANGE_RATE,
       to_char(a.account_id) as account_id,
       to_char(a.AMOUNT) as AMOUNT,
       to_char(a.AMOUNT_FOREIGN) as AMOUNT_FOREIGN,
       to_char(a.GROSS_AMOUNT) as GROSS_AMOUNT,
       to_char(a.NET_AMOUNT) as NET_AMOUNT,
       to_char(a.NET_AMOUNT_FOREIGN) as NET_AMOUNT_FOREIGN,
       to_char(a.rrp) as rrp,
       to_char(j.average_cost) as avg_cost,
       to_char(a.item_count) as quantity,
       to_char(a.item_id) as item_id,
       TO_CHAR(a.ITEM_UNIT_PRICE) AS ITEM_UNIT_PRICE,
       TO_CHAR(a.TAX_ITEM_ID) AS TAX_ITEM_ID,
       TO_CHAR(d.AMOUNT) AS TAX_AMOUNT,
       TO_CHAR(b.LOCATION_ID) AS LOCATION_ID,
       TO_CHAR(a.CLASS_ID) as CLASS_ID,
       TO_CHAR(a.SUBSIDIARY_ID) AS SUBSIDIARY_ID,
       TO_CHAR(B.accounting_period_ID) AS accounting_period_ID,
       TO_CHAR(B.entity_ID) AS customer_ID,
       TO_CHAR(a.price_type_ID) AS price_type_ID,
       TO_CHAR(B.custom_form_ID) AS custom_form_ID,
       TO_CHAR(b.created_by_ID) AS created_by_ID,
       TO_CHAR(B.create_date,'YYYY-MM-DD HH24:MI:SS') AS create_date,
       TO_CHAR(a.date_last_modified,'YYYY-MM-DD HH24:MI:SS') AS date_last_modified,
       DECODE(c.name,
             'Return Authorizations','RA_HDR',
             decode(a.transaction_line_id,0,'RA_HDR',decode(d.transaction_line_id,NULL,decode(i.item_id,NULL,'RA_LINE','RA_TAX'),'RA_LINE'))
       ) AS line_type,
       NULL prepack_id,
       to_char(a.product_catalogue_id) product_catalogue_id
FROM transaction_lines a
  INNER JOIN transactions b ON (TRANSACTION_LINES.transaction_id = transactions.transaction_id)
  LEFT OUTER JOIN accounts c ON (TRANSACTION_LINES.account_id = accounts.account_id)
  LEFT OUTER JOIN transaction_tax_detail d
               ON (TRANSACTION_LINES.transaction_id = transaction_tax_detail.transaction_id
              AND TRANSACTION_LINES.transaction_line_id = transaction_tax_detail.transaction_line_id)
  LEFT OUTER JOIN transaction_address e ON (TRANSACTION_LINES.transaction_id = transaction_address.transaction_id)
  LEFT OUTER JOIN transactions f ON (b.created_from_id = f.transaction_id)
  LEFT OUTER JOIN customers h ON (b.ENTITY_ID = h.customer_id)
  LEFT OUTER JOIN tax_items i ON (a.item_id = i.item_id)
  LEFT OUTER JOIN item_location_map j ON (a.item_id = j.item_id AND a.location_id = j.location_id)
WHERE a.subsidiary_id = '%s'
AND   b.transaction_type = 'Return Authorization' 
AND EXISTS (SELECT 1
              FROM transactions i
              WHERE i.transaction_id = a.transaction_id
              AND   i.transaction_type = 'Return Authorization' 
	      AND i.date_last_modified >= to_timestamp('%s','YYYY-MM-DD HH24:MI:SS'))
UNION ALL
SELECT b.tranid AS document_number,
       b.transaction_number AS transaction_number,
       to_char(a.transaction_id) as transaction_id,
       to_char(a.transaction_line_id) as transaction_line_id,
       to_char(a.transaction_order) as transaction_order,
       f.transaction_number AS REF_DOC_NUMBER,
       TO_CHAR(f.custom_form_id) as ref_custom_form_id,
       TO_CHAR(b.payment_terms_id) AS payment_terms_id,
       b.revenue_commitment_status,
       b.revenue_status,
       TO_CHAR(NVL(b.sales_rep_id,h.sales_rep_id)) AS sales_rep_id,
       TO_CHAR(B.SALES_TERRITORY_ID) AS SALES_TERRITORY_ID,
       e.BILL_ADDRESS_LINE_1,
       e.BILL_ADDRESS_LINE_2,
       e.BILL_ADDRESS_LINE_3,
       e.BILL_CITY,
       e.BILL_COUNTRY,
       e.BILL_STATE,
       e.BILL_ZIP,
       e.SHIP_ADDRESS_LINE_1,
       e.SHIP_ADDRESS_LINE_2,
       e.SHIP_ADDRESS_LINE_3,
       e.SHIP_CITY,
       e.SHIP_COUNTRY,
       e.SHIP_STATE,
       e.SHIP_ZIP,
       status AS document_status,
       b.transaction_type AS transaction_type,
       TO_CHAR(b.currency_id) as currency_id,
       TO_CHAR(b.trandate,'YYYY-MM-DD HH24:MI:SS') AS trandate,
       b.EXCHANGE_RATE,
       to_char(a.account_id) as account_id,
       to_char(a.AMOUNT) as AMOUNT,
       to_char(a.AMOUNT_FOREIGN) as AMOUNT_FOREIGN,
       to_char(a.GROSS_AMOUNT) as GROSS_AMOUNT,
       to_char(a.NET_AMOUNT) as NET_AMOUNT,
       to_char(a.NET_AMOUNT_FOREIGN) as NET_AMOUNT_FOREIGN,
       to_char(a.rrp) as rrp,
       to_char(j.average_cost) as avg_cost,
       to_char(a.item_count) as quantity,
       to_char(a.item_id) as item_id,
       TO_CHAR(a.ITEM_UNIT_PRICE) AS ITEM_UNIT_PRICE,
       TO_CHAR(a.TAX_ITEM_ID) AS TAX_ITEM_ID,
       TO_CHAR(d.AMOUNT) AS TAX_AMOUNT,
       TO_CHAR(b.LOCATION_ID) AS LOCATION_ID,
       TO_CHAR(a.CLASS_ID) as CLASS_ID,
       TO_CHAR(a.SUBSIDIARY_ID) AS SUBSIDIARY_ID,
       TO_CHAR(B.accounting_period_ID) AS accounting_period_ID,
       TO_CHAR(B.entity_ID) AS customer_ID,
       TO_CHAR(a.price_type_ID) AS price_type_ID,
       TO_CHAR(B.custom_form_ID) AS custom_form_ID,
       TO_CHAR(b.created_by_ID) AS created_by_ID,
       TO_CHAR(B.create_date,'YYYY-MM-DD HH24:MI:SS') AS create_date,
       TO_CHAR(a.date_last_modified,'YYYY-MM-DD HH24:MI:SS') AS date_last_modified,
       DECODE(c.name,
             'AR-General','CN_HDR',
             decode(a.transaction_line_id,0,'CN_HDR',decode(d.transaction_line_id,NULL,decode(i.item_id,NULL,'CN_LINE','CN_TAX'),'CN_LINE'))
       ) AS line_type,
       NULL prepack_id,
       to_char(a.product_catalogue_id) product_catalogue_id
FROM transaction_lines a
  INNER JOIN transactions b ON (TRANSACTION_LINES.transaction_id = transactions.transaction_id)
  LEFT OUTER JOIN accounts c ON (TRANSACTION_LINES.account_id = accounts.account_id)
  LEFT OUTER JOIN transaction_tax_detail d
               ON (TRANSACTION_LINES.transaction_id = transaction_tax_detail.transaction_id
              AND TRANSACTION_LINES.transaction_line_id = transaction_tax_detail.transaction_line_id)
  LEFT OUTER JOIN transaction_address e ON (TRANSACTION_LINES.transaction_id = transaction_address.transaction_id)
  LEFT OUTER JOIN transactions f ON (b.created_from_id = f.transaction_id)
  LEFT OUTER JOIN customers h ON (b.ENTITY_ID = h.customer_id)
  LEFT OUTER JOIN tax_items i ON (a.item_id = i.item_id)
  LEFT OUTER JOIN item_location_map j ON (a.item_id = j.item_id AND a.location_id = j.location_id)
WHERE a.subsidiary_id = '%s'
AND   b.transaction_type = 'Credit Memo'
AND EXISTS (SELECT 1
              FROM transactions i
              WHERE i.transaction_id = a.transaction_id
              AND   i.transaction_type = 'Credit Memo'
	      AND i.date_last_modified >= to_timestamp('%s','YYYY-MM-DD HH24:MI:SS'))
UNION ALL
SELECT b.tranid AS document_number,
       b.transaction_number AS transaction_number,
       to_char(a.transaction_id) as transaction_id,
       to_char(a.transaction_line_id) as transaction_line_id,
       to_char(a.transaction_order) as transaction_order,
       f.transaction_number AS REF_DOC_NUMBER,
       TO_CHAR(f.custom_form_id) as ref_custom_form_id,
       TO_CHAR(b.payment_terms_id) AS payment_terms_id,
       b.revenue_commitment_status,
       b.revenue_status,
       TO_CHAR(NVL(b.sales_rep_id,h.sales_rep_id)) AS sales_rep_id,
       TO_CHAR(B.SALES_TERRITORY_ID) AS SALES_TERRITORY_ID,
       e.BILL_ADDRESS_LINE_1,
       e.BILL_ADDRESS_LINE_2,
       e.BILL_ADDRESS_LINE_3,
       e.BILL_CITY,
       e.BILL_COUNTRY,
       e.BILL_STATE,
       e.BILL_ZIP,
       e.SHIP_ADDRESS_LINE_1,
       e.SHIP_ADDRESS_LINE_2,
       e.SHIP_ADDRESS_LINE_3,
       e.SHIP_CITY,
       e.SHIP_COUNTRY,
       e.SHIP_STATE,
       e.SHIP_ZIP,
       status AS document_status,
       b.transaction_type AS transaction_type,
       TO_CHAR(b.currency_id) as currency_id,
       TO_CHAR(b.trandate,'YYYY-MM-DD HH24:MI:SS') AS trandate,
       b.EXCHANGE_RATE,
       to_char(a.account_id) as account_id,
       to_char(a.AMOUNT) as AMOUNT,
       to_char(a.AMOUNT_FOREIGN) as AMOUNT_FOREIGN,
       to_char(a.GROSS_AMOUNT) as GROSS_AMOUNT,
       to_char(a.NET_AMOUNT) as NET_AMOUNT,
       to_char(a.NET_AMOUNT_FOREIGN) as NET_AMOUNT_FOREIGN,
       to_char(a.rrp) as rrp,
       NULL as avg_cost,
       to_char(a.item_count) as quantity,
       to_char(a.item_id) as item_id,
       TO_CHAR(a.ITEM_UNIT_PRICE) AS ITEM_UNIT_PRICE,
       TO_CHAR(a.TAX_ITEM_ID) AS TAX_ITEM_ID,
       TO_CHAR(d.AMOUNT) AS TAX_AMOUNT,
       TO_CHAR(b.LOCATION_ID) AS LOCATION_ID,
       TO_CHAR(a.CLASS_ID) as CLASS_ID,
       TO_CHAR(a.SUBSIDIARY_ID) AS SUBSIDIARY_ID,
       TO_CHAR(B.accounting_period_ID) AS accounting_period_ID,
       TO_CHAR(B.entity_ID) AS customer_ID,
       TO_CHAR(a.price_type_ID) AS price_type_ID,
       TO_CHAR(B.custom_form_ID) AS custom_form_ID,
       TO_CHAR(b.created_by_ID) AS created_by_ID,
       TO_CHAR(B.create_date,'YYYY-MM-DD HH24:MI:SS') AS create_date,
       TO_CHAR(a.date_last_modified,'YYYY-MM-DD HH24:MI:SS') AS date_last_modified,
       DECODE(c.name,
             'AR-General','JN_HDR',
             decode(a.transaction_line_id,0,'JN_HDR',decode(d.transaction_line_id,NULL,decode(i.item_id,NULL,'JN_LINE','JN_TAX'),'JN_LINE'))
       ) AS line_type,
       NULL prepack_id,
       to_char(a.product_catalogue_id) product_catalogue_id
FROM transaction_lines a
  INNER JOIN transactions b ON (TRANSACTION_LINES.transaction_id = transactions.transaction_id)
  LEFT OUTER JOIN accounts c ON (TRANSACTION_LINES.account_id = accounts.account_id)
  LEFT OUTER JOIN transaction_tax_detail d
               ON (TRANSACTION_LINES.transaction_id = transaction_tax_detail.transaction_id
              AND TRANSACTION_LINES.transaction_line_id = transaction_tax_detail.transaction_line_id)
  LEFT OUTER JOIN transaction_address e ON (TRANSACTION_LINES.transaction_id = transaction_address.transaction_id)
  LEFT OUTER JOIN transactions f ON (b.created_from_id = f.transaction_id)
  LEFT OUTER JOIN customers h ON (b.ENTITY_ID = h.customer_id)
  LEFT OUTER JOIN tax_items i ON (a.item_id = i.item_id)
WHERE a.subsidiary_id = '%s'
AND   b.transaction_type = 'Journal'
AND   c.accountnumber = '4000001'
AND c.full_name = 'Product Revenue : Revenue-Product'
AND EXISTS (SELECT 1
              FROM transactions i
              WHERE i.transaction_id = a.transaction_id
              AND   i.transaction_type = 'Journal'
	      AND  i.date_last_modified >= to_timestamp('%s','YYYY-MM-DD HH24:MI:SS'));
