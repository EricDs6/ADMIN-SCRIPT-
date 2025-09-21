--[[-- Admin Script Modular - Loader Principal v2.0

    Admin Script Modular v2.0-- Execução: loadstring(game:HttpGet("https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-/main/init.lua"))()

    Criado por: EricDs6

    Atualizado em: 21/09/2025print("🚀 Carregando Admin Script Modular v2.0...")

    

    Este script utiliza uma estrutura modular, com cada função separada em seu próprio arquivo-- Inicializar AdminScript para evitar erros de referência nil

    para facilitar manutenção e personalização. O carregamento de módulos é feito automaticamenteif not _G.AdminScript then

    conforme a configuração.    _G.AdminScript = {

            -- Informações da versão

    Instruções:        version = "2.0",

    - Carregue com: loadstring(game:HttpGet("https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-/main/init.lua"))()        lastUpdate = "2025-09-21",

    - Use o comando /admin no chat para abrir a GUI        

    - Use /cleanup para limpar todas as alterações feitas pelo script        -- Serviços

]]        Services = {

            Players = game:GetService("Players"),

-- Iniciar com mensagem de carregamento            UserInputService = game:GetService("UserInputService"),

print("🚀 Carregando Admin Script Modular v2.0...")            RunService = game:GetService("RunService"),

            TweenService = game:GetService("TweenService")

-- Inicializar estrutura global        },

if _G.AdminScript then        

    print("⚠️ Admin Script já está carregado! Limpando instalação anterior...")        -- Player info

    -- Tentar limpar instalação anterior se existir função de limpeza        Player = game:GetService("Players").LocalPlayer,

    if _G.AdminScript.cleanup then        

        _G.AdminScript.cleanup()        -- Estado global

    end        Connections = {},

end        OriginalValues = {},

        

-- Criar o objeto global do Admin Script        -- Módulos carregados

_G.AdminScript = {        LoadedModules = {},

    -- Informações da versão        

    version = "2.0",        -- Estruturas de módulos

    lastUpdate = "2025-09-21",        Movement = {},

            GUI = {},

    -- Serviços Roblox        Commands = {},

    Services = {        Teleport = {},

        Players = game:GetService("Players"),        Tools = {},

        UserInputService = game:GetService("UserInputService"),        Character = {},

        RunService = game:GetService("RunService"),        Server = {},

        TweenService = game:GetService("TweenService"),        Game = {},

        ReplicatedStorage = game:GetService("ReplicatedStorage"),        

        HttpService = game:GetService("HttpService"),        -- Configuração

        Lighting = game:GetService("Lighting"),        Config = {}

        Workspace = game:GetService("Workspace")    }

    },end

    

    -- Referências ao jogador-- Função para detectar loadstring disponível

    Player = game:GetService("Players").LocalPlayer,local function getLoadstring()

    Character = nil, -- Será atualizado    return loadstring or 

    Humanoid = nil, -- Será atualizado           (getgenv and getgenv().loadstring) or 

    HumanoidRootPart = nil, -- Será atualizado           (syn and syn.loadstring) or 

               (_G and _G.loadstring) or

    -- Controle de estado           (getfenv and getfenv().loadstring)

    Connections = {},end

    OriginalValues = {},

    LoadedModules = {},-- Função para carregar módulos via HTTP com múltiplas APIs

    local function httpGet(url)

    -- Categorias de módulos (serão preenchidas durante o carregamento)    local ok, res

    Movement = {},    

    GUI = {},    -- Tentar syn.request (Synapse X)

    Teleport = {},    if syn and syn.request then

    Character = {},        ok, res = pcall(syn.request, {Url = url, Method = "GET"})

    Utility = {},        if ok and res and res.Success and res.Body then return res.Body end

        end

    -- Configuração    

    Config = {    -- Tentar http.request (Script-Ware)

        debugMode = true,    if http and http.request then

        autoLoadGUI = true,        ok, res = pcall(http.request, {Url = url, Method = "GET"})

        defaultFlySpeed = 50,        if ok and res and res.Body then return res.Body end

        chatCommands = true,    end

        disableOnDeath = true    

    }    -- Tentar http_request (KRNL)

}    if http_request then

        ok, res = pcall(http_request, {Url = url, Method = "GET"})

-- Alias para facilitar referências        if ok and res and (res.Body or res.body) then return res.Body or res.body end

