-- Loader com tela de carregamento: carrega módulos remotos ou locais e inicia UI

local TweenService = game:GetService("TweenService")

-- Tela de Carregamento
local function create_loading_ui()
    local playerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    if playerGui:FindFirstChild("FK7_Loading") then
        playerGui.FK7_Loading:Destroy()
    end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FK7_Loading"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = playerGui

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

local loadingUI = create_loading_ui()

local SOURCE = {
  core = "https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-RBX/main/modules/core.lua",
  ui   = "https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-RBX/main/modules/ui.lua",
  fly  = "https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-RBX/main/modules/fly.lua",
  noclip = "https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-RBX/main/modules/noclip.lua",
  speed = "https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-RBX/main/modules/speed.lua",
  teleport = "https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-RBX/main/modules/teleport.lua",
  godmode = "https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-RBX/main/modules/godmode.lua",
  infinitejump = "https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-RBX/main/modules/infinitejump.lua",
  fullbright = "https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-RBX/main/modules/fullbright.lua",
  nofalldamage = "https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-RBX/main/modules/nofalldamage.lua",
  xray = "https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-RBX/main/modules/xray.lua",
  esp = "https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-RBX/main/modules/esp.lua",
  lowgravity = "https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-RBX/main/modules/lowgravity.lua",
  instantrespawn = "https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-RBX/main/modules/instantrespawn.lua",
  clicktp = "https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-RBX/main/modules/clicktp.lua",
  autofarm = "https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-RBX/main/modules/autofarm.lua",
  walkthrough = "https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-RBX/main/modules/walkthrough.lua",
  autojump = "https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-RBX/main/modules/autojump.lua",
}

local function http_get(url)
  local bust = tostring(os.clock()):gsub("%.", "")
  local finalUrl = url .. "?t=" .. bust
  return game:HttpGet(finalUrl)
end

local modules_to_load = {"core", "ui", "fly", "noclip", "speed", "teleport", "godmode", "infinitejump", "fullbright", "nofalldamage", "xray", "esp", "lowgravity", "instantrespawn", "clicktp", "autofarm", "walkthrough", "autojump"}
local total_modules = #modules_to_load
local loaded_count = 0

local function update_loading_progress(module_name)
    loaded_count = loaded_count + 1
    local progress = loaded_count / total_modules
    loadingUI.status.Text = "Carregando: " .. module_name .. ".lua"
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(loadingUI.bar, tweenInfo, {Size = UDim2.new(progress, 0, 1, 0)})
    tween:Play()
end

local function load_module(name)
  -- Primeiro tentar carregar localmente (para desenvolvimento)
  local local_modules = {
    core = [[-- modules/core.lua - núcleo com gerenciamento de respawn
local Core = {}

-- Serviços
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local state = {}
local character_added_callbacks = {}
local modules_to_respawn = {}

function Core.init()
    state.player = Players.LocalPlayer
    state.mouse = state.player:GetMouse()

    local function on_char(character)
        if not character then return end
        state.character = character
        state.humanoid = character:WaitForChild("Humanoid")
        state.hrp = character:WaitForChild("HumanoidRootPart")

        -- Dispara callbacks
        for _, callback in ipairs(character_added_callbacks) do
            pcall(callback)
        end
        
        -- Reativa módulos que estavam ativos
        for module_name, was_enabled in pairs(modules_to_respawn) do
            if was_enabled and _G.FK7 and _G.FK7.Features and _G.FK7.Features[module_name] then
                task.wait(0.5) -- Aguarda character estabilizar
                pcall(function()
                    if not _G.FK7.Features[module_name].enabled then
                        _G.FK7.Features[module_name].toggle()
                    end
                end)
            end
        end
    end

    state.player.CharacterAdded:Connect(on_char)
    if state.player.Character then
        on_char(state.player.Character)
    end
end

function Core.registerForRespawn(module_name, is_enabled)
    modules_to_respawn[module_name] = is_enabled
end

function Core.shutdown()
    -- Desativar todos os módulos ativos
    if _G.FK7 and _G.FK7.Features then
        for module_name, module in pairs(_G.FK7.Features) do
            if module and module.enabled and module.disable then
                pcall(module.disable)
            end
        end
    end
    
    -- Limpar todas as conexões
    Core.cleanup()
    
    -- Limpar variáveis globais
    if _G.FK7 then
        _G.FK7 = nil
    end
    
    -- Restaurar configurações do workspace se alteradas
    pcall(function()
        workspace.Gravity = 196.2 -- Gravidade padrão
    end)
    
    print("[FK7] Script encerrado e módulos desativados")
end

function Core.onCharacterAdded(callback)
    table.insert(character_added_callbacks, callback)
end

function Core.state()
  return state
end

function Core.services()
  return { Players = Players, UserInputService = UserInputService, RunService = RunService }
end

local connections = {}
function Core.connect(key, conn)
  if connections[key] then pcall(function() connections[key]:Disconnect() end) end
  connections[key] = conn
end
function Core.disconnect(key)
  if connections[key] then pcall(function() connections[key]:Disconnect() end); connections[key]=nil end
end
function Core.cleanup()
  for k,c in pairs(connections) do pcall(function() c:Disconnect() end) end
  table.clear(connections)
end

Core.init()
return Core]],
    ui = [[-- modules/ui.lua - Interface Premium FK7 Admin
local UI = {}
local TweenService = game:GetService("TweenService")

-- Animações e efeitos visuais
local function animate_button_hover(button, hoverColor, originalColor)
    button.MouseEnter:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            BackgroundColor3 = hoverColor,
            Size = UDim2.new(1, 0, 0, 38)
        })
        tween:Play()
    end)
    
    button.MouseLeave:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            BackgroundColor3 = originalColor,
            Size = UDim2.new(1, 0, 0, 35)
        })
        tween:Play()
    end)
