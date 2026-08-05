-- @title: Device Configuration Parameters
-- @description: Read the key/value configuration parameters stored on each device
-- @tags: devices, params, configuration, json

-- The params column returns one json element per device parameter, ordered by key,
-- in the same shape as the REST params API: { id, key, value, sent }. A device with
-- no parameters returns an empty array. The element id is the parameter row id, so
-- the values you read here can be edited or deleted through the REST params
-- endpoints. params is selectable only: it carries no comparison semantics, so it
-- cannot appear in WHERE, GROUP BY, ORDER BY, or inside an aggregate.
SELECT id, name, params
FROM devices() AS d
WHERE d.active = true
LIMIT 100
