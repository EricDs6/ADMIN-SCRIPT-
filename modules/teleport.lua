-- modules/teleport.lua
-- Click TP simples

local TP = { click = false }

function TP.setup(Core)
  TP.Core = Core
end

function TP.toggleClickTP()
  TP.click = not TP.click
  local st = TP.Core.state()
  local uis = TP.Core.services().UserInputService
  if TP.click then
    if TP.conn then TP.conn:Disconnect() end
    TP.conn = uis.InputBegan:Connect(function(input, gpe)
      if gpe then return end
      if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local pos = st.mouse.Hit.Position
        st.hrp.CFrame = CFrame.new(pos + Vector3.new(0,5,0))
      end
    end)
  else
    if TP.conn then TP.conn:Disconnect(); TP.conn = nil end
  end
  return TP.click
end

return TP
