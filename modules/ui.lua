-- modules/ui.lua - Interface Moderna FK7 Admin-- modules/ui.lua - Interface Moderna FK7 Admin v3.0

local UI = {}local UI = {}

local TweenService = game:GetService("TweenService")local TweenService = game:GetService("TweenService")

local UserInputService = game:GetService("UserInputService")local UserInputService = game:GetService("UserInputService")

local RunService = game:GetService("RunService")local RunService = game:GetService("RunService")



-- Cores do tema-- Cores do tema moderno

local COLORS = {local COLORS = {

    background = Color3.fromRGB(24, 25, 28),    background = Color3.fromRGB(24, 25, 28),

    surface = Color3.fromRGB(32, 34, 37),    surface = Color3.fromRGB(32, 34, 37),

    surface_light = Color3.fromRGB(40, 42, 46),    surface_light = Color3.fromRGB(40, 42, 46),

    primary = Color3.fromRGB(88, 166, 255),    primary = Color3.fromRGB(88, 166, 255),

    primary_dark = Color3.fromRGB(70, 140, 220),    primary_dark = Color3.fromRGB(70, 140, 220),

    success = Color3.fromRGB(76, 175, 80),    success = Color3.fromRGB(76, 175, 80),

    error = Color3.fromRGB(244, 67, 54),    error = Color3.fromRGB(244, 67, 54),

    warning = Color3.fromRGB(255, 193, 7),    warning = Color3.fromRGB(255, 193, 7),

    text_primary = Color3.fromRGB(255, 255, 255),    text_primary = Color3.fromRGB(255, 255, 255),

    text_secondary = Color3.fromRGB(158, 158, 158),    text_secondary = Color3.fromRGB(158, 158, 158),

    border = Color3.fromRGB(60, 63, 65)    border = Color3.fromRGB(60, 63, 65)

}}



-- Animações suaves-- Função para animações suaves

local function smooth_tween(object, properties, duration, style)local function smooth_tween(object, properties, duration, style)

    duration = duration or 0.3    duration = duration or 0.3

    style = style or Enum.EasingStyle.Quart    style = style or Enum.EasingStyle.Quart

    return TweenService:Create(object, TweenInfo.new(duration, style), properties)    return TweenService:Create(object, TweenInfo.new(duration, style), properties)

endend



-- Sistema de arrastar-- Animações e efeitos visuais modernos

local function make_draggable(frame, dragHandle)local function animate_button_hover(button, hoverColor, originalColor)

    local isDragging = false    button.MouseEnter:Connect(function()

    local dragStart, startPos        smooth_tween(button, {BackgroundColor3 = hoverColor}):Play()

    end)

    dragHandle = dragHandle or frame    

    button.MouseLeave:Connect(function()

    dragHandle.InputBegan:Connect(function(input)        smooth_tween(button, {BackgroundColor3 = originalColor}):Play()

        if input.UserInputType == Enum.UserInputType.MouseButton1 then    end)

            isDragging = trueend

            dragStart = input.Position

            startPos = frame.Position-- Sistema de arrastar melhorado

local function make_draggable(frame, dragHandle)

            smooth_tween(frame, {Size = frame.Size + UDim2.fromOffset(4, 4)}):Play()    local isDragging = false

        end    local dragStart, startPos

    end)    

    dragHandle = dragHandle or frame

    dragHandle.InputEnded:Connect(function(input)    

        if input.UserInputType == Enum.UserInputType.MouseButton1 then    dragHandle.InputBegan:Connect(function(input)

            isDragging = false        if input.UserInputType == Enum.UserInputType.MouseButton1 then

            smooth_tween(frame, {Size = frame.Size - UDim2.fromOffset(4, 4)}):Play()            isDragging = true

        end            dragStart = input.Position

    end)            startPos = frame.Position

            

    UserInputService.InputChanged:Connect(function(input)            smooth_tween(frame, {Size = frame.Size + UDim2.fromOffset(4, 4)}):Play()

        if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then        end

            local delta = input.Position - dragStart    end)

            frame.Position = UDim2.fromOffset(    

                startPos.X.Offset + delta.X,    dragHandle.InputEnded:Connect(function(input)

                startPos.Y.Offset + delta.Y        if input.UserInputType == Enum.UserInputType.MouseButton1 then

            )            isDragging = false

        end            smooth_tween(frame, {Size = frame.Size - UDim2.fromOffset(4, 4)}):Play()

    end)        end

end    end)

    

-- Criar tooltip    UserInputService.InputChanged:Connect(function(input)

local function create_tooltip(parent)        if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then

    local tooltip = Instance.new("Frame")            local delta = input.Position - dragStart

    tooltip.Name = "Tooltip"            frame.Position = UDim2.fromOffset(

    tooltip.Size = UDim2.fromOffset(200, 35)                startPos.X.Offset + delta.X,

    tooltip.BackgroundColor3 = COLORS.surface                startPos.Y.Offset + delta.Y

    tooltip.BorderSizePixel = 0            )

    tooltip.ZIndex = 1000        end

    tooltip.Visible = false    end)

    tooltip.Parent = parentend



    local corner = Instance.new("UICorner", tooltip)-- Criar tooltip moderno

    corner.CornerRadius = UDim.new(0, 8)local function create_tooltip(parent)

    local tooltip = Instance.new("Frame")

    local stroke = Instance.new("UIStroke", tooltip)    tooltip.Name = "Tooltip"

    stroke.Color = COLORS.border    tooltip.Size = UDim2.fromOffset(200, 35)

    stroke.Thickness = 1    tooltip.BackgroundColor3 = COLORS.surface

    tooltip.BorderSizePixel = 0

    local label = Instance.new("TextLabel", tooltip)    tooltip.ZIndex = 1000

    label.Size = UDim2.new(1, -16, 1, 0)    tooltip.Visible = false

    label.Position = UDim2.fromOffset(8, 0)    tooltip.Parent = parent

    label.BackgroundTransparency = 1    

    label.Font = Enum.Font.GothamMedium    local corner = Instance.new("UICorner", tooltip)

    label.TextSize = 13    corner.CornerRadius = UDim.new(0, 8)

    label.TextColor3 = COLORS.text_primary    

    label.TextXAlignment = Enum.TextXAlignment.Left    local stroke = Instance.new("UIStroke", tooltip)

    stroke.Color = COLORS.border

    return tooltip, label    stroke.Thickness = 1

