-- @title: Latest Value Across A Fleet By Tag
-- @description: Get the newest reading of a variable from every device matching a tag, in one query
-- @tags: fleet, tags, multiple devices, device_data_by_tag

-- device_data_by_tag('key','value') is the fleet function: one row per active device
-- carrying the tag, each with that device's newest reading matching your filters.
-- A variable filter and a time lower bound are required; up to 5 tag pairs can be
-- listed (AND-combined). For fleets above your plan's device cap, page with the
-- after_device field of the execute request body.
--   $1 = start of the time window, ISO 8601 (devices silent since then are skipped)
SELECT device, device_name, variable, value, unit, time
FROM device_data_by_tag('type', 'sensor') AS f
WHERE variable = 'temperature'
  AND time > $1
ORDER BY device
