update act
set act.has_matching_sector_act = true
where act.aid in (
        select distinct aid
        from sector
        where sector_code in (
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
    );