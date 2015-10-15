create schema if not exists dw_prestage ;

drop table if exists dw_prestage.employees;

create table dw_prestage.employees
( 
 RUNID                  INTEGER
,ABCD_MARKER_ID 	INTEGER
,ACCOUNTNUMBER 	VARCHAR(4000)
,ACTUAL_COST 	DECIMAL(22,2)
,ADDRESS 	VARCHAR(999)
,ALTERNATE_CUSTOMER_EMAIL 	VARCHAR(255)
,ALTERNATE_CUSTOMER_EMAIL1 	VARCHAR(255)
,ALTERNATE_CUSTOMER_EMAIL2 	VARCHAR(255)
,APPLY_FREIGHT 	VARCHAR(1)
,APPROVALLIMIT 	DECIMAL(20,2)
,APPROVER_ID 	INTEGER
,BACKORDERS_ALLOWED 	VARCHAR(1)
,BACK_ORDER_SPLIT 	VARCHAR(1)
,BILLING_CLASS_ID 	INTEGER
,BIRTHDATE 	TIMESTAMP
,BOOK_FAIRS_CONSULTANT_ID 	INTEGER
,BOOK_FAIR_ABCD_MARKER 	VARCHAR(4000)
,BOOK_FAIR_SIZE_ID 	INTEGER
,BRN 	VARCHAR(16)
,BUSINESS_STYLE_ID 	INTEGER
,CARRIER_ADDRESS 	VARCHAR(4000)
,CARRIER_LABEL_ID 	INTEGER
,CITY 	VARCHAR(50)
,CLASS_ID 	INTEGER
,COMMENTS 	VARCHAR(4000)
,COST_EXPIRED 	VARCHAR(1)
,COUNTRY 	VARCHAR(50)
,CREATE_DATE 	TIMESTAMP
,CTC 	VARCHAR(4000)
,CUSTOMER_ID 	VARCHAR(4000)
,DATE_CUSTOMER_STATEMENT_SENT 	TIMESTAMP
,DATE_LAST_MODIFIED 	TIMESTAMP
,DECILE_ID 	INTEGER
,DEFAULT_DISCOUNT_ID 	INTEGER
,DEFAULT_DISCOUNT_RATE 	DECIMAL(22,2)
,DEFAULT_WT_CODE_ID 	INTEGER
,DELIVERY_INSTRUCTION 	VARCHAR(4000)
,DEPARTMENT_ID 	INTEGER
,DIRECT_DEBIT 	VARCHAR(1)
,EFT_BILL_PAYMENT 	VARCHAR(1)
,EFT_CUSTOMER_REFUND_PAYMENT 	VARCHAR(1)
,EFT_FILE_FORMAT_ID 	INTEGER
,ELIGIBLE_FOR_APPROVAL 	VARCHAR(1)
,EMAIL 	VARCHAR(254)
,EMAIL_ADDRESS 	VARCHAR(255)
,EMAIL_ADDRESS_FOR_PAYMENT_NOT 	VARCHAR(255)
,EMAIL_ADDRESS_FOR_PAYMENT_NO_0 	VARCHAR(4000)
,EMAIL_FOR_CUSTOMER_STATEMENT 	VARCHAR(255)
,EMAIL_FOR_CUSTOMER_STATEMENT_ 	VARCHAR(255)
,EMAIL_FOR_CUSTOMER_STATEMENT_0 	VARCHAR(255)
,EMAIL_FOR_CUSTOMER_STATEMENT_1 	VARCHAR(255)
,EMPLOYEE_EXTID 	VARCHAR(255)
,EMPLOYEE_ID 	INTEGER
,EMPLOYEE_ID_0 	DECIMAL(22,0)
,EMPLOYEE_TYPE_ID 	INTEGER
,FAIR_SIZE 	VARCHAR(4000)
,FAIR_TYPE_ID 	INTEGER
,FINANCIAL 	VARCHAR(1)
,FIRSTNAME 	VARCHAR(32)
,FORWARDERS_ADDRESS_ID 	INTEGER
,FORWARDER_ADDRESS 	VARCHAR(4000)
,FREIGHT_ESTIMATE_METHOD_ID 	INTEGER
,FREIGHT_RATE 	DECIMAL(22,0)
,FULL_NAME 	VARCHAR(1800)
,HIREDDATE 	TIMESTAMP
,INITIALS 	VARCHAR(3)
,ISINACTIVE 	VARCHAR(3)
,ISSALESREP 	VARCHAR(3)
,ISSUPPORTREP 	VARCHAR(3)
,JOBTITLE 	VARCHAR(100)
,LABOR_COST 	DECIMAL(22,0)
,LASTNAME 	VARCHAR(32)
,LASTREVIEWDATE 	TIMESTAMP
,LAST_MODIFIED_DATE 	TIMESTAMP
,LAST_SALES_ACTIVITY 	TIMESTAMP
,LEGACY_CUSTOMER_IDCUSTOM 	VARCHAR(4000)
,LINE1 	VARCHAR(150)
,LINE2 	VARCHAR(150)
,LINE3 	VARCHAR(150)
,LINE_OF_BUSINESS_ID 	INTEGER
,LOCATION_ID 	INTEGER
,LOGINACCESS 	VARCHAR(3)
,LSA_LINK 	VARCHAR(255)
,LSA_LINK_NAME 	VARCHAR(4000)
,MIDDLENAME 	VARCHAR(32)
,MOE_ID 	VARCHAR(4000)
,NAME 	VARCHAR(83)
,NEXTREVIEWDATE 	TIMESTAMP
,NO_OF_CHILDREN_ENROLLED 	DECIMAL(22,0)
,OLD_CUSTOMER_CODE 	VARCHAR(4000)
,OLD_PARENT_CODE 	VARCHAR(4000)
,OPENING_BALANCE 	DECIMAL(22,8)
,PHILHEALTH 	VARCHAR(4000)
,PHONE 	VARCHAR(100)
,PRICE_GROUP_ID 	INTEGER
,PROJECT_SCOPE_STATEMENT 	VARCHAR(4000)
,PROVIDENT_FUND_NUMBER 	VARCHAR(4000)
,REGION_ID 	INTEGER
,RELEASEDATE 	TIMESTAMP
,REWARDS_BAND_ID 	INTEGER
,REWARD_EARNER_ID 	INTEGER
,ROUTE_CODE_ID 	INTEGER
,SALES_TERRITORYDO_NOT_USE_ID 	INTEGER
,SALUTATION 	VARCHAR(30)
,SCHEMAI1L_FOR_INVOICE 	VARCHAR(255)
,SCHEMAIL_FOR_INVOICE 	VARCHAR(255)
,SCHOLASTIC_SALES_TERRITORY_ID 	INTEGER
,SELLING_RIGHTS_ID 	INTEGER
,SHIPPING_PREFERENCE_ID 	INTEGER
,SNIPP_MEMBER_ID 	VARCHAR(4000)
,SOCIALSECURITYNUMBER 	VARCHAR(11)
,SOR_DISCOUNT_ID 	INTEGER
,SOR_DURATION_FROM_DAYS 	VARCHAR(4000)
,SOR_DURATION_TO_DAYS 	VARCHAR(4000)
,SOR_TAG 	VARCHAR(1)
,SOR_THRESHOLD 	DECIMAL(22,0)
,SPONSOR 	VARCHAR(1)
,STAPLES 	VARCHAR(1)
,STATE 	VARCHAR(50)
,STATUS 	VARCHAR(100)
,SUBSIDIARY_ID 	INTEGER
,SUPERVISOR_ID 	INTEGER
,TAX_CONTACT_FIRST_NAME 	VARCHAR(4000)
,TAX_CONTACT_ID 	INTEGER
,TAX_CONTACT_LAST_NAME 	VARCHAR(4000)
,TAX_CONTACT_MIDDLE_NAME 	VARCHAR(4000)
,THIRD_PARTY 	VARCHAR(1)
,TIN 	VARCHAR(4000)
,TOTAL_QUANTITY 	DECIMAL(22,8)
,TRANSACTIONS_NEED_APPROVAL 	VARCHAR(1)
,UEN 	VARCHAR(16)
,UK_OTC_CODE 	VARCHAR(4000)
,US_OTC_CODE 	VARCHAR(4000)
,VAT_REGISTRATION_NO 	VARCHAR(4000)
,WORK_CALENDAR_ID 	INTEGER
,ZIPCODE 	VARCHAR(36)
,ZONE_NUMBER_ID 	INTEGER
,SUPERVISOR_NAME	VARCHAR(200)
,APPROVER_NAME	VARCHAR(200)
,SUBSIDIARY	VARCHAR(83)
,LINE_OF_BUSINESS	VARCHAR(2000)
,LOCATION	VARCHAR(31)
,COST_CENTER	VARCHAR(2000)
,PRIMARY KEY ( EMPLOYEE_ID , FULL_NAME) )
DISTSTYLE ALL
INTERLEAVED SORTKEY (EMPLOYEE_ID , FULL_NAME);

