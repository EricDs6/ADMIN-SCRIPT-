-- modules/speed.lua
local Speed = { enabled = false, speed = 100 }

function Speed.setup(Core)
    Speed.Core = Core
    local st = Core.state()
    Speed.original_speed = st.humanoid.WalkSpeed
end

function Speed.toggle()
    Speed.enabled = not Speed.enabled
    local st = Speed.Core.state()

    if Speed.enabled then
        st.humanoid.WalkSpeed = Speed.speed
    else
        st.humanoid.WalkSpeed = Speed.original_speed or 16
    end
    return Speed.enabled
end

function Speed.disable()
    if Speed.enabled then
        Speed.enabled = false
        local st = Speed.Core.state()
        st.humanoid.WalkSpeed = Speed.original_speed or 16
    end
end

return Speed
