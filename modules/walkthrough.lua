-- modules/walkthrough.lua - Passar através de paredes mantendo gravidade
local Walkthrough = { enabled = false }

function Walkthrough.setup(Core)
    Walkthrough.Core = Core
    Walkthrough.originalSizes = {}
    
    Core.onCharacterAdded(function()
        if Walkthrough.enabled then
            task.wait(0.5)
            Walkthrough.setupWalkthrough()
        end
    end)
end

function Walkthrough.setupWalkthrough()
    local st = Walkthrough.Core.state()
    local services = Walkthrough.Core.services()
    
    if not st.character then return end

    -- Reduzir hitbox do personagem para passar por espaços pequenos
    for _, part in pairs(st.character:GetChildren()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            if not Walkthrough.originalSizes[part] then
                Walkthrough.originalSizes[part] = part.Size
            end
            -- Reduzir tamanho das partes para passar por buracos
            part.Size = part.Size * 0.1
        end
    end

    -- Sistema de detecção de parede e passagem automática
    Walkthrough.Core.connect("walkthrough_detection", services.RunService.Heartbeat:Connect(function()
        if not Walkthrough.enabled or not st.hrp or not st.humanoid then return end
        
        local moveVector = st.humanoid.MoveDirection
        if moveVector.Magnitude > 0 then
            -- Verificar se há parede na frente
            local rayDirection = moveVector * 5
            local raycastParams = RaycastParams.new()
            raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
            raycastParams.FilterDescendantsInstances = {st.character}
            
            local raycastResult = workspace:Raycast(st.hrp.Position, rayDirection, raycastParams)
            
            if raycastResult then
                local hitPart = raycastResult.Instance
                
                -- Se é uma parede/obstáculo, temporariamente desabilitar colisão
                if hitPart and hitPart.CanCollide then
                    task.spawn(function()
                        local originalCanCollide = hitPart.CanCollide
                        hitPart.CanCollide = false
                        
                        -- Restaurar colisão após passar
                        task.wait(0.5)
                        if hitPart and hitPart.Parent then
                            hitPart.CanCollide = originalCanCollide
                        end
                    end)
                end
            end
        end
    end))
    
    -- Sistema alternativo: reduzir colisão das partes do corpo temporariamente
    Walkthrough.Core.connect("walkthrough_body", services.RunService.Heartbeat:Connect(function()
        if not Walkthrough.enabled or not st.character then return end
        
        local velocity = st.humanoid.MoveDirection.Magnitude
        
        if velocity > 0 then
            -- Temporariamente reduzir colisão das partes do corpo
            for _, part in pairs(st.character:GetChildren()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.CanCollide = false
                end
            end
        else
            -- Restaurar colisão quando parado
            task.wait(0.2)
            for _, part in pairs(st.character:GetChildren()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.CanCollide = true
                end
            end
        end
    end))
end

function Walkthrough.toggle()
    Walkthrough.enabled = not Walkthrough.enabled
    Walkthrough.Core.registerForRespawn("walkthrough", Walkthrough.enabled)
    
    if Walkthrough.enabled then
        Walkthrough.setupWalkthrough()
    else
        Walkthrough.cleanup()
    end
    
    return Walkthrough.enabled
end

function Walkthrough.cleanup()
    Walkthrough.Core.disconnect("walkthrough_detection")
    Walkthrough.Core.disconnect("walkthrough_body")
    
    -- Restaurar tamanhos originais
    local st = Walkthrough.Core.state()
    if st.character then
        for part, originalSize in pairs(Walkthrough.originalSizes) do
            if part and part.Parent then
                part.Size = originalSize
                if part.Name ~= "HumanoidRootPart" then
                    part.CanCollide = true
                end
            end
        end
    end
    Walkthrough.originalSizes = {}
end

function Walkthrough.disable()
    if Walkthrough.enabled then
        Walkthrough.enabled = false
        Walkthrough.cleanup()
    end
end

return Walkthrough