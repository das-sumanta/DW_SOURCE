/* prestage - drop intermediate insert table */ 
DROP TABLE if exists dw_prestage.po_fact_insert;

/* prestage - create intermediate insert table*/ 
CREATE TABLE dw_prestage.po_fact_insert 
AS
SELECT a.*
FROM dw_prestage.po_fact a
WHERE not exists ( select 1 FROM dw_stage.po_fact b
where a.TRANSACTION_ID = b.TRANSACTION_ID
AND   a.transaction_line_id = b.transaction_line_id
AND   a.subsidiary_id = b.subsidiary_id);

/* prestage - drop intermediate update table*/ 
DROP TABLE if exists dw_prestage.po_fact_update;

/* prestage - create intermediate update table*/ 
CREATE TABLE dw_prestage.po_fact_update 
AS
SELECT TRANSACTION_ID,
       transaction_line_id,
	   subsidiary_id
FROM (SELECT TRANSACTION_ID,
             transaction_line_id,
			 subsidiary_id
      FROM (SELECT TRANSACTION_ID,
                   transaction_line_id,
                   REF_TRX_NUMBER,
                   REF_CUSTOM_FORM_ID,
                   PO_NUMBER,
                   VENDOR_ID,
                   APPROVER_LEVEL_ONE_ID,
                   APPROVER_LEVEL_TWO_ID,
                   APPROVAL_STATUS,
                   BILL_ADDRESS_LINE_1,
                   BILL_ADDRESS_LINE_2,
                   BILL_ADDRESS_LINE_3,
                   BILL_CITY,
                   BILL_COUNTRY,
                   BILL_STATE,
                   BILL_ZIP,
                   CARRIER_ID,
                   REQUESTOR_ID,
                   CREATE_DATE,
                   CURRENCY_ID,
                   CUSTOM_FORM_ID,
                   EXCHANGE_RATE,
                   LOCATION_ID,
                   SHIP_ADDRESS_LINE_1,
                   SHIP_ADDRESS_LINE_2,
                   SHIP_ADDRESS_LINE_3,
                   SHIP_CITY,
                   SHIP_COUNTRY,
                   SHIP_STATE,
                   SHIP_ZIP,
                   PO_STATUS,
                   PAYMENT_TERMS_ID,
                   FRIGHT_RATE,
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
                   NUMBER_BILLED,
                   QUANTITY_RECEIVED_IN_SHIPMENT,
                   QUANTITY_RETURNED,
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
            FROM dw_prestage.po_fact A2
			WHERE NOT EXISTS ( SELECT 1 FROM DW_PRESTAGE.PO_FACT_INSERT B2
                  WHERE B2.TRANSACTION_ID = A2.TRANSACTION_ID
                  AND B2.TRANSACTION_LINE_ID = A2.TRANSACTION_LINE_ID 
                  AND   A2.SUBSIDIARY_ID = B2.SUBSIDIARY_ID)
            MINUS
            SELECT TRANSACTION_ID,
                   transaction_line_id,
                   REF_TRX_NUMBER,
                   REF_CUSTOM_FORM_ID,
                   PO_NUMBER,
                   VENDOR_ID,
                   APPROVER_LEVEL_ONE_ID,
                   APPROVER_LEVEL_TWO_ID,
                   APPROVAL_STATUS,
                   BILL_ADDRESS_LINE_1,
                   BILL_ADDRESS_LINE_2,
                   BILL_ADDRESS_LINE_3,
                   BILL_CITY,
                   BILL_COUNTRY,
                   BILL_STATE,
                   BILL_ZIP,
                   CARRIER_ID,
                   REQUESTOR_ID,
                   CREATE_DATE,
                   CURRENCY_ID,
                   CUSTOM_FORM_ID,
                   EXCHANGE_RATE,
                   LOCATION_ID,
                   SHIP_ADDRESS_LINE_1,
                   SHIP_ADDRESS_LINE_2,
                   SHIP_ADDRESS_LINE_3,
                   SHIP_CITY,
                   SHIP_COUNTRY,
                   SHIP_STATE,
                   SHIP_ZIP,
                   PO_STATUS,
                   PAYMENT_TERMS_ID,
                   FRIGHT_RATE,
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
                   NUMBER_BILLED,
                   QUANTITY_RECEIVED_IN_SHIPMENT,
                   QUANTITY_RETURNED,
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
            FROM dw_stage.po_fact a1
			WHERE EXISTS ( select 1 from dw_prestage.PO_fact b1
     where b1.TRANSACTION_ID = a1.TRANSACTION_ID
     and b1.transaction_line_id = a1.transaction_line_id 
     AND   a1.subsidiary_id = b1.subsidiary_id))) a
WHERE NOT EXISTS (SELECT 1
                  FROM dw_prestage.po_fact_insert
                  WHERE dw_prestage.po_fact_insert.TRANSACTION_ID = a.TRANSACTION_ID
                  AND   dw_prestage.po_fact_insert.transaction_line_id = a.transaction_line_id);

/* prestage - drop intermediate no change track table*/ 
DROP TABLE if exists dw_prestage.po_fact_nochange;

/* prestage - create intermediate no change track table*/ 
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

/* prestage-> no of po fact records ingested in staging*/ 
SELECT count(1) FROM dw_prestage.po_fact;

/* prestage-> no of po fact records identified to inserted */ 
SELECT  count(1) FROM dw_prestage.po_fact_insert;

/* prestage-> no of po fact records identified to updated*/ 
SELECT count(1) FROM dw_prestage.po_fact_update;

/* prestage-> no of po fact records identified as no change*/ 
SELECT count(1) FROM dw_prestage.po_fact_nochange;

/* stage -> delete from stage records to be updated */ 
DELETE
FROM dw_stage.po_fact USING dw_prestage.po_fact_update
WHERE dw_stage.po_fact.transaction_id = dw_prestage.po_fact_update.transaction_id
AND   dw_stage.po_fact.transaction_line_id = dw_prestage.po_fact_update.transaction_line_id
AND   dw_stage.po_fact.subsidiary_id = dw_prestage.po_fact_update.subsidiary_id;

/* stage -> insert into stage records which have been created */ 
INSERT INTO dw_stage.po_fact(
 RUNID
,TRANSACTION_ID
,PO_NUMBER
,TRANSACTION_LINE_ID
,REF_TRX_NUMBER
,REF_CUSTOM_FORM_ID
,VENDOR_ID
,APPROVER_LEVEL_ONE_ID
,APPROVER_LEVEL_TWO_ID
,AMOUNT_UNBILLED
,APPROVAL_STATUS
,BILL_ADDRESS_LINE_1
,BILL_ADDRESS_LINE_2
,BILL_ADDRESS_LINE_3
,BILL_CITY
,BILL_COUNTRY
,BILL_STATE
,BILL_ZIP
,CARRIER_ID
,CLOSED
,CREATED_BY_ID
,REQUESTOR_ID
,CREATED_FROM_ID
,CREATE_DATE
,CURRENCY_ID
,CUSTOM_FORM_ID
,DATE_LAST_MODIFIED
,EMPLOYEE_CUSTOM_ID
,EXCHANGE_RATE
,LOCATION_ID
,PO_APPROVER_ID
,SHIP_ADDRESS_LINE_1
,SHIP_ADDRESS_LINE_2
,SHIP_ADDRESS_LINE_3
,SHIP_CITY
,SHIP_COUNTRY
,SHIP_STATE
,SHIP_ZIP
,SHIPMENT_RECEIVED
,PO_STATUS
,PAYMENT_TERMS_ID
,FRIGHT_RATE
,SUBSIDIARY_ID
,DEPARTMENT_ID
,ITEM_ID
,BC_QUANTITY
,BIH_QUANTITY
,BOOK_FAIR_QUANTITY
,EDUCATION_QUANTITY
,NZSO_QUANTITY
,TRADE_QUANTITY
,SCHOOL_ESSENTIALS_QUANTITY
,ITEM_COUNT
,ITEM_GROSS_AMOUNT
,AMOUNT
,AMOUNT_FOREIGN
,NET_AMOUNT
,NET_AMOUNT_FOREIGN
,GROSS_AMOUNT
,MATCH_BILL_TO_RECEIPT
,TRACK_LANDED_COST
,ITEM_UNIT_PRICE
,NUMBER_BILLED
,QUANTITY_RECEIVED_IN_SHIPMENT
,QUANTITY_RETURNED
,EXPECTED_RECEIPT_DATE
,ACTUAL_DELIVERY_DATE
,TAX_ITEM_ID
,TAX_TYPE
,TAX_AMOUNT
,FREIGHT_ESTIMATE_METHOD_ID
,LINE_TYPE
,CLASS_ID
)
SELECT
RUNID
,TRANSACTION_ID
,PO_NUMBER
,TRANSACTION_LINE_ID
,REF_TRX_NUMBER
,REF_CUSTOM_FORM_ID
,VENDOR_ID
,APPROVER_LEVEL_ONE_ID
,APPROVER_LEVEL_TWO_ID
,AMOUNT_UNBILLED
,APPROVAL_STATUS
,BILL_ADDRESS_LINE_1
,BILL_ADDRESS_LINE_2
,BILL_ADDRESS_LINE_3
,BILL_CITY
,BILL_COUNTRY
,BILL_STATE
,BILL_ZIP
,CARRIER_ID
,CLOSED
,CREATED_BY_ID
,REQUESTOR_ID
,CREATED_FROM_ID
,CREATE_DATE
,CURRENCY_ID
,CUSTOM_FORM_ID
,DATE_LAST_MODIFIED
,EMPLOYEE_CUSTOM_ID
,EXCHANGE_RATE
,LOCATION_ID
,PO_APPROVER_ID
,SHIP_ADDRESS_LINE_1
,SHIP_ADDRESS_LINE_2
,SHIP_ADDRESS_LINE_3
,SHIP_CITY
,SHIP_COUNTRY
,SHIP_STATE
,SHIP_ZIP
,SHIPMENT_RECEIVED
,PO_STATUS
,PAYMENT_TERMS_ID
,FRIGHT_RATE
,SUBSIDIARY_ID
,DEPARTMENT_ID
,ITEM_ID
,BC_QUANTITY
,BIH_QUANTITY
,BOOK_FAIR_QUANTITY
,EDUCATION_QUANTITY
,NZSO_QUANTITY
,TRADE_QUANTITY
,SCHOOL_ESSENTIALS_QUANTITY
,ITEM_COUNT
,ITEM_GROSS_AMOUNT
,AMOUNT
,AMOUNT_FOREIGN
,NET_AMOUNT
,NET_AMOUNT_FOREIGN
,GROSS_AMOUNT
,MATCH_BILL_TO_RECEIPT
,TRACK_LANDED_COST
,ITEM_UNIT_PRICE
,NUMBER_BILLED
,QUANTITY_RECEIVED_IN_SHIPMENT
,QUANTITY_RETURNED
,EXPECTED_RECEIPT_DATE
,ACTUAL_DELIVERY_DATE
,TAX_ITEM_ID
,TAX_TYPE
,TAX_AMOUNT
,FREIGHT_ESTIMATE_METHOD_ID
,LINE_TYPE
,CLASS_ID
FROM dw_prestage.po_fact_insert;

