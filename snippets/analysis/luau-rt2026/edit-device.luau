-- @title: Edit Device
-- @description: Rename a device, replace its tags, and clear them with an empty list
-- @tags: devices, edit, tags

--[[
  Analysis Example
  Edit a device

  device:edit returns a new handle with the accepted changes applied. It makes
  no second request, and the handle it was called on stays unchanged. Fields the
  platform computes, such as updated_at, are not refreshed.

  Tags replace the whole list. An empty list clears every tag.

  type and chunk_period cannot change. network and connector must be sent
  together, and cannot change once the device has a token.

  Instructions
  Add an environment variable device_id, and a policy allowing "Access" and
  "Edit" on that device.
]]

Analysis.use(function(context, scope)
  local device = Devices.get(context.environment.device_id)

  local renamed = device:edit({
    name = `{device.name} (managed)`,
    description = "Renamed from a Sandbox Analysis",
    active = true,
    tags = {
      { key = "kind", value = "sensor" },
      { key = "managed_by", value = context.analysis_id },
    },
  })

  print("before", device.name)
  print("after", renamed.name)

  for _, tag in renamed.tags do
    print("tag", tag.key, tag.value)
  end

  -- Uncomment to drop every tag from the device.
  -- renamed:edit({ tags = {} })
end)
