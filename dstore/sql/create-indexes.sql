create index if not exists xson_desc_narrative_idx on xson (
    root = '/iati-activities/iati-activity/description/narrative'
);
create index if not exists xson_desc_participating_org_idx on xson (
    root = '/iati-activities/iati-activity/participating-org'
);
create index if not exists xson_desc_recipient_region_idx on xson (
    root = '/iati-activities/iati-activity/recipient-region'
);
create index if not exists xson_root_description_narrative_idx on xson (
    root = '/iati-activities/iati-activity/description/narrative'
);
create index if not exists trans_has_sector_idx on trans (has_sector);
create index if not exists trans_has_matching_trans_code on trans (has_matching_trans_code);
create index if not exists trans_has_sector_idx on trans (has_matching_sector);
create index if not exists aid_trans_counts_fk_aid on aid_trans_counts(fk_aid);
create index if not exists act_has_matching_sector_trans_idx on act (has_matching_sector_trans);