local Admin = _G.AdminScript    end

local Player = Admin.Player    

local Services = Admin.Services    -- Tentar request (genérico)

    if request then

-- Atualizar referências do personagem        ok, res = pcall(request, {Url = url, Method = "GET"})

local function updateCharacterReferences()        if ok and res and (res.Body or res.body) then return res.Body or res.body end

    Admin.Character = Player.Character    end

    if Admin.Character then    

        Admin.Humanoid = Admin.Character:FindFirstChildOfClass("Humanoid")    -- Fallback para game:HttpGet (menos confiável)

        Admin.HumanoidRootPart = Admin.Character:FindFirstChild("HumanoidRootPart")    if game and game.HttpGet then

        return true        ok, res = pcall(function() return game:HttpGet(url) end)

    end        if ok and res then return res end

    return false    end

end    

    return nil

-- Inicializar referências do personagemend

updateCharacterReferences()

-- Configuração base no _G

-- Monitorar mudanças do personagemif not _G.AdminScript then

Player.CharacterAdded:Connect(function(character)    _G.AdminScript = {

    wait(0.5) -- Pequeno atraso para garantir que todos os componentes estejam carregados        -- Informações da versão

    updateCharacterReferences()        version = "2.0",

            lastUpdate = "2025-09-21",

    -- Notificar módulos sobre mudança de personagem        

    if Admin.onCharacterChanged then        -- Serviços

        Admin.onCharacterChanged(character)        Services = {

    end            Players = game:GetService("Players"),

end)            UserInputService = game:GetService("UserInputService"),

            RunService = game:GetService("RunService"),

-- Função para detectar loadstring disponível (compatível com múltiplos executores)            TweenService = game:GetService("TweenService")

local function getLoadstring()        },

    return loadstring or         

           (getgenv and getgenv().loadstring) or         -- Player info

           (syn and syn.loadstring) or         Player = game:GetService("Players").LocalPlayer,

           (_G and _G.loadstring) or        

           (getfenv and getfenv().loadstring)        -- Estado global

end        Connections = {},

        OriginalValues = {},

-- Função para carregar módulos via HTTP com múltiplas APIs        

local function httpGet(url)        -- Módulos carregados

    local ok, res        LoadedModules = {},

            

    -- Tentar syn.request (Synapse X)        -- GUI elementos

    if syn and syn.request then        GUI = {},

        ok, res = pcall(syn.request, {Url = url, Method = "GET"})        

        if ok and res and res.Success and res.Body then return res.Body end        -- Estados dos módulos

    end        Movement = {},

            

    -- Tentar http.request (Script-Ware)        -- Configuração

    if http and http.request then        Config = {}

        ok, res = pcall(http.request, {Url = url, Method = "GET"})    }

        if ok and res and res.Body then return res.Body endend

    end

    local Admin = _G.AdminScript

    -- Tentar http_request (KRNL)local Player = Admin.Player

    if http_request thenlocal Services = Admin.Services

        ok, res = pcall(http_request, {Url = url, Method = "GET"})

        if ok and res and (res.Body or res.body) then return res.Body or res.body end-- Atualizar referências do personagem

    endlocal function updateCharacter()

        Admin.Character = Player.Character or Player.CharacterAdded:Wait()

    -- Tentar request (genérico)    Admin.Humanoid = Admin.Character:WaitForChild("Humanoid")

    if request then    Admin.HumanoidRootPart = Admin.Character:WaitForChild("HumanoidRootPart")

        ok, res = pcall(request, {Url = url, Method = "GET"})end

        if ok and res and (res.Body or res.body) then return res.Body or res.body end

    end-- Função para carregar configuração

    local function loadConfig()

    -- Fallback para game:HttpGet (menos confiável em jogos com HTTP desabilitado)    local baseURL = "https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-/main/"

    if game and game.HttpGet then    local url = baseURL .. "config.lua"

        ok, res = pcall(function() return game:HttpGet(url) end)    

        if ok and res then return res end    print("⚙️ Baixando configuração...")

    end    local result = httpGet(url)

        if not result then

    return nil        warn("❌ Falha ao carregar configuração! Usando configuração padrão...")

