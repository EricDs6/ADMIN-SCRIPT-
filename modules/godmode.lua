-- modules/godmode.lua
local GodMode = { enabled = false }

function GodMode.setup(Core)
    GodMode.Core = Core
    Core.onCharacterAdded(function()
        if GodMode.enabled then
            GodMode.setupProtection()
        end
    end)
end

function GodMode.setupProtection()
    local st = GodMode.Core.state()
    
    -- Método 1: Teletransportar rapidamente para evitar dano
    local lastPosition = st.hrp.CFrame
    local lastHealth = st.humanoid.Health
    
    GodMode.Core.connect("godmode_monitor", st.humanoid.HealthChanged:Connect(function()
        if not GodMode.enabled then return end
        
        local currentHealth = st.humanoid.Health
        -- Se a vida diminuiu significativamente, teletransportar para posição anterior
        if currentHealth < lastHealth - 5 then
            st.hrp.CFrame = lastPosition
            -- Resetar estado do humanoid para cancelar dano
            st.humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end
        lastHealth = currentHealth
    end))
    
    -- Método 2: Manter posição segura atualizada
    local services = GodMode.Core.services()
    GodMode.Core.connect("godmode_position", services.RunService.Heartbeat:Connect(function()
        if not GodMode.enabled then return end
        
        -- Só atualizar posição se estiver em estado seguro
        if st.humanoid.Health > lastHealth - 1 then
            lastPosition = st.hrp.CFrame
        end
    end))
    
    -- Método 3: Proteção contra dano específicos
    GodMode.Core.connect("godmode_state", st.humanoid.StateChanged:Connect(function(oldState, newState)
        if not GodMode.enabled then return end
        
        -- Prevenir estados que causam dano
        if newState == Enum.HumanoidStateType.Dead then
            st.humanoid:ChangeState(Enum.HumanoidStateType.Running)
            st.hrp.CFrame = lastPosition
        end
    end))
    
    -- Método 4: Remover partes que causam dano do personagem
    for _, part in pairs(st.character:GetChildren()) do
        if part:IsA("BasePart") then
            -- Fazer partes do corpo "fantasmas" para projéteis
            local originalCanCollide = part.CanCollide
            part.CanCollide = false
            
            -- Restaurar colisão apenas para o chão
            if part.Name == "HumanoidRootPart" then
                part.CanCollide = true
            end
        end
    end
end

function GodMode.toggle()
    GodMode.enabled = not GodMode.enabled
    local st = GodMode.Core.state()
    
    if GodMode.enabled then
        GodMode.setupProtection()
    else
        GodMode.Core.disconnect("godmode_monitor")
        GodMode.Core.disconnect("godmode_position")
        GodMode.Core.disconnect("godmode_state")
        
        -- Restaurar colisões normais
        for _, part in pairs(st.character:GetChildren()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.CanCollide = false -- Valor padrão do Roblox para partes do corpo
            end
        end
    end
    
    return GodMode.enabled
end

function GodMode.disable()
    if GodMode.enabled then
        GodMode.enabled = false
        GodMode.Core.disconnect("godmode_monitor")
        GodMode.Core.disconnect("godmode_position")
        GodMode.Core.disconnect("godmode_state")
        
        local st = GodMode.Core.state()
        -- Restaurar colisões normais
        for _, part in pairs(st.character:GetChildren()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.CanCollide = false
            end
        end
    end
end

return GodMode