end

local function pulse_effect(element, color)
    local pulse = TweenService:Create(element, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
        BackgroundColor3 = color
    })
    return pulse
end

-- Função para criar interface arrastável com animação
local function create_draggable(gui)
    local is_dragging = false
    local drag_start
    local frame_start
    local original_transparency = gui.BackgroundTransparency

    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            is_dragging = true
            drag_start = input.Position
            frame_start = gui.Parent.Position
            
            -- Efeito visual ao começar a arrastar
            local tween = TweenService:Create(gui, TweenInfo.new(0.2), {
                BackgroundTransparency = 0.1
            })
            tween:Play()
        end
    end)

    gui.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            is_dragging = false
            
            -- Restaurar transparência
            local tween = TweenService:Create(gui, TweenInfo.new(0.2), {
                BackgroundTransparency = original_transparency
            })
            tween:Play()
        end
    end)

    gui.InputChanged:Connect(function(input)
        if is_dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - drag_start
            gui.Parent.Position = UDim2.new(frame_start.X.Scale, frame_start.X.Offset + delta.X, frame_start.Y.Scale, frame_start.Y.Offset + delta.Y)
        end
    end)
end

-- Criar separador visual
local function create_separator(parent, text)
    local separator = Instance.new("Frame")
    separator.Size = UDim2.new(1, 0, 0, 30)
    separator.BackgroundTransparency = 1
    separator.Parent = parent
    
    local line1 = Instance.new("Frame", separator)
    line1.Size = UDim2.new(0.3, 0, 0, 2)
    line1.Position = UDim2.new(0, 0, 0.5, -1)
    line1.BackgroundColor3 = Color3.fromRGB(60, 120, 220)
    line1.BorderSizePixel = 0
    Instance.new("UICorner", line1).CornerRadius = UDim.new(0, 1)
    
    local label = Instance.new("TextLabel", separator)
    label.Size = UDim2.new(0.4, 0, 1, 0)
    label.Position = UDim2.new(0.3, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.Font = Enum.Font.GothamBold
    label.TextSize = 12
    label.TextColor3 = Color3.fromRGB(150, 150, 150)
    label.TextXAlignment = Enum.TextXAlignment.Center
    
    local line2 = Instance.new("Frame", separator)
    line2.Size = UDim2.new(0.3, 0, 0, 2)
    line2.Position = UDim2.new(0.7, 0, 0.5, -1)
    line2.BackgroundColor3 = Color3.fromRGB(60, 120, 220)
    line2.BorderSizePixel = 0
    Instance.new("UICorner", line2).CornerRadius = UDim.new(0, 1)
    
    return separator
end

function UI.init(ctx)
    local Core = ctx.core
    local st = Core.state()
    local playerGui = st.player:WaitForChild("PlayerGui")

    -- Remover GUI antiga se existir
    if playerGui:FindFirstChild("FK7_GUI") then
        playerGui.FK7_GUI:Destroy()
    end

    local gui = Instance.new("ScreenGui")
    gui.Name = "FK7_GUI"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = playerGui

    -- Fundo blur (efeito de profundidade)
    local blurFrame = Instance.new("Frame")
    blurFrame.Size = UDim2.new(0, 340, 0, 520)
    blurFrame.Position = UDim2.new(0, 40, 0.5, -260)
    blurFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    blurFrame.BackgroundTransparency = 0.8
    blurFrame.BorderSizePixel = 0
    blurFrame.Parent = gui
    Instance.new("UICorner", blurFrame).CornerRadius = UDim.new(0, 16)

    -- Frame principal com glassmorphism
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 350, 0, 530)
    mainFrame.Position = UDim2.new(0, 35, 0.5, -265)
    mainFrame.BackgroundColor3 = Color3.fromRGB(15, 18, 25)
    mainFrame.BackgroundTransparency = 0.1
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = gui

    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 18)
    
    -- Borda com gradiente animado
    local stroke = Instance.new("UIStroke", mainFrame)
    stroke.Color = Color3.fromRGB(100, 180, 255)
    stroke.Thickness = 3
    stroke.Transparency = 0.2
    
    -- Gradiente principal
    local mainGradient = Instance.new("UIGradient", mainFrame)
    mainGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 30, 45)),
        ColorSequenceKeypoint.new(0.3, Color3.fromRGB(20, 25, 35)),
        ColorSequenceKeypoint.new(0.7, Color3.fromRGB(15, 20, 30)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 15, 25))
    }
    mainGradient.Rotation = 135

    -- Efeito de brilho no topo
    local glowEffect = Instance.new("Frame", mainFrame)
    glowEffect.Size = UDim2.new(1, 0, 0, 100)
    glowEffect.Position = UDim2.new(0, 0, 0, 0)
    glowEffect.BackgroundTransparency = 0.9
    glowEffect.BorderSizePixel = 0
    glowEffect.ZIndex = mainFrame.ZIndex + 1
    
    local glowGradient = Instance.new("UIGradient", glowEffect)
    glowGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 180, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 18, 25))
    }
    glowGradient.Rotation = 90
    Instance.new("UICorner", glowEffect).CornerRadius = UDim.new(0, 18)

    -- Cabeçalho premium
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 60)
    header.BackgroundColor3 = Color3.fromRGB(20, 25, 40)
    header.BackgroundTransparency = 0.3
    header.BorderSizePixel = 0
    header.Parent = mainFrame
    header.ZIndex = mainFrame.ZIndex + 2
    create_draggable(header)

    Instance.new("UICorner", header).CornerRadius = UDim.new(0, 18)

    local headerGradient = Instance.new("UIGradient", header)
    headerGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 140, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(60, 120, 200)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 80, 160))
    }
    headerGradient.Rotation = 45

    -- Logo e título melhorados
    local logoIcon = Instance.new("TextLabel", header)
    logoIcon.Size = UDim2.new(0, 40, 0, 40)
    logoIcon.Position = UDim2.new(0, 15, 0.5, -20)
    logoIcon.BackgroundTransparency = 1
    logoIcon.Text = "🚀"
    logoIcon.Font = Enum.Font.GothamBold
    logoIcon.TextSize = 24
    logoIcon.TextColor3 = Color3.new(1, 1, 1)

    local title = Instance.new("TextLabel", header)
    title.Size = UDim2.new(1, -150, 1, 0)
    title.Position = UDim2.new(0, 60, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "FK7 ADMIN"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 22
    title.TextColor3 = Color3.new(1, 1, 1)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextStrokeTransparency = 0.5
    title.TextStrokeColor3 = Color3.new(0, 0, 0)

    local subtitle = Instance.new("TextLabel", header)
    subtitle.Size = UDim2.new(1, -150, 0, 15)
    subtitle.Position = UDim2.new(0, 60, 1, -18)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "Premium Edition v2.0"
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextSize = 10
    subtitle.TextColor3 = Color3.fromRGB(200, 220, 255)
    subtitle.TextXAlignment = Enum.TextXAlignment.Left
    subtitle.TextTransparency = 0.3

    -- Botões de controle melhorados
    local minimizeButton = Instance.new("TextButton", header)
    minimizeButton.Size = UDim2.new(0, 30, 0, 30)
    minimizeButton.Position = UDim2.new(1, -75, 0.5, -15)
    minimizeButton.BackgroundColor3 = Color3.fromRGB(255, 193, 7)
    minimizeButton.Text = "—"
    minimizeButton.Font = Enum.Font.GothamBold
    minimizeButton.TextSize = 14
    minimizeButton.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", minimizeButton).CornerRadius = UDim.new(0, 6)

    local closeButton = Instance.new("TextButton", header)
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -38, 0.5, -15)
    closeButton.BackgroundColor3 = Color3.fromRGB(220, 53, 69)
    closeButton.Text = "✕"
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextSize = 14
    closeButton.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", closeButton).CornerRadius = UDim.new(0, 6)

    -- Animação dos botões de controle
    animate_button_hover(minimizeButton, Color3.fromRGB(255, 213, 47), Color3.fromRGB(255, 193, 7))
    animate_button_hover(closeButton, Color3.fromRGB(240, 73, 89), Color3.fromRGB(220, 53, 69))

    closeButton.MouseButton1Click:Connect(function()
        -- Animação de saída
        local closeTween = TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BackgroundTransparency = 1
        })
        closeTween:Play()
        
        closeTween.Completed:Connect(function()
            if ctx.core and ctx.core.shutdown then
                ctx.core.shutdown()
            end
            gui:Destroy()
        end)
    end)

    -- Container de conteúdo com scroll customizado
    local content = Instance.new("ScrollingFrame", mainFrame)
    content.Size = UDim2.new(1, -20, 1, -80)
    content.Position = UDim2.new(0, 10, 0, 70)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.CanvasSize = UDim2.new(0, 0, 0, 0)
    content.ScrollBarThickness = 6
    content.ScrollBarImageColor3 = Color3.fromRGB(100, 180, 255)
    content.ScrollBarImageTransparency = 0.2
    content.ScrollingDirection = Enum.ScrollingDirection.Y
    content.ZIndex = mainFrame.ZIndex + 1
    
    -- Layout com padding melhorado
    local layout = Instance.new("UIListLayout", content)
    layout.Padding = UDim.new(0, 6)
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    -- Padding interno
    local padding = Instance.new("UIPadding", content)
    padding.PaddingLeft = UDim.new(0, 5)
    padding.PaddingRight = UDim.new(0, 5)
    padding.PaddingTop = UDim.new(0, 10)
    padding.PaddingBottom = UDim.new(0, 10)

    -- Função para criar botões premium
    local function create_button(text, callback, category)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 40)
        btn.BackgroundColor3 = Color3.fromRGB(30, 35, 50)
        btn.Text = ""
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 14
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Parent = content
        btn.ZIndex = content.ZIndex + 1

        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
        
        local btnStroke = Instance.new("UIStroke", btn)
        btnStroke.Color = Color3.fromRGB(60, 70, 90)
        btnStroke.Thickness = 1
        btnStroke.Transparency = 0.5

        -- Gradiente do botão
        local btnGradient = Instance.new("UIGradient", btn)
        btnGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 40, 55)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 30, 45))
        }
        btnGradient.Rotation = 90

        -- Label do texto
        local textLabel = Instance.new("TextLabel", btn)
        textLabel.Size = UDim2.new(1, -50, 1, 0)
        textLabel.Position = UDim2.new(0, 45, 0, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.Text = text
        textLabel.Font = Enum.Font.GothamSemibold
        textLabel.TextSize = 14
        textLabel.TextColor3 = Color3.new(1, 1, 1)
        textLabel.TextXAlignment = Enum.TextXAlignment.Left
        textLabel.ZIndex = btn.ZIndex + 1

        -- Status indicator
        local indicator = Instance.new("Frame", btn)
        indicator.Size = UDim2.new(0, 6, 0, 6)
        indicator.Position = UDim2.new(1, -20, 0.5, -3)
        indicator.BackgroundColor3 = Color3.fromRGB(220, 53, 69)
        indicator.BorderSizePixel = 0
        indicator.ZIndex = btn.ZIndex + 1
        Instance.new("UICorner", indicator).CornerRadius = UDim.new(0, 3)

        -- Ícone categorial
        local icon = Instance.new("TextLabel", btn)
        icon.Size = UDim2.new(0, 30, 0, 30)
        icon.Position = UDim2.new(0, 8, 0.5, -15)
        icon.BackgroundTransparency = 1
        icon.Text = text:match("^[^%s]+") -- Pega o primeiro emoji
        icon.Font = Enum.Font.GothamBold
        icon.TextSize = 16
        icon.TextColor3 = Color3.new(1, 1, 1)
        icon.ZIndex = btn.ZIndex + 1

        -- Animações do botão
        animate_button_hover(btn, Color3.fromRGB(45, 50, 70), Color3.fromRGB(30, 35, 50))

        -- Efeito de clique
        btn.MouseButton1Click:Connect(function()
            local clickEffect = TweenService:Create(btn, TweenInfo.new(0.1), {
                Size = UDim2.new(1, -4, 0, 36)
            })
            clickEffect:Play()
            
            clickEffect.Completed:Connect(function()
                local returnEffect = TweenService:Create(btn, TweenInfo.new(0.1), {
                    Size = UDim2.new(1, 0, 0, 40)
                })
                returnEffect:Play()
            end)
            
            callback(btn, indicator, textLabel)
        end)

        return btn, indicator, textLabel
    end

    -- Função para atualizar status do botão
    local function update_button_status(button, indicator, textLabel, enabled, originalText)
        if enabled then
            textLabel.Text = originalText .. " (ON)"
            indicator.BackgroundColor3 = Color3.fromRGB(40, 167, 69)
            button.BackgroundColor3 = Color3.fromRGB(25, 60, 35)
            
            -- Efeito de pulso para botões ativos
            local pulse = pulse_effect(indicator, Color3.fromRGB(60, 200, 90))
            pulse:Play()
        else
            textLabel.Text = originalText .. " (OFF)"
            indicator.BackgroundColor3 = Color3.fromRGB(220, 53, 69)
            button.BackgroundColor3 = Color3.fromRGB(30, 35, 50)
        end
    end

    -- Categorias de recursos
    create_separator(content, "MOVEMENT")

    create_button("✈️ Voo Avançado", function(btn, indicator, textLabel)
        local enabled = ctx.features.fly.toggle()
        update_button_status(btn, indicator, textLabel, enabled, "✈️ Voo Avançado")
    end)

    create_button("👻 Noclip", function(btn, indicator, textLabel)
        local enabled = ctx.features.noclip.toggle()
        update_button_status(btn, indicator, textLabel, enabled, "👻 Noclip")
    end)

    create_button("⚡ Velocidade", function(btn, indicator, textLabel)
        local enabled = ctx.features.speed.toggle()
        update_button_status(btn, indicator, textLabel, enabled, "⚡ Velocidade")
    end)

    create_button("👟 Pulo Infinito", function(btn, indicator, textLabel)
        local enabled = ctx.features.infinitejump.toggle()
        update_button_status(btn, indicator, textLabel, enabled, "👟 Pulo Infinito")
    end)

    create_separator(content, "TELEPORT")

    create_button("🎯 Click Teleport", function(btn, indicator, textLabel)
        local enabled = ctx.features.teleport.toggle()
        update_button_status(btn, indicator, textLabel, enabled, "🎯 Click Teleport")
    end)

    create_button("🌟 TP Profissional", function(btn, indicator, textLabel)
        local enabled = ctx.features.clicktp.toggle()
        update_button_status(btn, indicator, textLabel, enabled, "🌟 TP Profissional")
    end)

    create_separator(content, "COMBAT")

    create_button("❤️ Modo Deus", function(btn, indicator, textLabel)
        local enabled = ctx.features.godmode.toggle()
        update_button_status(btn, indicator, textLabel, enabled, "❤️ Modo Deus")
    end)

    create_button("🛡️ Sem Dano de Queda", function(btn, indicator, textLabel)
        local enabled = ctx.features.nofalldamage.toggle()
        update_button_status(btn, indicator, textLabel, enabled, "🛡️ Sem Dano de Queda")
    end)

    create_separator(content, "VISUAL")

    create_button("💡 Luz Máxima", function(btn, indicator, textLabel)
        local enabled = ctx.features.fullbright.toggle()
        update_button_status(btn, indicator, textLabel, enabled, "💡 Luz Máxima")
    end)

    create_button("👁️ Visão de Raio-X", function(btn, indicator, textLabel)
        local enabled = ctx.features.xray.toggle()
        update_button_status(btn, indicator, textLabel, enabled, "👁️ Visão de Raio-X")
    end)

    create_button("📡 ESP Players", function(btn, indicator, textLabel)
        local enabled = ctx.features.esp.toggle()
        update_button_status(btn, indicator, textLabel, enabled, "📡 ESP Players")
    end)

    create_separator(content, "WORLD")

    create_button("🪐 Gravidade Baixa", function(btn, indicator, textLabel)
        local enabled = ctx.features.lowgravity.toggle()
        update_button_status(btn, indicator, textLabel, enabled, "🪐 Gravidade Baixa")
    end)

    create_button("🚪 Atravessar Paredes", function(btn, indicator, textLabel)
        local enabled = ctx.features.walkthrough.toggle()
        update_button_status(btn, indicator, textLabel, enabled, "🚪 Atravessar Paredes")
    end)

    create_separator(content, "AUTOMATION")

    create_button("💰 Farm Automático", function(btn, indicator, textLabel)
        local enabled = ctx.features.autofarm.toggle()
        update_button_status(btn, indicator, textLabel, enabled, "💰 Farm Automático")
    end)

    create_button("🦘 Pulo Automático", function(btn, indicator, textLabel)
        local enabled = ctx.features.autojump.toggle()
        update_button_status(btn, indicator, textLabel, enabled, "🦘 Pulo Automático")
    end)

    create_button("⚡ Respawn Instantâneo", function(btn, indicator, textLabel)
        local enabled = ctx.features.instantrespawn.toggle()
        update_button_status(btn, indicator, textLabel, enabled, "⚡ Respawn Instantâneo")
    end)

    -- Atualizar CanvasSize dinamicamente
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        content.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
    end)
    
    -- Atualização inicial
    content.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)

    -- Animação de entrada
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    mainFrame.BackgroundTransparency = 1
    
    local openTween = TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 350, 0, 530),
        Position = UDim2.new(0, 35, 0.5, -265),
        BackgroundTransparency = 0.1
    })
    openTween:Play()
    
    print("[FK7] Interface Premium carregada com sucesso! 🚀")
