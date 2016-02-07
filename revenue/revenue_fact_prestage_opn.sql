/* prestage - drop intermediate insert table */
DROP TABLE if exists dw_prestage.revenue_fact_insert;

/* prestage - create intermediate insert table*/
CREATE TABLE dw_prestage.revenue_fact_insert
AS
SELECT a.*
FROM dw_prestage.revenue_fact a
WHERE not exists ( select 1 FROM dw_stage.revenue_fact b
where a.TRANSACTION_ID = b.TRANSACTION_ID
AND   a.transaction_line_id = b.transaction_line_id
AND   a.subsidiary_id = b.subsidiary_id);

/* prestage - drop intermediate update table*/
DROP TABLE if exists dw_prestage.revenue_fact_update;

/* prestage - create intermediate update table*/
CREATE TABLE dw_prestage.revenue_fact_update
AS
SELECT TRANSACTION_ID,
       transaction_line_id,
       subsidiary_id
FROM (SELECT TRANSACTION_ID,
             transaction_line_id,
             subsidiary_id
      FROM (SELECT TRANSACTION_NUMBER,
                   TRANSACTION_ID,
                   TRANSACTION_LINE_ID,
                   TRANSACTION_ORDER,
                   REF_DOC_NUMBER,
                   REF_CUSTOM_FORM_ID,
                   PAYMENT_TERMS_ID,
                   REVENUE_COMMITMENT_STATUS,
                   REVENUE_STATUS,
                   SALES_REP_ID,
                   SALES_TERRITORY_ID,
                   BILL_ADDRESS_LINE_1,
                   BILL_ADDRESS_LINE_2,
                   BILL_ADDRESS_LINE_3,
                   BILL_CITY,
                   BILL_COUNTRY,
                   BILL_STATE,
                   BILL_ZIP,
                   SHIP_ADDRESS_LINE_1,
                   SHIP_ADDRESS_LINE_2,
                   SHIP_ADDRESS_LINE_3,
                   SHIP_CITY,
                   SHIP_COUNTRY,
                   SHIP_STATE,
                   SHIP_ZIP,
                   STATUS,
                   TRANSACTION_TYPE,
                   CURRENCY_ID,
                   TRANDATE,
                   EXCHANGE_RATE,
                   ACCOUNT_ID,
                   AMOUNT,
                   AMOUNT_FOREIGN,
                   GROSS_AMOUNT,
                   NET_AMOUNT,
                   NET_AMOUNT_FOREIGN,
                   QUANTITY,
                   ITEM_ID,
                   ITEM_UNIT_PRICE,
                   TAX_ITEM_ID,
                   TAX_AMOUNT,
                   LOCATION_ID,
                   CLASS_ID,
                   SUBSIDIARY_ID,
                   ACCOUNTING_PERIOD_ID,
                   CUSTOMER_ID,
                   PRICE_TYPE_ID,
                   CUSTOM_FORM_ID,
                   CREATED_BY_ID,
                   CREATE_DATE,
                   DATE_LAST_MODIFIED
            FROM dw_prestage.revenue_fact A2
            WHERE NOT EXISTS ( SELECT 1 FROM DW_PRESTAGE.REVENUE_FACT_INSERT B2
                  WHERE B2.TRANSACTION_ID = A2.TRANSACTION_ID
                  AND B2.TRANSACTION_LINE_ID = A2.TRANSACTION_LINE_ID 
                  AND   A2.SUBSIDIARY_ID = B2.SUBSIDIARY_ID)
            MINUS
            SELECT TRANSACTION_NUMBER,
                   TRANSACTION_ID,
                   TRANSACTION_LINE_ID,
                   TRANSACTION_ORDER,
                   REF_DOC_NUMBER,
                   REF_CUSTOM_FORM_ID,
                   PAYMENT_TERMS_ID,
                   REVENUE_COMMITMENT_STATUS,
                   REVENUE_STATUS,
                   SALES_REP_ID,
                   SALES_TERRITORY_ID,
                   BILL_ADDRESS_LINE_1,
                   BILL_ADDRESS_LINE_2,
                   BILL_ADDRESS_LINE_3,
                   BILL_CITY,
                   BILL_COUNTRY,
                   BILL_STATE,
                   BILL_ZIP,
                   SHIP_ADDRESS_LINE_1,
                   SHIP_ADDRESS_LINE_2,
                   SHIP_ADDRESS_LINE_3,
                   SHIP_CITY,
                   SHIP_COUNTRY,
                   SHIP_STATE,
                   SHIP_ZIP,
                   STATUS,
                   TRANSACTION_TYPE,
                   CURRENCY_ID,
                   TRANDATE,
                   EXCHANGE_RATE,
                   ACCOUNT_ID,
                   AMOUNT,
                   AMOUNT_FOREIGN,
                   GROSS_AMOUNT,
                   NET_AMOUNT,
                   NET_AMOUNT_FOREIGN,
                   QUANTITY,
                   ITEM_ID,
                   ITEM_UNIT_PRICE,
                   TAX_ITEM_ID,
                   TAX_AMOUNT,
                   LOCATION_ID,
                   CLASS_ID,
                   SUBSIDIARY_ID,
                   ACCOUNTING_PERIOD_ID,
                   CUSTOMER_ID,
                   PRICE_TYPE_ID,
                   CUSTOM_FORM_ID,
                   CREATED_BY_ID,
                   CREATE_DATE,
                   DATE_LAST_MODIFIED
            FROM dw_stage.revenue_fact a1
			WHERE EXISTS ( select 1 from dw_prestage.revenue_fact b1
where b1.TRANSACTION_ID = a1.TRANSACTION_ID
     and b1.transaction_line_id = a1.transaction_line_id 
     AND   a1.subsidiary_id = b1.subsidiary_id))) a
WHERE NOT EXISTS (SELECT 1
                  FROM dw_prestage.revenue_fact_insert
                  WHERE dw_prestage.revenue_fact_insert.TRANSACTION_ID = a.TRANSACTION_ID
                  AND   dw_prestage.revenue_fact_insert.transaction_line_id = a.transaction_line_id);

/* prestage - drop intermediate no change track table*/
DROP TABLE if exists dw_prestage.revenue_fact_nochange;

/* prestage - create intermediate no change track table*/
CREATE TABLE dw_prestage.revenue_fact_nochange
AS
SELECT TRANSACTION_ID,
       transaction_line_id
