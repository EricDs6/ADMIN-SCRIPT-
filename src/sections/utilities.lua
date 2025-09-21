-- Seção Utilidades
local M = {}

function M.mount(ctx)
    local ui, content = ctx.ui, ctx.gui.contentFrame
    local y = ctx.yOffset
    ui.createLabel("Utilidades", UDim2.new(0, 10, 0, y), content)
    y = y + 35

    local invisibleButton = ui.createButton("Invisível: OFF", UDim2.new(0, 20, 0, y), nil, content)
    y = y + 45
    local lowGravityButton = ui.createButton("Gravidade Baixa: OFF", UDim2.new(0, 20, 0, y), nil, content)
    y = y + 45
    local autoHealButton = ui.createButton("Cura Automática: OFF", UDim2.new(0, 20, 0, y), nil, content)
    y = y + 45
    local antiFallButton = ui.createButton("Anti-Queda: OFF", UDim2.new(0, 20, 0, y), nil, content)
    y = y + 45
    local noFallDamageButton = ui.createButton("Sem Dano de Queda: OFF", UDim2.new(0, 20, 0, y), nil, content)
    y = y + 45
    local anchorButton = ui.createButton("Grudar no Chão: OFF", UDim2.new(0, 20, 0, y), nil, content)
    y = y + 45
    local carryPartsButton = ui.createButton("Carregar Partes: OFF", UDim2.new(0, 20, 0, y), nil, content)
    y = y + 45
    local markPartsButton = ui.createButton("Marcar Partes: OFF", UDim2.new(0, 20, 0, y), nil, content)
    y = y + 45
    local antiAfkButton = ui.createButton("Anti-AFK: OFF", UDim2.new(0, 20, 0, y), nil, content)
    y = y + 45
    local fullBrightButton = ui.createButton("Brilho Total: OFF", UDim2.new(0, 20, 0, y), nil, content)
    y = y + 45
    local xrayButton = ui.createButton("Raio-X: OFF", UDim2.new(0, 20, 0, y), nil, content)
    y = y + 55

    local state = {
        invisible = false,
        lowGravity = false,
        autoHeal = false,
        antiFall = false,
        noFallDamage = false,
        anchor = false,
        carryParts = false,
        markParts = false,
        antiAfk = false,
        fullBright = false,
        xray = false,
    }

    local connections = ctx.connections
    local originals = ctx.originals
    local character = ctx.character
    local humanoid = ctx.humanoid
    local hrp = ctx.humanoidRootPart
    local Lighting = ctx.services.Lighting
    local TweenService = ctx.services.TweenService
    local Players = ctx.services.Players

    local function applyInvisibility(on)
        if not character then return end
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                part.Transparency = on and 1 or 0
            elseif part:IsA("Accessory") and part:FindFirstChild("Handle") then
                part.Handle.Transparency = on and 1 or 0
            end
        end
        local head = character:FindFirstChild("Head")
        if head and head:FindFirstChild("face") then
            head.face.Transparency = on and 1 or 0
        end
    end

    local function toggleInvisible()
        state.invisible = not state.invisible
        ui.updateButtonState(invisibleButton, state.invisible, "Invisível")
        applyInvisibility(state.invisible)
    end

    local function toggleFullBright()
        state.fullBright = not state.fullBright
        ui.updateButtonState(fullBrightButton, state.fullBright, "Brilho Total")
        if state.fullBright then
            originals.brightness = Lighting.Brightness
            originals.ambient = Lighting.Ambient
            Lighting.Brightness = 2
            Lighting.Ambient = Color3.new(1, 1, 1)
        else
            Lighting.Brightness = originals.brightness or 1
            Lighting.Ambient = originals.ambient or Color3.new(0, 0, 0)
        end
    end

    local function toggleLowGravity()
        state.lowGravity = not state.lowGravity
        ui.updateButtonState(lowGravityButton, state.lowGravity, "Gravidade Baixa")
        if state.lowGravity then
            originals.gravity = workspace.Gravity
            workspace.Gravity = 50
        else
            workspace.Gravity = originals.gravity or 196.2
        end
    end

    local function toggleAutoHeal()
        state.autoHeal = not state.autoHeal
        ui.updateButtonState(autoHealButton, state.autoHeal, "Cura Automática")
        if state.autoHeal then
            connections.autoHeal = ctx.services.RunService.Heartbeat:Connect(function()
                if state.autoHeal and humanoid.Health < humanoid.MaxHealth then
                    humanoid.Health = humanoid.MaxHealth
                end
            end)
        else
            if connections.autoHeal then connections.autoHeal:Disconnect() end
        end
    end

    local function toggleAntiFall()
        state.antiFall = not state.antiFall
        ui.updateButtonState(antiFallButton, state.antiFall, "Anti-Queda")
        if state.antiFall then
            connections.antiFall = ctx.services.RunService.Heartbeat:Connect(function()
                if state.antiFall and hrp.Position.Y < -50 then
                    hrp.CFrame = CFrame.new(hrp.Position.X, 50, hrp.Position.Z)
                end
            end)
        else
            if connections.antiFall then connections.antiFall:Disconnect() end
        end
    end

    local fallContext = { inFreefall = false, startY = 0, startHealth = 0 }
    local function attachNoFallDamage()
        if connections.noFallDamageState then pcall(function() connections.noFallDamageState:Disconnect() end) end
        if connections.noFallDamageHealth then pcall(function() connections.noFallDamageHealth:Disconnect() end) end
        connections.noFallDamageState = humanoid.StateChanged:Connect(function(_, newState)
            if not state.noFallDamage then return end
            if newState == Enum.HumanoidStateType.Freefall then
                fallContext.inFreefall = true
                fallContext.startY = hrp.Position.Y
                fallContext.startHealth = humanoid.Health
            elseif fallContext.inFreefall and (newState == Enum.HumanoidStateType.Landed or newState == Enum.HumanoidStateType.Running or newState == Enum.HumanoidStateType.RunningNoPhysics) then
                fallContext.inFreefall = false
                local drop = (fallContext.startY - hrp.Position.Y)
                if drop > 10 then
                    task.defer(function()
                        if state.noFallDamage and humanoid and humanoid.Health < fallContext.startHealth then
                            humanoid.Health = math.max(humanoid.Health, fallContext.startHealth)
                        end
                    end)
                end
            end
        end)
        connections.noFallDamageHealth = humanoid.HealthChanged:Connect(function()
            if state.noFallDamage and fallContext.startHealth > 0 and fallContext.inFreefall then
                if humanoid.Health < fallContext.startHealth then
                    humanoid.Health = math.max(humanoid.Health, fallContext.startHealth)
                end
            end
        end)
    end

    local function toggleNoFallDamage()
        state.noFallDamage = not state.noFallDamage
        ui.updateButtonState(noFallDamageButton, state.noFallDamage, "Sem Dano de Queda")
        if state.noFallDamage then
            attachNoFallDamage()
        else
            if connections.noFallDamageState then connections.noFallDamageState:Disconnect() end
            if connections.noFallDamageHealth then connections.noFallDamageHealth:Disconnect() end
            fallContext.inFreefall, fallContext.startY, fallContext.startHealth = false, 0, 0
        end
    end

    local anchorConn
    local function toggleAnchor()
        state.anchor = not state.anchor
        ui.updateButtonState(anchorButton, state.anchor, "Grudar no Chão")
        if state.anchor then
            local rayParams = RaycastParams.new()
            rayParams.FilterType = Enum.RaycastFilterType.Exclude
            rayParams.FilterDescendantsInstances = {character}
            local raycastResult = workspace:Raycast(hrp.Position, Vector3.new(0, -1000, 0), rayParams)
            if raycastResult then
                local groundY = raycastResult.Position.Y
                hrp.CFrame = CFrame.new(hrp.Position.X, groundY + 3, hrp.Position.Z)
            end
            hrp.Anchored = true
            humanoid.PlatformStand = true
            anchorConn = ctx.services.RunService.Heartbeat:Connect(function()
                if state.anchor and hrp then
                    local newRaycast = workspace:Raycast(hrp.Position, Vector3.new(0, -50, 0), rayParams)
                    if newRaycast then
                        local newGroundY = newRaycast.Position.Y
                        local currentPos = hrp.Position
                        hrp.CFrame = CFrame.new(currentPos.X, newGroundY + 3, currentPos.Z)
                    end
                end
            end)
        else
            if anchorConn then anchorConn:Disconnect(); anchorConn = nil end
            hrp.Anchored = false
            humanoid.PlatformStand = false
        end
    end

    local carriedParts, carryOffsets = {}, {}
    local function toggleCarryParts()
        state.carryParts = not state.carryParts
        ui.updateButtonState(carryPartsButton, state.carryParts, "Carregar Partes")
        if state.carryParts then
            local partCount = 0
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and obj ~= hrp and not obj.Anchored and obj.Parent ~= character then
                    local distance = (obj.Position - hrp.Position).Magnitude
                    if distance <= 20 then
                        local isCarried = false
                        for _, bodyMover in pairs(obj:GetChildren()) do
                            if bodyMover:IsA("BodyVelocity") or bodyMover:IsA("BodyPosition") then isCarried = true break end
                        end
                        if not isCarried then
                            table.insert(carriedParts, obj)
                            carryOffsets[obj] = obj.Position - hrp.Position
                            local bodyPosition = Instance.new("BodyPosition")
                            bodyPosition.MaxForce = Vector3.new(4000, 4000, 4000)
                            bodyPosition.P = 3000
                            bodyPosition.D = 500
                            bodyPosition.Parent = obj
                            bodyPosition.Name = "CarryPosition"
                            bodyPosition.Position = hrp.Position + carryOffsets[obj]
                            partCount = partCount + 1
                        end
                    end
                end
            end
            connections.carryParts = ctx.services.RunService.Heartbeat:Connect(function()
                if not state.carryParts then return end
                for i = #carriedParts, 1, -1 do
                    local part = carriedParts[i]
                    if part and part.Parent and carryOffsets[part] then
                        local bodyPosition = part:FindFirstChild("CarryPosition")
                        if bodyPosition then
                            bodyPosition.Position = hrp.Position + carryOffsets[part]
                        else
                            table.remove(carriedParts, i)
                            carryOffsets[part] = nil
                        end
                    else
                        table.remove(carriedParts, i)
                        if part then carryOffsets[part] = nil end
                    end
                end
            end)
        else
            for _, part in pairs(carriedParts) do
                if part and part.Parent then
                    local bodyPosition = part:FindFirstChild("CarryPosition")
                    if bodyPosition then bodyPosition:Destroy() end
                end
            end
            if connections.carryParts then connections.carryParts:Disconnect(); connections.carryParts = nil end
            carriedParts, carryOffsets = {}, {}
        end
    end

    local partMarkers, markedParts = {}, {}
    local function createPartMarker(part)
        local selectionBox = Instance.new("SelectionBox"); selectionBox.Adornee = part; selectionBox.Color3 = Color3.fromRGB(0,255,255); selectionBox.LineThickness = 0.2; selectionBox.Transparency = 0.5; selectionBox.Parent = part
        local billboardGui = Instance.new("BillboardGui"); billboardGui.Adornee = part; billboardGui.Size = UDim2.new(0,100,0,50); billboardGui.StudsOffset = Vector3.new(0, part.Size.Y/2 + 2, 0); billboardGui.Parent = part
        local textLabel = Instance.new("TextLabel"); textLabel.Size = UDim2.new(1,0,1,0); textLabel.BackgroundColor3 = Color3.fromRGB(0,0,0); textLabel.BackgroundTransparency = 0.3; textLabel.BorderSizePixel = 0; textLabel.Text = "📦 CLIQUE PARA GRUDAR"; textLabel.TextColor3 = Color3.fromRGB(0,255,255); textLabel.TextScaled = true; textLabel.Font = Enum.Font.SourceSansBold; textLabel.Parent = billboardGui
        local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
        local tween = TweenService:Create(selectionBox, tweenInfo, {Transparency = 0.1}); tween:Play()
        local clickDetector = Instance.new("ClickDetector"); clickDetector.MaxActivationDistance = 50; clickDetector.Parent = part
        clickDetector.MouseClick:Connect(function(plyr)
            if plyr == Players.LocalPlayer then
                local targetPosition = part.Position + Vector3.new(0, part.Size.Y/2 + 3, 0)
                hrp.CFrame = CFrame.new(targetPosition)
                if not state.anchor then toggleAnchor() end
            end
        end)
        return { selectionBox = selectionBox, billboardGui = billboardGui, clickDetector = clickDetector, tween = tween }
    end

    local function removePartMarker(part)
        if partMarkers[part] then
            local marker = partMarkers[part]
            if marker.tween then marker.tween:Cancel() end
            if marker.selectionBox then marker.selectionBox:Destroy() end
            if marker.billboardGui then marker.billboardGui:Destroy() end
            if marker.clickDetector then marker.clickDetector:Destroy() end
            partMarkers[part] = nil
        end
    end

    local function toggleMarkParts()
        state.markParts = not state.markParts
        ui.updateButtonState(markPartsButton, state.markParts, "Marcar Partes")
        if state.markParts then
            local partCount = 0
            local scanRange = 50
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and obj ~= hrp and not obj.Anchored and obj.Parent ~= character then
                    local distance = (obj.Position - hrp.Position).Magnitude
                    if distance <= scanRange and obj.Size.X > 1 and obj.Size.Y > 1 and obj.Size.Z > 1 then
                        local isPlayerPart = false
                        local parent = obj.Parent
                        while parent do
                            if parent:IsA("Model") and parent:FindFirstChild("Humanoid") then isPlayerPart = true break end
                            parent = parent.Parent
                        end
                        if not isPlayerPart then
                            markedParts[obj] = true
                            partMarkers[obj] = createPartMarker(obj)
                            partCount = partCount + 1
                        end
                    end
                end
            end
            connections.markParts = ctx.services.RunService.Heartbeat:Connect(function()
                if not state.markParts then return end
                for part, _ in pairs(markedParts) do
                    if not part or not part.Parent or part.Anchored then
                        removePartMarker(part)
                        markedParts[part] = nil
                    end
                end
                if tick() % 2 < 0.1 then
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if obj:IsA("BasePart") and obj ~= hrp and not obj.Anchored and obj.Parent ~= character and not markedParts[obj] then
                            local distance = (obj.Position - hrp.Position).Magnitude
                            if distance <= scanRange and obj.Size.X > 1 and obj.Size.Y > 1 and obj.Size.Z > 1 then
                                local isPlayerPart = false
                                local parent = obj.Parent
                                while parent do
                                    if parent:IsA("Model") and parent:FindFirstChild("Humanoid") then isPlayerPart = true break end
                                    parent = parent.Parent
                                end
                                if not isPlayerPart then
                                    markedParts[obj] = true
                                    partMarkers[obj] = createPartMarker(obj)
                                end
                            end
                        end
                    end
                end
            end)
        else
            for part, _ in pairs(markedParts) do
                removePartMarker(part)
            end
            if connections.markParts then connections.markParts:Disconnect(); connections.markParts = nil end
            markedParts = {}; partMarkers = {}
        end
    end

    local function toggleAntiAfk()
        state.antiAfk = not state.antiAfk
        ui.updateButtonState(antiAfkButton, state.antiAfk, "Anti-AFK")
        if state.antiAfk then
            connections.antiAfk = ctx.services.RunService.Heartbeat:Connect(function()
                if not state.antiAfk then return end
                local vu = game:GetService("VirtualUser")
                pcall(function() vu:CaptureController() end)
                pcall(function() vu:ClickButton2(Vector2.new(0, 0)) end)
            end)
        else
            if connections.antiAfk then connections.antiAfk:Disconnect() end
        end
    end

    local function toggleXray()
        state.xray = not state.xray
        ui.updateButtonState(xrayButton, state.xray, "Raio-X")
        if state.xray then
            originals.transparency = {}
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and obj.Parent ~= character then
                    originals.transparency[obj] = obj.Transparency
                    obj.Transparency = 0.5
                end
            end
        else
            for obj, transparency in pairs(originals.transparency or {}) do
                if obj and obj.Parent then obj.Transparency = transparency end
            end
            originals.transparency = {}
        end
    end

    invisibleButton.MouseButton1Click:Connect(toggleInvisible)
    lowGravityButton.MouseButton1Click:Connect(toggleLowGravity)
    autoHealButton.MouseButton1Click:Connect(toggleAutoHeal)
    antiFallButton.MouseButton1Click:Connect(toggleAntiFall)
    noFallDamageButton.MouseButton1Click:Connect(toggleNoFallDamage)
    anchorButton.MouseButton1Click:Connect(toggleAnchor)
    carryPartsButton.MouseButton1Click:Connect(toggleCarryParts)
    markPartsButton.MouseButton1Click:Connect(toggleMarkParts)
    antiAfkButton.MouseButton1Click:Connect(toggleAntiAfk)
    fullBrightButton.MouseButton1Click:Connect(toggleFullBright)
    xrayButton.MouseButton1Click:Connect(toggleXray)

    ctx.yOffset = y

    local function reset()
        if state.invisible then toggleInvisible() end
        if state.lowGravity then toggleLowGravity() end
        if state.autoHeal then toggleAutoHeal() end
        if state.antiFall then toggleAntiFall() end
        if state.noFallDamage then toggleNoFallDamage() end
        if state.anchor then toggleAnchor() end
        if state.carryParts then toggleCarryParts() end
        if state.markParts then toggleMarkParts() end
        if state.antiAfk then toggleAntiAfk() end
        if state.fullBright then toggleFullBright() end
        if state.xray then toggleXray() end
    end

    local function onCharacterAdded()
        -- reaplicar invisibilidade ou outras flags se desejado
        if state.invisible then applyInvisibility(true) end
    end

    return { reset = reset, onCharacterAdded = onCharacterAdded }
end

return M
