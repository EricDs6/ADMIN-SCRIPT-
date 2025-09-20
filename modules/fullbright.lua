-- modules/fullbright.lua
local FullBright = { enabled = false }

function FullBright.setup(Core)
    FullBright.Core = Core
    local Lighting = game:GetService("Lighting")
    FullBright.original_brightness = Lighting.Brightness
    FullBright.original_ambient = Lighting.Ambient
    FullBright.original_outdoor_ambient = Lighting.OutdoorAmbient
end

function FullBright.toggle()
    FullBright.enabled = not FullBright.enabled
    local Lighting = game:GetService("Lighting")

    if FullBright.enabled then
        FullBright.original_brightness = Lighting.Brightness
        FullBright.original_ambient = Lighting.Ambient
        FullBright.original_outdoor_ambient = Lighting.OutdoorAmbient
        
        Lighting.Brightness = 2
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        
        -- Remover sombras e névoa
        if Lighting:FindFirstChild("FogEnd") then
            Lighting.FogEnd = 100000
        end
        if Lighting:FindFirstChild("FogStart") then  
            Lighting.FogStart = 100000
        end
    else
        Lighting.Brightness = FullBright.original_brightness or 1
        Lighting.Ambient = FullBright.original_ambient or Color3.new(0, 0, 0)
        Lighting.OutdoorAmbient = FullBright.original_outdoor_ambient or Color3.new(0.5, 0.5, 0.5)
    end
    return FullBright.enabled
end

function FullBright.disable()
    if FullBright.enabled then
        FullBright.enabled = false
        local Lighting = game:GetService("Lighting")
        Lighting.Brightness = FullBright.original_brightness or 1
        Lighting.Ambient = FullBright.original_ambient or Color3.new(0, 0, 0)
        Lighting.OutdoorAmbient = FullBright.original_outdoor_ambient or Color3.new(0.5, 0.5, 0.5)
    end
end

return FullBright