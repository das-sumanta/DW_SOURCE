DROP TABLE if exists dw_prestage.po_fact_insert;

CREATE TABLE dw_prestage.po_fact_insert 
AS
SELECT *
FROM dw_prestage.po_fact
WHERE EXISTS (SELECT 1
FROM (SELECT TRANSACTION_ID, transaction_line_id FROM (SELECT TRANSACTION_ID, transaction_line_id FROM dw_prestage.po_fact MINUS SELECT TRANSACTION_ID, transaction_line_id FROM dw_stage.po_fact)) a
WHERE dw_prestage.po_fact.TRANSACTION_ID = a.TRANSACTION_ID
AND   dw_prestage.po_fact.transaction_line_id = a.transaction_line_id
);

DROP TABLE if exists dw_prestage.po_fact_update;

CREATE TABLE dw_prestage.po_fact_update 
AS
SELECT TRANSACTION_ID,
       transaction_line_id
FROM (SELECT TRANSACTION_ID,
             transaction_line_id
      FROM (SELECT TRANSACTION_ID,
                   transaction_line_id,
                   PO_NUMBER,
                   VENDOR_ID,
                   APPROVER_LEVEL_ONE_ID,
                   APPROVER_LEVEL_TWO_ID,
                   APPROVAL_STATUS,
                   BILLADDRESS,
                   CARRIER,
                   CARRIER_ADDRESS,
                   CARRIER_LEBEL_ID,
                   REQUESTOR_ID,
                   CREATE_DATE,
                   CURRENCY_ID,
                   CUSTOM_FORM_ID,
                   EXCHANGE_RATE,
                   LOCATION_ID,
                   SHIPADDRESS,
                   PO_STATUS,
                   PAYMENT_TERMS_ID,
                   FRIGHT_RATE,
                   PO_TYPE,
                   SUBSIDIARY_ID,
                   DEPARTMENT_ID,
                   ITEM_ID,
                   BC_QUANTITY,
                   BIH_QUANTITY,
                   BOOK_FAIR_QUANTITY,
                   EDUCATION_QUANTITY,
                   NZSO_QUANTITY,
                   TRADE_QUANTITY,
                   SCHOOL_ESSENTIALS_QUANTITY,
                   ITEM_COUNT,
                   ITEM_GROSS_AMOUNT,
                   ITEM_UNIT_PRICE,
                   EXPECTED_RECEIPT_DATE,
                   ACTUAL_DELIVERY_DATE,
                   TAX_ITEM_ID,
                   FREIGHT_ESTIMATE_METHOD_ID,
                   AMOUNT,
                   AMOUNT_FOREIGN,
                   NET_AMOUNT,
                   NET_AMOUNT_FOREIGN,
                   GROSS_AMOUNT,
                   MATCH_BILL_TO_RECEIPT,
                   TRACK_LANDED_COST,
                   TAX_AMOUNT,
                   CLASS_ID
            FROM dw_prestage.po_fact
            MINUS
            SELECT TRANSACTION_ID,
                   transaction_line_id,
                   PO_NUMBER,
                   VENDOR_ID,
                   APPROVER_LEVEL_ONE_ID,
                   APPROVER_LEVEL_TWO_ID,
                   APPROVAL_STATUS,
                   BILLADDRESS,
                   CARRIER,
                   CARRIER_ADDRESS,
                   CARRIER_LEBEL_ID,
                   REQUESTOR_ID,
                   CREATE_DATE,
                   CURRENCY_ID,
                   CUSTOM_FORM_ID,
                   EXCHANGE_RATE,
                   LOCATION_ID,
                   SHIPADDRESS,
                   PO_STATUS,
                   PAYMENT_TERMS_ID,
                   FRIGHT_RATE,
                   PO_TYPE,
                   SUBSIDIARY_ID,
                   DEPARTMENT_ID,
                   ITEM_ID,
                   BC_QUANTITY,
                   BIH_QUANTITY,
                   BOOK_FAIR_QUANTITY,
                   EDUCATION_QUANTITY,
                   NZSO_QUANTITY,
                   TRADE_QUANTITY,
                   SCHOOL_ESSENTIALS_QUANTITY,
                   ITEM_COUNT,
                   ITEM_GROSS_AMOUNT,
                   ITEM_UNIT_PRICE,
                   EXPECTED_RECEIPT_DATE,
                   ACTUAL_DELIVERY_DATE,
                   TAX_ITEM_ID,
                   FREIGHT_ESTIMATE_METHOD_ID,
                   AMOUNT,
                   AMOUNT_FOREIGN,
                   NET_AMOUNT,
                   NET_AMOUNT_FOREIGN,
                   GROSS_AMOUNT,
                   MATCH_BILL_TO_RECEIPT,
                   TRACK_LANDED_COST,
                   TAX_AMOUNT,
                   CLASS_ID
            FROM dw_stage.po_fact)) a