FROM (SELECT TRANSACTION_ID,
             transaction_line_id
      FROM dw_prestage.revenue_fact A
      WHERE NOT EXISTS ( SELECT 1
      FROM dw_prestage.revenue_fact_insert B
      WHERE A.TRANSACTION_ID = B.TRANSACTION_ID
      AND A.TRANSACTION_LINE_ID = B.TRANSACTION_LINE_ID)
      AND NOT EXISTS ( SELECT 1
      FROM dw_prestage.revenue_fact_update C
      WHERE A.TRANSACTION_ID = C.TRANSACTION_ID
      AND A.TRANSACTION_LINE_ID = C.TRANSACTION_LINE_ID));

/* prestage-> no of revenue fact records ingested in staging*/
SELECT count(1) FROM dw_prestage.revenue_fact;

/* prestage-> no of revenue fact records identified to inserted*/
SELECT  count(1) FROM dw_prestage.revenue_fact_insert;

/* prestage-> no of revenue fact records identified to updated -->*/
SELECT  count(1) FROM dw_prestage.revenue_fact_update;

/* prestage-> no of revenue fact records identified as no change*/
SELECT count(1) FROM dw_prestage.revenue_fact_nochange;

--D --A = B + C + D
/* stage -> delete from stage records to be updated */
DELETE
FROM dw_stage.revenue_fact USING dw_prestage.revenue_fact_update
WHERE dw_stage.revenue_fact.transaction_id = dw_prestage.revenue_fact_update.transaction_id
AND   dw_stage.revenue_fact.transaction_line_id = dw_prestage.revenue_fact_update.transaction_line_id
AND   dw_stage.revenue_fact.subsidiary_id = dw_prestage.revenue_fact_update.subsidiary_id;

/* stage -> insert into stage records which have been created */
INSERT INTO dw_stage.revenue_fact(runid
 ,transaction_number
 ,transaction_id
 ,transaction_line_id
 ,transaction_order
 ,ref_doc_number
 ,REF_CUSTOM_FORM_ID
 ,payment_terms_id
 ,revenue_commitment_status
 ,revenue_status
 ,sales_rep_id
 ,SALES_TERRITORY_ID
 ,bill_address_line_1
 ,bill_address_line_2
 ,bill_address_line_3
 ,bill_city
 ,bill_country
 ,bill_state
 ,bill_zip
 ,ship_address_line_1
 ,ship_address_line_2
 ,ship_address_line_3
 ,ship_city
 ,ship_country
 ,ship_state
 ,ship_zip
 ,status
 ,transaction_type
 ,currency_id
 ,trandate
 ,exchange_rate
 ,account_id
 ,amount
 ,amount_foreign
 ,gross_amount
 ,net_amount
 ,net_amount_foreign
 ,quantity
 ,item_id
 ,item_unit_price
 ,tax_item_id
 ,tax_amount
 ,location_id
 ,class_id
 ,subsidiary_id
 ,accounting_period_id
 ,customer_id
 ,trx_type
 ,custom_form_id
 ,created_by_id
 ,create_date
 ,price_type_id
 ,date_last_modified)
SELECT runid
 ,transaction_number
 ,transaction_id
 ,transaction_line_id
 ,transaction_order
 ,ref_doc_number
 ,REF_CUSTOM_FORM_ID
 ,payment_terms_id
 ,revenue_commitment_status
 ,revenue_status
 ,sales_rep_id
 ,SALES_TERRITORY_ID
 ,bill_address_line_1
 ,bill_address_line_2
 ,bill_address_line_3
 ,bill_city
 ,bill_country
 ,bill_state
 ,bill_zip
 ,ship_address_line_1
 ,ship_address_line_2
 ,ship_address_line_3
 ,ship_city
 ,ship_country
 ,ship_state
 ,ship_zip
 ,status
 ,transaction_type
 ,currency_id
 ,trandate
 ,exchange_rate
 ,account_id
 ,amount
 ,amount_foreign
 ,gross_amount
 ,net_amount
 ,net_amount_foreign
 ,quantity
 ,item_id
 ,item_unit_price
 ,tax_item_id
 ,tax_amount
 ,location_id
 ,class_id
 ,subsidiary_id
 ,accounting_period_id
 ,customer_id
 ,trx_type
 ,custom_form_id
 ,created_by_id
 ,create_date
 ,price_type_id
 ,date_last_modified
FROM dw_prestage.revenue_fact_insert;

/* stage -> insert into stage records which have been updated */
INSERT INTO dw_stage.revenue_fact
(runid
 ,transaction_number
 ,transaction_id
 ,transaction_line_id
 ,transaction_order
 ,ref_doc_number
 ,REF_CUSTOM_FORM_ID
 ,payment_terms_id
 ,revenue_commitment_status
 ,revenue_status
 ,sales_rep_id
 ,SALES_TERRITORY_ID
 ,bill_address_line_1
 ,bill_address_line_2
 ,bill_address_line_3
 ,bill_city
 ,bill_country
 ,bill_state
 ,bill_zip
 ,ship_address_line_1
 ,ship_address_line_2
 ,ship_address_line_3
 ,ship_city
 ,ship_country
 ,ship_state
 ,ship_zip
 ,status
 ,transaction_type
 ,currency_id
 ,trandate
 ,exchange_rate
 ,account_id
 ,amount
 ,amount_foreign
 ,gross_amount
 ,net_amount
 ,net_amount_foreign
 ,quantity
 ,item_id
 ,item_unit_price
 ,tax_item_id
 ,tax_amount
 ,location_id
 ,class_id
 ,subsidiary_id
 ,accounting_period_id
 ,customer_id
 ,trx_type
 ,custom_form_id
 ,created_by_id
 ,create_date
 ,price_type_id
 ,date_last_modified)
SELECT runid
 ,transaction_number
 ,transaction_id
 ,transaction_line_id
 ,transaction_order
 ,ref_doc_number
 ,REF_CUSTOM_FORM_ID
 ,payment_terms_id
 ,revenue_commitment_status
 ,revenue_status
 ,sales_rep_id
 ,SALES_TERRITORY_ID
 ,bill_address_line_1
 ,bill_address_line_2
 ,bill_address_line_3
 ,bill_city
 ,bill_country
 ,bill_state
 ,bill_zip
 ,ship_address_line_1
 ,ship_address_line_2
 ,ship_address_line_3
 ,ship_city
 ,ship_country
 ,ship_state
 ,ship_zip
 ,status
 ,transaction_type
 ,currency_id
 ,trandate
 ,exchange_rate
 ,account_id
 ,amount
 ,amount_foreign
 ,gross_amount
 ,net_amount
 ,net_amount_foreign
 ,quantity
 ,item_id
 ,item_unit_price
 ,tax_item_id
 ,tax_amount
 ,location_id
 ,class_id
 ,subsidiary_id
 ,accounting_period_id
 ,customer_id
 ,trx_type
 ,custom_form_id
 ,created_by_id
 ,create_date
 ,price_type_id
 ,date_last_modified
