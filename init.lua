--[[-- Admin Script Modular - Loader Principal v2.0

    Admin Script Modular v2.0-- Execução: loadstring(game:HttpGet("https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-/main/init.lua"))()

    Criado por: EricDs6

    Atualizado em: 21/09/2025print("🚀 Carregando Admin Script Modular v2.0...")

    

    Este script utiliza uma estrutura modular, com cada função separada em seu próprio arquivo-- Inicializar AdminScript para evitar erros de referência nil
--[[
    Admin Script Modular v2.0
    Criado por: EricDs6
    Atualizado em: 21/09/2025

    Instruções:
    - Carregue com: loadstring(game:HttpGet("https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-/main/init.lua"))()
    - /admin para abrir a GUI | /cleanup para limpar tudo
]]

print("[INIT] 🚀 Carregando Admin Script Modular v2.0...")

-- Limpeza anterior, se existir
if _G.AdminScript and type(_G.AdminScript.cleanup) == "function" then
    pcall(_G.AdminScript.cleanup)
end

-- Estado global
_G.AdminScript = {
    version = "2.0",
    lastUpdate = "2025-09-21",
    Services = {
        Players = game:GetService("Players"),
        UserInputService = game:GetService("UserInputService"),
        RunService = game:GetService("RunService"),
        TweenService = game:GetService("TweenService"),
        ReplicatedStorage = game:GetService("ReplicatedStorage"),
        HttpService = game:GetService("HttpService"),
        Lighting = game:GetService("Lighting"),
        Workspace = game:GetService("Workspace")
    },
    Player = game:GetService("Players").LocalPlayer,
    Character = nil,
    Humanoid = nil,
    HumanoidRootPart = nil,
    Connections = {},
    OriginalValues = {},
    LoadedModules = {},
    Movement = {},
    GUI = {},
    Teleport = {},
    CharacterMods = {},
    Utility = {},
    Config = {
        debugMode = true,
        autoLoadGUI = true,
        defaultFlySpeed = 50,
        chatCommands = true,
        disableOnDeath = true,
        diagnosticsCoreGui = false,
        diagnosticsVerbosity = 1
    }
}

local Admin = _G.AdminScript
local Services = Admin.Services
local Player = Admin.Player

-- Helpers
local BASE_URL = "https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-/main/"
local function splitString(str, delimiter)
    if not str or not delimiter then return {} end
    local result = {}
    local pattern = "[^" .. delimiter .. "]+"
    for match in string.gmatch(str, pattern) do table.insert(result, match) end
    return result
end

local function updateCharacterReferences()
    Admin.Character = Player.Character
    if Admin.Character then
        Admin.Humanoid = Admin.Character:FindFirstChildOfClass("Humanoid")
        Admin.HumanoidRootPart = Admin.Character:FindFirstChild("HumanoidRootPart")
        return true
    end
    return false
end
updateCharacterReferences()
Player.CharacterAdded:Connect(function()
    task.wait(0.5)
    updateCharacterReferences()
    if type(Admin.onCharacterChanged) == "function" then
        pcall(Admin.onCharacterChanged, Admin.Character)
    end
end)

-- Overrides de configuração via global (para diagnóstico e ajustes rápidos)
do
    local function mergeConfig(src)
        if type(src) ~= "table" then return end
        for k, v in pairs(src) do Admin.Config[k] = v end
        if Admin.Config.debugMode then print("[INIT] ⚙️ Config override aplicado:", game:GetService("HttpService"):JSONEncode(src)) end
    end
    if type(_G.AdminScriptUserConfig) == "table" then mergeConfig(_G.AdminScriptUserConfig) end
    if type(_G.AdminScriptConfig) == "table" then mergeConfig(_G.AdminScriptConfig) end
end

-- Exec compatibilidade
local function getLoadstring()
    return loadstring
        or (getgenv and getgenv().loadstring)
        or (syn and syn.loadstring)
        or (_G and _G.loadstring)
        or (getfenv and getfenv().loadstring)
end

local function httpGet(url)
    local ok, res
    if syn and syn.request then
        ok, res = pcall(syn.request, { Url = url, Method = "GET" })
        if ok and res and res.Success and res.Body then return res.Body end
    end
    if http and http.request then
        ok, res = pcall(http.request, { Url = url, Method = "GET" })
        if ok and res and res.Body then return res.Body end
    end
    if http_request then
        ok, res = pcall(http_request, { Url = url, Method = "GET" })
        if ok and res and (res.Body or res.body) then return res.Body or res.body end
    end
    if request then
        ok, res = pcall(request, { Url = url, Method = "GET" })
        if ok and res and (res.Body or res.body) then return res.Body or res.body end
    end
    if game and game.HttpGet then
        ok, res = pcall(function() return game:HttpGet(url) end)
        if ok and res then return res end
    end
    return nil
end

-- Carregar configuração remota (config.lua)
local function loadRemoteConfig()
    local compile = getLoadstring()
    if type(compile) ~= "function" then return nil end
    local code = httpGet(BASE_URL .. "config.lua")
    if type(code) ~= "string" or #code == 0 then return nil end
    local okCompile, fnOrErr = pcall(compile, code)
    if not okCompile or type(fnOrErr) ~= "function" then return nil end
    local okRun, cfg = pcall(fnOrErr)
    if not okRun or type(cfg) ~= "table" then return nil end
    return cfg
end

-- Loader de módulos remotos
local function loadModule(modulePath, moduleKey)
    local url = BASE_URL .. modulePath
    if Admin.Config.debugMode then print("[INIT] 📦 Carregando módulo:", moduleKey) end

    local compile = getLoadstring()
    if type(compile) ~= "function" then
        warn("[INIT] ❌ Nenhuma loadstring disponível!")
        return false
    end

    local code = httpGet(url)
    if type(code) ~= "string" or #code == 0 then
        warn("[INIT] ❌ Falha ao baixar módulo:", moduleKey)
        return false
    end

    -- Proteção mínima
    local wrapped = "if not _G.AdminScript then return end\n" .. code

    local okCompile, fnOrErr = pcall(compile, wrapped)
    if not okCompile or type(fnOrErr) ~= "function" then
        warn("[INIT] ❌ Erro ao compilar:", moduleKey, tostring(fnOrErr))
        return false
    end

    local okRun, retOrErr = pcall(fnOrErr)
    if not okRun then
        warn("[INIT] ❌ Erro ao executar:", moduleKey, tostring(retOrErr))
        return false
    end

    Admin.LoadedModules[moduleKey] = {
        path = modulePath,
        loaded = true,
        loadTime = tick(),
        returnValue = retOrErr
    }
    if Admin.Config.debugMode then print("[INIT] ✅ Módulo carregado:", moduleKey) end
    return true
end

-- Configuração dos módulos a carregar
local moduleConfig = {
    loadOrder = {
        "Movement.fly",
        "Movement.noclip",
        "Movement.speed",
        "Character.godmode",
        "Teleport.locations",
        "GUI.main"
    },
    Movement = {
        enabled = true,
        modules = {
            fly = { enabled = true, path = "modules/movement/fly.lua" },
            noclip = { enabled = true, path = "modules/movement/noclip.lua" },
            speed = { enabled = true, path = "modules/movement/speed.lua" }
        }
    },
    Character = {
        enabled = true,
        modules = {
            godmode = { enabled = true, path = "modules/character/godmode.lua" }
        }
    },
    Teleport = {
        enabled = true,
        modules = {
            locations = { enabled = true, path = "modules/teleport/locations.lua" }
        }
    },
    GUI = {
        enabled = true,
        modules = {
            main = { enabled = true, path = "modules/gui/main.lua" }
        }
    }
}

-- Aplicar configuração remota (mesclar com defaults)
do
    local function applyRemote(cfg)
        -- settings -> Admin.Config
        if type(cfg.settings) == "table" then
            for k, v in pairs(cfg.settings) do Admin.Config[k] = v end
        end
        -- loadOrder -> substitui se válido
        if type(cfg.loadOrder) == "table" then moduleConfig.loadOrder = cfg.loadOrder end
        -- categorias principais
        for _, cat in ipairs({"Movement","Character","Teleport","GUI"}) do
            if type(cfg[cat]) == "table" then
                if type(cfg[cat].enabled) == "boolean" then
                    moduleConfig[cat].enabled = cfg[cat].enabled
                end
                if type(cfg[cat].modules) == "table" then
                    moduleConfig[cat].modules = moduleConfig[cat].modules or {}
                    for name, mod in pairs(cfg[cat].modules) do
                        moduleConfig[cat].modules[name] = mod
                    end
                end
            end
        end
    end

    local remoteCfg = loadRemoteConfig()
    if remoteCfg then
        applyRemote(remoteCfg)
        if Admin.Config.debugMode then print("[INIT] ⚙️ Config remota aplicada") end
    else
        if Admin.Config.debugMode then print("[INIT] ⚠️ Usando config padrão (sem config remota)") end
    end
end

local function loadAllModules()
    print("[INIT] 🔄 Carregando módulos...")
    Admin.Movement = Admin.Movement or {}
    Admin.GUI = Admin.GUI or {}
    Admin.Teleport = Admin.Teleport or {}
    Admin.CharacterMods = Admin.CharacterMods or {}
    Admin.Utility = Admin.Utility or {}

    local ok, fail = 0, 0
    for _, key in ipairs(moduleConfig.loadOrder) do
        local parts = splitString(key, ".")
        if #parts == 2 then
            local category, name = parts[1], parts[2]
            local catCfg = moduleConfig[category]
            if catCfg and catCfg.enabled and catCfg.modules and catCfg.modules[name] and catCfg.modules[name].enabled then
                local path = catCfg.modules[name].path
                if loadModule(path, key) then ok = ok + 1 else fail = fail + 1 end
                task.wait(0.05)
            end
        end
    end
    print(string.format("[INIT] 📊 Módulos: %d ok | %d falhas", ok, fail))
    return ok > 0
end

-- Cleanup geral acessível
function Admin.cleanup()
    print("[INIT] 🧹 Limpando...")
    for name, connection in pairs(Admin.Connections) do
        if typeof(connection) == "RBXScriptConnection" then
            pcall(function() connection:Disconnect() end)
        elseif type(connection) == "table" then
            pcall(function()
                if connection.disconnect then connection:disconnect() end
                if connection.Disconnect then connection:Disconnect() end
                if connection.connection and connection.connection.Disconnect then connection.connection:Disconnect() end
            end)
        end
    end
    Admin.Connections = {}

    if Admin.GUI and Admin.GUI.main and Admin.GUI.main.cleanup then
        pcall(Admin.GUI.main.cleanup)
    end

    if Admin.Movement then
        pcall(function() Admin.Movement.fly and Admin.Movement.fly.disable and Admin.Movement.fly.disable() end)
        pcall(function() Admin.Movement.noclip and Admin.Movement.noclip.disable and Admin.Movement.noclip.disable() end)
        pcall(function() Admin.Movement.speed and Admin.Movement.speed.reset and Admin.Movement.speed.reset() end)
    end

    _G.AdminScript = nil
    print("[INIT] ✅ Limpeza concluída")
end

-- Comandos de chat
local function setupChatCommands()
    local conn = Services.Players.LocalPlayer.Chatted:Connect(function(message)
        local msg = string.lower(message or "")
        if msg == "/admin" then
            if Admin.GUI and Admin.GUI.main and Admin.GUI.main.toggle then Admin.GUI.main.toggle() end
        elseif msg == "/cleanup" or msg == "/limpar" or msg == "/clear" then
            Admin.cleanup()
        elseif msg == "/fly" then
            if Admin.Movement and Admin.Movement.fly and Admin.Movement.fly.toggle then Admin.Movement.fly.toggle() end
        elseif msg == "/noclip" then
            if Admin.Movement and Admin.Movement.noclip and Admin.Movement.noclip.toggle then Admin.Movement.noclip.toggle() end
        elseif msg == "/god" or msg == "/godmode" then
            local toggled = false
            if Admin.CharacterMods and Admin.CharacterMods.godmode and Admin.CharacterMods.godmode.toggle then
                Admin.CharacterMods.godmode.toggle()
                toggled = true
            end
            if not toggled and Admin.Character and Admin.Character.godmode and Admin.Character.godmode.toggle then
                Admin.Character.godmode.toggle()
            end
        elseif msg == "/selftest" then
            print("[TEST] Iniciando autoteste...")
            local function ok(b) return b and "OK" or "NOK" end
            print("[TEST] PlayerGui:", ok(Player and Player:FindFirstChildOfClass("PlayerGui")))
            print("[TEST] GUI.main:", ok(Admin.GUI and Admin.GUI.main))
            print("[TEST] Movement.fly:", ok(Admin.Movement and Admin.Movement.fly and type(Admin.Movement.fly.toggle)=="function"))
            print("[TEST] Movement.noclip:", ok(Admin.Movement and Admin.Movement.noclip and type(Admin.Movement.noclip.toggle)=="function"))
            print("[TEST] Movement.speed:", ok(Admin.Movement and Admin.Movement.speed and type(Admin.Movement.speed.set)=="function"))
            print("[TEST] Character.godmode:", ok((Admin.Character and Admin.Character.godmode) or (Admin.CharacterMods and Admin.CharacterMods.godmode)))
            print("[TEST] Fim do autoteste.")
        end
    end)
    Admin.Connections.ChatCommands = conn
end

-- Start
local function start()
    local ok = loadAllModules()
    if not ok then warn("[INIT] ❌ Falha ao carregar alguns módulos") end
    if Admin.Config.chatCommands then setupChatCommands() end
    if Admin.Config.autoLoadGUI and Admin.GUI and Admin.GUI.main and Admin.GUI.main.show then
        task.wait(0.4)
        pcall(Admin.GUI.main.show)
    end
    print("[INIT] ✅ Admin Script v" .. Admin.version .. " pronto")

    -- Modo diagnóstico: monitorar CoreGui para identificar criadores de scripts efêmeros
    if Admin.Config.diagnosticsCoreGui then
        local CoreGui = game:GetService("CoreGui")
        local function describe(inst)
            local ok, path = pcall(function()
                local p = {}
                local node = inst
                local n = 0
                while node and n < 6 do
                    table.insert(p, 1, node.Name .. "(" .. node.ClassName .. ")")
                    node = node.Parent
                    n = n + 1
                end
                return table.concat(p, "/")
            end)
            return ok and path or (inst.ClassName .. "?" )
        end
        local function onAdded(child)
            local msg = "[DIAG] CoreGui added: " .. describe(child)
            if Admin.Config.diagnosticsVerbosity > 0 then print(msg) end
        end
        Admin.Connections.CoreGuiAdded = CoreGui.ChildAdded:Connect(onAdded)
        Admin.Connections.CoreGuiDescAdded = CoreGui.DescendantAdded:Connect(function(d)
            if Admin.Config.diagnosticsVerbosity > 1 then print("[DIAG] CoreGui desc: " .. describe(d)) end
        end)
        print("[DIAG] Monitoramento de CoreGui habilitado")
    end
end

start()