end

return UI]],
    fly = [[-- modules/fly.lua - voo básico mínimo
local Fly = { enabled = false }

function Fly.setup(Core)
    Fly.Core = Core
    Fly.bv = Instance.new("BodyVelocity")
    Fly.bv.MaxForce = Vector3.new(4e5, 4e5, 4e5)
    Fly.bv.Velocity = Vector3.new()
    Fly.bg = Instance.new("BodyGyro")
    Fly.bg.MaxTorque = Vector3.new(4e5, 4e5, 4e5)
    Fly.bg.P = 3000
    Fly.bg.D = 500

    Core.onCharacterAdded(function()
        if Fly.enabled then
            local st = Core.state()
            Fly.bv.Parent = st.hrp
            Fly.bg.Parent = st.hrp
        end
    end)
end

function Fly.toggle()
  local st = Fly.Core.state()
  Fly.enabled = not Fly.enabled
  if Fly.enabled then
    Fly.bv.Parent = st.hrp; Fly.bg.Parent = st.hrp
    Fly.Core.connect("fly_loop", Fly.Core.services().RunService.RenderStepped:Connect(function()
      if not Fly.enabled then Fly.Core.disconnect("fly_loop"); return end
      local uis = Fly.Core.services().UserInputService
      local dir = Vector3.new()
      if uis:IsKeyDown(Enum.KeyCode.W) then dir += st.hrp.CFrame.LookVector end
      if uis:IsKeyDown(Enum.KeyCode.S) then dir -= st.hrp.CFrame.LookVector end
      if uis:IsKeyDown(Enum.KeyCode.A) then dir -= st.hrp.CFrame.RightVector end
      if uis:IsKeyDown(Enum.KeyCode.D) then dir += st.hrp.CFrame.RightVector end
      if uis:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
      if uis:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.new(0,1,0) end
      Fly.bv.Velocity = dir.Magnitude > 0 and dir.Unit * 60 or Vector3.new()
      Fly.bg.CFrame = CFrame.new(st.hrp.Position, st.hrp.Position + st.mouse.Hit.LookVector)
    end))
  else
    Fly.Core.disconnect("fly_loop"); Fly.bv.Parent = nil; Fly.bg.Parent = nil
  end
  return Fly.enabled
end

function Fly.disable()
  if Fly.enabled then Fly.enabled=false; Fly.Core.disconnect("fly_loop"); Fly.bv.Parent=nil; Fly.bg.Parent=nil end
end

return Fly]]
  }
  
  if local_modules[name] then
    local chunk = loadstring(local_modules[name])
    if chunk then
      local ok, mod = pcall(chunk)
      if ok and mod then
        update_loading_progress(name)
        return mod
      end
    end
  end
  
  -- Fallback para URLs remotas
  local url = SOURCE[name]
  if url and url ~= "" then
    local ok, src = pcall(http_get, url)
    if ok and src and src ~= "" then
      local chunk, err = loadstring(src)
      if chunk then
        local ok2, mod = pcall(chunk)
        if ok2 and mod then
            update_loading_progress(name)
            return mod
        end
        warn("[FK7] Erro executando módulo", name, mod)
      else
        warn("[FK7] Erro compilando módulo", name, err)
      end
    else
      warn("[FK7] Falha HttpGet módulo", name, src)
    end
  end
  
  error("[FK7] Não foi possível carregar módulo: "..name)
