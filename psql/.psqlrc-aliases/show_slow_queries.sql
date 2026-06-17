SELECT
  queryid,
  ((total_plan_time + total_exec_time) / 1000 / 60) as total_minutes,
  (total_plan_time + total_exec_time/calls) as average_time, query
FROM pg_stat_statements
ORDER BY 2 DESC
LIMIT 100;
