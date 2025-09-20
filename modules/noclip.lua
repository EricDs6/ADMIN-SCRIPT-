-- modules/noclip.lua - Sistema de noclip
local Noclip = {
    enabled = false,
    connection = nil
}

local Core = require(script.Parent.core)
local RunService = game:GetService("RunService")

function Noclip.enable()
    if Noclip.enabled then return end
    Noclip.enabled = true

    local st = Core.state()

    Noclip.connection = RunService.Stepped:Connect(function()
        if not Noclip.enabled then return end

        for _, part in pairs(st.character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end)

    print("[Noclip] Ativado - Você pode atravessar paredes")
end

function Noclip.disable()
    if not Noclip.enabled then return end
    Noclip.enabled = false

    if Noclip.connection then
        Noclip.connection:Disconnect()
        Noclip.connection = nil
    end

    local st = Core.state()
    for _, part in pairs(st.character:GetChildren()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            part.CanCollide = true
        end
    end

    print("[Noclip] Desativado")
end

return Noclip