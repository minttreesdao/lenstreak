-- streak result query
SELECT 
  st.profile_id
, qp.profile_name
, CONCAT("@", nsh.handle) AS handle
, st.date AS streak_end_date
, st.date_before AS streak_start_date
, st.streak AS streak_days
, qp.score AS profile_score
FROM intellilens.L3_streaks st
LEFT JOIN intellilens.L2_profile qp
  ON qp.profile_id = st.profile_id
LEFT JOIN `lens-public-data.v2_polygon.profile_record` pr
  ON pr.profile_id = st.profile_id
LEFT JOIN `lens-public-data.v2_polygon.namespace_handle` nsh
  ON pr.owned_by = nsh.owned_by
-- where st.profile_id in ('0x012b8f', '0x01a9c0', '0x01a5d6', '0x01b19a', '0x01fa20')
ORDER BY streak DESC
