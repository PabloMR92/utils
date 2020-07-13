SELECT
    relname AS table,
    indexrelname AS index,
    pg_size_pretty(pg_relation_size(i.indexrelid)) AS index_size,
    idx_scan as index_scans
FROM
    pg_stat_user_indexes ui
    JOIN pg_index i ON ui.indexrelid = i.indexrelid
WHERE
    NOT indisunique
    AND idx_scan < 50
    AND pg_relation_size(relid) > 5 * 8192
    AND 0 != ALL (i.indkey) 
    AND NOT EXISTS (SELECT 1 FROM pg_catalog.pg_constraint c WHERE c.conindid = ui.indexrelid)
ORDER BY
    pg_relation_size(i.indexrelid) / nullif(idx_scan, 0) DESC NULLS FIRST,
    pg_relation_size(i.indexrelid) DESC;
