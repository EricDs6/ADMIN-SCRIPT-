-- Módulo de Noclip (Atravessar Paredes)
-- Funcionalidade: Permite atravessar paredes desabilitando colisão
-- Carregado via _G.AdminScript

-- Verificar se AdminScript está disponível
local Admin = _G.AdminScript
if not Admin then
    warn("❌ Sistema AdminScript não inicializado!")
    return
end

local Services = Admin.Services
local Player = Admin.Player

print("👻 Carregando módulo de noclip...")

-- Estado do módulo
local NoclipModule = {
    enabled = false,
    connection = nil
}

-- Função para ativar noclip
local function enableNoclip()
    local character = Admin.Character
    if not character then
        warn("❌ Personagem não encontrado!")
        return false
    end
    
    -- Loop para desabilitar colisão continuamente
    NoclipModule.connection = Services.RunService.Stepped:Connect(function()
        if not NoclipModule.enabled then return end
        if not Admin.Character then return end
        
        -- Desabilitar colisão de todas as partes do personagem
        for _, part in pairs(Admin.Character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end)
    
    print("👻 Atravessar paredes ativado!")
    return true
end

-- Função para desativar noclip
local function disableNoclip()
    -- Desconectar loop de noclip
    if NoclipModule.connection then
        NoclipModule.connection:Disconnect()
        NoclipModule.connection = nil
    end
    
    -- Restaurar colisão das partes (exceto HumanoidRootPart)
    if Admin.Character then
        for _, part in pairs(Admin.Character:GetChildren()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.CanCollide = true
            end
        end
    end
    
    print("🚧 Atravessar paredes desativado!")
end

-- Função principal para alternar noclip
local function toggleNoclip()
    NoclipModule.enabled = not NoclipModule.enabled
    
    if NoclipModule.enabled then
        local success = enableNoclip()
        if not success then
            NoclipModule.enabled = false
        end
    else
        disableNoclip()
    end
    
    return NoclipModule.enabled
end

-- Função para obter estado atual
local function isNoclipping()
    return NoclipModule.enabled
end

-- Função para forçar atravessar uma vez (útil para sair de dentro de paredes)
local function forceNoclipOnce()
    if Admin.Character then
        for _, part in pairs(Admin.Character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
        
        -- Restaurar após um breve período
        wait(0.5)
        
        for _, part in pairs(Admin.Character:GetChildren()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.CanCollide = true
            end
        end
        
        print("⚡ Noclip temporário aplicado!")
    end
end

-- Registrar funções no sistema global
if not Admin.Movement then
    Admin.Movement = {}
end

Admin.Movement.Noclip = {
    toggle = toggleNoclip,
    enable = function() 
        if not NoclipModule.enabled then 
            return toggleNoclip() 
        end 
        return true 
    end,
    disable = function() 
        if NoclipModule.enabled then 
            return not toggleNoclip() 
        end 
        return true 
    end,
    isEnabled = isNoclipping,
    forceOnce = forceNoclipOnce,
    -- Compatibilidade com sistema antigo
    noclipEnabled = function() return NoclipModule.enabled end
}

-- Registrar no sistema de conexões para limpeza
Admin.Connections.NoclipModule = NoclipModule

print("✅ Módulo de noclip carregado!")
print("💡 Use Admin.Movement.Noclip.toggle() para ativar/desativar")
print("💡 Use Admin.Movement.Noclip.forceOnce() para atravessar temporariamente")