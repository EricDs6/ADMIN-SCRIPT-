-- Módulo de Movimento - Fly e Noclip
-- Carregado via _G.AdminScript

-- Verificar se AdminScript está disponível
local Admin = _G.AdminScript
if not Admin then
    warn("❌ Sistema AdminScript não inicializado!")
    warn("💡 Execute primeiro o init.lua")
    return
end

-- Verificar se serviços estão disponíveis
local Services = Admin.Services
local Player = Admin.Player

if not Services or not Player then
    warn("❌ Serviços não disponíveis!")
    return
end

-- Verificar se character está disponível
if not Admin.Character or not Admin.HumanoidRootPart then
    warn("❌ Personagem não encontrado!")
    return
end

print("🎮 Inicializando módulo de movimento...")

-- Criar GUI simples
local function createGUI()
    -- Verificar se já existe
    local existingGUI = Player.PlayerGui:FindFirstChild("MovementGUI")
    if existingGUI then
        existingGUI:Destroy()
    end
    
    -- ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MovementGUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = Player.PlayerGui
    
    -- Frame principal
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 250, 0, 150)
    mainFrame.Position = UDim2.new(0, 20, 0.5, -75)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    -- Estilo
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = mainFrame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(100, 100, 120)
    stroke.Thickness = 2
    stroke.Parent = mainFrame
    
    -- Título
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 35)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    title.Text = "✈️ Movimento"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 14
    title.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = title
    
    -- Função para criar botões
    local function createButton(text, position, callback)
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, -20, 0, 30)
        button.Position = position
        button.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        button.Text = text
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.Font = Enum.Font.Gotham
        button.TextSize = 12
        button.AutoButtonColor = false
        button.Parent = mainFrame
        
        -- Estilo
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = button
        
        local btnStroke = Instance.new("UIStroke")
        btnStroke.Color = Color3.fromRGB(80, 80, 100)
        btnStroke.Thickness = 1
        btnStroke.Parent = button
        
        -- Hover effect
        button.MouseEnter:Connect(function()
            button.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
        end)
        
        button.MouseLeave:Connect(function()
            if not button.Text:find("ON") then
                button.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
            end
        end)
        
        -- Callback
        if callback then
            button.MouseButton1Click:Connect(callback)
        end
        
        return button
    end
    
    -- Botões
    local flyButton = createButton("Voo: OFF", UDim2.new(0, 10, 0, 45), function()
        pcall(toggleFly)
    end)
    
    local noclipButton = createButton("Atravessar: OFF", UDim2.new(0, 10, 0, 85), function()
        pcall(toggleNoclip)
    end)
    
    -- Armazenar referências
    Admin.GUI.ScreenGui = screenGui
    Admin.GUI.MainFrame = mainFrame
    Admin.GUI.FlyButton = flyButton
    Admin.GUI.NoclipButton = noclipButton
    
    print("🖼️ GUI criada com sucesso!")
end

-- Função para atualizar estado do botão
local function updateButtonState(button, enabled, baseName)
    if not button then return end
    if enabled then
        button.Text = baseName .. ": ON"
        button.BackgroundColor3 = Color3.fromRGB(80, 180, 80)
    else
        button.Text = baseName .. ": OFF"
        button.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    end
end

