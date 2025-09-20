-- modules/core.lua
-- Núcleo: serviços, utilitários, estado global leve

local Core = {}

-- Serviços
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")

-- Estado mínimo compartilhado (evita excesso de locals no chunk principal)
local state = {
  player = Players.LocalPlayer,
}
state.character = state.player.Character or state.player.CharacterAdded:Wait()
state.humanoid = state.character:WaitForChild("Humanoid")
state.hrp = state.character:WaitForChild("HumanoidRootPart")
state.mouse = state.player:GetMouse()

-- Conexões e limpeza
local connections = {}
function Core.connect(key, conn)
  if connections[key] then pcall(function() connections[key]:Disconnect() end) end
  connections[key] = conn
end
function Core.disconnect(key)
  if connections[key] then pcall(function() connections[key]:Disconnect() end); connections[key] = nil end
end
function Core.cleanup()
  for k, c in pairs(connections) do pcall(function() c:Disconnect() end) end
  table.clear(connections)
end

-- Utils
function Core.onCharacterAdded(cb)
  state.player.CharacterAdded:Connect(function(newChar)
    state.character = newChar
    state.humanoid = newChar:WaitForChild("Humanoid")
    state.hrp = newChar:WaitForChild("HumanoidRootPart")
    cb(newChar)
  end)
end

function Core.services()
  return {
    Players = Players,
    UserInputService = UserInputService,
    RunService = RunService,
    Lighting = Lighting,
    TweenService = TweenService,
  }
end

function Core.state()
  return state
end

return Core
