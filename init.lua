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
local ADMIN_CORE_FALLBACK = "https://cdn.jsdelivr.net/gh/EricDs6/ADMIN-SCRIPT-RBX@main/src/admin_core.lua"

-- Verificar compilador disponível
local compile = loadstring or _G and _G.loadstring
if not compile then
    error("Seu executor não disponibiliza loadstring para compilar o módulo.")
end

-- Tentar carregar localmente primeiro (desenvolvimento), depois remoto
local src
if readfile then
    local ok, exists = pcall(function()
        return (isfile and isfile("src/admin_core.lua")) or (isfile and isfile("admin_core.lua"))
    end)
    if ok and exists then
        src = (isfile("src/admin_core.lua") and readfile("src/admin_core.lua")) or readfile("admin_core.lua")
    end
end
if not src then
    -- tentar primário
    src = httpGet(ADMIN_CORE_URL)
    -- se ainda assim vier JSON/HTML, tentar fallback
    if type(src) == "string" then
        local c = src:sub(1, 64)
        local looksLikeJson = c:sub(1,1) == "{" or c:find("\"message\"%s*:")
        local looksLikeHtml = c:find("<!DOCTYPE") or c:find("<html")
        if looksLikeJson or looksLikeHtml then
            src = httpGet(ADMIN_CORE_FALLBACK)
        end
    end
end

local chunk, err = compile(src)
if not chunk then
    local preview = (type(src) == "string" and src:sub(1, 120)) or tostring(src)
    error("Falha ao compilar admin_core: " .. tostring(err) .. "\nPrévia do conteúdo obtido: " .. tostring(preview))
end

local module = chunk()
if type(module) == "table" and type(module.start) == "function" then
    module.start()
else
    -- Caso o arquivo seja um script plano, apenas executa
    if type(module) == "function" then
        module()
    end
end
