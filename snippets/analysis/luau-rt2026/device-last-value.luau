-- @title: Device Last Value
-- @description: Read the last value of a variable and write a derived variable back
-- @tags: devices, data, last-value, add-data

--[[
  Analysis Example
  Last value

  Devices.get runs immediately and returns a handle. A wrong ID, an inactive
  device, or a denied policy fails at the get call, not later.

  Handle methods use the colon: device:getData(query).

  Instructions
  1 - Add an environment variable device_id with the ID of your device.
  2 - Add an Access Management policy targeting this Analysis that allows
      "Access", "Get Data", and "Send Data" on that device.
]]

Analysis.use(function(context, scope)
  local device = Devices.get(context.environment.device_id)

  context.log("device", device.name, device.type)

  local rows = device:getData({ variables = "temperature", query = "last_value" })
  local last = rows[1]

  if not last then
    return context.log("no temperature yet")
  end

  context.log("last value", last.value, "at", last.time)

  local celsius = tonumber(last.value)
  if not celsius then
    return context.log("temperature is not numeric")
  end

  context.log(device:addData({
    variable = "temperature_f",
    value = celsius * 1.8 + 32,
    unit = "F",
    time = last.time,
  }))
end)