end        return {

            settings = {

-- Função para dividir string (implementação de string.split)                autoLoadGUI = true,

local function splitString(str, delimiter)                showLoadMessages = true

    if not str or not delimiter then return {} end            },

                movement = {

    local result = {}                enabled = true,

    local pattern = "[^" .. delimiter .. "]+"                modules = {

    for match in string.gmatch(str, pattern) do                    fly = { enabled = true, path = "modules/movement/fly.lua" },

        table.insert(result, match)                    noclip = { enabled = true, path = "modules/movement/noclip.lua" }

    end                }

    return result            },

end            gui = {

                enabled = true,

-- Função para carregar um módulo específico                modules = {

local function loadModule(modulePath, moduleName)                    main = { enabled = true, path = "modules/gui/main.lua" }

    local baseURL = "https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-/main/"                }

    local url = baseURL .. modulePath            },

                loadOrder = {"movement.fly", "movement.noclip", "gui.main"}

    if Admin.Config.debugMode then        }

        print("📦 Carregando módulo: " .. moduleName)    end

    end    

        local compile = getLoadstring()

    -- Obter loadstring compatível    if not compile then

    local compile = getLoadstring()        warn("❌ Não foi possível compilar configuração! Usando padrão...")

    if not compile then        return {

        warn("❌ Nenhuma função loadstring disponível no executor!")            movement = {

        return false                enabled = true,

    end                modules = {

                        fly = { enabled = true, path = "modules/movement/fly.lua" },

    -- Baixar código do módulo                    noclip = { enabled = true, path = "modules/movement/noclip.lua" }

    local result = httpGet(url)                }

    if not result then            },

        warn("❌ Falha ao baixar módulo: " .. moduleName)            gui = {

        return false                enabled = true,

    end                modules = {

                        main = { enabled = true, path = "modules/gui/main.lua" }

    -- Preparar categoria para receber o módulo                }

    local parts = splitString(moduleName, ".")            },

    if #parts == 2 then            loadOrder = {"movement.fly", "movement.noclip", "gui.main"}

        local category = parts[1]        }

        local modName = parts[2]    end

            

        -- Garantir que a categoria exista    local success, configFunction = pcall(compile, result)

        if not Admin[category] then    if success and configFunction then

            Admin[category] = {}        local execSuccess, config = pcall(configFunction)

        end        if execSuccess and config then

    end            print("✅ Configuração carregada!")

                return config

    -- Adicionar proteção no início do código        end

    local protectedCode = [[    end

    -- Proteção contra erros de referência nil    

    if not _G.AdminScript then    warn("❌ Erro ao executar configuração! Usando padrão...")

        warn("❌ AdminScript não inicializado! Isso é um erro crítico.")    return {

        return        movement = {

    end            enabled = true,

                modules = {

    -- Garantir que categorias existam                fly = { enabled = true, path = "modules/movement/fly.lua" },

    if not _G.AdminScript.Movement then _G.AdminScript.Movement = {} end                noclip = { enabled = true, path = "modules/movement/noclip.lua" }

    if not _G.AdminScript.GUI then _G.AdminScript.GUI = {} end            }

    if not _G.AdminScript.Teleport then _G.AdminScript.Teleport = {} end        },

    if not _G.AdminScript.Character then _G.AdminScript.Character = {} end        gui = {

    if not _G.AdminScript.Utility then _G.AdminScript.Utility = {} end            enabled = true,

                modules = {

    ]] .. result                main = { enabled = true, path = "modules/gui/main.lua" }

                }

    -- Compilar e executar com proteção de erros        },

    local success, moduleFunction = pcall(compile, protectedCode)        loadOrder = {"movement.fly", "movement.noclip", "gui.main"}

    if success and moduleFunction then    }

        local execSuccess, moduleReturn = pcall(moduleFunction)end

        if execSuccess then

            Admin.LoadedModules[moduleName] = {-- Garantir que a estrutura de Admin.Movement exista

                path = modulePath,Admin.Movement = Admin.Movement or {}

                loaded = true,

                loadTime = tick(),-- Função para carregar um módulo específico

                returnValue = moduleReturnlocal function loadModule(modulePath, moduleName)

            }    local baseURL = "https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-/main/"

                local url = baseURL .. modulePath

            if Admin.Config.debugMode then    

                print("✅ Módulo " .. moduleName .. " carregado com sucesso!")    print("📦 Carregando módulo: " .. moduleName)

            end    

            return true    -- Preparar a estrutura necessária antes de carregar o módulo

        else    local parts = splitString(moduleName, ".")

            warn("❌ Erro ao executar módulo " .. moduleName .. ":")    if #parts == 2 then

            warn(tostring(moduleReturn))        local category = parts[1]

        end        local modName = parts[2]

    else        

        warn("❌ Erro ao compilar módulo " .. moduleName .. ":")        -- Criar categoria se não existir

        warn(tostring(moduleFunction))        if not Admin[category] then

    end            Admin[category] = {}

            end

    return false    end

