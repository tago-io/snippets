-- @title: Console Hello World
-- @description: Write to the Analysis console with print
-- @tags: basic, console, hello-world

--[[
  Analysis Example
  Hello World

  A Sandbox Analysis registers one callback with Analysis.use. The host calls it
  once, after the root chunk finishes.

  print writes to the Analysis console.
]]

Analysis.use(function(context, scope)
  print("Hello World")
  print("analysis", context.analysis_id)

  print("print also reaches the console")

  if scope then
    print("scope", Json.encode(scope))
  end
end)
