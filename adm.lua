-- Script de Admin para Roblox (Compatível com Injetores como Xeno, Synapse, etc.)
-- Instruções: Injete este script no jogo usando seu executor.
-- Controles: W/A/S/D para mover, Space para subir, LeftControl para descer.
-- Para ativar/desativar: Use os botões na GUI.
-- Serviços
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")
local mouse = player:GetMouse()
-- Variáveis de estado
local flyEnabled = false
local flySpeed = 50
local noclipEnabled = false
local godEnabled = false
local clickTpEnabled = false
local speedHackEnabled = false
local jumpHackEnabled = false
local invisibleEnabled = false
local lowGravityEnabled = false
local antiFallEnabled = false
local autoHealEnabled = false
local antiAfkEnabled = false
local rainbowEnabled = false
local spinEnabled = false
local infiniteJumpEnabled = false
local fullBrightEnabled = false
local xrayEnabled = false
local wallClimbEnabled = false
local swimEnabled = false
local reachEnabled = false
local noFallDamageEnabled = false
local scriptTerminated = false
local followEnabledFlag = false
local anchorEnabled = false
local carryPartsEnabled = false
local markPartsEnabled = false
local markedParts = {}
local partMarkers = {}
local isMinimized = false
local trollEnabled = false
local autoFireEnabled = false
local noRecoilEnabled = false
local bigHeadOn = false
local speedHackSpeed = 100
local jumpHackPower = 200
local minimizedButton = nil -- Botão flutuante quando minimizado
local colorTweenConnection = nil -- Conexão do efeito de cor pulsante
-- Objetos de física
local bodyVelocity = Instance.new("BodyVelocity")
bodyVelocity.MaxForce = Vector3.new(400000, 400000, 400000)
bodyVelocity.Velocity = Vector3.new(0, 0, 0)
local bodyGyro = Instance.new("BodyGyro")
bodyGyro.MaxTorque = Vector3.new(400000, 400000, 400000)
bodyGyro.P = 3000
bodyGyro.D = 500
-- Conexões para loops
local connections = {}
local originalValues = {}
-- GUI Criação
local playerGui = player:WaitForChild("PlayerGui")
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AdminGUI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui
-- Sombra do painel com gradiente (atualizada para acompanhar a estrutura unificada)
local shadow = Instance.new("Frame")
shadow.Size = UDim2.new(0, 280, 0, 560)
shadow.Position = UDim2.new(0, 10, 0.5, -280) -- Canto esquerdo da tela
shadow.BackgroundColor3 = Color3.fromRGB(0,0,0)
shadow.BackgroundTransparency = 0.7
shadow.BorderSizePixel = 0
shadow.ZIndex = 0
shadow.Parent = screenGui

-- Gradiente para a sombra
local shadowGradient = Instance.new("UIGradient")
shadowGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 30))
}
shadowGradient.Transparency = NumberSequence.new{
    NumberSequenceKeypoint.new(0, 0.7),
    NumberSequenceKeypoint.new(1, 0.9)
}
shadowGradient.Parent = shadow

local shadowCorner = Instance.new("UICorner")
shadowCorner.CornerRadius = UDim.new(0, 20)
shadowCorner.Parent = shadow

-- GUI Principal Unificada
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 280, 0, 560)
mainFrame.Position = UDim2.new(0, 10, 0.5, -280) -- Canto esquerdo da tela
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 17, 25)
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 0
mainFrame.ZIndex = 2
mainFrame.Parent = screenGui

-- Gradiente para o painel principal
local mainGradient = Instance.new("UIGradient")
mainGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 28, 40)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(20, 23, 35)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 18, 28))
}
mainGradient.Rotation = 90
mainGradient.Parent = mainFrame

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 20)
corner.Parent = mainFrame

-- Borda sutil
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(60, 70, 90)
stroke.Thickness = 1
stroke.Transparency = 0.8
stroke.Parent = mainFrame

-- Header Frame (parte superior integrada)
local headerFrame = Instance.new("Frame")
headerFrame.Size = UDim2.new(1, 0, 0, 55)
headerFrame.Position = UDim2.new(0, 0, 0, 0)
headerFrame.BackgroundColor3 = Color3.fromRGB(20, 25, 40)
headerFrame.BackgroundTransparency = 0.1
headerFrame.BorderSizePixel = 0
headerFrame.ZIndex = 8 -- ZIndex maior para garantir que fique acima
headerFrame.Parent = mainFrame

-- Gradiente para o header
local headerGradient = Instance.new("UIGradient")
headerGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 150)),
    ColorSequenceKeypoint.new(0.3, Color3.fromRGB(255, 180, 100)),
    ColorSequenceKeypoint.new(0.6, Color3.fromRGB(100, 200, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 100, 255))
}
headerGradient.Parent = headerFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 15)
headerCorner.Parent = headerFrame

-- Borda para o header
local headerStroke = Instance.new("UIStroke")
headerStroke.Color = Color3.fromRGB(80, 90, 120)
headerStroke.Thickness = 1.5
headerStroke.Transparency = 0.6
headerStroke.Parent = headerFrame

-- Título integrado ao header
local title = Instance.new("TextButton")
title.Size = UDim2.new(0, 220, 0, 55)
title.Position = UDim2.new(0.5, -110, 0, 0)
title.BackgroundTransparency = 1
title.Text = "FITA-K7-ADMIN"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Center
title.TextYAlignment = Enum.TextYAlignment.Center
title.RichText = true
title.AutoButtonColor = false
title.ZIndex = 9 -- ZIndex maior para garantir que fique acima
title.Parent = headerFrame
title.Active = true

-- ScrollingFrame para o conteúdo (dentro do mainFrame)
local contentFrame = Instance.new("ScrollingFrame")
contentFrame.Size = UDim2.new(1, 0, 1, -55) -- Altura total menos o header
contentFrame.Position = UDim2.new(0, 0, 0, 55) -- Abaixo do header
contentFrame.BackgroundTransparency = 1
contentFrame.BorderSizePixel = 0
contentFrame.CanvasSize = UDim2.new(0, 0, 0, 2300)
contentFrame.ScrollBarThickness = 8
contentFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 110, 130)
contentFrame.ZIndex = 2 -- Mesmo nível do mainFrame, mas abaixo do header
contentFrame.Parent = mainFrame
contentFrame.Active = true
-- Botão de arrastar (drag button) dentro do header
local dragButton = Instance.new("TextButton")
dragButton.Size = UDim2.new(0, 32, 0, 32)
dragButton.Position = UDim2.new(0, 10, 0.5, -16) -- Dentro do header, à esquerda
dragButton.BackgroundColor3 = Color3.fromRGB(70, 80, 100)
dragButton.Text = "⠿" -- Ícone de arrastar
dragButton.TextColor3 = Color3.fromRGB(220, 220, 240)
dragButton.Font = Enum.Font.GothamBold
dragButton.TextSize = 18
dragButton.AutoButtonColor = false
dragButton.ZIndex = 10
dragButton.Parent = headerFrame
dragButton.Active = true

-- Gradiente para o botão de arrastar
local dragGradient = Instance.new("UIGradient")
dragGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(90, 100, 120)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 70, 90))
}
dragGradient.Parent = dragButton

local dragCorner = Instance.new("UICorner")
dragCorner.CornerRadius = UDim.new(0, 8)
dragCorner.Parent = dragButton

-- Borda para o botão de arrastar
local dragStroke = Instance.new("UIStroke")
dragStroke.Color = Color3.fromRGB(120, 130, 150)
dragStroke.Thickness = 1
dragStroke.Transparency = 0.7
dragStroke.Parent = dragButton

-- Sombra sutil para o botão de arrastar
local dragShadow = Instance.new("Frame")
dragShadow.Size = UDim2.new(0, 32, 0, 32)
dragShadow.Position = UDim2.new(0, 2, 0, 2)
dragShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
dragShadow.BackgroundTransparency = 0.8
dragShadow.BorderSizePixel = 0
dragShadow.ZIndex = 5
dragShadow.Parent = dragButton
local dragShadowCorner = Instance.new("UICorner")
dragShadowCorner.CornerRadius = UDim.new(0, 8)
dragShadowCorner.Parent = dragShadow

-- Hover efeito para o botão de arrastar
dragButton.MouseEnter:Connect(function()
    dragButton.BackgroundColor3 = Color3.fromRGB(100, 110, 130)
    dragStroke.Transparency = 0.4
    dragButton:TweenSize(UDim2.new(0, 36, 0, 36), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
end)
dragButton.MouseButton1Up:Connect(function()
    if isDragging then
        isDragging = false
        dragStartPos = nil
        guiStartPos = nil
        mainFrame.ScrollingEnabled = true

        -- Restaurar aparência normal
        dragButton.BackgroundColor3 = Color3.fromRGB(70, 80, 100)
        dragStroke.Transparency = 0.7
    end
end)

-- Botão de minimizar dentro do header
local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 32, 0, 32)
minimizeButton.Position = UDim2.new(1, -42, 0.5, -16) -- Dentro do header, à direita
minimizeButton.BackgroundColor3 = Color3.fromRGB(255, 180, 50)
minimizeButton.Text = "—"
minimizeButton.TextColor3 = Color3.fromRGB(0, 0, 0)
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.TextSize = 20
minimizeButton.AutoButtonColor = false
minimizeButton.ZIndex = 10
minimizeButton.Parent = headerFrame
minimizeButton.Active = true

-- Gradiente para o botão de minimizar
local minimizeGradient = Instance.new("UIGradient")
minimizeGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 200, 80)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 160, 40))
}
minimizeGradient.Parent = minimizeButton

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0, 8)
minimizeCorner.Parent = minimizeButton

-- Borda para o botão de minimizar
local minimizeStroke = Instance.new("UIStroke")
minimizeStroke.Color = Color3.fromRGB(200, 150, 50)
minimizeStroke.Thickness = 1
minimizeStroke.Transparency = 0.6
minimizeStroke.Parent = minimizeButton

