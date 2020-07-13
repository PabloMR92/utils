SELECT
    i.relname as index_name,
    t.relname as table_name,
    i.reltuples AS "entries",
    pg_size_pretty(i.relpages :: bigint * 8 * 1024) AS size,
    pg_get_indexdef(ix.indexrelid) AS def
from
    pg_class t
    INNER JOIN pg_index ix on t.oid = ix.indrelid
    INNER JOIN pg_class i ON i.oid = ix.indexrelid
where
    t.relkind = 'r'
    AND t.relowner = (
        SELECT
            datdba
        from
            pg_database
        WHERE
            datname = current_database()
    )
ORDER BY
    i.relpages DESC;