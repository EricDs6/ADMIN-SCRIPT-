-- modules/ui.lua - Painel moderno e organizado
local UI = {}

local function create_draggable(gui)
    local is_dragging = false
    local drag_start
    local frame_start

    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            is_dragging = true
            drag_start = input.Position
            frame_start = gui.Parent.Position
        end
    end)

    gui.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            is_dragging = false
        end
    end)

    gui.InputChanged:Connect(function(input)
        if is_dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - drag_start
            gui.Parent.Position = UDim2.new(frame_start.X.Scale, frame_start.X.Offset + delta.X, frame_start.Y.Scale, frame_start.Y.Offset + delta.Y)
        end
    end)
end

function UI.init(ctx)
    local Core = ctx.core
    local st = Core.state()
    local playerGui = st.player:WaitForChild("PlayerGui")

    -- Remover GUI antiga se existir
    if playerGui:FindFirstChild("FK7_GUI") then
        playerGui.FK7_GUI:Destroy()
    end

    local gui = Instance.new("ScreenGui")
    gui.Name = "FK7_GUI"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = playerGui

    -- Painel Principal
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 280, 0, 350)
    mainFrame.Position = UDim2.new(0, 50, 0.5, -175)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 28, 35)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = gui

    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke", mainFrame)
    stroke.Color = Color3.fromRGB(80, 80, 100)
    stroke.Thickness = 1
    stroke.Transparency = 0.5

    local mainGradient = Instance.new("UIGradient", mainFrame)
    mainGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 40, 50)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 28, 35))
    }
    mainGradient.Rotation = 90

    -- Cabeçalho
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 40)
    header.BackgroundColor3 = Color3.fromRGB(30, 35, 45)
    header.BackgroundTransparency = 0.5
    header.BorderSizePixel = 0
    header.Parent = mainFrame
    create_draggable(header)

    local headerGradient = Instance.new("UIGradient", header)
    headerGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 50, 65)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 45, 60))
    }

    local title = Instance.new("TextLabel", header)
    title.Size = UDim2.new(1, -80, 1, 0)
    title.Position = UDim2.new(0, 15, 0, 0)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.Text = "FK7 Admin"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.TextSize = 16
    title.TextXAlignment = Enum.TextXAlignment.Left

    -- Botão de Fechar
    local closeButton = Instance.new("TextButton", header)
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0.5, -15)
    closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeButton.Text = "X"
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextSize = 14
    closeButton.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", closeButton).CornerRadius = UDim.new(0, 6)

    closeButton.MouseButton1Click:Connect(function()
        gui:Destroy()
        -- A lógica de encerramento completo será adicionada aqui
    end)

    -- Container de conteúdo
    local content = Instance.new("ScrollingFrame", mainFrame)
    content.Size = UDim2.new(1, -20, 1, -50)
    content.Position = UDim2.new(0, 10, 0, 45)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.CanvasSize = UDim2.new(0, 0, 0, 0)
    content.ScrollBarThickness = 6

    local layout = Instance.new("UIListLayout", content)
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    -- Função para criar botões
    local function create_button(text, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 35)
        btn.BackgroundColor3 = Color3.fromRGB(40, 45, 65)
        btn.Text = text
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 15
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Parent = content

        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        local btnStroke = Instance.new("UIStroke", btn)
        btnStroke.Color = Color3.fromRGB(70, 75, 95)
        btnStroke.Thickness = 1

        btn.MouseButton1Click:Connect(function()
            callback(btn)
        end)
        return btn
    end

    -- Botão de Voo
    create_button("✈️ Voo", function(btn)
        local enabled = ctx.features.fly.toggle()
        if enabled then
            btn.Text = "✈️ Voo (ON)"
            btn.BackgroundColor3 = Color3.fromRGB(70, 120, 90)
        else
            btn.Text = "✈️ Voo (OFF)"
            btn.BackgroundColor3 = Color3.fromRGB(40, 45, 65)
        end
    end)

    -- Botão de Noclip
    create_button("👻 Noclip", function(btn)
        local enabled = ctx.features.noclip.toggle()
        if enabled then
            btn.Text = "👻 Noclip (ON)"
            btn.BackgroundColor3 = Color3.fromRGB(70, 120, 90)
        else
            btn.Text = "👻 Noclip (OFF)"
            btn.BackgroundColor3 = Color3.fromRGB(40, 45, 65)
        end
    end)

    -- Botão de Speed
    create_button("⚡ Speed", function(btn)
        local enabled = ctx.features.speed.toggle()
        if enabled then
            btn.Text = "⚡ Speed (ON)"
            btn.BackgroundColor3 = Color3.fromRGB(70, 120, 90)
        else
            btn.Text = "⚡ Speed (OFF)"
            btn.BackgroundColor3 = Color3.fromRGB(40, 45, 65)
        end
    end)

    -- Botão de Teleport
    create_button("🎯 Click TP", function(btn)
        local enabled = ctx.features.teleport.toggle()
        if enabled then
            btn.Text = "🎯 Click TP (ON)"
            btn.BackgroundColor3 = Color3.fromRGB(70, 120, 90)
        else
            btn.Text = "🎯 Click TP (OFF)"
            btn.BackgroundColor3 = Color3.fromRGB(40, 45, 65)
        end
    end)

    -- Botão de God Mode
    create_button("❤️ God Mode", function(btn)
        local enabled = ctx.features.godmode.toggle()
        if enabled then
            btn.Text = "❤️ God Mode (ON)"
            btn.BackgroundColor3 = Color3.fromRGB(70, 120, 90)
        else
            btn.Text = "❤️ God Mode (OFF)"
            btn.BackgroundColor3 = Color3.fromRGB(40, 45, 65)
        end
    end)

    -- Botão de Infinite Jump
    create_button("👟 Infinite Jump", function(btn)
        local enabled = ctx.features.infinitejump.toggle()
        if enabled then
            btn.Text = "👟 Infinite Jump (ON)"
            btn.BackgroundColor3 = Color3.fromRGB(70, 120, 90)
        else
            btn.Text = "👟 Infinite Jump (OFF)"
            btn.BackgroundColor3 = Color3.fromRGB(40, 45, 65)
        end
    end)

    -- Botão de Full Bright
    create_button("💡 Full Bright", function(btn)
        local enabled = ctx.features.fullbright.toggle()
        if enabled then
            btn.Text = "💡 Full Bright (ON)"
            btn.BackgroundColor3 = Color3.fromRGB(70, 120, 90)
        else
            btn.Text = "💡 Full Bright (OFF)"
            btn.BackgroundColor3 = Color3.fromRGB(40, 45, 65)
        end
    end)

    -- Atualizar CanvasSize
    content.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
end

return UI
