-- @title: Latest Data From One Device
-- @description: Read the most recent readings stored on a single device
-- @tags: device, data, select, basic

-- The simplest TagoSQL query: the last 10 readings of a device, newest first.
-- device('id') reads the time-series data stored on that device.
-- Replace DEVICE_ID with a device id from your profile.
SELECT variable, value, unit, time
FROM device('DEVICE_ID') AS d
ORDER BY time DESC
LIMIT 10
