-- modules/lowgravity.lua - Gravidade baixa
local LowGravity = { enabled = false }

function LowGravity.setup(Core)
    LowGravity.Core = Core
    LowGravity.original_gravity = workspace.Gravity
end

function LowGravity.toggle()
    LowGravity.enabled = not LowGravity.enabled
    LowGravity.Core.registerForRespawn("lowgravity", LowGravity.enabled)
    
    if LowGravity.enabled then
        if not LowGravity.original_gravity then
            LowGravity.original_gravity = workspace.Gravity
        end
        workspace.Gravity = 50 -- Gravidade baixa (padrão é ~196)
    else
        workspace.Gravity = LowGravity.original_gravity or 196.2
    end
    
    return LowGravity.enabled
end

function LowGravity.disable()
    if LowGravity.enabled then
        LowGravity.enabled = false
        workspace.Gravity = LowGravity.original_gravity or 196.2
    end
end

return LowGravity