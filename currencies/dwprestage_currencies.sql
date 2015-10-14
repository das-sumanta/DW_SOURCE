create schema if not exists dw_prestage ;

drop table if exists dw_prestage.currencies;

create table dw_prestage.currencies
( 
RUNID	INTEGER
,CURRENCY_EXTID	VARCHAR(255)
,CURRENCY_ID	INTEGER
,DATE_LAST_MODIFIED	TIMESTAMP
,IS_INACTIVE	VARCHAR(3)
,NAME	VARCHAR(105)
,PRECISION_0	DECIMAL(1,0)
,SYMBOL	VARCHAR(4));
