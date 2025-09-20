-- mod_loader.lua - Carregador Principal FK7 Admin-- Loader com tela de carregamento: carrega módulos remotos ou locais e inicia UI

-- Script autocontido para Roblox - Cole no seu executor

local TweenService = game:GetService("TweenService")

-- Serviços necessários

local Players = game:GetService("Players")-- Tela de Carregamento

local RunService = game:GetService("RunService")local function create_loading_ui()

    local playerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

-- Verificar se já está carregado    if playerGui:FindFirstChild("FK7_Loading") then

if _G.FK7_LOADED then        playerGui.FK7_Loading:Destroy()

    warn("[FK7] Script já está carregado!")    end

    return

end    local screenGui = Instance.new("ScreenGui")

_G.FK7_LOADED = true    screenGui.Name = "FK7_Loading"

    screenGui.ResetOnSpawn = false

print("🚀 FK7 Admin - Carregando módulos...")    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    screenGui.Parent = playerGui

-- Sistema de módulos

local Modules = {    local background = Instance.new("Frame")

    core = nil,    background.Size = UDim2.new(1, 0, 1, 0)

    features = {},    background.BackgroundColor3 = Color3.fromRGB(20, 22, 28)

    ui = nil    background.BackgroundTransparency = 0.2

}    background.Parent = screenGui



-- Função para carregar módulos    local container = Instance.new("Frame")

local function loadModule(name, source)    container.Size = UDim2.new(0, 300, 0, 80)

    local success, module = pcall(loadstring, source)    container.Position = UDim2.new(0.5, -150, 0.5, -40)

    if success and module then    container.BackgroundColor3 = Color3.fromRGB(35, 40, 50)

        return module()    container.BorderSizePixel = 0

    else    container.Parent = screenGui

        warn("[FK7] Erro ao carregar módulo " .. name .. ":", module)    Instance.new("UICorner", container).CornerRadius = UDim.new(0, 8)

        return nil

    end    local title = Instance.new("TextLabel", container)

end    title.Size = UDim2.new(1, 0, 0, 30)

    title.BackgroundTransparency = 1

-- Carregar Core    title.Font = Enum.Font.GothamBold

