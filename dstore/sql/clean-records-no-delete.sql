--
-- Retain GHS-relevant records.sql
-- Mike Van Maele, Talus Analytics, LLC
-- mvanmaele@talusanalytics.com
-- 11 March 2020
--
-- Add columns to flag records that have incorrect sectors or transactions
alter table trans
add column has_sector boolean;
create index trans_has_sector_idx on trans (has_sector);
update trans
set has_sector = trans_sector is not null;
alter table trans
add column has_matching_trans_code boolean;
create index trans_has_matching_trans_code on trans (has_matching_trans_code);
update trans
set has_matching_trans_code = trans_code in ('C', 'D', 'E');
alter table trans
add column has_matching_sector boolean;
create index if not exists trans_has_sector_idx on trans (has_matching_sector);
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
alter table act
add column has_matching_sector_trans boolean;
create index act_has_matching_sector_trans_idx on act (has_matching_sector_trans);
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
where exists (
        select distinct aid
        from trans
        where aid = act.aid
    );
-- mark act as having GHS-relevant sector or not at the act level -------------
alter table act
add column act_has_ghs_sector boolean;
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
alter table act
add column act_or_trans_has_ghs_sector boolean;
update act
set act_or_trans_has_ghs_sector = (
        act_has_ghs_sector
        or has_matching_sector_trans
    );
-- count total value and number of transactions of each project ---------------
create table aid_trans_counts as
select aid as "fk_aid",
    count(*) as "n_trans",
    sum(
        case
            when trans_code in ('E', 'D') then trans_usd
            else 0
        end
    ) as "sum_disb",
    sum(
        case
            when trans_code = 'C' then trans_usd
            else 0
        end
    ) as "sum_comm"
from trans
group by aid
order by aid;
create index aid_trans_counts_fk_aid on aid_trans_counts(fk_aid);
-- store min and max transaction dates on activities --------------------------
alter table act
add column trans_day_min int;
alter table act
add column trans_day_max int;
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
-- create table to define repaired activity titles and descriptions
create table if not exists act_repairs (
    fk_aid text primary key,
    description text,
    title text,
    description_was_repaired boolean not null,
    title_was_repaired boolean not null
)
update trans
set trans_country = '_NONE_'
where trans_country is null;