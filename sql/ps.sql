SELECT
    pid,
    usename,
    now() - query_start as duration,
    state,
    CASE
        WHEN wait_event_type = 'Lock' THEN true
        ELSE FALSE
    END as blocked,
    query
FROM
    pg_stat_activity
WHERE
    query_start IS NOT NULL
    AND state != 'idle'
ORDER BY
    duration DESC, blocked;