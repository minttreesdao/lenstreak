
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
;

-- L3_profile_score
CREATE OR REPLACE table intellilens.L3_profile_score AS
SELECT
  count(distinct profile_id) AS number_profile
, avg(date_diff('2024-07-12', profile_last_logged_in_date, DAY)) AS days_since_last_login
, avg(date_diff('2024-07-12', profile_creation_date, DAY)) AS days_since_profile_creation
, avg(profile_posts) AS profile_posts
, avg(profile_comments) AS profile_comments
, avg(profile_mirrors) AS profile_mirrors
, avg(profile_quotes) AS profile_quotes
, avg(profile_publications) AS profile_publications
, avg(profile_reacted) AS profile_reacted
, avg(profile_reactions) AS profile_reactions
, avg(profile_collects) AS profile_collects
, avg(profile_acted) AS profile_acted
, avg(profile_followers) AS profile_followers
, avg(profile_following) AS profile_following
, case  when score < 1000 then '0 - 1000'
		when score >= 1000 and score < 2000 then '1000 - 2000'
		when score >= 2000 and score < 3000 then '2000 - 3000'
		when score >= 3000 and score < 4000 then '3000 - 4000'
		when score >= 4000 and score < 5000 then '4000 - 5000'
		when score >= 5000 and score < 6000 then '5000 - 6000'
		when score >= 6000 and score < 7000 then '6000 - 7000'
		when score >= 7000 and score < 8000 then '7000 - 8000'
		when score >= 8000 and score < 9000 then '8000 - 9000'
		when score >= 9000 and score < 10000 then '9000 - 10000' 
		else 'unknown' end as score1000
FROM intellilens.L2_profile
-- where profile_id IN ('0x0f85', '0x017566')
GROUP BY case  when score < 1000 then '0 - 1000'
		when score >= 1000 and score < 2000 then '1000 - 2000'
		when score >= 2000 and score < 3000 then '2000 - 3000'
		when score >= 3000 and score < 4000 then '3000 - 4000'
		when score >= 4000 and score < 5000 then '4000 - 5000'
		when score >= 5000 and score < 6000 then '5000 - 6000'
		when score >= 6000 and score < 7000 then '6000 - 7000'
		when score >= 7000 and score < 8000 then '7000 - 8000'
		when score >= 8000 and score < 9000 then '8000 - 9000'
		when score >= 9000 and score < 10000 then '9000 - 10000' 
		else 'unknown' end 