-- Sombra sutil para o botão de minimizar
local minimizeShadow = Instance.new("Frame")
minimizeShadow.Size = UDim2.new(0, 32, 0, 32)
minimizeShadow.Position = UDim2.new(0, 2, 0, 2)
minimizeShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
minimizeShadow.BackgroundTransparency = 0.8
minimizeShadow.BorderSizePixel = 0
minimizeShadow.ZIndex = 5
minimizeShadow.Parent = minimizeButton
local minimizeShadowCorner = Instance.new("UICorner")
minimizeShadowCorner.CornerRadius = UDim.new(0, 8)
minimizeShadowCorner.Parent = minimizeShadow

-- Hover efeito para o botão de minimizar
minimizeButton.MouseEnter:Connect(function()
    minimizeButton.BackgroundColor3 = Color3.fromRGB(255, 200, 80)
    minimizeStroke.Transparency = 0.3
    minimizeButton:TweenSize(UDim2.new(0, 36, 0, 36), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
end)
minimizeButton.MouseLeave:Connect(function()
    minimizeButton.BackgroundColor3 = Color3.fromRGB(255, 180, 50)
    minimizeStroke.Transparency = 0.6
    minimizeButton:TweenSize(UDim2.new(0, 32, 0, 32), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
end)
local function createButton(text, position, color, parent)
local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 210, 0, 36)
button.Position = position
button.BackgroundColor3 = color or Color3.fromRGB(50, 54, 70)
button.Text = text
button.TextColor3 = Color3.fromRGB(230, 230, 230)
button.Font = Enum.Font.Gotham
button.TextSize = 15
button.AutoButtonColor = false
button.Parent = parent or contentFrame
button.ZIndex = 4
local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 10)
buttonCorner.Parent = button
-- Hover efeito
button.MouseEnter:Connect(function()
if not button.Text:find("ON") then
button.BackgroundColor3 = Color3.fromRGB(60, 64, 90)
end
end)
button.MouseLeave:Connect(function()
if not button.Text:find("ON") then
button.BackgroundColor3 = color or Color3.fromRGB(50, 54, 70)
end
end)
return button
end
local function createLabel(text, position, parent)
local label = Instance.new("TextLabel")
label.Size = UDim2.new(1, -20, 0, 28)
label.Position = position
label.BackgroundColor3 = Color3.fromRGB(40, 44, 60)
label.BackgroundTransparency = 0.15
label.Text = "  " .. text .. ""
label.TextColor3 = Color3.fromRGB(255, 200, 80)
label.Font = Enum.Font.GothamBold
label.TextSize = 15
label.TextXAlignment = Enum.TextXAlignment.Left
label.RichText = true
label.Parent = parent or contentFrame
label.ZIndex = 4
local labelCorner = Instance.new("UICorner")
labelCorner.CornerRadius = UDim.new(0, 8)
labelCorner.Parent = label
return label
end
local function createValueControl(labelText, initialValue, minValue, maxValue, stepValue, position, parent)
    -- Container para o controle de valor
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -40, 0, 36)
    container.Position = position
    container.BackgroundTransparency = 1
    container.Parent = parent or contentFrame
    container.ZIndex = 4

    -- Label do valor
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 120, 1, 0)
    valueLabel.Position = UDim2.new(0, 0, 0, 0)
    valueLabel.BackgroundColor3 = Color3.fromRGB(40, 44, 60)
    valueLabel.BackgroundTransparency = 0.15
    valueLabel.Text = "  " .. labelText .. ": " .. initialValue .. ""
    valueLabel.TextColor3 = Color3.fromRGB(255, 200, 80)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 14
    valueLabel.TextXAlignment = Enum.TextXAlignment.Left
    valueLabel.RichText = true
    valueLabel.Parent = container
    valueLabel.ZIndex = 4
    local labelCorner = Instance.new("UICorner")
    labelCorner.CornerRadius = UDim.new(0, 8)
    labelCorner.Parent = valueLabel

    -- Botão -
    local minusButton = Instance.new("TextButton")
    minusButton.Size = UDim2.new(0, 30, 0, 30)
    minusButton.Position = UDim2.new(0, 130, 0.5, -15)
    minusButton.BackgroundColor3 = Color3.fromRGB(80, 40, 40)
    minusButton.Text = "−"
    minusButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    minusButton.Font = Enum.Font.GothamBold
    minusButton.TextSize = 20
    minusButton.AutoButtonColor = false
    minusButton.Parent = container
    minusButton.ZIndex = 4
    local minusCorner = Instance.new("UICorner")
    minusCorner.CornerRadius = UDim.new(0, 8)
    minusCorner.Parent = minusButton
    local minusStroke = Instance.new("UIStroke")
    minusStroke.Color = Color3.fromRGB(120, 60, 60)
    minusStroke.Thickness = 1
    minusStroke.Parent = minusButton

    -- Hover effect para botão -
    minusButton.MouseEnter:Connect(function()
        minusButton.BackgroundColor3 = Color3.fromRGB(100, 50, 50)
        minusStroke.Transparency = 0.3
    end)
    minusButton.MouseLeave:Connect(function()
        minusButton.BackgroundColor3 = Color3.fromRGB(80, 40, 40)
        minusStroke.Transparency = 0
    end)

    -- Botão +
    local plusButton = Instance.new("TextButton")
    plusButton.Size = UDim2.new(0, 30, 0, 30)
    plusButton.Position = UDim2.new(0, 170, 0.5, -15)
    plusButton.BackgroundColor3 = Color3.fromRGB(40, 80, 40)
    plusButton.Text = "+"
    plusButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    plusButton.Font = Enum.Font.GothamBold
    plusButton.TextSize = 20
    plusButton.AutoButtonColor = false
    plusButton.Parent = container
    plusButton.ZIndex = 4
    local plusCorner = Instance.new("UICorner")
    plusCorner.CornerRadius = UDim.new(0, 8)
    plusCorner.Parent = plusButton
    local plusStroke = Instance.new("UIStroke")
    plusStroke.Color = Color3.fromRGB(60, 120, 60)
    plusStroke.Thickness = 1
    plusStroke.Parent = plusButton

    -- Hover effect para botão +
    plusButton.MouseEnter:Connect(function()
        plusButton.BackgroundColor3 = Color3.fromRGB(50, 100, 50)
        plusStroke.Transparency = 0.3
    end)
    plusButton.MouseLeave:Connect(function()
        plusButton.BackgroundColor3 = Color3.fromRGB(40, 80, 40)
        plusStroke.Transparency = 0
    end)

    -- Função para atualizar o label
    local function updateLabel(newValue)
        valueLabel.Text = "  " .. labelText .. ": " .. newValue .. ""
    end

    -- Retornar os elementos para uso posterior
    return {
        container = container,
        label = valueLabel,
        minusButton = minusButton,
        plusButton = plusButton,
        updateLabel = updateLabel,
        currentValue = initialValue
    }
