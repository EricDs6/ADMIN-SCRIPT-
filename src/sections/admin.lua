-- Seção Admin
local M = {}

function M.mount(ctx)
    local ui, content = ctx.ui, ctx.gui.contentFrame
    local y = ctx.yOffset
    ui.createLabel("Admin", UDim2.new(0, 10, 0, y), content)
    y = y + 35

    local btoolsButton = ui.createButton("Dar Btools", UDim2.new(0, 20, 0, y), nil, content)
    y = y + 45
    local wallClimbButton = ui.createButton("Escalar Parede: OFF", UDim2.new(0, 20, 0, y), nil, content)
    y = y + 45
    local swimInAirButton = ui.createButton("Nadar no Ar: OFF", UDim2.new(0, 20, 0, y), nil, content)
    y = y + 55

    local state = { wallClimb = false, swim = false }
    local connections = ctx.connections
    local humanoid = ctx.humanoid
    local hrp = ctx.humanoidRootPart

    local function giveBtools()
        local tools = {"Clone", "Hammer", "Grab"}
        for _, toolName in pairs(tools) do
            local tool = Instance.new("Tool")
            tool.Name = toolName
            tool.RequiresHandle = false
            tool.Parent = ctx.player.Backpack
        end
    end

    local function toggleWallClimb()
        state.wallClimb = not state.wallClimb
        ui.updateButtonState(wallClimbButton, state.wallClimb, "Escalar Parede")
        if state.wallClimb then
            connections.wallClimb = game:GetService("RunService").RenderStepped:Connect(function()
                if state.wallClimb and game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
                    local origin = hrp.Position
                    local direction = hrp.CFrame.LookVector * 3
                    local raycastParams = RaycastParams.new()
                    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
                    raycastParams.FilterDescendantsInstances = {ctx.character}
                    local raycastResult = workspace:Raycast(origin, direction, raycastParams)
                    if raycastResult and raycastResult.Distance <= 3 then
                        hrp.Velocity = Vector3.new(hrp.Velocity.X, 30, hrp.Velocity.Z)
                        if humanoid:GetState() ~= Enum.HumanoidStateType.Jumping then
                            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                        end
                    end
                end
            end)
        else
            if connections.wallClimb then connections.wallClimb:Disconnect() end
        end
    end

    local function toggleSwimInAir()
        state.swim = not state.swim
        ui.updateButtonState(swimInAirButton, state.swim, "Nadar no Ar")
        if state.swim then
            connections.swim = game:GetService("RunService").Heartbeat:Connect(function()
                if state.swim and humanoid:GetState() ~= Enum.HumanoidStateType.Swimming then
                    humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
                end
            end)
        else
            if connections.swim then connections.swim:Disconnect() end
            humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end
    end

    btoolsButton.MouseButton1Click:Connect(giveBtools)
    wallClimbButton.MouseButton1Click:Connect(toggleWallClimb)
    swimInAirButton.MouseButton1Click:Connect(toggleSwimInAir)

    ctx.yOffset = y

    local function reset()
        if state.wallClimb then toggleWallClimb() end
        if state.swim then toggleSwimInAir() end
    end

    return { reset = reset }
end

return M
