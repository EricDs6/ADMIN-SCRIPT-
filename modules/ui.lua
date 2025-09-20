-- modules/ui.lua - Interface Moderna FK7 Admin v3.0
local UI = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Cores do tema moderno
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

-- Função para animações suaves
local function smooth_tween(object, properties, duration, style)
    duration = duration or 0.3
    style = style or Enum.EasingStyle.Quart
    return TweenService:Create(object, TweenInfo.new(duration, style), properties)
end

-- Animações e efeitos visuais modernos
local function animate_button_hover(button, hoverColor, originalColor)
    button.MouseEnter:Connect(function()
        smooth_tween(button, {BackgroundColor3 = hoverColor}):Play()
    end)
    
    button.MouseLeave:Connect(function()
        smooth_tween(button, {BackgroundColor3 = originalColor}):Play()
    end)
end

-- Sistema de arrastar melhorado
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

-- Criar tooltip moderno
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

    -- Frame principal moderno
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
    
    -- Sombra sutil
    local shadow = Instance.new("ImageLabel", screenGui)
    shadow.Size = mainFrame.Size + UDim2.fromOffset(40, 40)
    shadow.Position = mainFrame.Position - UDim2.fromOffset(20, 20)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://8560915132" -- Shadow texture
    shadow.ImageColor3 = Color3.new(0, 0, 0)
    shadow.ImageTransparency = 0.8
    shadow.ZIndex = -1

    -- Cabeçalho limpo
    local header = Instance.new("Frame", mainFrame)
    header.Size = UDim2.new(1, 0, 0, 50)
    header.BackgroundColor3 = COLORS.surface
    header.BorderSizePixel = 0
    
    local headerCorner = Instance.new("UICorner", header)
    headerCorner.CornerRadius = UDim.new(0, 16)
    
    make_draggable(mainFrame, header)
    
    -- Máscara para manter cantos arredondados
    local headerMask = Instance.new("Frame", header)
    headerMask.Size = UDim2.new(1, 0, 0, 20)
    headerMask.Position = UDim2.new(0, 0, 1, -20)
    headerMask.BackgroundColor3 = COLORS.surface
    headerMask.BorderSizePixel = 0

    -- Logo e título simplificados
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

    -- Botões de controle modernos
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
        
        animate_button_hover(btn, Color3.new(
            math.min(color.R + 0.1, 1),
            math.min(color.G + 0.1, 1),
            math.min(color.B + 0.1, 1)
        ), color)
        
        btn.MouseButton1Click:Connect(callback)
        return btn
    end

    local minimizeBtn = create_control_button("−", COLORS.warning, function()
        local isMinimized = mainFrame.Size.Y.Offset <= 60
        local targetSize = isMinimized and UDim2.fromOffset(420, 520) or UDim2.fromOffset(420, 50)
        smooth_tween(mainFrame, {Size = targetSize}, 0.4):Play()
    end)

    local closeBtn = create_control_button("✕", COLORS.error, function()
        local closeTween = smooth_tween(mainFrame, {
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

    -- Função para criar botões modernos
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
        animate_button_hover(btn, COLORS.surface_light, COLORS.surface)
        
        -- Mostrar tooltip
        btn.MouseEnter:Connect(function()
            tooltipLabel.Text = description
            tooltip.Visible = true
        end)
        
        btn.MouseLeave:Connect(function()
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
    local worldPage = create_tab("Mundo", "🌍", 4)
    local autoPage = create_tab("Auto", "⚙️", 5)

    -- Página Movimento
    create_feature_button(movementPage, "Fly", "Voe livremente pelo mapa", function(btn, indicator, label)
        if ctx.features.fly and ctx.features.fly.toggle then
            local enabled = ctx.features.fly.toggle()
            update_button_status(indicator, label, enabled, "Fly")
        else
            error("Módulo fly não encontrado")
        end
    end)

    create_feature_button(movementPage, "Noclip", "Atravesse paredes e objetos sólidos", function(btn, indicator, label)
        if ctx.features.noclip and ctx.features.noclip.toggle then
            local enabled = ctx.features.noclip.toggle()
            update_button_status(indicator, label, enabled, "Noclip")
        else
            error("Módulo noclip não encontrado")
        end
    end)

    create_feature_button(movementPage, "Speed", "Aumente sua velocidade de movimento", function(btn, indicator, label)
        if ctx.features.speed and ctx.features.speed.toggle then
            local enabled = ctx.features.speed.toggle()
            update_button_status(indicator, label, enabled, "Speed")
        else
            error("Módulo speed não encontrado")
        end
    end)

    create_feature_button(movementPage, "Infinite Jump", "Pule infinitas vezes no ar", function(btn, indicator, label)
        if ctx.features.infinitejump and ctx.features.infinitejump.toggle then
            local enabled = ctx.features.infinitejump.toggle()
            update_button_status(indicator, label, enabled, "Infinite Jump")
        else
            error("Módulo infinitejump não encontrado")
        end
    end)

    create_feature_button(movementPage, "Click Teleport", "Teleporte clicando no mapa", function(btn, indicator, label)
        if ctx.features.clicktp and ctx.features.clicktp.toggle then
            local enabled = ctx.features.clicktp.toggle()
            update_button_status(indicator, label, enabled, "Click Teleport")
        else
            error("Módulo clicktp não encontrado")
        end
    end)

    -- Página Combate
    create_feature_button(combatPage, "God Mode", "Torna você imortal", function(btn, indicator, label)
        if ctx.features.godmode and ctx.features.godmode.toggle then
            local enabled = ctx.features.godmode.toggle()
            update_button_status(indicator, label, enabled, "God Mode")
        else
            error("Módulo godmode não encontrado")
        end
    end)

    create_feature_button(combatPage, "No Fall Damage", "Remove danos de queda", function(btn, indicator, label)
        if ctx.features.nofalldamage and ctx.features.nofalldamage.toggle then
            local enabled = ctx.features.nofalldamage.toggle()
            update_button_status(indicator, label, enabled, "No Fall Damage")
        else
            error("Módulo nofalldamage não encontrado")
        end
    end)

    -- Página Visual
    create_feature_button(visualPage, "Full Bright", "Ilumina completamente o ambiente", function(btn, indicator, label)
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