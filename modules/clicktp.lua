-- modules/clicktp.lua - Click Teleport melhorado com indicador visual
local ClickTP = { enabled = false }

function ClickTP.setup(Core)
    ClickTP.Core = Core
    ClickTP.indicator = nil
    
    Core.onCharacterAdded(function()
        if ClickTP.enabled then
            task.wait(0.5)
            ClickTP.setupClickTeleport()
        end
    end)
end

function ClickTP.createIndicator()
    -- Criar indicador visual no local do clique
    local indicator = Instance.new("Part")
    indicator.Name = "TP_Indicator"
    indicator.Size = Vector3.new(4, 0.2, 4)
    indicator.Material = Enum.Material.Neon
    indicator.BrickColor = BrickColor.new("Cyan")
    indicator.Anchored = true
    indicator.CanCollide = false
    indicator.Parent = workspace
    
    -- Efeito visual
    Instance.new("SpecialMesh", indicator).MeshType = Enum.MeshType.Cylinder
    
    -- Luz
    local light = Instance.new("PointLight", indicator)
    light.Color = Color3.fromRGB(0, 255, 255)
    light.Brightness = 2
    light.Range = 10
    
    return indicator
end

function ClickTP.animateIndicator(indicator, targetPos)
    local TweenService = game:GetService("TweenService")
    
    -- Animação de aparição
    local appearTween = TweenService:Create(
        indicator,
        TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Size = Vector3.new(4, 0.2, 4), Transparency = 0}
    )
    appearTween:Play()
    
    -- Animação de rotação
    local rotateTween = TweenService:Create(
        indicator,
        TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1),
        {Rotation = Vector3.new(0, 360, 0)}
    )
    rotateTween:Play()
    
    -- Remover após 2 segundos
    task.wait(2)
    local fadeTween = TweenService:Create(
        indicator,
        TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Transparency = 1}
    )
    fadeTween:Play()
    fadeTween.Completed:Connect(function()
        indicator:Destroy()
    end)
end

function ClickTP.setupClickTeleport()
    local st = ClickTP.Core.state()
    local services = ClickTP.Core.services()
    
    if not st.mouse or not st.hrp then return end

    ClickTP.Core.connect("clicktp_mouse", st.mouse.Button1Down:Connect(function()
        if not ClickTP.enabled or not st.hrp then return end
        
        local hit = st.mouse.Hit
        if hit then
            local targetPos = hit.Position
            
            -- Ajustar altura para evitar ficar enterrado
            local raycast = workspace:Raycast(targetPos + Vector3.new(0, 10, 0), Vector3.new(0, -20, 0))
            if raycast then
                targetPos = raycast.Position + Vector3.new(0, 5, 0) -- 5 studs acima do chão
            else
                targetPos = targetPos + Vector3.new(0, 5, 0)
            end
            
            -- Criar indicador visual
            local indicator = ClickTP.createIndicator()
            indicator.Position = targetPos
            
            -- Animar indicador em background
            task.spawn(function()
                ClickTP.animateIndicator(indicator, targetPos)
            end)
            
            -- Teleportar
            st.hrp.CFrame = CFrame.new(targetPos)
            
            -- Efeito de partículas no jogador (opcional)
            task.spawn(function()
                local effect = Instance.new("Explosion")
                effect.Position = st.hrp.Position
                effect.BlastRadius = 0
                effect.BlastPressure = 0
                effect.Visible = false
                effect.Parent = workspace
            end)
        end
    end))
end

function ClickTP.toggle()
    ClickTP.enabled = not ClickTP.enabled
    ClickTP.Core.registerForRespawn("clicktp", ClickTP.enabled)
    
    if ClickTP.enabled then
        ClickTP.setupClickTeleport()
    else
        ClickTP.cleanup()
    end
    
    return ClickTP.enabled
end

function ClickTP.cleanup()
    ClickTP.Core.disconnect("clicktp_mouse")
    
    -- Remover indicadores existentes
    for _, obj in pairs(workspace:GetChildren()) do
        if obj.Name == "TP_Indicator" then
            obj:Destroy()
        end
    end
end

function ClickTP.disable()
    if ClickTP.enabled then
        ClickTP.enabled = false
        ClickTP.cleanup()
    end
end

return ClickTP