end    

    local label = Instance.new("TextLabel", tooltip)

function UI.init(ctx)    label.Size = UDim2.new(1, -16, 1, 0)

    local Core = ctx.core    label.Position = UDim2.fromOffset(8, 0)

    local st = Core.state()    label.BackgroundTransparency = 1

    local playerGui = st.player:WaitForChild("PlayerGui")    label.Font = Enum.Font.GothamMedium

    label.TextSize = 13

    -- Remover GUI antiga    label.TextColor3 = COLORS.text_primary

    if playerGui:FindFirstChild("FK7_GUI") then    label.TextXAlignment = Enum.TextXAlignment.Left

        playerGui.FK7_GUI:Destroy()    

    end    return tooltip, label

end

    local screenGui = Instance.new("ScreenGui")

    screenGui.Name = "FK7_GUI"function UI.init(ctx)

    screenGui.ResetOnSpawn = false    local Core = ctx.core

    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling    local st = Core.state()

    screenGui.Parent = playerGui    local playerGui = st.player:WaitForChild("PlayerGui")



    -- Frame principal    -- Remover GUI antiga

    local mainFrame = Instance.new("Frame")    if playerGui:FindFirstChild("FK7_GUI") then

    mainFrame.Size = UDim2.fromOffset(420, 520)        playerGui.FK7_GUI:Destroy()

    mainFrame.Position = UDim2.new(0.5, -210, 0.5, -260)    end

    mainFrame.BackgroundColor3 = COLORS.background

    mainFrame.BorderSizePixel = 0    local screenGui = Instance.new("ScreenGui")

    mainFrame.Parent = screenGui    screenGui.Name = "FK7_GUI"

    screenGui.ResetOnSpawn = false

    local mainCorner = Instance.new("UICorner", mainFrame)    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    mainCorner.CornerRadius = UDim.new(0, 16)    screenGui.Parent = playerGui



    local mainStroke = Instance.new("UIStroke", mainFrame)    -- Frame principal moderno

    mainStroke.Color = COLORS.border    local mainFrame = Instance.new("Frame")

    mainStroke.Thickness = 1    mainFrame.Size = UDim2.fromOffset(420, 520)

    mainFrame.Position = UDim2.new(0.5, -210, 0.5, -260)

    -- Cabeçalho    mainFrame.BackgroundColor3 = COLORS.background

    local header = Instance.new("Frame", mainFrame)    mainFrame.BorderSizePixel = 0

    header.Size = UDim2.new(1, 0, 0, 50)    mainFrame.Parent = screenGui

    header.BackgroundColor3 = COLORS.surface    

    header.BorderSizePixel = 0    local mainCorner = Instance.new("UICorner", mainFrame)

    mainCorner.CornerRadius = UDim.new(0, 16)

    local headerCorner = Instance.new("UICorner", header)    

    headerCorner.CornerRadius = UDim.new(0, 16)    local mainStroke = Instance.new("UIStroke", mainFrame)

    mainStroke.Color = COLORS.border

    make_draggable(mainFrame, header)    mainStroke.Thickness = 1

    

    -- Logo e título    -- Sombra sutil

    local logoIcon = Instance.new("TextLabel", header)    local shadow = Instance.new("ImageLabel", screenGui)

    logoIcon.Size = UDim2.fromOffset(32, 32)    shadow.Size = mainFrame.Size + UDim2.fromOffset(40, 40)

    logoIcon.Position = UDim2.fromOffset(16, 9)    shadow.Position = mainFrame.Position - UDim2.fromOffset(20, 20)

    logoIcon.BackgroundTransparency = 1    shadow.BackgroundTransparency = 1

    logoIcon.Text = "⚡"    shadow.Image = "rbxassetid://8560915132" -- Shadow texture

    logoIcon.Font = Enum.Font.GothamBold    shadow.ImageColor3 = Color3.new(0, 0, 0)

    logoIcon.TextSize = 18    shadow.ImageTransparency = 0.8

    logoIcon.TextColor3 = COLORS.primary    shadow.ZIndex = -1



    local title = Instance.new("TextLabel", header)    -- Cabeçalho limpo

    title.Size = UDim2.new(1, -120, 1, 0)    local header = Instance.new("Frame", mainFrame)

    title.Position = UDim2.fromOffset(56, 0)    header.Size = UDim2.new(1, 0, 0, 50)

    title.BackgroundTransparency = 1    header.BackgroundColor3 = COLORS.surface

    title.Text = "FK7 Admin"    header.BorderSizePixel = 0

    title.Font = Enum.Font.GothamBold    

    title.TextSize = 16    local headerCorner = Instance.new("UICorner", header)

    title.TextColor3 = COLORS.text_primary    headerCorner.CornerRadius = UDim.new(0, 16)

    title.TextXAlignment = Enum.TextXAlignment.Left    

    make_draggable(mainFrame, header)

    -- Botões de controle    

    local buttonContainer = Instance.new("Frame", header)    -- Máscara para manter cantos arredondados

    buttonContainer.Size = UDim2.fromOffset(70, 30)    local headerMask = Instance.new("Frame", header)

    buttonContainer.Position = UDim2.new(1, -85, 0.5, -15)    headerMask.Size = UDim2.new(1, 0, 0, 20)

    buttonContainer.BackgroundTransparency = 1    headerMask.Position = UDim2.new(0, 0, 1, -20)

    headerMask.BackgroundColor3 = COLORS.surface

    local buttonLayout = Instance.new("UIListLayout", buttonContainer)    headerMask.BorderSizePixel = 0

    buttonLayout.FillDirection = Enum.FillDirection.Horizontal

    buttonLayout.Padding = UDim.new(0, 8)    -- Logo e título simplificados

    local logoIcon = Instance.new("TextLabel", header)

    local function create_control_button(text, color, callback)    logoIcon.Size = UDim2.fromOffset(32, 32)

        local btn = Instance.new("TextButton", buttonContainer)    logoIcon.Position = UDim2.fromOffset(16, 9)

        btn.Size = UDim2.fromOffset(30, 30)    logoIcon.BackgroundTransparency = 1

        btn.BackgroundColor3 = color    logoIcon.Text = "⚡"

        btn.Text = text    logoIcon.Font = Enum.Font.GothamBold

        btn.Font = Enum.Font.GothamBold    logoIcon.TextSize = 18

        btn.TextSize = 12    logoIcon.TextColor3 = COLORS.primary

        btn.TextColor3 = COLORS.text_primary

        btn.BorderSizePixel = 0    local title = Instance.new("TextLabel", header)

    title.Size = UDim2.new(1, -120, 1, 0)

        local corner = Instance.new("UICorner", btn)    title.Position = UDim2.fromOffset(56, 0)

        corner.CornerRadius = UDim.new(0, 8)    title.BackgroundTransparency = 1

    title.Text = "FK7 Admin"

        btn.MouseButton1Click:Connect(callback)    title.Font = Enum.Font.GothamBold

        return btn    title.TextSize = 16

    end    title.TextColor3 = COLORS.text_primary

    title.TextXAlignment = Enum.TextXAlignment.Left

    local minimizeBtn = create_control_button("−", COLORS.warning, function()

        local isMinimized = mainFrame.Size.Y.Offset <= 60    -- Botões de controle modernos

        local targetSize = isMinimized and UDim2.fromOffset(420, 520) or UDim2.fromOffset(420, 50)    local buttonContainer = Instance.new("Frame", header)

        smooth_tween(mainFrame, {Size = targetSize}, 0.4):Play()    buttonContainer.Size = UDim2.fromOffset(70, 30)

    end)    buttonContainer.Position = UDim2.new(1, -85, 0.5, -15)

    buttonContainer.BackgroundTransparency = 1

    local closeBtn = create_control_button("✕", COLORS.error, function()    

        local closeTween = smooth_tween(mainFrame, {    local buttonLayout = Instance.new("UIListLayout", buttonContainer)

            Size = UDim2.fromOffset(0, 0),    buttonLayout.FillDirection = Enum.FillDirection.Horizontal

            Position = UDim2.new(0.5, 0, 0.5, 0)    buttonLayout.Padding = UDim.new(0, 8)

        }, 0.3)    

        closeTween:Play()    local function create_control_button(text, color, callback)

        local btn = Instance.new("TextButton", buttonContainer)

        closeTween.Completed:Connect(function()        btn.Size = UDim2.fromOffset(30, 30)

            if ctx.core and ctx.core.shutdown then        btn.BackgroundColor3 = color

                ctx.core.shutdown()        btn.Text = text

            end        btn.Font = Enum.Font.GothamBold

            screenGui:Destroy()        btn.TextSize = 12

        end)        btn.TextColor3 = COLORS.text_primary

    end)        btn.BorderSizePixel = 0

        

    -- Container principal com abas        local corner = Instance.new("UICorner", btn)

    local body = Instance.new("Frame", mainFrame)        corner.CornerRadius = UDim.new(0, 8)

    body.Size = UDim2.new(1, 0, 1, -50)        

    body.Position = UDim2.fromOffset(0, 50)        animate_button_hover(btn, Color3.new(

    body.BackgroundTransparency = 1            math.min(color.R + 0.1, 1),

            math.min(color.G + 0.1, 1),

    -- Sistema de abas lateral            math.min(color.B + 0.1, 1)

    local tabContainer = Instance.new("Frame", body)        ), color)

    tabContainer.Size = UDim2.fromOffset(110, 1)        

    tabContainer.BackgroundColor3 = COLORS.surface        btn.MouseButton1Click:Connect(callback)

    tabContainer.BorderSizePixel = 0        return btn

    end

    local tabLayout = Instance.new("UIListLayout", tabContainer)

    tabLayout.Padding = UDim.new(0, 4)    local minimizeBtn = create_control_button("−", COLORS.warning, function()

    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder        local isMinimized = mainFrame.Size.Y.Offset <= 60

        local targetSize = isMinimized and UDim2.fromOffset(420, 520) or UDim2.fromOffset(420, 50)

    local tabPadding = Instance.new("UIPadding", tabContainer)        smooth_tween(mainFrame, {Size = targetSize}, 0.4):Play()

    tabPadding.PaddingTop = UDim.new(0, 12)    end)

    tabPadding.PaddingLeft = UDim.new(0, 8)

    tabPadding.PaddingRight = UDim.new(0, 8)    local closeBtn = create_control_button("✕", COLORS.error, function()

        local closeTween = smooth_tween(mainFrame, {

    -- Painel de informações do usuário            Size = UDim2.fromOffset(0, 0),

    local userPanel = Instance.new("Frame", tabContainer)            Position = UDim2.new(0.5, 0, 0.5, 0)

    userPanel.Size = UDim2.new(1, 0, 0, 65)        }, 0.3)

    userPanel.BackgroundColor3 = COLORS.surface_light        closeTween:Play()

    userPanel.LayoutOrder = -1        

        closeTween.Completed:Connect(function()

    local userCorner = Instance.new("UICorner", userPanel)            if ctx.core and ctx.core.shutdown then

    userCorner.CornerRadius = UDim.new(0, 8)                ctx.core.shutdown()

            end

    local userName = Instance.new("TextLabel", userPanel)            screenGui:Destroy()

    userName.Size = UDim2.new(1, -12, 0, 20)        end)

    userName.Position = UDim2.fromOffset(6, 6)    end)

    userName.BackgroundTransparency = 1

    userName.Text = st.player.Name    -- Container principal com abas

    userName.Font = Enum.Font.GothamBold    local body = Instance.new("Frame", mainFrame)

    userName.TextSize = 12    body.Size = UDim2.new(1, 0, 1, -50)

    userName.TextColor3 = COLORS.text_primary    body.Position = UDim2.fromOffset(0, 50)

    userName.TextXAlignment = Enum.TextXAlignment.Left    body.BackgroundTransparency = 1

    userName.TextTruncate = Enum.TextTruncate.AtEnd

    -- Sistema de abas lateral

    local fpsLabel = Instance.new("TextLabel", userPanel)    local tabContainer = Instance.new("Frame", body)

    fpsLabel.Size = UDim2.new(1, -12, 0, 16)    tabContainer.Size = UDim2.fromOffset(110, 1)

    fpsLabel.Position = UDim2.fromOffset(6, 26)    tabContainer.BackgroundColor3 = COLORS.surface

    fpsLabel.BackgroundTransparency = 1    tabContainer.BorderSizePixel = 0

    fpsLabel.Text = "FPS: --"    

    fpsLabel.Font = Enum.Font.Gotham    local tabLayout = Instance.new("UIListLayout", tabContainer)

    fpsLabel.TextSize = 10    tabLayout.Padding = UDim.new(0, 4)

    fpsLabel.TextColor3 = COLORS.text_secondary    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder

    fpsLabel.TextXAlignment = Enum.TextXAlignment.Left    

    local tabPadding = Instance.new("UIPadding", tabContainer)

    local pingLabel = Instance.new("TextLabel", userPanel)    tabPadding.PaddingTop = UDim.new(0, 12)

    pingLabel.Size = UDim2.new(1, -12, 0, 16)    tabPadding.PaddingLeft = UDim.new(0, 8)

    pingLabel.Position = UDim2.fromOffset(6, 42)    tabPadding.PaddingRight = UDim.new(0, 8)

    pingLabel.BackgroundTransparency = 1    

    pingLabel.Text = "Ping: --"    -- Painel de informações do usuário

    pingLabel.Font = Enum.Font.Gotham    local userPanel = Instance.new("Frame", tabContainer)

    pingLabel.TextSize = 10    userPanel.Size = UDim2.new(1, 0, 0, 65)

    pingLabel.TextColor3 = COLORS.text_secondary    userPanel.BackgroundColor3 = COLORS.surface_light

    pingLabel.TextXAlignment = Enum.TextXAlignment.Left    userPanel.LayoutOrder = -1

    

    -- Atualizar FPS e Ping    local userCorner = Instance.new("UICorner", userPanel)

    local lastUpdate = 0    userCorner.CornerRadius = UDim.new(0, 8)

    RunService.Heartbeat:Connect(function()    

        if tick() - lastUpdate > 0.5 then    local userName = Instance.new("TextLabel", userPanel)

            lastUpdate = tick()    userName.Size = UDim2.new(1, -12, 0, 20)

            local fps = math.floor(1 / RunService.Heartbeat:Wait())    userName.Position = UDim2.fromOffset(6, 6)

            fpsLabel.Text = "FPS: " .. fps    userName.BackgroundTransparency = 1

    userName.Text = st.player.Name

            local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()    userName.Font = Enum.Font.GothamBold

            pingLabel.Text = "Ping: " .. ping    userName.TextSize = 12

        end    userName.TextColor3 = COLORS.text_primary

    end)    userName.TextXAlignment = Enum.TextXAlignment.Left

    userName.TextTruncate = Enum.TextTruncate.AtEnd

    -- Container de conteúdo    

    local contentContainer = Instance.new("Frame", body)    local fpsLabel = Instance.new("TextLabel", userPanel)

    contentContainer.Size = UDim2.new(1, -110, 1, 0)    fpsLabel.Size = UDim2.new(1, -12, 0, 16)

    contentContainer.Position = UDim2.fromOffset(110, 0)    fpsLabel.Position = UDim2.fromOffset(6, 26)

    contentContainer.BackgroundTransparency = 1    fpsLabel.BackgroundTransparency = 1

    fpsLabel.Text = "FPS: --"

    -- Sistema de tooltip    fpsLabel.Font = Enum.Font.Gotham

    local tooltip, tooltipLabel = create_tooltip(screenGui)    fpsLabel.TextSize = 10

    fpsLabel.TextColor3 = COLORS.text_secondary

    local pages = {}    fpsLabel.TextXAlignment = Enum.TextXAlignment.Left

    local tabs = {}    

    local activeTab = nil    local pingLabel = Instance.new("TextLabel", userPanel)

    pingLabel.Size = UDim2.new(1, -12, 0, 16)

    -- Função para criar abas    pingLabel.Position = UDim2.fromOffset(6, 42)

    local function create_tab(name, icon, order)    pingLabel.BackgroundTransparency = 1

        local tab = Instance.new("TextButton")    pingLabel.Text = "Ping: --"

        tab.Size = UDim2.new(1, 0, 0, 36)    pingLabel.Font = Enum.Font.Gotham

        tab.BackgroundColor3 = COLORS.surface    pingLabel.TextSize = 10

        tab.Text = ""    pingLabel.TextColor3 = COLORS.text_secondary

        tab.LayoutOrder = order    pingLabel.TextXAlignment = Enum.TextXAlignment.Left

        tab.Parent = tabContainer    

    -- Atualizar FPS e Ping

        local tabCorner = Instance.new("UICorner", tab)    local lastUpdate = 0

        tabCorner.CornerRadius = UDim.new(0, 8)    RunService.Heartbeat:Connect(function()

        if tick() - lastUpdate > 0.5 then

        local tabIcon = Instance.new("TextLabel", tab)            lastUpdate = tick()

        tabIcon.Size = UDim2.fromOffset(20, 20)            local fps = math.floor(1 / RunService.Heartbeat:Wait())

        tabIcon.Position = UDim2.fromOffset(8, 8)            fpsLabel.Text = "FPS: " .. fps

        tabIcon.BackgroundTransparency = 1            

        tabIcon.Text = icon            local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()

        tabIcon.Font = Enum.Font.GothamBold            pingLabel.Text = "Ping: " .. ping

        tabIcon.TextSize = 14        end

        tabIcon.TextColor3 = COLORS.text_secondary    end)



        local tabText = Instance.new("TextLabel", tab)    -- Container de conteúdo

        tabText.Size = UDim2.new(1, -36, 1, 0)    local contentContainer = Instance.new("Frame", body)

        tabText.Position = UDim2.fromOffset(32, 0)    contentContainer.Size = UDim2.new(1, -110, 1, 0)

        tabText.BackgroundTransparency = 1    contentContainer.Position = UDim2.fromOffset(110, 0)

        tabText.Text = name    contentContainer.BackgroundTransparency = 1

        tabText.Font = Enum.Font.GothamMedium

        tabText.TextSize = 11    -- Sistema de tooltip

        tabText.TextColor3 = COLORS.text_secondary    local tooltip, tooltipLabel = create_tooltip(screenGui)

        tabText.TextXAlignment = Enum.TextXAlignment.Left

    local pages = {}

        local page = Instance.new("ScrollingFrame")    local tabs = {}

        page.Size = UDim2.new(1, -16, 1, -16)    local activeTab = nil

        page.Position = UDim2.fromOffset(8, 8)

        page.BackgroundTransparency = 1    -- Função para criar abas

        page.BorderSizePixel = 0    local function create_tab(name, icon, order)

        page.CanvasSize = UDim2.fromOffset(0, 0)        local tab = Instance.new("TextButton")

        page.ScrollBarThickness = 4        tab.Size = UDim2.new(1, 0, 0, 36)

        page.ScrollBarImageColor3 = COLORS.primary        tab.BackgroundColor3 = COLORS.surface

        page.Visible = false        tab.Text = ""

        page.Parent = contentContainer        tab.LayoutOrder = order

        tab.Parent = tabContainer

        local pageLayout = Instance.new("UIListLayout", page)        

        pageLayout.Padding = UDim.new(0, 6)        local tabCorner = Instance.new("UICorner", tab)

        pageLayout.SortOrder = Enum.SortOrder.LayoutOrder        tabCorner.CornerRadius = UDim.new(0, 8)

        

        pages[name] = page        local tabIcon = Instance.new("TextLabel", tab)

        tabs[name] = {button = tab, icon = tabIcon, text = tabText}        tabIcon.Size = UDim2.fromOffset(20, 20)

        tabIcon.Position = UDim2.fromOffset(8, 8)

        tab.MouseButton1Click:Connect(function()        tabIcon.BackgroundTransparency = 1

            if activeTab == name then return end        tabIcon.Text = icon

        tabIcon.Font = Enum.Font.GothamBold

            -- Desativar aba anterior        tabIcon.TextSize = 14

            if activeTab then        tabIcon.TextColor3 = COLORS.text_secondary

                local oldTab = tabs[activeTab]        

                smooth_tween(oldTab.button, {BackgroundColor3 = COLORS.surface}):Play()        local tabText = Instance.new("TextLabel", tab)

                smooth_tween(oldTab.icon, {TextColor3 = COLORS.text_secondary}):Play()        tabText.Size = UDim2.new(1, -36, 1, 0)

                smooth_tween(oldTab.text, {TextColor3 = COLORS.text_secondary}):Play()        tabText.Position = UDim2.fromOffset(32, 0)

                pages[activeTab].Visible = false        tabText.BackgroundTransparency = 1

            end        tabText.Text = name

        tabText.Font = Enum.Font.GothamMedium

            -- Ativar nova aba        tabText.TextSize = 11

            activeTab = name        tabText.TextColor3 = COLORS.text_secondary

            smooth_tween(tab, {BackgroundColor3 = COLORS.primary}):Play()        tabText.TextXAlignment = Enum.TextXAlignment.Left

            smooth_tween(tabIcon, {TextColor3 = COLORS.text_primary}):Play()        

            smooth_tween(tabText, {TextColor3 = COLORS.text_primary}):Play()        local page = Instance.new("ScrollingFrame")

            page.Visible = true        page.Size = UDim2.new(1, -16, 1, -16)

        end)        page.Position = UDim2.fromOffset(8, 8)

        page.BackgroundTransparency = 1

        return page        page.BorderSizePixel = 0

    end        page.CanvasSize = UDim2.fromOffset(0, 0)

        page.ScrollBarThickness = 4

    -- Função para criar botões        page.ScrollBarImageColor3 = COLORS.primary

    local function create_feature_button(parent, text, description, callback)        page.Visible = false

        local btn = Instance.new("TextButton")        page.Parent = contentContainer

        btn.Size = UDim2.new(1, 0, 0, 48)        

        btn.BackgroundColor3 = COLORS.surface        local pageLayout = Instance.new("UIListLayout", page)

        btn.Text = ""        pageLayout.Padding = UDim.new(0, 6)

        btn.Parent = parent        pageLayout.SortOrder = Enum.SortOrder.LayoutOrder

        

        local btnCorner = Instance.new("UICorner", btn)        pages[name] = page

        btnCorner.CornerRadius = UDim.new(0, 10)        tabs[name] = {button = tab, icon = tabIcon, text = tabText}

        

        local btnStroke = Instance.new("UIStroke", btn)        tab.MouseButton1Click:Connect(function()

        btnStroke.Color = COLORS.border            if activeTab == name then return end

        btnStroke.Thickness = 1            

        btnStroke.Transparency = 0.5            -- Desativar aba anterior

            if activeTab then

        local textLabel = Instance.new("TextLabel", btn)                local oldTab = tabs[activeTab]

        textLabel.Size = UDim2.new(1, -60, 0, 20)                smooth_tween(oldTab.button, {BackgroundColor3 = COLORS.surface}):Play()

        textLabel.Position = UDim2.fromOffset(16, 8)                smooth_tween(oldTab.icon, {TextColor3 = COLORS.text_secondary}):Play()

        textLabel.BackgroundTransparency = 1                smooth_tween(oldTab.text, {TextColor3 = COLORS.text_secondary}):Play()

        textLabel.Text = text                pages[activeTab].Visible = false

        textLabel.Font = Enum.Font.GothamMedium            end

        textLabel.TextSize = 14            

        textLabel.TextColor3 = COLORS.text_primary            -- Ativar nova aba

        textLabel.TextXAlignment = Enum.TextXAlignment.Left            activeTab = name

            smooth_tween(tab, {BackgroundColor3 = COLORS.primary}):Play()

        local descLabel = Instance.new("TextLabel", btn)            smooth_tween(tabIcon, {TextColor3 = COLORS.text_primary}):Play()

        descLabel.Size = UDim2.new(1, -60, 0, 16)            smooth_tween(tabText, {TextColor3 = COLORS.text_primary}):Play()

        descLabel.Position = UDim2.fromOffset(16, 26)            page.Visible = true

        descLabel.BackgroundTransparency = 1        end)

        descLabel.Text = description        

        descLabel.Font = Enum.Font.Gotham        return page

        descLabel.TextSize = 11    end

        descLabel.TextColor3 = COLORS.text_secondary

        descLabel.TextXAlignment = Enum.TextXAlignment.Left    -- Função para criar botões modernos

    local function create_feature_button(parent, text, description, callback)

        local indicator = Instance.new("Frame", btn)        local btn = Instance.new("TextButton")

        indicator.Size = UDim2.fromOffset(12, 12)        btn.Size = UDim2.new(1, 0, 0, 48)

        indicator.Position = UDim2.new(1, -28, 0.5, -6)        btn.BackgroundColor3 = COLORS.surface

        indicator.BackgroundColor3 = COLORS.error        btn.Text = ""

        indicator.BorderSizePixel = 0        btn.Parent = parent

        

        local indicatorCorner = Instance.new("UICorner", indicator)        local btnCorner = Instance.new("UICorner", btn)

        indicatorCorner.CornerRadius = UDim.new(0, 6)        btnCorner.CornerRadius = UDim.new(0, 10)

        

        -- Animações de hover        local btnStroke = Instance.new("UIStroke", btn)

        local originalColor = COLORS.surface        btnStroke.Color = COLORS.border

        btn.MouseEnter:Connect(function()        btnStroke.Thickness = 1

            smooth_tween(btn, {BackgroundColor3 = COLORS.surface_light}):Play()        btnStroke.Transparency = 0.5

            tooltipLabel.Text = description        

            tooltip.Visible = true        local textLabel = Instance.new("TextLabel", btn)

        end)        textLabel.Size = UDim2.new(1, -60, 0, 20)

        textLabel.Position = UDim2.fromOffset(16, 8)

        btn.MouseLeave:Connect(function()        textLabel.BackgroundTransparency = 1

            smooth_tween(btn, {BackgroundColor3 = originalColor}):Play()        textLabel.Text = text

            tooltip.Visible = false        textLabel.Font = Enum.Font.GothamMedium

        end)        textLabel.TextSize = 14

        textLabel.TextColor3 = COLORS.text_primary

        -- Posicionar tooltip        textLabel.TextXAlignment = Enum.TextXAlignment.Left

        UserInputService.InputChanged:Connect(function(input)        

            if input.UserInputType == Enum.UserInputType.MouseMovement and tooltip.Visible then        local descLabel = Instance.new("TextLabel", btn)

                local mouse = UserInputService:GetMouseLocation()        descLabel.Size = UDim2.new(1, -60, 0, 16)

                tooltip.Position = UDim2.fromOffset(mouse.X + 16, mouse.Y - 40)        descLabel.Position = UDim2.fromOffset(16, 26)

            end        descLabel.BackgroundTransparency = 1

        end)        descLabel.Text = description

        descLabel.Font = Enum.Font.Gotham

        btn.MouseButton1Click:Connect(function()        descLabel.TextSize = 11

            local success, result = pcall(callback, btn, indicator, textLabel)        descLabel.TextColor3 = COLORS.text_secondary

            if not success then        descLabel.TextXAlignment = Enum.TextXAlignment.Left

                warn("[FK7] Erro:", result)        

                smooth_tween(indicator, {BackgroundColor3 = COLORS.warning}):Play()        local indicator = Instance.new("Frame", btn)

                task.wait(1.5)        indicator.Size = UDim2.fromOffset(12, 12)

                smooth_tween(indicator, {BackgroundColor3 = COLORS.error}):Play()        indicator.Position = UDim2.new(1, -28, 0.5, -6)

            end        indicator.BackgroundColor3 = COLORS.error

        end)        indicator.BorderSizePixel = 0

        

        return btn, indicator, textLabel        local indicatorCorner = Instance.new("UICorner", indicator)

    end        indicatorCorner.CornerRadius = UDim.new(0, 6)

        

    local function update_button_status(indicator, textLabel, enabled, originalText)        -- Animações de hover

        if enabled then        animate_button_hover(btn, COLORS.surface_light, COLORS.surface)

            smooth_tween(indicator, {BackgroundColor3 = COLORS.success}):Play()        

            textLabel.Text = originalText .. " (ON)"        -- Mostrar tooltip

        else        btn.MouseEnter:Connect(function()

            smooth_tween(indicator, {BackgroundColor3 = COLORS.error}):Play()            tooltipLabel.Text = description

            textLabel.Text = originalText            tooltip.Visible = true

        end        end)

    end        

        btn.MouseLeave:Connect(function()

    -- Criar páginas/abas            tooltip.Visible = false

    local movementPage = create_tab("Movimento", "🏃", 1)        end)

    local combatPage = create_tab("Combate", "⚔️", 2)        

    local visualPage = create_tab("Visual", "👁️", 3)        -- Posicionar tooltip

        UserInputService.InputChanged:Connect(function(input)

    -- Página Movimento            if input.UserInputType == Enum.UserInputType.MouseMovement and tooltip.Visible then

    create_feature_button(movementPage, "Fly", "Voe livremente pelo mapa", function(btn, indicator, label)                local mouse = UserInputService:GetMouseLocation()

        if ctx.features.fly then                tooltip.Position = UDim2.fromOffset(mouse.X + 16, mouse.Y - 40)

            local enabled = ctx.features.fly.toggle()            end

            update_button_status(indicator, label, enabled, "Fly")        end)

        else        

            error("Módulo fly não encontrado")        btn.MouseButton1Click:Connect(function()

        end            local success, result = pcall(callback, btn, indicator, textLabel)

    end)            if not success then

                warn("[FK7] Erro:", result)

    create_feature_button(movementPage, "Noclip", "Atravesse paredes e objetos sólidos", function(btn, indicator, label)                smooth_tween(indicator, {BackgroundColor3 = COLORS.warning}):Play()

        if ctx.features.noclip then                task.wait(1.5)

            local enabled = ctx.features.noclip.toggle()                smooth_tween(indicator, {BackgroundColor3 = COLORS.error}):Play()

            update_button_status(indicator, label, enabled, "Noclip")            end

        else        end)

            error("Módulo noclip não encontrado")        

        end        return btn, indicator, textLabel

    end)    end



    create_feature_button(movementPage, "Speed", "Aumente sua velocidade de movimento", function(btn, indicator, label)    local function update_button_status(indicator, textLabel, enabled, originalText)

        if ctx.features.speed then        if enabled then

            local enabled = ctx.features.speed.toggle()            smooth_tween(indicator, {BackgroundColor3 = COLORS.success}):Play()

            update_button_status(indicator, label, enabled, "Speed")            textLabel.Text = originalText .. " (ON)"

        else        else

            error("Módulo speed não encontrado")            smooth_tween(indicator, {BackgroundColor3 = COLORS.error}):Play()

        end            textLabel.Text = originalText

    end)        end

    end

    create_feature_button(movementPage, "Infinite Jump", "Pule infinitas vezes no ar", function(btn, indicator, label)

        if ctx.features.infinitejump then    -- Criar páginas/abas

            local enabled = ctx.features.infinitejump.toggle()    local movementPage = create_tab("Movimento", "🏃", 1)

            update_button_status(indicator, label, enabled, "Infinite Jump")    local combatPage = create_tab("Combate", "⚔️", 2)

        else    local visualPage = create_tab("Visual", "👁️", 3)

            error("Módulo infinitejump não encontrado")    local worldPage = create_tab("Mundo", "🌍", 4)

        end    local autoPage = create_tab("Auto", "⚙️", 5)

    end)

    -- Página Movimento

    create_feature_button(movementPage, "Click TP", "Teleporte clicando no mapa", function(btn, indicator, label)    create_feature_button(movementPage, "Fly", "Voe livremente pelo mapa", function(btn, indicator, label)

        if ctx.features.clicktp then        if ctx.features.fly and ctx.features.fly.toggle then

            local enabled = ctx.features.clicktp.toggle()            local enabled = ctx.features.fly.toggle()

            update_button_status(indicator, label, enabled, "Click TP")            update_button_status(indicator, label, enabled, "Fly")

        else        else

            error("Módulo clicktp não encontrado")            error("Módulo fly não encontrado")

        end        end

    end)    end)



    -- Página Combate    create_feature_button(movementPage, "Noclip", "Atravesse paredes e objetos sólidos", function(btn, indicator, label)

    create_feature_button(combatPage, "God Mode", "Torna você imortal", function(btn, indicator, label)        if ctx.features.noclip and ctx.features.noclip.toggle then

        if ctx.features.godmode then            local enabled = ctx.features.noclip.toggle()

            local enabled = ctx.features.godmode.toggle()            update_button_status(indicator, label, enabled, "Noclip")

            update_button_status(indicator, label, enabled, "God Mode")        else

        else            error("Módulo noclip não encontrado")

            error("Módulo godmode não encontrado")        end

        end    end)

    end)

    create_feature_button(movementPage, "Speed", "Aumente sua velocidade de movimento", function(btn, indicator, label)

    -- Página Visual        if ctx.features.speed and ctx.features.speed.toggle then

    create_feature_button(visualPage, "Full Bright", "Ilumina completamente o ambiente", function(btn, indicator, label)            local enabled = ctx.features.speed.toggle()

        if ctx.features.fullbright then            update_button_status(indicator, label, enabled, "Speed")

            local enabled = ctx.features.fullbright.toggle()        else

            update_button_status(indicator, label, enabled, "Full Bright")            error("Módulo speed não encontrado")

        else        end

            error("Módulo fullbright não encontrado")    end)

        end

    end)    create_feature_button(movementPage, "Infinite Jump", "Pule infinitas vezes no ar", function(btn, indicator, label)

        if ctx.features.infinitejump and ctx.features.infinitejump.toggle then

    create_feature_button(visualPage, "ESP", "Mostra informações de outros jogadores", function(btn, indicator, label)            local enabled = ctx.features.infinitejump.toggle()

        if ctx.features.esp then            update_button_status(indicator, label, enabled, "Infinite Jump")

            local enabled = ctx.features.esp.toggle()        else

            update_button_status(indicator, label, enabled, "ESP")            error("Módulo infinitejump não encontrado")

        else        end

            error("Módulo esp não encontrado")    end)

        end

    end)    create_feature_button(movementPage, "Click Teleport", "Teleporte clicando no mapa", function(btn, indicator, label)

        if ctx.features.clicktp and ctx.features.clicktp.toggle then

    -- Atualizar tamanho do conteúdo das páginas            local enabled = ctx.features.clicktp.toggle()

    for _, page in pairs(pages) do            update_button_status(indicator, label, enabled, "Click Teleport")

        local layout = page:FindFirstChild("UIListLayout")        else

        if layout then            error("Módulo clicktp não encontrado")

            layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()        end

                page.CanvasSize = UDim2.fromOffset(0, layout.AbsoluteContentSize.Y + 16)    end)

            end)

            page.CanvasSize = UDim2.fromOffset(0, layout.AbsoluteContentSize.Y + 16)    -- Página Combate

        end    create_feature_button(combatPage, "God Mode", "Torna você imortal", function(btn, indicator, label)

    end        if ctx.features.godmode and ctx.features.godmode.toggle then

            local enabled = ctx.features.godmode.toggle()

    -- Ativar primeira aba por padrão            update_button_status(indicator, label, enabled, "God Mode")

    tabs["Movimento"].button.MouseButton1Click:Invoke()        else

            error("Módulo godmode não encontrado")

    -- Animação de entrada        end

    mainFrame.Size = UDim2.fromOffset(0, 0)    end)

    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)

    create_feature_button(combatPage, "No Fall Damage", "Remove danos de queda", function(btn, indicator, label)

    local openTween = smooth_tween(mainFrame, {        if ctx.features.nofalldamage and ctx.features.nofalldamage.toggle then

        Size = UDim2.fromOffset(420, 520),            local enabled = ctx.features.nofalldamage.toggle()

        Position = UDim2.new(0.5, -210, 0.5, -260)            update_button_status(indicator, label, enabled, "No Fall Damage")

    }, 0.6, Enum.EasingStyle.Back)        else

    openTween:Play()            error("Módulo nofalldamage não encontrado")

        end

    print("[FK7] Interface moderna carregada! ⚡")    end)

