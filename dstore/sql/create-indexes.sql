create index xson_desc_narrative_idx on xson (root = '/iati-activities/iati-activity/description/narrative');
create index xson_desc_participating_org_idx on xson (root = '/iati-activities/iati-activity/participating-org');
create index xson_desc_recipient_region_idx on xson (root = '/iati-activities/iati-activity/recipient-region');
create index xson_root_description_narrative_idx on xson (root = '/iati-activities/iati-activity/description/narrative');