end    

    -- Obter loadstring compatível

-- Configuração dos módulos a carregar    local compile = getLoadstring()

local moduleConfig = {    if not compile then

    -- Ordem de carregamento (importante para dependências)        warn("❌ Nenhuma função loadstring disponível no executor!")

    loadOrder = {        return false

        "Movement.fly",    end

        "Movement.noclip",    

        "Movement.speed",    -- Baixar código do módulo

        "Character.godmode",     local result = httpGet(url)

        "Teleport.locations",    if not result then

        "GUI.main"        warn("❌ Falha ao baixar módulo: " .. moduleName)

    },        return false

        end

    -- Configuração da categoria Movement    

    Movement = {    -- Adicionar proteção no início do código

        enabled = true,    local protectedCode = [[

        modules = {    -- Proteção contra erros de referência nil

            fly = {    if not _G.AdminScript then

                enabled = true,        _G.AdminScript = {

                path = "modules/movement/fly.lua"            Movement = {},

            },            GUI = {},

            noclip = {            Services = {

                enabled = true,                Players = game:GetService("Players"),

                path = "modules/movement/noclip.lua"                UserInputService = game:GetService("UserInputService"),

            },                RunService = game:GetService("RunService"),

            speed = {                TweenService = game:GetService("TweenService")

                enabled = true,            },

                path = "modules/movement/speed.lua"            Player = game:GetService("Players").LocalPlayer,

            }            Connections = {},

        }            OriginalValues = {}

    },        }

        end

    -- Configuração da categoria Character    

    Character = {    if not _G.AdminScript.Movement then _G.AdminScript.Movement = {} end

        enabled = true,    if not _G.AdminScript.GUI then _G.AdminScript.GUI = {} end

        modules = {    if not _G.AdminScript.Connections then _G.AdminScript.Connections = {} end

            godmode = {    if not _G.AdminScript.OriginalValues then _G.AdminScript.OriginalValues = {} end

                enabled = true,    

                path = "modules/character/godmode.lua"    ]] .. result

            }    

        }    -- Compilar e executar

    },    local success, moduleFunction = pcall(compile, protectedCode)

        if success and moduleFunction then

    -- Configuração da categoria Teleport        local execSuccess, execError = pcall(moduleFunction)

    Teleport = {        if execSuccess then

        enabled = true,            Admin.LoadedModules[moduleName] = {

        modules = {                path = modulePath,

            locations = {                loaded = true,

                enabled = true,                loadTime = tick()

                path = "modules/teleport/locations.lua"            }

            }            print("✅ Módulo " .. moduleName .. " carregado!")

        }            return true

    },        else

                warn("❌ Erro ao executar módulo " .. moduleName .. ": " .. tostring(execError))

    -- Configuração da categoria GUI        end

    GUI = {    else

        enabled = true,        warn("❌ Falha ao compilar módulo " .. moduleName .. ": " .. tostring(moduleFunction))

        modules = {    end

            main = {    

                enabled = true,    return false

                path = "modules/gui/main.lua"end

            }

        }-- Função auxiliar para split de string

    }local function splitString(str, delimiter)

}    local result = {}

    local pattern = "[^" .. delimiter .. "]+"

-- Função para carregar todos os módulos conforme configuração    for match in string.gmatch(str, pattern) do

