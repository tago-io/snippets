-- @title: Handle Binding Errors
-- @description: Wrap a binding call in pcall and read the error message
-- @tags: error-handling, pcall, devices, resilience

--[[
  Analysis Example
  Handle binding errors

  A failed binding raises. Without pcall the run stops at that line and the
  message reaches the Analysis console.

  pcall returns ok plus the value or the error. The error is the plain message,
  so tostring gives you the text to log or to store.

  Common failures:
    Authorization Denied    the policy does not cover this device action
    Rate Limit Exceeded     the profile ran out of RPM for that resource
    a device API message    the platform rejected the operation
    a wrong argument hint   the query or payload shape is invalid

  Side effects that already completed are not rolled back when a later call
  fails. Write idempotent scripts.
]]

local function attempt(label, fn)
  local ok, result = pcall(fn)
  if not ok then
    print(label, "failed:", tostring(result))
    return nil
  end
  return result
end

Analysis.use(function(context, scope)
  local device = attempt("get", function()
    return Devices.get(context.environment.device_id)
  end)

  if not device then
    return
  end

  local rows = attempt("getData", function()
    return device:getData({ variables = "temperature", query = "last_value" })
  end)

  local last = rows and rows[1]
  if not last then
    return print("no reading to forward")
  end

  local written = attempt("addData", function()
    return device:addData({ variable = "temperature_copy", value = last.value, time = last.time })
  end)

  print("result", written or "not written")
end)
