-- modules/stick.lua
-- Grudar com Seat/Weld no alvo do mouse

local Stick = { seat = nil, weld = nil, target = nil }

function Stick.setup(Core)
  Stick.Core = Core
end

local function clear()
  local st = Stick.Core.state()
  if Stick.seat then pcall(function() Stick.seat:Destroy() end) Stick.seat = nil end
  if Stick.weld then pcall(function() Stick.weld:Destroy() end) Stick.weld = nil end
  Stick.target = nil
  if st and st.humanoid then st.humanoid.Sit = false; st.humanoid.PlatformStand = false end
end

function Stick.unstick()
  clear()
end

local function trySeat(part)
  local st = Stick.Core.state()
  local seat = Instance.new("Seat")
  seat.Name = "FK7_Seat"
  seat.Anchored = false
  seat.Transparency = 1
  seat.Size = Vector3.new(2, 1, 2)
  seat.TopSurface = Enum.SurfaceType.Smooth
  seat.BottomSurface = Enum.SurfaceType.Smooth
  seat.CFrame = CFrame.new(part.Position + Vector3.new(0, part.Size.Y/2 + 1.5, 0))
  seat.Parent = workspace
  local weld = Instance.new("WeldConstraint")
  weld.Part0 = seat
  weld.Part1 = part
  weld.Parent = seat
  Stick.seat = seat
  Stick.weld = weld
  Stick.target = part
  task.delay(0.1, function()
    pcall(function() st.humanoid.Sit = false end)
    st.hrp.CFrame = seat.CFrame * CFrame.new(0, 1, 0)
    pcall(function() st.humanoid.Sit = true end)
  end)
  task.delay(0.7, function()
    if seat.Parent and seat.Occupant == st.humanoid then return end
    -- fallback weld HRP->part
    local w = Instance.new("WeldConstraint")
    w.Part0 = st.hrp
    w.Part1 = part
    w.Parent = st.hrp
    pcall(function() seat:Destroy() end)
    Stick.seat = nil
    Stick.weld = w
    Stick.target = part
  end)
end

function Stick.stickToMouseTarget()
  local st = Stick.Core.state()
  local target = st.mouse.Target
  if target and target:IsA("BasePart") and not target:IsDescendantOf(st.character) then
    clear()
    trySeat(target)
    return true
  end
  warn("Nenhuma parte válida sob o mouse")
  return false
end

return Stick
