-- @title: Parse Trigger Payload
-- @description: Decode a raw hex payload from the trigger scope and post the parsed variables
-- @tags: scope, payload, decode, add-data

--[[
  Analysis Example
  Parse the trigger payload

  When an Action triggers the Analysis, scope is the array of data items that
  fired it. Each item carries at least variable, value, and device.

  This replaces a payload parser for cases where the decoding needs more than
  the parser can do, such as reading other variables or writing to a second
  device.

  Instructions
  Trigger this Analysis from an Action on the variable "payload", holding a
  four character hex string: two bytes of temperature in tenths of a degree.
]]

local function findVariable(items, name)
  for _, item in items do
    if item.variable == name then
      return item
    end
  end
  return nil
end

local function decodeTemperature(hex)
  local bytes = Hex.decode(hex)
  if buffer.len(bytes) < 2 then
    error("payload needs at least 2 bytes")
  end

  local high = buffer.readu8(bytes, 0)
  local low = buffer.readu8(bytes, 1)
  return (bit32.lshift(high, 8) + low) / 10
end

Analysis.use(function(context, scope)
  if type(scope) ~= "table" then
    return print("no trigger payload")
  end

  local payload = findVariable(scope, "payload")
  if not payload then
    return print("variable payload not found in scope")
  end

  local device = Devices.get(payload.device)
  local temperature = decodeTemperature(payload.value)

  print("decoded", temperature)

  local result = device:addData({
    { variable = "temperature", value = temperature, unit = "C", time = payload.time },
    { variable = "temperature_status", value = if temperature > 30 then "high" else "normal" },
  })

  print(result)
end)