FROM dw_prestage.revenue_fact
WHERE EXISTS (SELECT 1
              FROM dw_prestage.revenue_fact_update
              WHERE dw_prestage.revenue_fact_update.transaction_id = dw_prestage.revenue_fact.transaction_id
              AND   dw_prestage.revenue_fact_update.transaction_line_id = dw_prestage.revenue_fact.transaction_line_id);



/* fact -> INSERT NEW RECORDS WHICH HAS ALL VALID DIMENSIONS */
INSERT INTO dw.revenue_fact
(
DOCUMENT_NUMBER
,TRANSACTION_ID
,TRANSACTION_LINE_ID
,REF_DOC_NUMBER
,REF_DOC_TYPE_KEY
,TERMS_KEY
,REVENUE_COMMITMENT_STATUS
,REVENUE_STATUS
,SALES_REP_KEY
,TERRITORY_KEY
,BILL_ADDRESS_LINE_1
,BILL_ADDRESS_LINE_2
,BILL_ADDRESS_LINE_3
,BILL_CITY
,BILL_COUNTRY
,BILL_STATE
,BILL_ZIP
,SHIP_ADDRESS_LINE_1
,SHIP_ADDRESS_LINE_2
,SHIP_ADDRESS_LINE_3
,SHIP_CITY
,SHIP_COUNTRY
,SHIP_STATE
,SHIP_ZIP
,DOCUMENT_STATUS_KEY
,DOCUMENT_TYPE_KEY
,CURRENCY_KEY
,TRANSACTION_DATE_KEY
,EXCHANGE_RATE
,ACCOUNT_KEY
,AMOUNT
,AMOUNT_FOREIGN
,GROSS_AMOUNT
,NET_AMOUNT
,NET_AMOUNT_FOREIGN
,QUANTITY
,ITEM_KEY
,RATE
,TAX_ITEM_KEY
,TAX_AMOUNT
,LOCATION_KEY
,CLASS_KEY
,SUBSIDIARY_KEY
,CUSTOMER_KEY
,ACCOUNTING_PERIOD_KEY
,DATE_ACTIVE_FROM
,DATE_ACTIVE_TO
,DW_CURRENT
)
select
TRANSACTION_NUMBER
,TRANSACTION_ID
,TRANSACTION_LINE_ID
,REF_DOC_NUMBER
,n.transaction_type_key AS REF_DOC_TYPE_KEY
,b.PAYMENT_TERM_KEY AS TERMS_KEY
,REVENUE_COMMITMENT_STATUS
,REVENUE_STATUS
,r.employee_key
,c.territory_key
,BILL_ADDRESS_LINE_1
,BILL_ADDRESS_LINE_2
,BILL_ADDRESS_LINE_3
,BILL_CITY
,BILL_COUNTRY
,BILL_STATE
,BILL_ZIP
,SHIP_ADDRESS_LINE_1
,SHIP_ADDRESS_LINE_2
,SHIP_ADDRESS_LINE_3
,SHIP_CITY
,SHIP_COUNTRY
,SHIP_STATE
,SHIP_ZIP
,o.transaction_status_key  as DOCUMENT_STATUS_KEY
,p.transaction_type_key    as DOCUMENT_TYPE_KEY
,d.currency_key
,e.date_key as TRANSACTION_DATE_KEY
,EXCHANGE_RATE
,f.account_key
,AMOUNT
,AMOUNT_FOREIGN
,GROSS_AMOUNT
,NET_AMOUNT
,NET_AMOUNT_FOREIGN
,QUANTITY
 ,g.item_key
 ,ITEM_UNIT_PRICE        as rate
 ,h.TAX_ITEM_KEY
 ,TAX_AMOUNT
 ,k.location_key
 ,l.class_key
 ,j.subsidiary_key
 ,m.customer_key
 ,q.accounting_period_key
 ,SYSDATE AS DATE_ACTIVE_FROM
 ,'9999-12-31 11:59:59' AS DATE_ACTIVE_TO
 ,1 AS DW_CURRENT
 from dw_prestage.revenue_fact_insert a
 INNER JOIN DW_REPORT.PAYMENT_TERMS b ON (NVL (A.PAYMENT_TERMS_ID,-99) = b.PAYMENT_TERMS_ID)
 INNER JOIN DW_REPORT.territories c ON (NVL (A.sales_territory_ID,-99) = c.territory_ID)
 INNER JOIN DW_REPORT.CURRENCIES d ON (A.CURRENCY_ID = d.CURRENCY_ID)
 INNER JOIN DW_REPORT.DWDATE e ON (TO_CHAR (A.tranDATE,'YYYYMMDD') = e.DATE_ID)
 INNER JOIN DW_REPORT.ACCOUNTS F ON (NVL (A.account_ID,-99) = f.account_ID)
 INNER JOIN DW_REPORT.ITEMS g ON (A.ITEM_ID = g.ITEM_ID)
 INNER JOIN DW_REPORT.TAX_ITEMS h ON (A.TAX_ITEM_ID = h.ITEM_ID)
 INNER JOIN DW_REPORT.SUBSIDIARIES j ON (A.SUBSIDIARY_ID = j.SUBSIDIARY_ID)
 INNER JOIN DW_REPORT.LOCATIONS k ON (NVL (A.LOCATION_ID,-99) = k.LOCATION_ID)
 INNER JOIN DW_REPORT.CLASSES l ON (NVL(A.CLASS_ID,-99) = l.CLASS_ID)
 INNER JOIN DW_REPORT.customers m ON (A.customer_ID = m.customer_ID)
 INNER JOIN DW_REPORT.transaction_type n ON (NVL(A.ref_custom_form_id,-99) = n.transaction_type_id)
 INNER JOIN DW_REPORT.transaction_status o ON (NVL(A.STATUS,'NA_GDW') = o.status AND NVL(A.TRANSACTION_TYPE,'NA_GDW') = o.DOCUMENT_TYPE)
 INNER JOIN DW_REPORT.transaction_type p ON (A.custom_form_id = p.transaction_type_id)
 INNER JOIN DW_REPORT.accounting_period q ON (NVL(A.accounting_period_id,-99) = q.accounting_period_id)
 INNER JOIN DW_REPORT.employees r ON (NVL(A.sales_rep_id,-99) = r.employee_id)
