-- mod_loader.lua - Carregador Principal FK7 Admin
-- Script autocontido para Roblox - Cole no seu executor

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Tela de Carregamento
local function create_loading_ui()
    local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

    -- Verificar se já está carregado
    if playerGui:FindFirstChild("FK7_Loading") then
        if _G.FK7_LOADED then
            playerGui.FK7_Loading:Destroy()
            warn("[FK7] Script já está carregado!")
            return
        end
    end

    _G.FK7_LOADED = true

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FK7_Loading"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = playerGui

    print("🚀 FK7 Admin - Carregando módulos...")

    local background = Instance.new("Frame")
    background.Size = UDim2.new(1, 0, 1, 0)
    background.BackgroundColor3 = Color3.fromRGB(20, 22, 28)
    background.BackgroundTransparency = 0.2
    background.Parent = screenGui

    local container = Instance.new("Frame")
    container.Size = UDim2.new(0, 300, 0, 80)
    container.Position = UDim2.new(0.5, -150, 0.5, -40)
    container.BackgroundColor3 = Color3.fromRGB(35, 40, 50)
    container.BorderSizePixel = 0
    container.Parent = screenGui
    Instance.new("UICorner", container).CornerRadius = UDim.new(0, 8)

    local title = Instance.new("TextLabel", container)
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.Text = "FK7 Admin"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.TextSize = 18

    local status = Instance.new("TextLabel", container)
    status.Size = UDim2.new(1, -20, 0, 20)
    status.Position = UDim2.new(0, 10, 0, 55)
    status.BackgroundTransparency = 1
    status.Font = Enum.Font.Gotham
    status.Text = "Iniciando..."
    status.TextColor3 = Color3.fromRGB(200, 200, 200)
    status.TextSize = 14
    status.TextXAlignment = Enum.TextXAlignment.Left

    local barBg = Instance.new("Frame", container)
    barBg.Size = UDim2.new(1, -20, 0, 10)
    barBg.Position = UDim2.new(0, 10, 0, 40)
    barBg.BackgroundColor3 = Color3.fromRGB(25, 28, 35)
    Instance.new("UICorner", barBg).CornerRadius = UDim.new(0, 5)

    local barFill = Instance.new("Frame", barBg)
    barFill.Size = UDim2.new(0, 0, 1, 0)
    barFill.BackgroundColor3 = Color3.fromRGB(70, 120, 220)
    Instance.new("UICorner", barFill).CornerRadius = UDim.new(0, 5)

    return {
        gui = screenGui,
        background = background,
        status = status,
        bar = barFill,
        container = container
    }
end

-- Sistema de módulos
local Modules = {
    core = nil,
    features = {},
    ui = nil
}

-- Função para carregar módulos
local function loadModule(name, source)
    local success, module = pcall(loadstring, source)
    if success and module then
        return module()
    else
        warn("[FK7] Erro ao carregar módulo " .. name .. ":", module)
        return nil
    end
end

