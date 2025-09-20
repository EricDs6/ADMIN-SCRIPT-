-- modules/world.lua
-- Full bright e X-Ray simples

local World = { bright = false, xray = false }

function World.setup(Core)
  World.Core = Core
  World._store = { brightness = World.Core.services().Lighting.Brightness }
end

function World.toggleFullBright()
  local L = World.Core.services().Lighting
  World.bright = not World.bright
  if World.bright then
    World._store.brightness = L.Brightness
    L.Brightness = 5
    L.ClockTime = 14
    L.FogEnd = 1e5
  else
    L.Brightness = World._store.brightness or 3
  end
  return World.bright
end

function World.toggleXray()
  World.xray = not World.xray
  for _, p in ipairs(workspace:GetDescendants()) do
    if p:IsA("BasePart") then
      p.Transparency = World.xray and math.clamp(p.Transparency + 0.6, 0, 0.95) or 0
    end
  end
  return World.xray
end

function World.disable()
  local L = World.Core.services().Lighting
  if World.bright then
    World.bright = false
    L.Brightness = World._store.brightness or 3
  end
  if World.xray then
    World.xray = false
    for _, p in ipairs(workspace:GetDescendants()) do
      if p:IsA("BasePart") then
        p.Transparency = 0
      end
    end
  end
end

return World
