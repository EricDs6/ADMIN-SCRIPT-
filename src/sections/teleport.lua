-- Seção Teleporte
local M = {}

function M.mount(ctx)
    local ui, content = ctx.ui, ctx.gui.contentFrame
    local y = ctx.yOffset
    local Players = ctx.services.Players
    local RunService = ctx.services.RunService

    ui.createLabel("Teleporte", UDim2.new(0, 10, 0, y), content)
    y = y + 35

    local clickTpButton = ui.createButton("TP ao Clicar: OFF", UDim2.new(0, 20, 0, y), nil, content)
    y = y + 45
    local tpRandomButton = ui.createButton("TP Jogador Aleatório", UDim2.new(0, 20, 0, y), nil, content)
    y = y + 45
    local tpSpawnButton = ui.createButton("TP para Spawn", UDim2.new(0, 20, 0, y), nil, content)
    y = y + 45
    local followPlayerButton = ui.createButton("Seguir Jogador: OFF", UDim2.new(0, 20, 0, y), nil, content)
    y = y + 55

    local state = {
        clickTp = false,
        follow = false,
    }

    local function update(btn, on, label)
        ui.updateButtonState(btn, on, label)
    end

    local player = ctx.player
    local mouse = player:GetMouse()
    local character = ctx.character
    local humanoidRootPart = ctx.humanoidRootPart
    local connections = ctx.connections

    local function toggleClickTp()
        state.clickTp = not state.clickTp
        update(clickTpButton, state.clickTp, "TP ao Clicar")
        if state.clickTp then
            connections.clickTp = mouse.Button1Down:Connect(function()
                if not state.clickTp then return end
                local hit = mouse.Hit
                if hit and typeof(hit) == "CFrame" then
                    local pos = hit.Position
                    if typeof(pos) == "Vector3" and pos.Y > -1e5 and pos.Y < 1e5 then
                        humanoidRootPart.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
                    end
                end
            end)
        else
            if connections.clickTp then connections.clickTp:Disconnect() end
        end
    end

    local function tpRandomPlayer()
        local list = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                table.insert(list, p)
            end
        end
        if #list == 0 then
            warn("Nenhum jogador válido para TP Random.")
            return
        end
        local target = list[math.random(1, #list)]
        local hrp = target.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            humanoidRootPart.CFrame = hrp.CFrame * CFrame.new(0, 5, 0)
        end
    end

    local function tpToSpawn()
        for _, obj in ipairs(workspace:GetChildren()) do
            if obj:IsA("SpawnLocation") or obj:IsA("SpawnPoint") then
                humanoidRootPart.CFrame = obj.CFrame * CFrame.new(0, 5, 0)
                return
            end
        end
        humanoidRootPart.CFrame = CFrame.new(0, 50, 0)
    end

    local followTarget = nil
    local function isValidTarget(p)
        return p and p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart")
    end
    local function findClosestPlayer()
        local best, bestDist = nil, math.huge
        for _, p in ipairs(Players:GetPlayers()) do
            if isValidTarget(p) then
                local d = (humanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                if d < bestDist then best, bestDist = p, d end
            end
        end
        return best
    end
    local function toggleFollowPlayer()
        state.follow = not state.follow
        update(followPlayerButton, state.follow, "Seguir Jogador")
        if state.follow then
            followTarget = findClosestPlayer()
            if connections.follow then connections.follow:Disconnect() end
            local HOVER_HEIGHT = 6
            local LERP_ALPHA = 0.35
            connections.follow = RunService.Heartbeat:Connect(function()
                if not state.follow then return end
                if not isValidTarget(followTarget) then
                    followTarget = findClosestPlayer(); if not followTarget then return end
                end
                local targetChar = followTarget.Character
                local targetHead = targetChar and targetChar:FindFirstChild("Head")
                local refPart = targetHead or targetChar:FindFirstChild("HumanoidRootPart")
                if not refPart then return end
                local headPos = refPart.Position
                local desiredPos = headPos + Vector3.new(0, HOVER_HEIGHT, 0)
                local lookAt = CFrame.new(desiredPos, headPos)
                humanoidRootPart.CFrame = humanoidRootPart.CFrame:Lerp(lookAt, LERP_ALPHA)
            end)
        else
            if connections.follow then connections.follow:Disconnect() end
            followTarget = nil
        end
    end

    clickTpButton.MouseButton1Click:Connect(toggleClickTp)
    tpRandomButton.MouseButton1Click:Connect(tpRandomPlayer)
    tpSpawnButton.MouseButton1Click:Connect(tpToSpawn)
    followPlayerButton.MouseButton1Click:Connect(toggleFollowPlayer)

    ctx.yOffset = y

    local function reset()
        if state.clickTp then toggleClickTp() end
        if state.follow then toggleFollowPlayer() end
    end

    local function onCharacterAdded()
        -- nada específico
    end

    return { reset = reset, onCharacterAdded = onCharacterAdded }
end

return M