local function loadAllModules()        table.insert(result, match)

    print("🔄 Carregando módulos conforme configuração...")    end

        return result

    -- Garantir que categorias existam antes de carregar módulosend

    Admin.Movement = Admin.Movement or {}

    Admin.GUI = Admin.GUI or {}-- Inicializar categorias antes de carregar módulos

    Admin.Teleport = Admin.Teleport or {}local function initializeCategories()

    Admin.Character = Admin.Character or {}    print("🏗️ Inicializando estrutura de categorias...")

    Admin.Utility = Admin.Utility or {}    

        -- Categorias principais

    local loadedCount = 0    Admin.Movement = Admin.Movement or {}

    local failedCount = 0    Admin.GUI = Admin.GUI or {}

        Admin.Commands = Admin.Commands or {}

    for _, moduleKey in ipairs(moduleConfig.loadOrder) do    Admin.Teleport = Admin.Teleport or {}

        local parts = splitString(moduleKey, ".")    Admin.Tools = Admin.Tools or {}

        if #parts == 2 then    Admin.Character = Admin.Character or {}

            local category = parts[1]    Admin.Server = Admin.Server or {}

            local moduleName = parts[2]    Admin.Game = Admin.Game or {}

                

            -- Verificar se a categoria está habilitada    -- Logs

            local categoryConfig = moduleConfig[category]    print("✅ Estrutura de categorias inicializada")

            if categoryConfig and categoryConfig.enabled and categoryConfig.modules thenend

                -- Verificar se o módulo está habilitado

                local moduleConfig = categoryConfig.modules[moduleName]-- Função para carregar módulos baseado na configuração

                if moduleConfig and moduleConfig.enabled and moduleConfig.path thenlocal function loadModules(config)

                    -- Carregar o módulo    if not config or not config.loadOrder then

                    if loadModule(moduleConfig.path, moduleKey) then        warn("❌ Configuração inválida!")

                        loadedCount = loadedCount + 1        return

                    else    end

                        failedCount = failedCount + 1    

                    end    -- Inicializar categorias primeiro

                    wait(0.1) -- Pequena pausa entre carregamentos para evitar erros    initializeCategories()

                else    

                    if Admin.Config.debugMode then    print("🔄 Carregando módulos conforme configuração...")

                        print("⚠️ Módulo " .. moduleKey .. " desabilitado ou não configurado")    

                    end    for _, moduleKey in ipairs(config.loadOrder) do

                end        local parts = splitString(moduleKey, ".")

            else        if #parts == 2 then

                if Admin.Config.debugMode then            local category = parts[1]

                    print("⚠️ Categoria " .. category .. " desabilitada ou não configurada")            local moduleName = parts[2]

                end            

            end            -- Garantir que a categoria exista

        end            if not Admin[category] then

    end                Admin[category] = {}

                    print("📁 Criando categoria: " .. category)

    print("📊 Módulos carregados: " .. loadedCount .. " | Falhas: " .. failedCount)            end

    return loadedCount > 0            

end            local categoryConfig = config[category]

            if categoryConfig and categoryConfig.enabled and categoryConfig.modules then

-- Função de limpeza para remover todas as alterações feitas pelo script                local moduleConfig = categoryConfig.modules[moduleName]

function Admin.cleanup()                if moduleConfig and moduleConfig.enabled and moduleConfig.path then

    print("🧹 Limpando Admin Script...")                    loadModule(moduleConfig.path, moduleKey)

                        wait(0.1) -- Pequena pausa entre carregamentos

    -- Desconectar todas as conexões                else

    for name, connection in pairs(Admin.Connections) do                    print("⚠️ Módulo " .. moduleKey .. " desabilitado ou não configurado")

        if typeof(connection) == "RBXScriptConnection" and connection.Connected then                end

            connection:Disconnect()            else

        elseif typeof(connection) == "table" then                print("⚠️ Categoria " .. category .. " desabilitada ou não configurada")

            if connection.disconnect then            end

                connection:disconnect()        else

            elseif connection.Disconnect then            warn("❌ Formato de módulo inválido: " .. moduleKey)

                connection:Disconnect()        end

            end    end

        endend

    end

    -- Função de limpeza melhorada

    -- Restaurar valores originaislocal function cleanup()

    for objName, originalValues in pairs(Admin.OriginalValues) do    print("🧹 Iniciando limpeza do sistema...")

        for propName, value in pairs(originalValues) do    

            pcall(function()    -- Desconectar todas as conexões

                local obj = Admin[objName]    local connectionCount = 0

                if obj then    for name, connection in pairs(Admin.Connections) do

                    obj[propName] = value        if connection then

                end            if typeof(connection) == "RBXScriptConnection" then

            end)                pcall(function() connection:Disconnect() end)

        end                connectionCount = connectionCount + 1

    end            elseif type(connection) == "table" and connection.connection then

                    -- Para módulos que armazenam conexões em tabelas

    -- Limpar GUI se existir                pcall(function() connection.connection:Disconnect() end)

    if Admin.GUI and Admin.GUI.main and Admin.GUI.main.cleanup then                connectionCount = connectionCount + 1

        Admin.GUI.main.cleanup()            end

    end        end

        end

    -- Desativar funcionalidades ativas    Admin.Connections = {}

    if Admin.Movement then    

        if Admin.Movement.fly and Admin.Movement.fly.disable then    -- Limpar objetos de física dos módulos

            Admin.Movement.fly.disable()    if Admin.Movement then

        end        for moduleName, moduleData in pairs(Admin.Movement) do

        if Admin.Movement.noclip and Admin.Movement.noclip.disable then            if type(moduleData) == "table" then

            Admin.Movement.noclip.disable()                -- Limpar BodyVelocity e BodyGyro se existirem

        end                for _, objName in pairs({"BodyVelocity", "BodyGyro", "bodyVelocity", "bodyGyro"}) do

        if Admin.Movement.speed and Admin.Movement.speed.reset then                    if moduleData[objName] then

            Admin.Movement.speed.reset()                        pcall(function() moduleData[objName]:Destroy() end)

        end                        moduleData[objName] = nil

    end                    end

                    end

    -- Limpar referências            end

    _G.AdminScript = nil        end

        end

    print("✅ Admin Script limpo com sucesso!")    