Modules.core = loadModule("core", [[    title.Text = "FK7 Admin"

-- modules/core.lua - Gerenciador de estado e conexões    title.TextColor3 = Color3.new(1, 1, 1)

local Core = {}    title.TextSize = 18

local Players = game:GetService("Players")

local RunService = game:GetService("RunService")    local status = Instance.new("TextLabel", container)

    status.Size = UDim2.new(1, -20, 0, 20)

local state = {    status.Position = UDim2.new(0, 10, 0, 55)

    player = Players.LocalPlayer,    status.BackgroundTransparency = 1

    character = nil,    status.Font = Enum.Font.Gotham

    humanoid = nil,    status.Text = "Iniciando..."

    humanoidRootPart = nil,    status.TextColor3 = Color3.fromRGB(200, 200, 200)

    connections = {},    status.TextSize = 14

    activeModules = {},    status.TextXAlignment = Enum.TextXAlignment.Left

    originalValues = {}

}    local barBg = Instance.new("Frame", container)

    barBg.Size = UDim2.new(1, -20, 0, 10)

function Core.state()    barBg.Position = UDim2.new(0, 10, 0, 40)

    return state    barBg.BackgroundColor3 = Color3.fromRGB(25, 28, 35)

end    Instance.new("UICorner", barBg).CornerRadius = UDim.new(0, 5)



function Core.init()    local barFill = Instance.new("Frame", barBg)

    -- Inicializar estado do jogador    barFill.Size = UDim2.new(0, 0, 1, 0)

    state.character = state.player.Character or state.player.CharacterAdded:Wait()    barFill.BackgroundColor3 = Color3.fromRGB(70, 120, 220)

    state.humanoid = state.character:WaitForChild("Humanoid")    Instance.new("UICorner", barFill).CornerRadius = UDim.new(0, 5)

    state.humanoidRootPart = state.character:WaitForChild("HumanoidRootPart")

    return {

    -- Conectar evento de respawn        gui = screenGui,

    state.connections.characterAdded = state.player.CharacterAdded:Connect(function(newChar)        background = background,

        Core.onCharacterRespawn(newChar)        status = status,

    end)        bar = barFill,

        container = container

    print("[FK7 Core] Inicializado com sucesso!")    }

    return stateend

end

local loadingUI = create_loading_ui()

function Core.onCharacterRespawn(newChar)

    -- Atualizar referênciaslocal SOURCE = {

    state.character = newChar  core = "https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-RBX/main/modules/core.lua",

    state.humanoid = newChar:WaitForChild("Humanoid")  ui   = "https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-RBX/main/modules/ui.lua",

    state.humanoidRootPart = newChar:WaitForChild("HumanoidRootPart")  fly  = "https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-RBX/main/modules/fly.lua",

  noclip = "https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-RBX/main/modules/noclip.lua",

    -- Reaplicar módulos ativos  speed = "https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-RBX/main/modules/speed.lua",

    for moduleName, isEnabled in pairs(state.activeModules) do  teleport = "https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-RBX/main/modules/teleport.lua",

        if isEnabled and Core[moduleName] and Core[moduleName].enable then  godmode = "https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-RBX/main/modules/godmode.lua",

            pcall(function()  infinitejump = "https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-RBX/main/modules/infinitejump.lua",

                Core[moduleName].enable()  fullbright = "https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-RBX/main/modules/fullbright.lua",

            end)  nofalldamage = "https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-RBX/main/modules/nofalldamage.lua",

        end  xray = "https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-RBX/main/modules/xray.lua",

    end  esp = "https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-RBX/main/modules/esp.lua",

  lowgravity = "https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-RBX/main/modules/lowgravity.lua",

    print("[FK7 Core] Personagem respawnado, módulos reaplicados!")  instantrespawn = "https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-RBX/main/modules/instantrespawn.lua",

end  clicktp = "https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-RBX/main/modules/clicktp.lua",

  autofarm = "https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-RBX/main/modules/autofarm.lua",

function Core.registerModule(moduleName, moduleTable)  walkthrough = "https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-RBX/main/modules/walkthrough.lua",

    -- Registrar módulo no core  autojump = "https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-RBX/main/modules/autojump.lua",

    Core[moduleName] = moduleTable}



    -- Adicionar função toggle se não existirlocal function http_get(url)

    if not moduleTable.toggle then  local bust = tostring(os.clock()):gsub("%.", "")

        moduleTable.toggle = function()  local finalUrl = url .. "?t=" .. bust

            local enabled = not (state.activeModules[moduleName] or false)  return game:HttpGet(finalUrl)

            state.activeModules[moduleName] = enabledend



            if enabled thenlocal modules_to_load = {"core", "ui", "fly", "noclip", "speed", "teleport", "godmode", "infinitejump", "fullbright", "nofalldamage", "xray", "esp", "lowgravity", "instantrespawn", "clicktp", "autofarm", "walkthrough", "autojump"}

                if moduleTable.enable thenlocal total_modules = #modules_to_load

                    pcall(moduleTable.enable)local loaded_count = 0

                end

            elselocal function update_loading_progress(module_name)

                if moduleTable.disable then    loaded_count = loaded_count + 1

                    pcall(moduleTable.disable)    local progress = loaded_count / total_modules

                end    loadingUI.status.Text = "Carregando: " .. module_name .. ".lua"

            end    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    local tween = TweenService:Create(loadingUI.bar, tweenInfo, {Size = UDim2.new(progress, 0, 1, 0)})

            return enabled    tween:Play()

        endend

    end

local function load_module(name)

    print("[FK7 Core] Módulo '" .. moduleName .. "' registrado!")  -- Primeiro tentar carregar localmente (para desenvolvimento)

end  local local_modules = {

    core = [[-- modules/core.lua - núcleo com gerenciamento de respawn

function Core.connect(eventName, callback)local Core = {}

    if state.connections[eventName] then

        state.connections[eventName]:Disconnect()-- Serviços

    endlocal Players = game:GetService("Players")

    state.connections[eventName] = callbacklocal UserInputService = game:GetService("UserInputService")

    return state.connections[eventName]local RunService = game:GetService("RunService")

end

local state = {}

function Core.disconnect(eventName)local character_added_callbacks = {}

    if state.connections[eventName] thenlocal modules_to_respawn = {}

        state.connections[eventName]:Disconnect()

        state.connections[eventName] = nilfunction Core.init()

    end    state.player = Players.LocalPlayer

end    state.mouse = state.player:GetMouse()



function Core.saveOriginalValue(key, value)    local function on_char(character)

    state.originalValues[key] = value        if not character then return end

end        state.character = character

        state.humanoid = character:WaitForChild("Humanoid")

function Core.getOriginalValue(key, default)        state.hrp = character:WaitForChild("HumanoidRootPart")

    return state.originalValues[key] or default

end        -- Dispara callbacks

        for _, callback in ipairs(character_added_callbacks) do

function Core.shutdown()            pcall(callback)

    -- Desconectar todos os eventos        end

    for name, connection in pairs(state.connections) do        

        if typeof(connection) == "RBXScriptConnection" then        -- Reativa módulos que estavam ativos

            connection:Disconnect()        for module_name, was_enabled in pairs(modules_to_respawn) do

        end            if was_enabled and _G.FK7 and _G.FK7.Features and _G.FK7.Features[module_name] then

    end                task.wait(0.5) -- Aguarda character estabilizar

                pcall(function()

    -- Desabilitar todos os módulos                    if not _G.FK7.Features[module_name].enabled then

    for moduleName, isEnabled in pairs(state.activeModules) do                        _G.FK7.Features[module_name].toggle()

        if isEnabled and Core[moduleName] and Core[moduleName].disable then                    end

            pcall(Core[moduleName].disable)                end)

        end            end

    end        end

    end

    -- Limpar estado

    state.connections = {}    state.player.CharacterAdded:Connect(on_char)

    state.activeModules = {}    if state.player.Character then

    state.originalValues = {}        on_char(state.player.Character)

    end

    print("[FK7 Core] Sistema encerrado!")end

end

function Core.registerForRespawn(module_name, is_enabled)

return Core    modules_to_respawn[module_name] = is_enabled

]])end



-- Carregar módulos de funcionalidadesfunction Core.shutdown()

Modules.features.fly = loadModule("fly", [[    -- Desativar todos os módulos ativos

-- modules/fly.lua - Sistema de voo    if _G.FK7 and _G.FK7.Features then

local Fly = {        for module_name, module in pairs(_G.FK7.Features) do

    enabled = false,            if module and module.enabled and module.disable then

    speed = 50,                pcall(module.disable)

    bodyVelocity = nil,            end

    bodyGyro = nil        end

}    end

    

local Core = require(script.Parent.core)    -- Limpar todas as conexões

local RunService = game:GetService("RunService")    Core.cleanup()

local UserInputService = game:GetService("UserInputService")    

    -- Limpar variáveis globais

function Fly.enable()    if _G.FK7 then

    if Fly.enabled then return end        _G.FK7 = nil

    Fly.enabled = true    end

    

    local st = Core.state()    -- Restaurar configurações do workspace se alteradas

    Fly.bodyVelocity = Instance.new("BodyVelocity")    pcall(function()

    Fly.bodyVelocity.MaxForce = Vector3.new(400000, 400000, 400000)        workspace.Gravity = 196.2 -- Gravidade padrão

    Fly.bodyVelocity.Velocity = Vector3.new(0, 0, 0)    end)

    Fly.bodyVelocity.Parent = st.humanoidRootPart    

    print("[FK7] Script encerrado e módulos desativados")

    Fly.bodyGyro = Instance.new("BodyGyro")end

    Fly.bodyGyro.MaxTorque = Vector3.new(400000, 400000, 400000)

    Fly.bodyGyro.P = 3000function Core.onCharacterAdded(callback)

    Fly.bodyGyro.D = 500    table.insert(character_added_callbacks, callback)

    Fly.bodyGyro.Parent = st.humanoidRootPartend



    Fly.connection = RunService.Heartbeat:Connect(function()function Core.state()

        if not Fly.enabled then return end  return state

end

        local moveVector = Vector3.new()

        local camera = workspace.CurrentCamerafunction Core.services()

  return { Players = Players, UserInputService = UserInputService, RunService = RunService }

        if UserInputService:IsKeyDown(Enum.KeyCode.W) thenend

            moveVector = moveVector + camera.CFrame.LookVector

        endlocal connections = {}

        if UserInputService:IsKeyDown(Enum.KeyCode.S) thenfunction Core.connect(key, conn)

            moveVector = moveVector - camera.CFrame.LookVector  if connections[key] then pcall(function() connections[key]:Disconnect() end) end

        end  connections[key] = conn

        if UserInputService:IsKeyDown(Enum.KeyCode.A) thenend

            moveVector = moveVector - camera.CFrame.RightVectorfunction Core.disconnect(key)

        end  if connections[key] then pcall(function() connections[key]:Disconnect() end); connections[key]=nil end

        if UserInputService:IsKeyDown(Enum.KeyCode.D) thenend

            moveVector = moveVector + camera.CFrame.RightVectorfunction Core.cleanup()

        end  for k,c in pairs(connections) do pcall(function() c:Disconnect() end) end

        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then  table.clear(connections)

            moveVector = moveVector + Vector3.new(0, 1, 0)end

        end

        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) thenCore.init()

            moveVector = moveVector - Vector3.new(0, 1, 0)return Core]],

        end    ui = [[-- modules/ui.lua - Interface Premium FK7 Admin

local UI = {}

        Fly.bodyVelocity.Velocity = moveVector * Fly.speedlocal TweenService = game:GetService("TweenService")

        Fly.bodyGyro.CFrame = camera.CFrame

    end)-- Animações e efeitos visuais

local function animate_button_hover(button, hoverColor, originalColor)

    print("[Fly] Ativado - Use WASD + Space/Ctrl para voar")    button.MouseEnter:Connect(function()

end        local tween = TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {

            BackgroundColor3 = hoverColor,

function Fly.disable()            Size = UDim2.new(1, 0, 0, 38)

    if not Fly.enabled then return end        })

    Fly.enabled = false        tween:Play()

    end)

    if Fly.connection then    

        Fly.connection:Disconnect()    button.MouseLeave:Connect(function()

        Fly.connection = nil        local tween = TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {

    end            BackgroundColor3 = originalColor,

            Size = UDim2.new(1, 0, 0, 35)

    if Fly.bodyVelocity then        })

        Fly.bodyVelocity:Destroy()        tween:Play()

        Fly.bodyVelocity = nil    end)

    endend



    if Fly.bodyGyro thenlocal function pulse_effect(element, color)

        Fly.bodyGyro:Destroy()    local pulse = TweenService:Create(element, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {

        Fly.bodyGyro = nil        BackgroundColor3 = color

    end    })

    return pulse

    print("[Fly] Desativado")end

end

-- Função para criar interface arrastável com animação

function Fly.setSpeed(speed)local function create_draggable(gui)

    Fly.speed = math.clamp(speed, 10, 500)    local is_dragging = false

    print("[Fly] Velocidade definida para: " .. Fly.speed)    local drag_start

end    local frame_start

    local original_transparency = gui.BackgroundTransparency

return Fly

]])    gui.InputBegan:Connect(function(input)

        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then

Modules.features.noclip = loadModule("noclip", [[            is_dragging = true

-- modules/noclip.lua - Sistema de noclip            drag_start = input.Position

local Noclip = {            frame_start = gui.Parent.Position

    enabled = false,            

    connection = nil            -- Efeito visual ao começar a arrastar

}            local tween = TweenService:Create(gui, TweenInfo.new(0.2), {

                BackgroundTransparency = 0.1

local Core = require(script.Parent.core)            })

local RunService = game:GetService("RunService")            tween:Play()

        end

function Noclip.enable()    end)

    if Noclip.enabled then return end

    Noclip.enabled = true    gui.InputEnded:Connect(function(input)

        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then

    local st = Core.state()            is_dragging = false

            

    Noclip.connection = RunService.Stepped:Connect(function()            -- Restaurar transparência

        if not Noclip.enabled then return end            local tween = TweenService:Create(gui, TweenInfo.new(0.2), {

                BackgroundTransparency = original_transparency

        for _, part in pairs(st.character:GetChildren()) do            })

            if part:IsA("BasePart") then            tween:Play()

                part.CanCollide = false        end

            end    end)

        end

    end)    gui.InputChanged:Connect(function(input)

        if is_dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then

    print("[Noclip] Ativado - Você pode atravessar paredes")            local delta = input.Position - drag_start

end            gui.Parent.Position = UDim2.new(frame_start.X.Scale, frame_start.X.Offset + delta.X, frame_start.Y.Scale, frame_start.Y.Offset + delta.Y)

        end

function Noclip.disable()    end)

    if not Noclip.enabled then return endend

    Noclip.enabled = false

-- Criar separador visual

    if Noclip.connection thenlocal function create_separator(parent, text)

        Noclip.connection:Disconnect()    local separator = Instance.new("Frame")

        Noclip.connection = nil    separator.Size = UDim2.new(1, 0, 0, 30)

    end    separator.BackgroundTransparency = 1

    separator.Parent = parent

    local st = Core.state()    

    for _, part in pairs(st.character:GetChildren()) do    local line1 = Instance.new("Frame", separator)

        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then    line1.Size = UDim2.new(0.3, 0, 0, 2)

            part.CanCollide = true    line1.Position = UDim2.new(0, 0, 0.5, -1)

        end    line1.BackgroundColor3 = Color3.fromRGB(60, 120, 220)

    end    line1.BorderSizePixel = 0

    Instance.new("UICorner", line1).CornerRadius = UDim.new(0, 1)

    print("[Noclip] Desativado")    

end    local label = Instance.new("TextLabel", separator)

    label.Size = UDim2.new(0.4, 0, 1, 0)

return Noclip    label.Position = UDim2.new(0.3, 0, 0, 0)

]])    label.BackgroundTransparency = 1

    label.Text = text

