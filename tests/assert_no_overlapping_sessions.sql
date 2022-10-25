select
    sc1.visitorid || '_' || cast(sc2.session_sequence as varchar) as session_id
from {{ ref('sessionized_clicks') }} sc1
join {{ ref('sessionized_clicks') }} sc2
on sc1.session_started > sc2.session_ended and sc1.session_ended < sc2.session_started and sc1.visitorid = sc2.visitorid
