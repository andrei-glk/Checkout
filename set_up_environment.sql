use warehouse compute_wh;
use database demo_db;

drop schema if exists stg_users;
drop schema if exists stg_pageviews;
drop schema if exists transform_all;
drop schema if exists datamart;

create or replace schema stg_users;
create or replace stage users url='s3://checkout-users/' credentials=(aws_key_id='your_aws_keyid' aws_secret_key='your_aws_secret_key');
create or replace file format users_csv_format COMPRESSION = 'AUTO' FIELD_DELIMITER = ',' RECORD_DELIMITER = '\n' SKIP_HEADER = 1 FIELD_OPTIONALLY_ENCLOSED_BY = '\042' TRIM_SPACE = FALSE ERROR_ON_COLUMN_COUNT_MISMATCH = TRUE ESCAPE = '\134' ESCAPE_UNENCLOSED_FIELD = '\134' DATE_FORMAT = 'AUTO'  NULL_IF = "";


create or replace schema stg_pageviews;
create or replace stage pageviews url='s3://checkout-pageviews/' credentials=(aws_key_id='your_aws_keyid' aws_secret_key='your_aws_secret_key');
create or replace file format pageviews_csv_format COMPRESSION = 'AUTO' FIELD_DELIMITER = ',' RECORD_DELIMITER = '\n' SKIP_HEADER = 1 FIELD_OPTIONALLY_ENCLOSED_BY = '\042' TRIM_SPACE = FALSE ERROR_ON_COLUMN_COUNT_MISMATCH = TRUE ESCAPE = '\134' ESCAPE_UNENCLOSED_FIELD = '\134' DATE_FORMAT = 'AUTO'  NULL_IF = "";


create or replace schema transform_all;
create or replace schema datamart;