/* stage -> insert into stage records which have been updated */ 
INSERT INTO dw_stage.po_fact
(
 RUNID
,TRANSACTION_ID
,PO_NUMBER
,TRANSACTION_LINE_ID
,REF_TRX_NUMBER
,REF_CUSTOM_FORM_ID
,VENDOR_ID
,APPROVER_LEVEL_ONE_ID
,APPROVER_LEVEL_TWO_ID
,AMOUNT_UNBILLED
,APPROVAL_STATUS
,BILL_ADDRESS_LINE_1
,BILL_ADDRESS_LINE_2
,BILL_ADDRESS_LINE_3
,BILL_CITY
,BILL_COUNTRY
,BILL_STATE
,BILL_ZIP
,CARRIER_ID
,CLOSED
,CREATED_BY_ID
,REQUESTOR_ID
,CREATED_FROM_ID
,CREATE_DATE
,CURRENCY_ID
,CUSTOM_FORM_ID
,DATE_LAST_MODIFIED
,EMPLOYEE_CUSTOM_ID
,EXCHANGE_RATE
,LOCATION_ID
,PO_APPROVER_ID
,SHIP_ADDRESS_LINE_1
,SHIP_ADDRESS_LINE_2
,SHIP_ADDRESS_LINE_3
,SHIP_CITY
,SHIP_COUNTRY
,SHIP_STATE
,SHIP_ZIP
,SHIPMENT_RECEIVED
,PO_STATUS
,PAYMENT_TERMS_ID
,FRIGHT_RATE
,SUBSIDIARY_ID
,DEPARTMENT_ID
,ITEM_ID
,BC_QUANTITY
,BIH_QUANTITY
,BOOK_FAIR_QUANTITY
,EDUCATION_QUANTITY
,NZSO_QUANTITY
,TRADE_QUANTITY
,SCHOOL_ESSENTIALS_QUANTITY
,ITEM_COUNT
,ITEM_GROSS_AMOUNT
,AMOUNT
,AMOUNT_FOREIGN
,NET_AMOUNT
,NET_AMOUNT_FOREIGN
,GROSS_AMOUNT
,MATCH_BILL_TO_RECEIPT
,TRACK_LANDED_COST
,ITEM_UNIT_PRICE
,NUMBER_BILLED
,QUANTITY_RECEIVED_IN_SHIPMENT
,QUANTITY_RETURNED
,EXPECTED_RECEIPT_DATE
,ACTUAL_DELIVERY_DATE
,TAX_ITEM_ID
,TAX_TYPE
,TAX_AMOUNT
,FREIGHT_ESTIMATE_METHOD_ID
,LINE_TYPE
,CLASS_ID
)
SELECT 
RUNID
,TRANSACTION_ID
,PO_NUMBER
,TRANSACTION_LINE_ID
,REF_TRX_NUMBER
,REF_CUSTOM_FORM_ID
,VENDOR_ID
,APPROVER_LEVEL_ONE_ID
,APPROVER_LEVEL_TWO_ID
,AMOUNT_UNBILLED
,APPROVAL_STATUS
,BILL_ADDRESS_LINE_1
,BILL_ADDRESS_LINE_2
,BILL_ADDRESS_LINE_3
,BILL_CITY
,BILL_COUNTRY
,BILL_STATE
,BILL_ZIP
,CARRIER_ID
,CLOSED
,CREATED_BY_ID
,REQUESTOR_ID
,CREATED_FROM_ID
,CREATE_DATE
,CURRENCY_ID
,CUSTOM_FORM_ID
,DATE_LAST_MODIFIED
,EMPLOYEE_CUSTOM_ID
,EXCHANGE_RATE
,LOCATION_ID
,PO_APPROVER_ID
,SHIP_ADDRESS_LINE_1
,SHIP_ADDRESS_LINE_2
,SHIP_ADDRESS_LINE_3
,SHIP_CITY
,SHIP_COUNTRY
,SHIP_STATE
,SHIP_ZIP
,SHIPMENT_RECEIVED
,PO_STATUS
,PAYMENT_TERMS_ID
,FRIGHT_RATE
,SUBSIDIARY_ID
,DEPARTMENT_ID
,ITEM_ID
,BC_QUANTITY
,BIH_QUANTITY
,BOOK_FAIR_QUANTITY
,EDUCATION_QUANTITY
,NZSO_QUANTITY
,TRADE_QUANTITY
,SCHOOL_ESSENTIALS_QUANTITY
,ITEM_COUNT
,ITEM_GROSS_AMOUNT
,AMOUNT
,AMOUNT_FOREIGN
,NET_AMOUNT
,NET_AMOUNT_FOREIGN
,GROSS_AMOUNT
,MATCH_BILL_TO_RECEIPT
,TRACK_LANDED_COST
,ITEM_UNIT_PRICE
,NUMBER_BILLED
,QUANTITY_RECEIVED_IN_SHIPMENT
,QUANTITY_RETURNED
,EXPECTED_RECEIPT_DATE
,ACTUAL_DELIVERY_DATE
,TAX_ITEM_ID
,TAX_TYPE
,TAX_AMOUNT
,FREIGHT_ESTIMATE_METHOD_ID
,LINE_TYPE
,CLASS_ID
FROM dw_prestage.po_fact
WHERE EXISTS (SELECT 1
              FROM dw_prestage.po_fact_update
              WHERE dw_prestage.po_fact_update.transaction_id = dw_prestage.po_fact.transaction_id
              AND   dw_prestage.po_fact_update.transaction_line_id = dw_prestage.po_fact.transaction_line_id);

