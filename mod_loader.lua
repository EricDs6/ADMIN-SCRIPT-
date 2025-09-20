-- Loader mínimo: carrega módulos remotos ou locais e inicia UI

local SOURCE = {
  core = "https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-RBX/main/modules/core.lua",
  ui   = "https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-RBX/main/modules/ui.lua",
  fly  = "https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-RBX/main/modules/fly.lua",
  noclip = "https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-RBX/main/modules/noclip.lua",
  speed = "https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-RBX/main/modules/speed.lua",
  teleport = "https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-RBX/main/modules/teleport.lua",
}

local function http_get(url)
  local bust = tostring(os.clock()):gsub("%.", "")
  local finalUrl = url .. "?t=" .. bust
  return game:HttpGet(finalUrl)
end

local function load_module(name)
  local url = SOURCE[name]
  print("[FK7] Carregando módulo:", name)
  if url and url ~= "" then
    local ok, src = pcall(http_get, url)
    if ok and src and src ~= "" then
      local chunk, err = loadstring(src)
      if chunk then
        local ok2, mod = pcall(chunk)
        if ok2 and mod then return mod end
        warn("[FK7] Erro executando módulo", name, mod)
      else
        warn("[FK7] Erro compilando módulo", name, err)
      end
    else
      warn("[FK7] Falha HttpGet módulo", name, src)
    end
  end
  -- fallback local
  local path = "modules/"..name..".lua"
  if readfile then
    local ok, src = pcall(readfile, path)
    if ok and src then
      local chunk, err = loadstring(src)
      if chunk then
        local ok2, mod = pcall(chunk)
        if ok2 and mod then return mod end
      end
    end
  end
  error("[FK7] Não foi possível carregar módulo: "..name)
end

local env = getgenv and getgenv() or _G
env.FK7 = env.FK7 or {}

local Core = load_module("core")
env.FK7.Core = Core

local UI = load_module("ui")
local Features = {
  fly = load_module("fly"),
  noclip = load_module("noclip"),
  speed = load_module("speed"),
  teleport = load_module("teleport"),
}

env.FK7.Features = Features

-- Setup dos módulos que precisam do Core
pcall(function()
    for _, feature in pairs(Features) do
        if feature.setup then
            feature.setup(Core)
        end
    end
end)

UI.init({ core = Core, features = Features })
print("[FK7] Loader pronto")
