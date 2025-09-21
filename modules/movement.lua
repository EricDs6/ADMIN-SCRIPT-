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
    
    -- Barra de título
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 35)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = titleBar
    
    -- Título
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -80, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "✈️ Movimento"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = titleBar
    
    -- Botão Minimizar
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Size = UDim2.new(0, 30, 0, 25)
    minimizeBtn.Position = UDim2.new(1, -65, 0, 5)
    minimizeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    minimizeBtn.Text = "—"
    minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    minimizeBtn.Font = Enum.Font.GothamBold
    minimizeBtn.TextSize = 14
    minimizeBtn.BorderSizePixel = 0
    minimizeBtn.Parent = titleBar
    
    local minCorner = Instance.new("UICorner")
    minCorner.CornerRadius = UDim.new(0, 4)
    minCorner.Parent = minimizeBtn
    
    -- Botão Fechar
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 25)
    closeBtn.Position = UDim2.new(1, -30, 0, 5)
    closeBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 12
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = titleBar
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 4)
    closeCorner.Parent = closeBtn
    
    -- Hover effects
    minimizeBtn.MouseEnter:Connect(function()
        minimizeBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
    end)
    minimizeBtn.MouseLeave:Connect(function()
        minimizeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    end)
    
    closeBtn.MouseEnter:Connect(function()
        closeBtn.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
    end)
    closeBtn.MouseLeave:Connect(function()
        closeBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
    end)
    
    -- Eventos dos botões
    minimizeBtn.MouseButton1Click:Connect(function()
        mainFrame.Visible = not mainFrame.Visible
        if mainFrame.Visible then
            minimizeBtn.Text = "—"
        else
            -- Criar botão flutuante minimizado
            if not Admin.GUI.MinimizedButton then
                local floatingBtn = Instance.new("TextButton")
                floatingBtn.Size = UDim2.new(0, 60, 0, 30)
                floatingBtn.Position = UDim2.new(1, -80, 0, 20)
                floatingBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
                floatingBtn.Text = "✈️ Admin"
                floatingBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                floatingBtn.Font = Enum.Font.Gotham
                floatingBtn.TextSize = 10
                floatingBtn.BorderSizePixel = 0
                floatingBtn.Parent = screenGui
                
                local floatCorner = Instance.new("UICorner")
                floatCorner.CornerRadius = UDim.new(0, 6)
                floatCorner.Parent = floatingBtn
                
                floatingBtn.MouseButton1Click:Connect(function()
                    mainFrame.Visible = true
                    floatingBtn:Destroy()
                    Admin.GUI.MinimizedButton = nil
                    minimizeBtn.Text = "—"
                end)
                
                Admin.GUI.MinimizedButton = floatingBtn
            end
        end
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        -- Limpar tudo e fechar
        if _G.AdminScript and _G.AdminScript.Cleanup then
            _G.AdminScript.Cleanup()
        else
            -- Fallback caso não tenha acesso à função global
            if Admin.GUI.ScreenGui then
                Admin.GUI.ScreenGui:Destroy()
            end
        end
    end)
    
    -- Container para conteúdo
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, 0, 1, -35)
    contentFrame.Position = UDim2.new(0, 0, 0, 35)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = mainFrame
    
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
        button.Parent = contentFrame
        
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
    local flyButton = createButton("Voo: OFF", UDim2.new(0, 10, 0, 10), function()
        pcall(toggleFly)
    end)
    
    local noclipButton = createButton("Atravessar: OFF", UDim2.new(0, 10, 0, 50), function()
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
        
        -- Salvar valores originais para restaurar depois (sem mexer em saúde)
        if Admin.Humanoid then
            Admin.OriginalValues.PlatformStand = Admin.Humanoid.PlatformStand
            Admin.Humanoid.PlatformStand = true
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
    else
        -- Desabilitar fly
        if Admin.Connections.Fly then
            Admin.Connections.Fly:Disconnect()
            Admin.Connections.Fly = nil
        end
        
        if Admin.Movement.BodyVelocity then
            Admin.Movement.BodyVelocity:Destroy()
            Admin.Movement.BodyVelocity = nil
        end
        
        if Admin.Movement.BodyGyro then
            Admin.Movement.BodyGyro:Destroy()
            Admin.Movement.BodyGyro = nil
        end
        
        -- Restaurar valores originais (sem mexer em saúde)
        if Admin.Humanoid and Admin.OriginalValues then
            -- Restaurar PlatformStand
            if Admin.OriginalValues.PlatformStand ~= nil then
                Admin.Humanoid.PlatformStand = Admin.OriginalValues.PlatformStand
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