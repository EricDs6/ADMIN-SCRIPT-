-- modules/clicktp.lua - Teleporte ao clicar
local ClickTP = {
    enabled = false,
    connection = nil
}

local Core = require(script.Parent.core)
local Players = game:GetService("Players")

function ClickTP.enable()
    if ClickTP.enabled then return end
    ClickTP.enabled = true

    local st = Core.state()
    local player = st.player
    local mouse = player:GetMouse()

    ClickTP.connection = mouse.Button1Down:Connect(function()
        if not ClickTP.enabled then return end

        local hit = mouse.Hit
        if hit and typeof(hit) == "CFrame" then
            local pos = hit.Position
            if typeof(pos) == "Vector3" and pos.Y > -1e5 and pos.Y < 1e5 then
                st.humanoidRootPart.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
                print("[ClickTP] Teleportado para: " .. tostring(pos))
            end
        end
    end)

    print("[ClickTP] Ativado - Clique no mapa para teleportar")
end

function ClickTP.disable()
    if not ClickTP.enabled then return end
    ClickTP.enabled = false

    if ClickTP.connection then
        ClickTP.connection:Disconnect()
        ClickTP.connection = nil
    end

    print("[ClickTP] Desativado")
end

return ClickTP