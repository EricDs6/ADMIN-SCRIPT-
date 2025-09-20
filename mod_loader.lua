-- Loader modular para Fita-K7 Admin
-- Use URLs (Raw GitHub) ou carregamento local de modules/*.lua
-- Exemplo de uso: execute este arquivo no executor; ele carrega todos os módulos e inicia a UI

-- Config: defina onde buscar os módulos (urls) ou deixe vazio para usar local
local SOURCE = {
  core = "https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-RBX/refs/heads/main/modules/core.lua",
  ui = "https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-RBX/refs/heads/main/modules/ui.lua",
  fly = "https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-RBX/refs/heads/main/modules/fly.lua",
  teleport = "https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-RBX/refs/heads/main/modules/teleport.lua",
  player = "https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-RBX/refs/heads/main/modules/player.lua",
  world = "https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-RBX/refs/heads/main/modules/world.lua",
  stick = "https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-RBX/refs/heads/main/modules/stick.lua",
}

local function normalize_url(url)
  -- Converte /refs/heads/<branch>/ em /<branch>/ para raw.githubusercontent.com
  return (url:gsub("/refs/heads/([^/]+)/", "/%1/"))
end

local function http_get(url)
  local u = normalize_url(url)
  return game:HttpGet(u)
end

local function load_module(name)
  local url = SOURCE[name]
  local ok, mod
  if url and typeof(url) == "string" and url ~= "" then
    local src = http_get(url)
    ok, mod = pcall(function()
      return loadstring(src)()
    end)
    if ok and mod then return mod end
    warn("Falha ao carregar módulo por URL:", name, mod)
  end
  -- fallback: carregar localmente da pasta modules
  local success, result = pcall(function()
    local src = readfile and readfile("modules/"..name..".lua")
    if not src then error("Arquivo local ausente: modules/"..name..".lua") end
    return loadstring(src)()
  end)
  if success then return result end
  error("Não foi possível carregar módulo: "..name.." - "..tostring(result))
end

-- Ambiente compartilhado entre módulos
local env = getgenv and getgenv() or _G
env.FK7 = env.FK7 or {}

-- Carregar módulos-base primeiro
local Core = load_module("core")

-- Registrar Core no ambiente ANTES de carregar a UI (UI pode depender de FK7.Core)
env.FK7.Core = Core

-- Agora carregar a UI
local UI = load_module("ui")

-- Carregar módulos de features
local Features = {
  fly = load_module("fly"),
  teleport = load_module("teleport"),
  player = load_module("player"),
  world = load_module("world"),
  stick = load_module("stick"),
}

-- Registrar features
env.FK7.Features = Features

-- Inicializar UI com registro de comandos
UI.init({
  core = Core,
  features = Features,
})

print("[FK7] Loader concluído. UI iniciada.")
