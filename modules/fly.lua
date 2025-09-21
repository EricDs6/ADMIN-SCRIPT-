-- modules/fly.lua - Sistema de voo aprimorado

local Fly = {
    enabled = false,
    speed = 50,
    bodyVelocity = nil,
    bodyGyro = nil,
    connection = nil,
    noclip = false
}

local Core = require(script.Parent.core)
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Função auxiliar para garantir que o personagem e HRP existem
local function getHRP()
    local st = Core.state()
    if not st or not st.humanoidRootPart or not st.character then
        warn("[Fly] Personagem ou HumanoidRootPart não encontrado!")
        return nil
    end
    return st.humanoidRootPart, st.character
end

function Fly.enable()
    if Fly.enabled then return end
    Fly.disable() -- Garante que não há resíduos

    local hrp, character = getHRP()
    if not hrp then return end

    Fly.enabled = true

    -- Cria BodyVelocity e BodyGyro
    Fly.bodyVelocity = Instance.new("BodyVelocity")
    Fly.bodyVelocity.MaxForce = Vector3.new(400000, 400000, 400000)
    Fly.bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    Fly.bodyVelocity.Parent = hrp

    Fly.bodyGyro = Instance.new("BodyGyro")
    Fly.bodyGyro.MaxTorque = Vector3.new(400000, 400000, 400000)
    Fly.bodyGyro.P = 3000
    Fly.bodyGyro.D = 500
    Fly.bodyGyro.Parent = hrp

    -- (Opcional) Noclip durante o voo
    Fly.noclip = true
    Fly.noclipConn = RunService.Stepped:Connect(function()
        if Fly.enabled and Fly.noclip and character then
            for _, part in pairs(character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)

    -- Loop de voo
    Fly.connection = RunService.Heartbeat:Connect(function()
        if not Fly.enabled then return end

        local moveVector = Vector3.new()
        local camera = workspace.CurrentCamera

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveVector = moveVector + camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveVector = moveVector - camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveVector = moveVector - camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveVector = moveVector + camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveVector = moveVector + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            moveVector = moveVector - Vector3.new(0, 1, 0)
        end

        -- Atalhos para ajustar velocidade em tempo real
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            Fly.speed = math.min(Fly.speed + 1, 500)
        elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftAlt) then
            Fly.speed = math.max(Fly.speed - 1, 10)
        end

        Fly.bodyVelocity.Velocity = moveVector.Unit * Fly.speed
        Fly.bodyGyro.CFrame = camera.CFrame
    end)

    print("[Fly] Ativado - Use WASD + Espaço/Ctrl para voar. Shift/Alt ajustam velocidade.")
end

function Fly.disable()
    Fly.enabled = false

    if Fly.connection then
        Fly.connection:Disconnect()
        Fly.connection = nil
    end
    if Fly.noclipConn then
        Fly.noclipConn:Disconnect()
        Fly.noclipConn = nil
    end
    if Fly.bodyVelocity then
        Fly.bodyVelocity:Destroy()
        Fly.bodyVelocity = nil
    end
    if Fly.bodyGyro then
        Fly.bodyGyro:Destroy()
        Fly.bodyGyro = nil
    end

    print("[Fly] Desativado")
end

function Fly.setSpeed(speed)
    Fly.speed = math.clamp(tonumber(speed) or 50, 10, 500)
    print("[Fly] Velocidade definida para: " .. Fly.speed)
end

return Fly