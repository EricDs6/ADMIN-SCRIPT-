-- modules/noclip.lua
local Noclip = { enabled = false }

function Noclip.setup(Core)
    Noclip.Core = Core
    Core.onCharacterAdded(function()
        if Noclip.enabled then
            -- Re-ativa o loop de noclip no novo personagem
            Noclip.Core.disconnect("noclip_loop") -- Garante que não haja loops duplicados
            local st = Noclip.Core.state()
            local services = Noclip.Core.services()
            Noclip.Core.connect("noclip_loop", services.RunService.Stepped:Connect(function()
                if not st.character then return end
                for _, part in pairs(st.character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end))
        end
    end)
end

function Noclip.toggle()
    Noclip.enabled = not Noclip.enabled
    local st = Noclip.Core.state()
    local services = Noclip.Core.services()

    if Noclip.enabled then
        Noclip.Core.connect("noclip_loop", services.RunService.Stepped:Connect(function()
            if not st.character then return end
            for _, part in pairs(st.character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end))
    else
        Noclip.Core.disconnect("noclip_loop")
        if not st.character then return end
        for _, part in pairs(st.character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
    return Noclip.enabled
end

function Noclip.disable()
    if Noclip.enabled then
        Noclip.enabled = false
        Noclip.Core.disconnect("noclip_loop")
        local st = Noclip.Core.state()
        if not st.character then return end
        for _, part in pairs(st.character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

return Noclip