/* fact -> INSERT NEW RECORDS WHICH HAVE ALL VALID DIMENSIONS */ 
INSERT INTO dw.po_fact
(
  PO_NUMBER,
  PO_ID,
  PO_LINE_ID,
  REF_TRX_NUMBER,
  REF_TRX_TYPE_KEY, 
  VENDOR_KEY,
  REQUESTER_KEY,
  APPROVER_LEVEL1_KEY,
  APPROVER_LEVEL2_KEY,
  CREATE_DATE_KEY,
  SUBSIDIARY_KEY,
  LOCATION_KEY,
  COST_CENTER_KEY,
  ITEM_KEY,
  REQUESTED_RECEIPT_DATE_KEY,
  ACTUAL_DELIVERY_DATE_KEY,
  FREIGHT_ESTIMATE_METHOD_KEY,
  TERMS_KEY,
  TAX_ITEM_KEY,
  CURRENCY_KEY,
  CLASS_KEY,
  CARRIER_KEY,
  EXCHANGE_RATE,
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
  QUANTITY,
  BIH_QUANTITY,
  BC_QUANTITY,
  TRADE_QUANTITY,
  NZSO_QUANTITY,
  EDUCATION_QUANTITY,
  SCHOOL_ESSENTIALS_QUANTITY,
  BOOK_FAIR_QUANTITY,
  NUMBER_BILLED,
  QUANTITY_RECEIVED_IN_SHIPMENT,
  QUANTITY_RETURNED,
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
  PO_TYPE_KEY,   
  PO_STATUS_KEY,    
  APPROVAL_STATUS,
  CREATION_DATE,
  LAST_MODIFIED_DATE,
  DATE_ACTIVE_FROM,
  DATE_ACTIVE_TO,
  DW_CURRENT
)
SELECT A.po_number AS po_number,
       A.transaction_id AS po_id,
       A.transaction_line_id AS po_line_id,
       A.ref_trx_number AS ref_trx_number,
       U.TRANSACTION_TYPE_KEY AS REF_TRX_TYPE_KEY,
       B.VENDOR_KEY AS VENDOR_KEY,
       C.EMPLOYEE_KEY AS REQUESTER_KEY,
       D.EMPLOYEE_KEY AS APPROVER_LEVEL1_KEY,
       D1.EMPLOYEE_KEY AS APPROVER_LEVEL2_KEY,
       F.DATE_KEY AS CREATE_DATE_KEY,
       G.SUBSIDIARY_KEY AS SUBSIDIARY_KEY,
       L.LOCATION_KEY AS LOCATION_KEY,
       R.DEPARTMENT_KEY AS COST_CENTER_KEY,
       M.ITEM_KEY AS ITEM_KEY,
       H.DATE_KEY AS REQUESTED_RECEIPT_DATE_KEY,
       I.DATE_KEY AS ACTUAL_DELIVERY_DATE_KEY,
       J.FREIGHT_KEY AS FREIGHT_ESTIMATE_METHOD_KEY,
       P.PAYMENT_TERM_KEY AS TERMS_KEY,
       Q.TAX_ITEM_KEY AS TAX_ITEM_KEY,
       K.CURRENCY_KEY AS CURRENCY_KEY,
       S.CLASS_KEY AS CLASS_KEY,
       T.CARRIER_KEY AS CARRIER_KEY,
       A.EXCHANGE_RATE AS EXCHANGE_RATE,
       A.BILL_ADDRESS_LINE_1,
       A.BILL_ADDRESS_LINE_2,
       A.BILL_ADDRESS_LINE_3,
       A.BILL_CITY,
       A.BILL_COUNTRY,
       A.BILL_STATE,
       A.BILL_ZIP,
       A.SHIP_ADDRESS_LINE_1,
       A.SHIP_ADDRESS_LINE_2,
       A.SHIP_ADDRESS_LINE_3,
       A.SHIP_CITY,
       A.SHIP_COUNTRY,
       A.SHIP_STATE,
       A.SHIP_ZIP,
       A.ITEM_COUNT AS QUANTITY,
       A.BIH_QUANTITY AS BIH_QUANTITY,
       A.BC_QUANTITY AS BC_QUANTITY,
       A.TRADE_QUANTITY AS TRADE_QUANTITY,
       A.NZSO_QUANTITY AS NZSO_QUANTITY,
       A.EDUCATION_QUANTITY AS EDUCATION_QUANTITY,
       A.SCHOOL_ESSENTIALS_QUANTITY AS SCHOOL_ESSENTIALS_QUANTITY,
       A.BOOK_FAIR_QUANTITY AS BOOK_FAIR_QUANTITY,
       A.NUMBER_BILLED,
       A.QUANTITY_RECEIVED_IN_SHIPMENT,
       A.QUANTITY_RETURNED,
       A.ITEM_UNIT_PRICE AS RATE,
       A.AMOUNT AS AMOUNT,
       A.ITEM_GROSS_AMOUNT AS ITEM_GROSS_AMOUNT,
       A.AMOUNT_FOREIGN AS AMOUNT_FOREIGN,
       A.NET_AMOUNT AS NET_AMOUNT,
       A.NET_AMOUNT_FOREIGN AS NET_AMOUNT_FOREIGN,
       A.GROSS_AMOUNT AS GROSS_AMOUNT,
       A.MATCH_BILL_TO_RECEIPT AS MATCH_BILL_TO_RECEIPT,
       A.TRACK_LANDED_COST AS TRACK_LANDED_COST,
       A.TAX_AMOUNT AS TAX_AMOUNT,
       A.FRIGHT_RATE AS FREIGHT_RATE,
       W.transaction_type_key   AS PO_TYPE_KEY,
       V.transaction_status_key AS PO_STATUS_KEY,
       A.APPROVAL_STATUS AS APPROVAL_STATUS,
       A.CREATE_DATE AS CREATION_DATE,
       A.DATE_LAST_MODIFIED AS LAST_MODIFIED_DATE,
       SYSDATE AS DATE_ACTIVE_FROM,
       '9999-12-31 11:59:59' AS DATE_ACTIVE_TO,
       1 AS DW_CURRENT
FROM dw_prestage.po_fact_insert A
  INNER JOIN DW_REPORT.VENDORS B ON (A.VENDOR_ID = B.VENDOR_ID)
  INNER JOIN DW_REPORT.EMPLOYEES C ON (NVL (A.REQUESTOR_ID,-99) = C.EMPLOYEE_ID)
  INNER JOIN DW_REPORT.EMPLOYEES D ON (NVL (A.APPROVER_LEVEL_ONE_ID,-99) = D.EMPLOYEE_ID)
  INNER JOIN DW_REPORT.EMPLOYEES D1 ON (NVL (A.APPROVER_LEVEL_TWO_ID,-99) = D1.EMPLOYEE_ID)
  INNER JOIN DW_REPORT.DWDATE F ON (TO_CHAR (A.CREATE_DATE,'YYYYMMDD') = F.DATE_ID)
  INNER JOIN DW_REPORT.SUBSIDIARIES G ON (NVL (A.SUBSIDIARY_ID,-99) = G.SUBSIDIARY_ID)
  INNER JOIN DW_REPORT.DWDATE H ON (NVL (TO_CHAR (A.EXPECTED_RECEIPT_DATE,'YYYYMMDD'),'19000101') = H.DATE_ID)
  INNER JOIN DW_REPORT.DWDATE I ON (NVL (TO_CHAR (A.ACTUAL_DELIVERY_DATE,'YYYYMMDD'),'19000101') = I.DATE_ID)
  INNER JOIN DW_REPORT.FREIGHT_ESTIMATE J ON (NVL (A.FREIGHT_ESTIMATE_METHOD_ID,-99) = J.LANDED_COST_RULE_MATRIX_NZ_ID)
  INNER JOIN DW_REPORT.CURRENCIES K ON (A.CURRENCY_ID = K.CURRENCY_ID)
  INNER JOIN DW_REPORT.LOCATIONS L ON (NVL(A.LOCATION_ID,-99) = L.LOCATION_ID)
  INNER JOIN DW_REPORT.ITEMS M ON (A.ITEM_ID = M.ITEM_ID)
  INNER JOIN DW_REPORT.PAYMENT_TERMS P ON (NVL (A.PAYMENT_TERMS_ID,-99) = P.PAYMENT_TERMS_ID)
  INNER JOIN DW_REPORT.TAX_ITEMS Q ON (A.TAX_ITEM_ID = Q.ITEM_ID)
  INNER JOIN DW_REPORT.COST_CENTER R ON (NVL (A.DEPARTMENT_ID,-99) = R.DEPARTMENT_ID)
  INNER JOIN DW_REPORT.CLASSES S ON (NVL (A.CLASS_ID,-99) = S.CLASS_ID)
  INNER JOIN DW_REPORT.CARRIER T ON (NVL (A.CARRIER_ID,-99) = T.CARRIER_ID)
  INNER JOIN DW_REPORT.transaction_type U ON (NVL(A.ref_custom_form_id,-99) = U.transaction_type_id)
  INNER JOIN DW_REPORT.transaction_status V ON (NVL(A.PO_STATUS,'NA_GDW') = V.status AND V.DOCUMENT_TYPE = 'Purchase Order')
  INNER JOIN DW_REPORT.transaction_type W ON (A.custom_form_id = W.transaction_type_id)
