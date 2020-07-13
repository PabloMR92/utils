SELECT
    *
FROM
    (
        SELECT
            stat.relname AS table,
            stai.indexrelname AS index,
            CASE
                stai.idx_scan
                WHEN 0 THEN ' Insufficient data '
                ELSE (
                    100 * stai.idx_scan / (stat.seq_scan + stai.idx_scan)
                ) :: text || ' % '
            END hit_rate,
            CASE
                stat.idx_scan
                WHEN 0 THEN ' Insufficient data '
                ELSE (
                    100 * stat.idx_scan / (stat.seq_scan + stat.idx_scan)
                ) :: text || ' % '
            END all_index_hit_rate,
            ARRAY(
                SELECT
                    pg_get_indexdef(idx.indexrelid, k + 1, true)
                FROM
                    generate_subscripts(idx.indkey, 1) AS k
                ORDER BY
                    k
            ) AS cols,
            stat.n_live_tup rows_in_table
        FROM
            pg_stat_user_indexes AS stai
            JOIN pg_stat_user_tables AS stat ON stai.relid = stat.relid
            JOIN pg_index AS idx ON (idx.indexrelid = stai.indexrelid)
    ) AS sub_inner
ORDER BY
    rows_in_table DESC,
    hit_rate ASC;