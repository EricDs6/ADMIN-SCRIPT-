-- modules/instantrespawn.lua - Respawn instantâneo no mesmo local
local InstantRespawn = { enabled = false }

function InstantRespawn.setup(Core)
    InstantRespawn.Core = Core
    InstantRespawn.lastPosition = nil
    InstantRespawn.lastCFrame = nil
    
    Core.onCharacterAdded(function()
        if InstantRespawn.enabled then
            task.wait(0.1) -- Aguarda character carregar
            InstantRespawn.setupRespawnSystem()
        end
    end)
end

function InstantRespawn.setupRespawnSystem()
    local st = InstantRespawn.Core.state()
    local services = InstantRespawn.Core.services()
    
    if not st.hrp or not st.humanoid then return end

    -- Salvar posição continuamente
    InstantRespawn.Core.connect("respawn_save_pos", services.RunService.Heartbeat:Connect(function()
        if not InstantRespawn.enabled or not st.hrp then return end
        
        -- Salvar posição apenas se não está morto
        if st.humanoid.Health > 0 then
            InstantRespawn.lastPosition = st.hrp.Position
            InstantRespawn.lastCFrame = st.hrp.CFrame
        end
    end))

    -- Detectar morte e forçar respawn
    InstantRespawn.Core.connect("respawn_death", st.humanoid.Died:Connect(function()
        if not InstantRespawn.enabled then return end
        
        -- Aguardar um pouco e então forçar respawn
        task.wait(0.1)
        
        -- Forçar respawn instantâneo
        pcall(function()
            st.player:LoadCharacter()
        end)
    end))

    -- Se já temos uma posição salva, teleportar para ela
    if InstantRespawn.lastPosition then
        task.wait(0.5) -- Aguarda character estabilizar
        if st.hrp then
            st.hrp.CFrame = InstantRespawn.lastCFrame or CFrame.new(InstantRespawn.lastPosition)
        end
    end
end

function InstantRespawn.toggle()
    InstantRespawn.enabled = not InstantRespawn.enabled
    InstantRespawn.Core.registerForRespawn("instantrespawn", InstantRespawn.enabled)
    
    if InstantRespawn.enabled then
        InstantRespawn.setupRespawnSystem()
    else
        InstantRespawn.cleanup()
    end
    
    return InstantRespawn.enabled
end

function InstantRespawn.cleanup()
    InstantRespawn.Core.disconnect("respawn_save_pos")
    InstantRespawn.Core.disconnect("respawn_death")
end

function InstantRespawn.disable()
    if InstantRespawn.enabled then
        InstantRespawn.enabled = false
        InstantRespawn.cleanup()
    end
end

return InstantRespawn