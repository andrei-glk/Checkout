use warehouse compute_wh;
use database demo_db;

use schema stg_users;
create or replace table user_daily_extract
(
 id integer,
 postcode varchar,
 extract_date integer
);

create or replace table user_history_fact
(
 id integer,
 postcode varchar,
 extract_date integer
);

use schema stg_pageviews;

create or replace table pageview_extract
(
 user_id integer,
 url varchar,
 pageview_datetime timestamp_ntz
);

create or replace table pageview_history_fact
(
 user_id integer,
 url varchar,
 pageview_datetime timestamp_ntz
);

use schema datamart;
create or replace TABLE pageviews (
	ID INTEGER,
	POSTCODE VARCHAR,
	PAGEVIEW_DATE INTEGER,
	POSTCODE_LATEST_FLAG CHAR(1),
	URL VARCHAR,
    PAGEVIEW_DATETIME TIMESTAMP_NTZ(9)
);
