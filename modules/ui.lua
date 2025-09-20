-- modules/ui.lua - UI mínima com 1 botão
local UI = {}

function UI.init(ctx)
  local Core = ctx.core
  local st = Core.state()
  local playerGui = st.player:WaitForChild("PlayerGui")

  local gui = Instance.new("ScreenGui")
  gui.Name = "FK7_MIN"
  gui.ResetOnSpawn = false
  gui.Parent = playerGui

  local frame = Instance.new("Frame")
  frame.Size = UDim2.new(0, 220, 0, 120)
  frame.Position = UDim2.new(0, 20, 0.5, -60)
  frame.BackgroundColor3 = Color3.fromRGB(25, 28, 35)
  frame.BorderSizePixel = 0
  frame.Parent = gui

  local title = Instance.new("TextLabel")
  title.Size = UDim2.new(1, -10, 0, 30)
  title.Position = UDim2.new(0, 5, 0, 5)
  title.BackgroundTransparency = 1
  title.Font = Enum.Font.GothamBold
  title.TextSize = 16
  title.TextColor3 = Color3.new(1,1,1)
  title.Text = "FK7 Minimal"
  title.Parent = frame

  local btn = Instance.new("TextButton")
  btn.Size = UDim2.new(1, -20, 0, 40)
  btn.Position = UDim2.new(0, 10, 0, 60)
  btn.Text = "✈️ Voo"
  btn.Font = Enum.Font.Gotham
  btn.TextSize = 16
  btn.TextColor3 = Color3.new(1,1,1)
  btn.BackgroundColor3 = Color3.fromRGB(40, 45, 65)
  btn.Parent = frame

  btn.MouseButton1Click:Connect(function()
    local enabled = ctx.features.fly.toggle()
    btn.Text = enabled and "✈️ Voo (ON)" or "✈️ Voo (OFF)"
  end)
end

return UI
