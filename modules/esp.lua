-- modules/esp.lua - Sistema ESP
local ESP = {
    enabled = false,
    highlights = {},
    connections = {}
}

local Core = require(script.Parent.core)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

function ESP.enable()
    if ESP.enabled then return end
    ESP.enabled = true

    local st = Core.state()

    -- Função para criar ESP para um jogador
    local function createESP(player)
        if player == st.player or ESP.highlights[player] then return end

        local character = player.Character
        if not character then return end

        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then return end

        -- Criar Highlight
        local highlight = Instance.new("Highlight")
        highlight.Adornee = character
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.Parent = character

        -- Criar BillboardGui para nome
        local billboard = Instance.new("BillboardGui")
        billboard.Adornee = humanoidRootPart
        billboard.Size = UDim2.new(0, 100, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 2, 0)
        billboard.Parent = character

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, 0, 1, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = player.Name
        nameLabel.TextColor3 = Color3.new(1, 1, 1)
        nameLabel.TextStrokeTransparency = 0
        nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
        nameLabel.Font = Enum.Font.SourceSansBold
        nameLabel.TextSize = 14
        nameLabel.Parent = billboard

        ESP.highlights[player] = {
            highlight = highlight,
            billboard = billboard
        }
    end

    -- Criar ESP para jogadores existentes
    for _, player in pairs(Players:GetPlayers()) do
        createESP(player)
    end

    -- Conectar eventos para novos jogadores
    ESP.connections.playerAdded = Players.PlayerAdded:Connect(function(player)
        if ESP.enabled then
            createESP(player)
        end
    end)

    ESP.connections.playerRemoving = Players.PlayerRemoving:Connect(function(player)
        if ESP.highlights[player] then
            if ESP.highlights[player].highlight then
                ESP.highlights[player].highlight:Destroy()
            end
            if ESP.highlights[player].billboard then
                ESP.highlights[player].billboard:Destroy()
            end
            ESP.highlights[player] = nil
        end
    end)

    print("[ESP] Ativado - Jogadores visíveis")
end

function ESP.disable()
    if not ESP.enabled then return end
    ESP.enabled = false

    -- Desconectar eventos
    for _, connection in pairs(ESP.connections) do
        if connection then
            connection:Disconnect()
        end
    end
    ESP.connections = {}

    -- Remover todos os ESPs
    for _, espData in pairs(ESP.highlights) do
        if espData.highlight then
            espData.highlight:Destroy()
        end
        if espData.billboard then
            espData.billboard:Destroy()
        end
    end
    ESP.highlights = {}

    print("[ESP] Desativado")
end

return ESP