end
-- Inicializar variável de posicionamento Y
local yOffset = 45
-- Seção Movimento
local movimentoLabel = createLabel("Movimento", UDim2.new(0, 10, 0, yOffset))
yOffset = yOffset + 35
local flyButton = createButton("Voo: OFF", UDim2.new(0, 20, 0, yOffset), nil)
yOffset = yOffset + 45
local flyControl = createValueControl("Velocidade", flySpeed, 10, 500, 10, UDim2.new(0, 20, 0, yOffset))
yOffset = yOffset + 45
local noclipButton = createButton("Sem Colisão: OFF", UDim2.new(0, 20, 0, yOffset), nil)
yOffset = yOffset + 45
local speedHackButton = createButton("Velocidade Hack: OFF", UDim2.new(0, 20, 0, yOffset), nil)
yOffset = yOffset + 45
local speedHackControl = createValueControl("Velocidade", speedHackSpeed, 50, 500, 10, UDim2.new(0, 20, 0, yOffset))
yOffset = yOffset + 45
local jumpHackButton = createButton("Pulo Hack: OFF", UDim2.new(0, 20, 0, yOffset), nil)
yOffset = yOffset + 45
local jumpHackControl = createValueControl("Força", jumpHackPower, 50, 1000, 10, UDim2.new(0, 20, 0, yOffset))
yOffset = yOffset + 45
local infiniteJumpButton = createButton("Pulo Infinito: OFF", UDim2.new(0, 20, 0, yOffset), nil)
yOffset = yOffset + 55
-- Seção Combate
local combateLabel = createLabel("Combate", UDim2.new(0, 10, 0, yOffset))
yOffset = yOffset + 35
local godButton = createButton("Modo Deus: OFF", UDim2.new(0, 20, 0, yOffset), nil)
yOffset = yOffset + 45
local autoFireButton = createButton("Auto-Fire: OFF", UDim2.new(0, 20, 0, yOffset), nil)
yOffset = yOffset + 45
local noRecoilButton = createButton("Sem Recuo: OFF", UDim2.new(0, 20, 0, yOffset), nil)
yOffset = yOffset + 55
-- Seção Teleporte
local teleporteLabel = createLabel("Teleporte", UDim2.new(0, 10, 0, yOffset))
yOffset = yOffset + 35
local clickTpButton = createButton("TP ao Clicar: OFF", UDim2.new(0, 20, 0, yOffset), nil)
yOffset = yOffset + 45
local tpRandomButton = createButton("TP Jogador Aleatório", UDim2.new(0, 20, 0, yOffset), nil)
yOffset = yOffset + 45
local tpSpawnButton = createButton("TP para Spawn", UDim2.new(0, 20, 0, yOffset), nil)
yOffset = yOffset + 45
local followPlayerButton = createButton("Seguir Jogador: OFF", UDim2.new(0, 20, 0, yOffset), nil)
yOffset = yOffset + 55
-- Seção Utilidades
local utilidadesLabel = createLabel("Utilidades", UDim2.new(0, 10, 0, yOffset))
yOffset = yOffset + 35
local invisibleButton = createButton("Invisível: OFF", UDim2.new(0, 20, 0, yOffset), nil)
yOffset = yOffset + 45
local lowGravityButton = createButton("Gravidade Baixa: OFF", UDim2.new(0, 20, 0, yOffset), nil)
yOffset = yOffset + 45
local autoHealButton = createButton("Cura Automática: OFF", UDim2.new(0, 20, 0, yOffset), nil)
yOffset = yOffset + 45
local antiFallButton = createButton("Anti-Queda: OFF", UDim2.new(0, 20, 0, yOffset), nil)
yOffset = yOffset + 45
local noFallDamageButton = createButton("Sem Dano de Queda: OFF", UDim2.new(0, 20, 0, yOffset), nil)
yOffset = yOffset + 45
local anchorButton = createButton("Grudar no Chão: OFF", UDim2.new(0, 20, 0, yOffset), nil)
yOffset = yOffset + 45
local carryPartsButton = createButton("Carregar Partes: OFF", UDim2.new(0, 20, 0, yOffset), nil)
yOffset = yOffset + 45
local markPartsButton = createButton("Marcar Partes: OFF", UDim2.new(0, 20, 0, yOffset), nil)
yOffset = yOffset + 45
local antiAfkButton = createButton("Anti-AFK: OFF", UDim2.new(0, 20, 0, yOffset), nil)
yOffset = yOffset + 45
local fullBrightButton = createButton("Brilho Total: OFF", UDim2.new(0, 20, 0, yOffset), nil)
yOffset = yOffset + 45
local xrayButton = createButton("Raio-X: OFF", UDim2.new(0, 20, 0, yOffset), nil)
yOffset = yOffset + 55
-- Seção Troll
local trollLabel = createLabel("Troll", UDim2.new(0, 10, 0, yOffset))
yOffset = yOffset + 35
local trollButton = createButton("Modo Troll: OFF", UDim2.new(0, 20, 0, yOffset), nil)
yOffset = yOffset + 45
local flingButton = createButton("Arremessar Jogadores", UDim2.new(0, 20, 0, yOffset), nil)
yOffset = yOffset + 45
local spinButton = createButton("Girar: OFF", UDim2.new(0, 20, 0, yOffset), nil)
yOffset = yOffset + 45
local rainbowButton = createButton("Arco-Íris: OFF", UDim2.new(0, 20, 0, yOffset), nil)
yOffset = yOffset + 45
local freezeAllButton = createButton("Congelar Todos: OFF", UDim2.new(0, 20, 0, yOffset), nil)
yOffset = yOffset + 55
-- Seção Admin
local adminLabel = createLabel("Admin", UDim2.new(0, 10, 0, yOffset))
yOffset = yOffset + 35
local btoolsButton = createButton("Dar Btools", UDim2.new(0, 20, 0, yOffset), nil)
yOffset = yOffset + 45
local wallClimbButton = createButton("Escalar Parede: OFF", UDim2.new(0, 20, 0, yOffset), nil)
yOffset = yOffset + 45
local swimInAirButton = createButton("Nadar no Ar: OFF", UDim2.new(0, 20, 0, yOffset), nil)
yOffset = yOffset + 55
-- Seção Mundo
local worldLabel = createLabel("Mundo", UDim2.new(0, 10, 0, yOffset))
yOffset = yOffset + 35
local removeFogButton = createButton("Remover Névoa", UDim2.new(0, 20, 0, yOffset), nil)
yOffset = yOffset + 45
local forceDayButton = createButton("Forçar Dia", UDim2.new(0, 20, 0, yOffset), nil)
yOffset = yOffset + 45
local forceNightButton = createButton("Forçar Noite", UDim2.new(0, 20, 0, yOffset), nil)
yOffset = yOffset + 45
local removeRoofButton = createButton("Remover Teto", UDim2.new(0, 20, 0, yOffset), nil)
yOffset = yOffset + 45
local removeWallsButton = createButton("Remover Paredes", UDim2.new(0, 20, 0, yOffset), nil)
yOffset = yOffset + 55
-- Seção Diversão
local funLabel = createLabel("Diversão", UDim2.new(0, 10, 0, yOffset))
yOffset = yOffset + 35
local flashlightButton = createButton("Lanterna: OFF", UDim2.new(0, 20, 0, yOffset), nil)
yOffset = yOffset + 45
local reachButton = createButton("Alcance: OFF", UDim2.new(0, 20, 0, yOffset), nil)
yOffset = yOffset + 45
local bigHeadButton = createButton("Cabeça Grande: OFF", UDim2.new(0, 20, 0, yOffset), nil)
yOffset = yOffset + 55
-- Seção Sistema
local sistemaLabel = createLabel("Sistema", UDim2.new(0, 10, 0, yOffset))
yOffset = yOffset + 35
local resetButton = createButton("Reiniciar Todas as Funcionalidades", UDim2.new(0, 20, 0, yOffset), Color3.fromRGB(150, 50, 50))
yOffset = yOffset + 45
local exitButton = createButton("🚪 Encerrar Script", UDim2.new(0, 20, 0, yOffset), Color3.fromRGB(150, 50, 50))
yOffset = yOffset + 45
-- Atualizar canvas size
contentFrame.CanvasSize = UDim2.new(0, 0, 0, yOffset + 80)
-- Funções principais (definidas antes das conexões)
local function updateButtonState(button, enabled, feature)
if enabled then
button.Text = feature .. ": ON"
button.BackgroundColor3 = Color3.fromRGB(60, 180, 90)
button.TextColor3 = Color3.fromRGB(255,255,255)
else
button.Text = feature .. ": OFF"
button.BackgroundColor3 = Color3.fromRGB(50, 54, 70)
button.TextColor3 = Color3.fromRGB(230,230,230)
end
end
local function updateFlySpeedLabel()
    flyControl.updateLabel(flySpeed)
end
local function updateSpeedHackLabel()
    speedHackControl.updateLabel(speedHackSpeed)
end
local function updateJumpHackLabel()
    jumpHackControl.updateLabel(jumpHackPower)
end
-- Variáveis para transportar partes soltas
local carriedParts = {}
local carryOffsets = {}

local function toggleFly()
flyEnabled = not flyEnabled
updateButtonState(flyButton, flyEnabled, "Voo")
if flyEnabled then
    bodyVelocity.Parent = humanoidRootPart
    bodyGyro.Parent = humanoidRootPart
    
    -- Detectar partes próximas que estavam grudadas mas agora estão soltas
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj ~= humanoidRootPart and not obj.Anchored and obj.Parent ~= character then
            local distance = (obj.Position - humanoidRootPart.Position).Magnitude
            if distance <= 15 then -- Partes dentro de 15 studs
                -- Verificar se a parte não está sendo segurada por outro jogador
                local isCarried = false
                for _, bodyMover in pairs(obj:GetChildren()) do
                    if bodyMover:IsA("BodyVelocity") or bodyMover:IsA("BodyPosition") then
                        isCarried = true
                        break
                    end
                end
                
                if not isCarried then
                    table.insert(carriedParts, obj)
                    carryOffsets[obj] = obj.Position - humanoidRootPart.Position
                    
                    -- Criar BodyPosition para mover a parte junto
                    local bodyPosition = Instance.new("BodyPosition")
                    bodyPosition.MaxForce = Vector3.new(4000, 4000, 4000)
                    bodyPosition.P = 3000
                    bodyPosition.D = 500
                    bodyPosition.Parent = obj
                    bodyPosition.Name = "CarryPosition"
                end
            end
        end
    end
    
    connections.fly = RunService.Heartbeat:Connect(function()
        local moveVector = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveVector = moveVector + workspace.CurrentCamera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveVector = moveVector - workspace.CurrentCamera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveVector = moveVector - workspace.CurrentCamera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveVector = moveVector + workspace.CurrentCamera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveVector = moveVector + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            moveVector = moveVector - Vector3.new(0, 1, 0)
        end
        
        bodyVelocity.Velocity = moveVector * flySpeed
        bodyGyro.CFrame = workspace.CurrentCamera.CFrame
        
        -- Mover partes carregadas junto com o jogador
        for i, part in pairs(carriedParts) do
            if part and part.Parent and carryOffsets[part] then
                local bodyPosition = part:FindFirstChild("CarryPosition")
                if bodyPosition then
                    bodyPosition.Position = humanoidRootPart.Position + carryOffsets[part]
                else
                    -- Se o BodyPosition foi removido, parar de carregar esta parte
                    table.remove(carriedParts, i)
                    carryOffsets[part] = nil
                end
            else
                -- Parte foi destruída, remover da lista
                table.remove(carriedParts, i)
                if part then carryOffsets[part] = nil end
            end
        end
    end)
else
    if connections.fly then
        connections.fly:Disconnect()
    end
    bodyVelocity.Parent = nil
    bodyGyro.Parent = nil
    
    -- Soltar todas as partes carregadas
    for _, part in pairs(carriedParts) do
        if part and part.Parent then
            local bodyPosition = part:FindFirstChild("CarryPosition")
            if bodyPosition then
                bodyPosition:Destroy()
            end
        end
    end
    carriedParts = {}
    carryOffsets = {}