WHERE NOT EXISTS (SELECT 1 FROM dw_prestage.po_fact_insert WHERE dw_prestage.po_fact_insert.TRANSACTION_ID = a.TRANSACTION_ID AND   dw_prestage.po_fact_insert.transaction_line_id = a.transaction_line_id);

DROP TABLE if exists dw_prestage.po_fact_nochange;

CREATE TABLE dw_prestage.po_fact_nochange 
AS
SELECT TRANSACTION_ID,
       transaction_line_id
FROM (SELECT TRANSACTION_ID,
             transaction_line_id
      FROM dw_prestage.po_fact
      MINUS
      (SELECT TRANSACTION_ID,
             transaction_line_id
      FROM dw_prestage.po_fact_insert
      UNION ALL
      SELECT TRANSACTION_ID,
             transaction_line_id
      FROM dw_prestage.po_fact_update));

SELECT 'no of po fact records ingested in staging -->' ||count(1)
FROM dw_prestage.po_fact;

--A
SELECT 'no of po fact records identified to inserted -->' ||count(1)
FROM dw_prestage.po_fact_insert;

--B
SELECT 'no of po fact records identified to updated -->' ||count(1)
FROM dw_prestage.po_fact_update;

--C
SELECT 'no of po fact records identified as no change -->' ||count(1)
FROM dw_prestage.po_fact_nochange;

--D --A = B + C + D
/* delete from stage records to be updated */ 
DELETE
FROM dw_stage.po_fact USING dw_prestage.po_fact_update
WHERE dw_stage.po_fact.transaction_id = dw_prestage.po_fact_update.transaction_id
AND   dw_stage.po_fact.transaction_line_id = dw_prestage.po_fact_update.transaction_line_id;

/* insert into stage records which have been created */ 
INSERT INTO dw_stage.po_fact
SELECT *
FROM dw_prestage.po_fact_insert;

/* insert into stage records which have been updated */ 
INSERT INTO dw_stage.po_fact
SELECT *
FROM dw_prestage.po_fact
WHERE EXISTS (SELECT 1
              FROM dw_prestage.po_fact_update
              WHERE dw_prestage.po_fact_update.transaction_id = dw_prestage.po_fact.transaction_id
              AND   dw_prestage.po_fact_update.transaction_line_id = dw_prestage.po_fact.transaction_line_id);

COMMIT;