-- Função de Fly
function toggleFly()
    Admin.Movement.flyEnabled = not Admin.Movement.flyEnabled
    updateButtonState(Admin.GUI.FlyButton, Admin.Movement.flyEnabled, "Voo")
    
    if Admin.Movement.flyEnabled then
        -- Verificar se humanoidRootPart existe
        if not Admin.HumanoidRootPart then
            warn("❌ HumanoidRootPart não encontrado!")
            return
        end
        
        -- Salvar valores originais para restaurar depois
        if Admin.Humanoid then
            Admin.OriginalValues.Health = Admin.Humanoid.Health
            Admin.OriginalValues.MaxHealth = Admin.Humanoid.MaxHealth
            Admin.OriginalValues.PlatformStand = Admin.Humanoid.PlatformStand
            
            -- Proteger contra dano durante o voo
            Admin.Humanoid.MaxHealth = math.huge
            Admin.Humanoid.Health = math.huge
            Admin.Humanoid.PlatformStand = true
            
            -- Desabilitar estados que causam dano
            local statesEnabled = {}
            for _, state in pairs({
                Enum.HumanoidStateType.Freefall,
                Enum.HumanoidStateType.FallingDown,
                Enum.HumanoidStateType.Ragdoll,
                Enum.HumanoidStateType.PlatformStanding
            }) do
                statesEnabled[state] = Admin.Humanoid:GetStateEnabled(state)
                pcall(function() Admin.Humanoid:SetStateEnabled(state, false) end)
            end
            Admin.OriginalValues.StatesEnabled = statesEnabled
        end
        
        -- Criar objetos de física
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(400000, 400000, 400000)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.Parent = Admin.HumanoidRootPart
        
        local bodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(400000, 400000, 400000)
        bodyGyro.P = 3000
        bodyGyro.D = 500
        bodyGyro.Parent = Admin.HumanoidRootPart
        
        -- Armazenar referências
        Admin.Movement.BodyVelocity = bodyVelocity
        Admin.Movement.BodyGyro = bodyGyro
        
        -- Conexão para manter a saúde durante o voo
        Admin.Connections.FlyHealthProtection = Services.RunService.Heartbeat:Connect(function()
            if Admin.Movement.flyEnabled and Admin.Humanoid then
                if Admin.Humanoid.Health < Admin.Humanoid.MaxHealth then
                    Admin.Humanoid.Health = Admin.Humanoid.MaxHealth
                end
                -- Forçar estado seguro
                if Admin.Humanoid:GetState() ~= Enum.HumanoidStateType.Physics then
                    pcall(function() Admin.Humanoid:ChangeState(Enum.HumanoidStateType.Physics) end)
                end
            end
        end)
        
        -- Loop de movimento
        Admin.Connections.Fly = Services.RunService.Heartbeat:Connect(function()
            if not Admin.Movement.flyEnabled then return end
            if not Admin.HumanoidRootPart or not Admin.HumanoidRootPart.Parent then return end
            
            local moveVector = Vector3.new()
            
            -- Controles WASD + Space/LeftControl (com verificação de segurança)
            local camera = workspace.CurrentCamera
            if not camera then return end
            
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
            
            if bodyVelocity and bodyVelocity.Parent then
                bodyVelocity.Velocity = moveVector * Admin.Movement.flySpeed
            end
            if bodyGyro and bodyGyro.Parent then
                bodyGyro.CFrame = camera.CFrame
            end
        end)
        
        print("✈️ Voo ativado! Use WASD + Espaço/Ctrl para voar")
        print("🛡️ Proteção contra dano ativada!")
    else
        -- Desabilitar fly
        if Admin.Connections.Fly then
            Admin.Connections.Fly:Disconnect()
            Admin.Connections.Fly = nil
        end
        
        -- Desabilitar proteção de saúde
        if Admin.Connections.FlyHealthProtection then
            Admin.Connections.FlyHealthProtection:Disconnect()
            Admin.Connections.FlyHealthProtection = nil
        end
        
        if Admin.Movement.BodyVelocity then
            Admin.Movement.BodyVelocity:Destroy()
            Admin.Movement.BodyVelocity = nil
        end
        
        if Admin.Movement.BodyGyro then
            Admin.Movement.BodyGyro:Destroy()
            Admin.Movement.BodyGyro = nil
        end
        
        -- Restaurar valores originais
        if Admin.Humanoid and Admin.OriginalValues then
            -- Restaurar saúde gradualmente para evitar morte súbita
            if Admin.OriginalValues.Health and Admin.OriginalValues.MaxHealth then
                Admin.Humanoid.MaxHealth = Admin.OriginalValues.MaxHealth
                -- Garantir que não morra ao restaurar
                local targetHealth = math.max(Admin.OriginalValues.Health, Admin.OriginalValues.MaxHealth * 0.5)
                Admin.Humanoid.Health = targetHealth
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
        end
        
        -- Pouso suave: detectar chão próximo
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
                -- Zerar velocidade para pouso suave
                Admin.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
            end
        end
        
        -- Forçar estado de corrida após desabilitar
        wait(0.1)
        if Admin.Humanoid then
            pcall(function() Admin.Humanoid:ChangeState(Enum.HumanoidStateType.Running) end)
        end
        
        print("🚶 Voo desativado!")
        print("🛡️ Proteção contra dano desativada!")
    end
end

-- Função de Noclip (atravessar paredes)
function toggleNoclip()
    Admin.Movement.noclipEnabled = not Admin.Movement.noclipEnabled
    updateButtonState(Admin.GUI.NoclipButton, Admin.Movement.noclipEnabled, "Atravessar")
    
    if Admin.Movement.noclipEnabled then
        -- Loop para desabilitar colisão
        Admin.Connections.Noclip = Services.RunService.Stepped:Connect(function()
            if not Admin.Movement.noclipEnabled then return end
            if not Admin.Character then return end
            
            for _, part in pairs(Admin.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
        
        print("👻 Atravessar paredes ativado!")
    else
        -- Desabilitar noclip
        if Admin.Connections.Noclip then
            Admin.Connections.Noclip:Disconnect()
            Admin.Connections.Noclip = nil
        end
        
        -- Restaurar colisão
        if Admin.Character then
            for _, part in pairs(Admin.Character:GetChildren()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.CanCollide = true
                end
            end
        end
        
        print("🚧 Atravessar paredes desativado!")
    end
end

-- Criar GUI com proteção de erro
local success, error = pcall(createGUI)
if not success then
    warn("❌ Erro ao criar GUI: " .. tostring(error))
    return
end

print("✅ Módulo de Movimento carregado!")
print("💡 Controles: WASD + Espaço/Ctrl para voar")
print("💡 Use os botões na GUI para ativar/desativar")