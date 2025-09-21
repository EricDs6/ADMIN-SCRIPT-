--[[
    Módulo de Godmode (Invencibilidade)
    Parte do Admin Script Modular v2.0
    
    Funcionalidades:
    - Tornar o personagem invencível
    - Proteção contra dano
    - Recuperação automática de vida
    - Reset de estado ao morrer
]]

-- Verificar se AdminScript está disponível
local Admin = _G.AdminScript
if not Admin then
    warn("❌ AdminScript não inicializado! Módulo de godmode não pode ser carregado.")
    return
end

local Services = Admin.Services
local Player = Admin.Player

-- Estado do módulo
local GodmodeModule = {
    enabled = false,
    connections = {}
}

-- Constantes
local MAX_HEALTH = 100
local HEALTH_CHECK_INTERVAL = 0.5 -- Segundos

-- Função para aplicar invencibilidade
local function applyGodmode(humanoid)
    if not humanoid then return end
    
    -- Guardar valores originais
    Admin.OriginalValues.Humanoid = Admin.OriginalValues.Humanoid or {}
    Admin.OriginalValues.Humanoid.MaxHealth = humanoid.MaxHealth
    
    -- Definir vida máxima
    humanoid.MaxHealth = 999999
    wait() -- Pequena pausa para permitir que o valor seja aplicado
    humanoid.Health = humanoid.MaxHealth
    
    -- Conectar evento para evitar dano
    local damageConnection = humanoid:GetPropertyChangedSignal("Health"):Connect(function()
        if not GodmodeModule.enabled then return end
        
        if humanoid.Health < humanoid.MaxHealth then
            humanoid.Health = humanoid.MaxHealth
        end
    end)
    
    -- Salvar conexão para limpar depois
    table.insert(GodmodeModule.connections, damageConnection)
end

-- Função para desativar invencibilidade
local function removeGodmode(humanoid)
    if not humanoid then return end
    
    -- Restaurar valores originais
    if Admin.OriginalValues.Humanoid and Admin.OriginalValues.Humanoid.MaxHealth then
        humanoid.MaxHealth = Admin.OriginalValues.Humanoid.MaxHealth
        wait() -- Pequena pausa para permitir que o valor seja aplicado
        humanoid.Health = humanoid.MaxHealth
    end
    
    -- Limpar conexões
    for _, connection in pairs(GodmodeModule.connections) do
        if typeof(connection) == "RBXScriptConnection" and connection.Connected then
            connection:Disconnect()
        end
    end
    
    GodmodeModule.connections = {}
end

-- Função para ativar godmode
local function enableGodmode()
    -- Verificar se já está ativo
    if GodmodeModule.enabled then return true end
    
    -- Verificar personagem
    local character = Player.Character
    if not character then
        warn("❌ Personagem não encontrado!")
        return false
    end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then
        warn("❌ Humanoid não encontrado!")
        return false
    end
    
    -- Aplicar godmode
    applyGodmode(humanoid)
    
    -- Conectar evento para monitorar personagem
    local healthCheckConnection = Services.RunService.Heartbeat:Connect(function()
        if not GodmodeModule.enabled then return end
        
        -- Verificar personagem atual
        local currentCharacter = Player.Character
        if not currentCharacter then return end
        
        local currentHumanoid = currentCharacter:FindFirstChildOfClass("Humanoid")
        if not currentHumanoid then return end
        
        -- Garantir que a vida esteja no máximo
        if currentHumanoid.Health < currentHumanoid.MaxHealth then
            currentHumanoid.Health = currentHumanoid.MaxHealth
        end
    end)
    
    table.insert(GodmodeModule.connections, healthCheckConnection)
    
    -- Atualizar estado
    GodmodeModule.enabled = true
    
    -- Notificar
    if Admin.Config.debugMode then
        print("🛡️ Modo invencível ativado")
    end
    
    return true
end

-- Função para desativar godmode
local function disableGodmode()
    -- Verificar se está ativo
    if not GodmodeModule.enabled then return true end
    
    -- Verificar personagem
    local character = Player.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            removeGodmode(humanoid)
        end
    end
    
    -- Atualizar estado
    GodmodeModule.enabled = false
    
    -- Notificar
    if Admin.Config.debugMode then
        print("❌ Modo invencível desativado")
    end
    
    return true
end

-- Função para alternar godmode
local function toggleGodmode()
    if GodmodeModule.enabled then
        return disableGodmode()
    else
        return enableGodmode()
    end
end

-- Verificar alterações de personagem
Admin.onCharacterChanged = Admin.onCharacterChanged or function() end

local originalOnCharacterChanged = Admin.onCharacterChanged
Admin.onCharacterChanged = function(character)
    originalOnCharacterChanged(character)
    
    -- Se godmode estiver ativo, desativar e reativar para o novo personagem
    if GodmodeModule.enabled then
        wait(1) -- Aguardar carregamento do personagem
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            applyGodmode(humanoid)
        end
    end
end

-- Exportar funções do módulo
local API = {
    enable = enableGodmode,
    disable = disableGodmode,
    toggle = toggleGodmode,
    isEnabled = function() return GodmodeModule.enabled end
}

-- Registrar na API global
Admin.Character.godmode = API

-- Registrar no sistema de conexões para limpeza
Admin.Connections.GodmodeModule = GodmodeModule

-- Mensagem de carregamento
print("✅ Módulo de invencibilidade carregado!")
print("💡 Use Admin.Character.godmode.toggle() para ativar/desativar")

-- Retornar API do módulo
return API