-- @title: Devices Filtered By Tag
-- @description: List the devices carrying one tag and spot the ones that stopped reporting
-- @tags: devices, devices_tag, tags, inventory, params

-- devices_tag('key','value') is the device inventory restricted to devices carrying
-- that tag. Sorting by last_input ascending puts the silent devices first, which is
-- the quickest way to audit a group of sensors. params comes back as the device's
-- configuration array, so you can check firmware or mode alongside activity.
SELECT id, name, active, last_input, params
FROM devices_tag('device_type', 'sensor') AS d
ORDER BY last_input ASC
LIMIT 100
