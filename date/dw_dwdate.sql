CREATE TABLE DW.DWDATE 
(
  DATE_KEY                  BIGINT IDENTITY(0,1),
  DATE_ID                   INTEGER,
  DAY_OF_CALENDAR_YEAR      INTEGER,
  DAY_NAME                  VARCHAR(20),
  CALENDAR_WEEK_NUMBER      INTEGER,
  WEEK_ENDED                DATE,
  CALENDAR_MONTH_BEGIN      DATE,
  CALENDAR_MONTH_END        DATE,
  CALENDAR_YEAR             INTEGER,
  DAY_OF_CALENDAR_MONTH     INTEGER,
  MONTH_NAME                VARCHAR(20),
  CALENDAR_MONTH_NUMBER     INTEGER,
  CALENDAR_QUARTER_NUMBER   INTEGER,
  FISCAL_YEAR_DAY_NUMBER    INTEGER,
  FISCAL_WEEK_NUMBER        INTEGER,
  FISCAL_QUARTER_NUMBER     INTEGER,
  FISCAL_MONTH_NUMBER       INTEGER,
  FISCAL_WEEK_BEGIN         DATE,
  FISCAL_WEEK_END           DATE,
  FISCAL_MONTH_BEGIN        DATE,
  FISCAL_MONTH_END          DATE,
  FISCAL_YEAR               INTEGER,
  HOLIDAY_IND               VARCHAR(10),
  FISCAL_YEAR_BEGIN         DATE,
  FISCAL_YEAR_END           DATE,
  PRIMARY KEY (DATE_KEY,DATE_ID)
)
DISTSTYLE ALL INTERLEAVED SORTKEY (DATE_KEY,DATE_ID);



COMMIT;