end

local env = getgenv and getgenv() or _G
env.FK7 = env.FK7 or {}

-- Carregamento dos módulos
local Core = load_module("core")
env.FK7.Core = Core

local UI = load_module("ui")
local Features = {
  fly = load_module("fly"),
  noclip = load_module("noclip"),
  speed = load_module("speed"),
  teleport = load_module("teleport"),
  godmode = load_module("godmode"),
  infinitejump = load_module("infinitejump"),
  fullbright = load_module("fullbright"),
  nofalldamage = load_module("nofalldamage"),
  xray = load_module("xray"),
  esp = load_module("esp"),
  lowgravity = load_module("lowgravity"),
  instantrespawn = load_module("instantrespawn"),
  clicktp = load_module("clicktp"),
  autofarm = load_module("autofarm"),
  walkthrough = load_module("walkthrough"),
  autojump = load_module("autojump"),
}
env.FK7.Features = Features

-- Setup dos módulos que precisam do Core
loadingUI.status.Text = "Configurando módulos..."
pcall(function()
    for _, feature in pairs(Features) do
        if feature.setup then
            feature.setup(Core)
        end
    end
end)

-- Finaliza a UI
loadingUI.status.Text = "Finalizando interface..."
task.wait(0.5)
UI.init({ core = Core, features = Features })

