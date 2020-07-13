SELECT
    0 as priority,
    pg_database.datname AS objectname,
    'd' AS objecttype,
    0 :: real AS "#entries",
    pg_size_pretty(pg_database_size(pg_database.datname)) AS pretty_size,
    pg_database_size(pg_database.datname) as size
FROM
    pg_database
WHERE
    datname = current_database()
UNION
SELECT
    1 as priority,
    relname AS objectname,
    relkind AS objecttype,
    reltuples AS "#entries",
    pg_size_pretty(relpages :: bigint * 8 * 1024) AS pretty_size,
    relpages :: bigint * 8 * 1024 as size
FROM
    pg_class c
WHERE
    relpages >= 8
    AND c.relowner = (
        SELECT
            datdba
        from
            pg_database
        WHERE
            datname = current_database()
    )
ORDER BY
    priority,
    size DESC,
    "#entries";