end
end
local function toggleNoclip()
noclipEnabled = not noclipEnabled
updateButtonState(noclipButton, noclipEnabled, "Sem Colisão")
if noclipEnabled then
connections.noclip = RunService.Stepped:Connect(function()
for _, part in pairs(character:GetChildren()) do
if part:IsA("BasePart") then
part.CanCollide = false
end
end
end)
else
if connections.noclip then
connections.noclip:Disconnect()
end
for _, part in pairs(character:GetChildren()) do
if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
part.CanCollide = true
end
end
end
end
local function toggleGod()
godEnabled = not godEnabled
updateButtonState(godButton, godEnabled, "Modo Deus")
if godEnabled then
originalValues.maxHealth = humanoid.MaxHealth
originalValues.health = humanoid.Health
humanoid.MaxHealth = math.huge
humanoid.Health = math.huge
connections.god = humanoid.HealthChanged:Connect(function()
if godEnabled then
humanoid.Health = humanoid.MaxHealth
end
end)
else
if connections.god then
connections.god:Disconnect()
end
humanoid.MaxHealth = originalValues.maxHealth or 100
humanoid.Health = originalValues.health or 100
end
end
local function toggleClickTp()
clickTpEnabled = not clickTpEnabled
updateButtonState(clickTpButton, clickTpEnabled, "TP ao Clicar")
if clickTpEnabled then
connections.clickTp = mouse.Button1Down:Connect(function()
if not clickTpEnabled then return end
local hit = mouse.Hit
if hit and typeof(hit) == "CFrame" then
local pos = hit.Position
if typeof(pos) == "Vector3" and pos.Y > -1e5 and pos.Y < 1e5 then
humanoidRootPart.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
end
end
end)
else
if connections.clickTp then connections.clickTp:Disconnect() end
end
end
local function toggleSpeedHack()
speedHackEnabled = not speedHackEnabled
updateButtonState(speedHackButton, speedHackEnabled, "Velocidade Hack")
if speedHackEnabled then
originalValues.walkSpeed = humanoid.WalkSpeed
humanoid.WalkSpeed = speedHackSpeed
else
humanoid.WalkSpeed = originalValues.walkSpeed or 16
end
end
local function toggleJumpHack()
jumpHackEnabled = not jumpHackEnabled
updateButtonState(jumpHackButton, jumpHackEnabled, "Pulo Hack")
if jumpHackEnabled then
originalValues.jumpPower = humanoid.JumpPower or humanoid.JumpHeight
if humanoid:FindFirstChild("JumpPower") then
humanoid.JumpPower = jumpHackPower
else
humanoid.JumpHeight = jumpHackPower
end
else
if humanoid:FindFirstChild("JumpPower") then
humanoid.JumpPower = originalValues.jumpPower or 50
else
humanoid.JumpHeight = originalValues.jumpPower or 7.2
end
end
end
local function toggleInfiniteJump()
infiniteJumpEnabled = not infiniteJumpEnabled
updateButtonState(infiniteJumpButton, infiniteJumpEnabled, "Pulo Infinito")
if infiniteJumpEnabled then
connections.infiniteJump = UserInputService.JumpRequest:Connect(function()
if infiniteJumpEnabled then
humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
end
end)
else
if connections.infiniteJump then
connections.infiniteJump:Disconnect()
end
end
end
local function toggleInvisible()
invisibleEnabled = not invisibleEnabled
updateButtonState(invisibleButton, invisibleEnabled, "Invisível")
applyInvisibility(invisibleEnabled)
end
local function applyInvisibility(state)
if not character then return end
for _, part in pairs(character:GetChildren()) do
if part:IsA("BasePart") then
part.Transparency = state and 1 or 0
elseif part:IsA("Accessory") and part:FindFirstChild("Handle") then
part.Handle.Transparency = state and 1 or 0
end
end
local head = character:FindFirstChild("Head")
if head and head:FindFirstChild("face") then
head.face.Transparency = state and 1 or 0
end
end
local function toggleFullBright()
fullBrightEnabled = not fullBrightEnabled
updateButtonState(fullBrightButton, fullBrightEnabled, "Brilho Total")
if fullBrightEnabled then
originalValues.brightness = Lighting.Brightness
originalValues.ambient = Lighting.Ambient
Lighting.Brightness = 2
Lighting.Ambient = Color3.new(1, 1, 1)
else
Lighting.Brightness = originalValues.brightness or 1
Lighting.Ambient = originalValues.ambient or Color3.new(0, 0, 0)
end
end
local function toggleRainbow()
rainbowEnabled = not rainbowEnabled
updateButtonState(rainbowButton, rainbowEnabled, "Arco-Íris")
if rainbowEnabled then
connections.rainbow = RunService.Heartbeat:Connect(function()
if rainbowEnabled then
local hue = tick() % 5 / 5
local color = Color3.fromHSV(hue, 1, 1)
for _, part in pairs(character:GetChildren()) do
if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
part.Color = color
end
end
end
end)
else
if connections.rainbow then
connections.rainbow:Disconnect()
end
for _, part in pairs(character:GetChildren()) do
if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
part.Color = Color3.new(1, 1, 1)
end
end
end
end
local function toggleLowGravity()
lowGravityEnabled = not lowGravityEnabled
updateButtonState(lowGravityButton, lowGravityEnabled, "Gravidade Baixa")
if lowGravityEnabled then
originalValues.gravity = workspace.Gravity
workspace.Gravity = 50
else
workspace.Gravity = originalValues.gravity or 196.2
end
end
local function toggleAutoHeal()
autoHealEnabled = not autoHealEnabled
updateButtonState(autoHealButton, autoHealEnabled, "Cura Automática")
if autoHealEnabled then
connections.autoHeal = RunService.Heartbeat:Connect(function()
if autoHealEnabled and humanoid.Health < humanoid.MaxHealth then
humanoid.Health = humanoid.MaxHealth
end
end)
else
if connections.autoHeal then
connections.autoHeal:Disconnect()
end
end
end
local function toggleAntiFall()
antiFallEnabled = not antiFallEnabled
updateButtonState(antiFallButton, antiFallEnabled, "Anti-Queda")
if antiFallEnabled then
connections.antiFall = RunService.Heartbeat:Connect(function()
if antiFallEnabled and humanoidRootPart.Position.Y < -50 then
humanoidRootPart.CFrame = CFrame.new(humanoidRootPart.Position.X, 50, humanoidRootPart.Position.Z)
end
end)
else
if connections.antiFall then
connections.antiFall:Disconnect()
end
end
end
local function toggleNoFallDamage()
noFallDamageEnabled = not noFallDamageEnabled
updateButtonState(noFallDamageButton, noFallDamageEnabled, "Sem Dano de Queda")
if noFallDamageEnabled then
attachNoFallDamage()
else
if connections.noFallDamageState then connections.noFallDamageState:Disconnect() end
if connections.noFallDamageHealth then connections.noFallDamageHealth:Disconnect() end
fallContext.inFreefall, fallContext.startY, fallContext.startHealth = false, 0, 0
end
end
local fallContext = { inFreefall = false, startY = 0, startHealth = 0 }
local function attachNoFallDamage()
if connections.noFallDamageState then pcall(function() connections.noFallDamageState:Disconnect() end) end
if connections.noFallDamageHealth then pcall(function() connections.noFallDamageHealth:Disconnect() end) end
connections.noFallDamageState = humanoid.StateChanged:Connect(function(_, newState)
if not noFallDamageEnabled then return end
if newState == Enum.HumanoidStateType.Freefall then
fallContext.inFreefall = true
fallContext.startY = humanoidRootPart.Position.Y
fallContext.startHealth = humanoid.Health
elseif fallContext.inFreefall and (newState == Enum.HumanoidStateType.Landed or newState == Enum.HumanoidStateType.Running or newState == Enum.HumanoidStateType.RunningNoPhysics) then
fallContext.inFreefall = false
local drop = (fallContext.startY - humanoidRootPart.Position.Y)
if drop > 10 then
task.defer(function()
if noFallDamageEnabled and humanoid and humanoid.Health < fallContext.startHealth then
humanoid.Health = math.max(humanoid.Health, fallContext.startHealth)
end
end)
end
end
end)
connections.noFallDamageHealth = humanoid.HealthChanged:Connect(function()
if noFallDamageEnabled and fallContext.startHealth > 0 and fallContext.inFreefall then
if humanoid.Health < fallContext.startHealth then
humanoid.Health = math.max(humanoid.Health, fallContext.startHealth)
end
end
end)
end
local function toggleWallClimb()
wallClimbEnabled = not wallClimbEnabled
updateButtonState(wallClimbButton, wallClimbEnabled, "Escalar Parede")
if wallClimbEnabled then
connections.wallClimb = RunService.RenderStepped:Connect(function()
if wallClimbEnabled and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
local origin = humanoidRootPart.Position
local direction = humanoidRootPart.CFrame.LookVector * 3
local raycastParams = RaycastParams.new()
raycastParams.FilterType = Enum.RaycastFilterType.Exclude
raycastParams.FilterDescendantsInstances = {character}
local raycastResult = workspace:Raycast(origin, direction, raycastParams)
if raycastResult and raycastResult.Distance <= 3 then
humanoidRootPart.Velocity = Vector3.new(humanoidRootPart.Velocity.X, 30, humanoidRootPart.Velocity.Z)
if humanoid:GetState() ~= Enum.HumanoidStateType.Jumping then
humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
end
end
end
end)
else
if connections.wallClimb then connections.wallClimb:Disconnect() end
end
end
local function toggleSwimInAir()
swimEnabled = not swimEnabled
updateButtonState(swimInAirButton, swimEnabled, "Nadar no Ar")
if swimEnabled then
connections.swim = RunService.Heartbeat:Connect(function()
if swimEnabled and humanoid:GetState() ~= Enum.HumanoidStateType.Swimming then
humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
end
end)
else
if connections.swim then connections.swim:Disconnect() end
humanoid:ChangeState(Enum.HumanoidStateType.Running)
end
end
local function toggleReach()
reachEnabled = not reachEnabled
updateButtonState(reachButton, reachEnabled, "Alcance")
if reachEnabled then
connections.reach = RunService.Heartbeat:Connect(function()
if reachEnabled then
for _, tool in pairs(character:GetChildren()) do
if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
tool.Handle.Size = Vector3.new(0.5, 0.5, 20)
end
end
end
end)
else
if connections.reach then connections.reach:Disconnect() end
for _, tool in pairs(character:GetChildren()) do
if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
tool.Handle.Size = Vector3.new(0.5, 0.5, 0.5)
end
end
end
end
local function isEnemy(p)
if p == player then return false end
if player.Team ~= nil and p.Team ~= nil then
return p.Team ~= player.Team
end
return true
end
local function tpRandomPlayer()
local list = {}
for _, p in ipairs(Players:GetPlayers()) do
if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
table.insert(list, p)
end
end
if #list == 0 then
warn("Nenhum jogador válido para TP Random.")
return
end
local target = list[math.random(1, #list)]
local hrp = target.Character:FindFirstChild("HumanoidRootPart")
if hrp then
humanoidRootPart.CFrame = hrp.CFrame * CFrame.new(0, 5, 0)
print("Teleportado para:", target.Name)
end
end
local function tpToSpawn()
for _, obj in ipairs(workspace:GetChildren()) do
if obj:IsA("SpawnLocation") or obj:IsA("SpawnPoint") then
humanoidRootPart.CFrame = obj.CFrame * CFrame.new(0, 5, 0)
print("Teleportado para spawn.")
return
end
end
humanoidRootPart.CFrame = CFrame.new(0, 50, 0)
print("Spawn não encontrado, teleportado para (0,50,0).")
end
local followTarget = nil
local function isValidTarget(p)
return p and p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart")
end
local function findClosestPlayer()
local best, bestDist = nil, math.huge
for _, p in ipairs(Players:GetPlayers()) do
if isValidTarget(p) then
local d = (humanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
if d < bestDist then best, bestDist = p, d end
end
end
return best
end
local function toggleFollowPlayer()
followEnabledFlag = not followEnabledFlag
updateButtonState(followPlayerButton, followEnabledFlag, "Seguir Jogador")
if followEnabledFlag then
followTarget = findClosestPlayer()
if connections.follow then connections.follow:Disconnect() end
local FOLLOW_DISTANCE = 5
local LERP_ALPHA = 0.35
connections.follow = RunService.Heartbeat:Connect(function()
if not followEnabledFlag then return end
if not isValidTarget(followTarget) then
followTarget = findClosestPlayer()
if not followTarget then return end
end
local targetHRP = followTarget.Character.HumanoidRootPart
local desired = targetHRP.CFrame * CFrame.new(0, 0, FOLLOW_DISTANCE)
local lookAt = CFrame.new(desired.Position, targetHRP.Position)
humanoidRootPart.CFrame = humanoidRootPart.CFrame:Lerp(lookAt, LERP_ALPHA)
end)
else
if connections.follow then connections.follow:Disconnect() end
followTarget = nil
end
end
local function toggleAnchor()
anchorEnabled = not anchorEnabled
updateButtonState(anchorButton, anchorEnabled, "Grudar no Chão")
if anchorEnabled then
    -- Raycasting para encontrar o chão abaixo do jogador
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.FilterDescendantsInstances = {character}
    
    local raycastResult = workspace:Raycast(humanoidRootPart.Position, Vector3.new(0, -1000, 0), raycastParams)
    
    if raycastResult then
        -- Posicionar o jogador no chão encontrado
        local groundY = raycastResult.Position.Y
        humanoidRootPart.CFrame = CFrame.new(humanoidRootPart.Position.X, groundY + 3, humanoidRootPart.Position.Z)
        
        -- Ancorar o jogador no chão
        humanoidRootPart.Anchored = true
        humanoid.PlatformStand = true
        
        -- Loop para manter o jogador colado no chão mesmo se ele se mover
        connections.anchor = RunService.Heartbeat:Connect(function()
            if anchorEnabled and humanoidRootPart then
                local newRaycast = workspace:Raycast(humanoidRootPart.Position, Vector3.new(0, -50, 0), raycastParams)
                if newRaycast then
                    local newGroundY = newRaycast.Position.Y
                    local currentPos = humanoidRootPart.Position
                    humanoidRootPart.CFrame = CFrame.new(currentPos.X, newGroundY + 3, currentPos.Z)
                end
            end
        end)
        
        print("🔗 Jogador grudado no chão!")
    else
        -- Se não encontrar chão, apenas ancorar no lugar atual
        humanoidRootPart.Anchored = true
        humanoid.PlatformStand = true
        print("⚠️ Chão não detectado, ancorando na posição atual")
    end
else
    -- Desancorar e permitir movimento normal
    humanoidRootPart.Anchored = false
    humanoid.PlatformStand = false
    
    -- Desconectar o loop de anchor
    if connections.anchor then
        connections.anchor:Disconnect()
        connections.anchor = nil
    end
    
    print("🔓 Jogador liberado do chão")
end
end

local function toggleCarryParts()
carryPartsEnabled = not carryPartsEnabled
updateButtonState(carryPartsButton, carryPartsEnabled, "Carregar Partes")

if carryPartsEnabled then
    -- Detectar e pegar todas as partes próximas não ancoradas
    local partCount = 0
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj ~= humanoidRootPart and not obj.Anchored and obj.Parent ~= character then
            local distance = (obj.Position - humanoidRootPart.Position).Magnitude
            if distance <= 20 then -- Partes dentro de 20 studs
                -- Verificar se a parte não está sendo segurada
                local isCarried = false
                for _, bodyMover in pairs(obj:GetChildren()) do
                    if bodyMover:IsA("BodyVelocity") or bodyMover:IsA("BodyPosition") then
                        isCarried = true
                        break
                    end
                end
                
                if not isCarried then
                    table.insert(carriedParts, obj)
                    carryOffsets[obj] = obj.Position - humanoidRootPart.Position
                    
                    -- Criar BodyPosition para mover a parte junto
                    local bodyPosition = Instance.new("BodyPosition")
                    bodyPosition.MaxForce = Vector3.new(4000, 4000, 4000)
                    bodyPosition.P = 3000
                    bodyPosition.D = 500
                    bodyPosition.Parent = obj
                    bodyPosition.Name = "CarryPosition"
                    bodyPosition.Position = humanoidRootPart.Position + carryOffsets[obj]
                    
                    partCount = partCount + 1
                end
            end
        end
    end
    
    -- Loop para manter as partes próximas ao jogador
    connections.carryParts = RunService.Heartbeat:Connect(function()
        if not carryPartsEnabled then return end
        
        for i = #carriedParts, 1, -1 do
            local part = carriedParts[i]
            if part and part.Parent and carryOffsets[part] then
                local bodyPosition = part:FindFirstChild("CarryPosition")
                if bodyPosition then
                    bodyPosition.Position = humanoidRootPart.Position + carryOffsets[part]
                else
                    -- Se o BodyPosition foi removido, parar de carregar esta parte
                    table.remove(carriedParts, i)
                    carryOffsets[part] = nil
                end
            else
                -- Parte foi destruída, remover da lista
                table.remove(carriedParts, i)
                if part then carryOffsets[part] = nil end
            end
        end
    end)
    
    print("📦 Carregando " .. partCount .. " partes próximas!")
else
    -- Soltar todas as partes carregadas
    for _, part in pairs(carriedParts) do
        if part and part.Parent then
            local bodyPosition = part:FindFirstChild("CarryPosition")
            if bodyPosition then
                bodyPosition:Destroy()
            end
        end
    end
    
    -- Desconectar o loop
    if connections.carryParts then
        connections.carryParts:Disconnect()
        connections.carryParts = nil
    end
    
    carriedParts = {}
    carryOffsets = {}
    print("📤 Todas as partes foram soltas!")
end
end

local function createPartMarker(part)
    -- Criar SelectionBox para destacar a parte
    local selectionBox = Instance.new("SelectionBox")
    selectionBox.Adornee = part
    selectionBox.Color3 = Color3.fromRGB(0, 255, 255) -- Ciano brilhante
    selectionBox.LineThickness = 0.2
    selectionBox.Transparency = 0.5
    selectionBox.Parent = part
    
    -- Criar BillboardGui com texto informativo
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Adornee = part
    billboardGui.Size = UDim2.new(0, 100, 0, 50)
    billboardGui.StudsOffset = Vector3.new(0, part.Size.Y/2 + 2, 0)
    billboardGui.Parent = part
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    textLabel.BackgroundTransparency = 0.3
    textLabel.BorderSizePixel = 0
    textLabel.Text = "📦 CLIQUE PARA GRUDAR"
    textLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
    textLabel.TextScaled = true
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.Parent = billboardGui
    
    -- Adicionar efeito de brilho pulsante
    local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
    local tween = TweenService:Create(selectionBox, tweenInfo, {Transparency = 0.1})
    tween:Play()
    
    -- Detectar clique na parte
    local clickDetector = Instance.new("ClickDetector")
    clickDetector.MaxActivationDistance = 50
    clickDetector.Parent = part
    
    clickDetector.MouseClick:Connect(function(player)
        if player == Players.LocalPlayer then
            -- Teletransportar para próximo da parte
            local targetPosition = part.Position + Vector3.new(0, part.Size.Y/2 + 3, 0)
            humanoidRootPart.CFrame = CFrame.new(targetPosition)
            
            -- Ativar automaticamente o sistema de grudar no chão
            if not anchorEnabled then
                toggleAnchor()
            end
            
            -- Se o sistema de carregar partes estiver ativo, adicionar esta parte
            if carryPartsEnabled and not carriedParts[part] then
                table.insert(carriedParts, part)
                carryOffsets[part] = part.Position - humanoidRootPart.Position
                
                local bodyPosition = Instance.new("BodyPosition")
                bodyPosition.MaxForce = Vector3.new(4000, 4000, 4000)
                bodyPosition.P = 3000
                bodyPosition.D = 500
                bodyPosition.Parent = part
                bodyPosition.Name = "CarryPosition"
                bodyPosition.Position = humanoidRootPart.Position + carryOffsets[part]
            end
            
            print("🎯 Grudado na parte: " .. part.Name)
        end
    end)
    
    return {
        selectionBox = selectionBox,
        billboardGui = billboardGui,
        clickDetector = clickDetector,
        tween = tween
    }
end

local function removePartMarker(part)
    if partMarkers[part] then
        local marker = partMarkers[part]
        if marker.tween then marker.tween:Cancel() end
        if marker.selectionBox then marker.selectionBox:Destroy() end
        if marker.billboardGui then marker.billboardGui:Destroy() end
        if marker.clickDetector then marker.clickDetector:Destroy() end
        partMarkers[part] = nil
    end
end

local function toggleMarkParts()
markPartsEnabled = not markPartsEnabled
updateButtonState(markPartsButton, markPartsEnabled, "Marcar Partes")

if markPartsEnabled then
    -- Detectar e marcar todas as partes próximas não ancoradas
    local partCount = 0
    local scanRange = 50 -- Maior alcance para visualização
    
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj ~= humanoidRootPart and not obj.Anchored and obj.Parent ~= character then
            local distance = (obj.Position - humanoidRootPart.Position).Magnitude
            if distance <= scanRange and obj.Size.X > 1 and obj.Size.Y > 1 and obj.Size.Z > 1 then -- Só partes grandes o suficiente
                -- Verificar se não é uma parte do personagem ou ferramenta
                local isPlayerPart = false
                local parent = obj.Parent
                while parent do
                    if parent:IsA("Model") and parent:FindFirstChild("Humanoid") then
                        isPlayerPart = true
                        break
                    end
                    parent = parent.Parent
                end
                
                if not isPlayerPart then
                    markedParts[obj] = true
                    partMarkers[obj] = createPartMarker(obj)
                    partCount = partCount + 1
                end
            end
        end
    end
    
    -- Loop para monitorar partes e adicionar novas marcações
    connections.markParts = RunService.Heartbeat:Connect(function()
        if not markPartsEnabled then return end
        
        -- Verificar partes existentes
        for part, _ in pairs(markedParts) do
            if not part or not part.Parent or part.Anchored then
                -- Parte foi destruída ou ancorada, remover marcação
                removePartMarker(part)
                markedParts[part] = nil
            end
        end
        
        -- Adicionar novas partes a cada 2 segundos (otimização)
        if tick() % 2 < 0.1 then
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and obj ~= humanoidRootPart and not obj.Anchored and obj.Parent ~= character and not markedParts[obj] then
                    local distance = (obj.Position - humanoidRootPart.Position).Magnitude
                    if distance <= scanRange and obj.Size.X > 1 and obj.Size.Y > 1 and obj.Size.Z > 1 then
                        local isPlayerPart = false
                        local parent = obj.Parent
                        while parent do
                            if parent:IsA("Model") and parent:FindFirstChild("Humanoid") then
                                isPlayerPart = true
                                break
                            end
                            parent = parent.Parent
                        end
                        
                        if not isPlayerPart then
                            markedParts[obj] = true
                            partMarkers[obj] = createPartMarker(obj)
                        end
                    end
                end
            end
        end
    end)
    
    print("🎯 Marcando " .. partCount .. " partes próximas! Clique nelas para se grudar.")
else
    -- Remover todas as marcações
    for part, _ in pairs(markedParts) do
        removePartMarker(part)
    end
    
    -- Desconectar o loop
    if connections.markParts then
        connections.markParts:Disconnect()
        connections.markParts = nil
    end
    
    markedParts = {}
    partMarkers = {}
    print("❌ Marcações removidas!")
end
end

local function toggleAntiAfk()
antiAfkEnabled = not antiAfkEnabled
updateButtonState(antiAfkButton, antiAfkEnabled, "Anti-AFK")
if antiAfkEnabled then
connections.antiAfk = RunService.Heartbeat:Connect(function()
if not antiAfkEnabled then return end
local vu = game:GetService("VirtualUser")
pcall(function() vu:CaptureController() end)
pcall(function() vu:ClickButton2(Vector2.new(0, 0)) end)
end)
else
if connections.antiAfk then
connections.antiAfk:Disconnect()
end
end
end
local function toggleXray()
xrayEnabled = not xrayEnabled
updateButtonState(xrayButton, xrayEnabled, "Raio-X")
if xrayEnabled then
originalValues.transparency = {}
for _, obj in pairs(workspace:GetDescendants()) do
if obj:IsA("BasePart") and obj.Parent ~= character then
originalValues.transparency[obj] = obj.Transparency
obj.Transparency = 0.5
end
end
else
for obj, transparency in pairs(originalValues.transparency or {}) do
if obj and obj.Parent then
obj.Transparency = transparency
end
end
originalValues.transparency = {}
end
end
local function toggleMinimize()
    isMinimized = not isMinimized
    if isMinimized then
        -- Esconder a GUI principal
        mainFrame.Visible = false
        shadow.Visible = false

        -- Criar botão flutuante minimizado (estilo Roblox)
        if not minimizedButton then
            minimizedButton = Instance.new("ImageButton")
            minimizedButton.Size = UDim2.new(0, 40, 0, 40) -- Tamanho menor para combinar com controles do Roblox
            minimizedButton.Position = UDim2.new(1, -60, 1, -120) -- Canto inferior direito, evitando conflito com o painel esquerdo
            minimizedButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            minimizedButton.BackgroundTransparency = 0.2
            minimizedButton.Image = "rbxassetid://3926307971" -- Ícone de engrenagem (settings)
            minimizedButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
            minimizedButton.ScaleType = Enum.ScaleType.Fit
            minimizedButton.Parent = screenGui
            minimizedButton.ZIndex = 20 -- ZIndex alto para ficar acima dos controles do Roblox
            minimizedButton.Active = true
            minimizedButton.AutoButtonColor = false

            -- Borda arredondada
            local minimizedCorner = Instance.new("UICorner")
            minimizedCorner.CornerRadius = UDim.new(1, 0) -- Circular
            minimizedCorner.Parent = minimizedButton

            -- Sombra sutil
            local minimizedStroke = Instance.new("UIStroke")
            minimizedStroke.Color = Color3.fromRGB(255, 255, 255)
            minimizedStroke.Thickness = 1.5
            minimizedStroke.Transparency = 0.7
            minimizedStroke.Parent = minimizedButton

            -- Efeito hover
            minimizedButton.MouseEnter:Connect(function()
                if colorTweenConnection then
                    pcall(function() colorTweenConnection:Disconnect() end)
                    colorTweenConnection = nil
                end -- Pausar efeito de cor durante hover
                minimizedButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- Branco durante hover
                minimizedButton.ImageColor3 = Color3.fromRGB(0, 0, 0) -- Ícone preto para contraste
                minimizedButton:TweenSize(UDim2.new(0, 50, 0, 50), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
                minimizedStroke.Transparency = 0.2
            end)

            minimizedButton.MouseLeave:Connect(function()
                minimizedButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45) -- Voltar para cor base
                minimizedButton.ImageColor3 = Color3.fromRGB(255, 255, 255) -- Ícone branco
                minimizedButton:TweenSize(UDim2.new(0, 40, 0, 40), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
                minimizedStroke.Transparency = 0.7
                -- Retomar efeito de cor
                startColorPulse()
            end)

            -- Conectar clique para restaurar
            minimizedButton.MouseButton1Click:Connect(function()
                toggleMinimize() -- Chama novamente para restaurar
            end)

            -- Efeito de mudança de cor pulsante
            local function startColorPulse()
                if colorTweenConnection then
                    pcall(function() colorTweenConnection:Disconnect() end)
                end
                local colors = {
                    Color3.fromRGB(255, 100, 150), -- Rosa vibrante
                    Color3.fromRGB(100, 200, 255), -- Azul elétrico
                    Color3.fromRGB(150, 255, 100), -- Verde neon
                    Color3.fromRGB(255, 200, 100), -- Laranja
                    Color3.fromRGB(200, 100, 255), -- Roxo
                    Color3.fromRGB(255, 150, 200), -- Rosa pink
                    Color3.fromRGB(100, 255, 200), -- Verde água
                }
                local currentColorIndex = 1

                colorTweenConnection = RunService.Heartbeat:Connect(function()
                    if not minimizedButton or not minimizedButton.Parent then
                        if colorTweenConnection then
                            pcall(function() colorTweenConnection:Disconnect() end)
                            colorTweenConnection = nil
                        end
                        return
                    end

                    -- Mudar cor gradualmente com transição mais rápida
                    local nextColorIndex = currentColorIndex % #colors + 1
                    local currentColor = colors[currentColorIndex]
                    local nextColor = colors[nextColorIndex]

                    -- Interpolar entre cores (mais rápido)
                    local t = (tick() * 3) % 1 -- Ciclo de ~0.33 segundos
                    local newColor = currentColor:Lerp(nextColor, t)

                    minimizedButton.BackgroundColor3 = newColor
                    minimizedButton.ImageColor3 = Color3.new(1, 1, 1) -- Manter ícone branco

                    -- Trocar para próxima cor quando completar o ciclo
                    if t >= 0.95 then
                        currentColorIndex = nextColorIndex
                    end
                end)
            end

            -- Iniciar efeito de cor pulsante
            startColorPulse()
        end
    else
        -- Mostrar a GUI principal
        mainFrame.Visible = true
        shadow.Visible = true

        -- Destruir botão flutuante
        if minimizedButton then
            minimizedButton:Destroy()
            minimizedButton = nil
        end
        -- Interromper efeito de cor
        if colorTweenConnection then
            pcall(function() colorTweenConnection:Disconnect() end)
            colorTweenConnection = nil
        end
    end
end
local function giveBtools()
local tools = {"Clone", "Hammer", "Grab"}
for _, toolName in pairs(tools) do
local tool = Instance.new("Tool")
tool.Name = toolName
tool.RequiresHandle = false
tool.Parent = player.Backpack
end
print("Btools foram adicionadas")
end
local function deleteFog()
Lighting.FogEnd = math.huge
Lighting.FogStart = math.huge
local atmos = Lighting:FindFirstChildOfClass("Atmosphere")
if atmos then atmos:Destroy() end
print("Névoa removida")
end
local function forceDay()
pcall(function()
Lighting.ClockTime = 12
Lighting.Brightness = 2
end)
print("Forçado dia.")
end
local function forceNight()
pcall(function()
Lighting.ClockTime = 0
Lighting.Brightness = 1
end)
print("Forçada noite.")
end
local function removeRoof()
for _, p in ipairs(workspace:GetDescendants()) do
if p:IsA("BasePart") and (p.Name:lower():find("roof") or p.Name:lower():find("teto")) then
p.Transparency = 1
p.CanCollide = false
end
end
print("Teto(s) removido(s).")
end
local function removeWalls()
for _, p in ipairs(workspace:GetDescendants()) do
if p:IsA("BasePart") and (p.Name:lower():find("wall") or p.Name:lower():find("parede")) then
p.Transparency = 0.6
p.CanCollide = false
end
end
print("Paredes removidas/atravessáveis.")
end
local function toggleFlashlight()
local on = connections.flashlight and connections.flashlight.Parent
if on then
pcall(function() connections.flashlight:Destroy() end)
connections.flashlight = nil
updateButtonState(flashlightButton, false, "Lanterna")
else
local light = Instance.new("PointLight")
light.Brightness = 10
light.Range = 60
light.Parent = character:FindFirstChild("Head") or humanoidRootPart
connections.flashlight = light
updateButtonState(flashlightButton, true, "Lanterna")
end
end
local function toggleTroll()
trollEnabled = not trollEnabled
updateButtonState(trollButton, trollEnabled, "Modo Troll")
print("Modo Troll:", trollEnabled and "ON" or "OFF")
end
local function toggleSpin()
spinEnabled = not spinEnabled
updateButtonState(spinButton, spinEnabled, "Girar")
if spinEnabled then
local spinGyro = Instance.new("BodyAngularVelocity")
spinGyro.AngularVelocity = Vector3.new(0, 50, 0)
spinGyro.MaxTorque = Vector3.new(0, math.huge, 0)
spinGyro.Parent = humanoidRootPart
connections.spin = {spinGyro}
else
if connections.spin then
for _, obj in ipairs(connections.spin) do pcall(function() obj:Destroy() end) end
connections.spin = nil
end
end
end
local function performFling()
for _, p in pairs(Players:GetPlayers()) do
if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
local distance = (humanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
if distance <= 50 then
local bodyVel = Instance.new("BodyVelocity")
bodyVel.MaxForce = Vector3.new(4000, 4000, 4000)
bodyVel.Velocity = (p.Character.HumanoidRootPart.Position - humanoidRootPart.Position).Unit * 200
bodyVel.Parent = p.Character.HumanoidRootPart
game:GetService("Debris"):AddItem(bodyVel, 2)
end
end
end
print("Fling executado em jogadores próximos")
end
local function toggleFreezeAll()
freezeAllEnabled = not freezeAllEnabled
updateButtonState(freezeAllButton, freezeAllEnabled, "Congelar Todos")
if freezeAllEnabled then
for _, p in ipairs(Players:GetPlayers()) do
if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
pcall(function() p.Character.HumanoidRootPart.Anchored = true end)
end
end
else
for _, p in ipairs(Players:GetPlayers()) do
if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
pcall(function() p.Character.HumanoidRootPart.Anchored = false end)
end
end
end
end
local function toggleAutoFire()
autoFireEnabled = not autoFireEnabled
updateButtonState(autoFireButton, autoFireEnabled, "Auto-Fire")
if autoFireEnabled then
connections.autoFire = RunService.Heartbeat:Connect(function()
if autoFireEnabled then
for _, tool in pairs(character:GetChildren()) do
if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
tool:Activate()
end
end
end
end)
else
if connections.autoFire then connections.autoFire:Disconnect() end
end
print("Auto-Fire:", autoFireEnabled and "ON" or "OFF")
end
local function toggleNoRecoil()
noRecoilEnabled = not noRecoilEnabled
updateButtonState(noRecoilButton, noRecoilEnabled, "Sem Recuo")
if noRecoilEnabled then
connections.noRecoil = RunService.Heartbeat:Connect(function()
if noRecoilEnabled then
local cam = workspace.CurrentCamera
if cam then
cam.CFrame = CFrame.new(cam.CFrame.Position, cam.CFrame.Position + cam.CFrame.LookVector)
end
end
end)
else
if connections.noRecoil then connections.noRecoil:Disconnect() end
end
print("Sem Recuo:", noRecoilEnabled and "ON" or "OFF")
end
local function toggleBigHead()
bigHeadOn = not bigHeadOn
updateButtonState(bigHeadButton, bigHeadOn, "Cabeça Grande")
if character and character:FindFirstChild("Head") then
local head = character.Head
pcall(function()
head.Size = bigHeadOn and Vector3.new(4,4,4) or Vector3.new(2,1,1)
local mesh = head:FindFirstChild("Mesh")
if mesh then
mesh.Scale = bigHeadOn and Vector3.new(2,2,2) or Vector3.new(1,1,1)
end
end)
end
end
local function terminateScript()
if scriptTerminated then return end
pcall(resetAllFeatures)
scriptTerminated = true
if screenGui and screenGui.Parent then
pcall(function() screenGui:Destroy() end)
end
pcall(function() game:GetService("NetworkClient"):SetOutgoingKBPSLimit(math.huge) end)
if connections.characterAdded then pcall(function() connections.characterAdded:Disconnect() end) end
connections.characterAdded = nil
if connections.chat then pcall(function() connections.chat:Disconnect() end) end
connections.chat = nil
if bodyVelocity then pcall(function() bodyVelocity:Destroy() end) end
if bodyGyro then pcall(function() bodyGyro:Destroy() end) end
-- Interromper efeito de cor pulsante
if colorTweenConnection then
    pcall(function() colorTweenConnection:Disconnect() end)
    colorTweenConnection = nil
end
for k, v in pairs(connections) do
if typeof(v) == "RBXScriptConnection" then
pcall(function() v:Disconnect() end)
elseif type(v) == "table" then
for _, obj in pairs(v) do
if typeof(obj) == "RBXScriptConnection" then
pcall(function() obj:Disconnect() end)
elseif obj and obj.Destroy then
pcall(function() obj:Destroy() end)
end
end
elseif v and v.Destroy then
pcall(function() v:Destroy() end)
end
connections[k] = nil
end
print("✅ Script encerrado com sucesso! Todas as funcionalidades foram desativadas.")
end
local function resetAllFeatures()
local function off(fn, cond)
if cond then pcall(fn) end
end
off(toggleFly, flyEnabled)
off(toggleNoclip, noclipEnabled)
off(toggleGod, godEnabled)
off(toggleClickTp, clickTpEnabled)
off(toggleSpeedHack, speedHackEnabled)
off(toggleJumpHack, jumpHackEnabled)
off(toggleInfiniteJump, infiniteJumpEnabled)
off(toggleInvisible, invisibleEnabled)
off(toggleFullBright, fullBrightEnabled)
off(toggleRainbow, rainbowEnabled)
off(toggleLowGravity, lowGravityEnabled)
off(toggleAutoHeal, autoHealEnabled)
off(toggleAntiFall, antiFallEnabled)
off(toggleAnchor, anchorEnabled)
off(toggleCarryParts, carryPartsEnabled)
off(toggleMarkParts, markPartsEnabled)
off(toggleAntiAfk, antiAfkEnabled)
off(toggleXray, xrayEnabled)
off(toggleSpin, spinEnabled)
off(toggleWallClimb, wallClimbEnabled)
off(toggleSwimInAir, swimEnabled)
off(toggleReach, reachEnabled)
off(toggleNoFallDamage, noFallDamageEnabled)
off(toggleFollowPlayer, followEnabledFlag)
off(toggleTroll, trollEnabled)
off(toggleFreezeAll, freezeAllEnabled)
off(toggleAutoFire, autoFireEnabled)
off(toggleNoRecoil, noRecoilEnabled)
off(toggleBigHead, bigHeadOn)
if bodyVelocity.Parent then bodyVelocity.Parent = nil end
if bodyGyro.Parent then bodyGyro.Parent = nil end
-- Interromper efeito de cor pulsante
if colorTweenConnection then
    pcall(function() colorTweenConnection:Disconnect() end)
    colorTweenConnection = nil
end
if humanoid then
humanoid.PlatformStand = false
if humanoidRootPart then humanoidRootPart.Anchored = false end
end
for _, v in pairs(connections) do
if typeof(v) == "RBXScriptConnection" then
pcall(function() v:Disconnect() end)
elseif type(v) == "table" then
for _, obj in pairs(v) do
if typeof(obj) == "RBXScriptConnection" then
pcall(function() obj:Disconnect() end)
elseif obj and obj.Destroy then
pcall(function() obj:Destroy() end)
end
end
elseif v and v.Destroy then
pcall(function() v:Destroy() end)
end
end
connections = {}
originalValues = {}
end
local function onCharacterAdded(newChar)
if scriptTerminated then return end
character = newChar
humanoid = newChar:WaitForChild("Humanoid")
humanoidRootPart = newChar:WaitForChild("HumanoidRootPart")
if flyEnabled then
pcall(function() bodyVelocity:Destroy() end)
pcall(function() bodyGyro:Destroy() end)
bodyVelocity = Instance.new("BodyVelocity")
bodyVelocity.MaxForce = Vector3.new(400000, 400000, 400000)
bodyVelocity.Velocity = Vector3.new()
bodyVelocity.Parent = humanoidRootPart
bodyGyro = Instance.new("BodyGyro")
bodyGyro.MaxTorque = Vector3.new(400000, 400000, 400000)
bodyGyro.P = 3000
bodyGyro.D = 500
bodyGyro.Parent = humanoidRootPart
end
if spinEnabled then
local spinGyro = Instance.new("BodyAngularVelocity")
spinGyro.AngularVelocity = Vector3.new(0, 50, 0)
spinGyro.MaxTorque = Vector3.new(0, math.huge, 0)
spinGyro.Parent = humanoidRootPart
connections.spin = {spinGyro}
end
if invisibleEnabled then
applyInvisibility(true)
end
if anchorEnabled then
    -- Reativar o sistema de grudar no chão após respawn
    toggleAnchor()
    toggleAnchor() -- Toggle twice para reativar
end
if carryPartsEnabled then
    -- Reativar o sistema de carregar partes após respawn
    toggleCarryParts()
    toggleCarryParts() -- Toggle twice para reativar
end
if markPartsEnabled then
    -- Reativar o sistema de marcar partes após respawn
    toggleMarkParts()
    toggleMarkParts() -- Toggle twice para reativar
end
if noFallDamageEnabled then
attachNoFallDamage()
end
if rainbowEnabled then
toggleRainbow() -- Reconnect the loop
toggleRainbow() -- Toggle twice to re-enable
end
if xrayEnabled then
toggleXray()
toggleXray()
end
if bigHeadOn then
toggleBigHead()
toggleBigHead()
end
if connections.flashlight and flashlightButton.Text:find("ON") then
if not connections.flashlight.Parent then
local light = Instance.new("PointLight")
light.Brightness = 10
light.Range = 60
light.Parent = character:FindFirstChild("Head") or humanoidRootPart
connections.flashlight = light
end
end
end
-- Conexões dos botões
flyButton.MouseButton1Click:Connect(toggleFly)
noclipButton.MouseButton1Click:Connect(toggleNoclip)
godButton.MouseButton1Click:Connect(toggleGod)
clickTpButton.MouseButton1Click:Connect(toggleClickTp)
speedHackButton.MouseButton1Click:Connect(toggleSpeedHack)
jumpHackButton.MouseButton1Click:Connect(toggleJumpHack)
infiniteJumpButton.MouseButton1Click:Connect(toggleInfiniteJump)
invisibleButton.MouseButton1Click:Connect(toggleInvisible)
fullBrightButton.MouseButton1Click:Connect(toggleFullBright)
rainbowButton.MouseButton1Click:Connect(toggleRainbow)
lowGravityButton.MouseButton1Click:Connect(toggleLowGravity)
autoHealButton.MouseButton1Click:Connect(toggleAutoHeal)
antiFallButton.MouseButton1Click:Connect(toggleAntiFall)
noFallDamageButton.MouseButton1Click:Connect(toggleNoFallDamage)
anchorButton.MouseButton1Click:Connect(toggleAnchor)
carryPartsButton.MouseButton1Click:Connect(toggleCarryParts)
markPartsButton.MouseButton1Click:Connect(toggleMarkParts)
antiAfkButton.MouseButton1Click:Connect(toggleAntiAfk)
xrayButton.MouseButton1Click:Connect(toggleXray)
spinButton.MouseButton1Click:Connect(toggleSpin)
wallClimbButton.MouseButton1Click:Connect(toggleWallClimb)
swimInAirButton.MouseButton1Click:Connect(toggleSwimInAir)
reachButton.MouseButton1Click:Connect(toggleReach)
tpRandomButton.MouseButton1Click:Connect(tpRandomPlayer)
tpSpawnButton.MouseButton1Click:Connect(tpToSpawn)
btoolsButton.MouseButton1Click:Connect(giveBtools)
flashlightButton.MouseButton1Click:Connect(toggleFlashlight)
trollButton.MouseButton1Click:Connect(toggleTroll)
flingButton.MouseButton1Click:Connect(performFling)
resetButton.MouseButton1Click:Connect(resetAllFeatures)
exitButton.MouseButton1Click:Connect(terminateScript)
minimizeButton.MouseButton1Click:Connect(toggleMinimize)
removeFogButton.MouseButton1Click:Connect(deleteFog)
forceDayButton.MouseButton1Click:Connect(forceDay)
forceNightButton.MouseButton1Click:Connect(forceNight)
removeRoofButton.MouseButton1Click:Connect(removeRoof)
removeWallsButton.MouseButton1Click:Connect(removeWalls)
followPlayerButton.MouseButton1Click:Connect(toggleFollowPlayer)
freezeAllButton.MouseButton1Click:Connect(toggleFreezeAll)
autoFireButton.MouseButton1Click:Connect(toggleAutoFire)
noRecoilButton.MouseButton1Click:Connect(toggleNoRecoil)
bigHeadButton.MouseButton1Click:Connect(toggleBigHead)
-- Conexões dos botões de ajuste de valor
flyControl.minusButton.MouseButton1Click:Connect(function()
    flySpeed = math.max(10, flySpeed - 10)
    updateFlySpeedLabel()
end)
flyControl.plusButton.MouseButton1Click:Connect(function()
    flySpeed = math.min(500, flySpeed + 10)
    updateFlySpeedLabel()
end)
speedHackControl.minusButton.MouseButton1Click:Connect(function()
    speedHackSpeed = math.max(50, speedHackSpeed - 10)
    updateSpeedHackLabel()
end)
speedHackControl.plusButton.MouseButton1Click:Connect(function()
    speedHackSpeed = math.min(500, speedHackSpeed + 10)
    updateSpeedHackLabel()
end)
jumpHackControl.minusButton.MouseButton1Click:Connect(function()
    jumpHackPower = math.max(50, jumpHackPower - 10)
    updateJumpHackLabel()
end)
jumpHackControl.plusButton.MouseButton1Click:Connect(function()
    jumpHackPower = math.min(1000, jumpHackPower + 10)
    updateJumpHackLabel()
end)
-- Comandos de chat
connections.chat = player.Chatted:Connect(function(message)
if scriptTerminated then return end
local lowerMessage = message:lower()
if lowerMessage == "/voar" then
toggleFly()
elseif lowerMessage == "/atravessar" then
toggleNoclip()
elseif lowerMessage == "/deus" then
toggleGod()
elseif lowerMessage == "/velocidade" then
toggleSpeedHack()
elseif lowerMessage == "/invisivel" or lowerMessage == "/invis" then
toggleInvisible()
elseif lowerMessage == "/grudar" then
toggleAnchor()
elseif lowerMessage == "/soltar" then
-- Soltar todas as partes carregadas
for _, part in pairs(carriedParts) do
    if part and part.Parent then
        local bodyPosition = part:FindFirstChild("CarryPosition")
        if bodyPosition then
            bodyPosition:Destroy()
        end
    end
end
carriedParts = {}
carryOffsets = {}
print("Todas as partes foram soltas!")
elseif lowerMessage:sub(1, 8) == "/carregar" then
-- Pegar uma parte específica próxima para carregar
local range = 20
for _, obj in pairs(workspace:GetDescendants()) do
    if obj:IsA("BasePart") and obj ~= humanoidRootPart and not obj.Anchored and obj.Parent ~= character then
        local distance = (obj.Position - humanoidRootPart.Position).Magnitude
        if distance <= range then
            -- Verificar se já não está sendo carregada
            local alreadyCarried = false
            for _, carriedPart in pairs(carriedParts) do
                if carriedPart == obj then
                    alreadyCarried = true
                    break
                end
            end
            
            if not alreadyCarried then
                table.insert(carriedParts, obj)
                carryOffsets[obj] = obj.Position - humanoidRootPart.Position
                
                local bodyPosition = Instance.new("BodyPosition")
                bodyPosition.MaxForce = Vector3.new(4000, 4000, 4000)
                bodyPosition.P = 3000
                bodyPosition.D = 500
                bodyPosition.Parent = obj
                bodyPosition.Name = "CarryPosition"
                bodyPosition.Position = humanoidRootPart.Position + carryOffsets[obj]
                
                print("Parte carregada: " .. obj.Name)
                break
            end
        end
    end
end
elseif lowerMessage == "/marcar" then
toggleMarkParts()
elseif lowerMessage == "/reiniciar" then
resetAllFeatures()
end
end)
-- Sistema de Drag Alternativo (mais simples)
local function setupDragSystem()
    -- Remover conexões antigas se existirem
    if connections.dragBegan then
        pcall(function() connections.dragBegan:Disconnect() end)
        connections.dragBegan = nil
    end
    if connections.dragInput then
        pcall(function() connections.dragInput:Disconnect() end)
        connections.dragInput = nil
    end
    if connections.dragEnded then
        pcall(function() connections.dragEnded:Disconnect() end)
        connections.dragEnded = nil
    end

    -- Variáveis de estado
    local isDragging = false
    local dragStartPos = nil
    local guiStartPos = nil

    -- Função para obter posição do mouse
    local function getMousePosition()
        return UserInputService:GetMouseLocation()
    end

    -- Verificar se o ponto está dentro do botão de arrastar
    local function isPointInDragButton(point)
        if not dragButton or not dragButton.Parent then return false end
        local dragBtnPos = dragButton.AbsolutePosition
        local dragBtnSize = dragButton.AbsoluteSize
        return point.X >= dragBtnPos.X and point.X <= dragBtnPos.X + dragBtnSize.X and
               point.Y >= dragBtnPos.Y and point.Y <= dragBtnPos.Y + dragBtnSize.Y
    end

    -- Evento de início do drag
    connections.dragBegan = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end

        -- Verificar se o mouse está sobre o dragButton usando uma abordagem mais simples
        local mouseOver = false
        if dragButton and dragButton.Parent then
            -- Verificar se o mouse está dentro dos limites do botão
            local mousePos = UserInputService:GetMouseLocation()
            local btnPos = dragButton.AbsolutePosition
            local btnSize = dragButton.AbsoluteSize

            mouseOver = mousePos.X >= btnPos.X and mousePos.X <= btnPos.X + btnSize.X and
                       mousePos.Y >= btnPos.Y and mousePos.Y <= btnPos.Y + btnSize.Y
        end

        -- Verificar se clicou no botão de arrastar
        if mouseOver then
            isDragging = true
            dragStartPos = UserInputService:GetMouseLocation()
            guiStartPos = mainFrame.Position
            mainFrame.ScrollingEnabled = false

            -- Indicação visual de arrastar ativo
            dragButton.BackgroundColor3 = Color3.fromRGB(120, 130, 150)
            dragStroke.Transparency = 0.2
        end
    end)

    -- Evento de movimento durante o drag
    connections.dragInput = UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseMovement then return end
        if not isDragging then return end

        local currentMousePos = UserInputService:GetMouseLocation()
        local delta = currentMousePos - dragStartPos

        -- Calcular nova posição
        local newPos = UDim2.new(
            guiStartPos.X.Scale,
            guiStartPos.X.Offset + delta.X,
            guiStartPos.Y.Scale,
            guiStartPos.Y.Offset + delta.Y
        )

        -- Aplicar posições (estrutura unificada)
        mainFrame.Position = newPos
        shadow.Position = newPos
    end)

    -- Evento de fim do drag
    connections.dragEnded = UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
        if isDragging then
            isDragging = false
            dragStartPos = nil
            guiStartPos = nil
            mainFrame.ScrollingEnabled = true

            -- Restaurar aparência normal
            dragButton.BackgroundColor3 = Color3.fromRGB(70, 80, 100)
            dragStroke.Transparency = 0.7
        end
    end)

end

-- Chamar a função para configurar o drag
setupDragSystem()
connections.characterAdded = player.CharacterAdded:Connect(onCharacterAdded)
onCharacterAdded(character)
print("🔥 Admin Script v2.0 carregado com sucesso! 🔥")
print("💡 Use os botões na GUI ou comandos de chat (/voar, /atravessar, /deus, etc.)")
print("� Painel aparece no canto esquerdo da tela")
print("🔧 Use o botão de minimizar (—) para transformar em botão flutuante")
print("🌈 Botão minimizado pisca e muda de cor no canto inferior direito!")
print("� Botão minimizado pisca e muda de cor próximo ao chat!")