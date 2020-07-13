SELECT
    pid,
    age(now(), pg_stat_activity.query_start) AS duration,
    query,
    state
FROM
    pg_stat_activity
WHERE
    state != 'idle'
    AND pid != pg_backend_pid()
    AND datname = current_database()
    AND now() - pg_stat_activity.query_start > interval '5 seconds'
ORDER BY
    now() - pg_stat_activity.query_start DESC;