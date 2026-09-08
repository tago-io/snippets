-- @title: JSON, Base64, Hex and UUID
-- @description: Use the host utility globals to encode, decode and identify data
-- @tags: json, base64, hex, uuid, utilities

--[[
  Analysis Example
  Host utilities

  Json, Base64, Hex, and Uuid are always available. There is no require and no
  JSON.parse.

  Base64.decode and Hex.decode return a buffer, not a string. Use
  buffer.tostring for text and the buffer read functions for binary fields.
]]

Analysis.use(function(context, scope)
  local device = Devices.get(context.environment.device_id)

  -- Json round trip. metadata travels as a table, not as a string.
  local settings = Json.decode(context.environment.settings or "{}")
  context.log("settings", Json.encode(settings))

  -- Base64 for text.
  local encoded = Base64.encode("firmware=2.4.1")
  context.log("base64", encoded, buffer.tostring(Base64.decode(encoded)))

  -- Hex for binary frames. Read fields with the buffer library.
  local frame = Hex.decode("0a1f00c8")
  context.log("frame bytes", buffer.len(frame))
  context.log("battery", buffer.readu8(frame, 0))
  context.log("counter", bit32.lshift(buffer.readu8(frame, 2), 8) + buffer.readu8(frame, 3))

  -- A run has no shared state, so generate correlation IDs when you need them.
  local runId = Uuid.v4()
  context.log("run", runId)

  context.log(device:addData({
    variable = "heartbeat",
    value = 1,
    metadata = { run = runId, settings = settings },
  }))
end)
