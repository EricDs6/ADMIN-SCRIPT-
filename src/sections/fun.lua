-- Seção Diversão
local M = {}

function M.mount(ctx)
    local ui, content = ctx.ui, ctx.gui.contentFrame
    local y = ctx.yOffset
    ui.createLabel("Diversão", UDim2.new(0, 10, 0, y), content)
    y = y + 35

    local flashlightButton = ui.createButton("Lanterna: OFF", UDim2.new(0, 20, 0, y), nil, content)
    y = y + 45
    local reachButton = ui.createButton("Alcance: OFF", UDim2.new(0, 20, 0, y), nil, content)
    y = y + 45
    local bigHeadButton = ui.createButton("Cabeça Grande: OFF", UDim2.new(0, 20, 0, y), nil, content)
    y = y + 55

    local state = { flashlight = false, reach = false, bigHead = false }
    local connections = ctx.connections
    local character = ctx.character
    local humanoidRootPart = ctx.humanoidRootPart

    local function update(btn, on, label) ui.updateButtonState(btn, on, label) end

    local function toggleFlashlight()
        state.flashlight = not state.flashlight
        update(flashlightButton, state.flashlight, "Lanterna")
        if state.flashlight then
            local light = Instance.new("PointLight")
            light.Brightness = 10
            light.Range = 60
            light.Parent = character:FindFirstChild("Head") or humanoidRootPart
            connections.flashlight = light
        else
            if connections.flashlight then pcall(function() connections.flashlight:Destroy() end) end
            connections.flashlight = nil
        end
    end

    local function toggleReach()
        state.reach = not state.reach
        update(reachButton, state.reach, "Alcance")
        if state.reach then
            connections.reach = game:GetService("RunService").Heartbeat:Connect(function()
                if not state.reach then return end
                for _, tool in pairs(character:GetChildren()) do
                    if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
                        tool.Handle.Size = Vector3.new(0.5, 0.5, 20)
                    end
                end
            end)
        else
            if connections.reach then connections.reach:Disconnect() end
            for _, tool in pairs(character:GetChildren()) do
                if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
                    tool.Handle.Size = Vector3.new(0.5, 0.5, 0.5)
                end
            end
        end
    end

    local function toggleBigHead()
        state.bigHead = not state.bigHead
        update(bigHeadButton, state.bigHead, "Cabeça Grande")
        if character and character:FindFirstChild("Head") then
            local head = character.Head
            pcall(function()
                head.Size = state.bigHead and Vector3.new(4,4,4) or Vector3.new(2,1,1)
                local mesh = head:FindFirstChild("Mesh")
                if mesh then
                    mesh.Scale = state.bigHead and Vector3.new(2,2,2) or Vector3.new(1,1,1)
                end
            end)
        end
    end

    flashlightButton.MouseButton1Click:Connect(toggleFlashlight)
    reachButton.MouseButton1Click:Connect(toggleReach)
    bigHeadButton.MouseButton1Click:Connect(toggleBigHead)

    ctx.yOffset = y

    local function reset()
        if state.flashlight then toggleFlashlight() end
        if state.reach then toggleReach() end
        if state.bigHead then toggleBigHead() end
    end

    local function onCharacterAdded()
        if state.flashlight and connections.flashlight and not connections.flashlight.Parent then
            local light = Instance.new("PointLight")
            light.Brightness = 10
            light.Range = 60
            light.Parent = character:FindFirstChild("Head") or humanoidRootPart
            connections.flashlight = light
        end
    end

    return { reset = reset, onCharacterAdded = onCharacterAdded }
end

return M
