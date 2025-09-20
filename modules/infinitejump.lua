-- modules/infinitejump.lua - Pulo infinito
local InfiniteJump = {
    enabled = false,
    connection = nil
}

local Core = require(script.Parent.core)
local UserInputService = game:GetService("UserInputService")

function InfiniteJump.enable()
    if InfiniteJump.enabled then return end
    InfiniteJump.enabled = true

    local st = Core.state()
    local humanoid = st.humanoid

    InfiniteJump.connection = UserInputService.JumpRequest:Connect(function()
        if InfiniteJump.enabled then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)

    print("[InfiniteJump] Ativado - Pule infinitamente!")
end

function InfiniteJump.disable()
    if not InfiniteJump.enabled then return end
    InfiniteJump.enabled = false

    if InfiniteJump.connection then
        InfiniteJump.connection:Disconnect()
        InfiniteJump.connection = nil
    end

    print("[InfiniteJump] Desativado")
end

return InfiniteJump