/*============================================================process fact records from stage to fact table ========================================================================*/ /* INSERT NEW RECORDS WHICH HAS ALL VALID DIMENSIONS */ 
INSERT INTO dw.po_fact
(
  PO_NUMBER,
  VENDOR_KEY /* DIM 1*/ ,
  REQUESTER_KEY /* DIM 2*/ ,
  APPROVER_LEVEL1_KEY /* DIM 3*/ ,
  APPROVER_LEVEL2_KEY /* DIM 4*/ ,
 /* RECEIVE_BY_DATE_KEY */  /* DIM 4*/ 
  CREATE_DATE_KEY /* DIM 5*/ ,
  SUBSIDIARY_KEY /* DIM 6*/ ,
  LOCATION_KEY /* DIM 7*/ ,
  COST_CENTER_KEY /* DIM 8*/ ,
  ITEM_KEY /* DIM 9*/ ,
 /* VENDOR_ITEM_KEY *//* DIM 10*/ 
  REQUESTED_RECEIPT_DATE_KEY /* DIM 11*/ ,
  ACTUAL_DELIVERY_DATE_KEY /* DIM 12*/ ,
  FREIGHT_ESTIMATE_METHOD_KEY /* DIM 13*/ ,
 /* CARRIER_KEY */ /* DIM 14*/ 
  TERMS_KEY /* DIM 15*/ ,
  TAX_ITEM_KEY /* DIM 16*/ ,
  CURRENCY_KEY /* DIM 17 */ ,
  CLASS_KEY ,
  EXCHANGE_RATE,
  BILLADDRESS,
  SHIPADDRESS,
  QUANTITY,
  BIH_QUANTITY,
  BC_QUANTITY,
  TRADE_QUANTITY,
  NZSO_QUANTITY,
  EDUCATION_QUANTITY,
  SCHOOL_ESSENTIALS_QUANTITY,
  BOOK_FAIR_QUANTITY,
  RATE,
  AMOUNT,
  ITEM_GROSS_AMOUNT,
  AMOUNT_FOREIGN,
  NET_AMOUNT,
  NET_AMOUNT_FOREIGN,
  GROSS_AMOUNT,
  MATCH_BILL_TO_RECEIPT,
  TRACK_LANDED_COST,
  TAX_AMOUNT,
  FREIGHT_RATE,
  PO_TYPE,
  STATUS,
  APPROVAL_STATUS,
  CREATION_DATE,
  LAST_MODIFIED_DATE,
  DATE_ACTIVE_FROM,
  DATE_ACTIVE_TO,
  DW_CURRENT
)
SELECT A.po_number AS po_number,
       B.VENDOR_KEY AS VENDOR_KEY,
       C.EMPLOYEE_KEY AS REQUESTER_KEY,
       D.EMPLOYEE_KEY AS APPROVER_LEVEL1_KEY,
       D1.EMPLOYEE_KEY AS APPROVER_LEVEL2_KEY,
       /*-99 AS RECEIVE_BY_DATE_KEY,*/
       F.DATE_KEY AS CREATE_DATE_KEY,
       G.SUBSIDIARY_KEY AS SUBSIDIARY_KEY,
       L.LOCATION_KEY AS LOCATION_KEY,
       R.DEPARTMENT_KEY AS COST_CENTER_KEY,
       M.ITEM_KEY AS ITEM_KEY,
       /*-99 AS VENDOR_ITEM_KEY,*/
       H.DATE_KEY AS REQUESTED_RECEIPT_DATE_KEY,
       I.DATE_KEY AS ACTUAL_DELIVERY_DATE_KEY,
       J.FREIGHT_KEY AS FREIGHT_ESTIMATE_METHOD_KEY,
       /*-99 AS CARRIER_KEY,*/
       P.PAYMENT_TERM_KEY AS TERMS_KEY,
       Q.TAX_ITEM_KEY AS TAX_ITEM_KEY,
       K.CURRENCY_KEY AS CURRENCY_KEY,
       S.CLASS_KEY AS CLASS_KEY,
       A.EXCHANGE_RATE AS EXCHANGE_RATE,
       A.BILLADDRESS AS BILLADDRESS,
       A.SHIPADDRESS AS SHIPADDRESS,
       A.ITEM_COUNT AS QUANTITY,
       A.BIH_QUANTITY AS BIH_QUANTITY,
       A.BC_QUANTITY AS BC_QUANTITY,
       A.TRADE_QUANTITY AS TRADE_QUANTITY,
       A.NZSO_QUANTITY AS NZSO_QUANTITY,
       A.EDUCATION_QUANTITY AS EDUCATION_QUANTITY,
       A.SCHOOL_ESSENTIALS_QUANTITY AS SCHOOL_ESSENTIALS_QUANTITY,
       A.BOOK_FAIR_QUANTITY AS BOOK_FAIR_QUANTITY,
       A.ITEM_UNIT_PRICE AS RATE,
       A.AMOUNT AS AMOUNT,
       A.ITEM_GROSS_AMOUNT AS ITEM_GROSS_AMOUNT,
       A.AMOUNT_FOREIGN AS AMOUNT_FOREIGN,
       A.NET_AMOUNT AS NET_AMOUNT,
       A.NET_AMOUNT_FOREIGN AS NET_AMOUNT_FOREIGN,
       A.GROSS_AMOUNT AS GROSS_AMOUNT,
       A.MATCH_BILL_TO_RECEIPT as MATCH_BILL_TO_RECEIPT,
       A.TRACK_LANDED_COST as TRACK_LANDED_COST,
       A.TAX_AMOUNT AS TAX_AMOUNT,
       A.FRIGHT_RATE AS FREIGHT_RATE,
       A.PO_TYPE AS PO_TYPE,
       A.PO_STATUS AS STATUS,
       A.APPROVAL_STATUS AS APPROVAL_STATUS,
       A.CREATE_DATE AS CREATION_DATE,
       A.DATE_LAST_MODIFIED AS LAST_MODIFIED_DATE,
       SYSDATE AS DATE_ACTIVE_FROM,
       '9999-12-31 11:59:59' AS DATE_ACTIVE_TO,
       1 AS DW_CURRENT
FROM dw_prestage.po_fact_insert A
  INNER JOIN DW.VENDORS B ON (NVL (A.VENDOR_ID,-99) = B.VENDOR_ID) /* DIM 1*/ 
  INNER JOIN DW.EMPLOYEES C ON (NVL (A.REQUESTOR_ID,-99) = C.EMPLOYEE_ID) /* DIM 2*/ 
  INNER JOIN DW.EMPLOYEES D ON (NVL (A.APPROVER_LEVEL_ONE_ID,-99) = D.EMPLOYEE_ID) /* DIM 3*/ 
  INNER JOIN DW.EMPLOYEES D1 ON (NVL (A.APPROVER_LEVEL_TWO_ID,-99) = D1.EMPLOYEE_ID) /* DIM 3*/ 
  INNER JOIN DW.DWDATE F ON (NVL (TO_CHAR (A.CREATE_DATE,'YYYYMMDD'),'0') = F.DATE_ID) /* DIM 5*/ 
  INNER JOIN DW.SUBSIDIARIES G ON (NVL (A.SUBSIDIARY_ID,-99) = G.SUBSIDIARY_ID) /* DIM 6*/ 
  INNER JOIN DW.DWDATE H ON (NVL (TO_CHAR (A.EXPECTED_RECEIPT_DATE,'YYYYMMDD'),'0') = H.DATE_ID) /* DIM 11*/ 
  INNER JOIN DW.DWDATE I ON (NVL (TO_CHAR (A.ACTUAL_DELIVERY_DATE,'YYYYMMDD'),'0') = I.DATE_ID) /* DIM 12*/ 
  INNER JOIN DW.FREIGHT_ESTIMATE J ON (NVL (A.FREIGHT_ESTIMATE_METHOD_ID,-99) = J.LANDED_COST_RULE_MATRIX_NZ_ID) /* DIM 12*/ 
  INNER JOIN DW.CURRENCIES K ON (NVL (A.CURRENCY_ID,-99) = K.CURRENCY_ID)
  INNER JOIN DW.LOCATIONS L ON (NVL (A.LOCATION_ID,-99) = L.LOCATION_ID)
  INNER JOIN DW.ITEMS M ON (NVL (A.ITEM_ID,-99) = M.ITEM_ID)
  INNER JOIN DW.PAYMENT_TERMS P ON (NVL (A.PAYMENT_TERMS_ID,-99) = P.PAYMENT_TERMS_ID)
  INNER JOIN DW.TAX_ITEMS Q ON (NVL (A.TAX_ITEM_ID,-99) = Q.ITEM_ID)
  INNER JOIN DW.COST_CENTER R ON (NVL(A.DEPARTMENT_ID,-99) = R.DEPARTMENT_ID)
  INNER JOIN DW.CLASSES S ON (NVL(A.CLASS_ID,-99) = S.CLASS_ID)
  WHERE A.LINE_TYPE = 'PO_LINE';
  
