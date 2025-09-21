-- Módulo de Voo (Fly) - Versão Melhorada
-- Funcionalidade: Permite voar com controles WASD + Espaço/Ctrl, suporta veículos e evita danos
-- Carregado via _G.AdminScript

-- Verificar se AdminScript está disponível
local Admin = _G.AdminScript
if not Admin then
    warn("❌ Sistema AdminScript não inicializado!")
    return
end

local Services = Admin.Services
local Player = Admin.Player

print("✈️ Carregando módulo de voo aprimorado...")

-- Estado do módulo
local FlyModule = {
    enabled = false,
    speed = 50,
    bodyVelocity = nil,
    bodyGyro = nil,
    weld = nil,
    connection = nil,
    vehicle = nil, -- Referência ao assento ou modelo do veículo
    useNoclip = false -- Opção para ativar noclip durante o voo
}

-- Função para encontrar o veículo (assento ou modelo pai)
local function findVehicle()
    if Admin.Humanoid.SeatPart and (Admin.Humanoid.SeatPart:IsA("Seat") or Admin.Humanoid.SeatPart:IsA("VehicleSeat")) then
        local seat = Admin.Humanoid.SeatPart
        -- Tentar encontrar o modelo pai do assento (ex.: carro completo)
        local model = seat:FindFirstAncestorOfClass("Model") or seat
        return model, seat
    end
    return nil, nil
end

-- Função para criar um WeldConstraint entre o personagem e o assento
local function createWeld(character, seat)
    local weld = Instance.new("WeldConstraint")
    weld.Part0 = Admin.HumanoidRootPart
    weld.Part1 = seat
    weld.Parent = Admin.HumanoidRootPart
    return weld
end

-- Função para ativar voo
local function enableFly()
    local character = Admin.Character
    local humanoid = Admin.Humanoid
    local rootPart = Admin.HumanoidRootPart
    
    if not character or not humanoid or not rootPart then
        warn("❌ Personagem não encontrado!")
        return false
    end
    
    -- Verificar se está em um veículo
    FlyModule.vehicle, local seat = findVehicle()
    local targetPart = FlyModule.vehicle or rootPart -- Aplicar física ao veículo ou ao personagem
    
    -- Salvar valores originais
    if not Admin.OriginalValues.WalkSpeed then
        Admin.OriginalValues.WalkSpeed = humanoid.WalkSpeed
    end
    
    -- Ativar estado de voo
    pcall(function() humanoid:ChangeState(Enum.HumanoidStateType.Flying) end)
    
    -- Criar objetos de física
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge) -- Força suficiente para veículos
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = targetPart
    
    local bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bodyGyro.P = 5000
    bodyGyro.D = 500
    bodyGyro.Parent = targetPart
    
    -- Criar weld se estiver em um assento
    if seat then
        FlyModule.weld = createWeld(character, seat)
    end
    
    -- Armazenar referências
    FlyModule.bodyVelocity = bodyVelocity
    FlyModule.bodyGyro = bodyGyro
    
    -- Loop de controle de movimento
    FlyModule.connection = Services.RunService.Heartbeat:Connect(function()
        if not FlyModule.enabled then return end
        if not targetPart or not targetPart.Parent then return end
        
        local moveVector = Vector3.new()
        local camera = workspace.CurrentCamera
        if not camera then return end
        
        -- Controles WASD + Space/LeftControl + Q/E para velocidade
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
        if Services.UserInputService:IsKeyDown(Enum.KeyCode.Q) then
            FlyModule.speed = math.max(10, FlyModule.speed - 5)
            print("✈️ Velocidade de voo: " .. FlyModule.speed)
        end
        if Services.UserInputService:IsKeyDown(Enum.KeyCode.E) then
            FlyModule.speed = FlyModule.speed + 5
            print("✈️ Velocidade de voo: " .. FlyModule.speed)
        end
        
        -- Aplicar movimento
        if bodyVelocity and bodyVelocity.Parent then
            bodyVelocity.Velocity = moveVector.Unit * FlyModule.speed
        end
        if bodyGyro and bodyGyro.Parent then
            bodyGyro.CFrame = camera.CFrame
        end
    end)
    
    print("✈️ Voo ativado! Use WASD + Espaço/Ctrl para voar, Q/E para ajustar velocidade")
    return true
end

-- Função para desativar voo
local function disableFly()
    -- Desconectar loop de movimento
    if FlyModule.connection then
        pcall(function() FlyModule.connection:Disconnect() end)
        FlyModule.connection = nil
    end
    
    -- Remover objetos de física
    if FlyModule.bodyVelocity then
        pcall(function() FlyModule.bodyVelocity:Destroy() end)
        FlyModule.bodyVelocity = nil
    end
    if FlyModule.bodyGyro then
        pcall(function() FlyModule.bodyGyro:Destroy() end)
        FlyModule.bodyGyro = nil
    end
    if FlyModule.weld then
        pcall(function() FlyModule.weld:Destroy() end)
        FlyModule.weld = nil
    end
    
    -- Restaurar estado do humanoide
    if Admin.Humanoid then
        pcall(function() Admin.Humanoid:ChangeState(Enum.HumanoidStateType.Running) end)
        if Admin.OriginalValues.WalkSpeed then
            pcall(function() Admin.Humanoid.WalkSpeed = Admin.OriginalValues.WalkSpeed end)
        end
    end
    
    -- Pouso suave para personagem e veículo
    local targetPart = FlyModule.vehicle or Admin.HumanoidRootPart
    if targetPart then
        local rayParams = RaycastParams.new()
        rayParams.FilterType = Enum.RaycastFilterType.Exclude
        rayParams.FilterDescendantsInstances = {Admin.Character, FlyModule.vehicle}
        
        local rayResult = workspace:Raycast(
            targetPart.Position, 
            Vector3.new(0, -50, 0), 
            rayParams
        )
        
        if rayResult then
            local landingPosition = rayResult.Position + Vector3.new(0, 3, 0)
            pcall(function()
                targetPart.CFrame = CFrame.new(
                    landingPosition.X,
                    landingPosition.Y,
                    landingPosition.Z
                )
                targetPart.Velocity = Vector3.new(0, 0, 0)
            end)
        end
    end
    
    FlyModule.vehicle = nil
    print("🚶 Voo desativado!")
end

-- Função para alternar voo
local function toggleFly()
    FlyModule.enabled = not FlyModule.enabled
    
    if FlyModule.enabled then
        local success = enableFly()
        if not success then
            FlyModule.enabled = false
            return false
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
    flyEnabled = function() return FlyModule.enabled end
}

-- Registrar no sistema de conexões para limpeza
Admin.Connections.FlyModule = FlyModule

print("✅ Módulo de voo carregado com sucesso!")