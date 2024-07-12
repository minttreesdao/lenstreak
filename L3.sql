
-- lenstreak 

-- interaction (without posts)
select d.date, p.profile_id
from `intellilens.L2_date` d
left join `intellilens.L2_profile` p
on 1 = 1
left join `intellilens.L2_interaction` i
on i.interaction_date = d.date
and i.interaction_profile_id = p.profile_id

and i.interaction_profile_id in ('0x017566', '0x0f85')
and i.interaction_date_year_month >= '2024-07-01'

where d.date < '2024-07-12' 

and d.date >= '2024-07-01' 
and p.profile_id in ('0x017566', '0x0f85')

and i.interaction_profile_id is null

order by p.profile_id, d.date desc
;

-- post
select d.date, p.profile_id
from `intellilens.L2_date` d
left join `intellilens.L2_profile` p
on 1 = 1
left join `intellilens.L2_publication` pu
on pu.publication_date = d.date
and pu.profile_id = p.profile_id
and pu.publication_type = 'POST'

and pu.profile_id  in ('0x017566', '0x0f85')
and pu.publication_date_year_month >= '2024-07-01'

where d.date < '2024-07-12' 

and d.date >= '2024-07-01' 
and p.profile_id in ('0x017566', '0x0f85')

and pu.profile_id is null

order by p.profile_id, d.date desc
;

-- base streak query
select 
  base_rank.*
from
  (
  select 
    base.*
  , rank() over (partition by profile_id order by streak desc, date desc) as streak_rank
  from
    (
    select 
      d.date
    , p.profile_id
    , lead(d.date) over (partition by p.profile_id order by d.date desc) as date_before
    , date_diff(d.date, lead(d.date) over (partition by p.profile_id order by d.date desc), day) as streak
    from `intellilens.L2_date` d
    left join `intellilens.L2_profile` p
    on 1 = 1
    left join `intellilens.L2_publication` pu
    on pu.publication_date = d.date
    and pu.profile_id = p.profile_id
    and pu.publication_type = 'POST'
    and pu.publication_date < '2024-07-12'

    and pu.profile_id  in ('0x0f85')
    and pu.publication_date_year_month >= '2024-07-01'

    where d.date <= '2024-07-12' -- day after last publication date (-> end date)
    and d.date >= '2024-06-30'
    and d.date >= '2022-05-16' -- day before first publication date (-> start date)

    and p.profile_id in ('0x0f85')

    and pu.profile_id is null
    -- order by p.profile_id, d.date desc
    ) base
  ) base_rank
where streak_rank = 1
or date = '2024-07-12'