/* =================================================INSERT NEW RECORDS IN ERROR TABLE WHICH DOES NOT HAVE VALID DIMENSIONS======================================================== */ 
INSERT INTO dw.po_fact_error
(
  PO_NUMBER,
  VENDOR_KEY /* DIM 1*/ ,
  REQUESTER_KEY /* DIM 2*/ ,
  APPROVER_KEY /* DIM 3*/ ,
  RECEIVE_BY_DATE_KEY /* DIM 4*/ --?           
                                 ,
  CREATE_DATE_KEY /* DIM 5*/ ,
  SUBSIDIARY_KEY /* DIM 6*/ ,
  LOCATION_KEY /* DIM 7*/ ,
  COST_CENTER_KEY /* DIM 8*/ ,
  ITEM_KEY /* DIM 9*/ ,
  VENDOR_ITEM_KEY /* DIM 10*/ ,
  REQUESTED_RECEIPT_DATE_KEY /* DIM 11*/ ,
  ACTUAL_DELIVERY_DATE_KEY /* DIM 12*/ ,
  FREIGHT_ESTIMATE_METHOD_KEY /* DIM 13*/ ,
  CARRIER_KEY /* DIM 14*/ ,
  TERMS_KEY /* DIM 15*/ ,
  TAX_ITEM_KEY /* DIM 16*/ ,
  CURRENCY_KEY /* DIM 17 */ ,
  EXCHANGE_RATE,
  BILLADDRESS,
  SHIPADDRESS,
  QUANTITY,
  BIH_QUANTITY,
  BC_QUANTITY,
  TRADE_QUANTITY,
  NZSO_QUANTITY,
  EDUCATION_QUANTITY,
  SCHOOL_ESSENTIALS_QUANTITY,
  BOOK_FAIR_QUANTITY,
  RATE,
  ITEM_GROSS_AMOUNT,
  TAX_AMOUNT,
  FREIGHT_RATE,
  PO_TYPE,
  STATUS,
  CREATION_DATE,
  LAST_MODIFIED_DATE,
  VALID_TILL_DATE,
  ACTIVE
)
SELECT A.po_number AS po_number,
       B.VENDOR_KEY AS VENDOR_KEY,
       A.VENDOR_ID,
       C.EMPLOYEE_KEY AS REQUESTER_KEY,
       A.CREATED_BY_ID,
       D.EMPLOYEE_KEY AS APPROVER_KEY,
       A.APPROVER_LEVEL_ONE_ID,
       F.DATE_KEY AS CREATE_DATE_KEY,
       A.CREATE_DATE,
       G.SUBSIDIARY_KEY AS SUBSIDIARY_KEY,
       A.SUBSIDIARY_ID,
       -99 AS LOCATION_KEY,
       A.LOCATION_ID,
       -99 AS COST_CENTER_KEY,
       A.COST_CENTER_ID,
       -99 AS ITEM_KEY,
       A.ITEM_ID,
       -99 AS VENDOR_ITEM_KEY,
       A.VENDOR_ITEM_ID,
       H.DATE_KEY AS REQUESTED_RECEIPT_DATE_KEY,
       A.EXPECTED_RECEIPT_DATE,
       I.DATE_KEY AS ACTUAL_DELIVERY_DATE_KEY,
       A.ACTUAL_DELIVERY_DATE,
       J.FREIGHT_KEY AS FREIGHT_ESTIMATE_METHOD_KEY,
       A.FREIGHT_ESTIMATE_METHOD_ID,
       -99 AS CARRIER_KEY,
       A.CARRIER_ID,
       -99 AS TERMS_KEY,
       A.TERMS_ID,
       -99 AS TAX_ITEM_KEY,
       A.TAX_ITEM_ID,
       K.CURRENCY_KEY AS CURRENCY_KEY,
       A.CURRENCY_ID,
       A.EXCHANGE_RATE AS EXCHANGE_RATE,
       A.BILLADDRESS AS BILLADDRESS,
       A.SHIPADDRESS AS SHIPADDRESS,
       A.ITEM_COUNT AS QUANTITY,
       A.BIH_QUANTITY AS BIH_QUANTITY,
       A.BC_QUANTITY AS BC_QUANTITY,
       A.TRADE_QUANTITY AS TRADE_QUANTITY,
       A.NZSO_QUANTITY AS NZSO_QUANTITY,
       A.EDUCATION_QUANTITY AS EDUCATION_QUANTITY,
       A.SCHOOL_ESSENTIALS_QUANTITY AS SCHOOL_ESSENTIALS_QUANTITY,
       A.BOOK_FAIR_QUANTITY AS BOOK_FAIR_QUANTITY,
       A.ITEM_UNIT_PRICE AS RATE,
       A.ITEM_GROSS_AMOUNT AS ITEM_GROSS_AMOUNT,
       A.TAX_AMOUNT AS TAX_AMOUNT,
       A.FRIGHT_RATE AS FREIGHT_RATE,
       A.PO_TYPE AS PO_TYPE,
       A.PO_STATUS AS STATUS,
       A.CREATE_DATE AS CREATION_DATE,
       A.DATE_LAST_MODIFIED AS LAST_MODIFIED_DATE,
       SYSDATE AS DW_CREATION_DATE,
       'E' AS RECORD_STATUS
