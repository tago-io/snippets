-- @title: Minimum, Maximum and Average
-- @description: Run min, max and aggregate queries on a device and store the results
-- @tags: data, aggregate, statistics, query

--[[
  Analysis Example
  Minimum, maximum, and average

  getData takes the same query the API takes. The query key selects the method:
  last_value, min, max, avg, sum, count, aggregate, and the rest.

  "function" is a Lua keyword, so the aggregate function goes in brackets:
  ["function"] = "avg".

  Instructions
  Add an environment variable device_id, and grant the Analysis "Get Data" and
  "Send Data" on that device through an Access Management policy.
]]

local function scalar(rows)
  local first = rows[1]
  return first and tonumber(first.value) or nil
end

Analysis.use(function(context, scope)
  local device = Devices.get(context.environment.device_id)
  local window = "1 day"

  local minimum = scalar(device:getData({ variables = "temperature", query = "min", start_date = window }))
  local maximum = scalar(device:getData({ variables = "temperature", query = "max", start_date = window }))

  if not minimum or not maximum then
    return print("no temperature in the last day")
  end

  print("min", minimum, "max", maximum)

  -- One bucket per hour over the same window.
  local hourly = device:getData({
    variables = "temperature",
    query = "aggregate",
    ["function"] = "avg",
    interval = "1 hour",
    timezone = "America/New_York",
    start_date = window,
  })

  print("buckets", #hourly)

  local batch = {
    { variable = "temperature_minimum", value = minimum, unit = "C" },
    { variable = "temperature_maximum", value = maximum, unit = "C" },
  }

  for _, bucket in hourly do
    table.insert(batch, {
      variable = "temperature_hourly",
      value = bucket.value,
      unit = "C",
      time = bucket.time,
    })
  end

  -- A batch lands whole or the call fails. There is no partial write.
  print(device:addData(batch))
end)
