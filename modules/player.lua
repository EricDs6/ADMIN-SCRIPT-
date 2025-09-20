-- modules/player.lua
-- Velocidade, pulo, invisibilidade

local Player = { speedOn = false, jumpOn = false, invisOn = false, speed = 32, jump = 100 }

function Player.setup(Core)
  Player.Core = Core
  local st = Core.state()
  Player.defaultWalk = st.humanoid.WalkSpeed
  Player.defaultJump = st.humanoid.JumpPower
end

function Player.toggleSpeed()
  Player.speedOn = not Player.speedOn
  local st = Player.Core.state()
  st.humanoid.WalkSpeed = Player.speedOn and Player.speed or Player.defaultWalk
  return Player.speedOn
end

function Player.toggleJump()
  Player.jumpOn = not Player.jumpOn
  local st = Player.Core.state()
  st.humanoid.JumpPower = Player.jumpOn and Player.jump or Player.defaultJump
  return Player.jumpOn
end

function Player.toggleInvisible()
  Player.invisOn = not Player.invisOn
  local st = Player.Core.state()
  for _, p in ipairs(st.character:GetDescendants()) do
    if p:IsA("BasePart") then
      p.Transparency = Player.invisOn and 1 or 0
      if p:FindFirstChildOfClass("Decal") then p:FindFirstChildOfClass("Decal").Transparency = Player.invisOn and 1 or 0 end
    end
  end
  return Player.invisOn
end

function Player.disable()
  local st = Player.Core.state()
  if Player.speedOn then
    Player.speedOn = false
    st.humanoid.WalkSpeed = Player.defaultWalk
  end
  if Player.jumpOn then
    Player.jumpOn = false
    st.humanoid.JumpPower = Player.defaultJump
  end
  if Player.invisOn then
    Player.invisOn = false
    for _, p in ipairs(st.character:GetDescendants()) do
      if p:IsA("BasePart") then
        p.Transparency = 0
        if p:FindFirstChildOfClass("Decal") then p:FindFirstChildOfClass("Decal").Transparency = 0 end
      end
    end
  end
end

return Player
