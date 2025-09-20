-- Loader modular para Fita-K7 Admin
-- Use URLs (Raw GitHub) ou carregamento local de modules/*.lua
-- Exemplo de uso: execute este arquivo no executor; ele carrega todos os módulos e inicia a UI

-- Config: defina onde buscar os módulos (urls) ou deixe vazio para usar local
local SOURCE = {
  core = "https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-RBX/main/modules/core.lua",
  ui = "https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-RBX/main/modules/ui.lua",
  fly = "https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-RBX/main/modules/fly.lua",
  teleport = "https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-RBX/main/modules/teleport.lua",
  player = "https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-RBX/main/modules/player.lua",
  world = "https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-RBX/main/modules/world.lua",
  stick = "https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-RBX/main/modules/stick.lua",
}

local function load_module(name)
  local url = SOURCE[name]
  print("[FK7] Iniciando carregamento do módulo:", name)

  if url and typeof(url) == "string" and url ~= "" then
    -- Cache-busting para evitar CDN servir conteúdo antigo
    local bust = tostring(os.clock()):gsub("%.", "")
    local finalUrl = url .. "?t=" .. bust
    print("[FK7] Tentando URL:", finalUrl)
    local success, src = pcall(function()
      return game:HttpGet(finalUrl)
    end)

    if success then
      print("[FK7] HttpGet bem-sucedido para", name, "- Tamanho:", #src)
      if src and src ~= "" then
        print("[FK7] Conteúdo obtido, compilando...")
        local chunk, compileErr = loadstring(src)
        if not chunk then
          warn("[FK7] ERRO ao compilar módulo:", name, "- ", tostring(compileErr))
          warn("[FK7] Conteúdo do arquivo (primeiras 200 chars):", src:sub(1, 200))
        else
          print("[FK7] Compilação OK, executando chunk...")
          local ok, mod = pcall(chunk)
          if ok and mod then
            print("[FK7] Módulo carregado com sucesso:", name)
            return mod
          else
            warn("[FK7] ERRO ao executar módulo:", name, "- ", tostring(mod))
          end
        end
      else
        warn("[FK7] Conteúdo vazio retornado para", name)
      end
    else
      warn("[FK7] Falha no HttpGet para", name, "- Erro:", tostring(src))
    end
  else
    print("[FK7] URL inválida ou vazia para", name)
  end

  -- fallback: carregar localmente da pasta modules
  print("[FK7] Tentando carregar módulo local:", name)
  local success, result = pcall(function()
    local src = readfile and readfile("modules/"..name..".lua")
    if not src then
      error("Arquivo local ausente: modules/"..name..".lua")
    end
    print("[FK7] Arquivo local encontrado, executando loadstring...")
    return loadstring(src)()
  end)
  if success then
    print("[FK7] Módulo local carregado:", name)
    return result
  end
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