where trx_type in ('INV_LINE','RA_LINE','CN_LINE','JN_LINE' );

/* fact -> INSERT NEW RECORDS IN ERROR TABLE WHICH DOES NOT HAVE VALID DIMENSIONS */
INSERT INTO dw.revenue_fact_error
(
   RUNID
  ,DOCUMENT_NUMBER
  ,TRANSACTION_ID
  ,TRANSACTION_LINE_ID
  ,REF_DOC_NUMBER
  ,REF_DOC_TYPE_KEY
  ,TERMS_KEY
  ,REVENUE_COMMITMENT_STATUS
  ,REVENUE_STATUS
  ,SALES_REP_KEY
  ,TERRITORY_KEY
  ,BILL_ADDRESS_LINE_1
  ,BILL_ADDRESS_LINE_2
  ,BILL_ADDRESS_LINE_3
  ,BILL_CITY
  ,BILL_COUNTRY
  ,BILL_STATE
  ,BILL_ZIP
  ,SHIP_ADDRESS_LINE_1
  ,SHIP_ADDRESS_LINE_2
  ,SHIP_ADDRESS_LINE_3
  ,SHIP_CITY
  ,SHIP_COUNTRY
  ,SHIP_STATE
  ,SHIP_ZIP
  ,DOCUMENT_STATUS_KEY
  ,DOCUMENT_TYPE_KEY
  ,CURRENCY_KEY
  ,TRANSACTION_DATE_KEY
  ,EXCHANGE_RATE
  ,ACCOUNT_KEY
  ,AMOUNT
  ,AMOUNT_FOREIGN
  ,GROSS_AMOUNT
  ,NET_AMOUNT
  ,NET_AMOUNT_FOREIGN
  ,QUANTITY
  ,ITEM_KEY
  ,RATE
  ,TAX_ITEM_KEY
  ,TAX_AMOUNT
  ,LOCATION_KEY
  ,CLASS_KEY
  ,SUBSIDIARY_KEY
  ,CUSTOMER_KEY
  ,ACCOUNTING_PERIOD_KEY
  ,REF_CUSTOM_FORM_ID
  ,REF_TRANSACTION_TYPE_ERROR
  ,CUSTOM_FORM_ID
  ,TRANSACTION_TYPE_ERROR
  ,PAYMENT_TERMS_ID
  ,PAYMENT_TERMS_ID_ERROR
  ,SALES_REP_ID
  ,SALES_REP_ID_ERROR
  ,SALES_TERRITORY_ID
  ,TERRITORY_ID_ERROR
  ,STATUS
  ,STATUS_ERROR
  ,CURRENCY_ID
  ,CURRENCY_ID_ERROR
  ,TRANDATE
  ,TRANDATE_ERROR
  ,ACCOUNT_ID
  ,ACCOUNT_ID_ERROR
  ,ITEM_ID
  ,ITEM_ID_ERROR
  ,TAX_ITEM_ID
  ,TAX_ITEM_ID_ERROR
  ,LOCATION_ID
  ,LOCATION_ID_ERROR
  ,CLASS_ID
  ,CLASS_ID_ERROR
  ,SUBSIDIARY_ID
  ,SUBSIDIARY_ID_ERROR
  ,CUSTOMER_ID
  ,CUSTOMER_ID_ERROR
  ,ACCOUNTING_PERIOD_ID
  ,ACCOUNTING_PERIOD_ID_ERROR
  ,TRANSACTION_TYPE
  ,RECORD_STATUS
  ,DW_CREATION_DATE
)
SELECT
  A.RUNID
