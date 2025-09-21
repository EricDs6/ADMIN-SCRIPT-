--[[
    Módulo de Voo (Fly)
    Parte do Admin Script Modular v2.0
    
    Funcionalidades:
    - Voar com controles WASD + Espaço/Ctrl
    - Ajuste de velocidade
    - Suporte a veículos
    - Modo compatível com noclip
]]

-- Verificar se AdminScript está disponível
local Admin = _G.AdminScript
if not Admin then
    warn("❌ AdminScript não inicializado! Módulo de voo não pode ser carregado.")
    return
end

local Services = Admin.Services
local Player = Admin.Player

-- Estado do módulo
local FlyModule = {
    enabled = false,
    speed = Admin.Config.defaultFlySpeed or 50,
    bodyVelocity = nil,
    bodyGyro = nil,
    weld = nil,
    connection = nil,
    vehicle = nil,
    seat = nil,
    useNoclip = false
}

-- Constantes
local CONTROL_ACTIONS = {
    moveForward = false,
    moveBackward = false,
    moveRight = false,
    moveLeft = false,
    moveUp = false,
    moveDown = false
}

-- Função para encontrar o veículo
local function findVehicle()
    -- Atualizar referência do personagem
    local character = Player.Character
    if not character then
        return nil, nil
    end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then
        return nil, nil
    end
    
    if humanoid.SeatPart and (humanoid.SeatPart:IsA("Seat") or humanoid.SeatPart:IsA("VehicleSeat")) then
        local seat = humanoid.SeatPart
        local vehicle = seat:FindFirstAncestorOfClass("Model")
        return vehicle, seat
    end
    
    return nil, nil
end

-- Função para controlar o voo
local function flyStep()
    if not FlyModule.enabled then return end
    
    -- Obter referências atuais do personagem
    local character = Player.Character
    if not character then return end
    
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    -- Calcular direção baseada nos controles
    local flyDirection = Vector3.new(0, 0, 0)
    
    -- Frente/Trás
    if CONTROL_ACTIONS.moveForward then
        flyDirection = flyDirection + (hrp.CFrame.LookVector * 1)
    end
    if CONTROL_ACTIONS.moveBackward then
        flyDirection = flyDirection + (hrp.CFrame.LookVector * -1)
    end
    
    -- Esquerda/Direita
    if CONTROL_ACTIONS.moveRight then
        flyDirection = flyDirection + (hrp.CFrame.RightVector * 1)
    end
    if CONTROL_ACTIONS.moveLeft then
        flyDirection = flyDirection + (hrp.CFrame.RightVector * -1)
    end
    
    -- Cima/Baixo
    if CONTROL_ACTIONS.moveUp then
        flyDirection = flyDirection + Vector3.new(0, 1, 0)
    end
    if CONTROL_ACTIONS.moveDown then
        flyDirection = flyDirection + Vector3.new(0, -1, 0)
    end
    
    -- Normalizar e aplicar velocidade
    if flyDirection.Magnitude > 0 then
        flyDirection = flyDirection.Unit * FlyModule.speed
    end
    
    -- Aplicar velocidade
    if FlyModule.vehicle then
        -- Se estiver em veículo
        if FlyModule.bodyVelocity and FlyModule.bodyVelocity.Parent then
            FlyModule.bodyVelocity.Velocity = flyDirection
        end
    else
        -- Se estiver a pé
        if FlyModule.bodyVelocity and FlyModule.bodyVelocity.Parent then
            FlyModule.bodyVelocity.Velocity = flyDirection
        end
    end
end

