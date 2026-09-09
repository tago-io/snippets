-- @title: Device Configuration Parameters
-- @description: Read configuration parameters with filters and upsert them in one call
-- @tags: devices, parameters, configuration, downlink

--[[
  Analysis Example
  Configuration parameters

  device:params filters on key (exact match) and sent_status. device:setParams
  upserts: an item with an id edits that parameter, an item without one creates
  it. At most 60 items per call, and 60 parameters per device.

  A common downlink pattern stores the pending command as an unsent parameter,
  then marks it sent once the network confirms it.

  Instructions
  Add an environment variable device_id, and a policy allowing "Access" and
  "Edit" on that device.
]]

local function byKey(params)
  local index = {}
  for _, param in params do
    index[param.key] = param
  end
  return index
end

Analysis.use(function(context, scope)
  local device = Devices.get(context.environment.device_id)

  local all = byKey(device:params())
  context.log("interval", all.reading_interval and all.reading_interval.value or "unset")

  local pending = device:params({ sent_status = false })
  for _, param in pending do
    context.log("pending", param.key, param.value)
  end

  -- Create or update by key, then flag the pending downlink as delivered.
  local changes = {
    { id = all.reading_interval and all.reading_interval.id, key = "reading_interval", value = "600" },
  }

  for _, param in pending do
    table.insert(changes, { id = param.id, key = param.key, value = param.value, sent = true })
  end

  context.log(device:setParams(changes))
end)