Modules.features.godmode = loadModule("godmode", [[    label.Font = Enum.Font.GothamBold

-- modules/godmode.lua - Modo Deus    label.TextSize = 12

local Godmode = {    label.TextColor3 = Color3.fromRGB(150, 150, 150)

    enabled = false,    label.TextXAlignment = Enum.TextXAlignment.Center

    connection = nil,    

    originalMaxHealth = nil,    local line2 = Instance.new("Frame", separator)

    originalHealth = nil    line2.Size = UDim2.new(0.3, 0, 0, 2)

}    line2.Position = UDim2.new(0.7, 0, 0.5, -1)

    line2.BackgroundColor3 = Color3.fromRGB(60, 120, 220)

local Core = require(script.Parent.core)    line2.BorderSizePixel = 0

    Instance.new("UICorner", line2).CornerRadius = UDim.new(0, 1)

function Godmode.enable()    

    if Godmode.enabled then return end    return separator

    Godmode.enabled = trueend



    local st = Core.state()function UI.init(ctx)

    local humanoid = st.humanoid    local Core = ctx.core

    local st = Core.state()

    -- Salvar valores originais    local playerGui = st.player:WaitForChild("PlayerGui")

    Godmode.originalMaxHealth = humanoid.MaxHealth

    Godmode.originalHealth = humanoid.Health    -- Remover GUI antiga se existir

    if playerGui:FindFirstChild("FK7_GUI") then

    -- Definir vida infinita        playerGui.FK7_GUI:Destroy()

    humanoid.MaxHealth = math.huge    end

    humanoid.Health = math.huge

    local gui = Instance.new("ScreenGui")

    -- Conectar evento para manter vida infinita    gui.Name = "FK7_GUI"

    Godmode.connection = humanoid.HealthChanged:Connect(function()    gui.ResetOnSpawn = false

        if Godmode.enabled then    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

            humanoid.Health = humanoid.MaxHealth    gui.Parent = playerGui

        end

    end)    -- Fundo blur (efeito de profundidade)

    local blurFrame = Instance.new("Frame")

    print("[Godmode] Ativado - Você é imortal!")    blurFrame.Size = UDim2.new(0, 340, 0, 520)

end    blurFrame.Position = UDim2.new(0, 40, 0.5, -260)

    blurFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)

function Godmode.disable()    blurFrame.BackgroundTransparency = 0.8

    if not Godmode.enabled then return end    blurFrame.BorderSizePixel = 0

    Godmode.enabled = false    blurFrame.Parent = gui

    Instance.new("UICorner", blurFrame).CornerRadius = UDim.new(0, 16)

    if Godmode.connection then

        Godmode.connection:Disconnect()    -- Frame principal com glassmorphism

        Godmode.connection = nil    local mainFrame = Instance.new("Frame")

    end    mainFrame.Size = UDim2.new(0, 350, 0, 530)

    mainFrame.Position = UDim2.new(0, 35, 0.5, -265)

    local st = Core.state()    mainFrame.BackgroundColor3 = Color3.fromRGB(15, 18, 25)

    local humanoid = st.humanoid    mainFrame.BackgroundTransparency = 0.1

    mainFrame.BorderSizePixel = 0

    -- Restaurar valores originais    mainFrame.Parent = gui

    if Godmode.originalMaxHealth then

        humanoid.MaxHealth = Godmode.originalMaxHealth    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 18)

    end    

    if Godmode.originalHealth then    -- Borda com gradiente animado

        humanoid.Health = Godmode.originalHealth    local stroke = Instance.new("UIStroke", mainFrame)

    end    stroke.Color = Color3.fromRGB(100, 180, 255)

    stroke.Thickness = 3

    print("[Godmode] Desativado")    stroke.Transparency = 0.2

end    

    -- Gradiente principal

return Godmode    local mainGradient = Instance.new("UIGradient", mainFrame)

]])    mainGradient.Color = ColorSequence.new{

        ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 30, 45)),

Modules.features.speed = loadModule("speed", [[        ColorSequenceKeypoint.new(0.3, Color3.fromRGB(20, 25, 35)),

-- modules/speed.lua - Velocidade aumentada        ColorSequenceKeypoint.new(0.7, Color3.fromRGB(15, 20, 30)),

local Speed = {        ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 15, 25))

    enabled = false,    }

    speed = 100,    mainGradient.Rotation = 135

    originalWalkSpeed = nil

}    -- Efeito de brilho no topo

    local glowEffect = Instance.new("Frame", mainFrame)

local Core = require(script.Parent.core)    glowEffect.Size = UDim2.new(1, 0, 0, 100)

    glowEffect.Position = UDim2.new(0, 0, 0, 0)

function Speed.enable()    glowEffect.BackgroundTransparency = 0.9

    if Speed.enabled then return end    glowEffect.BorderSizePixel = 0

    Speed.enabled = true    glowEffect.ZIndex = mainFrame.ZIndex + 1

    

    local st = Core.state()    local glowGradient = Instance.new("UIGradient", glowEffect)

    local humanoid = st.humanoid    glowGradient.Color = ColorSequence.new{

        ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 180, 255)),

    -- Salvar velocidade original        ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 18, 25))

    Speed.originalWalkSpeed = humanoid.WalkSpeed    }

    glowGradient.Rotation = 90

    -- Aplicar velocidade aumentada    Instance.new("UICorner", glowEffect).CornerRadius = UDim.new(0, 18)

    humanoid.WalkSpeed = Speed.speed

    -- Cabeçalho premium

    print("[Speed] Ativado - Velocidade: " .. Speed.speed)    local header = Instance.new("Frame")

