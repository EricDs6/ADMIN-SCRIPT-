--[[
    Módulo de Noclip (Atravessar Paredes)
    Parte do Admin Script Modular v2.0
    
    Funcionalidades:
    - Atravessar paredes e objetos
    - Opção para atravessar apenas uma vez
    - Compatível com o módulo de voo
]]

-- Verificar se AdminScript está disponível
local Admin = _G.AdminScript
if not Admin then
    warn("❌ AdminScript não inicializado! Módulo de noclip não pode ser carregado.")
    return
end

local Services = Admin.Services
local Player = Admin.Player

-- Estado do módulo
local NoclipModule = {
    enabled = false,
    connection = nil,
    temporaryNoclip = false
}

-- Função para aplicar noclip
local function applyNoclip(character)
    if not character then return end
    
    -- Aplicar noclip a todas as partes do personagem
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") and part.CanCollide then
            part.CanCollide = false
        end
    end
end

-- Função para restaurar colisões
local function restoreCollisions(character)
    if not character then return end
    
    -- Restaurar colisões a todas as partes do personagem, exceto HumanoidRootPart
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            part.CanCollide = true
        end
    end
end

-- Função para ativar noclip
local function enableNoclip()
    -- Verificar se já está ativo
    if NoclipModule.enabled then return true end
    
    -- Verificar personagem
    local character = Player.Character
    if not character then
        warn("❌ Personagem não encontrado!")
        return false
    end
    
    -- Aplicar noclip inicial
    applyNoclip(character)
    
    -- Conectar evento de atualização contínua
    NoclipModule.connection = Services.RunService.Stepped:Connect(function()
        applyNoclip(character)
    end)
    
    -- Atualizar estado
    NoclipModule.enabled = true
    NoclipModule.temporaryNoclip = false
    
    -- Notificar
    if Admin.Config.debugMode then
        print("👻 Modo noclip ativado")
    end
    
    return true
end

-- Função para desativar noclip
local function disableNoclip()
    -- Verificar se está ativo
    if not NoclipModule.enabled then return true end
    
    -- Desconectar evento
    if NoclipModule.connection then
        NoclipModule.connection:Disconnect()
        NoclipModule.connection = nil
    end
    
    -- Restaurar colisões
    local character = Player.Character
    if character then
        restoreCollisions(character)
    end
    
    -- Atualizar estado
    NoclipModule.enabled = false
    NoclipModule.temporaryNoclip = false
    
    -- Notificar
    if Admin.Config.debugMode then
        print("🧱 Modo noclip desativado")
    end
    
    return true
end

-- Função para alternar noclip
local function toggleNoclip()
    if NoclipModule.enabled then
        return disableNoclip()
    else
        return enableNoclip()
    end
end

-- Função para aplicar noclip temporário (uma vez)
local function forceNoclipOnce()
    -- Verificar personagem
    local character = Player.Character
    if not character then
        warn("❌ Personagem não encontrado!")
        return false
    end
    
    -- Se noclip já estiver ativo, não fazer nada
    if NoclipModule.enabled then
        return true
    end
    
    -- Aplicar noclip
    applyNoclip(character)
    
    -- Configurar temporizador para restaurar colisões
    NoclipModule.temporaryNoclip = true
    
    -- Notificar
    if Admin.Config.debugMode then
        print("⏱️ Noclip temporário aplicado")
    end
    
    -- Restaurar após 1 segundo se noclip permanente não for ativado
    task.delay(1, function()
        if NoclipModule.temporaryNoclip and not NoclipModule.enabled then
            restoreCollisions(character)
            NoclipModule.temporaryNoclip = false
            
            if Admin.Config.debugMode then
                print("⏱️ Noclip temporário finalizado")
            end
        end
    end)
    
    return true
end

-- Função para verificar se noclip está ativo
local function isNoclipping()
    return NoclipModule.enabled
end

-- Verificar alterações de personagem
Admin.onCharacterChanged = Admin.onCharacterChanged or function() end

local originalOnCharacterChanged = Admin.onCharacterChanged
Admin.onCharacterChanged = function(character)
    originalOnCharacterChanged(character)
    
    -- Se noclip estiver ativo, desativar e reativar para o novo personagem
    if NoclipModule.enabled then
        disableNoclip()
        wait(0.5) -- Pequeno atraso para garantir que o personagem esteja carregado
        enableNoclip()
    end
end

-- Exportar funções do módulo
local API = {
    enable = enableNoclip,
    disable = disableNoclip,
    toggle = toggleNoclip,
    forceOnce = forceNoclipOnce,
    isEnabled = isNoclipping
}

-- Registrar na API global
Admin.Movement.noclip = API

-- Registrar no sistema de conexões para limpeza
Admin.Connections.NoclipModule = NoclipModule

-- Mensagem de carregamento
print("✅ Módulo de noclip carregado!")
print("💡 Use Admin.Movement.noclip.toggle() para ativar/desativar")
print("💡 Use Admin.Movement.noclip.forceOnce() para atravessar uma única vez")

-- Retornar API do módulo
return API