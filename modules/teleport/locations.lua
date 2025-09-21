--[[
    Módulo de Teleporte
    Parte do Admin Script Modular v2.0
    
    Funcionalidades:
    - Teleportar para jogadores
    - Teleportar para locais predefinidos
    - Salvar localizações personalizadas
    - Voltar ao último local
]]

-- Verificar se AdminScript está disponível
local Admin = _G.AdminScript
if not Admin then
    warn("❌ AdminScript não inicializado! Módulo de teleporte não pode ser carregado.")
    return
end

local Services = Admin.Services
local Player = Admin.Player

-- Estado do módulo
local TeleportModule = {
    lastPosition = nil,
    savedLocations = {}
}

-- Função para teleportar para uma posição
local function teleportTo(position)
    -- Verificar se a posição é válida
    if not position or typeof(position) ~= "Vector3" then
        warn("❌ Posição inválida para teleporte!")
        return false
    end
    
    -- Verificar personagem
    local character = Player.Character
    if not character then
        warn("❌ Personagem não encontrado!")
        return false
    end
    
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then
        warn("❌ HumanoidRootPart não encontrado!")
        return false
    end
    
    -- Guardar posição atual antes de teleportar
    TeleportModule.lastPosition = hrp.Position
    
    -- Teleportar
    hrp.CFrame = CFrame.new(position)
    
    -- Notificar
    if Admin.Config.debugMode then
        print("🚀 Teleportado para: " .. tostring(position))
    end
    
    return true
end

-- Função para teleportar para um jogador
local function teleportToPlayer(playerName)
    -- Verificar se o nome é válido
    if not playerName or type(playerName) ~= "string" then
        warn("❌ Nome de jogador inválido!")
        return false
    end
    
    -- Verificar personagem do usuário
    local character = Player.Character
    if not character then
        warn("❌ Personagem não encontrado!")
        return false
    end
    
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then
        warn("❌ HumanoidRootPart não encontrado!")
        return false
    end
    
    -- Procurar o jogador alvo
    local targetPlayer = nil
    
    -- Verificar correspondência exata primeiro
    for _, plr in pairs(Services.Players:GetPlayers()) do
        if plr.Name:lower() == playerName:lower() then
            targetPlayer = plr
            break
        end
    end
    
    -- Se não encontrou correspondência exata, procurar por correspondência parcial
    if not targetPlayer then
        for _, plr in pairs(Services.Players:GetPlayers()) do
            if plr.Name:lower():find(playerName:lower(), 1, true) then
                targetPlayer = plr
                break
            end
        end
    end
    
    -- Verificar se encontrou o jogador
    if not targetPlayer then
        warn("❌ Jogador '" .. playerName .. "' não encontrado!")
        return false
    end
    
    -- Verificar se o jogador alvo tem personagem
    local targetCharacter = targetPlayer.Character
    if not targetCharacter then
        warn("❌ Personagem do jogador alvo não encontrado!")
        return false
    end
    
    local targetHRP = targetCharacter:FindFirstChild("HumanoidRootPart")
    if not targetHRP then
        warn("❌ HumanoidRootPart do jogador alvo não encontrado!")
        return false
    end
    
    -- Guardar posição atual antes de teleportar
    TeleportModule.lastPosition = hrp.Position
    
    -- Teleportar
    hrp.CFrame = targetHRP.CFrame * CFrame.new(0, 0, 3) -- 3 studs atrás do alvo
    
    -- Notificar
    if Admin.Config.debugMode then
        print("🚀 Teleportado para jogador: " .. targetPlayer.Name)
    end
    
    return true
end

-- Função para voltar ao último local
local function goBack()
    -- Verificar se há posição anterior
    if not TeleportModule.lastPosition then
        warn("❌ Nenhuma posição anterior disponível!")
        return false
    end
    
    -- Teleportar para a última posição
    local success = teleportTo(TeleportModule.lastPosition)
    
    -- Se o teleporte foi bem-sucedido, limpar a última posição
    if success then
        local temp = TeleportModule.lastPosition
        TeleportModule.lastPosition = nil
        
        -- Notificar
        if Admin.Config.debugMode then
            print("🔄 Retornado à posição anterior: " .. tostring(temp))
        end
    end
    
    return success
end