WHERE A.LINE_TYPE = 'PO_LINE';

/* fact -> INSERT NEW RECORDS IN ERROR TABLE WHICH DOES NOT HAVE VALID DIMENSIONS */ 
INSERT INTO dw.po_fact_error
(
 runid
 ,po_number
 ,po_id
 ,po_line_id
 ,ref_trx_number
 ,ref_trx_type_key
 ,vendor_key
 ,requester_key
 ,approver_level1_key
 ,approver_level2_key
 ,create_date_key
 ,subsidiary_key
 ,location_key
 ,cost_center_key
 ,exchange_rate
 ,item_key
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
 ,quantity
 ,bih_quantity
 ,bc_quantity
 ,trade_quantity
 ,nzso_quantity
 ,education_quantity
 ,school_essentials_quantity
 ,book_fair_quantity
 ,number_billed
 ,quantity_received_in_shipment
 ,quantity_returned
 ,rate
 ,amount
 ,item_gross_amount
 ,amount_foreign
 ,net_amount
 ,net_amount_foreign
 ,gross_amount
 ,match_bill_to_receipt
 ,track_landed_cost
 ,tax_item_key
 ,tax_amount
 ,requested_receipt_date_key
 ,actual_delivery_date_key
 ,freight_estimate_method_key
 ,freight_rate
 ,terms_key
 ,po_type_key
 ,po_status_key
 ,po_status_error
 ,approval_status
 ,creation_date
 ,last_modified_date
 ,currency_key
 ,class_key
 ,carrier_key
 ,carrier_id
 ,carrier_id_error
 ,vendor_id
 ,vendor_id_error
 ,requester_id
 ,requester_id_error
 ,approver_level1_id
 ,approver_level1_id_error
 ,approver_level2_id
 ,approver_level2_id_error
 ,create_date_error
 ,subsidiary_id
 ,subsidiary_id_error
 ,location_id
 ,location_id_error
 ,cost_center_id
 ,cost_center_id_error
 ,item_id
 ,item_id_error
 ,tax_item_id
 ,tax_item_id_error
 ,requested_receipt_date
 ,requested_receipt_date_error
 ,actual_delivery_date
 ,actual_delivery_date_error
 ,freight_estimate_method_id
 ,freight_estimate_method_id_error
 ,terms_id
 ,terms_id_error
 ,currency_id
 ,currency_id_error
 ,class_id
 ,class_id_error
 ,custom_form_id
 ,po_type_error
 ,ref_custom_form_id
 ,ref_trx_type_error
 ,record_status
 ,dw_creation_date
)
SELECT
A.RUNID,
A.PO_NUMBER,
A.transaction_id AS po_id,
A.transaction_line_id AS po_line_id,
A.ref_trx_number AS ref_trx_number,
U.transaction_type_key AS ref_trx_type_key,
B.VENDOR_KEY,
C.EMPLOYEE_KEY AS REQUESTER_KEY,
D.EMPLOYEE_KEY AS APPROVER_LEVEL1_KEY,
D.EMPLOYEE_KEY AS APPROVER_LEVEL2_KEY,
F.DATE_KEY AS CREATE_DATE_KEY,
G.SUBSIDIARY_KEY AS SUBSIDIARY_KEY,
L.LOCATION_KEY AS LOCATION_KEY,
R.DEPARTMENT_KEY AS COST_CENTER_KEY,
A.EXCHANGE_RATE,
M.ITEM_KEY AS ITEM_KEY,
A.BILL_ADDRESS_LINE_1,
A.BILL_ADDRESS_LINE_2,
A.BILL_ADDRESS_LINE_3,
A.BILL_CITY,
A.BILL_COUNTRY,
A.BILL_STATE,
A.BILL_ZIP,
A.SHIP_ADDRESS_LINE_1,
A.SHIP_ADDRESS_LINE_2,
A.SHIP_ADDRESS_LINE_3,
A.SHIP_CITY,
A.SHIP_COUNTRY,
A.SHIP_STATE,
A.SHIP_ZIP,
A.ITEM_COUNT AS QUANTITY,
A.BIH_QUANTITY,
A.BC_QUANTITY,
A.TRADE_QUANTITY,
A.NZSO_QUANTITY,
A.EDUCATION_QUANTITY,
A.SCHOOL_ESSENTIALS_QUANTITY,
A.BOOK_FAIR_QUANTITY,
A.NUMBER_BILLED,
A.QUANTITY_RECEIVED_IN_SHIPMENT,
A.QUANTITY_RETURNED,
A.ITEM_UNIT_PRICE AS RATE,
A.AMOUNT,
A.ITEM_GROSS_AMOUNT,
A.AMOUNT_FOREIGN,
A.NET_AMOUNT,
A.NET_AMOUNT_FOREIGN,
A.GROSS_AMOUNT,
A.MATCH_BILL_TO_RECEIPT,
A.TRACK_LANDED_COST,
Q.TAX_ITEM_KEY AS TAX_ITEM_KEY,
A.TAX_AMOUNT,
H.DATE_KEY AS REQUESTED_RECEIPT_DATE_KEY,
I.DATE_KEY AS ACTUAL_DELIVERY_DATE_KEY,
J.FREIGHT_KEY AS FREIGHT_ESTIMATE_METHOD_KEY,
A.FRIGHT_RATE AS FREIGHT_RATE,
P.PAYMENT_TERM_KEY AS TERMS_KEY,
W.transaction_type_key AS PO_TYPE_KEY,
V.transaction_status_key AS PO_STATUS_KEY,
   CASE
         WHEN (v.transaction_status_key IS NULL AND A.PO_STATUS IS NOT NULL  ) THEN ' DIM LOOKUP FAILED '
         WHEN (v.transaction_status_key IS NULL AND A.PO_STATUS IS NULL ) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END,
