use warehouse compute_wh;
use database demo_db;
use role accountadmin;

-- This will create a set of new streams in the current/specified schema 
-- A stream records data manipulation language (DML) changes made to a table, including information about inserts, updates, and deletes
use schema stg_users;
create stream user_stream on table user_daily_extract;
 
use schema stg_pageviews;
create stream pageviews_stream on table pageview_extract;

use schema stg_pageviews;
create stream mart_pageviews_stream on table pageview_history_fact;

-- This will create several new tasks and schedule them
-- A stream records data manipulation language (DML) changes made to a table, including information about inserts, updates, and deletes
 
use schema stg_users;
CREATE OR REPLACE TASK users_queue_task
  WAREHOUSE = compute_wh
  SCHEDULE = '60 minute'
WHEN
  SYSTEM$STREAM_HAS_DATA('USER_STREAM')
AS
  INSERT INTO user_history_fact(id,postcode,extract_date) SELECT id,postcode,extract_date FROM user_stream WHERE METADATA$ACTION = 'INSERT';

use schema stg_pageviews;
CREATE OR REPLACE TASK pageview_queue_task
  WAREHOUSE = compute_wh
  SCHEDULE = '60 minute'
WHEN
  SYSTEM$STREAM_HAS_DATA('PAGEVIEWS_STREAM')
AS
  INSERT INTO pageview_history_fact(user_id,url,pageview_datetime) SELECT user_id,url,pageview_datetime FROM pageviews_stream WHERE METADATA$ACTION = 'INSERT';

CREATE OR REPLACE TASK mart_pageview_queue_task
  WAREHOUSE = compute_wh
WHEN
  SYSTEM$STREAM_HAS_DATA('MART_PAGEVIEWS_STREAM')
AS
INSERT OVERWRITE INTO datamart.pageviews (id,postcode,pageview_date,postcode_latest_flag,url,pageview_datetime)
SELECT id,postcode,extract_date,postcode_latest_flag,url,pageview_datetime
FROM transform_all.v_pageviews;

alter task mart_pageview_queue_task add after demo_db.stg_pageviews.pageview_queue_task;

-- all the tasks are suspended by default and must be resumed manually
use schema stg_users;
alter task users_queue_task resume;

use schema stg_pageviews;
alter task mart_pageview_queue_task resume;
alter task pageview_queue_task resume;
