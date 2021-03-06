SELECT
1 AS runid,
TO_CHAR(VENDORS.ABCD_MARKER_ID) AS ABCD_MARKER_ID , 
ACCOUNTNUMBER , 
TO_CHAR(ACTUAL_COST) AS ACTUAL_COST , 
REPLACE(REPLACE(VENDORS.ALTEMAIL,CHR(10),' '),CHR(13),' ') AS ALTEMAIL , 
REPLACE(REPLACE(VENDORS.ALTERNATE_CUSTOMER_EMAIL,CHR(10),' '),CHR(13),' ') AS ALTERNATE_CUSTOMER_EMAIL , 
REPLACE(REPLACE(VENDORS.ALTERNATE_CUSTOMER_EMAIL1,CHR(10),' '),CHR(13),' ') AS ALTERNATE_CUSTOMER_EMAIL1 , 
REPLACE(REPLACE(VENDORS.ALTERNATE_CUSTOMER_EMAIL2,CHR(10),' '),CHR(13),' ') AS ALTERNATE_CUSTOMER_EMAIL2 , 
REPLACE(REPLACE(VENDORS.ALTPHONE,CHR(10),' '),CHR(13),' ') AS ALTPHONE , 
APPLY_FREIGHT , 
BACKORDERS_ALLOWED , 
BACK_ORDER_SPLIT , 
REPLACE(REPLACE(VENDORS.BILLADDRESS,CHR(10),' '),CHR(13),' ') AS BILLADDRESS , 
TO_CHAR(VENDORS.BILLING_CLASS_ID) AS BILLING_CLASS_ID , 
TO_CHAR(VENDORS.BOOK_FAIRS_CONSULTANT_ID) AS BOOK_FAIRS_CONSULTANT_ID , 
REPLACE(REPLACE(VENDORS.BOOK_FAIR_ABCD_MARKER,CHR(10),' '),CHR(13),' ') AS BOOK_FAIR_ABCD_MARKER , 
TO_CHAR(VENDORS.BOOK_FAIR_SIZE_ID) AS BOOK_FAIR_SIZE_ID , 
BRN , 
TO_CHAR(VENDORS.BUSINESS_STYLE_ID) AS BUSINESS_STYLE_ID , 
REPLACE(REPLACE(VENDORS.CARRIER_ADDRESS,CHR(10),' '),CHR(13),' ') AS CARRIER_ADDRESS , 
TO_CHAR(VENDORS.CARRIER_LABEL_ID) AS CARRIER_LABEL_ID , 
CITY , 
REPLACE(REPLACE(VENDORS.COMMENTS,CHR(10),' '),CHR(13),' ') AS COMMENTS , 
COMPANYNAME , 
COST_EXPIRED , 
COUNTRY , 
TO_CHAR(VENDORS.CREATE_DATE,'YYYY-MM-DD HH24:MI:SS') AS CREATE_DATE , 
TO_CHAR(CREDITLIMIT) AS CREDITLIMIT , 
REPLACE(REPLACE(VENDORS.CTC,CHR(10),' '),CHR(13),' ') AS CTC , 
TO_CHAR(VENDORS.CURRENCY_ID) AS CURRENCY_ID ,
CURRENCIES.NAME AS CURRENCY_NAME,
REPLACE(REPLACE(VENDORS.CUSTOMER_ID,CHR(10),' '),CHR(13),' ') AS CUSTOMER_ID , 
TO_CHAR(VENDORS.DATE_CUSTOMER_STATEMENT_SENT,'YYYY-MM-DD HH24:MI:SS') AS DATE_CUSTOMER_STATEMENT_SENT , 
TO_CHAR(VENDORS.DATE_LAST_MODIFIED,'YYYY-MM-DD HH24:MI:SS') AS DATE_LAST_MODIFIED , 
TO_CHAR(VENDORS.DECILE_ID) AS DECILE_ID , 
TO_CHAR(VENDORS.DEFAULT_DISCOUNT_ID) AS DEFAULT_DISCOUNT_ID , 
TO_CHAR(DEFAULT_DISCOUNT_RATE) AS DEFAULT_DISCOUNT_RATE , 
TO_CHAR(VENDORS.DEFAULT_WT_CODE_ID) AS DEFAULT_WT_CODE_ID , 
REPLACE(REPLACE(VENDORS.DELIVERY_INSTRUCTION,CHR(10),' '),CHR(13),' ') AS DELIVERY_INSTRUCTION , 
DIRECT_DEBIT , 
EFT_BILL_PAYMENT , 
EFT_CUSTOMER_REFUND_PAYMENT , 
TO_CHAR(VENDORS.EFT_FILE_FORMAT_ID) AS EFT_FILE_FORMAT_ID , 
ELIGIBLE_FOR_APPROVAL , 
REPLACE(REPLACE(VENDORS.EMAIL,CHR(10),' '),CHR(13),' ') AS EMAIL , 
REPLACE(REPLACE(VENDORS.EMAIL_ADDRESS,CHR(10),' '),CHR(13),' ') AS EMAIL_ADDRESS , 
REPLACE(REPLACE(VENDORS.EMAIL_ADDRESS_FOR_PAYMENT_NOT,CHR(10),' '),CHR(13),' ') AS EMAIL_ADDRESS_FOR_PAYMENT_NOT , 
REPLACE(REPLACE(VENDORS.EMAIL_ADDRESS_FOR_PAYMENT_NO_0,CHR(10),' '),CHR(13),' ') AS EMAIL_ADDRESS_FOR_PAYMENT_NO_0 , 
REPLACE(REPLACE(VENDORS.EMAIL_FOR_CUSTOMER_STATEMENT,CHR(10),' '),CHR(13),' ') AS EMAIL_FOR_CUSTOMER_STATEMENT , 
REPLACE(REPLACE(VENDORS.EMAIL_FOR_CUSTOMER_STATEMENT_,CHR(10),' '),CHR(13),' ') AS EMAIL_FOR_CUSTOMER_STATEMENT_ , 
REPLACE(REPLACE(VENDORS.EMAIL_FOR_CUSTOMER_STATEMENT_0,CHR(10),' '),CHR(13),' ') AS EMAIL_FOR_CUSTOMER_STATEMENT_0 , 
REPLACE(REPLACE(VENDORS.EMAIL_FOR_CUSTOMER_STATEMENT_1,CHR(10),' '),CHR(13),' ') AS EMAIL_FOR_CUSTOMER_STATEMENT_1 , 
TO_CHAR(VENDORS.EMPLOYEE_ID) AS EMPLOYEE_ID , 
TO_CHAR(VENDORS.EXPENSE_ACCOUNT_ID) AS EXPENSE_ACCOUNT_ID , 
REPLACE(REPLACE(VENDORS.FAIR_SIZE,CHR(10),' '),CHR(13),' ') AS FAIR_SIZE , 
TO_CHAR(VENDORS.FAIR_TYPE_ID) AS FAIR_TYPE_ID , 
REPLACE(REPLACE(VENDORS.FAX,CHR(10),' '),CHR(13),' ') AS FAX , 
FINANCIAL , 
TO_CHAR(VENDORS.FORWARDERS_ADDRESS_ID) AS FORWARDERS_ADDRESS_ID , 
REPLACE(REPLACE(VENDORS.FORWARDER_ADDRESS,CHR(10),' '),CHR(13),' ') AS FORWARDER_ADDRESS , 
TO_CHAR(VENDORS.FREIGHT_ESTIMATE_METHOD_ID) AS FREIGHT_ESTIMATE_METHOD_ID , 
TO_CHAR(FREIGHT_RATE) AS FREIGHT_RATE , 
REPLACE(REPLACE(VENDORS.FULL_NAME,CHR(10),' '),CHR(13),' ') AS FULL_NAME , 
REPLACE(REPLACE(VENDORS.HOME_PHONE,CHR(10),' '),CHR(13),' ') AS HOME_PHONE , 
REPLACE(REPLACE(VENDORS.INCOTERM,CHR(10),' '),CHR(13),' ') AS INCOTERM , 
IS1099ELIGIBLE , 
ISEMAILHTML , 
ISEMAILPDF , 
ISINACTIVE , 
IS_PERSON , 
TO_CHAR(LABOR_COST) AS LABOR_COST , 
TO_CHAR(VENDORS.LAST_MODIFIED_DATE,'YYYY-MM-DD HH24:MI:SS') AS LAST_MODIFIED_DATE , 
TO_CHAR(VENDORS.LAST_SALES_ACTIVITY,'YYYY-MM-DD HH24:MI:SS') AS LAST_SALES_ACTIVITY , 
REPLACE(REPLACE(VENDORS.LEGACY_CUSTOMER_IDCUSTOM,CHR(10),' '),CHR(13),' ') AS LEGACY_CUSTOMER_IDCUSTOM , 
REPLACE(REPLACE(VENDORS.LINE1,CHR(10),' '),CHR(13),' ') AS LINE1 , 
REPLACE(REPLACE(VENDORS.LINE2,CHR(10),' '),CHR(13),' ') AS LINE2 , 
REPLACE(REPLACE(VENDORS.LINE3,CHR(10),' '),CHR(13),' ') AS LINE3 , 
TO_CHAR(VENDORS.LINE_OF_BUSINESS_ID) AS LINE_OF_BUSINESS_ID ,
CLASSES.NAME AS LINE_OF_BUSINESS, 
LOGINACCESS , 
REPLACE(REPLACE(VENDORS.LSA_LINK,CHR(10),' '),CHR(13),' ') AS LSA_LINK , 
REPLACE(REPLACE(VENDORS.LSA_LINK_NAME,CHR(10),' '),CHR(13),' ') AS LSA_LINK_NAME , 
REPLACE(REPLACE(VENDORS.MOBILE_PHONE,CHR(10),' '),CHR(13),' ') AS MOBILE_PHONE , 
REPLACE(REPLACE(VENDORS.MOE_ID,CHR(10),' '),CHR(13),' ') AS MOE_ID , 
NAME , 
to_char(NO_OF_CHILDREN_ENROLLED) as NO_OF_CHILDREN_ENROLLED , 
REPLACE(REPLACE(VENDORS.OLD_CUSTOMER_CODE,CHR(10),' '),CHR(13),' ') AS OLD_CUSTOMER_CODE , 
REPLACE(REPLACE(VENDORS.OLD_PARENT_CODE,CHR(10),' '),CHR(13),' ') AS OLD_PARENT_CODE , 
to_char(OPENBALANCE) as OPENBALANCE, 
to_char(OPENBALANCE_FOREIGN) as OPENBALANCE_FOREIGN , 
to_char(OPENING_BALANCE) as OPENING_BALANCE , 
TO_CHAR(VENDORS.PAYABLES_ACCOUNT_ID) AS PAYABLES_ACCOUNT_ID , 
TO_CHAR(VENDORS.PAYMENT_TERMS_ID) AS PAYMENT_TERMS_ID , 
REPLACE(REPLACE(VENDORS.PHILHEALTH,CHR(10),' '),CHR(13),' ') AS PHILHEALTH , 
REPLACE(REPLACE(VENDORS.PHONE,CHR(10),' '),CHR(13),' ') AS PHONE , 
TO_CHAR(VENDORS.PRICE_GROUP_ID) AS PRICE_GROUP_ID , 
PRINTONCHECKAS , 
REPLACE(REPLACE(VENDORS.PROJECT_SCOPE_STATEMENT,CHR(10),' '),CHR(13),' ') AS PROJECT_SCOPE_STATEMENT , 
REPLACE(REPLACE(VENDORS.PROVIDENT_FUND_NUMBER,CHR(10),' '),CHR(13),' ') AS PROVIDENT_FUND_NUMBER , 
TO_CHAR(PURCHASEORDERAMOUNT) AS PURCHASEORDERAMOUNT , 
TO_CHAR(PURCHASEORDERQUANTITY) AS PURCHASEORDERQUANTITY , 
TO_CHAR(PURCHASEORDERQUANTITYDIFF) AS PURCHASEORDERQUANTITYDIFF , 
TO_CHAR(RECEIPTAMOUNT) AS RECEIPTAMOUNT , 
TO_CHAR(RECEIPTQUANTITY) AS RECEIPTQUANTITY , 
TO_CHAR(RECEIPTQUANTITYDIFF) AS RECEIPTQUANTITYDIFF , 
TO_CHAR(VENDORS.REGION_ID) AS REGION_ID , 
TO_CHAR(VENDORS.REWARDS_BAND_ID) AS REWARDS_BAND_ID , 
TO_CHAR(VENDORS.REWARD_EARNER_ID) AS REWARD_EARNER_ID , 
TO_CHAR(VENDORS.ROUTE_CODE_ID) AS ROUTE_CODE_ID , 
TO_CHAR(VENDORS.SALES_TERRITORYDO_NOT_USE_ID) AS SALES_TERRITORYDO_NOT_USE_ID , 
REPLACE(REPLACE(VENDORS.SCHEMAI1L_FOR_INVOICE,CHR(10),' '),CHR(13),' ') AS SCHEMAI1L_FOR_INVOICE , 
REPLACE(REPLACE(VENDORS.SCHEMAIL_FOR_INVOICE,CHR(10),' '),CHR(13),' ') AS SCHEMAIL_FOR_INVOICE , 
TO_CHAR(VENDORS.SCHOLASTIC_SALES_TERRITORY_ID) AS SCHOLASTIC_SALES_TERRITORY_ID , 
TO_CHAR(VENDORS.SELLING_RIGHTS_ID) AS SELLING_RIGHTS_ID , 
REPLACE(REPLACE(VENDORS.SHIPADDRESS,CHR(10),' '),CHR(13),' ') AS SHIPADDRESS , 
TO_CHAR(VENDORS.SHIPPING_PREFERENCE_ID) AS SHIPPING_PREFERENCE_ID , 
REPLACE(REPLACE(VENDORS.SNIPP_MEMBER_ID,CHR(10),' '),CHR(13),' ') AS SNIPP_MEMBER_ID , 
TO_CHAR(VENDORS.SOR_DISCOUNT_ID) AS SOR_DISCOUNT_ID , 
REPLACE(REPLACE(VENDORS.SOR_DURATION_FROM_DAYS,CHR(10),' '),CHR(13),' ') AS SOR_DURATION_FROM_DAYS , 
REPLACE(REPLACE(VENDORS.SOR_DURATION_TO_DAYS,CHR(10),' '),CHR(13),' ') AS SOR_DURATION_TO_DAYS , 
SOR_TAG , 
TO_CHAR(SOR_THRESHOLD) AS SOR_THRESHOLD , 
SPONSOR , 
STAPLES , 
STATE , 
SUBSIDIARY , 
SUBSIDIARIES.NAME AS SUBSIDIARY_NAME,
TAXIDNUM , 
REPLACE(REPLACE(VENDORS.TAX_CONTACT_FIRST_NAME,CHR(10),' '),CHR(13),' ') AS TAX_CONTACT_FIRST_NAME , 
TO_CHAR(VENDORS.TAX_CONTACT_ID) AS TAX_CONTACT_ID , 
REPLACE(REPLACE(VENDORS.TAX_CONTACT_LAST_NAME,CHR(10),' '),CHR(13),' ') AS TAX_CONTACT_LAST_NAME , 
REPLACE(REPLACE(VENDORS.TAX_CONTACT_MIDDLE_NAME,CHR(10),' '),CHR(13),' ') AS TAX_CONTACT_MIDDLE_NAME , 
THIRD_PARTY , 
REPLACE(REPLACE(VENDORS.TIN,CHR(10),' '),CHR(13),' ') AS TIN , 
TO_CHAR(TOTAL_QUANTITY) AS TOTAL_QUANTITY , 
TRANSACTIONS_NEED_APPROVAL , 
UEN , 
REPLACE(REPLACE(VENDORS.UK_OTC_CODE,CHR(10),' '),CHR(13),' ') AS UK_OTC_CODE , 
to_char(UNBILLED_ORDERS) as UNBILLED_ORDERS, 
to_char(UNBILLED_ORDERS_FOREIGN) as UNBILLED_ORDERS_FOREIGN, 
REPLACE(REPLACE(VENDORS.URL,CHR(10),' '),CHR(13),' ') AS URL , 
REPLACE(REPLACE(VENDORS.US_OTC_CODE,CHR(10),' '),CHR(13),' ') AS US_OTC_CODE , 
REPLACE(REPLACE(VENDORS.VAT_REGISTRATION_NO,CHR(10),' '),CHR(13),' ') AS VAT_REGISTRATION_NO , 
REPLACE(REPLACE(VENDORS.VENDOR_EXTID,CHR(10),' '),CHR(13),' ') AS VENDOR_EXTID , 
TO_CHAR(VENDORS.VENDOR_ID) AS VENDOR_ID , 
TO_CHAR(VENDORS.VENDOR_TYPE_ID) AS VENDOR_TYPE_ID , 
VENDOR_TYPES.NAME as VENDOR_TYPE,
ZIPCODE , 
TO_CHAR(VENDORS.ZONE_NUMBER_ID) AS ZONE_NUMBER_ID
FROM
VENDORS , CURRENCIES , CLASSES , SUBSIDIARIES , VENDOR_TYPES
WHERE VENDORS.DATE_LAST_MODIFIED >= '1900-01-01 00:00:00' 
AND VENDORS.CURRENCY_ID = CURRENCIES.CURRENCY_ID (+)
AND VENDORS.LINE_OF_BUSINESS_ID = CLASSES.CLASS_ID (+)
AND VENDORS.SUBSIDIARY = SUBSIDIARIES.SUBSIDIARY_ID (+)
AND VENDORS.VENDOR_TYPE_ID = VENDOR_TYPES.VENDOR_TYPE_ID (+);
