-- modules/ui.lua
-- UI simples: registra funções e cria botões (lazy init)

local UI = {}

function UI.init(ctx)
  -- Resolver Core tardiamente (passado pelo loader) e montar UI agora
  local Core = (ctx and ctx.core) or (getgenv and getgenv().FK7 and getgenv().FK7.Core)
  assert(Core, "UI.init: Core ausente")
  local state = Core.state()
  local uis = Core.services().UserInputService

  local playerGui = state.player:WaitForChild("PlayerGui")
  local screenGui = Instance.new("ScreenGui")
  screenGui.Name = "FK7_GUI"
  screenGui.ResetOnSpawn = false
  screenGui.Parent = playerGui

  local frame = Instance.new("Frame")
  frame.Size = UDim2.new(0, 280, 0, 450)
  frame.Position = UDim2.new(0, 20, 0.5, -225)
  frame.BackgroundColor3 = Color3.fromRGB(20, 23, 35)
  frame.BorderSizePixel = 0
  frame.Parent = screenGui

  -- Gradiente para o frame principal
  local frameGradient = Instance.new("UIGradient")
  frameGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 28, 40)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(20, 23, 35)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 18, 28))
  }
  frameGradient.Rotation = 90
  frameGradient.Parent = frame

  -- Bordas arredondadas para o frame
  local frameCorner = Instance.new("UICorner")
  frameCorner.CornerRadius = UDim.new(0, 15)
  frameCorner.Parent = frame

  -- Borda sutil
  local frameStroke = Instance.new("UIStroke")
  frameStroke.Color = Color3.fromRGB(60, 70, 90)
  frameStroke.Thickness = 1
  frameStroke.Transparency = 0.8
  frameStroke.Parent = frame

  -- Header
  local header = Instance.new("Frame")
  header.Size = UDim2.new(1, 0, 0, 45)
  header.Position = UDim2.new(0, 0, 0, 0)
  header.BackgroundColor3 = Color3.fromRGB(30, 35, 50)
  header.BorderSizePixel = 0
  header.Parent = frame

  -- Gradiente para o header
  local headerGradient = Instance.new("UIGradient")
  headerGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 150)),
    ColorSequenceKeypoint.new(0.3, Color3.fromRGB(255, 180, 100)),
    ColorSequenceKeypoint.new(0.6, Color3.fromRGB(100, 200, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 100, 255))
  }
  headerGradient.Parent = header

  -- Bordas arredondadas para o header
  local headerCorner = Instance.new("UICorner")
  headerCorner.CornerRadius = UDim.new(0, 15)
  headerCorner.Parent = header

  -- Borda para o header
  local headerStroke = Instance.new("UIStroke")
  headerStroke.Color = Color3.fromRGB(80, 90, 120)
  headerStroke.Thickness = 1.5
  headerStroke.Transparency = 0.6
  headerStroke.Parent = header

  local headerTitle = Instance.new("TextLabel")
  headerTitle.Size = UDim2.new(0, 160, 1, 0)
  headerTitle.Position = UDim2.new(0, 15, 0, 0)
  headerTitle.BackgroundTransparency = 1
  headerTitle.Text = "FK7 Admin Panel"
  headerTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
  headerTitle.Font = Enum.Font.GothamBold
  headerTitle.TextSize = 18
  headerTitle.TextXAlignment = Enum.TextXAlignment.Left
  headerTitle.Parent = header

  local minButton = Instance.new("TextButton")
  minButton.Size = UDim2.new(0, 35, 0, 35)
  minButton.Position = UDim2.new(1, -75, 0, 5)
  minButton.BackgroundColor3 = Color3.fromRGB(50, 55, 70)
  minButton.Text = "−"
  minButton.TextColor3 = Color3.fromRGB(255, 255, 255)
  minButton.Font = Enum.Font.GothamBold
  minButton.TextSize = 20
  minButton.AutoButtonColor = false
  minButton.Parent = header

  -- Hover effect para minButton
  minButton.MouseEnter:Connect(function()
    minButton.BackgroundColor3 = Color3.fromRGB(70, 75, 90)
  end)
  minButton.MouseLeave:Connect(function()
    minButton.BackgroundColor3 = Color3.fromRGB(50, 55, 70)
  end)

  local closeButton = Instance.new("TextButton")
  closeButton.Size = UDim2.new(0, 35, 0, 35)
  closeButton.Position = UDim2.new(1, -35, 0, 5)
  closeButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
  closeButton.Text = "×"
  closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
  closeButton.Font = Enum.Font.GothamBold
  closeButton.TextSize = 20
  closeButton.AutoButtonColor = false
  closeButton.Parent = header

  -- Hover effect para closeButton
  closeButton.MouseEnter:Connect(function()
    closeButton.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
  end)
  closeButton.MouseLeave:Connect(function()
    closeButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
  end)

  -- Content Frame
  local contentFrame = Instance.new("Frame")
  contentFrame.Size = UDim2.new(1, -20, 1, -100)
  contentFrame.Position = UDim2.new(0, 10, 0, 90)
  contentFrame.BackgroundTransparency = 1
  contentFrame.Parent = frame

  -- Tab Buttons
  local tabFrame = Instance.new("Frame")
  tabFrame.Size = UDim2.new(1, -20, 0, 40)
  tabFrame.Position = UDim2.new(0, 10, 0, 45)
  tabFrame.BackgroundTransparency = 1
  tabFrame.Parent = frame

  local tabLayout = Instance.new("UIListLayout")
  tabLayout.FillDirection = Enum.FillDirection.Horizontal
  tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
  tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
  tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
  tabLayout.Padding = UDim.new(0, 5)
  tabLayout.Parent = tabFrame

  local tabs = {}
  local tabContents = {}

  local function createTab(name, order, icon)
    local tabButton = Instance.new("TextButton")
    tabButton.Size = UDim2.new(0, 85, 1, 0)
    tabButton.BackgroundColor3 = Color3.fromRGB(30, 35, 50)
    tabButton.TextColor3 = Color3.fromRGB(200, 200, 220)
    tabButton.Font = Enum.Font.GothamBold
    tabButton.TextSize = 12
    tabButton.Text = icon .. " " .. name
    tabButton.LayoutOrder = order
    tabButton.AutoButtonColor = false
    tabButton.Parent = tabFrame

    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 8)
    tabCorner.Parent = tabButton

    local tabStroke = Instance.new("UIStroke")
    tabStroke.Color = Color3.fromRGB(60, 70, 90)
    tabStroke.Thickness = 1
    tabStroke.Transparency = 0.8
    tabStroke.Parent = tabButton

    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1, 0, 1, 0)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.CanvasSize = UDim2.new(0, 0, 0, 0)
    content.ScrollBarThickness = 6
    content.ScrollBarImageColor3 = Color3.fromRGB(100, 150, 255)
    content.Visible = false
    content.Parent = contentFrame

    local list = Instance.new("UIListLayout")
    list.Padding = UDim.new(0, 8)
    list.HorizontalAlignment = Enum.HorizontalAlignment.Center
    list.Parent = content

    -- Auto-resize canvas
    list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
      content.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + 20)
    end)

    tabs[name] = {button = tabButton, stroke = tabStroke}
    tabContents[name] = content
    return tabButton, content
  end

  local function switchTab(name)
    for n, c in pairs(tabContents) do
      c.Visible = (n == name)
    end
    for n, t in pairs(tabs) do
      if n == name then
        t.button.BackgroundColor3 = Color3.fromRGB(50, 55, 75)
        t.stroke.Color = Color3.fromRGB(100, 150, 255)
        t.stroke.Transparency = 0.4
      else
        t.button.BackgroundColor3 = Color3.fromRGB(30, 35, 50)
        t.stroke.Color = Color3.fromRGB(60, 70, 90)
        t.stroke.Transparency = 0.8
      end
    end
  end

  createTab("Movimento", 1, "🚀")
  createTab("Jogador", 2, "👤")
  createTab("Mundo", 3, "🌍")

  for name, tabData in pairs(tabs) do
    tabData.button.MouseButton1Click:Connect(function()
      switchTab(name)
    end)
  end

  switchTab("Movimento") -- Aba padrão

  local function createFeatureButton(parent, text, icon, onClick)
    local buttonFrame = Instance.new("Frame")
    buttonFrame.Size = UDim2.new(0, 240, 0, 40)
    buttonFrame.BackgroundColor3 = Color3.fromRGB(40, 45, 65)
    buttonFrame.Parent = parent

    local bCorner = Instance.new("UICorner")
    bCorner.CornerRadius = UDim.new(0, 8)
    bCorner.Parent = buttonFrame

    local bStroke = Instance.new("UIStroke")
    bStroke.Color = Color3.fromRGB(80, 90, 110)
    bStroke.Thickness = 1
    bStroke.Transparency = 0.7
    bStroke.Parent = buttonFrame

    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.new(0, 30, 1, 0)
    iconLabel.Position = UDim2.new(0, 8, 0, 0)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = icon
    iconLabel.TextColor3 = Color3.fromRGB(100, 150, 255)
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.TextSize = 18
    iconLabel.TextXAlignment = Enum.TextXAlignment.Center
    iconLabel.Parent = buttonFrame

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(0, 50, 1, 0)
    statusLabel.Position = UDim2.new(1, -55, 0, 0)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "OFF"
    statusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    statusLabel.Font = Enum.Font.GothamBold
    statusLabel.TextSize = 12
    statusLabel.TextXAlignment = Enum.TextXAlignment.Center
    statusLabel.Parent = buttonFrame

    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 1, 0)
    b.Position = UDim2.new(0, 0, 0, 0)
    b.BackgroundTransparency = 1
    b.TextColor3 = Color3.fromRGB(240, 240, 255)
    b.Font = Enum.Font.Gotham
    b.TextSize = 14
    b.Text = text
    b.TextXAlignment = Enum.TextXAlignment.Left
    b.AutoButtonColor = false
    b.Parent = buttonFrame

    -- Ajustar posição do texto para dar espaço ao ícone
    local textPadding = Instance.new("UIPadding")
    textPadding.PaddingLeft = UDim.new(0, 40)
    textPadding.PaddingRight = UDim.new(0, 60)
    textPadding.Parent = b

    -- Função para atualizar estado visual
    local function updateStatus(isOn)
      if isOn then
        statusLabel.Text = "ON"
        statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        buttonFrame.BackgroundColor3 = Color3.fromRGB(50, 70, 50)
        bStroke.Color = Color3.fromRGB(100, 255, 100)
        iconLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
      else
        statusLabel.Text = "OFF"
        statusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
        buttonFrame.BackgroundColor3 = Color3.fromRGB(40, 45, 65)
        bStroke.Color = Color3.fromRGB(80, 90, 110)
        iconLabel.TextColor3 = Color3.fromRGB(100, 150, 255)
      end
    end

    -- Hover effects
    b.MouseEnter:Connect(function()
      if statusLabel.Text == "ON" then
        buttonFrame.BackgroundColor3 = Color3.fromRGB(60, 80, 60)
      else
        buttonFrame.BackgroundColor3 = Color3.fromRGB(60, 65, 85)
      end
    end)

    b.MouseLeave:Connect(function()
      if statusLabel.Text == "ON" then
        buttonFrame.BackgroundColor3 = Color3.fromRGB(50, 70, 50)
      else
        buttonFrame.BackgroundColor3 = Color3.fromRGB(40, 45, 65)
      end
    end)

    b.MouseButton1Click:Connect(function()
      local result = onClick()
      if result ~= nil then
        updateStatus(result)
      end
    end)

    return buttonFrame, updateStatus
  end

  -- Drag logic
  local dragging = false
  local dragStart = nil
  local startPos = nil

  header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
      dragging = true
      dragStart = input.Position
      startPos = frame.Position
    end
  end)

  uis.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
      local delta = input.Position - dragStart
      frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
  end)

  uis.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
      dragging = false
    end
  end)

  -- Minimize logic
  local minimized = false
  minButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
      contentFrame.Visible = false
      tabFrame.Visible = false
      frame.Size = UDim2.new(0, 280, 0, 45)
      minButton.Text = "+"
    else
      contentFrame.Visible = true
      tabFrame.Visible = true
      frame.Size = UDim2.new(0, 280, 0, 450)
      minButton.Text = "−"
    end
  end)

  -- Close logic
  closeButton.MouseButton1Click:Connect(function()
    -- Desligar todas as features antes de fechar
    local F = (ctx and ctx.features) or (getgenv and getgenv().FK7 and getgenv().FK7.Features) or {}
    if F.fly and F.fly.disable then F.fly.disable() end
    if F.teleport and F.teleport.disable then F.teleport.disable() end
    if F.player and F.player.disable then F.player.disable() end
    if F.world and F.world.disable then F.world.disable() end
    if F.stick and F.stick.disable then F.stick.disable() end
    
    Core.cleanup()
    screenGui:Destroy()
    print("[FK7] Script encerrado completamente.")
  end)

  local F = (ctx and ctx.features) or (getgenv and getgenv().FK7 and getgenv().FK7.Features) or {}

  if F.fly and F.fly.setup then F.fly.setup(Core) end
  if F.teleport and F.teleport.setup then F.teleport.setup(Core) end
  if F.player and F.player.setup then F.player.setup(Core) end
  if F.world and F.world.setup then F.world.setup(Core) end
  if F.stick and F.stick.setup then F.stick.setup(Core) end

  -- Adicionar botões às abas corretas
  if F.fly then
    createFeatureButton(tabContents["Movimento"], "Voo", "✈️", function() 
      return F.fly.toggle() 
    end)
  end
  if F.teleport then
    createFeatureButton(tabContents["Movimento"], "TP ao Clicar", "📍", function() 
      return F.teleport.toggleClickTP() 
    end)
  end
  if F.player then
    createFeatureButton(tabContents["Jogador"], "Velocidade Hack", "⚡", function() 
      return F.player.toggleSpeed() 
    end)
    createFeatureButton(tabContents["Jogador"], "Pulo Hack", "🦘", function() 
      return F.player.toggleJump() 
    end)
    createFeatureButton(tabContents["Jogador"], "Invisível", "👻", function() 
      return F.player.toggleInvisible() 
    end)
  end
  if F.world then
    createFeatureButton(tabContents["Mundo"], "Brilho Total", "💡", function() 
      return F.world.toggleFullBright() 
    end)
    createFeatureButton(tabContents["Mundo"], "Raio-X", "🔍", function() 
      return F.world.toggleXray() 
    end)
  end
  if F.stick then
    createFeatureButton(tabContents["Mundo"], "Grudar", "🔗", function() 
      F.stick.stickToMouseTarget()
    end)
    createFeatureButton(tabContents["Mundo"], "Soltar", "🔓", function() 
      F.stick.unstick()
    end)
  end
end

return UI
