-- @title: Fleet Scoped To The Signed-In User
-- @description: One stored query that shows each Run user only the devices carrying their own customer tag
-- @tags: session, run user, fleet, device_data_by_tag, session_user_tag

-- session_user_tag('key') is filled by the server with the tag value of the user
-- executing the query: tag your devices and your Run users with the same key
-- (customer=acme on both) and every user sees only their fleet. The value never
-- comes from the request, and a user without the tag gets an empty result.
-- The second argument is an optional default, used only when the profile owner
-- runs the query while authoring.
--   $1 = start of the time window, ISO 8601
SELECT device, device_name, variable, value, unit, time
FROM device_data_by_tag('customer', session_user_tag('customer', 'acme')) AS f
WHERE variable = 'temperature'
  AND time > $1
ORDER BY device
