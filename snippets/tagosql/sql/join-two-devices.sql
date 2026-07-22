-- @title: Correlate Two Devices With A JOIN
-- @description: Match readings from two devices by time to compare them side by side
-- @tags: device, join, correlation, multiple devices

-- JOINs combine data from multiple devices in one result (Starter plan or above).
-- Here a sensor's temperature is paired with an actuator's state recorded at the
-- same instant. Replace SENSOR_ID and ACTUATOR_ID with your device ids.
SELECT a.time,
       a.value AS temperature,
       b.value AS actuator_state
FROM device('SENSOR_ID') AS a
JOIN device('ACTUATOR_ID') AS b ON a.time = b.time
WHERE a.variable = 'temperature'
ORDER BY a.time DESC
LIMIT 50
