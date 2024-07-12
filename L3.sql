
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


