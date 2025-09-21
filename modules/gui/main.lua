--[[
    Módulo de Interface Gráfica (GUI)
    Parte do Admin Script Modular v2.0
    
    Funcionalidades:
    - Interface completa para controlar todas as funções
    - Personalização de cores e temas
    - Sistema de guias para organizar funções
    - Arrastar e soltar
]]

-- Verificar se AdminScript está disponível
local Admin = _G.AdminScript
if not Admin then
    warn("❌ AdminScript não inicializado! Módulo GUI não pode ser carregado.")
    return
end

local Services = Admin.Services
local Player = Admin.Player

-- Estado do módulo
local GUIModule = {
    visible = false,
    screenGui = nil,
    mainFrame = nil,
    tabs = {},
    activeTab = nil,
    colors = {
        background = Color3.fromRGB(30, 30, 30),
        header = Color3.fromRGB(40, 40, 40),
        button = Color3.fromRGB(50, 50, 50),
        buttonHover = Color3.fromRGB(60, 60, 60),
        text = Color3.fromRGB(255, 255, 255),
        accent = Color3.fromRGB(0, 120, 215),
        enabled = Color3.fromRGB(0, 200, 0),
        disabled = Color3.fromRGB(200, 0, 0),
        warning = Color3.fromRGB(255, 165, 0)
    }
}

-- Criar elementos de interface
local function createElement(className, properties)
    local element = Instance.new(className)
    
    for property, value in pairs(properties) do
        element[property] = value
    end
    
    return element
end

-- Função para criar o botão de uma funcionalidade
local function createFeatureButton(parent, text, callback, getStateFunc)
    local button = createElement("TextButton", {
        Size = UDim2.new(1, -20, 0, 40),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundColor3 = GUIModule.colors.button,
        BorderSizePixel = 0,
        Text = text,
        TextColor3 = GUIModule.colors.text,
        TextSize = 14,
        Font = Enum.Font.SourceSansBold,
        AutoButtonColor = false
    })
    
    -- Estado visual (indicador)
    local stateIndicator = createElement("Frame", {
        Size = UDim2.new(0, 10, 0, 10),
        Position = UDim2.new(0, 10, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = GUIModule.colors.disabled,
        BorderSizePixel = 0
    })
    
    -- Arredondar cantos do indicador
    local corner = createElement("UICorner", {
        CornerRadius = UDim.new(1, 0)
    })
    corner.Parent = stateIndicator
    
    stateIndicator.Parent = button
    
    -- Padding para o texto
    button.TextXAlignment = Enum.TextXAlignment.Center
    
    -- Cantos arredondados
    local corner = createElement("UICorner", {
        CornerRadius = UDim.new(0, 8)
    })
    corner.Parent = button
    
    -- Efeito hover
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = GUIModule.colors.buttonHover
    end)
    
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = GUIModule.colors.button
    end)
    
    -- Ação do botão
    button.MouseButton1Click:Connect(function()
        if callback then
            callback()
            
            -- Atualizar indicador de estado
            if getStateFunc then
                local isActive = getStateFunc()
                stateIndicator.BackgroundColor3 = isActive and GUIModule.colors.enabled or GUIModule.colors.disabled
            end
        end
    end)
    
    -- Atualizar estado inicial
    if getStateFunc then
        local isActive = getStateFunc()
        stateIndicator.BackgroundColor3 = isActive and GUIModule.colors.enabled or GUIModule.colors.disabled
    end
    
    button.Parent = parent
    return button
end

