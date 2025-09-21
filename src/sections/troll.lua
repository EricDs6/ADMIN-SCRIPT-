-- Seção Troll
local M = {}

function M.mount(ctx)
    local ui, content = ctx.ui, ctx.gui.contentFrame
    local y = ctx.yOffset
    ui.createLabel("Troll", UDim2.new(0, 10, 0, y), content)
    y = y + 35

    local trollButton = ui.createButton("Modo Troll: OFF", UDim2.new(0, 20, 0, y), nil, content)
    y = y + 45
    local flingButton = ui.createButton("Arremessar Jogadores", UDim2.new(0, 20, 0, y), nil, content)
    y = y + 45
    local spinButton = ui.createButton("Girar: OFF", UDim2.new(0, 20, 0, y), nil, content)
    y = y + 45
    local rainbowButton = ui.createButton("Arco-Íris: OFF", UDim2.new(0, 20, 0, y), nil, content)
    y = y + 45
    local freezeAllButton = ui.createButton("Congelar Todos: OFF", UDim2.new(0, 20, 0, y), nil, content)
    y = y + 55

    local state = { troll = false, spin = false, rainbow = false, freezeAll = false }
    local connections = ctx.connections
    local player = ctx.player
    local Players = game:GetService("Players")
    local humanoidRootPart = ctx.humanoidRootPart

    local function update(btn, on, label) ui.updateButtonState(btn, on, label) end

    local function toggleTroll()
        state.troll = not state.troll
        update(trollButton, state.troll, "Modo Troll")
    end

    local function toggleSpin()
        state.spin = not state.spin
        update(spinButton, state.spin, "Girar")
        if state.spin then
            local spinGyro = Instance.new("BodyAngularVelocity")
            spinGyro.AngularVelocity = Vector3.new(0, 50, 0)
            spinGyro.MaxTorque = Vector3.new(0, math.huge, 0)
            spinGyro.Parent = humanoidRootPart
            connections.spin = { spinGyro }
        else
            if connections.spin then
                for _, obj in ipairs(connections.spin) do pcall(function() obj:Destroy() end) end
                connections.spin = nil
            end
        end
    end

    local function toggleRainbow()
        state.rainbow = not state.rainbow
        update(rainbowButton, state.rainbow, "Arco-Íris")
        if state.rainbow then
            connections.rainbow = game:GetService("RunService").Heartbeat:Connect(function()
                if not state.rainbow then return end
                local hue = tick() % 5 / 5
                local color = Color3.fromHSV(hue, 1, 1)
                local character = ctx.character
                for _, part in pairs(character:GetChildren()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.Color = color
                    end
                end
            end)
        else
            if connections.rainbow then connections.rainbow:Disconnect() end
            for _, part in pairs(ctx.character:GetChildren()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.Color = Color3.new(1, 1, 1)
                end
            end
        end
    end

    local function performFling()
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local distance = (humanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                if distance <= 50 then
                    local bodyVel = Instance.new("BodyVelocity")
                    bodyVel.MaxForce = Vector3.new(4000, 4000, 4000)
                    bodyVel.Velocity = (p.Character.HumanoidRootPart.Position - humanoidRootPart.Position).Unit * 200
                    bodyVel.Parent = p.Character.HumanoidRootPart
                    game:GetService("Debris"):AddItem(bodyVel, 2)
                end
            end
        end
    end

    local function toggleFreezeAll()
        state.freezeAll = not state.freezeAll
        update(freezeAllButton, state.freezeAll, "Congelar Todos")
        if state.freezeAll then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    pcall(function() p.Character.HumanoidRootPart.Anchored = true end)
                end
            end
        else
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    pcall(function() p.Character.HumanoidRootPart.Anchored = false end)
                end
            end
        end
    end

    trollButton.MouseButton1Click:Connect(toggleTroll)
    flingButton.MouseButton1Click:Connect(performFling)
    spinButton.MouseButton1Click:Connect(toggleSpin)
    rainbowButton.MouseButton1Click:Connect(toggleRainbow)
    freezeAllButton.MouseButton1Click:Connect(toggleFreezeAll)

    ctx.yOffset = y

    local function reset()
        if state.troll then toggleTroll() end
        if state.spin then toggleSpin() end
        if state.rainbow then toggleRainbow() end
        if state.freezeAll then toggleFreezeAll() end
    end

    return { reset = reset }
end

return M
