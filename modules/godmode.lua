-- modules/godmode.lua - Modo Deus
local Godmode = {
    enabled = false,
    connection = nil,
    originalMaxHealth = nil,
    originalHealth = nil
}

local Core = require(script.Parent.core)

function Godmode.enable()
    if Godmode.enabled then return end
    Godmode.enabled = true

    local st = Core.state()
    local humanoid = st.humanoid

    -- Salvar valores originais
    Godmode.originalMaxHealth = humanoid.MaxHealth
    Godmode.originalHealth = humanoid.Health

    -- Definir vida infinita
    humanoid.MaxHealth = math.huge
    humanoid.Health = math.huge

    -- Conectar evento para manter vida infinita
    Godmode.connection = humanoid.HealthChanged:Connect(function()
        if Godmode.enabled then
            humanoid.Health = humanoid.MaxHealth
        end
    end)

    print("[Godmode] Ativado - Você é imortal!")
end

function Godmode.disable()
    if not Godmode.enabled then return end
    Godmode.enabled = false

    if Godmode.connection then
        Godmode.connection:Disconnect()
        Godmode.connection = nil
    end

    local st = Core.state()
    local humanoid = st.humanoid

    -- Restaurar valores originais
    if Godmode.originalMaxHealth then
        humanoid.MaxHealth = Godmode.originalMaxHealth
    end
    if Godmode.originalHealth then
        humanoid.Health = Godmode.originalHealth
    end

    print("[Godmode] Desativado")
end

return Godmode