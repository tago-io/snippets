-- @title: Structure an Analysis
-- @description: Organize a script with local helpers and a table of handlers
-- @tags: structure, patterns, scope, routing

--[[
  Analysis Example
  Structure a larger script

  The root chunk runs first, with the same globals as the callback. Declare the
  helpers there and keep the callback short.

  Globals are frozen, so state lives in locals. Runs share nothing and are never
  retried, so keep each handler idempotent.

  Instructions
  Trigger this Analysis from an Action on the variables below. The handler table
  routes each item in scope to the function that owns it.
]]

local ALERT_LIMIT = 40

local function toNumber(item)
  return tonumber(item.value)
end

local function handleTemperature(device, item)
  local celsius = toNumber(item)
  if not celsius then
    return print("temperature is not numeric")
  end

  return {
    { variable = "temperature_f", value = celsius * 1.8 + 32, unit = "F", time = item.time },
    { variable = "temperature_alert", value = celsius > ALERT_LIMIT, time = item.time },
  }
end

local function handleBattery(device, item)
  local percent = toNumber(item)
  if not percent or percent > 20 then
    return nil
  end

  print("battery low on", device.name)
  return { { variable = "battery_alert", value = percent, unit = "%", time = item.time } }
end

local handlers = {
  temperature = handleTemperature,
  battery = handleBattery,
}

Analysis.use(function(context, scope)
  if type(scope) ~= "table" or #scope == 0 then
    return print("nothing to process")
  end

  local batch = {}
  local device = Devices.get(scope[1].device)

  for _, item in scope do
    local handler = handlers[item.variable]
    if handler then
      local produced = handler(device, item)
      for _, row in produced or {} do
        table.insert(batch, row)
      end
    end
  end

  if #batch == 0 then
    return print("no output for this trigger")
  end

  -- One call for the whole batch: one request and one rate limit token.
  print(device:addData(batch))
end)
