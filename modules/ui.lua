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

  local function createTab(name, order)
    local tabButton = Instance.new("TextButton")
    tabButton.Size = UDim2.new(0, 80, 1, 0)
    tabButton.BackgroundColor3 = Color3.fromRGB(30, 35, 50)
    tabButton.TextColor3 = Color3.fromRGB(200, 200, 220)
    tabButton.Font = Enum.Font.GothamBold
    tabButton.TextSize = 14
    tabButton.Text = name
    tabButton.LayoutOrder = order
    tabButton.Parent = tabFrame

    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 8)
    tabCorner.Parent = tabButton

    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1, 0, 1, 0)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.CanvasSize = UDim2.new(0, 0, 0, 0)
    content.ScrollBarThickness = 6
    content.Visible = false
    content.Parent = contentFrame

    local list = Instance.new("UIListLayout")
    list.Padding = UDim.new(0, 8)
    list.HorizontalAlignment = Enum.HorizontalAlignment.Center
    list.Parent = content

    tabs[name] = tabButton
    tabContents[name] = content
    return tabButton, content
  end

  local function switchTab(name)
    for n, c in pairs(tabContents) do
      c.Visible = (n == name)
    end
    for n, b in pairs(tabs) do
      b.BackgroundColor3 = (n == name) and Color3.fromRGB(50, 55, 75) or Color3.fromRGB(30, 35, 50)
    end
  end

  createTab("Movimento", 1)
  createTab("Jogador", 2)
  createTab("Mundo", 3)

  for name, button in pairs(tabs) do
    button.MouseButton1Click:Connect(function()
      switchTab(name)
    end)
  end

  switchTab("Movimento") -- Aba padrão

  local function createFeatureButton(parent, text, onClick)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 240, 0, 35)
    b.BackgroundColor3 = Color3.fromRGB(40, 45, 65)
    b.TextColor3 = Color3.fromRGB(240, 240, 255)
    b.Font = Enum.Font.Gotham
    b.TextSize = 14
    b.Text = text
    b.AutoButtonColor = false
    b.Parent = parent

    local bCorner = Instance.new("UICorner")
    bCorner.CornerRadius = UDim.new(0, 8)
    bCorner.Parent = b

    b.MouseEnter:Connect(function()
      b.BackgroundColor3 = Color3.fromRGB(60, 65, 85)
    end)
    b.MouseLeave:Connect(function()
      b.BackgroundColor3 = Color3.fromRGB(40, 45, 65)
    end)

    b.MouseButton1Click:Connect(onClick)
    return b
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
    createFeatureButton(tabContents["Movimento"], "Voo: OFF", function() F.fly.toggle() end)
  end
  if F.teleport then
    createFeatureButton(tabContents["Movimento"], "TP ao Clicar: OFF", function() F.teleport.toggleClickTP() end)
  end
  if F.player then
    createFeatureButton(tabContents["Jogador"], "Velocidade Hack: OFF", function() F.player.toggleSpeed() end)
    createFeatureButton(tabContents["Jogador"], "Pulo Hack: OFF", function() F.player.toggleJump() end)
    createFeatureButton(tabContents["Jogador"], "Invisível: OFF", function() F.player.toggleInvisible() end)
  end
  if F.world then
    createFeatureButton(tabContents["Mundo"], "Brilho Total: OFF", function() F.world.toggleFullBright() end)
    createFeatureButton(tabContents["Mundo"], "Raio-X: OFF", function() F.world.toggleXray() end)
  end
  if F.stick then
    createFeatureButton(tabContents["Mundo"], "Grudar (Seat/Weld)", function() F.stick.stickToMouseTarget() end)
    createFeatureButton(tabContents["Mundo"], "Soltar", function() F.stick.unstick() end)
  end
end

return UI
