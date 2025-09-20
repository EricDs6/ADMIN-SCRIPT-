-- modules/esp.lua - Ver jogadores através de paredes
local ESP = { enabled = false }

function ESP.setup(Core)
    ESP.Core = Core
    ESP.highlights = {}
end

function ESP.createHighlight(player)
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        return
    end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_Highlight"
    highlight.Adornee = player.Character
    highlight.FillColor = player.TeamColor and player.TeamColor.Color or Color3.fromRGB(255, 0, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Parent = player.Character
    
    -- Adicionar nome acima da cabeça
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_Name"
    billboard.Size = UDim2.new(0, 200, 0, 30)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.Parent = player.Character:FindFirstChild("Head")
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = Color3.new(1, 1, 1)
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 16
    nameLabel.Parent = billboard
    
    ESP.highlights[player] = {highlight = highlight, billboard = billboard}
end

function ESP.removeHighlight(player)
    if ESP.highlights[player] then
        if ESP.highlights[player].highlight then
            ESP.highlights[player].highlight:Destroy()
        end
        if ESP.highlights[player].billboard then
            ESP.highlights[player].billboard:Destroy()
        end
        ESP.highlights[player] = nil
    end
end

function ESP.toggle()
    ESP.enabled = not ESP.enabled
    ESP.Core.registerForRespawn("esp", ESP.enabled)
    local Players = ESP.Core.services().Players
    
    if ESP.enabled then
        -- Adicionar ESP para todos os jogadores
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= Players.LocalPlayer then
                ESP.createHighlight(player)
            end
        end
        
        -- Conectar eventos para novos jogadores
        ESP.Core.connect("esp_added", Players.PlayerAdded:Connect(function(player)
            if ESP.enabled then
                player.CharacterAdded:Connect(function()
                    task.wait(1) -- Aguardar character carregar
                    ESP.createHighlight(player)
                end)
            end
        end))
        
        ESP.Core.connect("esp_removed", Players.PlayerRemoving:Connect(function(player)
            ESP.removeHighlight(player)
        end))
        
        -- Monitorar respawns
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= Players.LocalPlayer then
                player.CharacterAdded:Connect(function()
                    if ESP.enabled then
                        task.wait(1)
                        ESP.createHighlight(player)
                    end
                end)
            end
        end
    else
        -- Remover todos os highlights
        for player, _ in pairs(ESP.highlights) do
            ESP.removeHighlight(player)
        end
        ESP.Core.disconnect("esp_added")
        ESP.Core.disconnect("esp_removed")
    end
    
    return ESP.enabled
end

function ESP.disable()
    if ESP.enabled then
        ESP.enabled = false
        for player, _ in pairs(ESP.highlights) do
            ESP.removeHighlight(player)
        end
        ESP.Core.disconnect("esp_added")
        ESP.Core.disconnect("esp_removed")
    end
end

return ESP