A.APPROVAL_STATUS,
A.CREATE_DATE AS CREATION_DATE,
A.DATE_LAST_MODIFIED AS LAST_MODIFIED_DATE,
K.CURRENCY_KEY AS CURRENCY_KEY,
S.CLASS_KEY AS CLASS_KEY,
T.CARRIER_KEY AS CARRIER_KEY,
A.CARRIER_ID,
  CASE
         WHEN (T.CARRIER_KEY IS NULL AND A.CARRIER_ID IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (T.CARRIER_KEY IS NULL AND A.CARRIER_ID IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END, 
A.VENDOR_ID,
  CASE
         WHEN ( B.VENDOR_KEY IS NULL AND A.VENDOR_ID IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN ( B.VENDOR_KEY IS NULL AND A.VENDOR_ID IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END, 
A.REQUESTOR_ID,
  CASE
         WHEN ( C.EMPLOYEE_KEY IS NULL AND A.REQUESTOR_ID IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN ( C.EMPLOYEE_KEY IS NULL AND A.REQUESTOR_ID IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END, 
A.APPROVER_LEVEL_ONE_ID,
  CASE
         WHEN ( D.EMPLOYEE_KEY IS NULL AND A.APPROVER_LEVEL_ONE_ID IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN ( D.EMPLOYEE_KEY IS NULL AND A.APPROVER_LEVEL_ONE_ID IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END,
A.APPROVER_LEVEL_TWO_ID,
CASE
         WHEN ( D1.EMPLOYEE_KEY IS NULL AND A.APPROVER_LEVEL_TWO_ID IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN ( D1.EMPLOYEE_KEY IS NULL AND A.APPROVER_LEVEL_TWO_ID IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END,
CASE
         WHEN (A.CREATE_DATE IS NULL ) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END,
A.SUBSIDIARY_ID,
CASE
         WHEN (G.subsidiary_key IS NULL AND A.SUBSIDIARY_ID IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (G.subsidiary_key IS NULL AND A.SUBSIDIARY_ID IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END,
A.LOCATION_ID,
CASE
         WHEN (L.LOCATION_KEY IS NULL AND A.LOCATION_ID IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN ( L.LOCATION_KEY IS NULL AND A.LOCATION_ID IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END,
A.DEPARTMENT_ID AS COST_CENTER_ID,
CASE
         WHEN ( R.DEPARTMENT_KEY IS NULL AND A.DEPARTMENT_ID IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN ( R.DEPARTMENT_KEY IS NULL AND A.DEPARTMENT_ID IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END,
A.ITEM_ID,
CASE
         WHEN ( M.ITEM_KEY IS NULL AND A.ITEM_ID IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN ( M.ITEM_KEY IS NULL AND A.ITEM_ID IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END,
A.TAX_ITEM_ID,
CASE
         WHEN ( Q.TAX_ITEM_KEY IS NULL AND A.TAX_ITEM_ID IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN ( Q.TAX_ITEM_KEY IS NULL AND A.TAX_ITEM_ID IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END,
A.EXPECTED_RECEIPT_DATE,
CASE
         WHEN (H.DATE_KEY IS NULL AND A.EXPECTED_RECEIPT_DATE IS NOT NULL ) THEN ' DIM LOOKUP FAILED '
         WHEN (H.DATE_KEY IS NULL AND A.EXPECTED_RECEIPT_DATE IS NULL ) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END,
A.ACTUAL_DELIVERY_DATE,
CASE
         WHEN (I.DATE_KEY IS NULL AND A.ACTUAL_DELIVERY_DATE IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (I.DATE_KEY IS NULL AND A.ACTUAL_DELIVERY_DATE IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END,
A.FREIGHT_ESTIMATE_METHOD_ID,
CASE
         WHEN (J.FREIGHT_KEY IS NULL AND A.FREIGHT_ESTIMATE_METHOD_ID IS NOT NULL ) THEN ' DIM LOOKUP FAILED '
         WHEN (J.FREIGHT_KEY IS NULL AND A.FREIGHT_ESTIMATE_METHOD_ID IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END,
A.PAYMENT_TERMS_ID AS TERMS_ID,
CASE
         WHEN (P.PAYMENT_TERM_KEY IS NULL AND A.PAYMENT_TERMS_ID IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (P.PAYMENT_TERM_KEY IS NULL AND A.PAYMENT_TERMS_ID IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END,
A.CURRENCY_ID,
CASE
         WHEN (K.CURRENCY_KEY IS NULL AND A.CURRENCY_ID IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (K.CURRENCY_KEY IS NULL AND A.CURRENCY_ID IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END,
A.CLASS_ID,
CASE
         WHEN (S.CLASS_KEY IS NULL AND A.CLASS_ID IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (S.CLASS_KEY IS NULL AND A.CLASS_ID IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END,
A.CUSTOM_FORM_ID,
CASE
         WHEN (W.transaction_type_key IS NULL AND A.custom_form_id IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (W.transaction_type_key IS NULL AND A.custom_form_id IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END,
A.ref_custom_form_id, 
CASE
         WHEN (U.transaction_type_key IS NULL AND A.ref_custom_form_id IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (U.transaction_type_key IS NULL AND A.ref_custom_form_id IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END,
'ERROR' AS RECORD_STATUS,
SYSDATE AS DW_CREATION_DATE
FROM dw_prestage.po_fact_insert A
  LEFT OUTER JOIN DW_REPORT.VENDORS B ON (A.VENDOR_ID = B.VENDOR_ID)
  LEFT OUTER JOIN DW_REPORT.EMPLOYEES C ON (A.REQUESTOR_ID = C.EMPLOYEE_ID)
  LEFT OUTER JOIN DW_REPORT.EMPLOYEES D ON (A.APPROVER_LEVEL_ONE_ID = D.EMPLOYEE_ID)
  LEFT OUTER JOIN DW_REPORT.EMPLOYEES D1 ON (A.APPROVER_LEVEL_TWO_ID = D1.EMPLOYEE_ID)
  LEFT OUTER JOIN DW_REPORT.DWDATE F ON (TO_CHAR (A.CREATE_DATE,'YYYYMMDD') = F.DATE_ID)
  LEFT OUTER JOIN DW_REPORT.SUBSIDIARIES G ON (A.SUBSIDIARY_ID = G.SUBSIDIARY_ID)
  LEFT OUTER JOIN DW_REPORT.DWDATE H ON (TO_CHAR(A.EXPECTED_RECEIPT_DATE,'YYYYMMDD') = H.DATE_ID)
  LEFT OUTER JOIN DW_REPORT.DWDATE I ON (TO_CHAR(A.ACTUAL_DELIVERY_DATE,'YYYYMMDD') = I.DATE_ID)
  LEFT OUTER JOIN DW_REPORT.FREIGHT_ESTIMATE J ON (A.FREIGHT_ESTIMATE_METHOD_ID = J.LANDED_COST_RULE_MATRIX_NZ_ID)
  LEFT OUTER JOIN DW_REPORT.CURRENCIES K ON (A.CURRENCY_ID = K.CURRENCY_ID)
  LEFT OUTER JOIN DW_REPORT.LOCATIONS L ON (A.LOCATION_ID = L.LOCATION_ID)
  LEFT OUTER JOIN DW_REPORT.ITEMS M ON (A.ITEM_ID = M.ITEM_ID)
  LEFT OUTER JOIN DW_REPORT.PAYMENT_TERMS P ON (A.PAYMENT_TERMS_ID = P.PAYMENT_TERMS_ID)
  LEFT OUTER JOIN DW_REPORT.TAX_ITEMS Q ON (A.TAX_ITEM_ID = Q.ITEM_ID)
  LEFT OUTER JOIN DW_REPORT.COST_CENTER R ON (A.DEPARTMENT_ID = R.DEPARTMENT_ID)
  LEFT OUTER JOIN DW_REPORT.CLASSES S ON (A.CLASS_ID = S.CLASS_ID)
  LEFT OUTER JOIN DW_REPORT.CARRIER T ON (A.CARRIER_ID = T.CARRIER_ID)
  LEFT OUTER JOIN DW_REPORT.transaction_type U ON (A.ref_custom_form_id = U.transaction_type_id)
  LEFT OUTER JOIN DW_REPORT.transaction_status V ON (A.PO_STATUS = V.status AND V.DOCUMENT_TYPE = 'Purchase Order')
  LEFT OUTER JOIN DW_REPORT.transaction_type W ON (A.custom_form_id = W.transaction_type_id)
WHERE A.LINE_TYPE = 'PO_LINE'
AND   (B.VENDOR_KEY IS NULL OR 
       (C.EMPLOYEE_KEY IS NULL AND A.REQUESTOR_ID IS NOT NULL ) OR 
       (D.EMPLOYEE_KEY IS NULL AND A.APPROVER_LEVEL_ONE_ID IS NOT NULL ) OR 
       (D1.EMPLOYEE_KEY IS NULL AND A.APPROVER_LEVEL_TWO_ID IS NOT NULL ) OR 
       F.DATE_KEY IS NULL OR 
       (G.SUBSIDIARY_KEY IS NULL AND A.SUBSIDIARY_ID IS NOT NULL ) OR 
       ( L.LOCATION_KEY IS NULL AND A.LOCATION_ID IS NOT NULL ) OR 
       ( R.DEPARTMENT_KEY IS NULL AND A.DEPARTMENT_ID IS NOT NULL ) OR 
       M.ITEM_KEY IS NULL OR 
       Q.TAX_ITEM_KEY IS NULL OR 
       ( H.DATE_KEY IS NULL AND A.EXPECTED_RECEIPT_DATE IS NOT NULL ) OR 
       ( I.DATE_KEY IS NULL AND A.ACTUAL_DELIVERY_DATE IS NOT NULL ) OR 
       ( J.FREIGHT_KEY IS NULL AND A.FREIGHT_ESTIMATE_METHOD_ID IS NOT NULL ) OR 
       ( P.PAYMENT_TERM_KEY IS NULL AND A.PAYMENT_TERMS_ID IS NOT NULL ) OR 
       K.CURRENCY_KEY IS NULL OR 
       ( S.CLASS_KEY IS NULL AND A.CLASS_ID IS NOT NULL ) OR 
       ( T.CARRIER_KEY IS NULL AND A.CARRIER_ID IS NOT NULL ) OR
	    A.custom_form_id IS NULL OR
		(U.transaction_type_KEY IS NULL AND A.ref_custom_form_id IS NOT NULL) OR
		( V.TRANSACTION_STATUS_KEY IS NULL AND A.PO_STATUS IS NOT NULL));

/* fact -> UPDATE THE OLD RECORDS SETTING THE CURRENT FLAG VALUE TO 0 */ 
UPDATE dw.po_fact
   SET dw_current = 0,
       DATE_ACTIVE_TO = (sysdate -1)
WHERE dw_current = 1
AND   sysdate>= date_active_from
AND   sysdate< date_active_to
AND   EXISTS (SELECT 1
              FROM dw_prestage.po_fact_update
              WHERE dw.po_fact.po_id = dw_prestage.po_fact_update.transaction_id
              AND   dw.po_fact.po_line_id = dw_prestage.po_fact_update.transaction_line_id);

/* fact -> NOW INSERT THE FACT RECORDS WHICH HAVE BEEN UPDATED AT THE SOURCE */ 
INSERT INTO dw.po_fact
(
  PO_NUMBER,
  PO_ID,
  PO_LINE_ID,
  REF_TRX_NUMBER,
  REF_TRX_TYPE_KEY, 
  VENDOR_KEY,
  REQUESTER_KEY,
  APPROVER_LEVEL1_KEY,
  APPROVER_LEVEL2_KEY,
  CREATE_DATE_KEY,
  SUBSIDIARY_KEY,
  LOCATION_KEY,
  COST_CENTER_KEY,
  ITEM_KEY,
  REQUESTED_RECEIPT_DATE_KEY,
  ACTUAL_DELIVERY_DATE_KEY,
  FREIGHT_ESTIMATE_METHOD_KEY,
  TERMS_KEY,
  TAX_ITEM_KEY,
  CURRENCY_KEY,
  CLASS_KEY,
  CARRIER_KEY,
  EXCHANGE_RATE,
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
  QUANTITY,
  BIH_QUANTITY,
  BC_QUANTITY,
  TRADE_QUANTITY,
  NZSO_QUANTITY,
  EDUCATION_QUANTITY,
  SCHOOL_ESSENTIALS_QUANTITY,
  BOOK_FAIR_QUANTITY,
  NUMBER_BILLED,
  QUANTITY_RECEIVED_IN_SHIPMENT,
  QUANTITY_RETURNED,
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
  PO_TYPE_KEY,   
  PO_STATUS_KEY,    
  APPROVAL_STATUS,
  CREATION_DATE,
  LAST_MODIFIED_DATE,
  DATE_ACTIVE_FROM,
  DATE_ACTIVE_TO,
  DW_CURRENT
)
SELECT A.po_number AS po_number,
       A.transaction_id AS po_id,
       A.transaction_line_id AS po_line_id,
       A.ref_trx_number AS ref_trx_number,
       U.TRANSACTION_TYPE_KEY AS REF_TRX_TYPE_KEY,
       B.VENDOR_KEY AS VENDOR_KEY,
       C.EMPLOYEE_KEY AS REQUESTER_KEY,
       D.EMPLOYEE_KEY AS APPROVER_LEVEL1_KEY,
       D1.EMPLOYEE_KEY AS APPROVER_LEVEL2_KEY,
       F.DATE_KEY AS CREATE_DATE_KEY,
       G.SUBSIDIARY_KEY AS SUBSIDIARY_KEY,
       L.LOCATION_KEY AS LOCATION_KEY,
       R.DEPARTMENT_KEY AS COST_CENTER_KEY,
       M.ITEM_KEY AS ITEM_KEY,
       H.DATE_KEY AS REQUESTED_RECEIPT_DATE_KEY,
       I.DATE_KEY AS ACTUAL_DELIVERY_DATE_KEY,
       J.FREIGHT_KEY AS FREIGHT_ESTIMATE_METHOD_KEY,
       P.PAYMENT_TERM_KEY AS TERMS_KEY,
       Q.TAX_ITEM_KEY AS TAX_ITEM_KEY,
       K.CURRENCY_KEY AS CURRENCY_KEY,
       S.CLASS_KEY AS CLASS_KEY,
       T.CARRIER_KEY AS CARRIER_KEY,
       A.EXCHANGE_RATE AS EXCHANGE_RATE,
       A.BILL_ADDRESS_LINE_1,
       A.BILL_ADDRESS_LINE_2,
       A.BILL_ADDRESS_LINE_3,
       A.BILL_CITY,
       A.BILL_COUNTRY,
       A.BILL_STATE,
       A.BILL_ZIP,
       A.SHIP_ADDRESS_LINE_1,
       A.SHIP_ADDRESS_LINE_2,
       A.SHIP_ADDRESS_LINE_3,
       A.SHIP_CITY,
       A.SHIP_COUNTRY,
       A.SHIP_STATE,
       A.SHIP_ZIP,
       A.ITEM_COUNT AS QUANTITY,
       A.BIH_QUANTITY AS BIH_QUANTITY,
       A.BC_QUANTITY AS BC_QUANTITY,
       A.TRADE_QUANTITY AS TRADE_QUANTITY,
       A.NZSO_QUANTITY AS NZSO_QUANTITY,
       A.EDUCATION_QUANTITY AS EDUCATION_QUANTITY,
       A.SCHOOL_ESSENTIALS_QUANTITY AS SCHOOL_ESSENTIALS_QUANTITY,
       A.BOOK_FAIR_QUANTITY AS BOOK_FAIR_QUANTITY,
       A.NUMBER_BILLED,
       A.QUANTITY_RECEIVED_IN_SHIPMENT,
       A.QUANTITY_RETURNED,
       A.ITEM_UNIT_PRICE AS RATE,
       A.AMOUNT AS AMOUNT,
       A.ITEM_GROSS_AMOUNT AS ITEM_GROSS_AMOUNT,
       A.AMOUNT_FOREIGN AS AMOUNT_FOREIGN,
       A.NET_AMOUNT AS NET_AMOUNT,
       A.NET_AMOUNT_FOREIGN AS NET_AMOUNT_FOREIGN,
       A.GROSS_AMOUNT AS GROSS_AMOUNT,
       A.MATCH_BILL_TO_RECEIPT AS MATCH_BILL_TO_RECEIPT,
       A.TRACK_LANDED_COST AS TRACK_LANDED_COST,
       A.TAX_AMOUNT AS TAX_AMOUNT,
       A.FRIGHT_RATE AS FREIGHT_RATE,
       W.transaction_type_key   AS PO_TYPE_KEY,
       V.transaction_status_key AS PO_STATUS_KEY,
       A.APPROVAL_STATUS AS APPROVAL_STATUS,
       A.CREATE_DATE AS CREATION_DATE,
       A.DATE_LAST_MODIFIED AS LAST_MODIFIED_DATE,
       SYSDATE AS DATE_ACTIVE_FROM,
       '9999-12-31 11:59:59' AS DATE_ACTIVE_TO,
       1 AS DW_CURRENT
FROM dw_prestage.po_fact A
  INNER JOIN DW_REPORT.VENDORS B ON (A.VENDOR_ID = B.VENDOR_ID)
  INNER JOIN DW_REPORT.EMPLOYEES C ON (NVL (A.REQUESTOR_ID,-99) = C.EMPLOYEE_ID)
  INNER JOIN DW_REPORT.EMPLOYEES D ON (NVL (A.APPROVER_LEVEL_ONE_ID,-99) = D.EMPLOYEE_ID)
  INNER JOIN DW_REPORT.EMPLOYEES D1 ON (NVL (A.APPROVER_LEVEL_TWO_ID,-99) = D1.EMPLOYEE_ID)
  INNER JOIN DW_REPORT.DWDATE F ON (TO_CHAR (A.CREATE_DATE,'YYYYMMDD') = F.DATE_ID)
  INNER JOIN DW_REPORT.SUBSIDIARIES G ON (NVL (A.SUBSIDIARY_ID,-99) = G.SUBSIDIARY_ID)
  INNER JOIN DW_REPORT.DWDATE H ON (NVL (TO_CHAR (A.EXPECTED_RECEIPT_DATE,'YYYYMMDD'),'19000101') = H.DATE_ID)
  INNER JOIN DW_REPORT.DWDATE I ON (NVL (TO_CHAR (A.ACTUAL_DELIVERY_DATE,'YYYYMMDD'),'19000101') = I.DATE_ID)
  INNER JOIN DW_REPORT.FREIGHT_ESTIMATE J ON (NVL (A.FREIGHT_ESTIMATE_METHOD_ID,-99) = J.LANDED_COST_RULE_MATRIX_NZ_ID)
  INNER JOIN DW_REPORT.CURRENCIES K ON (A.CURRENCY_ID = K.CURRENCY_ID)
  INNER JOIN DW_REPORT.LOCATIONS L ON (NVL(A.LOCATION_ID,-99) = L.LOCATION_ID)
  INNER JOIN DW_REPORT.ITEMS M ON (A.ITEM_ID = M.ITEM_ID)
  INNER JOIN DW_REPORT.PAYMENT_TERMS P ON (NVL (A.PAYMENT_TERMS_ID,-99) = P.PAYMENT_TERMS_ID)
  INNER JOIN DW_REPORT.TAX_ITEMS Q ON (A.TAX_ITEM_ID = Q.ITEM_ID)
  INNER JOIN DW_REPORT.COST_CENTER R ON (NVL (A.DEPARTMENT_ID,-99) = R.DEPARTMENT_ID)
  INNER JOIN DW_REPORT.CLASSES S ON (NVL (A.CLASS_ID,-99) = S.CLASS_ID)
  INNER JOIN DW_REPORT.CARRIER T ON (NVL (A.CARRIER_ID,-99) = T.CARRIER_ID)
  INNER JOIN DW_REPORT.transaction_type U ON (NVL(A.ref_custom_form_id,-99) = U.transaction_type_id)
  INNER JOIN DW_REPORT.transaction_status V ON (NVL(A.PO_STATUS,'NA_GDW') = V.status AND V.DOCUMENT_TYPE = 'Purchase Order')
  INNER JOIN DW_REPORT.transaction_type W ON (A.custom_form_id = W.transaction_type_id)
WHERE A.LINE_TYPE = 'PO_LINE'
AND   EXISTS (SELECT 1
              FROM dw_prestage.po_fact_update
              WHERE a.transaction_id = dw_prestage.po_fact_update.transaction_id
              AND   a.transaction_line_id = dw_prestage.po_fact_update.transaction_line_id);

/* fact -> INSERT UPDATED RECORDS IN ERROR TABLE WHICH DOES NOT HAVE VALID DIMENSIONS */ 
INSERT INTO dw.po_fact_error
(
 runid
 ,po_number
 ,po_id
 ,po_line_id
 ,ref_trx_number
 ,ref_trx_type_key
 ,vendor_key
 ,requester_key
 ,approver_level1_key
 ,approver_level2_key
 ,create_date_key
 ,subsidiary_key
 ,location_key
 ,cost_center_key
 ,exchange_rate
 ,item_key
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
 ,quantity
 ,bih_quantity
 ,bc_quantity
 ,trade_quantity
 ,nzso_quantity
 ,education_quantity
 ,school_essentials_quantity
 ,book_fair_quantity
 ,number_billed
 ,quantity_received_in_shipment
 ,quantity_returned
 ,rate
 ,amount
 ,item_gross_amount
 ,amount_foreign
 ,net_amount
 ,net_amount_foreign
 ,gross_amount
 ,match_bill_to_receipt
 ,track_landed_cost
 ,tax_item_key
 ,tax_amount
 ,requested_receipt_date_key
 ,actual_delivery_date_key
 ,freight_estimate_method_key
 ,freight_rate
 ,terms_key
 ,po_type_key
 ,po_status_key
 ,po_status_error
 ,approval_status
 ,creation_date
 ,last_modified_date
 ,currency_key
 ,class_key
 ,carrier_key
 ,carrier_id
 ,carrier_id_error
 ,vendor_id
 ,vendor_id_error
 ,requester_id
 ,requester_id_error
 ,approver_level1_id
 ,approver_level1_id_error
 ,approver_level2_id
 ,approver_level2_id_error
 ,create_date_error
 ,subsidiary_id
 ,subsidiary_id_error
 ,location_id
 ,location_id_error
 ,cost_center_id
 ,cost_center_id_error
 ,item_id
 ,item_id_error
 ,tax_item_id
 ,tax_item_id_error
 ,requested_receipt_date
 ,requested_receipt_date_error
 ,actual_delivery_date
 ,actual_delivery_date_error
 ,freight_estimate_method_id
 ,freight_estimate_method_id_error
 ,terms_id
 ,terms_id_error
 ,currency_id
 ,currency_id_error
 ,class_id
 ,class_id_error
 ,custom_form_id
 ,po_type_error
 ,ref_custom_form_id
 ,ref_trx_type_error
 ,record_status
 ,dw_creation_date
)
SELECT
A.RUNID,
A.PO_NUMBER,
A.transaction_id AS po_id,
A.transaction_line_id AS po_line_id,
A.ref_trx_number AS ref_trx_number,
U.transaction_type_key AS ref_trx_type_key,
B.VENDOR_KEY,
C.EMPLOYEE_KEY AS REQUESTER_KEY,
D.EMPLOYEE_KEY AS APPROVER_LEVEL1_KEY,
D.EMPLOYEE_KEY AS APPROVER_LEVEL2_KEY,
F.DATE_KEY AS CREATE_DATE_KEY,
G.SUBSIDIARY_KEY AS SUBSIDIARY_KEY,
L.LOCATION_KEY AS LOCATION_KEY,
R.DEPARTMENT_KEY AS COST_CENTER_KEY,
A.EXCHANGE_RATE,
M.ITEM_KEY AS ITEM_KEY,
A.BILL_ADDRESS_LINE_1,
A.BILL_ADDRESS_LINE_2,
A.BILL_ADDRESS_LINE_3,
A.BILL_CITY,
A.BILL_COUNTRY,
A.BILL_STATE,
A.BILL_ZIP,
A.SHIP_ADDRESS_LINE_1,
A.SHIP_ADDRESS_LINE_2,
A.SHIP_ADDRESS_LINE_3,
A.SHIP_CITY,
A.SHIP_COUNTRY,
A.SHIP_STATE,
A.SHIP_ZIP,
A.ITEM_COUNT AS QUANTITY,
A.BIH_QUANTITY,
A.BC_QUANTITY,
A.TRADE_QUANTITY,
A.NZSO_QUANTITY,
A.EDUCATION_QUANTITY,
A.SCHOOL_ESSENTIALS_QUANTITY,
A.BOOK_FAIR_QUANTITY,
A.NUMBER_BILLED,
A.QUANTITY_RECEIVED_IN_SHIPMENT,
A.QUANTITY_RETURNED,
A.ITEM_UNIT_PRICE AS RATE,
A.AMOUNT,
A.ITEM_GROSS_AMOUNT,
A.AMOUNT_FOREIGN,
A.NET_AMOUNT,
A.NET_AMOUNT_FOREIGN,
A.GROSS_AMOUNT,
A.MATCH_BILL_TO_RECEIPT,
A.TRACK_LANDED_COST,
Q.TAX_ITEM_KEY AS TAX_ITEM_KEY,
A.TAX_AMOUNT,
H.DATE_KEY AS REQUESTED_RECEIPT_DATE_KEY,
I.DATE_KEY AS ACTUAL_DELIVERY_DATE_KEY,
J.FREIGHT_KEY AS FREIGHT_ESTIMATE_METHOD_KEY,
A.FRIGHT_RATE AS FREIGHT_RATE,
P.PAYMENT_TERM_KEY AS TERMS_KEY,
W.transaction_type_key AS PO_TYPE_KEY,
V.transaction_status_key AS PO_STATUS_KEY,
   CASE
         WHEN (v.transaction_status_key IS NULL AND A.PO_STATUS IS NOT NULL  ) THEN ' DIM LOOKUP FAILED '
         WHEN (v.transaction_status_key IS NULL AND A.PO_STATUS IS NULL ) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END,
A.APPROVAL_STATUS,
A.CREATE_DATE AS CREATION_DATE,
A.DATE_LAST_MODIFIED AS LAST_MODIFIED_DATE,
K.CURRENCY_KEY AS CURRENCY_KEY,
S.CLASS_KEY AS CLASS_KEY,
T.CARRIER_KEY AS CARRIER_KEY,
A.CARRIER_ID,
  CASE
         WHEN (T.CARRIER_KEY IS NULL AND A.CARRIER_ID IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (T.CARRIER_KEY IS NULL AND A.CARRIER_ID IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END, 
A.VENDOR_ID,
  CASE
         WHEN ( B.VENDOR_KEY IS NULL AND A.VENDOR_ID IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN ( B.VENDOR_KEY IS NULL AND A.VENDOR_ID IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END, 
A.REQUESTOR_ID,
  CASE
         WHEN ( C.EMPLOYEE_KEY IS NULL AND A.REQUESTOR_ID IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN ( C.EMPLOYEE_KEY IS NULL AND A.REQUESTOR_ID IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END, 
A.APPROVER_LEVEL_ONE_ID,
  CASE
         WHEN ( D.EMPLOYEE_KEY IS NULL AND A.APPROVER_LEVEL_ONE_ID IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN ( D.EMPLOYEE_KEY IS NULL AND A.APPROVER_LEVEL_ONE_ID IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END,
A.APPROVER_LEVEL_TWO_ID,
CASE
         WHEN ( D1.EMPLOYEE_KEY IS NULL AND A.APPROVER_LEVEL_TWO_ID IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN ( D1.EMPLOYEE_KEY IS NULL AND A.APPROVER_LEVEL_TWO_ID IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END,
CASE
         WHEN (A.CREATE_DATE IS NULL ) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END,
A.SUBSIDIARY_ID,
CASE
         WHEN (G.subsidiary_key IS NULL AND A.SUBSIDIARY_ID IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (G.subsidiary_key IS NULL AND A.SUBSIDIARY_ID IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END,
A.LOCATION_ID,
CASE
         WHEN (L.LOCATION_KEY IS NULL AND A.LOCATION_ID IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN ( L.LOCATION_KEY IS NULL AND A.LOCATION_ID IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END,
A.DEPARTMENT_ID AS COST_CENTER_ID,
CASE
         WHEN ( R.DEPARTMENT_KEY IS NULL AND A.DEPARTMENT_ID IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN ( R.DEPARTMENT_KEY IS NULL AND A.DEPARTMENT_ID IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END,
A.ITEM_ID,
CASE
         WHEN ( M.ITEM_KEY IS NULL AND A.ITEM_ID IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN ( M.ITEM_KEY IS NULL AND A.ITEM_ID IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END,
A.TAX_ITEM_ID,
CASE
         WHEN ( Q.TAX_ITEM_KEY IS NULL AND A.TAX_ITEM_ID IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN ( Q.TAX_ITEM_KEY IS NULL AND A.TAX_ITEM_ID IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END,
A.EXPECTED_RECEIPT_DATE,
CASE
         WHEN (H.DATE_KEY IS NULL AND A.EXPECTED_RECEIPT_DATE IS NOT NULL ) THEN ' DIM LOOKUP FAILED '
         WHEN (H.DATE_KEY IS NULL AND A.EXPECTED_RECEIPT_DATE IS NULL ) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END,
A.ACTUAL_DELIVERY_DATE,
CASE
         WHEN (I.DATE_KEY IS NULL AND A.ACTUAL_DELIVERY_DATE IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (I.DATE_KEY IS NULL AND A.ACTUAL_DELIVERY_DATE IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END,
A.FREIGHT_ESTIMATE_METHOD_ID,
CASE
         WHEN (J.FREIGHT_KEY IS NULL AND A.FREIGHT_ESTIMATE_METHOD_ID IS NOT NULL ) THEN ' DIM LOOKUP FAILED '
         WHEN (J.FREIGHT_KEY IS NULL AND A.FREIGHT_ESTIMATE_METHOD_ID IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END,
A.PAYMENT_TERMS_ID AS TERMS_ID,
CASE
         WHEN (P.PAYMENT_TERM_KEY IS NULL AND A.PAYMENT_TERMS_ID IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (P.PAYMENT_TERM_KEY IS NULL AND A.PAYMENT_TERMS_ID IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END,
A.CURRENCY_ID,
CASE
         WHEN (K.CURRENCY_KEY IS NULL AND A.CURRENCY_ID IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (K.CURRENCY_KEY IS NULL AND A.CURRENCY_ID IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END,
A.CLASS_ID,
CASE
         WHEN (S.CLASS_KEY IS NULL AND A.CLASS_ID IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (S.CLASS_KEY IS NULL AND A.CLASS_ID IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END,
A.CUSTOM_FORM_ID,
CASE
         WHEN (W.transaction_type_key IS NULL AND A.custom_form_id IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (W.transaction_type_key IS NULL AND A.custom_form_id IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END,
A.ref_custom_form_id, 
CASE
         WHEN (U.transaction_type_key IS NULL AND A.ref_custom_form_id IS NOT NULL) THEN ' DIM LOOKUP FAILED '
         WHEN (U.transaction_type_key IS NULL AND A.ref_custom_form_id IS NULL) THEN ' NO DIM FROM SOURCE '
         ELSE 'OK'
       END,
'ERROR' AS RECORD_STATUS,
SYSDATE AS DW_CREATION_DATE
FROM dw_prestage.po_fact A
  LEFT OUTER JOIN DW_REPORT.VENDORS B ON (A.VENDOR_ID = B.VENDOR_ID)
  LEFT OUTER JOIN DW_REPORT.EMPLOYEES C ON (A.REQUESTOR_ID = C.EMPLOYEE_ID)
  LEFT OUTER JOIN DW_REPORT.EMPLOYEES D ON (A.APPROVER_LEVEL_ONE_ID = D.EMPLOYEE_ID)
  LEFT OUTER JOIN DW_REPORT.EMPLOYEES D1 ON (A.APPROVER_LEVEL_TWO_ID = D1.EMPLOYEE_ID)
  LEFT OUTER JOIN DW_REPORT.DWDATE F ON (TO_CHAR (A.CREATE_DATE,'YYYYMMDD') = F.DATE_ID)
  LEFT OUTER JOIN DW_REPORT.SUBSIDIARIES G ON (A.SUBSIDIARY_ID = G.SUBSIDIARY_ID)
  LEFT OUTER JOIN DW_REPORT.DWDATE H ON (TO_CHAR(A.EXPECTED_RECEIPT_DATE,'YYYYMMDD') = H.DATE_ID)
  LEFT OUTER JOIN DW_REPORT.DWDATE I ON (TO_CHAR(A.ACTUAL_DELIVERY_DATE,'YYYYMMDD') = I.DATE_ID)
  LEFT OUTER JOIN DW_REPORT.FREIGHT_ESTIMATE J ON (A.FREIGHT_ESTIMATE_METHOD_ID = J.LANDED_COST_RULE_MATRIX_NZ_ID)
  LEFT OUTER JOIN DW_REPORT.CURRENCIES K ON (A.CURRENCY_ID = K.CURRENCY_ID)
  LEFT OUTER JOIN DW_REPORT.LOCATIONS L ON (A.LOCATION_ID = L.LOCATION_ID)
  LEFT OUTER JOIN DW_REPORT.ITEMS M ON (A.ITEM_ID = M.ITEM_ID)
  LEFT OUTER JOIN DW_REPORT.PAYMENT_TERMS P ON (A.PAYMENT_TERMS_ID = P.PAYMENT_TERMS_ID)
  LEFT OUTER JOIN DW_REPORT.TAX_ITEMS Q ON (A.TAX_ITEM_ID = Q.ITEM_ID)
  LEFT OUTER JOIN DW_REPORT.COST_CENTER R ON (A.DEPARTMENT_ID = R.DEPARTMENT_ID)
  LEFT OUTER JOIN DW_REPORT.CLASSES S ON (A.CLASS_ID = S.CLASS_ID)
  LEFT OUTER JOIN DW_REPORT.CARRIER T ON (A.CARRIER_ID = T.CARRIER_ID)
  LEFT OUTER JOIN DW_REPORT.transaction_type U ON (A.ref_custom_form_id = U.transaction_type_id)
  LEFT OUTER JOIN DW_REPORT.transaction_status V ON (A.PO_STATUS = V.status AND V.DOCUMENT_TYPE = 'Purchase Order')
  LEFT OUTER JOIN DW_REPORT.transaction_type W ON (A.custom_form_id = W.transaction_type_id)
WHERE A.LINE_TYPE = 'PO_LINE'
AND   (B.VENDOR_KEY IS NULL OR 
       (C.EMPLOYEE_KEY IS NULL AND A.REQUESTOR_ID IS NOT NULL ) OR 
       (D.EMPLOYEE_KEY IS NULL AND A.APPROVER_LEVEL_ONE_ID IS NOT NULL ) OR 
       (D1.EMPLOYEE_KEY IS NULL AND A.APPROVER_LEVEL_TWO_ID IS NOT NULL ) OR 
       F.DATE_KEY IS NULL OR 
       (G.SUBSIDIARY_KEY IS NULL AND A.SUBSIDIARY_ID IS NOT NULL ) OR 
       ( L.LOCATION_KEY IS NULL AND A.LOCATION_ID IS NOT NULL ) OR 
       ( R.DEPARTMENT_KEY IS NULL AND A.DEPARTMENT_ID IS NOT NULL ) OR 
       M.ITEM_KEY IS NULL OR 
       Q.TAX_ITEM_KEY IS NULL OR 
       ( H.DATE_KEY IS NULL AND A.EXPECTED_RECEIPT_DATE IS NOT NULL ) OR 
       ( I.DATE_KEY IS NULL AND A.ACTUAL_DELIVERY_DATE IS NOT NULL ) OR 
       ( J.FREIGHT_KEY IS NULL AND A.FREIGHT_ESTIMATE_METHOD_ID IS NOT NULL ) OR 
       ( P.PAYMENT_TERM_KEY IS NULL AND A.PAYMENT_TERMS_ID IS NOT NULL ) OR 
       K.CURRENCY_KEY IS NULL OR 
       ( S.CLASS_KEY IS NULL AND A.CLASS_ID IS NOT NULL ) OR 
       ( T.CARRIER_KEY IS NULL AND A.CARRIER_ID IS NOT NULL ) OR
	    A.custom_form_id IS NULL OR
		(U.transaction_type_KEY IS NULL AND A.ref_custom_form_id IS NOT NULL) OR
		( V.TRANSACTION_STATUS_KEY IS NULL AND A.PO_STATUS IS NOT NULL))
AND   EXISTS (SELECT 1
              FROM dw_prestage.po_fact_update
              WHERE a.transaction_id = dw_prestage.po_fact_update.transaction_id
              AND   a.transaction_line_id = dw_prestage.po_fact_update.transaction_line_id);

