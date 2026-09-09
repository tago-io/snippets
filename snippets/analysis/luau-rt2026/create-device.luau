-- @title: Create Device
-- @description: Create a device with tags and set its initial configuration parameters
-- @tags: devices, create, tags, parameters

--[[
  Analysis Example
  Create a device

  Devices.create returns a handle for the new device. The generated device token
  never reaches the script.

  Access Management matches create by tag, never by ID, so the policy has to
  allow "Create" on a tag that the payload carries.

  The handle holds the values you submitted plus the ID the platform returned.
  Server side fields such as created_at arrive only after Devices.get.

  Instructions
  Add a policy targeting this Analysis that allows "Create", "Access", and
  "Edit" on devices with the tag kind = sensor.
]]

local SERIAL = "TAGO-0001"

Analysis.use(function(context, scope)
  local existing = Devices.list({
    amount = 1,
    fields = { "id", "name" },
    filter = { tags = { { key = "serial", value = SERIAL } } },
  })

  if existing[1] then
    return context.log("device already exists", existing[1].id)
  end

  local device = Devices.create({
    name = `Sensor {SERIAL}`,
    type = "immutable",
    description = "Created from a Sandbox Analysis",
    chunk_period = "month",
    chunk_retention = 1,
    tags = {
      { key = "kind", value = "sensor" },
      { key = "serial", value = SERIAL },
    },
  })

  context.log("created", device.id, device.name)

  -- Parameters are set after create, so a failure here is visible.
  context.log(device:setParams({
    { key = "reading_interval", value = "300" },
    { key = "serial", value = SERIAL, sent = true },
  }))
end)