end    header.Size = UDim2.new(1, 0, 0, 60)

    header.BackgroundColor3 = Color3.fromRGB(20, 25, 40)

function Speed.disable()    header.BackgroundTransparency = 0.3

    if not Speed.enabled then return end    header.BorderSizePixel = 0

    Speed.enabled = false    header.Parent = mainFrame

    header.ZIndex = mainFrame.ZIndex + 2

    local st = Core.state()    create_draggable(header)

    local humanoid = st.humanoid

    Instance.new("UICorner", header).CornerRadius = UDim.new(0, 18)

    -- Restaurar velocidade original

    if Speed.originalWalkSpeed then    local headerGradient = Instance.new("UIGradient", header)

        humanoid.WalkSpeed = Speed.originalWalkSpeed    headerGradient.Color = ColorSequence.new{

    end        ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 140, 255)),

        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(60, 120, 200)),

    print("[Speed] Desativado")        ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 80, 160))

end    }

    headerGradient.Rotation = 45

function Speed.setSpeed(speed)

    Speed.speed = math.clamp(speed, 50, 500)    -- Logo e título melhorados

    if Speed.enabled then    local logoIcon = Instance.new("TextLabel", header)

        local st = Core.state()    logoIcon.Size = UDim2.new(0, 40, 0, 40)

        st.humanoid.WalkSpeed = Speed.speed    logoIcon.Position = UDim2.new(0, 15, 0.5, -20)

    end    logoIcon.BackgroundTransparency = 1

    print("[Speed] Velocidade definida para: " .. Speed.speed)    logoIcon.Text = "🚀"

end    logoIcon.Font = Enum.Font.GothamBold

    logoIcon.TextSize = 24

return Speed    logoIcon.TextColor3 = Color3.new(1, 1, 1)

]])

    local title = Instance.new("TextLabel", header)

Modules.features.infinitejump = loadModule("infinitejump", [[    title.Size = UDim2.new(1, -150, 1, 0)

-- modules/infinitejump.lua - Pulo infinito    title.Position = UDim2.new(0, 60, 0, 0)

local InfiniteJump = {    title.BackgroundTransparency = 1

    enabled = false,    title.Text = "FK7 ADMIN"

    connection = nil    title.Font = Enum.Font.GothamBold

}    title.TextSize = 22

    title.TextColor3 = Color3.new(1, 1, 1)

local Core = require(script.Parent.core)    title.TextXAlignment = Enum.TextXAlignment.Left

local UserInputService = game:GetService("UserInputService")    title.TextStrokeTransparency = 0.5

    title.TextStrokeColor3 = Color3.new(0, 0, 0)

function InfiniteJump.enable()

    if InfiniteJump.enabled then return end    local subtitle = Instance.new("TextLabel", header)

    InfiniteJump.enabled = true    subtitle.Size = UDim2.new(1, -150, 0, 15)

    subtitle.Position = UDim2.new(0, 60, 1, -18)

    local st = Core.state()    subtitle.BackgroundTransparency = 1

    local humanoid = st.humanoid    subtitle.Text = "Premium Edition v2.0"

    subtitle.Font = Enum.Font.Gotham

    InfiniteJump.connection = UserInputService.JumpRequest:Connect(function()    subtitle.TextSize = 10

        if InfiniteJump.enabled then    subtitle.TextColor3 = Color3.fromRGB(200, 220, 255)

            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)    subtitle.TextXAlignment = Enum.TextXAlignment.Left

        end    subtitle.TextTransparency = 0.3

    end)

    -- Botões de controle melhorados

    print("[InfiniteJump] Ativado - Pule infinitamente!")    local minimizeButton = Instance.new("TextButton", header)

end    minimizeButton.Size = UDim2.new(0, 30, 0, 30)

    minimizeButton.Position = UDim2.new(1, -75, 0.5, -15)

function InfiniteJump.disable()    minimizeButton.BackgroundColor3 = Color3.fromRGB(255, 193, 7)

    if not InfiniteJump.enabled then return end    minimizeButton.Text = "—"

    InfiniteJump.enabled = false    minimizeButton.Font = Enum.Font.GothamBold

    minimizeButton.TextSize = 14

    if InfiniteJump.connection then    minimizeButton.TextColor3 = Color3.new(1, 1, 1)

        InfiniteJump.connection:Disconnect()    Instance.new("UICorner", minimizeButton).CornerRadius = UDim.new(0, 6)

        InfiniteJump.connection = nil

    end    local closeButton = Instance.new("TextButton", header)

    closeButton.Size = UDim2.new(0, 30, 0, 30)

    print("[InfiniteJump] Desativado")    closeButton.Position = UDim2.new(1, -38, 0.5, -15)

end    closeButton.BackgroundColor3 = Color3.fromRGB(220, 53, 69)

    closeButton.Text = "✕"

return InfiniteJump    closeButton.Font = Enum.Font.GothamBold

]])    closeButton.TextSize = 14

    closeButton.TextColor3 = Color3.new(1, 1, 1)

Modules.features.clicktp = loadModule("clicktp", [[    Instance.new("UICorner", closeButton).CornerRadius = UDim.new(0, 6)

-- modules/clicktp.lua - Teleporte ao clicar

local ClickTP = {    -- Animação dos botões de controle

    enabled = false,    animate_button_hover(minimizeButton, Color3.fromRGB(255, 213, 47), Color3.fromRGB(255, 193, 7))

    connection = nil    animate_button_hover(closeButton, Color3.fromRGB(240, 73, 89), Color3.fromRGB(220, 53, 69))

}

    closeButton.MouseButton1Click:Connect(function()

local Core = require(script.Parent.core)        -- Animação de saída

local Players = game:GetService("Players")        local closeTween = TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {

            Size = UDim2.new(0, 0, 0, 0),

function ClickTP.enable()            Position = UDim2.new(0.5, 0, 0.5, 0),

    if ClickTP.enabled then return end            BackgroundTransparency = 1

    ClickTP.enabled = true        })

        closeTween:Play()

    local st = Core.state()        

    local player = st.player        closeTween.Completed:Connect(function()

    local mouse = player:GetMouse()            if ctx.core and ctx.core.shutdown then

                ctx.core.shutdown()

    ClickTP.connection = mouse.Button1Down:Connect(function()            end

        if not ClickTP.enabled then return end            gui:Destroy()

        end)

        local hit = mouse.Hit    end)

        if hit and typeof(hit) == "CFrame" then

            local pos = hit.Position    -- Container de conteúdo com scroll customizado

            if typeof(pos) == "Vector3" and pos.Y > -1e5 and pos.Y < 1e5 then    local content = Instance.new("ScrollingFrame", mainFrame)

                st.humanoidRootPart.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))    content.Size = UDim2.new(1, -20, 1, -80)

                print("[ClickTP] Teleportado para: " .. tostring(pos))    content.Position = UDim2.new(0, 10, 0, 70)

            end    content.BackgroundTransparency = 1

        end    content.BorderSizePixel = 0

    end)    content.CanvasSize = UDim2.new(0, 0, 0, 0)

    content.ScrollBarThickness = 6

    print("[ClickTP] Ativado - Clique no mapa para teleportar")    content.ScrollBarImageColor3 = Color3.fromRGB(100, 180, 255)

end    content.ScrollBarImageTransparency = 0.2

    content.ScrollingDirection = Enum.ScrollingDirection.Y

function ClickTP.disable()    content.ZIndex = mainFrame.ZIndex + 1

    if not ClickTP.enabled then return end    

    ClickTP.enabled = false    -- Layout com padding melhorado

    local layout = Instance.new("UIListLayout", content)

    if ClickTP.connection then    layout.Padding = UDim.new(0, 6)

        ClickTP.connection:Disconnect()    layout.FillDirection = Enum.FillDirection.Vertical

        ClickTP.connection = nil    layout.SortOrder = Enum.SortOrder.LayoutOrder

    end

    -- Padding interno

    print("[ClickTP] Desativado")    local padding = Instance.new("UIPadding", content)