-- Função para criar um controle deslizante
local function createSlider(parent, text, min, max, defaultValue, callback)
    local container = createElement("Frame", {
        Size = UDim2.new(1, -20, 0, 60),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundColor3 = GUIModule.colors.button,
        BorderSizePixel = 0
    })
    
    -- Cantos arredondados
    local corner = createElement("UICorner", {
        CornerRadius = UDim.new(0, 8)
    })
    corner.Parent = container
    
    -- Título
    local title = createElement("TextLabel", {
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 0, 5),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = GUIModule.colors.text,
        TextSize = 14,
        Font = Enum.Font.SourceSansSemibold
    })
    title.Parent = container
    
    -- Barra de fundo
    local sliderBack = createElement("Frame", {
        Size = UDim2.new(1, -20, 0, 6),
        Position = UDim2.new(0, 10, 0, 30),
        BackgroundColor3 = Color3.fromRGB(80, 80, 80),
        BorderSizePixel = 0
    })
    
    local backCorner = createElement("UICorner", {
        CornerRadius = UDim.new(1, 0)
    })
    backCorner.Parent = sliderBack
    sliderBack.Parent = container
    
    -- Barra de progresso
    local sliderFill = createElement("Frame", {
        Size = UDim2.new(0.5, 0, 1, 0),
        BackgroundColor3 = GUIModule.colors.accent,
        BorderSizePixel = 0
    })
    
    local fillCorner = createElement("UICorner", {
        CornerRadius = UDim.new(1, 0)
    })
    fillCorner.Parent = sliderFill
    sliderFill.Parent = sliderBack
    
    -- Botão deslizante
    local sliderButton = createElement("TextButton", {
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(240, 240, 240),
        Text = "",
        BorderSizePixel = 0
    })
    
    local buttonCorner = createElement("UICorner", {
        CornerRadius = UDim.new(1, 0)
    })
    buttonCorner.Parent = sliderButton
    sliderButton.Parent = sliderBack
    
    -- Valor
    local valueLabel = createElement("TextLabel", {
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 0, 40),
        BackgroundTransparency = 1,
        Text = tostring(defaultValue),
        TextColor3 = GUIModule.colors.text,
        TextSize = 14,
        Font = Enum.Font.SourceSans
    })
    valueLabel.Parent = container
    
    -- Função para definir o valor
    local function setValue(value)
        value = math.clamp(value, min, max)
        local percent = (value - min) / (max - min)
        
        -- Atualizar interface
        sliderFill.Size = UDim2.new(percent, 0, 1, 0)
        sliderButton.Position = UDim2.new(percent, 0, 0.5, 0)
        valueLabel.Text = tostring(math.floor(value))
        
        -- Chamar callback
        if callback then
            callback(value)
        end
    end
    
    -- Definir valor inicial
    setValue(defaultValue)
    
    -- Eventos do controle deslizante
    local isDragging = false
    
    sliderButton.MouseButton1Down:Connect(function()
        isDragging = true
    end)
    
    Services.UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = false
        end
    end)
    
    Services.UserInputService.InputChanged:Connect(function(input)
        if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = input.Position.X
            local sliderPos = sliderBack.AbsolutePosition.X
            local sliderSize = sliderBack.AbsoluteSize.X
            
            local relativePos = (mousePos - sliderPos) / sliderSize
            relativePos = math.clamp(relativePos, 0, 1)
            
            local value = min + (max - min) * relativePos
            setValue(value)
        end
    end)
    
    container.Parent = parent
    return container, setValue
end

-- Função para criar uma guia
local function createTab(name)
    -- Verificar se a guia já existe
    if GUIModule.tabs[name] then
        return GUIModule.tabs[name]
    end
    
    -- Criar botão da guia
    local tabButton = createElement("TextButton", {
        Size = UDim2.new(0, 80, 1, 0),
        BackgroundColor3 = GUIModule.colors.header,
        BorderSizePixel = 0,
        Text = name,
        TextColor3 = GUIModule.colors.text,
        TextSize = 14,
        Font = Enum.Font.SourceSansBold,
        AutoButtonColor = false
    })
    
    -- Criar conteúdo da guia
    local tabContent = createElement("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, -40),
        Position = UDim2.new(0, 0, 0, 40),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = GUIModule.colors.accent,
        Visible = false
    })
    
    -- Organizar elementos verticalmente
    local layout = createElement("UIListLayout", {
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder,
        HorizontalAlignment = Enum.HorizontalAlignment.Center
    })
    layout.Parent = tabContent
    
    -- Adicionar padding
    local padding = createElement("UIPadding", {
        PaddingTop = UDim.new(0, 10)
    })
    padding.Parent = tabContent
    
    -- Registrar guia
    GUIModule.tabs[name] = {
        button = tabButton,
        content = tabContent,
        elements = {}
    }
    
    -- Evento de clique
    tabButton.MouseButton1Click:Connect(function()
        -- Ocultar guia ativa
        if GUIModule.activeTab and GUIModule.tabs[GUIModule.activeTab] then
            GUIModule.tabs[GUIModule.activeTab].content.Visible = false
            GUIModule.tabs[GUIModule.activeTab].button.BackgroundColor3 = GUIModule.colors.header
        end
        
        -- Exibir guia selecionada
        GUIModule.tabs[name].content.Visible = true
        GUIModule.tabs[name].button.BackgroundColor3 = GUIModule.colors.accent
        
        -- Atualizar guia ativa
        GUIModule.activeTab = name
    end)
    
    return GUIModule.tabs[name]
end