, A.TRANSACTION_NUMBER
,A.TRANSACTION_ID
,A.TRANSACTION_LINE_ID
,A.REF_DOC_NUMBER
,n.transaction_type_key AS REF_DOC_TYPE_KEY
,b.PAYMENT_TERM_KEY AS TERMS_KEY
,REVENUE_COMMITMENT_STATUS
,REVENUE_STATUS
,R.EMPLOYEE_KEY
,c.territory_key
,BILL_ADDRESS_LINE_1
,BILL_ADDRESS_LINE_2
,BILL_ADDRESS_LINE_3
,BILL_CITY
,BILL_COUNTRY
,BILL_STATE
,BILL_ZIP
,SHIP_ADDRESS_LINE_1
,SHIP_ADDRESS_LINE_2
,SHIP_ADDRESS_LINE_3
,SHIP_CITY
,SHIP_COUNTRY
,SHIP_STATE
,SHIP_ZIP
,o.transaction_status_key  as DOCUMENT_STATUS_KEY
,p.transaction_type_key    as DOCUMENT_TYPE_KEY
,d.currency_key
,e.date_key as TRANSACTION_DATE_KEY
,EXCHANGE_RATE
,f.account_key
,AMOUNT
,AMOUNT_FOREIGN
,GROSS_AMOUNT
,NET_AMOUNT
,NET_AMOUNT_FOREIGN
,QUANTITY
 ,g.item_key
 ,ITEM_UNIT_PRICE        as rate
 ,h.TAX_ITEM_KEY
 ,TAX_AMOUNT
 ,k.location_key
 ,l.class_key
 ,j.subsidiary_key
 ,m.customer_key
 ,q.accounting_period_key
 ,A.ref_custom_form_id
  ,CASE
         WHEN (n.transaction_type_key IS NULL AND A.ref_custom_form_id IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (n.transaction_type_key IS NULL AND A.ref_custom_form_id IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END
 ,A.custom_form_id
   ,CASE
         WHEN (P.transaction_type_key IS NULL AND A.custom_form_id IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (P.transaction_type_key IS NULL AND A.custom_form_id IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END
 ,A.PAYMENT_TERMS_ID
 ,CASE
         WHEN (b.PAYMENT_TERM_KEY IS NULL AND A.PAYMENT_TERMS_ID IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (b.PAYMENT_TERM_KEY IS NULL AND A.PAYMENT_TERMS_ID IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END
 ,A.sales_REP_ID
  ,CASE
         WHEN (r.employee_KEY IS NULL AND A.sales_REP_ID IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (r.employee_KEY IS NULL AND A.sales_REP_ID IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END
 ,A.sales_TERRITORY_ID
  ,CASE
         WHEN (c.territory_key IS NULL AND A.sales_TERRITORY_ID IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (c.territory_key IS NULL AND A.sales_TERRITORY_ID IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END
 ,A.STATUS
   ,CASE
         WHEN (o.transaction_status_key IS NULL AND A.STATUS IS NOT NULL AND A.TRANSACTION_TYPE IS NOT NULL ) THEN ' DIM LOOKUP FAILED '
         WHEN (o.transaction_status_key IS NULL AND A.STATUS IS NULL AND A.TRANSACTION_TYPE IS  NULL ) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END
,A.CURRENCY_ID
  ,CASE
         WHEN (d.currency_key IS NULL AND A.CURRENCY_ID IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (d.currency_key IS NULL AND A.CURRENCY_ID IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END
,A.TRANDATE
  ,CASE
         WHEN (e.date_key IS NULL AND A.TRANDATE IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (e.date_key IS NULL AND A.TRANDATE IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END
 , A.ACCOUNT_ID
   ,CASE
         WHEN (f.account_key IS NULL AND A.ACCOUNT_ID IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (f.account_key IS NULL AND A.ACCOUNT_ID IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END
, A.ITEM_ID
   ,CASE
         WHEN (g.item_key IS NULL AND A.ITEM_ID IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (g.item_key IS NULL AND A.ITEM_ID IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END
, A.TAX_ITEM_ID
   ,CASE
         WHEN (h.TAX_ITEM_KEY IS NULL AND A.TAX_ITEM_ID IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (h.TAX_ITEM_KEY IS NULL AND A.TAX_ITEM_ID IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END
,A.LOCATION_ID
   ,CASE
         WHEN (k.location_key IS NULL AND A.LOCATION_ID IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (k.location_key IS NULL AND A.LOCATION_ID IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END
,A.CLASS_ID
   ,CASE
         WHEN (l.class_key  IS NULL AND A.CLASS_ID IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (l.class_key  IS NULL AND A.CLASS_ID IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END
,A.SUBSIDIARY_ID
   ,CASE
         WHEN (j.subsidiary_key IS NULL AND A.SUBSIDIARY_ID IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (j.subsidiary_key IS NULL AND A.SUBSIDIARY_ID IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END
,A.CUSTOMER_ID
   ,CASE
         WHEN (m.customer_key IS NULL AND A.CUSTOMER_ID IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (m.customer_key IS NULL AND A.CUSTOMER_ID IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END
,A.ACCOUNTING_PERIOD_ID
   ,CASE
         WHEN (q.accounting_period_key IS NULL AND A.ACCOUNTING_PERIOD_ID IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (q.accounting_period_key IS NULL AND A.ACCOUNTING_PERIOD_ID IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END
,A.TRANSACTION_TYPE
,'ERROR' AS RECORD_STATUS
,SYSDATE AS DW_CREATION_DATE
 from dw_prestage.revenue_fact_insert a
 LEFT OUTER JOIN DW_REPORT.PAYMENT_TERMS b ON (A.PAYMENT_TERMS_ID = b.PAYMENT_TERMS_ID)
 LEFT OUTER JOIN DW_REPORT.territories c ON (A.sales_territory_ID = c.territory_ID)
 LEFT OUTER JOIN DW_REPORT.CURRENCIES d ON (A.CURRENCY_ID = d.CURRENCY_ID)
 LEFT OUTER JOIN DW_REPORT.DWDATE e ON (TO_CHAR (A.tranDATE,'YYYYMMDD') = e.DATE_ID)
 LEFT OUTER JOIN DW_REPORT.ACCOUNTS F ON (A.account_ID = f.account_ID)
 LEFT OUTER JOIN DW_REPORT.ITEMS g ON (A.ITEM_ID = g.ITEM_ID)
 LEFT OUTER JOIN DW_REPORT.TAX_ITEMS h ON (A.TAX_ITEM_ID = h.ITEM_ID)
 LEFT OUTER JOIN DW_REPORT.SUBSIDIARIES j ON (A.SUBSIDIARY_ID = j.SUBSIDIARY_ID)
 LEFT OUTER JOIN DW_REPORT.LOCATIONS k ON (A.LOCATION_ID = k.LOCATION_ID)
 LEFT OUTER JOIN DW_REPORT.CLASSES l ON (A.CLASS_ID = l.CLASS_ID)
 LEFT OUTER JOIN DW_REPORT.customers m ON (A.customer_ID = m.customer_ID)
 LEFT OUTER JOIN DW_REPORT.transaction_type n ON (A.ref_custom_form_id = n.transaction_type_id)
 LEFT OUTER JOIN DW_REPORT.transaction_status o ON (A.STATUS = o.status AND A.TRANSACTION_TYPE = o.DOCUMENT_TYPE)
 LEFT OUTER JOIN DW_REPORT.transaction_type p ON (A.custom_form_id = p.transaction_type_id)
 LEFT OUTER JOIN DW_REPORT.accounting_period q ON (A.accounting_period_id = q.accounting_period_id)
 LEFT OUTER JOIN DW_REPORT.employees r ON (A.sales_rep_id = r.employee_id)
where trx_type in ('INV_LINE','RA_LINE','CN_LINE','JN_LINE' ) AND
((B.PAYMENT_TERM_KEY IS NULL AND A.PAYMENT_TERMS_ID IS NOT NULL )OR
 (C.TERRITORY_KEY IS NULL AND A.sales_territory_ID IS NOT NULL ) OR
 D.CURRENCY_KEY IS NULL OR
 E.DATE_KEY IS NULL OR
 (F.ACCOUNT_KEY IS NULL AND A.account_ID IS NOT NULL ) OR
 G.ITEM_KEY IS NULL OR
 H.TAX_ITEM_KEY IS NULL OR
 J.SUBSIDIARY_KEY IS NULL OR
 (K.LOCATION_KEY IS NULL AND A.LOCATION_ID IS NOT NULL ) OR
 ( L.CLASS_KEY IS NULL AND A.CLASS_ID IS NOT NULL ) OR
 M.CUSTOMER_KEY IS NULL OR
 ( N.transaction_type_key IS NULL AND A.ref_custom_form_id IS NOT NULL ) OR
 ( O.transaction_status_key IS NULL AND A.STATUS IS NOT NULL AND A.TRANSACTION_TYPE IS NOT NULL )OR
 ( P.transaction_type_key IS NULL AND A.custom_form_id IS NOT NULL ) OR
 (Q.ACCOUNTING_PERIOD_KEY IS NULL AND A.accounting_period_id IS NOT NULL ) OR 
 (r.employee_KEY IS NULL AND A.sales_rep_id IS NOT NULL));

/* fact -> UPDATE THE OLD RECORDS SETTING THE CURRENT FLAG VALUE TO 0 */
UPDATE dw.revenue_fact SET dw_current = 0,DATE_ACTIVE_TO = (sysdate -1) WHERE dw_current = 1
AND   sysdate>= date_active_from
AND   sysdate< date_active_to
AND   EXISTS (SELECT 1 FROM dw_prestage.revenue_fact_update
  WHERE dw.revenue_fact.transaction_ID = dw_prestage.revenue_fact_update.transaction_id
  AND   dw.revenue_fact.transaction_LINE_ID = dw_prestage.revenue_fact_update.transaction_line_id);

/* fact -> NOW INSERT THE FACT RECORDS WHICH HAVE BEEN UPDATED AT THE SOURCE */
INSERT INTO dw.revenue_fact
(
DOCUMENT_NUMBER
,TRANSACTION_ID
,TRANSACTION_LINE_ID
,REF_DOC_NUMBER
,REF_DOC_TYPE_KEY
,TERMS_KEY
,REVENUE_COMMITMENT_STATUS
,REVENUE_STATUS
,SALES_REP_KEY
,TERRITORY_KEY
,BILL_ADDRESS_LINE_1
,BILL_ADDRESS_LINE_2
,BILL_ADDRESS_LINE_3
,BILL_CITY
,BILL_COUNTRY
,BILL_STATE
,BILL_ZIP
,SHIP_ADDRESS_LINE_1
,SHIP_ADDRESS_LINE_2
,SHIP_ADDRESS_LINE_3
,SHIP_CITY
,SHIP_COUNTRY
,SHIP_STATE
,SHIP_ZIP
,DOCUMENT_STATUS_KEY
,DOCUMENT_TYPE_KEY
,CURRENCY_KEY
,TRANSACTION_DATE_KEY
,EXCHANGE_RATE
,ACCOUNT_KEY
,AMOUNT
,AMOUNT_FOREIGN
,GROSS_AMOUNT
,NET_AMOUNT
,NET_AMOUNT_FOREIGN
,QUANTITY
,ITEM_KEY
,RATE
,TAX_ITEM_KEY
,TAX_AMOUNT
,LOCATION_KEY
,CLASS_KEY
,SUBSIDIARY_KEY
,CUSTOMER_KEY
,ACCOUNTING_PERIOD_KEY
,DATE_ACTIVE_FROM
,DATE_ACTIVE_TO
,DW_CURRENT
)
select
TRANSACTION_NUMBER
,TRANSACTION_ID
,TRANSACTION_LINE_ID
,REF_DOC_NUMBER
,n.transaction_type_key AS REF_DOC_TYPE_KEY
,b.PAYMENT_TERM_KEY AS TERMS_KEY
,REVENUE_COMMITMENT_STATUS
,REVENUE_STATUS
,r.employee_key
,c.territory_key
,BILL_ADDRESS_LINE_1
,BILL_ADDRESS_LINE_2
,BILL_ADDRESS_LINE_3
,BILL_CITY
,BILL_COUNTRY
,BILL_STATE
,BILL_ZIP
,SHIP_ADDRESS_LINE_1
,SHIP_ADDRESS_LINE_2
,SHIP_ADDRESS_LINE_3
,SHIP_CITY
,SHIP_COUNTRY
,SHIP_STATE
,SHIP_ZIP
,o.transaction_status_key  as DOCUMENT_STATUS_KEY
,p.transaction_type_key    as DOCUMENT_TYPE_KEY
,d.currency_key
,e.date_key as TRANSACTION_DATE_KEY
,EXCHANGE_RATE
,f.account_key
,AMOUNT
,AMOUNT_FOREIGN
,GROSS_AMOUNT
,NET_AMOUNT
,NET_AMOUNT_FOREIGN
,QUANTITY
 ,g.item_key
 ,ITEM_UNIT_PRICE        as rate
 ,h.TAX_ITEM_KEY
 ,TAX_AMOUNT
 ,k.location_key
 ,l.class_key
 ,j.subsidiary_key
 ,m.customer_key
 ,q.accounting_period_key
 ,SYSDATE AS DATE_ACTIVE_FROM
 ,'9999-12-31 11:59:59' AS DATE_ACTIVE_TO
 ,1 AS DW_CURRENT
 from dw_prestage.revenue_fact a
 INNER JOIN DW_REPORT.PAYMENT_TERMS b ON (NVL (A.PAYMENT_TERMS_ID,-99) = b.PAYMENT_TERMS_ID)
 INNER JOIN DW_REPORT.territories c ON (NVL (A.sales_territory_ID,-99) = c.territory_ID)
 INNER JOIN DW_REPORT.CURRENCIES d ON (A.CURRENCY_ID = d.CURRENCY_ID)
 INNER JOIN DW_REPORT.DWDATE e ON (TO_CHAR (A.tranDATE,'YYYYMMDD') = e.DATE_ID)
 INNER JOIN DW_REPORT.ACCOUNTS F ON (NVL (A.account_ID,-99) = f.account_ID)
 INNER JOIN DW_REPORT.ITEMS g ON (A.ITEM_ID = g.ITEM_ID)
 INNER JOIN DW_REPORT.TAX_ITEMS h ON (A.TAX_ITEM_ID = h.ITEM_ID)
 INNER JOIN DW_REPORT.SUBSIDIARIES j ON (A.SUBSIDIARY_ID = j.SUBSIDIARY_ID)
 INNER JOIN DW_REPORT.LOCATIONS k ON (NVL (A.LOCATION_ID,-99) = k.LOCATION_ID)
 INNER JOIN DW_REPORT.CLASSES l ON (NVL(A.CLASS_ID,-99) = l.CLASS_ID)
 INNER JOIN DW_REPORT.customers m ON (A.customer_ID = m.customer_ID)
 INNER JOIN DW_REPORT.transaction_type n ON (NVL(A.ref_custom_form_id,-99) = n.transaction_type_id)
 INNER JOIN DW_REPORT.transaction_status o ON (NVL(A.STATUS,'NA_GDW') = o.status AND NVL(A.TRANSACTION_TYPE,'NA_GDW') = o.DOCUMENT_TYPE)
 INNER JOIN DW_REPORT.transaction_type p ON (A.custom_form_id = p.transaction_type_id)
 INNER JOIN DW_REPORT.accounting_period q ON (NVL(A.accounting_period_id,-99) = q.accounting_period_id)
 INNER JOIN DW_REPORT.employees r ON (NVL(A.sales_rep_id,-99) = r.employee_id)
where trx_type in ('INV_LINE','RA_LINE','CN_LINE','JN_LINE' )
AND   EXISTS (SELECT 1 FROM dw_prestage.revenue_fact_update
 WHERE a.transaction_id = dw_prestage.revenue_fact_update.transaction_id
 AND   a.transaction_line_id = dw_prestage.revenue_fact_update.transaction_line_id);

/* fact -> INSERT UPDATED RECORDS IN ERROR TABLE WHICH DOES NOT HAVE VALID DIMENSIONS */
INSERT INTO dw.revenue_fact_error
(
   RUNID
  ,DOCUMENT_NUMBER
  ,TRANSACTION_ID
  ,TRANSACTION_LINE_ID
  ,REF_DOC_NUMBER
  ,REF_DOC_TYPE_KEY
  ,TERMS_KEY
  ,REVENUE_COMMITMENT_STATUS
  ,REVENUE_STATUS
  ,SALES_REP_KEY
  ,TERRITORY_KEY
  ,BILL_ADDRESS_LINE_1
  ,BILL_ADDRESS_LINE_2
  ,BILL_ADDRESS_LINE_3
  ,BILL_CITY
  ,BILL_COUNTRY
  ,BILL_STATE
  ,BILL_ZIP
  ,SHIP_ADDRESS_LINE_1
  ,SHIP_ADDRESS_LINE_2
  ,SHIP_ADDRESS_LINE_3
  ,SHIP_CITY
  ,SHIP_COUNTRY
  ,SHIP_STATE
  ,SHIP_ZIP
  ,DOCUMENT_STATUS_KEY
  ,DOCUMENT_TYPE_KEY
  ,CURRENCY_KEY
  ,TRANSACTION_DATE_KEY
  ,EXCHANGE_RATE
  ,ACCOUNT_KEY
  ,AMOUNT
  ,AMOUNT_FOREIGN
  ,GROSS_AMOUNT
  ,NET_AMOUNT
  ,NET_AMOUNT_FOREIGN
  ,QUANTITY
  ,ITEM_KEY
  ,RATE
  ,TAX_ITEM_KEY
  ,TAX_AMOUNT
  ,LOCATION_KEY
  ,CLASS_KEY
  ,SUBSIDIARY_KEY
  ,CUSTOMER_KEY
  ,ACCOUNTING_PERIOD_KEY
  ,REF_CUSTOM_FORM_ID
  ,REF_TRANSACTION_TYPE_ERROR
  ,CUSTOM_FORM_ID
  ,TRANSACTION_TYPE_ERROR
  ,PAYMENT_TERMS_ID
  ,PAYMENT_TERMS_ID_ERROR
  ,SALES_REP_ID
  ,SALES_REP_ID_ERROR
  ,SALES_TERRITORY_ID
  ,TERRITORY_ID_ERROR
  ,STATUS
  ,STATUS_ERROR
  ,CURRENCY_ID
  ,CURRENCY_ID_ERROR
  ,TRANDATE
  ,TRANDATE_ERROR
  ,ACCOUNT_ID
  ,ACCOUNT_ID_ERROR
  ,ITEM_ID
  ,ITEM_ID_ERROR
  ,TAX_ITEM_ID
  ,TAX_ITEM_ID_ERROR
  ,LOCATION_ID
  ,LOCATION_ID_ERROR
  ,CLASS_ID
  ,CLASS_ID_ERROR
  ,SUBSIDIARY_ID
  ,SUBSIDIARY_ID_ERROR
  ,CUSTOMER_ID
  ,CUSTOMER_ID_ERROR
  ,ACCOUNTING_PERIOD_ID
  ,ACCOUNTING_PERIOD_ID_ERROR
  ,TRANSACTION_TYPE
  ,RECORD_STATUS
  ,DW_CREATION_DATE
)
SELECT
  A.RUNID
, A.TRANSACTION_NUMBER
,A.TRANSACTION_ID
,A.TRANSACTION_LINE_ID
,A.REF_DOC_NUMBER
,n.transaction_type_key AS REF_DOC_TYPE_KEY
,b.PAYMENT_TERM_KEY AS TERMS_KEY
,REVENUE_COMMITMENT_STATUS
,REVENUE_STATUS
,R.EMPLOYEE_KEY
,c.territory_key
,BILL_ADDRESS_LINE_1
,BILL_ADDRESS_LINE_2
,BILL_ADDRESS_LINE_3
,BILL_CITY
,BILL_COUNTRY
,BILL_STATE
,BILL_ZIP
,SHIP_ADDRESS_LINE_1
,SHIP_ADDRESS_LINE_2
,SHIP_ADDRESS_LINE_3
,SHIP_CITY
,SHIP_COUNTRY
,SHIP_STATE
,SHIP_ZIP
,o.transaction_status_key  as DOCUMENT_STATUS_KEY
,p.transaction_type_key    as DOCUMENT_TYPE_KEY
,d.currency_key
,e.date_key as TRANSACTION_DATE_KEY
,EXCHANGE_RATE
,f.account_key
,AMOUNT
,AMOUNT_FOREIGN
,GROSS_AMOUNT
,NET_AMOUNT
,NET_AMOUNT_FOREIGN
,QUANTITY
 ,g.item_key
 ,ITEM_UNIT_PRICE        as rate
 ,h.TAX_ITEM_KEY
 ,TAX_AMOUNT
 ,k.location_key
 ,l.class_key
 ,j.subsidiary_key
 ,m.customer_key
 ,q.accounting_period_key
 ,A.ref_custom_form_id
  ,CASE
         WHEN (n.transaction_type_key IS NULL AND A.ref_custom_form_id IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (n.transaction_type_key IS NULL AND A.ref_custom_form_id IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END
 ,A.custom_form_id
   ,CASE
         WHEN (P.transaction_type_key IS NULL AND A.custom_form_id IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (P.transaction_type_key IS NULL AND A.custom_form_id IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END
 ,A.PAYMENT_TERMS_ID
 ,CASE
         WHEN (b.PAYMENT_TERM_KEY IS NULL AND A.PAYMENT_TERMS_ID IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (b.PAYMENT_TERM_KEY IS NULL AND A.PAYMENT_TERMS_ID IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END
 ,A.sales_REP_ID
  ,CASE
         WHEN (r.employee_KEY IS NULL AND A.sales_REP_ID IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (r.employee_KEY IS NULL AND A.sales_REP_ID IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END
 ,A.sales_TERRITORY_ID
  ,CASE
         WHEN (c.territory_key IS NULL AND A.sales_TERRITORY_ID IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (c.territory_key IS NULL AND A.sales_TERRITORY_ID IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END
 ,A.STATUS
   ,CASE
         WHEN (d.currency_key IS NULL AND A.STATUS IS NOT NULL AND A.TRANSACTION_TYPE IS NOT NULL ) THEN ' DIM LOOKUP FAILED '
         WHEN (d.currency_key IS NULL AND A.STATUS IS NULL AND A.TRANSACTION_TYPE IS  NULL ) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END
,A.CURRENCY_ID
  ,CASE
         WHEN (d.currency_key IS NULL AND A.CURRENCY_ID IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (d.currency_key IS NULL AND A.CURRENCY_ID IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END
,A.TRANDATE
  ,CASE
         WHEN (e.date_key IS NULL AND A.TRANDATE IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (e.date_key IS NULL AND A.TRANDATE IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END
 , A.ACCOUNT_ID
   ,CASE
         WHEN (f.account_key IS NULL AND A.ACCOUNT_ID IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (f.account_key IS NULL AND A.ACCOUNT_ID IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END
, A.ITEM_ID
   ,CASE
         WHEN (g.item_key IS NULL AND A.ITEM_ID IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (g.item_key IS NULL AND A.ITEM_ID IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END
, A.TAX_ITEM_ID
   ,CASE
         WHEN (h.TAX_ITEM_KEY IS NULL AND A.TAX_ITEM_ID IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (h.TAX_ITEM_KEY IS NULL AND A.TAX_ITEM_ID IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END
,A.LOCATION_ID
   ,CASE
         WHEN (k.location_key IS NULL AND A.LOCATION_ID IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (k.location_key IS NULL AND A.LOCATION_ID IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END
,A.CLASS_ID
   ,CASE
         WHEN (l.class_key  IS NULL AND A.CLASS_ID IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (l.class_key  IS NULL AND A.CLASS_ID IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END
,A.SUBSIDIARY_ID
   ,CASE
         WHEN (j.subsidiary_key IS NULL AND A.SUBSIDIARY_ID IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (j.subsidiary_key IS NULL AND A.SUBSIDIARY_ID IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END
,A.CUSTOMER_ID
   ,CASE
         WHEN (m.customer_key IS NULL AND A.CUSTOMER_ID IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (m.customer_key IS NULL AND A.CUSTOMER_ID IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END
,A.ACCOUNTING_PERIOD_ID
   ,CASE
         WHEN (q.accounting_period_key IS NULL AND A.ACCOUNTING_PERIOD_ID IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (q.accounting_period_key IS NULL AND A.ACCOUNTING_PERIOD_ID IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END
,A.TRANSACTION_TYPE
,'ERROR' AS RECORD_STATUS
,SYSDATE AS DW_CREATION_DATE
 from dw_prestage.revenue_fact a
 LEFT OUTER JOIN DW_REPORT.PAYMENT_TERMS b ON (A.PAYMENT_TERMS_ID = b.PAYMENT_TERMS_ID)
 LEFT OUTER JOIN DW_REPORT.territories c ON (A.sales_territory_ID = c.territory_ID)
 LEFT OUTER JOIN DW_REPORT.CURRENCIES d ON (A.CURRENCY_ID = d.CURRENCY_ID)
 LEFT OUTER JOIN DW_REPORT.DWDATE e ON (TO_CHAR (A.tranDATE,'YYYYMMDD') = e.DATE_ID)
 LEFT OUTER JOIN DW_REPORT.ACCOUNTS F ON (A.account_ID = f.account_ID)
 LEFT OUTER JOIN DW_REPORT.ITEMS g ON (A.ITEM_ID = g.ITEM_ID)
 LEFT OUTER JOIN DW_REPORT.TAX_ITEMS h ON (A.TAX_ITEM_ID = h.ITEM_ID)
 LEFT OUTER JOIN DW_REPORT.SUBSIDIARIES j ON (A.SUBSIDIARY_ID = j.SUBSIDIARY_ID)
 LEFT OUTER JOIN DW_REPORT.LOCATIONS k ON (A.LOCATION_ID = k.LOCATION_ID)
 LEFT OUTER JOIN DW_REPORT.CLASSES l ON (A.CLASS_ID = l.CLASS_ID)
 LEFT OUTER JOIN DW_REPORT.customers m ON (A.customer_ID = m.customer_ID)
 LEFT OUTER JOIN DW_REPORT.transaction_type n ON (A.ref_custom_form_id = n.transaction_type_id)
 LEFT OUTER JOIN DW_REPORT.transaction_status o ON (A.STATUS = o.status AND A.TRANSACTION_TYPE = o.DOCUMENT_TYPE)
 LEFT OUTER JOIN DW_REPORT.transaction_type p ON (A.custom_form_id = p.transaction_type_id)
 LEFT OUTER JOIN DW_REPORT.accounting_period q ON (A.accounting_period_id = q.accounting_period_id)
 LEFT OUTER JOIN DW_REPORT.employees r ON (A.sales_rep_id = r.employee_id)
where trx_type in ('INV_LINE','RA_LINE','CN_LINE','JN_LINE' ) AND
((B.PAYMENT_TERM_KEY IS NULL AND A.PAYMENT_TERMS_ID IS NOT NULL )OR
 (C.TERRITORY_KEY IS NULL AND A.sales_territory_ID IS NOT NULL ) OR
 D.CURRENCY_KEY IS NULL OR
 E.DATE_KEY IS NULL OR
 (F.ACCOUNT_KEY IS NULL AND A.account_ID IS NOT NULL ) OR
 G.ITEM_KEY IS NULL OR
 H.TAX_ITEM_KEY IS NULL OR
 J.SUBSIDIARY_KEY IS NULL OR
 (K.LOCATION_KEY IS NULL AND A.LOCATION_ID IS NOT NULL ) OR
 ( L.CLASS_KEY IS NULL AND A.CLASS_ID IS NOT NULL ) OR
 M.CUSTOMER_KEY IS NULL OR
 ( N.transaction_type_key IS NULL AND A.ref_custom_form_id IS NOT NULL ) OR
 ( O.transaction_status_key IS NULL AND A.STATUS IS NOT NULL AND A.TRANSACTION_TYPE IS NOT NULL )OR
 ( P.transaction_type_key IS NULL AND A.custom_form_id IS NOT NULL ) OR
 (Q.ACCOUNTING_PERIOD_KEY IS NULL AND A.accounting_period_id IS NOT NULL ) OR 
 (r.employee_KEY IS NULL AND A.sales_rep_id IS NOT NULL))
AND   EXISTS (SELECT 1
             FROM dw_prestage.revenue_fact_update
             WHERE
                   a.transaction_id = dw_prestage.revenue_fact_update.transaction_id
             AND   a.transaction_line_id = dw_prestage.revenue_fact_update.transaction_line_id);
