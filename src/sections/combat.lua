-- Seção Combate
local M = {}

function M.mount(ctx)
    local ui, content = ctx.ui, ctx.gui.contentFrame
    local y = ctx.yOffset

    ui.createLabel("Combate", UDim2.new(0, 10, 0, y), content)
    y = y + 35

    local godButton = ui.createButton("Modo Deus: OFF", UDim2.new(0, 20, 0, y), nil, content)
    y = y + 45
    local autoFireButton = ui.createButton("Auto-Fire: OFF", UDim2.new(0, 20, 0, y), nil, content)
    y = y + 45
    local noRecoilButton = ui.createButton("Sem Recuo: OFF", UDim2.new(0, 20, 0, y), nil, content)
    y = y + 55

    local state = {
        god = false,
        autoFire = false,
        noRecoil = false,
    }

    local function update(btn, on, label)
        ui.updateButtonState(btn, on, label)
    end

    local humanoid = ctx.humanoid
    local character = ctx.character
    local connections = ctx.connections

    local originals = ctx.originals

    local function toggleGod()
        state.god = not state.god
        update(godButton, state.god, "Modo Deus")
        if state.god then
            originals.maxHealth = humanoid.MaxHealth
            originals.health = humanoid.Health
            humanoid.MaxHealth = math.huge
            humanoid.Health = math.huge
            connections.god = humanoid.HealthChanged:Connect(function()
                if state.god then humanoid.Health = humanoid.MaxHealth end
            end)
        else
            if connections.god then connections.god:Disconnect() end
            humanoid.MaxHealth = originals.maxHealth or 100
            humanoid.Health = originals.health or 100
        end
    end

    local function toggleAutoFire()
        state.autoFire = not state.autoFire
        update(autoFireButton, state.autoFire, "Auto-Fire")
        if state.autoFire then
            connections.autoFire = ctx.services.RunService.Heartbeat:Connect(function()
                if not state.autoFire then return end
                for _, tool in pairs(character:GetChildren()) do
                    if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
                        tool:Activate()
                    end
                end
            end)
        else
            if connections.autoFire then connections.autoFire:Disconnect() end
        end
    end

    local function toggleNoRecoil()
        state.noRecoil = not state.noRecoil
        update(noRecoilButton, state.noRecoil, "Sem Recuo")
        if state.noRecoil then
            connections.noRecoil = ctx.services.RunService.Heartbeat:Connect(function()
                if not state.noRecoil then return end
                local cam = workspace.CurrentCamera
                if cam then
                    cam.CFrame = CFrame.new(cam.CFrame.Position, cam.CFrame.Position + cam.CFrame.LookVector)
                end
            end)
        else
            if connections.noRecoil then connections.noRecoil:Disconnect() end
        end
    end

    godButton.MouseButton1Click:Connect(toggleGod)
    autoFireButton.MouseButton1Click:Connect(toggleAutoFire)
    noRecoilButton.MouseButton1Click:Connect(toggleNoRecoil)

    ctx.yOffset = y

    local function reset()
        if state.god then toggleGod() end
        if state.autoFire then toggleAutoFire() end
        if state.noRecoil then toggleNoRecoil() end
    end

    local function onCharacterAdded()
        -- sem-op; reconexões não necessárias para combate exceto se desejar manter estados
        if state.god and humanoid then
            humanoid.MaxHealth = math.huge
            humanoid.Health = math.huge
        end
    end

    return { reset = reset, onCharacterAdded = onCharacterAdded }
end

return M
