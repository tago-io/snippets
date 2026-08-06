-- @title: Data From One Device Selected By Tag
-- @description: Read recent data from the single device that carries a given tag
-- @tags: device_tag, tags, device, data

-- device_tag('key','value') resolves to the FIRST device in your profile carrying
-- the tag, deterministic by device id, and reads its stored data. Use it for tags
-- that identify exactly one device (one gateway per site, for example). When
-- several devices share the tag, only one is read: use device('DEVICE_ID') for a
-- specific device, or device_data_by_tag to fan out across all of them.
SELECT variable, value, unit, time
FROM device_tag('device_type', 'gateway') AS d
ORDER BY time DESC
LIMIT 50
