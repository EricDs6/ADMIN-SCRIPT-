-- modules/fly.lua - Sistema de voo
local Fly = {
    enabled = false,
    speed = 50,
    bodyVelocity = nil,
    bodyGyro = nil
}

local Core = require(script.Parent.core)
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

function Fly.enable()
    if Fly.enabled then return end
    Fly.enabled = true

    local st = Core.state()
    Fly.bodyVelocity = Instance.new("BodyVelocity")
    Fly.bodyVelocity.MaxForce = Vector3.new(400000, 400000, 400000)
    Fly.bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    Fly.bodyVelocity.Parent = st.humanoidRootPart

    Fly.bodyGyro = Instance.new("BodyGyro")
    Fly.bodyGyro.MaxTorque = Vector3.new(400000, 400000, 400000)
    Fly.bodyGyro.P = 3000
    Fly.bodyGyro.D = 500
    Fly.bodyGyro.Parent = st.humanoidRootPart

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

        Fly.bodyVelocity.Velocity = moveVector * Fly.speed
        Fly.bodyGyro.CFrame = camera.CFrame
    end)

    print("[Fly] Ativado - Use WASD + Space/Ctrl para voar")
end

function Fly.disable()
    if not Fly.enabled then return end
    Fly.enabled = false

    if Fly.connection then
        Fly.connection:Disconnect()
        Fly.connection = nil
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
    Fly.speed = math.clamp(speed, 10, 500)
    print("[Fly] Velocidade definida para: " .. Fly.speed)
end

return Fly