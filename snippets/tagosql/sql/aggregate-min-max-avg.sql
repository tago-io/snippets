-- @title: Aggregate Min, Max And Average
-- @description: Compute per-variable statistics on the server instead of fetching raw data
-- @tags: device, aggregation, average, min, max, group by

-- Aggregations run on the server: one small result row per variable instead of
-- thousands of raw readings.
--   $1 = device id
--   $2 = start of the time window, ISO 8601
SELECT variable,
       COUNT(*) AS readings,
       MIN(value) AS min_value,
       MAX(value) AS max_value,
       AVG(value) AS avg_value
FROM device($1) AS d
WHERE time > $2
GROUP BY variable
ORDER BY variable