FROM dw_prestage.po_fact_insert A
  LEFT OUTER JOIN DW.VENDORS B ON (NVL (A.VENDOR_ID,-99) = B.VENDOR_ID) /* DIM 1*/ 
  LEFT OUTER JOIN DW.EMPLOYEES C ON (NVL (A.CREATED_BY_ID,-99) = C.EMPLOYEE_ID) /* DIM 2*/ 
  LEFT OUTER JOIN DW.EMPLOYEES D ON (NVL (A.APPROVER_LEVEL_ONE_ID,-99) = D.EMPLOYEE_ID) /* DIM 3*/ 
  LEFT OUTER JOIN DW.DWDATE F ON (NVL (TO_CHAR (A.CREATE_DATE,'YYYYMMDD'),'0') = F.DATE_ID) /* DIM 5*/ 
  LEFT OUTER JOIN DW.SUBSIDIARIES G ON (NVL (A.SUBSIDIARY_ID,-99) = G.SUBSIDIARY_ID) /* DIM 6*/ 
  LEFT OUTER JOIN DW.DWDATE H ON (NVL (TO_CHAR (A.EXPECTED_RECEIPT_DATE,'YYYYMMDD'),'0') = H.DATE_ID) /* DIM 11*/ 
  LEFT OUTER JOIN DW.DWDATE I ON (NVL (TO_CHAR (A.ACTUAL_DELIVERY_DATE,'YYYYMMDD'),'0') = I.DATE_ID) /* DIM 12*/ 
  LEFT OUTER JOIN DW.FREIGHT_ESTIMATE J ON (NVL (A.FREIGHT_ESTIMATE_METHOD_ID,-99) = J.LANDED_COST_RULE_MATRIX_NZ_ID) /* DIM 12*/ 
  LEFT OUTER JOIN DW.CURRENCIES K ON (NVL (A.CURRENCY_ID,-99) = K.CURRENCY_ID)
WHERE A.LINE_TYPE = 'PO_LINE'
AND   (B.VENDOR_KEY IS NULL OR C.EMPLOYEE_KEY IS NULL OR D.EMPLOYEE_KEY IS NULL OR F.DATE_KEY IS NULL OR G.SUBSIDIARY_KEY IS NULL OR< LOCATION_ID > IS NULL OR< COST CENTER > IS NULL OR< ITEM > IS NULL OR< VENDOR ITEM > IS NULL OR H.DATE_KEY IS NULL OR I.DATE_KEY IS NULL OR J.FREIGHT_KEY IS NULL OR< CARRIER > IS NULL OR< TERMS > IS NULL OR< TAX ITEM > IS NULL OR K.CURRENCY_KEY IS NULL) /* =======================================================UPDATE THE OLD RECORDS SETTING THE CURRENT FLAG VALUE TO 0 ================================================================*/  UPDATE dw.po_fact SET dw_current = 0,DATE_ACTIVE_TO = (sysdate -1) WHERE dw_current = 1
AND   sysdate>= date_active_from
AND   sysdate< date_active_to
AND   EXISTS (SELECT 1 FROM dw_prestage.po_fact_update WHERE dw.po_fact.transaction_id = dw_prestage.po_fact_update.transaction_id AND   dw.po_fact.transaction_line_id = dw_prestage.po_fact_update.transaction_line_id);

