SELECT 1 as RUNID,
       TO_CHAR(TRANSACTIONS.transaction_id) AS transaction_id,
       TO_CHAR(TRANSACTION_LINES.transaction_line_id) AS transaction_line_id,
       REPLACE(REPLACE(TRANSACTIONS.transaction_number, CHR(10), ' '),
               CHR(13),
               ' ') AS VB_NUMBER,
       TO_CHAR(TRANSACTIONS.ENTITY_ID) AS VENDOR_ID,
       TO_CHAR(TRANSACTIONS.CREATED_FROM_ID) AS CREATED_FROM_ID,
       F.TRANSACTION_NUMBER AS REF_TRX_NUMBER,
       F.TRANSACTION_TYPE AS REF_TRX_TYPE,
       REPLACE(REPLACE(TRANSACTIONS.external_ref_number, CHR(10), ' '),
               CHR(13),
               ' ') AS EXT_REF_NUMBER,  /* EXT REF NO */
       d.full_name account_name,   /* ACC NAME */
       d.accountnumber account_number,   /* ACC NO */
       h.payment_terms_id,   /* payment term id */
       a.is_payment_hold payment_hold,   /* payment hold */
       a.due_date  vb_due_date,  /* vb_due_date */
       a.sales_effective_date  gl_post_date,  /* gl_post_date */
       a.supplier_create_date  vendor_bill_date,  /* vendor_bill_date */
       TO_CHAR(TRANSACTIONS.CREATED_BY_ID) AS CREATED_BY_ID,
       TO_CHAR(TRANSACTIONS.CREATE_DATE, 'YYYY-MM-DD HH24:MI:SS') AS CREATE_DATE,
       TO_CHAR(TRANSACTION_LINES.SUBSIDIARY_ID) AS SUBSIDIARY_ID,
       TO_CHAR(TRANSACTION_LINES.DEPARTMENT_ID) AS DEPARTMENT_ID,
       TO_CHAR(TRANSACTION_LINES.ITEM_ID) AS ITEM_ID,
       TO_CHAR(TRANSACTIONS.LOCATION_ID) AS LOCATION_ID,
       TRANSACTIONS.EXCHANGE_RATE,
       REPLACE(REPLACE(TRANSACTION_ADDRESS.BILL_ADDRESS_LINE_1,
                       CHR(10),
                       ' '),
               CHR(13),
               ' ') AS VENDOR_ADDRESS_LINE_1,
       REPLACE(REPLACE(TRANSACTION_ADDRESS.BILL_ADDRESS_LINE_2,
                       CHR(10),
                       ' '),
               CHR(13),
               ' ') AS VENDOR_ADDRESS_LINE_2,
       REPLACE(REPLACE(TRANSACTION_ADDRESS.BILL_ADDRESS_LINE_3,
                       CHR(10),
                       ' '),
               CHR(13),
               ' ') AS VENDOR_ADDRESS_LINE_3,
       REPLACE(REPLACE(TRANSACTION_ADDRESS.BILL_CITY, CHR(10), ' '),
               CHR(13),
               ' ') AS VENDOR_CITY,
       REPLACE(REPLACE(NVL(g.name,TRANSACTION_ADDRESS.BILL_COUNTRY), CHR(10), ' '),
               CHR(13),
               ' ') AS VENDOR_COUNTRY, 
       REPLACE(REPLACE(TRANSACTION_ADDRESS.BILL_STATE, CHR(10), ' '),
               CHR(13),
               ' ') AS VENDOR_STATE,
       REPLACE(REPLACE(TRANSACTION_ADDRESS.BILL_ZIP, CHR(10), ' '),
               CHR(13),
               ' ') AS VENDOR_ZIP,
       REPLACE(REPLACE(TRANSACTIONS.STATUS, CHR(10), ' '), CHR(13), ' ') AS VRA_STATUS,
       REPLACE(REPLACE(TRANSACTIONS.APPROVAL_STATUS, CHR(10), ' '),
               CHR(13),
               ' ') AS APPROVAL_STATUS,
       TRANSACTION_LINES.ITEM_COUNT AS ITEM_COUNT,
       TRANSACTION_LINES.ITEM_GROSS_AMOUNT AS ITEM_GROSS_AMOUNT,
       TRANSACTION_LINES.AMOUNT AS AMOUNT,
       TRANSACTION_LINES.AMOUNT_FOREIGN AS AMOUNT_FOREIGN,
       TRANSACTION_LINES.NET_AMOUNT AS NET_AMOUNT,
       TRANSACTION_LINES.NET_AMOUNT_FOREIGN AS NET_AMOUNT_FOREIGN,
       TRANSACTION_LINES.GROSS_AMOUNT AS GROSS_AMOUNT,
       TRANSACTION_LINES.ITEM_UNIT_PRICE AS ITEM_UNIT_PRICE,
       F.ITEM_COUNT AS PO_QUANTITY,  /* po QUANTITY */
       F.AMOUNT AS PO_AMOUNT,  /* po AMOUNT */
       TRANSACTION_LINES.QUANTITY_RECEIVED_IN_SHIPMENT AS QUANTITY_SHIPPED,
       /*TRANSACTION_LINES.account_id,*/
       TO_CHAR(TRANSACTION_LINES.date_closed, 'YYYY-MM-DD HH24:MI:SS') AS CLOSE_DATE,
       /*TRANSACTION_LINES.company_id,*/
       TO_CHAR(C.TAX_ITEM_ID) AS TAX_ITEM_ID,
       TRANSACTION_LINES.TRANSACTION_ORDER,
       C.AMOUNT TAX_AMOUNT,
       C.AMOUNT_FOREIGN TAX_AMOUNT_FOREIGN,
       DECODE(CUSTOM_FORM_ID,
              115,
              'Scholastic Vendor Return Authorization',
              198,
              'INTL Vendor Return Authorization') AS VRA_TYPE,
       A.CURRENCY_ID,
       TO_CHAR(A.CUSTOM_FORM_ID) AS CUSTOM_FORM_ID,
       TO_CHAR(B.DATE_LAST_MODIFIED, 'YYYY-MM-DD HH24:MI:SS') AS DATE_LAST_MODIFIED,
       TO_CHAR(A.EMPLOYEE_CUSTOM_ID) AS EMPLOYEE_CUSTOM_ID,
       B.CLASS_ID,
       Decode(d.name,
              'Vendor Return Authorizations',
              'VRA_HDR',
              DECODE(c.transaction_line_id, NULL, 'VRA_TAX', 'VRA_LINE')) AS line_type
  FROM transaction_lines b
 INNER JOIN transactions a
    ON (a.transaction_id = b.transaction_id)
 LEFT OUTER JOIN transactions f 
   ON (a.created_from_id = f.transaction_id )
  LEFT OUTER JOIN accounts d
    ON (TRANSACTION_LINES.account_id = accounts.account_id)
  LEFT OUTER JOIN transaction_address e
    ON (TRANSACTION_LINES.transaction_id =
       transaction_address.transaction_id)
  LEFT OUTER JOIN countries g 
   ON (e.BILL_COUNTRY = g.short_name ) 
  LEFT OUTER JOIN payment_terms h 
   ON (a.payment_terms_id = h.payment_terms_id ) 
  LEFT OUTER JOIN transaction_tax_detail c
    ON (TRANSACTION_LINES.transaction_id =
       transaction_tax_detail.transaction_id AND
       TRANSACTION_LINES.transaction_line_id =
       transaction_tax_detail.transaction_line_id)
 WHERE a.transaction_type = 'Bill'
   AND a.date_last_modified >= '1900-01-01 00:00:00'
   AND b.subsidiary_id = 27
 ORDER BY TRANSACTIONS.transaction_id,
          TRANSACTION_LINES.transaction_line_id;
          