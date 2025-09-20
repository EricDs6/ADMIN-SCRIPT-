-- modules/speed.lua - Velocidade aumentada
local Speed = {
    enabled = false,
    speed = 100,
    originalWalkSpeed = nil
}

local Core = require(script.Parent.core)

function Speed.enable()
    if Speed.enabled then return end
    Speed.enabled = true

    local st = Core.state()
    local humanoid = st.humanoid

    -- Salvar velocidade original
    Speed.originalWalkSpeed = humanoid.WalkSpeed

    -- Aplicar velocidade aumentada
    humanoid.WalkSpeed = Speed.speed

    print("[Speed] Ativado - Velocidade: " .. Speed.speed)
end

function Speed.disable()
    if not Speed.enabled then return end
    Speed.enabled = false

    local st = Core.state()
    local humanoid = st.humanoid

    -- Restaurar velocidade original
    if Speed.originalWalkSpeed then
        humanoid.WalkSpeed = Speed.originalWalkSpeed
    end

    print("[Speed] Desativado")
end

function Speed.setSpeed(speed)
    Speed.speed = math.clamp(speed, 50, 500)
    if Speed.enabled then
        local st = Core.state()
        st.humanoid.WalkSpeed = Speed.speed
    end
    print("[Speed] Velocidade definida para: " .. Speed.speed)
end

return Speed