--[[
    Módulo de Speed (Velocidade)
    Parte do Admin Script Modular v2.0
    
    Funcionalidades:
    - Alterar velocidade de movimento do personagem
    - Valores padrão e possibilidade de personalização
    - Reset automático ao morrer
]]

-- Verificar se AdminScript está disponível
local Admin = _G.AdminScript
if not Admin then
    warn("❌ AdminScript não inicializado! Módulo de speed não pode ser carregado.")
    return
end

local Services = Admin.Services
local Player = Admin.Player

-- Estado do módulo
local SpeedModule = {
    enabled = false,
    originalSpeed = 16, -- Velocidade padrão do Roblox
    currentSpeed = 16,
    connection = nil
}

-- Função para definir velocidade
local function setSpeed(speed)
    -- Verificar argumentos
    if type(speed) ~= "number" or speed < 0 then
        warn("❌ Velocidade inválida! Use um número positivo.")
        return false
    end
    
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
    
    -- Armazenar velocidade original na primeira vez
    if not SpeedModule.enabled then
        SpeedModule.originalSpeed = humanoid.WalkSpeed
        SpeedModule.enabled = true
    end
    
    -- Aplicar nova velocidade
    SpeedModule.currentSpeed = speed
    humanoid.WalkSpeed = speed
    
    -- Notificar
    if Admin.Config.debugMode then
        print("⚡ Velocidade definida para " .. speed)
    end
    
    return true
end

-- Função para resetar velocidade
local function resetSpeed()
    -- Verificar personagem
    local character = Player.Character
    if not character then
        SpeedModule.enabled = false
        return true -- Retornar true mesmo sem personagem, pois o objetivo foi alcançado
    end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then
        SpeedModule.enabled = false
        return true -- Retornar true mesmo sem humanoid, pois o objetivo foi alcançado
    end
    
    -- Restaurar velocidade original
    humanoid.WalkSpeed = SpeedModule.originalSpeed
    
    -- Atualizar estado
    SpeedModule.enabled = false
    SpeedModule.currentSpeed = SpeedModule.originalSpeed
    
    -- Notificar
    if Admin.Config.debugMode then
        print("🔄 Velocidade resetada para " .. SpeedModule.originalSpeed)
    end
    
    return true
end

-- Função para aumentar velocidade
local function increaseSpeed(amount)
    amount = amount or 5 -- Valor padrão de incremento
    
    -- Verificar se o módulo está ativo
    if not SpeedModule.enabled then
        -- Armazenar velocidade atual
        local character = Player.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                SpeedModule.originalSpeed = humanoid.WalkSpeed
                SpeedModule.currentSpeed = humanoid.WalkSpeed
                SpeedModule.enabled = true
            end
        end
    end
    
    -- Calcular nova velocidade
    local newSpeed = SpeedModule.currentSpeed + amount
    
    -- Aplicar nova velocidade
    return setSpeed(newSpeed)
end

-- Função para diminuir velocidade
local function decreaseSpeed(amount)
    amount = amount or 5 -- Valor padrão de decremento
    
    -- Verificar se o módulo está ativo
    if not SpeedModule.enabled then
        -- Armazenar velocidade atual
        local character = Player.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                SpeedModule.originalSpeed = humanoid.WalkSpeed
                SpeedModule.currentSpeed = humanoid.WalkSpeed
                SpeedModule.enabled = true
            end
        end
    end
    
    -- Calcular nova velocidade (mínimo 1)
    local newSpeed = math.max(1, SpeedModule.currentSpeed - amount)
    
    -- Aplicar nova velocidade
    return setSpeed(newSpeed)
end

-- Função para obter velocidade atual
local function getCurrentSpeed()
    return SpeedModule.currentSpeed
end

-- Verificar alterações de personagem
Admin.onCharacterChanged = Admin.onCharacterChanged or function() end

local originalOnCharacterChanged = Admin.onCharacterChanged
Admin.onCharacterChanged = function(character)
    originalOnCharacterChanged(character)
    
    -- Se velocidade estiver modificada, aplicar ao novo personagem
    if SpeedModule.enabled then
        wait(0.5) -- Pequeno atraso para garantir que o personagem esteja carregado
        setSpeed(SpeedModule.currentSpeed)
    end
end

-- Monitorar casos de morte para restaurar velocidade se necessário
local function setupDeathWatch()
    local function onDied()
        if Admin.Config.disableOnDeath and SpeedModule.enabled then
            resetSpeed()
        end
    end
    
    -- Conectar evento de morte
    local character = Player.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            SpeedModule.connection = humanoid.Died:Connect(onDied)
        end
    end
    
    -- Monitorar troca de personagem
    Player.CharacterAdded:Connect(function(newCharacter)
        wait(1) -- Aguardar carregamento
        
        local humanoid = newCharacter:FindFirstChildOfClass("Humanoid")
        if humanoid then
            -- Desconectar conexão anterior
            if SpeedModule.connection then
                SpeedModule.connection:Disconnect()
            end
            
            -- Criar nova conexão
            SpeedModule.connection = humanoid.Died:Connect(onDied)
            
            -- Reaplicar velocidade se necessário
            if SpeedModule.enabled then
                humanoid.WalkSpeed = SpeedModule.currentSpeed
            end
        end
    end)
end

-- Inicializar monitoramento
setupDeathWatch()

-- Exportar funções do módulo
local API = {
    set = setSpeed,
    reset = resetSpeed,
    increase = increaseSpeed,
    decrease = decreaseSpeed,
    getCurrent = getCurrentSpeed,
    getOriginal = function() return SpeedModule.originalSpeed end,
    isEnabled = function() return SpeedModule.enabled end
}

-- Registrar na API global
Admin.Movement.speed = API

-- Registrar no sistema de conexões para limpeza
Admin.Connections.SpeedModule = SpeedModule

-- Mensagem de carregamento
print("✅ Módulo de velocidade carregado!")
print("💡 Use Admin.Movement.speed.set(valor) para definir velocidade")
print("💡 Use Admin.Movement.speed.increase() e decrease() para ajustar")
print("💡 Use Admin.Movement.speed.reset() para restaurar velocidade normal")

-- Retornar API do módulo
return API