end    -- Restaurar valores originais

    if Admin.Humanoid and Admin.OriginalValues then

-- Processador de comandos do chat        local restoredCount = 0

local function setupChatCommands()        

    local connection = Services.Players.LocalPlayer.Chatted:Connect(function(message)        if Admin.OriginalValues.PlatformStand ~= nil then

        message = message:lower()            Admin.Humanoid.PlatformStand = Admin.OriginalValues.PlatformStand

                    restoredCount = restoredCount + 1

        if message == "/admin" then        end

            if Admin.GUI and Admin.GUI.main and Admin.GUI.main.toggle then        

                Admin.GUI.main.toggle()        if Admin.OriginalValues.WalkSpeed then

            end            Admin.Humanoid.WalkSpeed = Admin.OriginalValues.WalkSpeed

        elseif message == "/cleanup" or message == "/limpar" or message == "/clear" then            restoredCount = restoredCount + 1

            Admin.cleanup()        end

        elseif message == "/fly" then        

            if Admin.Movement and Admin.Movement.fly and Admin.Movement.fly.toggle then        print("🔄 " .. restoredCount .. " valores originais restaurados")

                Admin.Movement.fly.toggle()    end

            end    

        elseif message == "/noclip" then    Admin.OriginalValues = {}

            if Admin.Movement and Admin.Movement.noclip and Admin.Movement.noclip.toggle then    

                Admin.Movement.noclip.toggle()    -- Restaurar colisão das partes do character

            end    if Admin.Character then

        elseif message == "/god" or message == "/godmode" then        local partCount = 0

            if Admin.Character and Admin.Character.godmode and Admin.Character.godmode.toggle then        for _, part in pairs(Admin.Character:GetChildren()) do

                Admin.Character.godmode.toggle()            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then

            end                part.CanCollide = true

        end                partCount = partCount + 1

    end)            end

            end

    Admin.Connections.ChatCommands = connection        print("🔄 " .. partCount .. " partes restauradas")

end    end

    

-- Função para iniciar o Admin Script    -- Remover GUI

local function startAdminScript()    if Admin.GUI and Admin.GUI.Module and Admin.GUI.Module.ScreenGui then

    -- Carregar todos os módulos        local screenGui = Admin.GUI.Module.ScreenGui()

    local success = loadAllModules()        if screenGui then

    if not success then            screenGui:Destroy()

        warn("❌ Falha ao carregar módulos!")        end

        return    end

    end    Admin.GUI = {}

        

    -- Configurar comandos do chat se habilitados    -- Resetar estados dos módulos

    if Admin.Config.chatCommands then    Admin.Movement = {}

        setupChatCommands()    Admin.LoadedModules = {}

    end    

        print("✅ Sistema completamente limpo!")

    -- Carregar GUI automaticamente se configurado    print("🔌 " .. connectionCount .. " conexões desconectadas")

    if Admin.Config.autoLoadGUI and Admin.GUI and Admin.GUI.main and Admin.GUI.main.show then    print("🛡️ Todos os valores foram restaurados!")

        wait(0.5) -- Pequeno atraso para garantir que tudo esteja carregadoend

        Admin.GUI.main.show()

    end-- Tornar cleanup acessível globalmente

    _G.AdminScript.Cleanup = cleanup

    print("✅ Admin Script v" .. Admin.version .. " carregado completamente!")

    print("🎮 Use /admin para abrir a GUI ou /cleanup para limpar")-- Comando de limpeza via chat

