-- @title: Console Hello World
-- @description: Write to the Analysis console with context.log and print
-- @tags: basic, console, hello-world

--[[
  Analysis Example
  Hello World

  A Sandbox Analysis registers one callback with Analysis.use. The host calls it
  once, after the root chunk finishes.

  Both context.log and print write to the Analysis console. context.log carries
  the run's console session, so prefer it inside the callback.
]]

Analysis.use(function(context, scope)
  context.log("Hello World")
  context.log("analysis", context.analysis_id)

  print("print also reaches the console")

  if scope then
    context.log("scope", Json.encode(scope))
  end
end)
