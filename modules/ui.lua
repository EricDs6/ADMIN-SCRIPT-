-- modules/ui.lua
-- UI simples: registra funções e cria botões

local Core = getgenv().FK7 and getgenv().FK7.Core or require(script.Parent.core)
local state = Core.state()
local S = Core.services()

local UI = {}

local playerGui = state.player:WaitForChild("PlayerGui")
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FK7_GUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 260, 0, 420)
frame.Position = UDim2.new(0, 20, 0.5, -210)
frame.BackgroundColor3 = Color3.fromRGB(25, 28, 40)
frame.Parent = screenGui

local list = Instance.new("UIListLayout")
list.Padding = UDim.new(0, 6)
list.Parent = frame

local function button(text, onClick)
  local b = Instance.new("TextButton")
  b.Size = UDim2.new(1, -12, 0, 30)
  b.Position = UDim2.new(0, 6, 0, 0)
  b.BackgroundColor3 = Color3.fromRGB(40, 45, 65)
  b.TextColor3 = Color3.fromRGB(240, 240, 255)
  b.Font = Enum.Font.Gotham
  b.TextSize = 14
  b.Text = text
  b.Parent = frame
  b.MouseButton1Click:Connect(onClick)
  return b
end

function UI.init(ctx)
  local F = ctx.features
  -- Cada feature expõe toggle/init e retorna enabled
  if F.fly and F.fly.setup then F.fly.setup(Core) end
  if F.teleport and F.teleport.setup then F.teleport.setup(Core) end
  if F.player and F.player.setup then F.player.setup(Core) end
  if F.world and F.world.setup then F.world.setup(Core) end
  if F.stick and F.stick.setup then F.stick.setup(Core) end

  if F.fly then
    button("Voo: OFF", function()
      local on = F.fly.toggle()
    end)
  end
  if F.teleport then
    button("TP ao Clicar: OFF", function()
      local on = F.teleport.toggleClickTP()
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
