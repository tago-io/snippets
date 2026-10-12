-- @title: Console Hello World
-- @description: Write to the Analysis console with print
-- @tags: basic, console, hello-world

--[[
  Analysis Example
  Hello World

  A Sandbox Analysis registers one callback with Analysis.use. The host calls it
  once, after the root chunk finishes.

  print is the only way to write to the Analysis console. It takes any number of
  values and separates them with a tab, the same as Lua's print.

  The console has an 8 KiB budget for the whole run. A line that would cross it
  ends the run.
]]

Analysis.use(function(context, scope)
  print("Hello World")
  print("analysis", context.analysis_id)

  if scope then
    print("scope", Json.encode(scope))
  end
end)