/*=========================================================NOW INSERT THE FACT RECORDS WHICH HAVE BEEN UPDATED AT THE SOURCE ========================================================*/ 
INSERT INTO dw.po_fact
(
  PO_NUMBER,
  VENDOR_KEY /* DIM 1*/ ,
  REQUESTER_KEY /* DIM 2*/ ,
  APPROVER_KEY /* DIM 3*/ ,
  RECEIVE_BY_DATE_KEY /* DIM 4*/ --?           
                                 ,
  CREATE_DATE_KEY /* DIM 5*/ ,
  SUBSIDIARY_KEY /* DIM 6*/ ,
  LOCATION_KEY /* DIM 7*/ ,
  COST_CENTER_KEY /* DIM 8*/ ,
  ITEM_KEY /* DIM 9*/ ,
  VENDOR_ITEM_KEY /* DIM 10*/ ,
  REQUESTED_RECEIPT_DATE_KEY /* DIM 11*/ ,
  ACTUAL_DELIVERY_DATE_KEY /* DIM 12*/ ,
  FREIGHT_ESTIMATE_METHOD_KEY /* DIM 13*/ ,
  CARRIER_KEY /* DIM 14*/ ,
  TERMS_KEY /* DIM 15*/ ,
  TAX_ITEM_KEY /* DIM 16*/ ,
  CURRENCY_KEY /* DIM 17 */ ,
  EXCHANGE_RATE,
  BILLADDRESS,
  SHIPADDRESS,
  QUANTITY,
  BIH_QUANTITY,
  BC_QUANTITY,
  TRADE_QUANTITY,
  NZSO_QUANTITY,
  EDUCATION_QUANTITY,
  SCHOOL_ESSENTIALS_QUANTITY,
  BOOK_FAIR_QUANTITY,
  RATE,
  ITEM_GROSS_AMOUNT,
  TAX_AMOUNT,
  FREIGHT_RATE,
  PO_TYPE,
  STATUS,
  CREATION_DATE,
  LAST_MODIFIED_DATE,
  VALID_TILL_DATE,
  ACTIVE
)
SELECT A.po_number AS po_number,
       B.VENDOR_KEY AS VENDOR_KEY,
       C.EMPLOYEE_KEY AS REQUESTER_KEY,
       D.EMPLOYEE_KEY AS APPROVER_KEY,
       F.DATE_KEY AS CREATE_DATE_KEY,
       G.SUBSIDIARY_KEY AS SUBSIDIARY_KEY,
       -99 AS LOCATION_KEY,
       -99 AS COST_CENTER_KEY,
       -99 AS ITEM_KEY,
       -99 AS VENDOR_ITEM_KEY,
       H.DATE_KEY AS REQUESTED_RECEIPT_DATE_KEY,
       I.DATE_KEY AS ACTUAL_DELIVERY_DATE_KEY,
       J.FREIGHT_KEY AS FREIGHT_ESTIMATE_METHOD_KEY,
       -99 AS CARRIER_KEY,
       -99 AS TERMS_KEY,
       -99 AS TAX_ITEM_KEY,
       K.CURRENCY_KEY AS CURRENCY_KEY,
       A.EXCHANGE_RATE AS EXCHANGE_RATE,
       A.BILLADDRESS AS BILLADDRESS,
       A.SHIPADDRESS AS SHIPADDRESS,
       A.ITEM_COUNT AS QUANTITY,
       A.BIH_QUANTITY AS BIH_QUANTITY,
       A.BC_QUANTITY AS BC_QUANTITY,
       A.TRADE_QUANTITY AS TRADE_QUANTITY,
       A.NZSO_QUANTITY AS NZSO_QUANTITY,
       A.EDUCATION_QUANTITY AS EDUCATION_QUANTITY,
       A.SCHOOL_ESSENTIALS_QUANTITY AS SCHOOL_ESSENTIALS_QUANTITY,
       A.BOOK_FAIR_QUANTITY AS BOOK_FAIR_QUANTITY,
       A.ITEM_UNIT_PRICE AS RATE,
       A.ITEM_GROSS_AMOUNT AS ITEM_GROSS_AMOUNT,
       A.TAX_AMOUNT AS TAX_AMOUNT,
       A.FRIGHT_RATE AS FREIGHT_RATE,
       A.PO_TYPE AS PO_TYPE,
       A.PO_STATUS AS STATUS,
       A.CREATE_DATE AS CREATION_DATE,
       A.DATE_LAST_MODIFIED AS LAST_MODIFIED_DATE,
       SYSDATE AS DATE_ACTIVE_FROM,
       '9999-12-31 11:59:59' AS DATE_ACTIVE_FROM,
       1 AS DW_CURRENT
