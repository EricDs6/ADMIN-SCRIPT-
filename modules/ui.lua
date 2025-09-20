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
  frame.Size = UDim2.new(0, 260, 0, 420)
  frame.Position = UDim2.new(0, 20, 0.5, -210)
  frame.BackgroundColor3 = Color3.fromRGB(25, 28, 40)
  frame.BorderSizePixel = 0
  frame.Parent = screenGui

  -- Header
  local header = Instance.new("Frame")
  header.Size = UDim2.new(1, 0, 0, 40)
  header.Position = UDim2.new(0, 0, 0, 0)
  header.BackgroundColor3 = Color3.fromRGB(35, 40, 55)
  header.BorderSizePixel = 0
  header.Parent = frame

  local headerTitle = Instance.new("TextLabel")
  headerTitle.Size = UDim2.new(0, 150, 1, 0)
  headerTitle.Position = UDim2.new(0, 10, 0, 0)
  headerTitle.BackgroundTransparency = 1
  headerTitle.Text = "FK7 Admin"
  headerTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
  headerTitle.Font = Enum.Font.GothamBold
  headerTitle.TextSize = 16
  headerTitle.TextXAlignment = Enum.TextXAlignment.Left
  headerTitle.Parent = header

  local minButton = Instance.new("TextButton")
  minButton.Size = UDim2.new(0, 30, 0, 30)
  minButton.Position = UDim2.new(1, -60, 0, 5)
  minButton.BackgroundColor3 = Color3.fromRGB(50, 55, 70)
  minButton.Text = "−"
  minButton.TextColor3 = Color3.fromRGB(255, 255, 255)
  minButton.Font = Enum.Font.GothamBold
  minButton.TextSize = 18
  minButton.Parent = header

  local closeButton = Instance.new("TextButton")
  closeButton.Size = UDim2.new(0, 30, 0, 30)
  closeButton.Position = UDim2.new(1, -30, 0, 5)
  closeButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
  closeButton.Text = "×"
  closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
  closeButton.Font = Enum.Font.GothamBold
  closeButton.TextSize = 18
  closeButton.Parent = header

  -- Content Frame
  local contentFrame = Instance.new("Frame")
  contentFrame.Size = UDim2.new(1, 0, 1, -40)
  contentFrame.Position = UDim2.new(0, 0, 0, 40)
  contentFrame.BackgroundTransparency = 1
  contentFrame.Parent = frame

  local list = Instance.new("UIListLayout")
  list.Padding = UDim.new(0, 6)
  list.Parent = contentFrame

  local function button(text, onClick)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -12, 0, 30)
    b.Position = UDim2.new(0, 6, 0, 0)
    b.BackgroundColor3 = Color3.fromRGB(40, 45, 65)
    b.TextColor3 = Color3.fromRGB(240, 240, 255)
    b.Font = Enum.Font.Gotham
    b.TextSize = 14
    b.Text = text
    b.Parent = contentFrame
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
      frame.Size = UDim2.new(0, 260, 0, 40)
      minButton.Text = "+"
    else
      contentFrame.Visible = true
      frame.Size = UDim2.new(0, 260, 0, 420)
      minButton.Text = "−"
    end
  end)

  -- Close logic
  closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
  end)

  local F = (ctx and ctx.features) or (getgenv and getgenv().FK7 and getgenv().FK7.Features) or {}

  if F.fly and F.fly.setup then F.fly.setup(Core) end
  if F.teleport and F.teleport.setup then F.teleport.setup(Core) end
  if F.player and F.player.setup then F.player.setup(Core) end
  if F.world and F.world.setup then F.world.setup(Core) end
  if F.stick and F.stick.setup then F.stick.setup(Core) end

  if F.fly then
    button("Voo: OFF", function()
      F.fly.toggle()
    end)
  end
  if F.teleport then
    button("TP ao Clicar: OFF", function()
      F.teleport.toggleClickTP()
    end)
  end
  if F.player then
    button("Velocidade Hack: OFF", function()
      F.player.toggleSpeed()
    end)
    button("Pulo Hack: OFF", function()
      F.player.toggleJump()
    end)
    button("Invisível: OFF", function()
      F.player.toggleInvisible()
    end)
  end
  if F.world then
    button("Brilho Total: OFF", function()
      F.world.toggleFullBright()
    end)
    button("Raio-X: OFF", function()
      F.world.toggleXray()
    end)
  end
  if F.stick then
    button("Grudar (Seat/Weld)", function()
      F.stick.stickToMouseTarget()
    end)
    button("Soltar", function()
      F.stick.unstick()
    end)
  end
end

return UI
