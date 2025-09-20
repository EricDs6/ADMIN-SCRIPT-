-- modules/autofarm.lua - Coletar itens próximos automaticamente
local AutoFarm = { enabled = false }

function AutoFarm.setup(Core)
    AutoFarm.Core = Core
    AutoFarm.collectRadius = 50 -- Raio de coleta em studs
    
    Core.onCharacterAdded(function()
        if AutoFarm.enabled then
            task.wait(0.5)
            AutoFarm.setupAutoFarm()
        end
    end)
end

function AutoFarm.isCollectable(obj)
    -- Verifica se o objeto pode ser coletado
    local collectableNames = {
        "Coin", "Money", "Cash", "Diamond", "Gem", "Orb", "Tool", "Sword", "Gun",
        "Key", "Keycard", "Item", "Pickup", "Collectible", "Power", "Boost",
        "Apple", "Food", "Health", "Shield", "Armor", "Weapon"
    }
    
    -- Verificar nome
    for _, name in pairs(collectableNames) do
        if string.find(obj.Name:lower(), name:lower()) then
            return true
        end
    end
    
    -- Verificar se tem script de coleta ou ClickDetector
    if obj:FindFirstChild("ClickDetector") or 
       obj:FindFirstChild("ProximityPrompt") or
       obj:FindFirstChild("TouchInterest") then
        return true
    end
    
    -- Verificar se é um Tool
    if obj:IsA("Tool") then
        return true
    end
    
    return false
end

function AutoFarm.collectItem(item)
    local st = AutoFarm.Core.state()
    if not st.hrp then return end
    
    -- Método 1: ClickDetector
    local clickDetector = item:FindFirstChild("ClickDetector")
    if clickDetector then
        fireclickdetector(clickDetector)
        return true
    end
    
    -- Método 2: ProximityPrompt
    local proximityPrompt = item:FindFirstChild("ProximityPrompt")
    if proximityPrompt then
        fireproximityprompt(proximityPrompt)
        return true
    end
    
    -- Método 3: Tocar o item
    if item:FindFirstChild("TouchInterest") then
        local oldPos = st.hrp.CFrame
        st.hrp.CFrame = item.CFrame
        task.wait(0.1)
        st.hrp.CFrame = oldPos
        return true
    end
    
    -- Método 4: Se é uma Tool, tentar equipar
    if item:IsA("Tool") then
        pcall(function()
            st.humanoid:EquipTool(item)
        end)
        return true
    end
    
    return false
end

function AutoFarm.setupAutoFarm()
    local st = AutoFarm.Core.state()
    local services = AutoFarm.Core.services()
    
    if not st.hrp then return end

    -- Loop de coleta automática
    AutoFarm.Core.connect("autofarm_loop", services.RunService.Heartbeat:Connect(function()
        if not AutoFarm.enabled or not st.hrp then return end
        
        local playerPos = st.hrp.Position
        local itemsCollected = 0
        
        -- Procurar itens colecionáveis no workspace
        for _, obj in pairs(workspace:GetDescendants()) do
            if itemsCollected >= 5 then break end -- Limite por frame para performance
            
            if obj:IsA("BasePart") and obj.Parent and AutoFarm.isCollectable(obj) then
                local distance = (obj.Position - playerPos).Magnitude
                
                if distance <= AutoFarm.collectRadius then
                    if AutoFarm.collectItem(obj) then
                        itemsCollected = itemsCollected + 1
                        
                        -- Efeito visual opcional
                        task.spawn(function()
                            local effect = Instance.new("SelectionBox")
                            effect.Adornee = obj
                            effect.Color3 = Color3.fromRGB(0, 255, 0)
                            effect.Parent = obj
                            task.wait(0.5)
                            if effect.Parent then
                                effect:Destroy()
                            end
                        end)
                    end
                end
            end
        end
    end))
end

function AutoFarm.toggle()
    AutoFarm.enabled = not AutoFarm.enabled
    AutoFarm.Core.registerForRespawn("autofarm", AutoFarm.enabled)
    
    if AutoFarm.enabled then
        AutoFarm.setupAutoFarm()
    else
        AutoFarm.cleanup()
    end
    
    return AutoFarm.enabled
end

function AutoFarm.cleanup()
    AutoFarm.Core.disconnect("autofarm_loop")
end

function AutoFarm.disable()
    if AutoFarm.enabled then
        AutoFarm.enabled = false
        AutoFarm.cleanup()
    end
end

return AutoFarm