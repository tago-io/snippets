-- @title: Device Inventory
-- @description: List your devices with their type, network, and last activity
-- @tags: devices, inventory, list, metadata

-- devices() lists your device inventory (metadata, not stored data). Useful to
-- find silent devices: sort by last_input to see which stopped reporting.
-- devices_tag('key','value') is the same table restricted to one tag.
-- To read each device's configuration parameters, see device-configuration-params.
SELECT id, name, active, type, network, last_input
FROM devices() AS d
WHERE active = true
ORDER BY last_input DESC
LIMIT 100
