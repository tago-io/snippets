-- @title: List Devices by Tag
-- @description: Page through devices filtered by tag and act on each handle
-- @tags: devices, list, tags, filtering

--[[
  Analysis Example
  List devices by tag

  Devices.list returns handles, so every row can be read and written without a
  second Devices.get. Rows carry only the fields you ask for, plus id and tags.

  amount defaults to 20 and the whole reply shares a 64 KiB budget. Page with
  amount and page, and request only the fields you need.

  Instructions
  Grant the Analysis "Access" and "Send Data" on the devices through an Access
  Management policy that targets the tag below.
]]

local PAGE_SIZE = 50

local function listPage(page)
  return Devices.list({
    page = page,
    amount = PAGE_SIZE,
    fields = { "id", "name", "last_input", "tags" },
    orderBy = "name,asc",
    filter = {
      active = true,
      tags = { { key = "kind", value = "sensor" } },
    },
  })
end

Analysis.use(function(context, scope)
  local now = Date.now()
  local page = 1
  local offline = 0

  while true do
    local devices = listPage(page)
    if #devices == 0 then
      break
    end

    for _, device in devices do
      local silentFor = if device.last_input
        then Date.diff(now, Date.parse(device.last_input), "hours")
        else math.huge

      if silentFor > 24 then
        offline += 1
        print("offline", device.name, device.id)
        device:addData({ variable = "offline", value = true })
      end
    end

    if #devices < PAGE_SIZE then
      break
    end
    page += 1
  end

  print("offline devices", offline)
end)
