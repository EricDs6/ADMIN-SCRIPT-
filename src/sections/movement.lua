-- Seção: Movimento
-- Exporta: mount(ctx) -> { reset=fn, onCharacterAdded=fn }

local M = {}

function M.mount(ctx)
    local ui = ctx.ui
    local contentFrame = ctx.gui.contentFrame
    local connections = ctx.connections
    local originals = ctx.originals
    local player = ctx.player
    local character = ctx.character
    local humanoid = ctx.humanoid
    local hrp = ctx.humanoidRootPart
    local UserInputService = ctx.services.UserInputService
    local RunService = ctx.services.RunService
    local workspace = ctx.services.workspace

    -- Estados
    local flyEnabled = false
    local noclipEnabled = false
    local speedHackEnabled = false
    local jumpHackEnabled = false
    local infiniteJumpEnabled = false
    local flySpeed = 50
    local speedHackSpeed = 100
    local jumpHackPower = 200

    -- Objetos de física dedicados à seção
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(400000, 400000, 400000)
    bodyVelocity.Velocity = Vector3.new()
    local bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(400000, 400000, 400000)
    bodyGyro.P = 3000
    bodyGyro.D = 500

    -- UI
    ctx.yOffset = ctx.yOffset or 50
    local movimentoLabel = ui.createLabel("Movimento", UDim2.new(0, 10, 0, ctx.yOffset)); ctx.yOffset += 35
    local flyButton = ui.createButton("Voo: OFF", UDim2.new(0, 20, 0, ctx.yOffset)); ctx.yOffset += 45
    local flyControl = ui.createValueControl("Velocidade", flySpeed, 10, 500, 10, UDim2.new(0, 20, 0, ctx.yOffset)); ctx.yOffset += 45
    local noclipButton = ui.createButton("Sem Colisão: OFF", UDim2.new(0, 20, 0, ctx.yOffset)); ctx.yOffset += 45
    local speedHackButton = ui.createButton("Velocidade Hack: OFF", UDim2.new(0, 20, 0, ctx.yOffset)); ctx.yOffset += 45
    local speedHackControl = ui.createValueControl("Velocidade", speedHackSpeed, 50, 500, 10, UDim2.new(0, 20, 0, ctx.yOffset)); ctx.yOffset += 45
    local jumpHackButton = ui.createButton("Pulo Hack: OFF", UDim2.new(0, 20, 0, ctx.yOffset)); ctx.yOffset += 45
    local jumpHackControl = ui.createValueControl("Força", jumpHackPower, 50, 1000, 10, UDim2.new(0, 20, 0, ctx.yOffset)); ctx.yOffset += 45
    local infiniteJumpButton = ui.createButton("Pulo Infinito: OFF", UDim2.new(0, 20, 0, ctx.yOffset)); ctx.yOffset += 55

    local function updateFlySpeedLabel()
        flyControl.updateLabel(flySpeed)
    end
    local function updateSpeedHackLabel()
        speedHackControl.updateLabel(speedHackSpeed)
    end
    local function updateJumpHackLabel()
        jumpHackControl.updateLabel(jumpHackPower)
    end

    local function toggleFly()
        flyEnabled = not flyEnabled
        ui.updateButtonState(flyButton, flyEnabled, "Voo")
        if flyEnabled then
            originals.stateEnabled = originals.stateEnabled or {}
            for _, st in ipairs({Enum.HumanoidStateType.Freefall, Enum.HumanoidStateType.FallingDown, Enum.HumanoidStateType.Ragdoll}) do
                originals.stateEnabled[st] = humanoid:GetStateEnabled(st)
                pcall(function() humanoid:SetStateEnabled(st, false) end)
            end
            bodyVelocity.Parent = hrp
            bodyGyro.Parent = hrp
            connections.fly = RunService.Heartbeat:Connect(function()
                local moveVector = Vector3.new()
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVector += workspace.CurrentCamera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVector -= workspace.CurrentCamera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVector -= workspace.CurrentCamera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVector += workspace.CurrentCamera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveVector += Vector3.new(0,1,0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveVector -= Vector3.new(0,1,0) end
                bodyVelocity.Velocity = moveVector * flySpeed
                bodyGyro.CFrame = workspace.CurrentCamera.CFrame
                if humanoid and humanoid:GetState() ~= Enum.HumanoidStateType.RunningNoPhysics then
                    pcall(function() humanoid:ChangeState(Enum.HumanoidStateType.RunningNoPhysics) end)
                end
            end)
        else
            if connections.fly then connections.fly:Disconnect() end
            bodyVelocity.Parent = nil
            bodyGyro.Parent = nil
            if originals.stateEnabled then
                for st, wasEnabled in pairs(originals.stateEnabled) do
                    pcall(function() humanoid:SetStateEnabled(st, wasEnabled) end)
                end
                originals.stateEnabled = nil
            end
            local rayParams = RaycastParams.new(); rayParams.FilterType = Enum.RaycastFilterType.Exclude; rayParams.FilterDescendantsInstances = {character}
            local result = workspace:Raycast(hrp.Position, Vector3.new(0,-1000,0), rayParams)
            if result then hrp.CFrame = CFrame.new(hrp.Position.X, result.Position.Y + 3, hrp.Position.Z) end
            hrp.Velocity = Vector3.new()
        end
    end

    local function toggleNoclip()
        noclipEnabled = not noclipEnabled
        ui.updateButtonState(noclipButton, noclipEnabled, "Sem Colisão")
        if noclipEnabled then
            connections.noclip = RunService.Stepped:Connect(function()
                for _, part in pairs(character:GetChildren()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end)
        else
            if connections.noclip then connections.noclip:Disconnect() end
            for _, part in pairs(character:GetChildren()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then part.CanCollide = true end
            end
        end
    end

    local function toggleSpeedHack()
        speedHackEnabled = not speedHackEnabled
        ui.updateButtonState(speedHackButton, speedHackEnabled, "Velocidade Hack")
        if speedHackEnabled then
            originals.walkSpeed = humanoid.WalkSpeed
            humanoid.WalkSpeed = speedHackSpeed
        else
            humanoid.WalkSpeed = originals.walkSpeed or 16
        end
    end

    local function toggleJumpHack()
        jumpHackEnabled = not jumpHackEnabled
        ui.updateButtonState(jumpHackButton, jumpHackEnabled, "Pulo Hack")
        if jumpHackEnabled then
            originals.jumpPower = humanoid.JumpPower or humanoid.JumpHeight
            if humanoid:FindFirstChild("JumpPower") then
                humanoid.JumpPower = jumpHackPower
            else
                humanoid.JumpHeight = jumpHackPower
            end
        else
            if humanoid:FindFirstChild("JumpPower") then
                humanoid.JumpPower = originals.jumpPower or 50
            else
                humanoid.JumpHeight = originals.jumpPower or 7.2
            end
        end
    end

    local function toggleInfiniteJump()
        infiniteJumpEnabled = not infiniteJumpEnabled
        ui.updateButtonState(infiniteJumpButton, infiniteJumpEnabled, "Pulo Infinito")
        if infiniteJumpEnabled then
            connections.infiniteJump = UserInputService.JumpRequest:Connect(function()
                if infiniteJumpEnabled then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
            end)
        else
            if connections.infiniteJump then connections.infiniteJump:Disconnect() end
        end
    end

    -- Bindings
    flyButton.MouseButton1Click:Connect(toggleFly)
    noclipButton.MouseButton1Click:Connect(toggleNoclip)
    speedHackButton.MouseButton1Click:Connect(toggleSpeedHack)
    jumpHackButton.MouseButton1Click:Connect(toggleJumpHack)
    infiniteJumpButton.MouseButton1Click:Connect(toggleInfiniteJump)

    flyControl.minusButton.MouseButton1Click:Connect(function()
        flySpeed = math.max(10, flySpeed - 10); updateFlySpeedLabel()
    end)
    flyControl.plusButton.MouseButton1Click:Connect(function()
        flySpeed = math.min(500, flySpeed + 10); updateFlySpeedLabel()
    end)
    speedHackControl.minusButton.MouseButton1Click:Connect(function()
        speedHackSpeed = math.max(50, speedHackSpeed - 10); updateSpeedHackLabel(); if speedHackEnabled then humanoid.WalkSpeed = speedHackSpeed end
    end)
    speedHackControl.plusButton.MouseButton1Click:Connect(function()
        speedHackSpeed = math.min(500, speedHackSpeed + 10); updateSpeedHackLabel(); if speedHackEnabled then humanoid.WalkSpeed = speedHackSpeed end
    end)
    jumpHackControl.minusButton.MouseButton1Click:Connect(function()
        jumpHackPower = math.max(50, jumpHackPower - 10); updateJumpHackLabel(); if jumpHackEnabled then toggleJumpHack(); toggleJumpHack() end
    end)
    jumpHackControl.plusButton.MouseButton1Click:Connect(function()
        jumpHackPower = math.min(1000, jumpHackPower + 10); updateJumpHackLabel(); if jumpHackEnabled then toggleJumpHack(); toggleJumpHack() end
    end)

    -- Callbacks
    local function reset()
        if flyEnabled then toggleFly() end
        if noclipEnabled then toggleNoclip() end
        if speedHackEnabled then toggleSpeedHack() end
        if jumpHackEnabled then toggleJumpHack() end
        if infiniteJumpEnabled then toggleInfiniteJump() end
    end

    local function onCharacterAdded(newChar)
        character = newChar
        humanoid = newChar:WaitForChild("Humanoid")
        hrp = newChar:WaitForChild("HumanoidRootPart")
        if flyEnabled then
            -- Reparent physics movers to new HRP
            bodyVelocity.Parent = hrp
            bodyGyro.Parent = hrp
        end
    end

    return { reset = reset, onCharacterAdded = onCharacterAdded }
end

return M
