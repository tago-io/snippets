-- @title: Dates and Timezones
-- @description: Bucket readings into local days with the Date helpers
-- @tags: date, timezone, aggregate, data

--[[
  Analysis Example
  Dates and timezones

  Every date on the wire is an ISO 8601 string. The Date helpers work on
  milliseconds: Date.parse reads a string, Date.format writes one.

  startOf, endOf, weekday, and isSame take a timezone, so a "day" is the local
  day of the site, not UTC.

  A getData reply has a 64 KiB budget, so read in pages with qty and skip
  instead of asking for everything at once.

  Instructions
  Add environment variables device_id and timezone, for example
  America/Chicago.
]]

local PAGE_SIZE = 200

local function readPage(device, from, to, skip)
  return device:getData({
    variables = "energy",
    qty = PAGE_SIZE,
    skip = skip,
    start_date = Date.format(from),
    end_date = Date.format(to),
    ordination = "ascending",
  })
end

Analysis.use(function(context, scope)
  local timezone = context.environment.timezone or "UTC"
  if not Date.isTimezone(timezone) then
    error(`unknown timezone "{timezone}"`)
  end

  local device = Devices.get(context.environment.device_id)

  local today = Date.startOf(Date.now(), "day", timezone)
  local weekAgo = Date.sub(today, { days = 7 })

  context.log("window", Date.format(weekAgo, timezone), Date.format(today, timezone))
  context.log("offset minutes", Date.offsetMinutes(today, timezone))

  -- Sum each local day, keyed by its own start of day.
  local totals = {}
  local skip = 0

  while true do
    local rows = readPage(device, weekAgo, today, skip)

    for _, row in rows do
      local value = tonumber(row.value)
      if value and row.time then
        local day = Date.startOf(Date.parse(row.time), "day", timezone)
        totals[day] = (totals[day] or 0) + value
      end
    end

    if #rows < PAGE_SIZE then
      break
    end
    skip += PAGE_SIZE
  end

  local batch = {}
  for day, total in totals do
    table.insert(batch, {
      variable = "energy_daily",
      value = total,
      unit = "kWh",
      time = Date.format(day),
      metadata = { weekday = Date.weekday(day, timezone) },
    })
  end

  if #batch == 0 then
    return context.log("no energy readings in the last 7 days")
  end

  context.log(device:addData(batch))
end)
