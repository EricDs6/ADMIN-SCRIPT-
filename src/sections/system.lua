-- Seção Sistema
local M = {}

function M.mount(ctx)
    local ui, content = ctx.ui, ctx.gui.contentFrame
    local y = ctx.yOffset
    ui.createLabel("Sistema", UDim2.new(0, 10, 0, y), content)
    y = y + 35

    local resetButton = ui.createButton("Reiniciar Todas as Funcionalidades", UDim2.new(0, 20, 0, y), Color3.fromRGB(150, 50, 50), content)
    y = y + 45
    local exitButton = ui.createButton("🚪 Encerrar Script", UDim2.new(0, 20, 0, y), Color3.fromRGB(150, 50, 50), content)
    y = y + 45

    resetButton.MouseButton1Click:Connect(function()
        if ctx.system and ctx.system.resetAll then ctx.system.resetAll() end
    end)
    exitButton.MouseButton1Click:Connect(function()
        if ctx.system and ctx.system.terminate then ctx.system.terminate() end
    end)

    ctx.yOffset = y
    return { reset = function() end }
end

return M
