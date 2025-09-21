-- Módulo de GUI Principal
-- Funcionalidade: Interface gráfica modular com botões para diferentes módulos
-- Carregado via _G.AdminScript

-- Verificar se AdminScript está disponível
local Admin = _G.AdminScript
if not Admin then
    warn("❌ Sistema AdminScript não inicializado!")
    return
end

local Services = Admin.Services
local Player = Admin.Player

print("🖼️ Carregando módulo de GUI...")

-- Estado do módulo
local GUIModule = {
    screenGui = nil,
    mainFrame = nil,
    minimizedButton = nil,
    buttons = {},
    isMinimized = false
}

-- Função para criar a estrutura base da GUI
local function createBaseGUI()
    -- Verificar se já existe
    local existingGUI = Player.PlayerGui:FindFirstChild("AdminGUI")
    if existingGUI then
        existingGUI:Destroy()
    end
    
    -- ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AdminGUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = Player.PlayerGui
    
    -- Frame principal
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 280, 0, 200)
    mainFrame.Position = UDim2.new(0, 20, 0.5, -100)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    -- Estilo do frame principal
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
    title.Text = "🛠️ Admin Script"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = titleBar
    
    -- Container para conteúdo
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, 0, 1, -35)
    contentFrame.Position = UDim2.new(0, 0, 0, 35)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = mainFrame
    
    -- Layout para organizar botões
    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 5)
    listLayout.Parent = contentFrame
    
    -- Padding interno
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 10)
    padding.PaddingBottom = UDim.new(0, 10)
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingRight = UDim.new(0, 10)
    padding.Parent = contentFrame
    
    -- Armazenar referências
    GUIModule.screenGui = screenGui
    GUIModule.mainFrame = mainFrame
    GUIModule.contentFrame = contentFrame
    GUIModule.titleBar = titleBar
    
    return mainFrame, contentFrame, titleBar
end

-- Função para criar botões de controle da janela
local function createWindowControls(titleBar)
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
    
    -- Funcionalidades
    minimizeBtn.MouseButton1Click:Connect(function()
        toggleMinimize()
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        if _G.AdminScript and _G.AdminScript.Cleanup then
            _G.AdminScript.Cleanup()
        end
    end)
end

-- Função para criar um botão modular
local function createModuleButton(parent, text, layoutOrder, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 35)
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.Gotham
    button.TextSize = 12
    button.AutoButtonColor = false
    button.LayoutOrder = layoutOrder
    button.Parent = parent
    
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
        button.MouseButton1Click:Connect(function()
            pcall(callback, button)
        end)
    end
    
    return button
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

-- Função para minimizar/restaurar GUI
function toggleMinimize()
    if GUIModule.isMinimized then
        -- Restaurar
        if GUIModule.mainFrame then
            GUIModule.mainFrame.Visible = true
        end
        if GUIModule.minimizedButton then
            GUIModule.minimizedButton:Destroy()
            GUIModule.minimizedButton = nil
        end
        GUIModule.isMinimized = false
    else
        -- Minimizar
        if GUIModule.mainFrame then
            GUIModule.mainFrame.Visible = false
        end
        
        -- Criar botão flutuante
        local floatingBtn = Instance.new("TextButton")
        floatingBtn.Size = UDim2.new(0, 80, 0, 30)
        floatingBtn.Position = UDim2.new(1, -100, 0, 20)
        floatingBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
        floatingBtn.Text = "🛠️ Admin"
        floatingBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        floatingBtn.Font = Enum.Font.Gotham
        floatingBtn.TextSize = 10
        floatingBtn.BorderSizePixel = 0
        floatingBtn.Parent = GUIModule.screenGui
        
        local floatCorner = Instance.new("UICorner")
        floatCorner.CornerRadius = UDim.new(0, 6)
        floatCorner.Parent = floatingBtn
        
        floatingBtn.MouseButton1Click:Connect(function()
            toggleMinimize()
        end)
        
        GUIModule.minimizedButton = floatingBtn
        GUIModule.isMinimized = true
    end
end

-- Função para adicionar módulo à GUI
local function addModule(moduleName, moduleData)
    if not GUIModule.contentFrame then return end
    
    local layoutOrder = #GUIModule.buttons + 1
    local button = createModuleButton(
        GUIModule.contentFrame,
        moduleData.displayName .. ": OFF",
        layoutOrder,
        function(btn)
            if moduleData.toggle then
                local newState = moduleData.toggle()
                updateButtonState(btn, newState, moduleData.displayName)
            end
        end
    )
    
    GUIModule.buttons[moduleName] = {
        button = button,
        data = moduleData
    }
    
    return button
end

-- Função para remover módulo da GUI
local function removeModule(moduleName)
    if GUIModule.buttons[moduleName] then
        if GUIModule.buttons[moduleName].button then
            GUIModule.buttons[moduleName].button:Destroy()
        end
        GUIModule.buttons[moduleName] = nil
    end
end

-- Função para atualizar estado de um módulo específico
local function updateModuleState(moduleName, enabled)
    if GUIModule.buttons[moduleName] then
        local moduleData = GUIModule.buttons[moduleName].data
        local button = GUIModule.buttons[moduleName].button
        updateButtonState(button, enabled, moduleData.displayName)
    end
end

-- Função principal para criar GUI completa
local function createGUI()
    local mainFrame, contentFrame, titleBar = createBaseGUI()
    createWindowControls(titleBar)
    
    -- Registrar módulos disponíveis
    addModule("fly", {
        displayName = "Voo",
        toggle = function()
            if Admin.Movement and Admin.Movement.Fly then
                return Admin.Movement.Fly.toggle()
            end
            return false
        end
    })
    
    addModule("noclip", {
        displayName = "Atravessar",
        toggle = function()
            if Admin.Movement and Admin.Movement.Noclip then
                return Admin.Movement.Noclip.toggle()
            end
            return false
        end
    })
    
    print("🖼️ GUI modular criada!")
end

-- Registrar funções no sistema global
if not Admin.GUI then
    Admin.GUI = {}
end

Admin.GUI.Module = {
    create = createGUI,
    addModule = addModule,
    removeModule = removeModule,
    updateState = updateModuleState,
    toggleMinimize = toggleMinimize,
    -- Compatibilidade
    ScreenGui = function() return GUIModule.screenGui end,
    MainFrame = function() return GUIModule.mainFrame end
}

-- Registrar no sistema de conexões para limpeza
Admin.Connections.GUIModule = GUIModule

print("✅ Módulo de GUI carregado!")
print("💡 Use Admin.GUI.Module.create() para criar a interface")