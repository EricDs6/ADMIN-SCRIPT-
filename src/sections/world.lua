-- Seção Mundo
local M = {}

function M.mount(ctx)
    local ui, content = ctx.ui, ctx.gui.contentFrame
    local y = ctx.yOffset
    ui.createLabel("Mundo", UDim2.new(0, 10, 0, y), content)
    y = y + 35

    local removeFogButton = ui.createButton("Remover Névoa", UDim2.new(0, 20, 0, y), nil, content)
    y = y + 45
    local forceDayButton = ui.createButton("Forçar Dia", UDim2.new(0, 20, 0, y), nil, content)
    y = y + 45
    local forceNightButton = ui.createButton("Forçar Noite", UDim2.new(0, 20, 0, y), nil, content)
    y = y + 45
    local removeRoofButton = ui.createButton("Remover Teto", UDim2.new(0, 20, 0, y), nil, content)
    y = y + 45
    local removeWallsButton = ui.createButton("Remover Paredes", UDim2.new(0, 20, 0, y), nil, content)
    y = y + 55

    local Lighting = ctx.services.Lighting

    local function deleteFog()
        Lighting.FogEnd = math.huge
        Lighting.FogStart = math.huge
        local atmos = Lighting:FindFirstChildOfClass("Atmosphere")
        if atmos then atmos:Destroy() end
    end

    local function forceDay()
        pcall(function()
            Lighting.ClockTime = 12
            Lighting.Brightness = 2
        end)
    end

    local function forceNight()
        pcall(function()
            Lighting.ClockTime = 0
            Lighting.Brightness = 1
        end)
    end

    local function removeRoof()
        for _, p in ipairs(workspace:GetDescendants()) do
            if p:IsA("BasePart") and (p.Name:lower():find("roof") or p.Name:lower():find("teto")) then
                p.Transparency = 1
                p.CanCollide = false
            end
        end
    end

    local function removeWalls()
        for _, p in ipairs(workspace:GetDescendants()) do
            if p:IsA("BasePart") and (p.Name:lower():find("wall") or p.Name:lower():find("parede")) then
                p.Transparency = 0.6
                p.CanCollide = false
            end
        end
    end

    removeFogButton.MouseButton1Click:Connect(deleteFog)
    forceDayButton.MouseButton1Click:Connect(forceDay)
    forceNightButton.MouseButton1Click:Connect(forceNight)
    removeRoofButton.MouseButton1Click:Connect(removeRoof)
    removeWallsButton.MouseButton1Click:Connect(removeWalls)

    ctx.yOffset = y

    local function reset() end

    return { reset = reset }
end

return M
