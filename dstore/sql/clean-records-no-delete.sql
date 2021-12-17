--
-- Retain GHS-relevant records.sql
-- Mike Van Maele, Talus Analytics, LLC
-- mvanmaele@talusanalytics.com
-- 11 March 2020
--
-- Add columns to flag records that have incorrect sectors or transactions
update trans
set has_sector = trans_sector is not null;
update trans
set has_matching_trans_code = trans_code in ('C', 'D', 'E');
update trans
set has_matching_sector = cast(trans_sector as integer) in (
        12110,
        12181,
        12182,
        12191,
        12220,
        12230,
        12240,
        12250,
        12261,
        12262,
        12263,
        12281,
        13010,
        13020,
        13030,
        13040,
        13081,
        31195,
        16064,
        32168
    );
update act
set has_matching_sector_trans = false;
update act
set has_matching_sector_trans = true
where aid in (
        select distinct aid
        from trans
        where has_matching_sector
            and aid = act.aid
    )
    and exists (
        select distinct aid
        from trans
        where aid = act.aid
    );
-- mark act as having GHS-relevant sector or not at the act level -------------
update act
set act_has_ghs_sector = false;
update act
set act_has_ghs_sector = true
where aid in (
        select aid
        from sector
        where aid = act.aid
            and cast(sector_code as integer) in (
                12110,
                12181,
                12182,
                12191,
                12220,
                12230,
                12240,
                12250,
                12261,
                12262,
                12263,
                12281,
                13010,
                13020,
                13030,
                13040,
                13081,
                31195,
                16064,
                32168
            )
    )
    and exists (
        select aid
        from sector
        where aid = act.aid
    );
update act
set act_or_trans_has_ghs_sector = (
        act_has_ghs_sector
        or has_matching_sector_trans
    );
-- store min and max transaction dates on activities --------------------------
UPDATE act
SET trans_day_min = temp.trans_day_min,
    trans_day_max = temp.trans_day_max
FROM (
        select t.aid,
            max(t.trans_day) as trans_day_max,
            min(t.trans_day) as trans_day_min
        from act a
            join trans t on a.aid = t.aid
        group by t.aid
    ) AS temp
WHERE act.aid = temp.aid;
update trans
set trans_country = '_NONE_'
where trans_country is null
    or trans_country = '';