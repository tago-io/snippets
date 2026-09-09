-- @title: Environment Variables
-- @description: Read Analysis variables and trigger values from context.environment
-- @tags: basic, environment, configuration

--[[
  Analysis Example
  Environment variables

  context.environment is a read-only string dictionary. It holds the variables
  set on the Analysis screen plus the reserved values the trigger adds, such as
  device, action, and dashboard identifiers.

  Values are always strings. Convert them before use.

  The console has an 8 KiB budget for the whole run. Log what you need to
  debug, not every value you touch.

  Instructions
  Add a variable named device_id on the Analysis "Environment Variables" tab and
  set it to the ID of a device the Analysis can access.
]]

local function required(context, key)
  local value = context.environment[key]
  if not value or value == "" then
    error(`missing environment variable "{key}"`)
  end
  return value
end

Analysis.use(function(context, scope)
  local device_id = required(context, "device_id")
  local threshold = tonumber(context.environment.threshold) or 30

  context.log("device_id", device_id)
  context.log("threshold", threshold)

  for key, value in context.environment do
    context.log("env", key, value)
  end
end)
