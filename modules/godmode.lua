-- modules/godmode.lua
local GodMode = { enabled = false }

function GodMode.setup(Core)
    GodMode.Core = Core
    Core.onCharacterAdded(function()
        local st = Core.state()
        GodMode.original_health = st.humanoid.MaxHealth
        if GodMode.enabled then
            st.humanoid.MaxHealth = math.huge
            st.humanoid.Health = math.huge
        end
    end)
end

function GodMode.toggle()
    GodMode.enabled = not GodMode.enabled
    local st = GodMode.Core.state()

    if GodMode.enabled then
        GodMode.original_health = st.humanoid.MaxHealth
        st.humanoid.MaxHealth = math.huge
        st.humanoid.Health = math.huge
        
        -- Conectar listener para manter vida infinita
        GodMode.Core.connect("godmode_health", st.humanoid.HealthChanged:Connect(function()
            if GodMode.enabled and st.humanoid.Health < st.humanoid.MaxHealth then
                st.humanoid.Health = st.humanoid.MaxHealth
            end
        end))
    else
        GodMode.Core.disconnect("godmode_health")
        st.humanoid.MaxHealth = GodMode.original_health or 100
        st.humanoid.Health = GodMode.original_health or 100
    end
    return GodMode.enabled
end

function GodMode.disable()
    if GodMode.enabled then
        GodMode.enabled = false
        GodMode.Core.disconnect("godmode_health")
        local st = GodMode.Core.state()
        st.humanoid.MaxHealth = GodMode.original_health or 100
        st.humanoid.Health = GodMode.original_health or 100
    end
end

return GodMode