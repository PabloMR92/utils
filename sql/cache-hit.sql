SELECT
  'Database Hit Rate' AS name,
  SUM(blks_read) AS block_read,
  SUM(blks_hit) AS block_hit,
  SUM(blks_hit) / NULLIF(SUM(blks_hit + blks_read),0) AS ratio
FROM
  pg_stat_database
WHERE
  datname = current_database()
UNION ALL
SELECT
  'Index Hit Rate' AS name,
  SUM(idx_blks_read) AS block_read,
  SUM(idx_blks_hit) AS block_hit,
  SUM(idx_blks_hit) / NULLIF(SUM(idx_blks_hit + idx_blks_read),0) AS ratio
FROM
  pg_statio_user_indexes
UNION ALL
SELECT
  'Table Hit Rate' AS name,
  SUM(heap_blks_read) as block_read,
  SUM(heap_blks_hit)  as block_hit,
  SUM(heap_blks_hit) / NULLIF(SUM(heap_blks_hit + heap_blks_read),0) AS ratio
FROM
  pg_statio_user_tables;