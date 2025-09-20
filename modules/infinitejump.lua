-- modules/infinitejump.lua
local InfiniteJump = { enabled = false }

function InfiniteJump.setup(Core)
    InfiniteJump.Core = Core
    Core.onCharacterAdded(function()
        if InfiniteJump.enabled then
            local services = Core.services()
            InfiniteJump.Core.connect("infinite_jump", services.UserInputService.JumpRequest:Connect(function()
                if InfiniteJump.enabled then
                    local st = Core.state()
                    st.humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end))
        end
    end)
end

function InfiniteJump.toggle()
    InfiniteJump.enabled = not InfiniteJump.enabled
    local services = InfiniteJump.Core.services()

    if InfiniteJump.enabled then
        InfiniteJump.Core.connect("infinite_jump", services.UserInputService.JumpRequest:Connect(function()
            if InfiniteJump.enabled then
                local st = InfiniteJump.Core.state()
                st.humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end))
    else
        InfiniteJump.Core.disconnect("infinite_jump")
    end
    return InfiniteJump.enabled
end

function InfiniteJump.disable()
    if InfiniteJump.enabled then
        InfiniteJump.enabled = false
        InfiniteJump.Core.disconnect("infinite_jump")
    end
end

return InfiniteJump