end    padding.PaddingLeft = UDim.new(0, 5)

    padding.PaddingRight = UDim.new(0, 5)

return ClickTP    padding.PaddingTop = UDim.new(0, 10)

]])    padding.PaddingBottom = UDim.new(0, 10)



Modules.features.fullbright = loadModule("fullbright", [[    -- Função para criar botões premium

-- modules/fullbright.lua - Iluminação total    local function create_button(text, callback, category)

local Fullbright = {        local btn = Instance.new("TextButton")

    enabled = false,        btn.Size = UDim2.new(1, 0, 0, 40)

    originalBrightness = nil,        btn.BackgroundColor3 = Color3.fromRGB(30, 35, 50)

    originalAmbient = nil        btn.Text = ""

}        btn.Font = Enum.Font.Gotham

        btn.TextSize = 14

local Core = require(script.Parent.core)        btn.TextColor3 = Color3.new(1, 1, 1)

local Lighting = game:GetService("Lighting")        btn.Parent = content

        btn.ZIndex = content.ZIndex + 1

function Fullbright.enable()

    if Fullbright.enabled then return end        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

    Fullbright.enabled = true        

        local btnStroke = Instance.new("UIStroke", btn)

    -- Salvar valores originais        btnStroke.Color = Color3.fromRGB(60, 70, 90)

    Fullbright.originalBrightness = Lighting.Brightness        btnStroke.Thickness = 1

    Fullbright.originalAmbient = Lighting.Ambient        btnStroke.Transparency = 0.5



    -- Aplicar iluminação total        -- Gradiente do botão

    Lighting.Brightness = 2        local btnGradient = Instance.new("UIGradient", btn)

    Lighting.Ambient = Color3.new(1, 1, 1)        btnGradient.Color = ColorSequence.new{

            ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 40, 55)),

    print("[Fullbright] Ativado - Ambiente totalmente iluminado")            ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 30, 45))

end        }

        btnGradient.Rotation = 90

function Fullbright.disable()

    if not Fullbright.enabled then return end        -- Label do texto

    Fullbright.enabled = false        local textLabel = Instance.new("TextLabel", btn)

        textLabel.Size = UDim2.new(1, -50, 1, 0)

    -- Restaurar valores originais        textLabel.Position = UDim2.new(0, 45, 0, 0)

    if Fullbright.originalBrightness then        textLabel.BackgroundTransparency = 1

        Lighting.Brightness = Fullbright.originalBrightness        textLabel.Text = text

    end        textLabel.Font = Enum.Font.GothamSemibold

    if Fullbright.originalAmbient then        textLabel.TextSize = 14

        Lighting.Ambient = Fullbright.originalAmbient        textLabel.TextColor3 = Color3.new(1, 1, 1)

    end        textLabel.TextXAlignment = Enum.TextXAlignment.Left

        textLabel.ZIndex = btn.ZIndex + 1

    print("[Fullbright] Desativado")

end        -- Status indicator

        local indicator = Instance.new("Frame", btn)

return Fullbright        indicator.Size = UDim2.new(0, 6, 0, 6)

]])        indicator.Position = UDim2.new(1, -20, 0.5, -3)

        indicator.BackgroundColor3 = Color3.fromRGB(220, 53, 69)

Modules.features.esp = loadModule("esp", [[        indicator.BorderSizePixel = 0

-- modules/esp.lua - Sistema ESP        indicator.ZIndex = btn.ZIndex + 1

local ESP = {        Instance.new("UICorner", indicator).CornerRadius = UDim.new(0, 3)

    enabled = false,

    highlights = {},        -- Ícone categorial

    connections = {}        local icon = Instance.new("TextLabel", btn)

}        icon.Size = UDim2.new(0, 30, 0, 30)

        icon.Position = UDim2.new(0, 8, 0.5, -15)

local Core = require(script.Parent.core)        icon.BackgroundTransparency = 1

local Players = game:GetService("Players")        icon.Text = text:match("^[^%s]+") -- Pega o primeiro emoji

local RunService = game:GetService("RunService")        icon.Font = Enum.Font.GothamBold

        icon.TextSize = 16

function ESP.enable()        icon.TextColor3 = Color3.new(1, 1, 1)

    if ESP.enabled then return end        icon.ZIndex = btn.ZIndex + 1

    ESP.enabled = true

        -- Animações do botão

    local st = Core.state()        animate_button_hover(btn, Color3.fromRGB(45, 50, 70), Color3.fromRGB(30, 35, 50))



    -- Função para criar ESP para um jogador        -- Efeito de clique

    local function createESP(player)        btn.MouseButton1Click:Connect(function()

        if player == st.player or ESP.highlights[player] then return end            local clickEffect = TweenService:Create(btn, TweenInfo.new(0.1), {

                Size = UDim2.new(1, -4, 0, 36)

        local character = player.Character            })

        if not character then return end            clickEffect:Play()

            

        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")            clickEffect.Completed:Connect(function()

        if not humanoidRootPart then return end                local returnEffect = TweenService:Create(btn, TweenInfo.new(0.1), {

                    Size = UDim2.new(1, 0, 0, 40)

        -- Criar Highlight                })

        local highlight = Instance.new("Highlight")                returnEffect:Play()

        highlight.Adornee = character            end)

        highlight.FillColor = Color3.fromRGB(255, 0, 0)            

        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)            callback(btn, indicator, textLabel)

        highlight.FillTransparency = 0.5        end)

        highlight.OutlineTransparency = 0

        highlight.Parent = character        return btn, indicator, textLabel

    end

        -- Criar BillboardGui para nome

        local billboard = Instance.new("BillboardGui")    -- Função para atualizar status do botão

        billboard.Adornee = humanoidRootPart    local function update_button_status(button, indicator, textLabel, enabled, originalText)

        billboard.Size = UDim2.new(0, 100, 0, 50)        if enabled then

        billboard.StudsOffset = Vector3.new(0, 2, 0)            textLabel.Text = originalText .. " (ON)"

        billboard.Parent = character            indicator.BackgroundColor3 = Color3.fromRGB(40, 167, 69)

            button.BackgroundColor3 = Color3.fromRGB(25, 60, 35)

        local nameLabel = Instance.new("TextLabel")            

        nameLabel.Size = UDim2.new(1, 0, 1, 0)            -- Efeito de pulso para botões ativos

        nameLabel.BackgroundTransparency = 1            local pulse = pulse_effect(indicator, Color3.fromRGB(60, 200, 90))

        nameLabel.Text = player.Name            pulse:Play()

        nameLabel.TextColor3 = Color3.new(1, 1, 1)        else

        nameLabel.TextStrokeTransparency = 0            textLabel.Text = originalText .. " (OFF)"

        nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)            indicator.BackgroundColor3 = Color3.fromRGB(220, 53, 69)

        nameLabel.Font = Enum.Font.SourceSansBold            button.BackgroundColor3 = Color3.fromRGB(30, 35, 50)

        nameLabel.TextSize = 14        end

        nameLabel.Parent = billboard    end



        ESP.highlights[player] = {    -- Categorias de recursos

            highlight = highlight,    create_separator(content, "MOVEMENT")

            billboard = billboard

        }    create_button("✈️ Voo Avançado", function(btn, indicator, textLabel)

    end        local enabled = ctx.features.fly.toggle()

        update_button_status(btn, indicator, textLabel, enabled, "✈️ Voo Avançado")

    -- Criar ESP para jogadores existentes    end)

    for _, player in pairs(Players:GetPlayers()) do

        createESP(player)    create_button("👻 Noclip", function(btn, indicator, textLabel)

    end        local enabled = ctx.features.noclip.toggle()

        update_button_status(btn, indicator, textLabel, enabled, "👻 Noclip")

    -- Conectar eventos para novos jogadores    end)

    ESP.connections.playerAdded = Players.PlayerAdded:Connect(function(player)

        if ESP.enabled then    create_button("⚡ Velocidade", function(btn, indicator, textLabel)

            createESP(player)        local enabled = ctx.features.speed.toggle()

        end        update_button_status(btn, indicator, textLabel, enabled, "⚡ Velocidade")

    end)    end)



    ESP.connections.playerRemoving = Players.PlayerRemoving:Connect(function(player)    create_button("👟 Pulo Infinito", function(btn, indicator, textLabel)

        if ESP.highlights[player] then        local enabled = ctx.features.infinitejump.toggle()

            if ESP.highlights[player].highlight then        update_button_status(btn, indicator, textLabel, enabled, "👟 Pulo Infinito")

                ESP.highlights[player].highlight:Destroy()    end)

            end

            if ESP.highlights[player].billboard then    create_separator(content, "TELEPORT")

                ESP.highlights[player].billboard:Destroy()

            end    create_button("🎯 Click Teleport", function(btn, indicator, textLabel)

            ESP.highlights[player] = nil        local enabled = ctx.features.teleport.toggle()

        end        update_button_status(btn, indicator, textLabel, enabled, "🎯 Click Teleport")

    end)    end)



    print("[ESP] Ativado - Jogadores visíveis")    create_button("🌟 TP Profissional", function(btn, indicator, textLabel)

end        local enabled = ctx.features.clicktp.toggle()

        update_button_status(btn, indicator, textLabel, enabled, "🌟 TP Profissional")

function ESP.disable()    end)

    if not ESP.enabled then return end

    ESP.enabled = false    create_separator(content, "COMBAT")



    -- Desconectar eventos    create_button("❤️ Modo Deus", function(btn, indicator, textLabel)

    for _, connection in pairs(ESP.connections) do        local enabled = ctx.features.godmode.toggle()

        if connection then        update_button_status(btn, indicator, textLabel, enabled, "❤️ Modo Deus")

            connection:Disconnect()    end)

        end

    end    create_button("🛡️ Sem Dano de Queda", function(btn, indicator, textLabel)

    ESP.connections = {}        local enabled = ctx.features.nofalldamage.toggle()

        update_button_status(btn, indicator, textLabel, enabled, "🛡️ Sem Dano de Queda")

    -- Remover todos os ESPs    end)

    for _, espData in pairs(ESP.highlights) do

        if espData.highlight then    create_separator(content, "VISUAL")

            espData.highlight:Destroy()

        end    create_button("💡 Luz Máxima", function(btn, indicator, textLabel)

        if espData.billboard then        local enabled = ctx.features.fullbright.toggle()

            espData.billboard:Destroy()        update_button_status(btn, indicator, textLabel, enabled, "💡 Luz Máxima")

        end    end)

    end

    ESP.highlights = {}    create_button("👁️ Visão de Raio-X", function(btn, indicator, textLabel)

        local enabled = ctx.features.xray.toggle()

    print("[ESP] Desativado")        update_button_status(btn, indicator, textLabel, enabled, "👁️ Visão de Raio-X")

end    end)



