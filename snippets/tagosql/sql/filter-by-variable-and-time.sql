-- @title: Filter By Variable And Time Window
-- @description: Read one variable from a device inside a time window using query parameters
-- @tags: device, data, parameters, filter, time

-- Positional parameters ($1, $2, ...) keep values out of the query text: store the
-- query once and send different values on each execution.
--   $1 = device id        (example: "6a033c5b0528f6000c2ac5ee")
--   $2 = variable name    (example: "temperature")
--   $3 = start of the time window, ISO 8601 (example: "2026-07-01T00:00:00Z")
SELECT variable, value, unit, time
FROM device($1) AS d
WHERE variable = $2
  AND time > $3
ORDER BY time DESC
LIMIT 100