FROM dw_prestage.po_fact A
  INNER JOIN DW.VENDORS B ON (NVL (A.VENDOR_ID,-99) = B.VENDOR_ID) /* DIM 1*/ 
  INNER JOIN DW.EMPLOYEES C ON (NVL (A.CREATED_BY_ID,-99) = C.EMPLOYEE_ID) /* DIM 2*/ 
  INNER JOIN DW.EMPLOYEES D ON (NVL (A.APPROVER_LEVEL_ONE_ID,-99) = D.EMPLOYEE_ID) /* DIM 3*/ 
  INNER JOIN DW.DWDATE F ON (NVL (TO_CHAR (A.CREATE_DATE,'YYYYMMDD'),'0') = F.DATE_ID) /* DIM 5*/ 
  INNER JOIN DW.SUBSIDIARIES G ON (NVL (A.SUBSIDIARY_ID,-99) = G.SUBSIDIARY_ID) /* DIM 6*/ 
  INNER JOIN DW.DWDATE H ON (NVL (TO_CHAR (A.EXPECTED_RECEIPT_DATE,'YYYYMMDD'),'0') = H.DATE_ID) /* DIM 11*/ 
  INNER JOIN DW.DWDATE I ON (NVL (TO_CHAR (A.ACTUAL_DELIVERY_DATE,'YYYYMMDD'),'0') = I.DATE_ID) /* DIM 12*/ 
  INNER JOIN DW.FREIGHT_ESTIMATE J ON (NVL (A.FREIGHT_ESTIMATE_METHOD_ID,-99) = J.LANDED_COST_RULE_MATRIX_NZ_ID) /* DIM 12*/ 
  INNER JOIN DW.CURRENCIES K ON (NVL (A.CURRENCY_ID,-99) = K.CURRENCY_ID)
WHERE A.LINE_TYPE = 'PO_LINE'
AND   EXISTS (SELECT 1 FROM dw_prestage.po_fact_update WHERE a.transaction_id = dw_prestage.po_fact_update.transaction_id AND   a.transaction_line_id = dw_prestage.po_fact_update.transaction_line_id);

/* ================================================INSERT UPDATED RECORDS IN ERROR TABLE WHICH DOES NOT HAVE VALID DIMENSIONS======================================================== */ 
INSERT INTO dw.po_fact_error
(
  PO_NUMBER,
  VENDOR_KEY /* DIM 1*/ ,
  REQUESTER_KEY /* DIM 2*/ ,
  APPROVER_KEY /* DIM 3*/ ,
  RECEIVE_BY_DATE_KEY /* DIM 4*/ --?           
                                 ,
  CREATE_DATE_KEY /* DIM 5*/ ,
  SUBSIDIARY_KEY /* DIM 6*/ ,
  LOCATION_KEY /* DIM 7*/ ,
  COST_CENTER_KEY /* DIM 8*/ ,
  ITEM_KEY /* DIM 9*/ ,
  VENDOR_ITEM_KEY /* DIM 10*/ ,
  REQUESTED_RECEIPT_DATE_KEY /* DIM 11*/ ,
  ACTUAL_DELIVERY_DATE_KEY /* DIM 12*/ ,
  FREIGHT_ESTIMATE_METHOD_KEY /* DIM 13*/ ,
  CARRIER_KEY /* DIM 14*/ ,
  TERMS_KEY /* DIM 15*/ ,
  TAX_ITEM_KEY /* DIM 16*/ ,
  CURRENCY_KEY /* DIM 17 */ ,
  EXCHANGE_RATE,
  BILLADDRESS,
  SHIPADDRESS,
  QUANTITY,
  BIH_QUANTITY,
  BC_QUANTITY,
  TRADE_QUANTITY,
  NZSO_QUANTITY,
  EDUCATION_QUANTITY,
  SCHOOL_ESSENTIALS_QUANTITY,
  BOOK_FAIR_QUANTITY,
  RATE,
  ITEM_GROSS_AMOUNT,
  TAX_AMOUNT,
  FREIGHT_RATE,
  PO_TYPE,
  STATUS,
  CREATION_DATE,
  LAST_MODIFIED_DATE,
  VALID_TILL_DATE,
  ACTIVE
)
SELECT A.po_number AS po_number,
       B.VENDOR_KEY AS VENDOR_KEY,
       A.VENDOR_ID,
       C.EMPLOYEE_KEY AS REQUESTER_KEY,
       A.CREATED_BY_ID,
       D.EMPLOYEE_KEY AS APPROVER_KEY,
       A.APPROVER_LEVEL_ONE_ID,
       F.DATE_KEY AS CREATE_DATE_KEY,
       A.CREATE_DATE,
       G.SUBSIDIARY_KEY AS SUBSIDIARY_KEY,
       A.SUBSIDIARY_ID,
       -99 AS LOCATION_KEY,
       A.LOCATION_ID,
       -99 AS COST_CENTER_KEY,
       A.DEPARTMENT_ID,
       -99 AS ITEM_KEY,
       A.ITEM_ID,
       
