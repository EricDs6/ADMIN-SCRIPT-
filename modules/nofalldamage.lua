-- modules/nofalldamage.lua - Proteção contra dano de queda
local NoFallDamage = { enabled = false }

function NoFallDamage.setup(Core)
    NoFallDamage.Core = Core
    Core.onCharacterAdded(function()
        if NoFallDamage.enabled then
            task.wait(0.5) -- Aguarda character carregar
            NoFallDamage.setupFallProtection()
        end
    end)
end

function NoFallDamage.setupFallProtection()
    local st = NoFallDamage.Core.state()
    local services = NoFallDamage.Core.services()
    
    if not st.hrp then return end

    -- Monitorar velocidade de queda e aplicar amortecimento
    NoFallDamage.Core.connect("nofall_monitor", services.RunService.Heartbeat:Connect(function()
        if not NoFallDamage.enabled or not st.hrp then return end
        
        local velocity = st.hrp.Velocity
        
        -- Se está caindo muito rápido (velocidade Y negativa alta)
        if velocity.Y < -55 then
            -- Criar/atualizar BodyVelocity para reduzir velocidade de queda
            local bodyVel = st.hrp:FindFirstChild("NoFallBodyVelocity")
            if not bodyVel then
                bodyVel = Instance.new("BodyVelocity")
                bodyVel.Name = "NoFallBodyVelocity"
                bodyVel.MaxForce = Vector3.new(0, math.huge, 0)
                bodyVel.Parent = st.hrp
            end
            
            -- Reduzir velocidade de queda para um valor seguro
            bodyVel.Velocity = Vector3.new(0, math.max(velocity.Y * 0.3, -25), 0)
            
        else
            -- Remover BodyVelocity quando não está em queda perigosa
            local bodyVel = st.hrp:FindFirstChild("NoFallBodyVelocity")
            if bodyVel then
                bodyVel:Destroy()
            end
        end
    end))

    -- Detectar aterrissagem para limpar BodyVelocity
    NoFallDamage.Core.connect("nofall_landed", st.humanoid.StateChanged:Connect(function(oldState, newState)
        if not NoFallDamage.enabled or not st.hrp then return end
        
        if newState == Enum.HumanoidStateType.Landed or 
           newState == Enum.HumanoidStateType.Running or 
           newState == Enum.HumanoidStateType.RunningNoPhysics then
            -- Limpar BodyVelocity ao aterrissar
            local bodyVel = st.hrp:FindFirstChild("NoFallBodyVelocity")
            if bodyVel then
                bodyVel:Destroy()
            end
        end
    end))
end

function NoFallDamage.toggle()
    NoFallDamage.enabled = not NoFallDamage.enabled
    NoFallDamage.Core.registerForRespawn("nofalldamage", NoFallDamage.enabled)
    
    if NoFallDamage.enabled then
        NoFallDamage.setupFallProtection()
    else
        NoFallDamage.cleanup()
    end
    
    return NoFallDamage.enabled
end

function NoFallDamage.cleanup()
    NoFallDamage.Core.disconnect("nofall_monitor")
    NoFallDamage.Core.disconnect("nofall_landed")
    
    -- Remover BodyVelocity se existir
    local st = NoFallDamage.Core.state()
    if st.hrp then
        local bodyVel = st.hrp:FindFirstChild("NoFallBodyVelocity")
        if bodyVel then
            bodyVel:Destroy()
        end
    end
end

function NoFallDamage.disable()
    if NoFallDamage.enabled then
        NoFallDamage.enabled = false
        NoFallDamage.cleanup()
    end
end

return NoFallDamage