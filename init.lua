-- Admin Script Modular - Loader Principal-- Loader do Admin Script via loadstring

-- Execução: loadstring(game:HttpGet("https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-/main/init.lua"))()-- Suporta diferentes executores: Synapse, KRNL, Script-Ware, etc.



print("🚀 Carregando Admin Script Modular - Movimento...")local function httpGet(url)

    -- Tenta usar APIs comuns dos executores

-- Configuração base no _G    local ok, res

if not _G.AdminScript then    if syn and syn.request then

    _G.AdminScript = {        ok, res = pcall(syn.request, {Url = url, Method = "GET"})

        -- Serviços        if ok and res and res.Success and res.Body then return res.Body end

        Services = {    end

            Players = game:GetService("Players"),    if http and http.request then

            UserInputService = game:GetService("UserInputService"),        ok, res = pcall(http.request, {Url = url, Method = "GET"})

            RunService = game:GetService("RunService"),        if ok and res and res.Body then return res.Body end

            TweenService = game:GetService("TweenService")    end

        },    if http_request then

                ok, res = pcall(http_request, {Url = url, Method = "GET"})

        -- Player info        if ok and res and (res.Body or res.body) then return res.Body or res.body end

        Player = game:GetService("Players").LocalPlayer,    end

            if request then

        -- Estado global        ok, res = pcall(request, {Url = url, Method = "GET"})

        Connections = {},        if ok and res and (res.Body or res.body) then return res.Body or res.body end

        OriginalValues = {},    end

            if game and game.HttpGet then

        -- GUI elementos        ok, res = pcall(function() return game:HttpGet(url) end)

        GUI = {},        if ok and res then return res end

            end

        -- Estados dos módulos    error("Nenhuma API HTTP suportada encontrada para buscar: " .. url)

        Movement = {end

            flyEnabled = false,

            noclipEnabled = false,-- URL bruto do módulo principal (ajuste para o seu repositório público)

            flySpeed = 50-- Dica: hospede o conteúdo de src/admin_core.lua e substitua a URL abaixo

        }local ADMIN_CORE_URL = "https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-RBX/main/src/admin_core.lua"

    }local ADMIN_CORE_FALLBACK = "https://cdn.jsdelivr.net/gh/EricDs6/ADMIN-SCRIPT-RBX@main/src/admin_core.lua"

end

-- Verificar compilador disponível

local Admin = _G.AdminScriptlocal compile = loadstring or _G and _G.loadstring

local Player = Admin.Playerif not compile then

local Services = Admin.Services    error("Seu executor não disponibiliza loadstring para compilar o módulo.")

end

-- Atualizar referências do personagem

local function updateCharacter()-- Tentar carregar localmente primeiro (desenvolvimento), depois remoto

    Admin.Character = Player.Character or Player.CharacterAdded:Wait()local src

    Admin.Humanoid = Admin.Character:WaitForChild("Humanoid")if readfile then

    Admin.HumanoidRootPart = Admin.Character:WaitForChild("HumanoidRootPart")    local ok, exists = pcall(function()

end        return (isfile and isfile("src/admin_core.lua")) or (isfile and isfile("admin_core.lua"))

    end)

-- Função para carregar módulos via HTTP    if ok and exists then

local function loadModule(moduleName)        src = (isfile("src/admin_core.lua") and readfile("src/admin_core.lua")) or readfile("admin_core.lua")

    local baseURL = "https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-/main/modules/"    end

    local url = baseURL .. moduleName .. ".lua"end

    if not src then

    print("📦 Carregando módulo: " .. moduleName)    -- tentar primário

        src = httpGet(ADMIN_CORE_URL)

    local success, result = pcall(function()    -- se ainda assim vier JSON/HTML, tentar fallback

        return game:HttpGet(url)    if type(src) == "string" then

    end)        local c = src:sub(1, 64)

            local looksLikeJson = c:sub(1,1) == "{" or c:find("\"message\"%s*:")

    if success and result then        local looksLikeHtml = c:find("<!DOCTYPE") or c:find("<html")

        local moduleFunction = loadstring(result)        if looksLikeJson or looksLikeHtml then

        if moduleFunction then            src = httpGet(ADMIN_CORE_FALLBACK)

            moduleFunction()        end

            print("✅ Módulo " .. moduleName .. " carregado com sucesso!")    end

            return trueend

        else

            warn("❌ Falha ao compilar módulo: " .. moduleName)local chunk, err = compile(src)

        endif not chunk then

    else    local preview = (type(src) == "string" and src:sub(1, 120)) or tostring(src)

        warn("❌ Falha ao carregar módulo: " .. moduleName)    error("Falha ao compilar admin_core: " .. tostring(err) .. "\nPrévia do conteúdo obtido: " .. tostring(preview))

    endend

    

    return falselocal module = chunk()

endif type(module) == "table" and type(module.start) == "function" then

    module.start()

-- Função de limpezaelse

local function cleanup()    -- Caso o arquivo seja um script plano, apenas executa

    -- Desconectar todas as conexões    if type(module) == "function" then

    for name, connection in pairs(Admin.Connections) do        module()

        if connection and typeof(connection) == "RBXScriptConnection" then    end

            pcall(function() connection:Disconnect() end)end

        end
    end
    Admin.Connections = {}
    
    -- Restaurar valores originais
    for key, value in pairs(Admin.OriginalValues) do
        if key == "WalkSpeed" and Admin.Humanoid then
            Admin.Humanoid.WalkSpeed = value
        end
    end
    Admin.OriginalValues = {}
    
    -- Remover GUI
    if Admin.GUI.ScreenGui then
        Admin.GUI.ScreenGui:Destroy()
        Admin.GUI = {}
    end
    
    print("🧹 Sistema limpo!")
end

-- Comando de limpeza via chat
Admin.Connections.Chat = Player.Chatted:Connect(function(message)
    if message:lower() == "/cleanup" or message:lower() == "/limpar" then
        cleanup()
    end
end)

-- Conectar evento de respawn
Admin.Connections.CharacterAdded = Player.CharacterAdded:Connect(function()
    updateCharacter()
end)

-- Inicialização
updateCharacter()

-- Carregar módulo de movimento
loadModule("movement")

print("✅ Sistema base carregado! Digite /cleanup para limpar tudo.")