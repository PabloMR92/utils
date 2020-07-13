SELECT
    client_addr,
    usename,
    COUNT(*),
    SUM(
        CASE
            state
            when 'idle' then 1
            else 0
        end
    ) as idle,
    SUM(
        CASE
            state
            when 'idle in transaction' then 1
            else 0
        end
    ) as "idle in transaction",
    SUM(
        CASE
            state
            when 'active' then 1
            else 0
        end
    ) as active
FROM
    pg_stat_activity
GROUP BY
    client_addr,
    usename
ORDER BY
    count DESC;