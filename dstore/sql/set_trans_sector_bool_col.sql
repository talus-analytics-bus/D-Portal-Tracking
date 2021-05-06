update act
set has_matching_sector_trans = true
where aid in (
        select distinct aid
        from trans
        where trans_sector in (
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