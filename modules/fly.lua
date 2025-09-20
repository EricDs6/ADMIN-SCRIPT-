-- modules/fly.lua
-- Sistema de voo avançado com múltiplos modos e controles

local Fly = { 
  enabled = false, 
  speed = 60,
  maxSpeed = 200,
  minSpeed = 10,
  currentVelocity = Vector3.new(),
  acceleration = 0.15,
  deceleration = 0.85,
  mode = "Normal", -- Normal, Fast, Stealth
  modes = {
    Normal = { speed = 60, accel = 0.15, maxForce = 400000 },
    Fast = { speed = 120, accel = 0.25, maxForce = 800000 },
    Stealth = { speed = 25, accel = 0.08, maxForce = 200000 }
  },
  hovering = true,
  effects = {
    trail = nil,
    sound = nil
  }
}

function Fly.setupEffects(st)
  -- Trail effect para modo Fast
  local attachment = Instance.new("Attachment")
  attachment.Name = "FK7_FlyTrail"
  attachment.Parent = st.hrp
  
  local trail = Instance.new("Trail")
  trail.Attachment0 = attachment
  trail.Attachment1 = attachment
  trail.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 200, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 100, 150))
  }
  trail.Transparency = NumberSequence.new{
    NumberSequenceKeypoint.new(0, 0.5),
    NumberSequenceKeypoint.new(1, 1)
  }
  trail.Lifetime = 0.5
  trail.MinLength = 0
  trail.Enabled = false
  trail.Parent = attachment
  
  Fly.effects.trail = trail
  Fly.effects.attachment = attachment
end

function Fly.setup(Core)
  Fly.Core = Core
  local st = Core.state()
  
  -- Configurar BodyVelocity
  Fly.bv = Instance.new("BodyVelocity")
  Fly.bv.MaxForce = Vector3.new(400000, 400000, 400000)
  Fly.bv.Velocity = Vector3.new()
  
  -- Configurar BodyGyro para rotação suave
  Fly.bg = Instance.new("BodyGyro")
  Fly.bg.MaxTorque = Vector3.new(400000, 400000, 400000)
  Fly.bg.P = 3000
  Fly.bg.D = 500
  
  -- Configurar BodyPosition para hover
  Fly.bp = Instance.new("BodyPosition")
  Fly.bp.MaxForce = Vector3.new(400000, 400000, 400000)
  Fly.bp.P = 10000
  Fly.bp.D = 1000
  
  -- Inicialmente desabilitados
  Fly.bv.Parent = nil
  Fly.bg.Parent = nil
  Fly.bp.Parent = nil
  
  -- Configurar efeitos visuais
  Fly.setupEffects(st)
end

function Fly.setMode(newMode)
  if Fly.modes[newMode] then
    Fly.mode = newMode
    local modeData = Fly.modes[newMode]
    Fly.speed = modeData.speed
    Fly.acceleration = modeData.accel
    
    if Fly.enabled then
      Fly.bv.MaxForce = Vector3.new(modeData.maxForce, modeData.maxForce, modeData.maxForce)
      Fly.bg.MaxTorque = Vector3.new(modeData.maxForce, modeData.maxForce, modeData.maxForce)
    end
    
    -- Efeitos visuais baseados no modo
    if Fly.effects.trail then
      Fly.effects.trail.Enabled = (newMode == "Fast" and Fly.enabled)
    end
    
    print("[FK7] Modo de voo alterado para: " .. newMode)
    return true
  end
  return false
end

function Fly.getSpeedMultiplier()
  local uis = Fly.Core.services().UserInputService
  local multiplier = 1
  
  -- Shift para acelerar
  if uis:IsKeyDown(Enum.KeyCode.LeftShift) or uis:IsKeyDown(Enum.KeyCode.RightShift) then
    multiplier = multiplier * 2.5
  end
  
  -- Alt para desacelerar
  if uis:IsKeyDown(Enum.KeyCode.LeftAlt) or uis:IsKeyDown(Enum.KeyCode.RightAlt) then
    multiplier = multiplier * 0.3
  end
  
  return multiplier
