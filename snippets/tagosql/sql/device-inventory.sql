-- @title: Device Inventory
-- @description: List your devices with their type, network, and last activity
-- @tags: devices, inventory, list, metadata

-- devices() lists your device inventory (metadata, not stored data). Useful to
-- find silent devices: sort by last_input to see which stopped reporting.
-- devices_tag('key','value') is the same table restricted to one tag.
SELECT id, name, active, type, last_input
FROM devices() AS d
WHERE active = true
ORDER BY last_input DESC
LIMIT 100