end

    -- Página Visual

return UI    create_feature_button(visualPage, "Full Bright", "Ilumina completamente o ambiente", function(btn, indicator, label)
        if ctx.features.fullbright and ctx.features.fullbright.toggle then
            local enabled = ctx.features.fullbright.toggle()
            update_button_status(indicator, label, enabled, "Full Bright")
        else
            error("Módulo fullbright não encontrado")
        end
    end)

    create_feature_button(visualPage, "X-Ray", "Veja através de paredes", function(btn, indicator, label)
        if ctx.features.xray and ctx.features.xray.toggle then
            local enabled = ctx.features.xray.toggle()
            update_button_status(indicator, label, enabled, "X-Ray")
        else
            error("Módulo xray não encontrado")
        end
    end)

    create_feature_button(visualPage, "ESP", "Mostra informações de outros jogadores", function(btn, indicator, label)
        if ctx.features.esp and ctx.features.esp.toggle then
            local enabled = ctx.features.esp.toggle()
            update_button_status(indicator, label, enabled, "ESP")
        else
            error("Módulo esp não encontrado")
        end
    end)

    -- Página Mundo
    create_feature_button(worldPage, "Low Gravity", "Reduz a gravidade do jogo", function(btn, indicator, label)
        if ctx.features.lowgravity and ctx.features.lowgravity.toggle then
            local enabled = ctx.features.lowgravity.toggle()
            update_button_status(indicator, label, enabled, "Low Gravity")
        else
            error("Módulo lowgravity não encontrado")
        end
    end)

    create_feature_button(worldPage, "Walk Through", "Atravesse objetos específicos", function(btn, indicator, label)
        if ctx.features.walkthrough and ctx.features.walkthrough.toggle then
            local enabled = ctx.features.walkthrough.toggle()
            update_button_status(indicator, label, enabled, "Walk Through")
        else
            error("Módulo walkthrough não encontrado")
        end
    end)

    -- Página Automação
    create_feature_button(autoPage, "Auto Farm", "Coleta recursos automaticamente", function(btn, indicator, label)
        if ctx.features.autofarm and ctx.features.autofarm.toggle then
            local enabled = ctx.features.autofarm.toggle()
            update_button_status(indicator, label, enabled, "Auto Farm")
        else
            error("Módulo autofarm não encontrado")
        end
    end)

    create_feature_button(autoPage, "Auto Jump", "Pula obstáculos automaticamente", function(btn, indicator, label)
        if ctx.features.autojump and ctx.features.autojump.toggle then
            local enabled = ctx.features.autojump.toggle()
            update_button_status(indicator, label, enabled, "Auto Jump")
        else
            error("Módulo autojump não encontrado")
        end
    end)

    create_feature_button(autoPage, "Instant Respawn", "Renascimento instantâneo", function(btn, indicator, label)
        if ctx.features.instantrespawn and ctx.features.instantrespawn.toggle then
            local enabled = ctx.features.instantrespawn.toggle()
            update_button_status(indicator, label, enabled, "Instant Respawn")
        else
            error("Módulo instantrespawn não encontrado")
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