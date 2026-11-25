-- Task 1: average session length (sessions longer than 5 minutes),
-- cohort 11-12.2022 (1) vs other cohorts (0)
select
    case when extract(month from u.reg_date) in (11, 12)
        then 1 else 0 end as cohorts
    , round(extract(epoch from avg(s.end_session - s.start_session))/60) as avg_time_minutes
    , count(*) as cnt_sessions
from skygame.users u
    join skygame.game_sessions s
    on u.id_user = s.id_user
where s.end_session - s.start_session > interval '5 minutes'
group by cohorts;


-- Task 2: K-factor and expected size of a future average monthly cohort
with k_factor as (
select avg_invite_per_user * reg_success_rate as k_factor
from (
    select count(r.id_user) * 1.00 / count(distinct u.id_user) as avg_invite_per_user
        , sum(r.ref_reg) * 1.00 / count(r.id_user) as reg_success_rate
    from skygame.referral r
        right join skygame.users u
        on r.id_user = u.id_user
    ) t1
),

cohorts as (
select avg(cohort_size) as avg_cohort_size
from (
    select date_trunc('month', reg_date) as cohort_month
        , count(distinct id_user) as cohort_size
    from skygame.users
    group by cohort_month
    ) t2
)

select k.k_factor
    , c.avg_cohort_size
    , k.k_factor * c.avg_cohort_size as result
from k_factor k
cross join cohorts c;
