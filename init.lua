-- Admin Script Modular - Loader Principal v2.0
-- Execução: loadstring(game:HttpGet("https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-/main/init.lua"))()

print("🚀 Carregando Admin Script Modular v2.0...")

-- Função para detectar loadstring disponível
local function getLoadstring()
    return loadstring or 
           (getgenv and getgenv().loadstring) or 
           (syn and syn.loadstring) or 
           (_G and _G.loadstring) or
           (getfenv and getfenv().loadstring)
end

-- Função para carregar módulos via HTTP com múltiplas APIs
local function httpGet(url)
    local ok, res
    
    -- Tentar syn.request (Synapse X)
    if syn and syn.request then
        ok, res = pcall(syn.request, {Url = url, Method = "GET"})
        if ok and res and res.Success and res.Body then return res.Body end
    end
    
    -- Tentar http.request (Script-Ware)
    if http and http.request then
        ok, res = pcall(http.request, {Url = url, Method = "GET"})
        if ok and res and res.Body then return res.Body end
    end
    
    -- Tentar http_request (KRNL)
    if http_request then
        ok, res = pcall(http_request, {Url = url, Method = "GET"})
        if ok and res and (res.Body or res.body) then return res.Body or res.body end
    end
    
    -- Tentar request (genérico)
    if request then
        ok, res = pcall(request, {Url = url, Method = "GET"})
        if ok and res and (res.Body or res.body) then return res.Body or res.body end
    end
    
    -- Fallback para game:HttpGet (menos confiável)
    if game and game.HttpGet then
        ok, res = pcall(function() return game:HttpGet(url) end)
        if ok and res then return res end
    end
    
    return nil
end

-- Configuração base no _G
if not _G.AdminScript then
    _G.AdminScript = {
        -- Informações da versão
        version = "2.0",
        lastUpdate = "2025-09-21",
        
        -- Serviços
        Services = {
            Players = game:GetService("Players"),
            UserInputService = game:GetService("UserInputService"),
            RunService = game:GetService("RunService"),
            TweenService = game:GetService("TweenService")
        },
        
        -- Player info
        Player = game:GetService("Players").LocalPlayer,
        
        -- Estado global
        Connections = {},
        OriginalValues = {},
        
        -- Módulos carregados
        LoadedModules = {},
        
        -- GUI elementos
        GUI = {},
        
        -- Estados dos módulos
        Movement = {},
        
        -- Configuração
        Config = {}
    }
end

local Admin = _G.AdminScript
local Player = Admin.Player
local Services = Admin.Services

-- Atualizar referências do personagem
local function updateCharacter()
    Admin.Character = Player.Character or Player.CharacterAdded:Wait()
    Admin.Humanoid = Admin.Character:WaitForChild("Humanoid")
    Admin.HumanoidRootPart = Admin.Character:WaitForChild("HumanoidRootPart")
end

-- Função para carregar configuração
local function loadConfig()
    local baseURL = "https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-/main/"
    local url = baseURL .. "config.lua"
    
    local result = httpGet(url)
    if not result then
        warn("❌ Falha ao carregar configuração! Usando configuração padrão...")
        return {
            movement = {
                enabled = true,
                modules = {
                    fly = { enabled = true, path = "modules/movement/fly.lua" },
                    noclip = { enabled = true, path = "modules/movement/noclip.lua" }
                }
            },
            gui = {
                enabled = true,
                modules = {
                    main = { enabled = true, path = "modules/gui/main.lua" }
                }
            },
            loadOrder = {"movement.fly", "movement.noclip", "gui.main"}
        }
    end
    
    local compile = getLoadstring()
    if not compile then
        warn("❌ Não foi possível compilar configuração!")
        return {}
    end
    
    local success, configFunction = pcall(compile, result)
    if success and configFunction then
        local execSuccess, config = pcall(configFunction)
        if execSuccess and config then
            print("✅ Configuração carregada!")
            return config
        end
    end
    
    warn("❌ Erro ao executar configuração!")
    return {}
end

-- Função para carregar um módulo específico
local function loadModule(modulePath, moduleName)
    local baseURL = "https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-/main/"
    local url = baseURL .. modulePath
    
    print("📦 Carregando módulo: " .. moduleName)
    
    -- Obter loadstring compatível
    local compile = getLoadstring()
    if not compile then
        warn("❌ Nenhuma função loadstring disponível no executor!")
        return false
    end
    
    -- Baixar código do módulo
    local result = httpGet(url)
    if not result then
        warn("❌ Falha ao baixar módulo: " .. moduleName)
        return false
    end
    
    -- Compilar e executar
    local success, moduleFunction = pcall(compile, result)
    if success and moduleFunction then
        local execSuccess, execError = pcall(moduleFunction)
        if execSuccess then
            Admin.LoadedModules[moduleName] = {
                path = modulePath,
                loaded = true,
                loadTime = tick()
            }
            print("✅ Módulo " .. moduleName .. " carregado!")
            return true
        else
            warn("❌ Erro ao executar módulo " .. moduleName .. ": " .. tostring(execError))
        end
    else
        warn("❌ Falha ao compilar módulo " .. moduleName .. ": " .. tostring(moduleFunction))
    end
    
    return false
end

