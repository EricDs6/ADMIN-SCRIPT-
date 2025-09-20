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
}

local function http_get(url)
  local bust = tostring(os.clock()):gsub("%.", "")
  local finalUrl = url .. "?t=" .. bust
  return game:HttpGet(finalUrl)
end

local modules_to_load = {"core", "ui", "fly", "noclip", "speed", "teleport"}
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
  -- fallback local
  local path = "modules/"..name..".lua"
  if readfile then
    local ok, src = pcall(readfile, path)
    if ok and src then
      local chunk, err = loadstring(src)
      if chunk then
        local ok2, mod = pcall(chunk)
        if ok2 and mod then
            update_loading_progress(name)
            return mod
        end
      end
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
    if child:IsA("GuiObject") then
        local childTween = TweenService:Create(child, tweenInfo, {
            TextTransparency = 1, 
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
