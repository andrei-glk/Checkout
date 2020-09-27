use warehouse compute_wh;
use database demo_db;

use schema stg_users;
copy into demo_db.stg_users.user_daily_extract
(
id,postcode,extract_date
)
from (
 select
$1,$2,$3
FROM @users
(file_format => 'users_csv_format') t
) ON_ERROR = 'CONTINUE';


use schema stg_pageviews;
copy into stg_pageviews.pageview_extract
(
user_id,url,pageview_datetime
)
from (
 select
$1,$2,$3
FROM @pageviews
(file_format => 'pageviews_csv_format') t
) ON_ERROR = 'CONTINUE';