end
function Fly.toggle()
  Fly.enabled = not Fly.enabled
  local st = Fly.Core.state()
  
  if Fly.enabled then
    -- Aplicar configurações do modo atual
    local modeData = Fly.modes[Fly.mode]
    Fly.bv.MaxForce = Vector3.new(modeData.maxForce, modeData.maxForce, modeData.maxForce)
    Fly.bg.MaxTorque = Vector3.new(modeData.maxForce, modeData.maxForce, modeData.maxForce)
    
    -- Ativar objetos de física
    Fly.bv.Parent = st.hrp
    Fly.bg.Parent = st.hrp
    
    -- Configurar posição inicial para hover
    Fly.bp.Position = st.hrp.Position
    
    -- Resetar velocidade
    Fly.currentVelocity = Vector3.new()
    
    -- Ativar efeitos visuais
    if Fly.effects.trail and Fly.mode == "Fast" then
      Fly.effects.trail.Enabled = true
    end
    
    -- Loop principal de voo com movimento suave
    Fly.Core.connect("fly_loop", Fly.Core.services().RunService.RenderStepped:Connect(function()
      if not Fly.enabled then 
        Fly.Core.disconnect("fly_loop") 
        return 
      end
      
      local uis = Fly.Core.services().UserInputService
      local targetDirection = Vector3.new()
      
      -- Capturar inputs de movimento
      if uis:IsKeyDown(Enum.KeyCode.W) then 
        targetDirection = targetDirection + st.hrp.CFrame.LookVector 
      end
      if uis:IsKeyDown(Enum.KeyCode.S) then 
        targetDirection = targetDirection - st.hrp.CFrame.LookVector 
      end
      if uis:IsKeyDown(Enum.KeyCode.A) then 
        targetDirection = targetDirection - st.hrp.CFrame.RightVector 
      end
      if uis:IsKeyDown(Enum.KeyCode.D) then 
        targetDirection = targetDirection + st.hrp.CFrame.RightVector 
      end
      if uis:IsKeyDown(Enum.KeyCode.Space) then 
        targetDirection = targetDirection + Vector3.new(0, 1, 0) 
      end
      if uis:IsKeyDown(Enum.KeyCode.LeftControl) then 
        targetDirection = targetDirection - Vector3.new(0, 1, 0) 
      end
      
      -- Aplicar multiplicador de velocidade
      local speedMultiplier = Fly.getSpeedMultiplier()
      local targetSpeed = Fly.speed * speedMultiplier
      
      -- Movimento suave com aceleração/desaceleração
      if targetDirection.Magnitude > 0 then
        local targetVelocity = targetDirection.Unit * targetSpeed
        Fly.currentVelocity = Fly.currentVelocity:Lerp(targetVelocity, Fly.acceleration)
        Fly.hovering = false
        
        -- Desabilitar hover quando movendo
        if Fly.bp.Parent then
          Fly.bp.Parent = nil
        end
      else
        -- Desacelerar quando não há input
        Fly.currentVelocity = Fly.currentVelocity * Fly.deceleration
        
        -- Ativar hover quando parado
        if Fly.currentVelocity.Magnitude < 0.5 and not Fly.hovering then
          Fly.hovering = true
          Fly.bp.Position = st.hrp.Position
          Fly.bp.Parent = st.hrp
        end
      end
      
      -- Aplicar velocidade
      Fly.bv.Velocity = Fly.currentVelocity
      
      -- Rotação suave baseada na direção do mouse
      local camera = workspace.CurrentCamera
      Fly.bg.CFrame = CFrame.lookAt(st.hrp.Position, st.hrp.Position + camera.CFrame.LookVector)
      
    end))
    
    print("[FK7] Voo ativado - Modo: " .. Fly.mode)
  else
    Fly.Core.disconnect("fly_loop")
    Fly.bv.Parent = nil
    Fly.bg.Parent = nil
    Fly.bp.Parent = nil
    
    -- Desativar efeitos
    if Fly.effects.trail then
      Fly.effects.trail.Enabled = false
    end
    
    print("[FK7] Voo desativado")
  end
  
  return Fly.enabled
end
end

-- Funções de controle de modo (podem ser chamadas externamente)
function Fly.cycleMode()
  local modes = {"Normal", "Fast", "Stealth"}
  local currentIndex = 1
  
  for i, mode in ipairs(modes) do
    if mode == Fly.mode then
      currentIndex = i
      break
    end
  end
  
  local nextIndex = (currentIndex % #modes) + 1
  return Fly.setMode(modes[nextIndex])
end

function Fly.toggleNormalMode()
  return Fly.setMode("Normal")
end

function Fly.toggleFastMode()
  return Fly.setMode("Fast")
end

function Fly.toggleStealthMode()
  return Fly.setMode("Stealth")
end

function Fly.disable()
  if Fly.enabled then
    Fly.enabled = false
    Fly.Core.disconnect("fly_loop")
    Fly.bv.Parent = nil
    Fly.bg.Parent = nil
    Fly.bp.Parent = nil
    
    -- Limpar efeitos
    if Fly.effects.trail then
      Fly.effects.trail.Enabled = false
    end
  end
  
  -- Limpar objetos ao desabilitar completamente
  if Fly.effects.attachment then
    Fly.effects.attachment:Destroy()
    Fly.effects.attachment = nil
    Fly.effects.trail = nil
  end
end

return Fly