-- Função para carregar módulos baseado na configuração
local function loadModules(config)
    if not config or not config.loadOrder then
        warn("❌ Configuração inválida!")
        return
    end
    
    print("🔄 Carregando módulos conforme configuração...")
    
    for _, moduleKey in ipairs(config.loadOrder) do
        local parts = string.split(moduleKey, ".")
        if #parts == 2 then
            local category = parts[1]
            local moduleName = parts[2]
            
            local categoryConfig = config[category]
            if categoryConfig and categoryConfig.enabled and categoryConfig.modules then
                local moduleConfig = categoryConfig.modules[moduleName]
                if moduleConfig and moduleConfig.enabled and moduleConfig.path then
                    loadModule(moduleConfig.path, moduleKey)
                    wait(0.1) -- Pequena pausa entre carregamentos
                end
            end
        end
    end
end

-- Função de limpeza melhorada
local function cleanup()
    print("🧹 Iniciando limpeza do sistema...")
    
    -- Desconectar todas as conexões
    local connectionCount = 0
    for name, connection in pairs(Admin.Connections) do
        if connection then
            if typeof(connection) == "RBXScriptConnection" then
                pcall(function() connection:Disconnect() end)
                connectionCount = connectionCount + 1
            elseif type(connection) == "table" and connection.connection then
                -- Para módulos que armazenam conexões em tabelas
                pcall(function() connection.connection:Disconnect() end)
                connectionCount = connectionCount + 1
            end
        end
    end
    Admin.Connections = {}
    
    -- Limpar objetos de física dos módulos
    if Admin.Movement then
        for moduleName, moduleData in pairs(Admin.Movement) do
            if type(moduleData) == "table" then
                -- Limpar BodyVelocity e BodyGyro se existirem
                for _, objName in pairs({"BodyVelocity", "BodyGyro", "bodyVelocity", "bodyGyro"}) do
                    if moduleData[objName] then
                        pcall(function() moduleData[objName]:Destroy() end)
                        moduleData[objName] = nil
                    end
                end
            end
        end
    end
    
    -- Restaurar valores originais
    if Admin.Humanoid and Admin.OriginalValues then
        local restoredCount = 0
        
        if Admin.OriginalValues.PlatformStand ~= nil then
            Admin.Humanoid.PlatformStand = Admin.OriginalValues.PlatformStand
            restoredCount = restoredCount + 1
        end
        
        if Admin.OriginalValues.WalkSpeed then
            Admin.Humanoid.WalkSpeed = Admin.OriginalValues.WalkSpeed
            restoredCount = restoredCount + 1
        end
        
        print("🔄 " .. restoredCount .. " valores originais restaurados")
    end
    
    Admin.OriginalValues = {}
    
    -- Restaurar colisão das partes do character
    if Admin.Character then
        local partCount = 0
        for _, part in pairs(Admin.Character:GetChildren()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.CanCollide = true
                partCount = partCount + 1
            end
        end
        print("🔄 " .. partCount .. " partes restauradas")
    end
    
    -- Remover GUI
    if Admin.GUI and Admin.GUI.Module and Admin.GUI.Module.ScreenGui then
        local screenGui = Admin.GUI.Module.ScreenGui()
        if screenGui then
            screenGui:Destroy()
        end
    end
    Admin.GUI = {}
    
    -- Resetar estados dos módulos
    Admin.Movement = {}
    Admin.LoadedModules = {}
    
    print("✅ Sistema completamente limpo!")
    print("🔌 " .. connectionCount .. " conexões desconectadas")
    print("🛡️ Todos os valores foram restaurados!")
end

-- Tornar cleanup acessível globalmente
_G.AdminScript.Cleanup = cleanup

-- Comando de limpeza via chat
Admin.Connections.Chat = Player.Chatted:Connect(function(message)
    local lowerMessage = message:lower()
    for _, command in pairs({"/cleanup", "/limpar", "/clear"}) do
        if lowerMessage == command then
            cleanup()
            break
        end
    end
end)

-- Conectar evento de respawn
Admin.Connections.CharacterAdded = Player.CharacterAdded:Connect(function()
    updateCharacter()
end)

-- Inicialização
updateCharacter()

-- Carregar configuração e módulos
print("⚙️ Carregando configuração...")
local config = loadConfig()
Admin.Config = config

if config.settings and config.settings.showLoadMessages then
    print("📋 Configuração:")
    print("   - Módulos de movimento: " .. (config.movement.enabled and "✅" or "❌"))
    print("   - Módulos de GUI: " .. (config.gui.enabled and "✅" or "❌"))
    print("   - Total de módulos: " .. #config.loadOrder)
end

-- Carregar módulos
loadModules(config)

-- Criar GUI se habilitado
if config.gui and config.gui.enabled and Admin.GUI and Admin.GUI.Module then
    wait(0.2) -- Aguardar carregamento dos módulos
    local success, error = pcall(function()
        Admin.GUI.Module.create()
    end)
    if not success then
        warn("❌ Erro ao criar GUI: " .. tostring(error))
    end
end

print("✅ Admin Script v" .. Admin.version .. " carregado completamente!")
print("🎮 Use a GUI ou comandos de chat para controlar")
print("🧹 Digite /cleanup, /limpar ou /clear para limpar tudo")