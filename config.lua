-- Configuração de Módulos
-- Define quais módulos devem ser carregados e suas configurações

return {
    -- Configurações gerais
    settings = {
        autoLoadGUI = true,
        showLoadMessages = true,
        enableCleanupCommand = true,
        cleanupCommands = {"/cleanup", "/limpar", "/clear"}
    },
    
    -- Módulos de movimento
    movement = {
        enabled = true,
        modules = {
            fly = {
                enabled = true,
                path = "modules/movement/fly.lua",
                config = {
                    defaultSpeed = 50,
                    maxSpeed = 200
                }
            },
            noclip = {
                enabled = true,
                path = "modules/movement/noclip.lua",
                config = {}
            }
        }
    },
    
    -- Módulos de GUI
    gui = {
        enabled = true,
        modules = {
            main = {
                enabled = true,
                path = "modules/gui/main.lua",
                config = {
                    position = {x = 20, y = 0.5},
                    size = {width = 280, height = 200}
                }
            }
        }
    },
    
    -- Módulos de utilidades (para futuras expansões)
    utils = {
        enabled = false,
        modules = {
            -- teleport = {
            --     enabled = false,
            --     path = "modules/utils/teleport.lua"
            -- },
            -- speed = {
            --     enabled = false,
            --     path = "modules/utils/speed.lua"
            -- }
        }
    },
    
    -- Ordem de carregamento (importante para dependências)
    loadOrder = {
        "movement.fly",
        "movement.noclip",
        "gui.main"
    }
}