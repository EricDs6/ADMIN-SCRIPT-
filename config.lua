--[[
  Configuração do Admin Script Modular
  Esta configuração é carregada pelo init.lua e mesclada com os defaults.
]]

return {
  settings = {
    autoLoadGUI = true,
    debugMode = true,
    chatCommands = true,
  },

  loadOrder = {
    "Movement.fly",
    "Movement.noclip",
    "Movement.speed",
    "Character.godmode",
    "Teleport.locations",
    "GUI.main",
  },

  Movement = {
    enabled = true,
    modules = {
      fly = { enabled = true, path = "modules/movement/fly.lua" },
      noclip = { enabled = true, path = "modules/movement/noclip.lua" },
      speed = { enabled = true, path = "modules/movement/speed.lua" },
    }
  },

  Character = {
    enabled = true,
    modules = {
      godmode = { enabled = true, path = "modules/character/godmode.lua" },
    }
  },

  Teleport = {
    enabled = true,
    modules = {
      locations = { enabled = true, path = "modules/teleport/locations.lua" },
    }
  },

  GUI = {
    enabled = true,
    modules = {
      main = { enabled = true, path = "modules/gui/main.lua" },
    }
  },
}
