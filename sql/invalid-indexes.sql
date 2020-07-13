SELECT
  t.relname AS index_name
FROM
  pg_class t,
  pg_index idx
WHERE
  idx.indisvalid = false AND
  idx.indexrelid = t.oid;