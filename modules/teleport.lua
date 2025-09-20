-- modules/teleport.lua
local Teleport = { enabled = false }

function Teleport.setup(Core)
    Teleport.Core = Core
end

function Teleport.toggle()
    Teleport.enabled = not Teleport.enabled
    local st = Teleport.Core.state()

    if Teleport.enabled then
        Teleport.Core.connect("teleport_click", st.mouse.Button1Down:Connect(function()
            if not Teleport.enabled then return end
            local hit = st.mouse.Hit
            if hit then
                st.hrp.CFrame = CFrame.new(hit.Position + Vector3.new(0, 3, 0))
            end
        end))
    else
        Teleport.Core.disconnect("teleport_click")
    end
    return Teleport.enabled
end

function Teleport.disable()
    if Teleport.enabled then
        Teleport.enabled = false
        Teleport.Core.disconnect("teleport_click")
    end
end

return Teleport
