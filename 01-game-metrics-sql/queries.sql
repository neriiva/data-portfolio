-- Task 1.1: DAU
select date_trunc ('day', start_session) as day
   , count (distinct id_user) as dau 
from skygame.game_sessions
   group by date_trunc ('day', start_session)
   order by day

-- Task 1.2: WAU
select date_trunc ('week', start_session) as week
   , count (distinct id_user) as wau
from skygame.game_sessions
   group by date_trunc ('week', start_session)
   order by week

-- Task 1.3: MAU
select date_trunc ('month', start_session) as month
   , count (distinct id_user) as mau 
from skygame.game_sessions
   group by date_trunc ('month', start_session)
   order by month

-----------------------------------------------------------------------------------------

-- Task 2: top 25 most engaged players (registered in 2022)
select * from (
   select game_sessions.id_user
      , sum(end_session - start_session) as full_len 
      , extract (year from reg_date) as year
   from skygame.game_sessions
      join skygame.users on game_sessions.id_user = users.id_user
   where end_session is not null
   group by game_sessions.id_user
      , users.reg_date
) t
where year = '2022'
   order by full_len desc 
   limit 25

------------------------------------------------------------------------------------------------------------

-- Task 3.1: number of sessions with missing end_session
select count(*)
from skygame.game_sessions
      join skygame.users on game_sessions.id_user = users.id_user
where end_session is null

-- Task 3.1: share of such sessions among all sessions, %
select (sum(case when end_session is null then 1 else 0 end) * 100.00) / count(*)
from skygame.game_sessions
      join skygame.users on game_sessions.id_user = users.id_user


-- Task 3.2: number of broken sessions on iOS
select count(*)
from skygame.game_sessions
      join skygame.users on game_sessions.id_user = users.id_user
where end_session is null
   and dev_type = 'ios'

-- Task 3.2: share of broken sessions among all iOS sessions, %
select (sum(case when end_session is null and dev_type = 'ios' then 1 else 0 end) * 100.00) / sum(case when dev_type = 'ios' then 1 else 0 end)
from skygame.game_sessions
      join skygame.users on game_sessions.id_user = users.id_user

-- Task 3.2: number of broken sessions on Android
select count(*)
from skygame.game_sessions
      join skygame.users on game_sessions.id_user = users.id_user
where end_session is null
   and dev_type = 'android'

-- Task 3.2: share of broken sessions among all Android sessions, %
select (sum(case when end_session is null and dev_type = 'android' then 1 else 0 end) * 100.00) / sum(case when dev_type = 'android' then 1 else 0 end)
from skygame.game_sessions
      join skygame.users on game_sessions.id_user = users.id_user


-- Task 3.3: iOS share among all broken sessions, %
select (sum(case when end_session is null and dev_type = 'ios' then 1 else 0 end) * 100.00) / count(*)
from skygame.game_sessions
      join skygame.users on game_sessions.id_user = users.id_user
where end_session is null

-- Task 3.3: Android share among all broken sessions, %
select (sum(case when end_session is null and dev_type = 'android' then 1 else 0 end) * 100.00) / count(*)
from skygame.game_sessions
      join skygame.users on game_sessions.id_user = users.id_user
where end_session is null