-- Módulos incorporados como strings
local embedded_modules = {
    core = [[
-- modules/core.lua - Gerenciador de estado e conexões
local Core = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local state = {
    player = Players.LocalPlayer,
    character = nil,
    humanoid = nil,
    humanoidRootPart = nil,
    connections = {},
    activeModules = {},
    originalValues = {}
}

function Core.state()
    return state
end

function Core.init()
    -- Inicializar estado do jogador
    state.character = state.player.Character or state.player.CharacterAdded:Wait()
    state.humanoid = state.character:WaitForChild("Humanoid")
    state.humanoidRootPart = state.character:WaitForChild("HumanoidRootPart")

    -- Conectar evento de respawn
    state.connections.characterAdded = state.player.CharacterAdded:Connect(function(newChar)
        Core.onCharacterRespawn(newChar)
    end)

    print("[FK7 Core] Inicializado com sucesso!")
    return state
end

function Core.onCharacterRespawn(newChar)
    -- Atualizar referências
    state.character = newChar
    state.humanoid = newChar:WaitForChild("Humanoid")
    state.humanoidRootPart = newChar:WaitForChild("HumanoidRootPart")

    -- Reaplicar módulos ativos
    for moduleName, isEnabled in pairs(state.activeModules) do
        if isEnabled and Core[moduleName] and Core[moduleName].enable then
            pcall(function()
                Core[moduleName].enable()
            end)
        end
    end

    print("[FK7 Core] Personagem respawnado, módulos reaplicados!")
end

function Core.registerModule(moduleName, moduleTable)
    -- Registrar módulo no core
    Core[moduleName] = moduleTable

    -- Adicionar função toggle se não existir
    if not moduleTable.toggle then
        moduleTable.toggle = function()
            local enabled = not (state.activeModules[moduleName] or false)
            state.activeModules[moduleName] = enabled

            if enabled then
                if moduleTable.enable then
                    pcall(moduleTable.enable)
                end
            else
                if moduleTable.disable then
                    pcall(moduleTable.disable)
                end
            end

            return enabled
        end
    end

    print("[FK7 Core] Módulo '" .. moduleName .. "' registrado!")
end

function Core.services()
    return { Players = Players, UserInputService = UserInputService, RunService = RunService }
end

return Core
]],

    fly = [[
-- modules/fly.lua - Sistema de voo
local Fly = {
    enabled = false,
    speed = 50,
    bodyVelocity = nil,
    bodyGyro = nil,
    connection = nil
}

local Core = require(script.Parent.core)
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

function Fly.enable()
    if Fly.enabled then return end
    Fly.enabled = true

    local st = Core.state()
    Fly.bodyVelocity = Instance.new("BodyVelocity")
    Fly.bodyVelocity.MaxForce = Vector3.new(400000, 400000, 400000)
    Fly.bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    Fly.bodyVelocity.Parent = st.humanoidRootPart

    Fly.bodyGyro = Instance.new("BodyGyro")
    Fly.bodyGyro.MaxTorque = Vector3.new(400000, 400000, 400000)
    Fly.bodyGyro.P = 3000
    Fly.bodyGyro.D = 500
    Fly.bodyGyro.Parent = st.humanoidRootPart

    Fly.connection = RunService.Heartbeat:Connect(function()
        if not Fly.enabled then return end

        local moveVector = Vector3.new()
        local camera = workspace.CurrentCamera

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveVector = moveVector + camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveVector = moveVector - camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveVector = moveVector - camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveVector = moveVector + camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveVector = moveVector + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            moveVector = moveVector - Vector3.new(0, 1, 0)
        end

        Fly.bodyVelocity.Velocity = moveVector * Fly.speed
        Fly.bodyGyro.CFrame = camera.CFrame
    end)

    print("[Fly] Ativado - Use WASD + Space/Ctrl para voar")
end

function Fly.disable()
    if not Fly.enabled then return end
    Fly.enabled = false

    if Fly.connection then
        Fly.connection:Disconnect()
        Fly.connection = nil
    end

    if Fly.bodyVelocity then
        Fly.bodyVelocity:Destroy()
        Fly.bodyVelocity = nil
    end

    if Fly.bodyGyro then
        Fly.bodyGyro:Destroy()
        Fly.bodyGyro = nil
    end

    print("[Fly] Desativado")
end

function Fly.setSpeed(speed)
    Fly.speed = math.clamp(speed, 10, 500)
    print("[Fly] Velocidade definida para: " .. Fly.speed)
end

return Fly
]],

    noclip = [[
-- modules/noclip.lua - Sistema de noclip
local Noclip = {
    enabled = false,
    connection = nil
}

local Core = require(script.Parent.core)
local RunService = game:GetService("RunService")

function Noclip.enable()
    if Noclip.enabled then return end
    Noclip.enabled = true

    local st = Core.state()

    Noclip.connection = RunService.Stepped:Connect(function()
        if not Noclip.enabled then return end

        for _, part in pairs(st.character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end)

    print("[Noclip] Ativado - Você pode atravessar paredes")
end

function Noclip.disable()
    if not Noclip.enabled then return end
    Noclip.enabled = false

    if Noclip.connection then
        Noclip.connection:Disconnect()
        Noclip.connection = nil
    end

    local st = Core.state()

    for _, part in pairs(st.character:GetChildren()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            part.CanCollide = true
        end
    end

    print("[Noclip] Desativado")
end

return Noclip
]],

    godmode = [[
-- modules/godmode.lua - Modo Deus
local Godmode = {
    enabled = false,
    connection = nil,
    originalMaxHealth = nil,
    originalHealth = nil
}

local Core = require(script.Parent.core)

function Godmode.enable()
    if Godmode.enabled then return end
    Godmode.enabled = true

    local st = Core.state()
    local humanoid = st.humanoid

    -- Salvar valores originais
    Godmode.originalMaxHealth = humanoid.MaxHealth
    Godmode.originalHealth = humanoid.Health

    -- Definir vida infinita
    humanoid.MaxHealth = math.huge
    humanoid.Health = math.huge

    -- Conectar evento para manter vida infinita
    Godmode.connection = humanoid.HealthChanged:Connect(function()
        if Godmode.enabled then
            humanoid.Health = humanoid.MaxHealth
        end
    end)

    print("[Godmode] Ativado - Você é imortal!")
end

function Godmode.disable()
    if not Godmode.enabled then return end
    Godmode.enabled = false

    if Godmode.connection then
        Godmode.connection:Disconnect()
        Godmode.connection = nil
    end

    local st = Core.state()
    local humanoid = st.humanoid

    -- Restaurar valores originais
    if Godmode.originalMaxHealth then
        humanoid.MaxHealth = Godmode.originalMaxHealth
    end
    if Godmode.originalHealth then
        humanoid.Health = Godmode.originalHealth
    end

    print("[Godmode] Desativado")
end

return Godmode
]],

    speed = [[
-- modules/speed.lua - Velocidade aumentada
local Speed = {
    enabled = false,
    speed = 100,
    originalWalkSpeed = nil
}

local Core = require(script.Parent.core)

function Speed.enable()
    if Speed.enabled then return end
    Speed.enabled = true

    local st = Core.state()
    local humanoid = st.humanoid

    -- Salvar velocidade original
    Speed.originalWalkSpeed = humanoid.WalkSpeed

    -- Aplicar velocidade aumentada
    humanoid.WalkSpeed = Speed.speed

    print("[Speed] Ativado - Velocidade: " .. Speed.speed)
end

function Speed.disable()
    if not Speed.enabled then return end
    Speed.enabled = false

    local st = Core.state()
    local humanoid = st.humanoid

    -- Restaurar velocidade original
    if Speed.originalWalkSpeed then
        humanoid.WalkSpeed = Speed.originalWalkSpeed
    end

    print("[Speed] Desativado")
end

function Speed.setSpeed(speed)
    Speed.speed = math.clamp(speed, 50, 500)
    if Speed.enabled then
        local st = Core.state()
        st.humanoid.WalkSpeed = Speed.speed
    end
    print("[Speed] Velocidade definida para: " .. Speed.speed)
end

return Speed
]],

    infinitejump = [[
-- modules/infinitejump.lua - Pulo infinito
local InfiniteJump = {
    enabled = false,
    connection = nil
}

local Core = require(script.Parent.core)
local UserInputService = game:GetService("UserInputService")

function InfiniteJump.enable()
    if InfiniteJump.enabled then return end
    InfiniteJump.enabled = true

    local st = Core.state()
    local humanoid = st.humanoid

    InfiniteJump.connection = UserInputService.JumpRequest:Connect(function()
        if InfiniteJump.enabled then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)

    print("[InfiniteJump] Ativado - Pule infinitamente!")
end

function InfiniteJump.disable()
    if not InfiniteJump.enabled then return end
    InfiniteJump.enabled = false

    if InfiniteJump.connection then
        InfiniteJump.connection:Disconnect()
        InfiniteJump.connection = nil
    end

    print("[InfiniteJump] Desativado")
end

return InfiniteJump
]],

    clicktp = [[
-- modules/clicktp.lua - Teleporte ao clicar
local ClickTP = {
    enabled = false,
    connection = nil
}

local Core = require(script.Parent.core)
local Players = game:GetService("Players")

function ClickTP.enable()
    if ClickTP.enabled then return end
    ClickTP.enabled = true

    local st = Core.state()
    local player = st.player
    local mouse = player:GetMouse()

    ClickTP.connection = mouse.Button1Down:Connect(function()
        if not ClickTP.enabled then return end

        local hit = mouse.Hit
        if hit and typeof(hit) == "CFrame" then
            local pos = hit.Position
            if typeof(pos) == "Vector3" and pos.Y > -1e5 and pos.Y < 1e5 then
                st.humanoidRootPart.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
                print("[ClickTP] Teleportado para: " .. tostring(pos))
            end
        end
    end)

    print("[ClickTP] Ativado - Clique no mapa para teleportar")
end

function ClickTP.disable()
    if not ClickTP.enabled then return end
    ClickTP.enabled = false

    if ClickTP.connection then
        ClickTP.connection:Disconnect()
        ClickTP.connection = nil
    end

    print("[ClickTP] Desativado")
end

return ClickTP
]],

    fullbright = [[
-- modules/fullbright.lua - Iluminação total
local Fullbright = {
    enabled = false,
    originalBrightness = nil,
    originalAmbient = nil
}

local Core = require(script.Parent.core)
local Lighting = game:GetService("Lighting")

function Fullbright.enable()
    if Fullbright.enabled then return end
    Fullbright.enabled = true

    -- Salvar valores originais
    Fullbright.originalBrightness = Lighting.Brightness
    Fullbright.originalAmbient = Lighting.Ambient

    -- Aplicar iluminação total
    Lighting.Brightness = 2
    Lighting.Ambient = Color3.new(1, 1, 1)

    print("[Fullbright] Ativado - Ambiente totalmente iluminado")
end

function Fullbright.disable()
    if not Fullbright.enabled then return end
    Fullbright.enabled = false

    -- Restaurar valores originais
    if Fullbright.originalBrightness then
        Lighting.Brightness = Fullbright.originalBrightness
    end
    if Fullbright.originalAmbient then
        Lighting.Ambient = Fullbright.originalAmbient
    end

    print("[Fullbright] Desativado")
end

return Fullbright
]],

    esp = [[
-- modules/esp.lua - Sistema ESP
local ESP = {
    enabled = false,
    highlights = {},
    connections = {}
}

local Core = require(script.Parent.core)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

function ESP.enable()
    if ESP.enabled then return end
    ESP.enabled = true

    local st = Core.state()

    -- Função para criar ESP para um jogador
    local function createESP(player)
        if player == st.player or ESP.highlights[player] then return end

        local character = player.Character
        if not character then return end

        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then return end

        -- Criar Highlight
        local highlight = Instance.new("Highlight")
        highlight.Adornee = character
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.Parent = character

        -- Criar BillboardGui para nome
        local billboard = Instance.new("BillboardGui")
        billboard.Adornee = humanoidRootPart
        billboard.Size = UDim2.new(0, 100, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 2, 0)
        billboard.Parent = character

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, 0, 1, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = player.Name
        nameLabel.TextColor3 = Color3.new(1, 1, 1)
        nameLabel.TextStrokeTransparency = 0
        nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
        nameLabel.Font = Enum.Font.SourceSansBold
        nameLabel.TextSize = 14
        nameLabel.Parent = billboard

        ESP.highlights[player] = {
            highlight = highlight,
            billboard = billboard
        }
    end

    -- Criar ESP para jogadores existentes
    for _, player in pairs(Players:GetPlayers()) do
        createESP(player)
    end

    -- Conectar eventos para novos jogadores
    ESP.connections.playerAdded = Players.PlayerAdded:Connect(function(player)
        if ESP.enabled then
            createESP(player)
        end
    end)

    ESP.connections.playerRemoving = Players.PlayerRemoving:Connect(function(player)
        if ESP.highlights[player] then
            if ESP.highlights[player].highlight then
                ESP.highlights[player].highlight:Destroy()
            end
            if ESP.highlights[player].billboard then
                ESP.highlights[player].billboard:Destroy()
            end
            ESP.highlights[player] = nil
        end
    end)

    print("[ESP] Ativado - Jogadores visíveis")
end

function ESP.disable()
    if not ESP.enabled then return end
    ESP.enabled = false

    -- Desconectar eventos
    for _, connection in pairs(ESP.connections) do
        if connection then
            connection:Disconnect()
        end
    end
    ESP.connections = {}

    -- Remover todos os ESPs
    for _, espData in pairs(ESP.highlights) do
        if espData.highlight then
            espData.highlight:Destroy()
        end
        if espData.billboard then
            espData.billboard:Destroy()
        end
    end
    ESP.highlights = {}

    print("[ESP] Desativado")
end

return ESP
]],

    ui = [[
-- modules/ui.lua - Interface Moderna FK7 Admin
local UI = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Cores do tema
local COLORS = {
    background = Color3.fromRGB(24, 25, 28),
    surface = Color3.fromRGB(32, 34, 37),
    surface_light = Color3.fromRGB(40, 42, 46),
    primary = Color3.fromRGB(88, 166, 255),
    primary_dark = Color3.fromRGB(70, 140, 220),
    success = Color3.fromRGB(76, 175, 80),
    error = Color3.fromRGB(244, 67, 54),
    warning = Color3.fromRGB(255, 193, 7),
    text_primary = Color3.fromRGB(255, 255, 255),
    text_secondary = Color3.fromRGB(158, 158, 158),
    border = Color3.fromRGB(60, 63, 65)
}

-- Animações suaves
local function smooth_tween(object, properties, duration, style)
    duration = duration or 0.3
    style = style or Enum.EasingStyle.Quart
    return TweenService:Create(object, TweenInfo.new(duration, style), properties)
end

-- Sistema de arrastar
local function make_draggable(frame, dragHandle)
    local isDragging = false
    local dragStart, startPos

    dragHandle = dragHandle or frame

    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = true
            dragStart = input.Position
            startPos = frame.Position

            smooth_tween(frame, {Size = frame.Size + UDim2.fromOffset(4, 4)}):Play()
        end
    end)

    dragHandle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = false
            smooth_tween(frame, {Size = frame.Size - UDim2.fromOffset(4, 4)}):Play()
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.fromOffset(
                startPos.X.Offset + delta.X,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- Criar tooltip
local function create_tooltip(parent)
    local tooltip = Instance.new("Frame")
    tooltip.Name = "Tooltip"
    tooltip.Size = UDim2.fromOffset(200, 35)
    tooltip.BackgroundColor3 = COLORS.surface
    tooltip.BorderSizePixel = 0
    tooltip.ZIndex = 1000
    tooltip.Visible = false
    tooltip.Parent = parent

    local corner = Instance.new("UICorner", tooltip)
    corner.CornerRadius = UDim.new(0, 8)

    local stroke = Instance.new("UIStroke", tooltip)
    stroke.Color = COLORS.border
    stroke.Thickness = 1

    local label = Instance.new("TextLabel", tooltip)
    label.Size = UDim2.new(1, -16, 1, 0)
    label.Position = UDim2.fromOffset(8, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 13
    label.TextColor3 = COLORS.text_primary
    label.TextXAlignment = Enum.TextXAlignment.Left

    return tooltip, label
end

function UI.init(ctx)
    local Core = ctx.core
    local st = Core.state()
    local playerGui = st.player:WaitForChild("PlayerGui")

    -- Remover GUI antiga
    if playerGui:FindFirstChild("FK7_GUI") then
        playerGui.FK7_GUI:Destroy()
    end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FK7_GUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = playerGui

    -- Frame principal
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.fromOffset(420, 520)
    mainFrame.Position = UDim2.new(0.5, -210, 0.5, -260)
    mainFrame.BackgroundColor3 = COLORS.background
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui

    local mainCorner = Instance.new("UICorner", mainFrame)
    mainCorner.CornerRadius = UDim.new(0, 16)

    local mainStroke = Instance.new("UIStroke", mainFrame)
    mainStroke.Color = COLORS.border
    mainStroke.Thickness = 1

    -- Cabeçalho
    local header = Instance.new("Frame", mainFrame)
    header.Size = UDim2.new(1, 0, 0, 50)
    header.BackgroundColor3 = COLORS.surface
    header.BorderSizePixel = 0

    local headerCorner = Instance.new("UICorner", header)
    headerCorner.CornerRadius = UDim.new(0, 16)

    make_draggable(mainFrame, header)

    -- Logo e título
    local logoIcon = Instance.new("TextLabel", header)
    logoIcon.Size = UDim2.fromOffset(32, 32)
    logoIcon.Position = UDim2.fromOffset(16, 9)
    logoIcon.BackgroundTransparency = 1
    logoIcon.Text = "⚡"
    logoIcon.Font = Enum.Font.GothamBold
    logoIcon.TextSize = 18
    logoIcon.TextColor3 = COLORS.primary

    local title = Instance.new("TextLabel", header)
    title.Size = UDim2.new(1, -120, 1, 0)
    title.Position = UDim2.fromOffset(56, 0)
    title.BackgroundTransparency = 1
    title.Text = "FK7 Admin"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16
    title.TextColor3 = COLORS.text_primary
    title.TextXAlignment = Enum.TextXAlignment.Left

    -- Botões de controle
    local buttonContainer = Instance.new("Frame", header)
    buttonContainer.Size = UDim2.fromOffset(70, 30)
    buttonContainer.Position = UDim2.new(1, -85, 0.5, -15)
    buttonContainer.BackgroundTransparency = 1

    local buttonLayout = Instance.new("UIListLayout", buttonContainer)
    buttonLayout.FillDirection = Enum.FillDirection.Horizontal
    buttonLayout.Padding = UDim.new(0, 8)

    local function create_control_button(text, color, callback)
        local btn = Instance.new("TextButton", buttonContainer)
        btn.Size = UDim2.fromOffset(30, 30)
        btn.BackgroundColor3 = color
        btn.Text = text
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 12
        btn.TextColor3 = COLORS.text_primary
        btn.BorderSizePixel = 0

        local corner = Instance.new("UICorner", btn)
        corner.CornerRadius = UDim.new(0, 8)

        btn.MouseButton1Click:Connect(callback)
        return btn
    end

    local minimizeBtn = create_control_button("−", COLORS.warning, function()
        local isMinimized = mainFrame.Size.Y.Offset <= 60
        local targetSize = isMinimized and UDim2.fromOffset(420, 520) or UDim2.fromOffset(420, 50)
        smooth_tween(mainFrame, {Size = targetSize}, 0.4):Play()
    end)

    local closeBtn = create_control_button("✕", COLORS.error, function()
        local closeTween = smooth_tween(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.fromOffset(0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }, 0.3)
        closeTween:Play()

        closeTween.Completed:Connect(function()
            if ctx.core and ctx.core.shutdown then
                ctx.core.shutdown()
            end
            screenGui:Destroy()
        end)
    end)

    -- Container principal com abas
    local body = Instance.new("Frame", mainFrame)
    body.Size = UDim2.new(1, 0, 1, -50)
    body.Position = UDim2.fromOffset(0, 50)
    body.BackgroundTransparency = 1

    -- Sistema de abas lateral
    local tabContainer = Instance.new("Frame", body)
    tabContainer.Size = UDim2.fromOffset(110, 1)
    tabContainer.BackgroundColor3 = COLORS.surface
    tabContainer.BorderSizePixel = 0

    local tabLayout = Instance.new("UIListLayout", tabContainer)
    tabLayout.Padding = UDim.new(0, 4)
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local tabPadding = Instance.new("UIPadding", tabContainer)
    tabPadding.PaddingTop = UDim.new(0, 12)
    tabPadding.PaddingLeft = UDim.new(0, 8)
    tabPadding.PaddingRight = UDim.new(0, 8)

    -- Painel de informações do usuário
    local userPanel = Instance.new("Frame", tabContainer)
    userPanel.Size = UDim2.new(1, 0, 0, 65)
    userPanel.BackgroundColor3 = COLORS.surface_light
    userPanel.LayoutOrder = -1

    local userCorner = Instance.new("UICorner", userPanel)
    userCorner.CornerRadius = UDim.new(0, 8)

    local userName = Instance.new("TextLabel", userPanel)
    userName.Size = UDim2.new(1, -12, 0, 20)
    userName.Position = UDim2.fromOffset(6, 6)
    userName.BackgroundTransparency = 1
    userName.Text = st.player.Name
    userName.Font = Enum.Font.GothamBold
    userName.TextSize = 12
    userName.TextColor3 = COLORS.text_primary
    userName.TextXAlignment = Enum.TextXAlignment.Left
    userName.TextTruncate = Enum.TextTruncate.AtEnd

    local fpsLabel = Instance.new("TextLabel", userPanel)
    fpsLabel.Size = UDim2.new(1, -12, 0, 16)
    fpsLabel.Position = UDim2.fromOffset(6, 26)
    fpsLabel.BackgroundTransparency = 1
    fpsLabel.Text = "FPS: --"
    fpsLabel.Font = Enum.Font.Gotham
    fpsLabel.TextSize = 10
    fpsLabel.TextColor3 = COLORS.text_secondary
    fpsLabel.TextXAlignment = Enum.TextXAlignment.Left

    local pingLabel = Instance.new("TextLabel", userPanel)
    pingLabel.Size = UDim2.new(1, -12, 0, 16)
    pingLabel.Position = UDim2.fromOffset(6, 42)
    pingLabel.BackgroundTransparency = 1
    pingLabel.Text = "Ping: --"
    pingLabel.Font = Enum.Font.Gotham
    pingLabel.TextSize = 10
    pingLabel.TextColor3 = COLORS.text_secondary
    pingLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- Atualizar FPS e Ping
    local lastUpdate = 0
    RunService.Heartbeat:Connect(function()
        if tick() - lastUpdate > 0.5 then
            lastUpdate = tick()
            local fps = math.floor(1 / RunService.Heartbeat:Wait())
            fpsLabel.Text = "FPS: " .. fps

            local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
            pingLabel.Text = "Ping: " .. ping
        end
    end)

    -- Container de conteúdo
    local contentContainer = Instance.new("Frame", body)
    contentContainer.Size = UDim2.new(1, -110, 1, 0)
    contentContainer.Position = UDim2.fromOffset(110, 0)
    contentContainer.BackgroundTransparency = 1

    -- Sistema de tooltip
    local tooltip, tooltipLabel = create_tooltip(screenGui)

    local pages = {}
    local tabs = {}
    local activeTab = nil

    -- Função para criar abas
    local function create_tab(name, icon, order)
        local tab = Instance.new("TextButton")
        tab.Size = UDim2.new(1, 0, 0, 36)
        tab.BackgroundColor3 = COLORS.surface
        tab.Text = ""
        tab.LayoutOrder = order
        tab.Parent = tabContainer

        local tabCorner = Instance.new("UICorner", tab)
        tabCorner.CornerRadius = UDim.new(0, 8)

        local tabIcon = Instance.new("TextLabel", tab)
        tabIcon.Size = UDim2.fromOffset(20, 20)
        tabIcon.Position = UDim2.fromOffset(8, 8)
        tabIcon.BackgroundTransparency = 1
        tabIcon.Text = icon
        tabIcon.Font = Enum.Font.GothamBold
        tabIcon.TextSize = 14
        tabIcon.TextColor3 = COLORS.text_secondary

        local tabText = Instance.new("TextLabel", tab)
        tabText.Size = UDim2.new(1, -36, 1, 0)
        tabText.Position = UDim2.fromOffset(32, 0)
        tabText.BackgroundTransparency = 1
        tabText.Text = name
        tabText.Font = Enum.Font.GothamMedium
        tabText.TextSize = 11
        tabText.TextColor3 = COLORS.text_secondary
        tabText.TextXAlignment = Enum.TextXAlignment.Left

        local page = Instance.new("ScrollingFrame")
        page.Size = UDim2.new(1, -16, 1, -16)
        page.Position = UDim2.fromOffset(8, 8)
        page.BackgroundTransparency = 1
        page.BorderSizePixel = 0
        page.CanvasSize = UDim2.fromOffset(0, 0)
        page.ScrollBarThickness = 4
        page.ScrollBarImageColor3 = COLORS.primary
        page.Visible = false
        page.Parent = contentContainer

        local pageLayout = Instance.new("UIListLayout", page)
        pageLayout.Padding = UDim.new(0, 6)
        pageLayout.SortOrder = Enum.SortOrder.LayoutOrder

        pages[name] = page
        tabs[name] = {button = tab, icon = tabIcon, text = tabText}

        tab.MouseButton1Click:Connect(function()
            if activeTab == name then return end

            -- Desativar aba anterior
            if activeTab then
                local oldTab = tabs[activeTab]
                smooth_tween(oldTab.button, {BackgroundColor3 = COLORS.surface}):Play()
                smooth_tween(oldTab.icon, {TextColor3 = COLORS.text_secondary}):Play()
                smooth_tween(oldTab.text, {TextColor3 = COLORS.text_secondary}):Play()
                pages[activeTab].Visible = false
            end

            -- Ativar nova aba
            activeTab = name
            smooth_tween(tab, {BackgroundColor3 = COLORS.primary}):Play()
            smooth_tween(tabIcon, {TextColor3 = COLORS.text_primary}):Play()
            smooth_tween(tabText, {TextColor3 = COLORS.text_primary}):Play()
            page.Visible = true
        end)

        return page
    end

    -- Função para criar botões
    local function create_feature_button(parent, text, description, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 48)
        btn.BackgroundColor3 = COLORS.surface
        btn.Text = ""
        btn.Parent = parent

        local btnCorner = Instance.new("UICorner", btn)
        btnCorner.CornerRadius = UDim.new(0, 10)

        local btnStroke = Instance.new("UIStroke", btn)
        btnStroke.Color = COLORS.border
        btnStroke.Thickness = 1
        btnStroke.Transparency = 0.5

        local textLabel = Instance.new("TextLabel", btn)
        textLabel.Size = UDim2.new(1, -60, 0, 20)
        textLabel.Position = UDim2.fromOffset(16, 8)
        textLabel.BackgroundTransparency = 1
        textLabel.Text = text
        textLabel.Font = Enum.Font.GothamMedium
        textLabel.TextSize = 14
        textLabel.TextColor3 = COLORS.text_primary
        textLabel.TextXAlignment = Enum.TextXAlignment.Left

        local descLabel = Instance.new("TextLabel", btn)
        descLabel.Size = UDim2.new(1, -60, 0, 16)
        descLabel.Position = UDim2.fromOffset(16, 26)
        descLabel.BackgroundTransparency = 1
        descLabel.Text = description
        descLabel.Font = Enum.Font.Gotham
        descLabel.TextSize = 11
        descLabel.TextColor3 = COLORS.text_secondary
        descLabel.TextXAlignment = Enum.TextXAlignment.Left

        local indicator = Instance.new("Frame", btn)
        indicator.Size = UDim2.fromOffset(12, 12)
        indicator.Position = UDim2.new(1, -28, 0.5, -6)
        indicator.BackgroundColor3 = COLORS.error
        indicator.BorderSizePixel = 0

        local indicatorCorner = Instance.new("UICorner", indicator)
        indicatorCorner.CornerRadius = UDim.new(0, 6)

        -- Animações de hover
        local originalColor = COLORS.surface
        btn.MouseEnter:Connect(function()
            smooth_tween(btn, {BackgroundColor3 = COLORS.surface_light}):Play()
            tooltipLabel.Text = description
            tooltip.Visible = true
        end)

        btn.MouseLeave:Connect(function()
            smooth_tween(btn, {BackgroundColor3 = originalColor}):Play()
            tooltip.Visible = false
        end)

        -- Posicionar tooltip
        UserInputService.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement and tooltip.Visible then
                local mouse = UserInputService:GetMouseLocation()
                tooltip.Position = UDim2.fromOffset(mouse.X + 16, mouse.Y - 40)
            end
        end)

        btn.MouseButton1Click:Connect(function()
            local success, result = pcall(callback, btn, indicator, textLabel)
            if not success then
                warn("[FK7] Erro:", result)
                smooth_tween(indicator, {BackgroundColor3 = COLORS.warning}):Play()
                task.wait(1.5)
                smooth_tween(indicator, {BackgroundColor3 = COLORS.error}):Play()
            end
        end)

        return btn, indicator, textLabel
    end

    local function update_button_status(indicator, textLabel, enabled, originalText)
        if enabled then
            smooth_tween(indicator, {BackgroundColor3 = COLORS.success}):Play()
            textLabel.Text = originalText .. " (ON)"
        else
            smooth_tween(indicator, {BackgroundColor3 = COLORS.error}):Play()
            textLabel.Text = originalText
        end
    end

    -- Criar páginas/abas
    local movementPage = create_tab("Movimento", "🏃", 1)
    local combatPage = create_tab("Combate", "⚔️", 2)
    local visualPage = create_tab("Visual", "👁️", 3)

    -- Página Movimento
    create_feature_button(movementPage, "Fly", "Voe livremente pelo mapa", function(btn, indicator, label)
        if ctx.features.fly then
            local enabled = ctx.features.fly.toggle()
            update_button_status(indicator, label, enabled, "Fly")
        else
            error("Módulo fly não encontrado")
        end
    end)

    create_feature_button(movementPage, "Noclip", "Atravesse paredes e objetos sólidos", function(btn, indicator, label)
        if ctx.features.noclip then
            local enabled = ctx.features.noclip.toggle()
            update_button_status(indicator, label, enabled, "Noclip")
        else
            error("Módulo noclip não encontrado")
        end
    end)

    create_feature_button(movementPage, "Speed", "Aumente sua velocidade de movimento", function(btn, indicator, label)
        if ctx.features.speed then
            local enabled = ctx.features.speed.toggle()
            update_button_status(indicator, label, enabled, "Speed")
        else
            error("Módulo speed não encontrado")
        end
    end)

    create_feature_button(movementPage, "Infinite Jump", "Pule infinitas vezes no ar", function(btn, indicator, label)
        if ctx.features.infinitejump then
            local enabled = ctx.features.infinitejump.toggle()
            update_button_status(indicator, label, enabled, "Infinite Jump")
        else
            error("Módulo infinitejump não encontrado")
        end
    end)

    create_feature_button(movementPage, "Click TP", "Teleporte clicando no mapa", function(btn, indicator, label)
        if ctx.features.clicktp then
            local enabled = ctx.features.clicktp.toggle()
            update_button_status(indicator, label, enabled, "Click TP")
        else
            error("Módulo clicktp não encontrado")
        end
    end)

    -- Página Combate
    create_feature_button(combatPage, "God Mode", "Torna você imortal", function(btn, indicator, label)
        if ctx.features.godmode then
            local enabled = ctx.features.godmode.toggle()
            update_button_status(indicator, label, enabled, "God Mode")
        else
            error("Módulo godmode não encontrado")
        end
    end)

    -- Página Visual
    create_feature_button(visualPage, "Full Bright", "Ilumina completamente o ambiente", function(btn, indicator, label)
        if ctx.features.fullbright then
            local enabled = ctx.features.fullbright.toggle()
            update_button_status(indicator, label, enabled, "Full Bright")
        else
            error("Módulo fullbright não encontrado")
        end
    end)

    create_feature_button(visualPage, "ESP", "Mostra informações de outros jogadores", function(btn, indicator, label)
        if ctx.features.esp then
            local enabled = ctx.features.esp.toggle()
            update_button_status(indicator, label, enabled, "ESP")
        else
            error("Módulo esp não encontrado")
        end
    end)

    -- Atualizar tamanho do conteúdo das páginas
    for _, page in pairs(pages) do
        local layout = page:FindFirstChild("UIListLayout")
        if layout then
            layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                page.CanvasSize = UDim2.fromOffset(0, layout.AbsoluteContentSize.Y + 16)
            end)
            page.CanvasSize = UDim2.fromOffset(0, layout.AbsoluteContentSize.Y + 16)
        end
    end

    -- Ativar primeira aba por padrão
    tabs["Movimento"].button.MouseButton1Click:Invoke()

    -- Animação de entrada
    mainFrame.Size = UDim2.fromOffset(0, 0)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)

    local openTween = smooth_tween(mainFrame, {
        Size = UDim2.fromOffset(420, 520),
        Position = UDim2.new(0.5, -210, 0.5, -260)
    }, 0.6, Enum.EasingStyle.Back)
    openTween:Play()

    print("[FK7] Interface moderna carregada! ⚡")
end

return UI
]]
}