-- Função para criar a interface
local function createGUI()
    -- Verificar se já existe
    if GUIModule.screenGui then
        return
    end
    
    -- Criar ScreenGui
    local screenGui = createElement("ScreenGui", {
        Name = "AdminScript",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 100
    })
    
    -- Inserir no jogador (robusto a diferentes executores)
    local parentGui = nil
    -- Tentar proteger e usar CoreGui (Synapse)
    pcall(function()
        if syn and type(syn.protect_gui) == "function" then
            syn.protect_gui(screenGui)
            parentGui = game:GetService("CoreGui")
        end
    end)
    -- Tentar usar gethui() quando disponível
    if not parentGui then
        if type(gethui) == "function" then
            local ok, res = pcall(gethui)
            if ok and res then
                parentGui = res
            end
        end
    end
    -- Fallback para PlayerGui
    if not parentGui then
        local pg = Player:FindFirstChildOfClass("PlayerGui")
        if pg then parentGui = pg end
    end
    -- Fallback final para CoreGui (pode falhar em alguns executores)
    screenGui.Parent = parentGui or game:GetService("CoreGui")
    
    -- Criar frame principal
    local mainFrame = createElement("Frame", {
        Size = UDim2.new(0, 400, 0, 300),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = GUIModule.colors.background,
        BorderSizePixel = 0
    })
    
    -- Cantos arredondados
    local corner = createElement("UICorner", {
        CornerRadius = UDim.new(0, 10)
    })
    corner.Parent = mainFrame
    
    -- Sombra
    local shadow = createElement("ImageLabel", {
        Size = UDim2.new(1, 30, 1, 30),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Image = "rbxassetid://6015897843",
        ImageTransparency = 0.5,
        ImageColor3 = Color3.new(0, 0, 0),
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(49, 49, 450, 450),
        ZIndex = 0
    })
    shadow.Parent = mainFrame
    
    -- Cabeçalho
    local header = createElement("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = GUIModule.colors.header,
        BorderSizePixel = 0
    })
    
    -- Cantos arredondados apenas no topo
    local headerCorner = createElement("UICorner", {
        CornerRadius = UDim.new(0, 10)
    })
    headerCorner.Parent = header
    
    -- Corrigir cantos do cabeçalho
    local headerFix = createElement("Frame", {
        Size = UDim2.new(1, 0, 0, 10),
        Position = UDim2.new(0, 0, 1, -10),
        BackgroundColor3 = GUIModule.colors.header,
        BorderSizePixel = 0
    })
    headerFix.Parent = header
    
    -- Título
    local title = createElement("TextLabel", {
        Size = UDim2.new(0, 150, 1, 0),
        BackgroundTransparency = 1,
        Text = "Admin Script v" .. Admin.version,
        TextColor3 = GUIModule.colors.text,
        TextSize = 16,
        Font = Enum.Font.SourceSansBold
    })
    title.Parent = header
    
    -- Botão fechar
    local closeButton = createElement("TextButton", {
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -35, 0, 5),
        BackgroundColor3 = Color3.fromRGB(255, 80, 80),
        BorderSizePixel = 0,
        Text = "X",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 16,
        Font = Enum.Font.SourceSansBold
    })
    
    local closeCorner = createElement("UICorner", {
        CornerRadius = UDim.new(0, 15)
    })
    closeCorner.Parent = closeButton
    closeButton.Parent = header
    
    header.Parent = mainFrame
    
    -- Container de guias
    local tabsContainer = createElement("Frame", {
        Size = UDim2.new(1, 0, 0, 30),
        Position = UDim2.new(0, 0, 0, 40),
        BackgroundColor3 = GUIModule.colors.header,
        BorderSizePixel = 0
    })
    
    -- Layout para as guias
    local tabLayout = createElement("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    tabLayout.Parent = tabsContainer
    
    tabsContainer.Parent = mainFrame
    
    -- Container de conteúdo
    local contentContainer = createElement("Frame", {
        Size = UDim2.new(1, 0, 1, -70),
        Position = UDim2.new(0, 0, 0, 70),
        BackgroundTransparency = 1,
        BorderSizePixel = 0
    })
    contentContainer.Parent = mainFrame
    
    -- Armazenar referências
    GUIModule.screenGui = screenGui
    GUIModule.mainFrame = mainFrame
    GUIModule.tabsContainer = tabsContainer
    GUIModule.contentContainer = contentContainer
    
    -- Adicionar guias
    local movementTab = createTab("Movimento")
    local characterTab = createTab("Personagem")
    local teleportTab = createTab("Teleporte")
    local visualTab = createTab("Visual")
    local miscTab = createTab("Outros")
    
    -- Adicionar botões das guias ao container
    for _, tab in pairs(GUIModule.tabs) do
        tab.button.Parent = tabsContainer
        tab.content.Parent = contentContainer
    end
    
    -- Ativar a primeira guia por padrão
    if movementTab then
        movementTab.button.BackgroundColor3 = GUIModule.colors.accent
        movementTab.content.Visible = true
        GUIModule.activeTab = "Movimento"
    end
    
    -- Adicionar funcionalidade de arrastar
    local isDragging = false
    local dragStart = nil
    local startPos = nil
    
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)
    
    header.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = false
        end
    end)
    
    Services.UserInputService.InputChanged:Connect(function(input)
        if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    -- Conectar evento de fechar
    closeButton.MouseButton1Click:Connect(function()
        GUIModule.screenGui.Enabled = false
        GUIModule.visible = false
    end)
    
    -- Adicionar botões de recursos
    -- Guia de movimento
    if Admin.Movement then
        -- Fly
        if Admin.Movement.fly then
            createFeatureButton(
                movementTab.content,
                "Modo de Voo",
                function() Admin.Movement.fly.toggle() end,
                function() return Admin.Movement.fly.isEnabled() end
            )
            
            -- Slider para velocidade de voo
            createSlider(
                movementTab.content,
                "Velocidade de Voo",
                10,
                200,
                Admin.Movement.fly.getSpeed(),
                function(value) Admin.Movement.fly.setSpeed(value) end
            )
        end
        
        -- Noclip
        if Admin.Movement.noclip then
            createFeatureButton(
                movementTab.content,
                "Atravessar Paredes (Noclip)",
                function() Admin.Movement.noclip.toggle() end,
                function() return Admin.Movement.noclip.isEnabled() end
            )
        end
        
        -- Speed
        if Admin.Movement.speed then
            createFeatureButton(
                movementTab.content,
                "Velocidade Normal",
                function() Admin.Movement.speed.reset() end,
                function() return not Admin.Movement.speed.isEnabled() end
            )
            
            createSlider(
                movementTab.content,
                "Velocidade de Movimento",
                16,
                200,
                Admin.Movement.speed.isEnabled() and Admin.Movement.speed.getCurrent() or 16,
                function(value) Admin.Movement.speed.set(value) end
            )
        end
    end
    
    -- Guia de personagem
    if Admin.Character then
        -- Godmode
        if Admin.Character.godmode then
            createFeatureButton(
                characterTab.content,
                "Modo Invencível",
                function() Admin.Character.godmode.toggle() end,
                function() return Admin.Character.godmode.isEnabled() end
            )
        end
    end
    
    -- Ajustar tamanho conforme conteúdo
    for _, tab in pairs(GUIModule.tabs) do
        local contentSize = tab.content:FindFirstChildOfClass("UIListLayout").AbsoluteContentSize
        tab.content.CanvasSize = UDim2.new(0, 0, 0, contentSize.Y + 20)
    end
    
    -- Iniciar invisível
    GUIModule.screenGui.Enabled = false
    GUIModule.visible = false
    
    mainFrame.Parent = screenGui
    
    return screenGui
end

-- Função para mostrar a GUI
local function showGUI()
    if not GUIModule.screenGui then
        createGUI()
    end
    
    GUIModule.screenGui.Enabled = true
    GUIModule.visible = true
end

-- Função para ocultar a GUI
local function hideGUI()
    if GUIModule.screenGui then
        GUIModule.screenGui.Enabled = false
        GUIModule.visible = false
    end
end

-- Função para alternar visibilidade
local function toggleGUI()
    if GUIModule.visible then
        hideGUI()
    else
        showGUI()
    end
end

-- Função para limpar a GUI
local function cleanupGUI()
    if GUIModule.screenGui then
        GUIModule.screenGui:Destroy()
        GUIModule.screenGui = nil
    end
    
    GUIModule.mainFrame = nil
    GUIModule.tabs = {}
    GUIModule.activeTab = nil
    GUIModule.visible = false
end

-- Exportar funções do módulo
local API = {
    create = createGUI,
    show = showGUI,
    hide = hideGUI,
    toggle = toggleGUI,
    cleanup = cleanupGUI,
    isVisible = function() return GUIModule.visible end
}

-- Registrar na API global
Admin.GUI.main = API

-- Mensagem de carregamento
print("✅ Módulo GUI carregado!")
print("💡 Use Admin.GUI.main.toggle() para mostrar/ocultar a interface")
print("💡 Digite /admin no chat para acessar a GUI")

-- Retornar API do módulo
return API