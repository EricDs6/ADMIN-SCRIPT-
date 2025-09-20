-- modules/fullbright.lua - Iluminação total
local Fullbright = {
    enabled = false,
    originalBrightness = nil,
    originalAmbient = nil
}

local Core = require(script.Parent.core)
local Lighting = game:GetService("Lighting")

function Fullbright.enable()
    if Fullbright.enabled then return end
    Fullbright.enabled = true

    -- Salvar valores originais
    Fullbright.originalBrightness = Lighting.Brightness
    Fullbright.originalAmbient = Lighting.Ambient

    -- Aplicar iluminação total
    Lighting.Brightness = 2
    Lighting.Ambient = Color3.new(1, 1, 1)

    print("[Fullbright] Ativado - Ambiente totalmente iluminado")
end

function Fullbright.disable()
    if not Fullbright.enabled then return end
    Fullbright.enabled = false

    -- Restaurar valores originais
    if Fullbright.originalBrightness then
        Lighting.Brightness = Fullbright.originalBrightness
    end
    if Fullbright.originalAmbient then
        Lighting.Ambient = Fullbright.originalAmbient
    end

    print("[Fullbright] Desativado")
end

return Fullbright