-- Animação de saída da tela de carregamento
local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- Animar o fundo da tela
local backgroundTween = TweenService:Create(loadingUI.background, tweenInfo, {BackgroundTransparency = 1})
backgroundTween:Play()

-- Animar o container principal
local containerTween = TweenService:Create(loadingUI.container, tweenInfo, {BackgroundTransparency = 1})
containerTween:Play()

-- Animar todos os elementos filhos
for _, child in ipairs(loadingUI.container:GetChildren()) do
    if child:IsA("TextLabel") or child:IsA("TextButton") then
        -- Para elementos de texto
        local childTween = TweenService:Create(child, tweenInfo, {
            TextTransparency = 1, 
            BackgroundTransparency = 1
        })
        childTween:Play()
    elseif child:IsA("Frame") then
        -- Para frames (como a barra de progresso)
        local childTween = TweenService:Create(child, tweenInfo, {
            BackgroundTransparency = 1
        })
        childTween:Play()
    elseif child:IsA("GuiObject") then
        -- Para outros elementos GUI
        local childTween = TweenService:Create(child, tweenInfo, {
            BackgroundTransparency = 1
        })
        childTween:Play()
    end
end

-- Aguardar a animação terminar e destruir a GUI completamente
containerTween.Completed:Wait()
if loadingUI.gui and loadingUI.gui.Parent then
    loadingUI.gui:Destroy()
end

print("[FK7] Loader pronto")