return ESP    create_button("📡 ESP Players", function(btn, indicator, textLabel)

]])        local enabled = ctx.features.esp.toggle()

        update_button_status(btn, indicator, textLabel, enabled, "📡 ESP Players")

-- Carregar UI    end)

Modules.ui = loadModule("ui", [[

-- modules/ui.lua - Interface Moderna FK7 Admin    create_separator(content, "WORLD")

local UI = {}

local TweenService = game:GetService("TweenService")    create_button("🪐 Gravidade Baixa", function(btn, indicator, textLabel)

local UserInputService = game:GetService("UserInputService")        local enabled = ctx.features.lowgravity.toggle()

local RunService = game:GetService("RunService")        update_button_status(btn, indicator, textLabel, enabled, "🪐 Gravidade Baixa")

    end)

-- Cores do tema

local COLORS = {    create_button("🚪 Atravessar Paredes", function(btn, indicator, textLabel)

    background = Color3.fromRGB(24, 25, 28),        local enabled = ctx.features.walkthrough.toggle()

    surface = Color3.fromRGB(32, 34, 37),        update_button_status(btn, indicator, textLabel, enabled, "🚪 Atravessar Paredes")

    surface_light = Color3.fromRGB(40, 42, 46),    end)

    primary = Color3.fromRGB(88, 166, 255),

    primary_dark = Color3.fromRGB(70, 140, 220),    create_separator(content, "AUTOMATION")

    success = Color3.fromRGB(76, 175, 80),

    error = Color3.fromRGB(244, 67, 54),    create_button("💰 Farm Automático", function(btn, indicator, textLabel)

    warning = Color3.fromRGB(255, 193, 7),        local enabled = ctx.features.autofarm.toggle()

    text_primary = Color3.fromRGB(255, 255, 255),        update_button_status(btn, indicator, textLabel, enabled, "💰 Farm Automático")

    text_secondary = Color3.fromRGB(158, 158, 158),    end)

    border = Color3.fromRGB(60, 63, 65)

}    create_button("🦘 Pulo Automático", function(btn, indicator, textLabel)

        local enabled = ctx.features.autojump.toggle()

-- Animações suaves        update_button_status(btn, indicator, textLabel, enabled, "🦘 Pulo Automático")

local function smooth_tween(object, properties, duration, style)    end)

    duration = duration or 0.3

    style = style or Enum.EasingStyle.Quart    create_button("⚡ Respawn Instantâneo", function(btn, indicator, textLabel)

    return TweenService:Create(object, TweenInfo.new(duration, style), properties)        local enabled = ctx.features.instantrespawn.toggle()

end        update_button_status(btn, indicator, textLabel, enabled, "⚡ Respawn Instantâneo")

    end)

-- Sistema de arrastar

local function make_draggable(frame, dragHandle)    -- Atualizar CanvasSize dinamicamente

    local isDragging = false    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()

    local dragStart, startPos        content.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)

    end)

    dragHandle = dragHandle or frame    

    -- Atualização inicial

    dragHandle.InputBegan:Connect(function(input)    content.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)

        if input.UserInputType == Enum.UserInputType.MouseButton1 then

            isDragging = true    -- Animação de entrada

            dragStart = input.Position    mainFrame.Size = UDim2.new(0, 0, 0, 0)

            startPos = frame.Position    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)

    mainFrame.BackgroundTransparency = 1

            smooth_tween(frame, {Size = frame.Size + UDim2.fromOffset(4, 4)}):Play()    

        end    local openTween = TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {

    end)        Size = UDim2.new(0, 350, 0, 530),

        Position = UDim2.new(0, 35, 0.5, -265),

    dragHandle.InputEnded:Connect(function(input)        BackgroundTransparency = 0.1

        if input.UserInputType == Enum.UserInputType.MouseButton1 then    })

            isDragging = false    openTween:Play()

            smooth_tween(frame, {Size = frame.Size - UDim2.fromOffset(4, 4)}):Play()    

        end    print("[FK7] Interface Premium carregada com sucesso! 🚀")

    end)end



    UserInputService.InputChanged:Connect(function(input)return UI]],

        if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then    fly = [[-- modules/fly.lua - voo básico mínimo

            local delta = input.Position - dragStartlocal Fly = { enabled = false }

            frame.Position = UDim2.fromOffset(

                startPos.X.Offset + delta.X,function Fly.setup(Core)

                startPos.Y.Offset + delta.Y    Fly.Core = Core

            )    Fly.bv = Instance.new("BodyVelocity")

        end    Fly.bv.MaxForce = Vector3.new(4e5, 4e5, 4e5)

    end)    Fly.bv.Velocity = Vector3.new()

end    Fly.bg = Instance.new("BodyGyro")

    Fly.bg.MaxTorque = Vector3.new(4e5, 4e5, 4e5)

-- Criar tooltip    Fly.bg.P = 3000

local function create_tooltip(parent)    Fly.bg.D = 500

    local tooltip = Instance.new("Frame")

    tooltip.Name = "Tooltip"    Core.onCharacterAdded(function()

    tooltip.Size = UDim2.fromOffset(200, 35)        if Fly.enabled then

    tooltip.BackgroundColor3 = COLORS.surface            local st = Core.state()

    tooltip.BorderSizePixel = 0            Fly.bv.Parent = st.hrp

    tooltip.ZIndex = 1000            Fly.bg.Parent = st.hrp

    tooltip.Visible = false        end

    tooltip.Parent = parent    end)

end

    local corner = Instance.new("UICorner", tooltip)

    corner.CornerRadius = UDim.new(0, 8)function Fly.toggle()

  local st = Fly.Core.state()

    local stroke = Instance.new("UIStroke", tooltip)  Fly.enabled = not Fly.enabled

    stroke.Color = COLORS.border  if Fly.enabled then

    stroke.Thickness = 1    Fly.bv.Parent = st.hrp; Fly.bg.Parent = st.hrp

    Fly.Core.connect("fly_loop", Fly.Core.services().RunService.RenderStepped:Connect(function()

    local label = Instance.new("TextLabel", tooltip)      if not Fly.enabled then Fly.Core.disconnect("fly_loop"); return end

    label.Size = UDim2.new(1, -16, 1, 0)      local uis = Fly.Core.services().UserInputService

    label.Position = UDim2.fromOffset(8, 0)      local dir = Vector3.new()

    label.BackgroundTransparency = 1      if uis:IsKeyDown(Enum.KeyCode.W) then dir += st.hrp.CFrame.LookVector end

    label.Font = Enum.Font.GothamMedium      if uis:IsKeyDown(Enum.KeyCode.S) then dir -= st.hrp.CFrame.LookVector end

    label.TextSize = 13      if uis:IsKeyDown(Enum.KeyCode.A) then dir -= st.hrp.CFrame.RightVector end

    label.TextColor3 = COLORS.text_primary      if uis:IsKeyDown(Enum.KeyCode.D) then dir += st.hrp.CFrame.RightVector end

    label.TextXAlignment = Enum.TextXAlignment.Left      if uis:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end

      if uis:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.new(0,1,0) end

    return tooltip, label      Fly.bv.Velocity = dir.Magnitude > 0 and dir.Unit * 60 or Vector3.new()

end      Fly.bg.CFrame = CFrame.new(st.hrp.Position, st.hrp.Position + st.mouse.Hit.LookVector)

    end))

function UI.init(ctx)  else

    local Core = ctx.core    Fly.Core.disconnect("fly_loop"); Fly.bv.Parent = nil; Fly.bg.Parent = nil

    local st = Core.state()  end

    local playerGui = st.player:WaitForChild("PlayerGui")  return Fly.enabled

end

    -- Remover GUI antiga

    if playerGui:FindFirstChild("FK7_GUI") thenfunction Fly.disable()

        playerGui.FK7_GUI:Destroy()  if Fly.enabled then Fly.enabled=false; Fly.Core.disconnect("fly_loop"); Fly.bv.Parent=nil; Fly.bg.Parent=nil end

    endend



    local screenGui = Instance.new("ScreenGui")return Fly]]

    screenGui.Name = "FK7_GUI"  }

    screenGui.ResetOnSpawn = false  

    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling  if local_modules[name] then

    screenGui.Parent = playerGui    local chunk = loadstring(local_modules[name])

    if chunk then

    -- Frame principal      local ok, mod = pcall(chunk)

    local mainFrame = Instance.new("Frame")      if ok and mod then

    mainFrame.Size = UDim2.fromOffset(420, 520)        update_loading_progress(name)

    mainFrame.Position = UDim2.new(0.5, -210, 0.5, -260)        return mod

    mainFrame.BackgroundColor3 = COLORS.background      end

    mainFrame.BorderSizePixel = 0    end

    mainFrame.Parent = screenGui  end

  

    local mainCorner = Instance.new("UICorner", mainFrame)  -- Fallback para URLs remotas

    mainCorner.CornerRadius = UDim.new(0, 16)  local url = SOURCE[name]

  if url and url ~= "" then

    local mainStroke = Instance.new("UIStroke", mainFrame)    local ok, src = pcall(http_get, url)

    mainStroke.Color = COLORS.border    if ok and src and src ~= "" then

    mainStroke.Thickness = 1      local chunk, err = loadstring(src)

      if chunk then

    -- Cabeçalho        local ok2, mod = pcall(chunk)

    local header = Instance.new("Frame", mainFrame)        if ok2 and mod then

    header.Size = UDim2.new(1, 0, 0, 50)            update_loading_progress(name)

    header.BackgroundColor3 = COLORS.surface            return mod

    header.BorderSizePixel = 0        end

        warn("[FK7] Erro executando módulo", name, mod)

    local headerCorner = Instance.new("UICorner", header)      else

    headerCorner.CornerRadius = UDim.new(0, 16)        warn("[FK7] Erro compilando módulo", name, err)

      end

    make_draggable(mainFrame, header)    else

      warn("[FK7] Falha HttpGet módulo", name, src)

    -- Logo e título    end

    local logoIcon = Instance.new("TextLabel", header)  end

    logoIcon.Size = UDim2.fromOffset(32, 32)  

    logoIcon.Position = UDim2.fromOffset(16, 9)  error("[FK7] Não foi possível carregar módulo: "..name)

    logoIcon.BackgroundTransparency = 1end

    logoIcon.Text = "⚡"

    logoIcon.Font = Enum.Font.GothamBoldlocal env = getgenv and getgenv() or _G

    logoIcon.TextSize = 18env.FK7 = env.FK7 or {}

    logoIcon.TextColor3 = COLORS.primary

