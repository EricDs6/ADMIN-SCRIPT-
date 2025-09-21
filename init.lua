-- Loader do Admin Script via loadstring
-- Suporta diferentes executores: Synapse, KRNL, Script-Ware, etc.

local function httpGet(url)
    -- Tenta usar APIs comuns dos executores
    local ok, res
    if syn and syn.request then
        ok, res = pcall(syn.request, {Url = url, Method = "GET"})
        if ok and res and res.Success and res.Body then return res.Body end
    end
    if http and http.request then
        ok, res = pcall(http.request, {Url = url, Method = "GET"})
        if ok and res and res.Body then return res.Body end
    end
    if http_request then
        ok, res = pcall(http_request, {Url = url, Method = "GET"})
        if ok and res and (res.Body or res.body) then return res.Body or res.body end
    end
    if request then
        ok, res = pcall(request, {Url = url, Method = "GET"})
        if ok and res and (res.Body or res.body) then return res.Body or res.body end
    end
    if game and game.HttpGet then
        ok, res = pcall(function() return game:HttpGet(url) end)
        if ok and res then return res end
    end
    error("Nenhuma API HTTP suportada encontrada para buscar: " .. url)
end

-- URL bruto do módulo principal (ajuste para o seu repositório público)
-- Dica: hospede o conteúdo de src/admin_core.lua e substitua a URL abaixo
local ADMIN_CORE_URL = "https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-RBX/main/src/admin_core.lua"

local src = httpGet(ADMIN_CORE_URL)

-- Verificar compilador disponível
local compile = loadstring or _G and _G.loadstring
if not compile then
    error("Seu executor não disponibiliza loadstring para compilar o módulo.")
end

local chunk, err = compile(src)
if not chunk then error("Falha ao compilar admin_core: " .. tostring(err)) end

local module = chunk()
if type(module) == "table" and type(module.start) == "function" then
    module.start()
else
    -- Caso o arquivo seja um script plano, apenas executa
    if type(module) == "function" then
        module()
    end
end
