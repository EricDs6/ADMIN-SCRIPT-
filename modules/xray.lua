-- modules/xray.lua - Visão através de paredes
local XRay = { enabled = false }

function XRay.setup(Core)
    XRay.Core = Core
    XRay.original_transparency = {}
end

function XRay.toggle()
    XRay.enabled = not XRay.enabled
    XRay.Core.registerForRespawn("xray", XRay.enabled)
    
    if XRay.enabled then
        -- Salvar transparências originais e tornar paredes transparentes
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Parent ~= XRay.Core.state().character then
                if not XRay.original_transparency[obj] then
                    XRay.original_transparency[obj] = obj.Transparency
                end
                obj.Transparency = 0.7 -- Tornar semi-transparente
            end
        end
        
        -- Conectar para novos objetos que aparecem
        XRay.Core.connect("xray_new", workspace.DescendantAdded:Connect(function(obj)
            if XRay.enabled and obj:IsA("BasePart") and obj.Parent ~= XRay.Core.state().character then
                XRay.original_transparency[obj] = obj.Transparency
                obj.Transparency = 0.7
            end
        end))
    else
        -- Restaurar transparências originais
        for obj, original in pairs(XRay.original_transparency) do
            if obj and obj.Parent then
                obj.Transparency = original
            end
        end
        XRay.original_transparency = {}
        XRay.Core.disconnect("xray_new")
    end
    
    return XRay.enabled
end

function XRay.disable()
    if XRay.enabled then
        XRay.enabled = false
        -- Restaurar transparências
        for obj, original in pairs(XRay.original_transparency) do
            if obj and obj.Parent then
                obj.Transparency = original
            end
        end
        XRay.original_transparency = {}
        XRay.Core.disconnect("xray_new")
    end
end

return XRay