-- Set all to false
update flow f set capacity = false

-- Set parents to correct val
update flow set capacity = true
where flow_info -> 'core_capacities' ->> 0 != 'Unspecified'
and flow_type_id = 5

-- Update children
update flow c
set capacity = true
from flow p
where p.flow_id = c.parent
and c.flow_type_id != 5
and p.flow_type_id = 5
and p.capacity = true

-- -- Any non-IATI projects with Unspec? There shouldn't be.
-- select * from flow
-- where data_sources != '{IATI Registry}'
-- and flow_info -> 'core_capacities' ->> 0 is null
-- and flow_type_id = 5