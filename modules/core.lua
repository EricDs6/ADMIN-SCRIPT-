-- modules/core.lua - núcleo com gerenciamento de respawn
local Core = {}

-- Serviços
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local state = {}
local character_added_callbacks = {}
local modules_to_respawn = {}

function Core.init()
    state.player = Players.LocalPlayer
    state.mouse = state.player:GetMouse()

    local function on_char(character)
        if not character then return end
        state.character = character
        state.humanoid = character:WaitForChild("Humanoid")
        state.hrp = character:WaitForChild("HumanoidRootPart")

        -- Dispara callbacks
        for _, callback in ipairs(character_added_callbacks) do
            pcall(callback)
        end
        
        -- Reativa módulos que estavam ativos
        for module_name, was_enabled in pairs(modules_to_respawn) do
            if was_enabled and _G.FK7 and _G.FK7.Features and _G.FK7.Features[module_name] then
                task.wait(0.5) -- Aguarda character estabilizar
                pcall(function()
                    if not _G.FK7.Features[module_name].enabled then
                        _G.FK7.Features[module_name].toggle()
                    end
                end)
            end
        end
    end

    state.player.CharacterAdded:Connect(on_char)
    if state.player.Character then
        on_char(state.player.Character)
    end
end

function Core.registerForRespawn(module_name, is_enabled)
    modules_to_respawn[module_name] = is_enabled
end

function Core.onCharacterAdded(callback)
    table.insert(character_added_callbacks, callback)
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