endAdmin.Connections.Chat = Player.Chatted:Connect(function(message)

    local lowerMessage = message:lower()

-- Iniciar o Admin Script    for _, command in pairs({"/cleanup", "/limpar", "/clear"}) do

startAdminScript()        if lowerMessage == command then
            cleanup()
            break
        end
    end
end)

-- Conectar evento de respawn
Admin.Connections.CharacterAdded = Player.CharacterAdded:Connect(function()
    updateCharacter()
end)

-- Inicialização
updateCharacter()

-- Carregar configuração e módulos
print("⚙️ Carregando configuração...")
local config = loadConfig()
Admin.Config = config

-- Verificar se a configuração foi carregada corretamente
if not config or not config.loadOrder then
    warn("❌ Configuração inválida! Tentando carregar módulos individualmente...")
    -- Carregar módulos básicos diretamente
    local success1 = loadModule("modules/movement/fly.lua", "movement.fly")
    local success2 = loadModule("modules/movement/noclip.lua", "movement.noclip")
    local success3 = loadModule("modules/gui/main.lua", "gui.main")
    
    if success3 then
        wait(0.2)
        pcall(function()
            if Admin.GUI and Admin.GUI.Module then
                Admin.GUI.Module.create()
            end
        end)
    end
else
    if config.settings and config.settings.showLoadMessages then
        print("📋 Configuração:")
        print("   - Módulos de movimento: " .. (config.movement and config.movement.enabled and "✅" or "❌"))
        print("   - Módulos de GUI: " .. (config.gui and config.gui.enabled and "✅" or "❌"))
        print("   - Total de módulos: " .. (config.loadOrder and #config.loadOrder or 0))
    end

    -- Carregar módulos
    loadModules(config)

    -- Criar GUI se habilitado
    if config.gui and config.gui.enabled and config.settings and config.settings.autoLoadGUI then
        wait(0.2) -- Aguardar carregamento dos módulos
        local success, error = pcall(function()
            if Admin.GUI and Admin.GUI.Module then
                Admin.GUI.Module.create()
            end
        end)
        if not success then
            warn("❌ Erro ao criar GUI: " .. tostring(error))
        end
    end
end

-- Verificar se todos os módulos foram carregados corretamente
local function verificarModulos()
    print("🔍 Verificando módulos carregados...")
    
    -- Verificar categorias principais
    if not Admin.Movement then 
        print("⚠️ Categoria Movement não inicializada! Criando...")
        Admin.Movement = {}
    end
    
    if not Admin.GUI then
        print("⚠️ Categoria GUI não inicializada! Criando...")
        Admin.GUI = {}
    end
    
    -- Exportar módulos para _G para acesso global
    _G.AdminScript = Admin
    
    -- Verificar módulos específicos que costumam dar problemas
    if Admin.LoadedModules["movement.noclip"] and not Admin.Movement.noclip then
        print("🔄 Corrigindo referência: movement.noclip")
        -- Tentar reatribuir do módulo
        if NoclipModule then
            Admin.Movement.noclip = NoclipModule
        else
            Admin.Movement.noclip = {
                enabled = false,
                toggle = function() print("⚠️ Função noclip reconstruída") end
            }
        end
    end
    
    if Admin.LoadedModules["movement.fly"] and not Admin.Movement.fly then
        print("🔄 Corrigindo referência: movement.fly")
        -- Tentar reatribuir do módulo
        if FlyModule then
            Admin.Movement.fly = FlyModule
        else
            Admin.Movement.fly = {
                enabled = false,
                toggle = function() print("⚠️ Função fly reconstruída") end
            }
        end
    end
    
    print("✅ Verificação de módulos concluída")
end

-- Chamar verificação de módulos
verificarModulos()

print("✅ Admin Script v" .. Admin.version .. " carregado completamente!")
print("🎮 Use a GUI ou comandos de chat para controlar")
print("🧹 Digite /cleanup, /limpar ou /clear para limpar tudo")