--       -99 AS VENDOR_ITEM_KEY,
--       A.VENDOR_ITEM_ID,
H.DATE_KEY AS REQUESTED_RECEIPT_DATE_KEY,
       A.EXPECTED_RECEIPT_DATE,
       I.DATE_KEY AS ACTUAL_DELIVERY_DATE_KEY,
       A.ACTUAL_DELIVERY_DATE,
       J.FREIGHT_KEY AS FREIGHT_ESTIMATE_METHOD_KEY,
       A.FREIGHT_ESTIMATE_METHOD_ID,
       -99 AS CARRIER_KEY,
       
--       A.CARRIER_ID,
-99 AS TERMS_KEY,
       
--       A.TERMS_ID,
-99 AS TAX_ITEM_KEY,
       A.TAX_ITEM_ID,
       K.CURRENCY_KEY AS CURRENCY_KEY,
       A.CURRENCY_ID,
       A.EXCHANGE_RATE AS EXCHANGE_RATE,
       A.BILLADDRESS AS BILLADDRESS,
       A.SHIPADDRESS AS SHIPADDRESS,
       A.ITEM_COUNT AS QUANTITY,
       A.BIH_QUANTITY AS BIH_QUANTITY,
       A.BC_QUANTITY AS BC_QUANTITY,
       A.TRADE_QUANTITY AS TRADE_QUANTITY,
       A.NZSO_QUANTITY AS NZSO_QUANTITY,
       A.EDUCATION_QUANTITY AS EDUCATION_QUANTITY,
       A.SCHOOL_ESSENTIALS_QUANTITY AS SCHOOL_ESSENTIALS_QUANTITY,
       A.BOOK_FAIR_QUANTITY AS BOOK_FAIR_QUANTITY,
       A.ITEM_UNIT_PRICE AS RATE,
       A.ITEM_GROSS_AMOUNT AS ITEM_GROSS_AMOUNT,
       
--       A.TAX_AMOUNT AS TAX_AMOUNT,
A.FRIGHT_RATE AS FREIGHT_RATE,
       A.PO_TYPE AS PO_TYPE,
       A.PO_STATUS AS STATUS,
       A.CREATE_DATE AS CREATION_DATE,
       A.DATE_LAST_MODIFIED AS LAST_MODIFIED_DATE,
       SYSDATE AS DW_CREATION_DATE,
       'E' AS RECORD_STATUS
FROM dw_prestage.po_fact A
  LEFT OUTER JOIN DW.VENDORS B ON (NVL (A.VENDOR_ID,-99) = B.VENDOR_ID) /* DIM 1*/ 
  LEFT OUTER JOIN DW.EMPLOYEES C ON (NVL (A.CREATED_BY_ID,-99) = C.EMPLOYEE_ID) /* DIM 2*/ 
  LEFT OUTER JOIN DW.EMPLOYEES D ON (NVL (A.APPROVER_LEVEL_ONE_ID,-99) = D.EMPLOYEE_ID) /* DIM 3*/ 
  LEFT OUTER JOIN DW.DWDATE F ON (NVL (TO_CHAR (A.CREATE_DATE,'YYYYMMDD'),'0') = F.DATE_ID) /* DIM 5*/ 
  LEFT OUTER JOIN DW.SUBSIDIARIES G ON (NVL (A.SUBSIDIARY_ID,-99) = G.SUBSIDIARY_ID) /* DIM 6*/ 
  LEFT OUTER JOIN DW.DWDATE H ON (NVL (TO_CHAR (A.EXPECTED_RECEIPT_DATE,'YYYYMMDD'),'0') = H.DATE_ID) /* DIM 11*/ 
  LEFT OUTER JOIN DW.DWDATE I ON (NVL (TO_CHAR (A.ACTUAL_DELIVERY_DATE,'YYYYMMDD'),'0') = I.DATE_ID) /* DIM 12*/ 
  LEFT OUTER JOIN DW.FREIGHT_ESTIMATE J ON (NVL (A.FREIGHT_ESTIMATE_METHOD_ID,-99) = J.LANDED_COST_RULE_MATRIX_NZ_ID) /* DIM 12*/ 
  LEFT OUTER JOIN DW.CURRENCIES K ON (NVL (A.CURRENCY_ID,-99) = K.CURRENCY_ID)
WHERE A.LINE_TYPE = 'PO_LINE'
AND   EXISTS (SELECT 1 FROM dw_prestage.po_fact_update WHERE a.transaction_id = dw_prestage.po_fact_update.transaction_id AND   a.transaction_line_id = dw_prestage.po_fact_update.transaction_line_id)
AND   (B.VENDOR_KEY IS NULL OR C.EMPLOYEE_KEY IS NULL OR D.EMPLOYEE_KEY IS NULL OR F.DATE_KEY IS NULL OR G.SUBSIDIARY_KEY IS NULL OR< LOCATION_ID > IS NULL OR< COST CENTER > IS NULL OR< ITEM > IS NULL OR< VENDOR ITEM > IS NULL OR H.DATE_KEY IS NULL OR I.DATE_KEY IS NULL OR J.FREIGHT_KEY IS NULL OR< CARRIER > IS NULL OR< TERMS > IS NULL OR< TAX ITEM > IS NULL OR K.CURRENCY_KEY IS NULL);