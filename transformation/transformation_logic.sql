use warehouse compute_wh;
use database demo_db;
use schema transform_all;

create or replace view transform_all.v_pageviews as 
select 
  id,
  postcode,
  extract_date,
  case when cume_dist() over (partition by id order by  extract_date asc) = 1 then 'Y' else 'N' end postcode_latest_flag,
  p.url,
  p.pageview_datetime
from demo_db.stg_users.user_history_fact u
   inner join demo_db.stg_pageviews.pageview_history_fact p on (u.id = p.user_id and to_varchar(extract_date) = to_varchar(pageview_datetime::date, 'yyyymmdd'));