-- Função para configurar os controles
local function setupFlyControls()
    local userInputService = Services.UserInputService
    
    -- Detectar teclas pressionadas
    local function onInputBegan(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode.W then
            CONTROL_ACTIONS.moveForward = true
        elseif input.KeyCode == Enum.KeyCode.S then
            CONTROL_ACTIONS.moveBackward = true
        elseif input.KeyCode == Enum.KeyCode.D then
            CONTROL_ACTIONS.moveRight = true
        elseif input.KeyCode == Enum.KeyCode.A then
            CONTROL_ACTIONS.moveLeft = true
        elseif input.KeyCode == Enum.KeyCode.Space then
            CONTROL_ACTIONS.moveUp = true
        elseif input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.RightControl then
            CONTROL_ACTIONS.moveDown = true
        end
    end
    
    -- Detectar teclas liberadas
    local function onInputEnded(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode.W then
            CONTROL_ACTIONS.moveForward = false
        elseif input.KeyCode == Enum.KeyCode.S then
            CONTROL_ACTIONS.moveBackward = false
        elseif input.KeyCode == Enum.KeyCode.D then
            CONTROL_ACTIONS.moveRight = false
        elseif input.KeyCode == Enum.KeyCode.A then
            CONTROL_ACTIONS.moveLeft = false
        elseif input.KeyCode == Enum.KeyCode.Space then
            CONTROL_ACTIONS.moveUp = false
        elseif input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.RightControl then
            CONTROL_ACTIONS.moveDown = false
        end
    end
    
    -- Conectar eventos
    Admin.Connections.FlyInputBegan = userInputService.InputBegan:Connect(onInputBegan)
    Admin.Connections.FlyInputEnded = userInputService.InputEnded:Connect(onInputEnded)
end

-- Função para ativar voo
local function enableFly()
    -- Verificar se já está voando
    if FlyModule.enabled then return true end
    
    -- Verificar personagem
    local character = Player.Character
    if not character then
        warn("❌ Personagem não encontrado!")
        return false
    end
    
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then
        warn("❌ HumanoidRootPart não encontrado!")
        return false
    end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then
        warn("❌ Humanoid não encontrado!")
        return false
    end
    
    -- Verificar se está em veículo
    FlyModule.vehicle, FlyModule.seat = findVehicle()
    
    -- Ativar noclip se configurado
    if FlyModule.useNoclip and Admin.Movement.noclip and Admin.Movement.noclip.enable then
        Admin.Movement.noclip.enable()
    end
    
    -- Criar controles de física para voo
    if FlyModule.vehicle then
        -- Controles para veículo
        local primaryPart = FlyModule.vehicle.PrimaryPart or FlyModule.seat
        
        -- Criar BodyVelocity para o veículo
        FlyModule.bodyVelocity = Instance.new("BodyVelocity")
        FlyModule.bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        FlyModule.bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        FlyModule.bodyVelocity.Parent = primaryPart
        
        -- Criar BodyGyro para manter orientação
        FlyModule.bodyGyro = Instance.new("BodyGyro")
        FlyModule.bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        FlyModule.bodyGyro.D = 100
        FlyModule.bodyGyro.P = 10000
        FlyModule.bodyGyro.CFrame = primaryPart.CFrame
        FlyModule.bodyGyro.Parent = primaryPart
    else
        -- Controles para personagem a pé
        -- Criar BodyVelocity para o personagem
        FlyModule.bodyVelocity = Instance.new("BodyVelocity")
        FlyModule.bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        FlyModule.bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        FlyModule.bodyVelocity.Parent = hrp
        
        -- Criar BodyGyro para manter orientação
        FlyModule.bodyGyro = Instance.new("BodyGyro")
        FlyModule.bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        FlyModule.bodyGyro.D = 100
        FlyModule.bodyGyro.P = 10000
        FlyModule.bodyGyro.CFrame = hrp.CFrame
        FlyModule.bodyGyro.Parent = hrp
        
        -- Guardar valores originais da gravidade para restaurar depois
        Admin.OriginalValues.Humanoid = Admin.OriginalValues.Humanoid or {}
        Admin.OriginalValues.Humanoid.PlatformStand = humanoid.PlatformStand
        
        -- Desabilitar gravidade
        humanoid.PlatformStand = true
    end
    
    -- Configurar controles
    setupFlyControls()
    
    -- Conectar evento de atualização
    FlyModule.connection = Services.RunService.Heartbeat:Connect(flyStep)
    
    -- Atualizar estado
    FlyModule.enabled = true
    
    -- Notificar
    if Admin.Config.debugMode then
        print("✈️ Modo de voo ativado" .. (FlyModule.vehicle and " (veículo)" or ""))
    end
    
    return true
end

-- Função para desativar voo
local function disableFly()
    -- Verificar se está voando
    if not FlyModule.enabled then return true end
    
    -- Desativar noclip se foi ativado pelo módulo
    if FlyModule.useNoclip and Admin.Movement.noclip and Admin.Movement.noclip.disable then
        Admin.Movement.noclip.disable()
    end
    
    -- Remover controles de física
    if FlyModule.bodyVelocity then
        FlyModule.bodyVelocity:Destroy()
        FlyModule.bodyVelocity = nil
    end
    
    if FlyModule.bodyGyro then
        FlyModule.bodyGyro:Destroy()
        FlyModule.bodyGyro = nil
    end
    
    if FlyModule.weld then
        FlyModule.weld:Destroy()
        FlyModule.weld = nil
    end
    
    -- Desconectar eventos
    if FlyModule.connection then
        FlyModule.connection:Disconnect()
        FlyModule.connection = nil
    end
    
    if Admin.Connections.FlyInputBegan then
        Admin.Connections.FlyInputBegan:Disconnect()
        Admin.Connections.FlyInputBegan = nil
    end
    
    if Admin.Connections.FlyInputEnded then
        Admin.Connections.FlyInputEnded:Disconnect()
        Admin.Connections.FlyInputEnded = nil
    end
    
    -- Resetar controles
    for action in pairs(CONTROL_ACTIONS) do
        CONTROL_ACTIONS[action] = false
    end
    
    -- Restaurar valores originais
    local character = Player.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid and Admin.OriginalValues.Humanoid then
            humanoid.PlatformStand = Admin.OriginalValues.Humanoid.PlatformStand
        end
    end
    
    -- Limpar referências
    FlyModule.vehicle = nil
    FlyModule.seat = nil
    
    -- Atualizar estado
    FlyModule.enabled = false
    
    -- Notificar
    if Admin.Config.debugMode then
        print("🛬 Modo de voo desativado")
    end
    
    return true
end

-- Função para alternar voo
local function toggleFly()
    if FlyModule.enabled then
        return disableFly()
    else
        return enableFly()
    end
end

-- Função para definir velocidade
local function setFlySpeed(speed)
    if type(speed) ~= "number" or speed <= 0 then
        warn("❌ Velocidade inválida! Use um número positivo.")
        return false
    end
    
    FlyModule.speed = speed
    
    if Admin.Config.debugMode then
        print("🚀 Velocidade de voo definida para " .. speed)
    end
    
    return true
end

-- Função para verificar se está voando
local function isFlying()
    return FlyModule.enabled
end

-- Verificar alterações de personagem
Admin.onCharacterChanged = Admin.onCharacterChanged or function() end

local originalOnCharacterChanged = Admin.onCharacterChanged
Admin.onCharacterChanged = function(character)
    originalOnCharacterChanged(character)
    
    -- Se o voo estiver ativo, desativar e reativar para o novo personagem
    if FlyModule.enabled then
        disableFly()
        wait(0.5) -- Pequeno atraso para garantir que o personagem esteja carregado
        enableFly()
    end
end

-- Exportar funções do módulo
local API = {
    enable = enableFly,
    disable = disableFly,
    toggle = toggleFly,
    setSpeed = setFlySpeed,
    getSpeed = function() return FlyModule.speed end,
    isEnabled = isFlying,
    
    -- Propriedade para controlar se deve ativar noclip junto
    useNoclip = function(value)
        if value ~= nil then
            FlyModule.useNoclip = value
            return value
        end
        return FlyModule.useNoclip
    end
}

-- Registrar na API global
Admin.Movement.fly = API

-- Registrar no sistema de conexões para limpeza
Admin.Connections.FlyModule = FlyModule

-- Mensagem de carregamento
print("✅ Módulo de voo carregado!")
print("💡 Use Admin.Movement.fly.toggle() para ativar/desativar")
print("💡 Use Admin.Movement.fly.setSpeed(valor) para ajustar velocidade")

-- Retornar API do módulo
return API