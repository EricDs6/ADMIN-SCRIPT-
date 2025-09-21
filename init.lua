-- Admin Script Modular - Loader Principal
-- Execução: loadstring(game:HttpGet("https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-/main/init.lua"))()

print("🚀 Carregando Admin Script Modular - Movimento...")

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
        
        -- GUI elementos
        GUI = {},
        
        -- Estados dos módulos
        Movement = {
            flyEnabled = false,
            noclipEnabled = false,
            flySpeed = 50
        }
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

-- Função para carregar módulos via HTTP
local function loadModule(moduleName)
    local baseURL = "https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-/main/modules/"
    local url = baseURL .. moduleName .. ".lua"
    
    print("📦 Carregando módulo: " .. moduleName)
    
    -- Obter loadstring compatível
    local compile = getLoadstring()
    if not compile then
        warn("❌ Nenhuma função loadstring disponível no executor!")
        warn("💡 Tente usar um executor como Synapse X, KRNL ou Script-Ware")
        return false
    end
    
    -- Baixar código do módulo
    local result = httpGet(url)
    if not result then
        warn("❌ Falha ao baixar módulo: " .. moduleName)
        warn("💡 Verifique sua conexão com a internet")
        return false
    end
    
    -- Compilar e executar
    local success, moduleFunction = pcall(compile, result)
    if success and moduleFunction then
        local execSuccess, execError = pcall(moduleFunction)
        if execSuccess then
            print("✅ Módulo " .. moduleName .. " carregado com sucesso!")
            return true
        else
            warn("❌ Erro ao executar módulo " .. moduleName .. ": " .. tostring(execError))
        end
    else
        warn("❌ Falha ao compilar módulo " .. moduleName .. ": " .. tostring(moduleFunction))
    end
    
    return false
end

-- Função de limpeza
local function cleanup()
    -- Desconectar todas as conexões
    for name, connection in pairs(Admin.Connections) do
        if connection and typeof(connection) == "RBXScriptConnection" then
            pcall(function() connection:Disconnect() end)
        end
    end
    Admin.Connections = {}
    
    -- Remover objetos de física se existirem
    if Admin.Movement and Admin.Movement.BodyVelocity then
        pcall(function() Admin.Movement.BodyVelocity:Destroy() end)
        Admin.Movement.BodyVelocity = nil
    end
    if Admin.Movement and Admin.Movement.BodyGyro then
        pcall(function() Admin.Movement.BodyGyro:Destroy() end)
        Admin.Movement.BodyGyro = nil
    end
    
    -- Restaurar valores originais
    if Admin.Humanoid and Admin.OriginalValues then
        -- Restaurar saúde
        if Admin.OriginalValues.Health and Admin.OriginalValues.MaxHealth then
            Admin.Humanoid.MaxHealth = Admin.OriginalValues.MaxHealth
            Admin.Humanoid.Health = math.max(Admin.OriginalValues.Health, Admin.OriginalValues.MaxHealth * 0.5)
        end
        
        -- Restaurar PlatformStand
        if Admin.OriginalValues.PlatformStand ~= nil then
            Admin.Humanoid.PlatformStand = Admin.OriginalValues.PlatformStand
        end
        
        -- Restaurar estados do humanoid
        if Admin.OriginalValues.StatesEnabled then
            for state, wasEnabled in pairs(Admin.OriginalValues.StatesEnabled) do
                pcall(function() Admin.Humanoid:SetStateEnabled(state, wasEnabled) end)
            end
        end
        
        -- Restaurar velocidade de caminhada
        if Admin.OriginalValues.WalkSpeed then
            Admin.Humanoid.WalkSpeed = Admin.OriginalValues.WalkSpeed
        end
    end
    
    -- Limpar valores originais
    Admin.OriginalValues = {}
    
    -- Restaurar colisão das partes do character
    if Admin.Character then
        for _, part in pairs(Admin.Character:GetChildren()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.CanCollide = true
            end
        end
    end
    
    -- Remover GUI
    if Admin.GUI.ScreenGui then
        Admin.GUI.ScreenGui:Destroy()
        Admin.GUI = {}
    end
    
    -- Resetar estados dos módulos
    if Admin.Movement then
        Admin.Movement.flyEnabled = false
        Admin.Movement.noclipEnabled = false
    end
    
    print("🧹 Sistema limpo!")
    print("🛡️ Todos os valores foram restaurados!")
end

-- Comando de limpeza via chat
Admin.Connections.Chat = Player.Chatted:Connect(function(message)
    if message:lower() == "/cleanup" or message:lower() == "/limpar" then
        cleanup()
    end
end)

-- Conectar evento de respawn
Admin.Connections.CharacterAdded = Player.CharacterAdded:Connect(function()
    updateCharacter()
end)

-- Inicialização
updateCharacter()

-- Carregar módulo de movimento
loadModule("movement")

print("✅ Sistema base carregado! Digite /cleanup para limpar tudo.")