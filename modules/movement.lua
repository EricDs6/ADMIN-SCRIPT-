-- Módulo de Movimento - Fly e Noclip
-- Carregado via _G.AdminScript

local Admin = _G.AdminScript
if not Admin then
    error("Sistema AdminScript não inicializado!")
    return
end

local Services = Admin.Services
local Player = Admin.Player

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
        toggleFly()
    end)
    
    local noclipButton = createButton("Atravessar: OFF", UDim2.new(0, 10, 0, 85), function()
        toggleNoclip()
    end)
    
    -- Armazenar referências
    Admin.GUI.ScreenGui = screenGui
    Admin.GUI.MainFrame = mainFrame
    Admin.GUI.FlyButton = flyButton
    Admin.GUI.NoclipButton = noclipButton
end

-- Função para atualizar estado do botão
local function updateButtonState(button, enabled, baseName)
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
            local moveVector = Vector3.new()
            
            -- Controles WASD + Space/LeftControl
            if Services.UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveVector = moveVector + workspace.CurrentCamera.CFrame.LookVector
            end
            if Services.UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveVector = moveVector - workspace.CurrentCamera.CFrame.LookVector
            end
            if Services.UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveVector = moveVector - workspace.CurrentCamera.CFrame.RightVector
            end
            if Services.UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveVector = moveVector + workspace.CurrentCamera.CFrame.RightVector
            end
            if Services.UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                moveVector = moveVector + Vector3.new(0, 1, 0)
            end
            if Services.UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                moveVector = moveVector - Vector3.new(0, 1, 0)
            end
            
            bodyVelocity.Velocity = moveVector * Admin.Movement.flySpeed
            bodyGyro.CFrame = workspace.CurrentCamera.CFrame
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
        
        print("🚶 Voo desativado!")
    end
end

-- Função de Noclip (atravessar paredes)
function toggleNoclip()
    Admin.Movement.noclipEnabled = not Admin.Movement.noclipEnabled
    updateButtonState(Admin.GUI.NoclipButton, Admin.Movement.noclipEnabled, "Atravessar")
    
    if Admin.Movement.noclipEnabled then
        -- Loop para desabilitar colisão
        Admin.Connections.Noclip = Services.RunService.Stepped:Connect(function()
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
        for _, part in pairs(Admin.Character:GetChildren()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.CanCollide = true
            end
        end
        
        print("🚧 Atravessar paredes desativado!")
    end
end

-- Criar GUI
createGUI()

print("✅ Módulo de Movimento carregado!")
print("💡 Controles: WASD + Espaço/Ctrl para voar")
print("💡 Use os botões na GUI para ativar/desativar")