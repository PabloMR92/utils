SELECT
    indrelid :: regclass AS table,
    'Exact Match' AS type,
    array_agg(indexrelid :: regclass) AS indexes
FROM
    pg_index
GROUP BY
    indrelid,
    indkey
HAVING
    COUNT(*) > 1
UNION
ALL
SELECT
    indrelid :: regclass AS table,
    'Partial Match' AS type,
    array_agg(indexrelid :: regclass) AS indexes
FROM
    pg_index
GROUP BY
    indrelid,
    indkey [0]
HAVING
    COUNT(*) > 1
ORDER BY
    1 DESC;