-- Função para salvar localização atual
local function saveLocation(name)
    -- Verificar se o nome é válido
    if not name or type(name) ~= "string" then
        warn("❌ Nome inválido para salvar localização!")
        return false
    end
    
    -- Verificar personagem
    local character = Player.Character
    if not character then
        warn("❌ Personagem não encontrado!")
        return false
    end
    
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then
        warn("❌ HumanoidRootPart não encontrado!")
        return false
    end
    
    -- Salvar localização
    TeleportModule.savedLocations[name] = {
        position = hrp.Position,
        saveTime = tick()
    }
    
    -- Notificar
    if Admin.Config.debugMode then
        print("💾 Localização '" .. name .. "' salva: " .. tostring(hrp.Position))
    end
    
    return true
end

-- Função para teleportar para uma localização salva
local function teleportToSaved(name)
    -- Verificar se o nome é válido
    if not name or type(name) ~= "string" then
        warn("❌ Nome inválido para localização salva!")
        return false
    end
    
    -- Verificar se a localização existe
    if not TeleportModule.savedLocations[name] then
        warn("❌ Localização '" .. name .. "' não encontrada!")
        return false
    end
    
    -- Obter posição salva
    local savedPosition = TeleportModule.savedLocations[name].position
    
    -- Teleportar para a posição salva
    local success = teleportTo(savedPosition)
    
    -- Notificar
    if success and Admin.Config.debugMode then
        print("🚀 Teleportado para localização salva: " .. name)
    end
    
    return success
end

-- Função para listar todas as localizações salvas
local function listSavedLocations()
    local locations = {}
    
    for name, data in pairs(TeleportModule.savedLocations) do
        table.insert(locations, {
            name = name,
            position = data.position,
            saveTime = data.saveTime
        })
    end
    
    return locations
end

-- Função para remover uma localização salva
local function removeLocation(name)
    -- Verificar se o nome é válido
    if not name or type(name) ~= "string" then
        warn("❌ Nome inválido para remover localização!")
        return false
    end
    
    -- Verificar se a localização existe
    if not TeleportModule.savedLocations[name] then
        warn("❌ Localização '" .. name .. "' não encontrada!")
        return false
    end
    
    -- Remover localização
    TeleportModule.savedLocations[name] = nil
    
    -- Notificar
    if Admin.Config.debugMode then
        print("🗑️ Localização '" .. name .. "' removida")
    end
    
    return true
end

-- Locais pré-definidos para jogos populares
local predefinedLocations = {
    -- Prisão
    ["Prison"] = {
        ["Celas"] = Vector3.new(917, 99.9, 2453),
        ["Refeitório"] = Vector3.new(918, 99.9, 2325),
        ["Pátio"] = Vector3.new(779, 97.9, 2477),
        ["Armamento"] = Vector3.new(789, 99.9, 2260),
        ["Saída"] = Vector3.new(503, 102.9, 2250)
    }
}

-- Função para teleportar para local pré-definido
local function teleportToPredefined(gameType, locationName)
    -- Verificar se o tipo de jogo é válido
    if not predefinedLocations[gameType] then
        warn("❌ Tipo de jogo '" .. tostring(gameType) .. "' não reconhecido!")
        return false
    end
    
    -- Verificar se o local existe
    if not predefinedLocations[gameType][locationName] then
        warn("❌ Local '" .. tostring(locationName) .. "' não encontrado no jogo '" .. gameType .. "'!")
        return false
    end
    
    -- Obter posição pré-definida
    local position = predefinedLocations[gameType][locationName]
    
    -- Teleportar
    local success = teleportTo(position)
    
    -- Notificar
    if success and Admin.Config.debugMode then
        print("🚀 Teleportado para local pré-definido: " .. gameType .. " - " .. locationName)
    end
    
    return success
end

-- Função para listar locais pré-definidos para um jogo
local function listPredefinedLocations(gameType)
    if not gameType or not predefinedLocations[gameType] then
        return {}
    end
    
    local locations = {}
    
    for name, _ in pairs(predefinedLocations[gameType]) do
        table.insert(locations, name)
    end
    
    return locations
end

-- Exportar funções do módulo
local API = {
    to = teleportTo,
    toPlayer = teleportToPlayer,
    back = goBack,
    saveLocation = saveLocation,
    toSaved = teleportToSaved,
    listSaved = listSavedLocations,
    removeLocation = removeLocation,
    toPredefined = teleportToPredefined,
    listPredefined = listPredefinedLocations
}

-- Registrar na API global
Admin.Teleport.locations = API

-- Mensagem de carregamento
print("✅ Módulo de teleporte carregado!")
print("💡 Use Admin.Teleport.locations.toPlayer('nome') para teleportar para um jogador")
print("💡 Use Admin.Teleport.locations.saveLocation('nome') para salvar localização atual")
print("💡 Use Admin.Teleport.locations.back() para voltar ao local anterior")

-- Retornar API do módulo
return API