-- Carregar módulos incorporados
local loadingUI = create_loading_ui()
local total_modules = 0
for _ in pairs(embedded_modules) do
    total_modules = total_modules + 1
end

local loaded_count = 0
local function update_loading_progress(module_name)
    loaded_count = loaded_count + 1
    local progress = loaded_count / total_modules
    loadingUI.status.Text = "Carregando: " .. module_name .. ".lua"

    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(loadingUI.bar, tweenInfo, {Size = UDim2.new(progress, 0, 1, 0)}):Play()
end

-- Carregar Core primeiro
Modules.core = loadModule("core", embedded_modules.core)
update_loading_progress("core")

-- Carregar features
for name, source in pairs(embedded_modules) do
    if name ~= "core" and name ~= "ui" then
        Modules.features[name] = loadModule(name, source)
        update_loading_progress(name)
    end
end

-- Carregar UI
Modules.ui = loadModule("ui", embedded_modules.ui)
update_loading_progress("ui")

-- Inicializar sistema
if Modules.core then
    local Core = Modules.core
    Core.init()

    -- Registrar módulos no core
    for moduleName, module in pairs(Modules.features) do
        if module then
            Core.registerModule(moduleName, module)
        end
    end

    -- Inicializar UI
    if Modules.ui then
        Modules.ui.init({
            core = Core,
            features = Modules.features
        })
    end

    -- Animação de saída da tela de carregamento
    task.wait(0.5)
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(loadingUI.background, tweenInfo, {BackgroundTransparency = 1}):Play()
    TweenService:Create(loadingUI.container, tweenInfo, {BackgroundTransparency = 1}):Play()

    task.wait(0.5)
    if loadingUI.gui and loadingUI.gui.Parent then
        loadingUI.gui:Destroy()
    end

    print("🎉 FK7 Admin carregado com sucesso!")
    print("📋 Comandos disponíveis:")
    print("   • Fly - Voe livremente (WASD + Space/Ctrl)")
    print("   • Noclip - Atravessar paredes")
    print("   • Speed - Velocidade aumentada")
    print("   • Infinite Jump - Pulo infinito")
    print("   • Click TP - Teleporte ao clicar")
    print("   • God Mode - Imortal")
    print("   • Full Bright - Iluminação total")
    print("   • ESP - Ver jogadores")
else
    warn("[FK7] Erro: Core não pôde ser carregado!")
end