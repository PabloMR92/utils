SELECT
    bl.pid as blocked_pid,
    kl.pid as blocking_pid,
    bl.mode as blocked_lock,
    kl.mode as blocking_lock,
    bl.transactionid as blocked_transaction_id,
    kl.transactionid as blocking_transaction_id,
    now() - a.query_start as blocked_duration,
    now() - ka.query_start as blocking_duration,
    a.query as blocked_statement,
    ka.query as blocking_statement
FROM
    pg_catalog.pg_locks bl
    JOIN pg_catalog.pg_stat_activity a on bl.pid = a.pid
    JOIN pg_catalog.pg_locks kl
    JOIN pg_catalog.pg_stat_activity ka on kl.pid = ka.pid ON bl.transactionid = kl.transactionid
    AND bl.pid != kl.pid
WHERE
    not bl.granted;