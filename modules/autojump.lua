-- modules/autojump.lua - Pular automaticamente ao encontrar obstáculos
local AutoJump = { enabled = false }

function AutoJump.setup(Core)
    AutoJump.Core = Core
    AutoJump.jumpCooldown = 0
    
    Core.onCharacterAdded(function()
        if AutoJump.enabled then
            task.wait(0.5)
            AutoJump.setupAutoJump()
        end
    end)
end

function AutoJump.setupAutoJump()
    local st = AutoJump.Core.state()
    local services = AutoJump.Core.services()
    
    if not st.hrp or not st.humanoid then return end

    -- Sistema principal de detecção de obstáculos
    AutoJump.Core.connect("autojump_detection", services.RunService.Heartbeat:Connect(function()
        if not AutoJump.enabled or not st.hrp or not st.humanoid then return end
        
        local currentTime = tick()
        if currentTime < AutoJump.jumpCooldown then return end
        
        local moveDirection = st.humanoid.MoveDirection
        if moveDirection.Magnitude > 0.1 then
            -- Raycast para frente para detectar obstáculos
            local rayDirection = moveDirection * 4
            local raycastParams = RaycastParams.new()
            raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
            raycastParams.FilterDescendantsInstances = {st.character}
            
            -- Ray horizontal para obstáculos na altura do peito
            local frontRay = workspace:Raycast(
                st.hrp.Position + Vector3.new(0, 1, 0), 
                rayDirection, 
                raycastParams
            )
            
            -- Ray diagonal para baixo para detectar degraus
            local stepRay = workspace:Raycast(
                st.hrp.Position + moveDirection * 2 + Vector3.new(0, 2, 0),
                Vector3.new(0, -3, 0),
                raycastParams
            )
            
            local shouldJump = false
            
            -- Verificar obstáculo na frente
            if frontRay then
                local obstacle = frontRay.Instance
                if obstacle and obstacle.CanCollide then
                    local obstacleHeight = obstacle.Size.Y
                    -- Pular se o obstáculo for de altura razoável (não muito alto)
                    if obstacleHeight <= 15 then
                        shouldJump = true
                    end
                end
            end
            
            -- Verificar degrau/elevação
            if stepRay then
                local stepHeight = st.hrp.Position.Y - stepRay.Position.Y
                if stepHeight > 3 and stepHeight < 15 then
                    shouldJump = true
                end
            end
            
            -- Verificar se está "travado" (não se movendo apesar de tentar)
            local velocity = st.hrp.Velocity
            if moveDirection.Magnitude > 0.5 and velocity.Magnitude < 2 then
                shouldJump = true
            end
            
            -- Executar pulo se necessário
            if shouldJump and st.humanoid:GetState() ~= Enum.HumanoidStateType.Freefall then
                st.humanoid.Jump = true
                AutoJump.jumpCooldown = currentTime + 0.8 -- Cooldown para evitar pulos spam
                
                -- Efeito visual opcional
                task.spawn(function()
                    local effect = Instance.new("Explosion")
                    effect.Position = st.hrp.Position + Vector3.new(0, -2, 0)
                    effect.BlastRadius = 0
                    effect.BlastPressure = 0
                    effect.Visible = false
                    effect.Parent = workspace
                end)
            end
        end
    end))
    
    -- Sistema de detecção de queda para pulo de segurança
    AutoJump.Core.connect("autojump_safety", st.humanoid.StateChanged:Connect(function(oldState, newState)
        if not AutoJump.enabled or not st.hrp then return end
        
        -- Se começou a cair e há chão próximo, tentar pular para safety
        if newState == Enum.HumanoidStateType.Freefall then
            local raycastParams = RaycastParams.new()
            raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
            raycastParams.FilterDescendantsInstances = {st.character}
            
            local groundRay = workspace:Raycast(
                st.hrp.Position,
                Vector3.new(0, -10, 0),
                raycastParams
            )
            
            -- Se há chão próximo mas está caindo, pode estar em um buraco pequeno
            if groundRay and groundRay.Distance < 8 then
                task.wait(0.1)
                if st.humanoid:GetState() == Enum.HumanoidStateType.Freefall then
                    st.humanoid.Jump = true
                end
            end
        end
    end))
end

function AutoJump.toggle()
    AutoJump.enabled = not AutoJump.enabled
    AutoJump.Core.registerForRespawn("autojump", AutoJump.enabled)
    
    if AutoJump.enabled then
        AutoJump.setupAutoJump()
    else
        AutoJump.cleanup()
    end
    
    return AutoJump.enabled
end

function AutoJump.cleanup()
    AutoJump.Core.disconnect("autojump_detection")
    AutoJump.Core.disconnect("autojump_safety")
    AutoJump.jumpCooldown = 0
end

function AutoJump.disable()
    if AutoJump.enabled then
        AutoJump.enabled = false
        AutoJump.cleanup()
    end
end

return AutoJump