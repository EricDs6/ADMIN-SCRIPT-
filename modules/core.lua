-- modules/core.lua - núcleo mínimo
local Core = {}

-- Serviços
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local state = {}

function Core.init()
  state.player = Players.LocalPlayer
  state.character = state.player.Character or state.player.CharacterAdded:Wait()
  state.humanoid = state.character:WaitForChild("Humanoid")
  state.hrp = state.character:WaitForChild("HumanoidRootPart")
  state.mouse = state.player:GetMouse()
end

function Core.state()
  return state
end

function Core.services()
  return { Players = Players, UserInputService = UserInputService, RunService = RunService }
end

local connections = {}
function Core.connect(key, conn)
  if connections[key] then pcall(function() connections[key]:Disconnect() end) end
  connections[key] = conn
end
function Core.disconnect(key)
  if connections[key] then pcall(function() connections[key]:Disconnect() end); connections[key]=nil end
end
function Core.cleanup()
  for k,c in pairs(connections) do pcall(function() c:Disconnect() end) end
  table.clear(connections)
end

Core.init()
return Core
