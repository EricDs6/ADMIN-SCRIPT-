-- modules/fly.lua - voo básico mínimo
local Fly = { enabled = false }

function Fly.setup(Core)
    Fly.Core = Core
    Fly.bv = Instance.new("BodyVelocity")
    Fly.bv.MaxForce = Vector3.new(4e5, 4e5, 4e5)
    Fly.bv.Velocity = Vector3.new()
    Fly.bg = Instance.new("BodyGyro")
    Fly.bg.MaxTorque = Vector3.new(4e5, 4e5, 4e5)
    Fly.bg.P = 3000
    Fly.bg.D = 500

    Core.onCharacterAdded(function()
        if Fly.enabled then
            local st = Core.state()
            Fly.bv.Parent = st.hrp
            Fly.bg.Parent = st.hrp
        end
    end)
end

function Fly.toggle()
  local st = Fly.Core.state()
  Fly.enabled = not Fly.enabled
  if Fly.enabled then
    Fly.bv.Parent = st.hrp; Fly.bg.Parent = st.hrp
    Fly.Core.connect("fly_loop", Fly.Core.services().RunService.RenderStepped:Connect(function()
      if not Fly.enabled then Fly.Core.disconnect("fly_loop"); return end
      local uis = Fly.Core.services().UserInputService
      local dir = Vector3.new()
      if uis:IsKeyDown(Enum.KeyCode.W) then dir += st.hrp.CFrame.LookVector end
      if uis:IsKeyDown(Enum.KeyCode.S) then dir -= st.hrp.CFrame.LookVector end
      if uis:IsKeyDown(Enum.KeyCode.A) then dir -= st.hrp.CFrame.RightVector end
      if uis:IsKeyDown(Enum.KeyCode.D) then dir += st.hrp.CFrame.RightVector end
      if uis:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
      if uis:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.new(0,1,0) end
      Fly.bv.Velocity = dir.Magnitude > 0 and dir.Unit * 60 or Vector3.new()
      Fly.bg.CFrame = CFrame.new(st.hrp.Position, st.hrp.Position + st.mouse.Hit.LookVector)
    end))
  else
    Fly.Core.disconnect("fly_loop"); Fly.bv.Parent = nil; Fly.bg.Parent = nil
  end
  return Fly.enabled
end

function Fly.disable()
  if Fly.enabled then Fly.enabled=false; Fly.Core.disconnect("fly_loop"); Fly.bv.Parent=nil; Fly.bg.Parent=nil end
end

return Fly
