-- Módulo de Voo (Fly)
-- Funcionalidade: Permite voar com controles WASD + Espaço/Ctrl
-- Carregado via _G.AdminScript

-- Verificar se AdminScript está disponível
local Admin = _G.AdminScript
if not Admin then
    warn("❌ Sistema AdminScript não inicializado!")
    return
end

local Services = Admin.Services
local Player = Admin.Player

print("✈️ Carregando módulo de voo...")

-- Estado do módulo
local FlyModule = {
    enabled = false,
    speed = 50,
    bodyVelocity = nil,
    bodyGyro = nil,
    connection = nil
}

-- Função para ativar voo
local function enableFly()
    local character = Admin.Character
    local humanoid = Admin.Humanoid
    local rootPart = Admin.HumanoidRootPart
    
    if not character or not humanoid or not rootPart then
        warn("❌ Personagem não encontrado!")
        return false
    end
    
    -- Salvar valores originais
    if not Admin.OriginalValues.PlatformStand then
        Admin.OriginalValues.PlatformStand = humanoid.PlatformStand
    end
    
    -- Ativar PlatformStand para melhor controle
    humanoid.PlatformStand = true
    
    -- Criar objetos de física
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(400000, 400000, 400000)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = rootPart
    
    local bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(400000, 400000, 400000)
    bodyGyro.P = 3000
    bodyGyro.D = 500
    bodyGyro.Parent = rootPart
    
    -- Armazenar referências
    FlyModule.bodyVelocity = bodyVelocity
    FlyModule.bodyGyro = bodyGyro
    
    -- Loop de controle de movimento
    FlyModule.connection = Services.RunService.Heartbeat:Connect(function()
        if not FlyModule.enabled then return end
        if not rootPart or not rootPart.Parent then return end
        
        local moveVector = Vector3.new()
        local camera = workspace.CurrentCamera
        if not camera then return end
        
        -- Controles WASD + Space/LeftControl
        if Services.UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveVector = moveVector + camera.CFrame.LookVector
        end
        if Services.UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveVector = moveVector - camera.CFrame.LookVector
        end
        if Services.UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveVector = moveVector - camera.CFrame.RightVector
        end
        if Services.UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveVector = moveVector + camera.CFrame.RightVector
        end
        if Services.UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveVector = moveVector + Vector3.new(0, 1, 0)
        end
        if Services.UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            moveVector = moveVector - Vector3.new(0, 1, 0)
        end
        
        -- Aplicar movimento
        if bodyVelocity and bodyVelocity.Parent then
            bodyVelocity.Velocity = moveVector * FlyModule.speed
        end
        if bodyGyro and bodyGyro.Parent then
            bodyGyro.CFrame = camera.CFrame
        end
    end)
    
    print("✈️ Voo ativado! Use WASD + Espaço/Ctrl para voar")
    return true
end

-- Função para desativar voo
local function disableFly()
    -- Desconectar loop de movimento
    if FlyModule.connection then
        FlyModule.connection:Disconnect()
        FlyModule.connection = nil
    end
    
    -- Remover objetos de física
    if FlyModule.bodyVelocity then
        FlyModule.bodyVelocity:Destroy()
        FlyModule.bodyVelocity = nil
    end
    if FlyModule.bodyGyro then
        FlyModule.bodyGyro:Destroy()
        FlyModule.bodyGyro = nil
    end
    
    -- Restaurar valores originais
    if Admin.Humanoid and Admin.OriginalValues.PlatformStand ~= nil then
        Admin.Humanoid.PlatformStand = Admin.OriginalValues.PlatformStand
    end
    
    -- Pouso suave
    if Admin.HumanoidRootPart then
        local rayParams = RaycastParams.new()
        rayParams.FilterType = Enum.RaycastFilterType.Exclude
        rayParams.FilterDescendantsInstances = {Admin.Character}
        
        local rayResult = workspace:Raycast(
            Admin.HumanoidRootPart.Position, 
            Vector3.new(0, -50, 0), 
            rayParams
        )
        
        if rayResult then
            -- Pousar suavemente 3 studs acima do chão
            local landingPosition = rayResult.Position + Vector3.new(0, 3, 0)
            Admin.HumanoidRootPart.CFrame = CFrame.new(
                landingPosition.X,
                landingPosition.Y,
                landingPosition.Z
            )
            -- Zerar velocidade
            Admin.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
        end
    end
    
    -- Forçar estado de corrida
    wait(0.1)
    if Admin.Humanoid then
        pcall(function() Admin.Humanoid:ChangeState(Enum.HumanoidStateType.Running) end)
    end
    
    print("🚶 Voo desativado!")
end

-- Função principal para alternar voo
local function toggleFly()
    FlyModule.enabled = not FlyModule.enabled
    
    if FlyModule.enabled then
        local success = enableFly()
        if not success then
            FlyModule.enabled = false
        end
    else
        disableFly()
    end
    
    return FlyModule.enabled
end

-- Função para definir velocidade
local function setFlySpeed(speed)
    if type(speed) == "number" and speed > 0 then
        FlyModule.speed = speed
        print("✈️ Velocidade de voo definida para: " .. speed)
    else
        warn("❌ Velocidade inválida! Use um número maior que 0")
    end
end

-- Função para obter estado atual
local function isFlying()
    return FlyModule.enabled
end

-- Registrar funções no sistema global
if not Admin.Movement then
    Admin.Movement = {}
end

Admin.Movement.Fly = {
    toggle = toggleFly,
    enable = function() 
        if not FlyModule.enabled then 
            return toggleFly() 
        end 
        return true 
    end,
    disable = function() 
        if FlyModule.enabled then 
            return not toggleFly() 
        end 
        return true 
    end,
    setSpeed = setFlySpeed,
    getSpeed = function() return FlyModule.speed end,
    isEnabled = isFlying,
    -- Compatibilidade com sistema antigo
    flyEnabled = function() return FlyModule.enabled end
}

-- Registrar no sistema de conexões para limpeza
Admin.Connections.FlyModule = FlyModule

print("✅ Módulo de voo carregado com sucesso!")