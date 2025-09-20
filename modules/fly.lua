-- modules/fly.lua
-- Voo básico com BodyVelocity/BodyGyro

local Fly = { enabled = false, speed = 60 }

function Fly.setup(Core)
  Fly.Core = Core
  local st = Core.state()
  Fly.bv = Instance.new("BodyVelocity")
  Fly.bv.MaxForce = Vector3.new(400000, 400000, 400000)
  Fly.bv.Parent = st.hrp
  Fly.bg = Instance.new("BodyGyro")
  Fly.bg.MaxTorque = Vector3.new(400000, 400000, 400000)
  Fly.bg.P = 3000
  Fly.bg.D = 500
  Fly.bg.Parent = st.hrp
  Fly.bv.Velocity = Vector3.new()
  Fly.bg.CFrame = st.hrp.CFrame
  Fly.bv.Parent = nil
  Fly.bg.Parent = nil
end

function Fly.toggle()
  Fly.enabled = not Fly.enabled
  local st = Fly.Core.state()
  if Fly.enabled then
    Fly.bv.Parent = st.hrp
    Fly.bg.Parent = st.hrp
    Fly.Core.connect("fly_loop", Fly.Core.services().RunService.RenderStepped:Connect(function()
      if not Fly.enabled then 
        Fly.Core.disconnect("fly_loop") 
        return 
      end
      local dir = Vector3.new()
      local uis = Fly.Core.services().UserInputService
      if uis:IsKeyDown(Enum.KeyCode.W) then dir = dir + st.hrp.CFrame.LookVector end
      if uis:IsKeyDown(Enum.KeyCode.S) then dir = dir - st.hrp.CFrame.LookVector end
      if uis:IsKeyDown(Enum.KeyCode.A) then dir = dir - st.hrp.CFrame.RightVector end
      if uis:IsKeyDown(Enum.KeyCode.D) then dir = dir + st.hrp.CFrame.RightVector end
      if uis:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0,1,0) end
      if uis:IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir - Vector3.new(0,1,0) end
      Fly.bv.Velocity = dir.Unit.Magnitude > 0 and dir.Unit * Fly.speed or Vector3.new()
      Fly.bg.CFrame = CFrame.new(st.hrp.Position, st.hrp.Position + st.mouse.Hit.LookVector)
    end))
  else
    Fly.Core.disconnect("fly_loop")
    Fly.bv.Parent = nil
    Fly.bg.Parent = nil
  end
  return Fly.enabled
end

function Fly.disable()
  if Fly.enabled then
    Fly.enabled = false
    Fly.Core.disconnect("fly_loop")
    Fly.bv.Parent = nil
    Fly.bg.Parent = nil
  end
end

return Fly
