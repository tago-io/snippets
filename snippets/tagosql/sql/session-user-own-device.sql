-- @title: Latest Data From The Signed-In User's Device
-- @description: Read recent data from the device tagged with the executing Run user's id
-- @tags: session, run user, device_tag, session_user_id

-- session_user_id() is filled by the server with the id of the Run user executing
-- the query. Tag each user's device as owner=<run user id> and this one stored
-- query serves every user with only their own readings. The optional argument is
-- a default id for the profile owner while authoring; real users always resolve
-- to their own id, and a user with no matching device gets an empty result.
--   $1 = start of the time window, ISO 8601
SELECT variable, value, unit, time
FROM device_tag('owner', session_user_id('6a4ff908be1ad0000bf49a2d')) AS d
WHERE time > $1
ORDER BY time DESC
LIMIT 50