-- Carregamento dos módulos

    local title = Instance.new("TextLabel", header)local Core = load_module("core")

    title.Size = UDim2.new(1, -120, 1, 0)env.FK7.Core = Core

    title.Position = UDim2.fromOffset(56, 0)

    title.BackgroundTransparency = 1local UI = load_module("ui")

    title.Text = "FK7 Admin"local Features = {

    title.Font = Enum.Font.GothamBold  fly = load_module("fly"),

    title.TextSize = 16  noclip = load_module("noclip"),

    title.TextColor3 = COLORS.text_primary  speed = load_module("speed"),

    title.TextXAlignment = Enum.TextXAlignment.Left  teleport = load_module("teleport"),

  godmode = load_module("godmode"),

    -- Botões de controle  infinitejump = load_module("infinitejump"),

    local buttonContainer = Instance.new("Frame", header)  fullbright = load_module("fullbright"),

    buttonContainer.Size = UDim2.fromOffset(70, 30)  nofalldamage = load_module("nofalldamage"),

    buttonContainer.Position = UDim2.new(1, -85, 0.5, -15)  xray = load_module("xray"),

    buttonContainer.BackgroundTransparency = 1  esp = load_module("esp"),

  lowgravity = load_module("lowgravity"),

    local buttonLayout = Instance.new("UIListLayout", buttonContainer)  instantrespawn = load_module("instantrespawn"),

    buttonLayout.FillDirection = Enum.FillDirection.Horizontal  clicktp = load_module("clicktp"),

    buttonLayout.Padding = UDim.new(0, 8)  autofarm = load_module("autofarm"),

  walkthrough = load_module("walkthrough"),

    local function create_control_button(text, color, callback)  autojump = load_module("autojump"),

        local btn = Instance.new("TextButton", buttonContainer)}

        btn.Size = UDim2.fromOffset(30, 30)env.FK7.Features = Features

        btn.BackgroundColor3 = color

        btn.Text = text-- Setup dos módulos que precisam do Core

        btn.Font = Enum.Font.GothamBoldloadingUI.status.Text = "Configurando módulos..."

        btn.TextSize = 12pcall(function()

        btn.TextColor3 = COLORS.text_primary    for _, feature in pairs(Features) do

        btn.BorderSizePixel = 0        if feature.setup then

            feature.setup(Core)

        local corner = Instance.new("UICorner", btn)        end

        corner.CornerRadius = UDim.new(0, 8)    end

end)

        btn.MouseButton1Click:Connect(callback)

        return btn-- Finaliza a UI

    endloadingUI.status.Text = "Finalizando interface..."

