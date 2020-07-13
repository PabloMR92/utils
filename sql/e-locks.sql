SELECT
    pg_stat_activity.pid,
    pg_class.relname,
    pg_locks.transactionid,
    pg_locks.mode,
    pg_locks.locktype,
    pg_locks.granted,
    SUBSTRING(pg_stat_activity.query, 1, 50) AS query_snippet,
    age(now(), pg_stat_activity.query_start) AS duration
FROM
    pg_stat_activity,
    pg_locks
    LEFT JOIN pg_class ON (pg_locks.relation = pg_class.oid)
WHERE
    pg_locks.pid = pg_stat_activity.pid
    AND pg_locks.mode = 'ExclusiveLock'
    AND pg_stat_activity.pid != pg_backend_pid()
    AND pg_stat_activity.query != '<insufficient privilege>'
ORDER BY
    query_start;