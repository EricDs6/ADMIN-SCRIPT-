-- modules/nofalldamage.lua
local NoFallDamage = { enabled = false }

function NoFallDamage.setup(Core)
    NoFallDamage.Core = Core
    Core.onCharacterAdded(function()
        if NoFallDamage.enabled then
            NoFallDamage.setupFallProtection()
        end
    end)
end

function NoFallDamage.setupFallProtection()
    local st = NoFallDamage.Core.state()
    local fallData = {
        inFreefall = false,
        startHealth = 0,
        startY = 0
    }

    -- Monitorar mudanças de estado do humanoid
    NoFallDamage.Core.connect("nofall_state", st.humanoid.StateChanged:Connect(function(oldState, newState)
        if not NoFallDamage.enabled then return end
        
        if newState == Enum.HumanoidStateType.Freefall then
            fallData.inFreefall = true
            fallData.startHealth = st.humanoid.Health
            fallData.startY = st.hrp.Position.Y
        elseif fallData.inFreefall and (
            newState == Enum.HumanoidStateType.Landed or 
            newState == Enum.HumanoidStateType.Running or 
            newState == Enum.HumanoidStateType.RunningNoPhysics
        ) then
            fallData.inFreefall = false
            local fallDistance = fallData.startY - st.hrp.Position.Y
            
            -- Se caiu de uma altura significativa, proteger contra dano
            if fallDistance > 10 then
                task.wait(0.1) -- Pequeno delay para detectar o dano
                if NoFallDamage.enabled and st.humanoid.Health < fallData.startHealth then
                    st.humanoid.Health = fallData.startHealth
                end
            end
        end
    end))

    -- Monitorar mudanças na vida durante quedas
    NoFallDamage.Core.connect("nofall_health", st.humanoid.HealthChanged:Connect(function()
        if NoFallDamage.enabled and fallData.inFreefall and fallData.startHealth > 0 then
            if st.humanoid.Health < fallData.startHealth then
                st.humanoid.Health = fallData.startHealth
            end
        end
    end))
end

function NoFallDamage.toggle()
    NoFallDamage.enabled = not NoFallDamage.enabled
    
    if NoFallDamage.enabled then
        NoFallDamage.setupFallProtection()
    else
        NoFallDamage.Core.disconnect("nofall_state")
        NoFallDamage.Core.disconnect("nofall_health")
    end
    
    return NoFallDamage.enabled
end

function NoFallDamage.disable()
    if NoFallDamage.enabled then
        NoFallDamage.enabled = false
        NoFallDamage.Core.disconnect("nofall_state")
        NoFallDamage.Core.disconnect("nofall_health")
    end
end

return NoFallDamage