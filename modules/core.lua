-- modules/core.lua - Gerenciador de estado e conexões
local Core = {}
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local state = {
    player = Players.LocalPlayer,
    character = nil,
    humanoid = nil,
    humanoidRootPart = nil,
    connections = {},
    activeModules = {},
    originalValues = {}
}

function Core.state()
    return state
end

function Core.init()
    -- Inicializar estado do jogador
    state.character = state.player.Character or state.player.CharacterAdded:Wait()
    state.humanoid = state.character:WaitForChild("Humanoid")
    state.humanoidRootPart = state.character:WaitForChild("HumanoidRootPart")

    -- Conectar evento de respawn
    state.connections.characterAdded = state.player.CharacterAdded:Connect(function(newChar)
        Core.onCharacterRespawn(newChar)
    end)

    print("[FK7 Core] Inicializado com sucesso!")
    return state
end

function Core.onCharacterRespawn(newChar)
    -- Atualizar referências
    state.character = newChar
    state.humanoid = newChar:WaitForChild("Humanoid")
    state.humanoidRootPart = newChar:WaitForChild("HumanoidRootPart")

    -- Reaplicar módulos ativos
    for moduleName, isEnabled in pairs(state.activeModules) do
        if isEnabled and Core[moduleName] and Core[moduleName].enable then
            pcall(function()
                Core[moduleName].enable()
            end)
        end
    end

    print("[FK7 Core] Personagem respawnado, módulos reaplicados!")
end

function Core.registerModule(moduleName, moduleTable)
    -- Registrar módulo no core
    Core[moduleName] = moduleTable

    -- Adicionar função toggle se não existir
    if not moduleTable.toggle then
        moduleTable.toggle = function()
            local enabled = not (state.activeModules[moduleName] or false)
            state.activeModules[moduleName] = enabled

            if enabled then
                if moduleTable.enable then
                    pcall(moduleTable.enable)
                end
            else
                if moduleTable.disable then
                    pcall(moduleTable.disable)
                end
            end

            return enabled
        end
    end

    print("[FK7 Core] Módulo '" .. moduleName .. "' registrado!")
end

function Core.connect(eventName, callback)
    if state.connections[eventName] then
        state.connections[eventName]:Disconnect()
    end
    state.connections[eventName] = callback
    return state.connections[eventName]
end

function Core.disconnect(eventName)
    if state.connections[eventName] then
        state.connections[eventName]:Disconnect()
        state.connections[eventName] = nil
    end
end

function Core.saveOriginalValue(key, value)
    state.originalValues[key] = value
end

function Core.getOriginalValue(key, default)
    return state.originalValues[key] or default
end

function Core.shutdown()
    -- Desconectar todos os eventos
    for name, connection in pairs(state.connections) do
        if typeof(connection) == "RBXScriptConnection" then
            connection:Disconnect()
        end
    end

    -- Desabilitar todos os módulos
    for moduleName, isEnabled in pairs(state.activeModules) do
        if isEnabled and Core[moduleName] and Core[moduleName].disable then
            pcall(Core[moduleName].disable)
        end
    end

    -- Limpar estado
    state.connections = {}
    state.activeModules = {}
    state.originalValues = {}

    print("[FK7 Core] Sistema encerrado!")
end

return Core