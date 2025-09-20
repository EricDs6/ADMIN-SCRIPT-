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
    local services = NoFallDamage.Core.services()
    
    -- Criar BodyVelocity para amortecer quedas
    if not NoFallDamage.cushion then
        NoFallDamage.cushion = Instance.new("BodyVelocity")
        NoFallDamage.cushion.MaxForce = Vector3.new(0, math.huge, 0)
        NoFallDamage.cushion.Velocity = Vector3.new(0, 0, 0)
    end

    local fallData = {
        inFreefall = false,
        fallTime = 0,
        lastY = 0
    }

    -- Loop para detectar quedas perigosas e amortecer
    NoFallDamage.Core.connect("nofall_monitor", services.RunService.Heartbeat:Connect(function()
        if not NoFallDamage.enabled or not st.hrp then return end
        
        local currentY = st.hrp.Position.Y
        local velocity = st.hrp.Velocity
        
        -- Detectar se está caindo rapidamente
        if velocity.Y < -50 then -- Velocidade de queda perigosa
            if not fallData.inFreefall then
                fallData.inFreefall = true
                fallData.fallTime = 0
                fallData.lastY = currentY
            else
                fallData.fallTime = fallData.fallTime + services.RunService.Heartbeat:Wait()
            end
            
            -- Se está caindo há tempo suficiente e rápido o suficiente
            if fallData.fallTime > 0.5 and velocity.Y < -40 then
                -- Ativar amortecimento gradual
                NoFallDamage.cushion.Parent = st.hrp
                local cushionForce = math.min(-velocity.Y * 0.8, 50)
                NoFallDamage.cushion.Velocity = Vector3.new(0, cushionForce, 0)
            end
        else
            -- Não está mais em queda perigosa
            if fallData.inFreefall then
                fallData.inFreefall = false
                fallData.fallTime = 0
                -- Remover amortecimento
                if NoFallDamage.cushion.Parent then
                    NoFallDamage.cushion.Parent = nil
                end
            end
        end
    end))

    -- Detectar quando aterrissa para remover amortecimento
    NoFallDamage.Core.connect("nofall_state", st.humanoid.StateChanged:Connect(function(oldState, newState)
        if not NoFallDamage.enabled then return end
        
        if newState == Enum.HumanoidStateType.Landed or 
           newState == Enum.HumanoidStateType.Running or 
           newState == Enum.HumanoidStateType.RunningNoPhysics then
            -- Aterrissou, remover amortecimento
            if NoFallDamage.cushion and NoFallDamage.cushion.Parent then
                NoFallDamage.cushion.Parent = nil
            end
            fallData.inFreefall = false
            fallData.fallTime = 0
        end
    end))
end

function NoFallDamage.toggle()
    NoFallDamage.enabled = not NoFallDamage.enabled
    
    if NoFallDamage.enabled then
        NoFallDamage.setupFallProtection()
    else
        NoFallDamage.Core.disconnect("nofall_monitor")
        NoFallDamage.Core.disconnect("nofall_state")
        -- Remover amortecimento se estiver ativo
        if NoFallDamage.cushion and NoFallDamage.cushion.Parent then
            NoFallDamage.cushion.Parent = nil
        end
    end
    
    return NoFallDamage.enabled
end

function NoFallDamage.disable()
    if NoFallDamage.enabled then
        NoFallDamage.enabled = false
        NoFallDamage.Core.disconnect("nofall_monitor")
        NoFallDamage.Core.disconnect("nofall_state")
        -- Limpar amortecimento
        if NoFallDamage.cushion then
            if NoFallDamage.cushion.Parent then
                NoFallDamage.cushion.Parent = nil
            end
            NoFallDamage.cushion:Destroy()
            NoFallDamage.cushion = nil
        end
    end
end

return NoFallDamage