task.wait(0.5)

    local minimizeBtn = create_control_button("−", COLORS.warning, function()UI.init({ core = Core, features = Features })

        local isMinimized = mainFrame.Size.Y.Offset <= 60

        local targetSize = isMinimized and UDim2.fromOffset(420, 520) or UDim2.fromOffset(420, 50)-- Animação de saída da tela de carregamento

        smooth_tween(mainFrame, {Size = targetSize}, 0.4):Play()local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    end)

-- Animar o fundo da tela

    local closeBtn = create_control_button("✕", COLORS.error, function()local backgroundTween = TweenService:Create(loadingUI.background, tweenInfo, {BackgroundTransparency = 1})

        local closeTween = smooth_tween(mainFrame, {backgroundTween:Play()

            Size = UDim2.fromOffset(0, 0),

            Position = UDim2.new(0.5, 0, 0.5, 0)-- Animar o container principal

        }, 0.3)local containerTween = TweenService:Create(loadingUI.container, tweenInfo, {BackgroundTransparency = 1})

        closeTween:Play()containerTween:Play()



        closeTween.Completed:Connect(function()-- Animar todos os elementos filhos

            if ctx.core and ctx.core.shutdown thenfor _, child in ipairs(loadingUI.container:GetChildren()) do

                ctx.core.shutdown()    if child:IsA("TextLabel") or child:IsA("TextButton") then

            end        -- Para elementos de texto

            screenGui:Destroy()        local childTween = TweenService:Create(child, tweenInfo, {

        end)            TextTransparency = 1, 

    end)            BackgroundTransparency = 1

        })

    -- Container principal com abas        childTween:Play()

    local body = Instance.new("Frame", mainFrame)    elseif child:IsA("Frame") then

    body.Size = UDim2.new(1, 0, 1, -50)        -- Para frames (como a barra de progresso)

    body.Position = UDim2.fromOffset(0, 50)        local childTween = TweenService:Create(child, tweenInfo, {

    body.BackgroundTransparency = 1            BackgroundTransparency = 1

        })

    -- Sistema de abas lateral        childTween:Play()

    local tabContainer = Instance.new("Frame", body)    elseif child:IsA("GuiObject") then

    tabContainer.Size = UDim2.fromOffset(110, 1)        -- Para outros elementos GUI

    tabContainer.BackgroundColor3 = COLORS.surface        local childTween = TweenService:Create(child, tweenInfo, {

    tabContainer.BorderSizePixel = 0            BackgroundTransparency = 1

        })

    local tabLayout = Instance.new("UIListLayout", tabContainer)        childTween:Play()

    tabLayout.Padding = UDim.new(0, 4)    end

    tabLayout.SortOrder = Enum.SortOrder.LayoutOrderend



    local tabPadding = Instance.new("UIPadding", tabContainer)-- Aguardar a animação terminar e destruir a GUI completamente

    tabPadding.PaddingTop = UDim.new(0, 12)containerTween.Completed:Wait()

    tabPadding.PaddingLeft = UDim.new(0, 8)if loadingUI.gui and loadingUI.gui.Parent then

    tabPadding.PaddingRight = UDim.new(0, 8)    loadingUI.gui:Destroy()

end

    -- Painel de informações do usuário

    local userPanel = Instance.new("Frame", tabContainer)print("[FK7] Loader pronto")

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

    -- Função para criar botões
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
        local originalColor = COLORS.surface
        btn.MouseEnter:Connect(function()
            smooth_tween(btn, {BackgroundColor3 = COLORS.surface_light}):Play()
            tooltipLabel.Text = description
            tooltip.Visible = true
        end)

        btn.MouseLeave:Connect(function()
            smooth_tween(btn, {BackgroundColor3 = originalColor}):Play()
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

    -- Página Movimento
    create_feature_button(movementPage, "Fly", "Voe livremente pelo mapa", function(btn, indicator, label)
        if ctx.features.fly then
            local enabled = ctx.features.fly.toggle()
            update_button_status(indicator, label, enabled, "Fly")
        else
            error("Módulo fly não encontrado")
        end
    end)

    create_feature_button(movementPage, "Noclip", "Atravesse paredes e objetos sólidos", function(btn, indicator, label)
        if ctx.features.noclip then
            local enabled = ctx.features.noclip.toggle()
            update_button_status(indicator, label, enabled, "Noclip")
        else
            error("Módulo noclip não encontrado")
        end
    end)

    create_feature_button(movementPage, "Speed", "Aumente sua velocidade de movimento", function(btn, indicator, label)
        if ctx.features.speed then
            local enabled = ctx.features.speed.toggle()
            update_button_status(indicator, label, enabled, "Speed")
        else
            error("Módulo speed não encontrado")
        end
    end)

    create_feature_button(movementPage, "Infinite Jump", "Pule infinitas vezes no ar", function(btn, indicator, label)
        if ctx.features.infinitejump then
            local enabled = ctx.features.infinitejump.toggle()
            update_button_status(indicator, label, enabled, "Infinite Jump")
        else
            error("Módulo infinitejump não encontrado")
        end
    end)

    create_feature_button(movementPage, "Click TP", "Teleporte clicando no mapa", function(btn, indicator, label)
        if ctx.features.clicktp then
            local enabled = ctx.features.clicktp.toggle()
            update_button_status(indicator, label, enabled, "Click TP")
        else
            error("Módulo clicktp não encontrado")
        end
    end)

    -- Página Combate
    create_feature_button(combatPage, "God Mode", "Torna você imortal", function(btn, indicator, label)
        if ctx.features.godmode then
            local enabled = ctx.features.godmode.toggle()
            update_button_status(indicator, label, enabled, "God Mode")
        else
            error("Módulo godmode não encontrado")
        end
    end)

    -- Página Visual
    create_feature_button(visualPage, "Full Bright", "Ilumina completamente o ambiente", function(btn, indicator, label)
        if ctx.features.fullbright then
            local enabled = ctx.features.fullbright.toggle()
            update_button_status(indicator, label, enabled, "Full Bright")
        else
            error("Módulo fullbright não encontrado")
        end
    end)

    create_feature_button(visualPage, "ESP", "Mostra informações de outros jogadores", function(btn, indicator, label)
        if ctx.features.esp then
            local enabled = ctx.features.esp.toggle()
            update_button_status(indicator, label, enabled, "ESP")
        else
            error("Módulo esp não encontrado")
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
]])

-- Inicializar sistema
if Modules.core then
    local Core = Modules.core
    Core.init()

    -- Registrar módulos no core
    for moduleName, module in pairs(Modules.features) do
        if module then
            Core.registerModule(moduleName, module)
        end
    end

    -- Inicializar UI
    if Modules.ui then
        Modules.ui.init({
            core = Core,
            features = Modules.features
        })
    end

    print("🎉 FK7 Admin carregado com sucesso!")
    print("📋 Comandos disponíveis:")
    print("   • Fly - Voe livremente (WASD + Space/Ctrl)")
    print("   • Noclip - Atravessar paredes")
    print("   • Speed - Velocidade aumentada")
    print("   • Infinite Jump - Pulo infinito")
    print("   • Click TP - Teleporte ao clicar")
    print("   • God Mode - Imortal")
    print("   • Full Bright - Iluminação total")
    print("   • ESP - Ver jogadores")
else
    warn("[FK7] Erro: Core não pôde ser carregado!")
end