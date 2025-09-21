# Admin Script Modular v2.0# Admin Script (Modular, carregado por loadstring)



## 🏗️ Nova Arquitetura ModularEste repositório contém o script admin modularizado para Roblox, com um módulo principal em `src/admin_core.lua` e um loader simples em `init.lua` que baixa o módulo remoto e executa com `loadstring`.



Este projeto foi completamente reestruturado para máxima manutenibilidade e flexibilidade. Cada funcionalidade agora é um módulo independente.## Uso rápido (no executor)



## 📁 Estrutura do ProjetoCopie e cole no seu executor de scripts Roblox:



``````

admPRISON/loadstring(game:HttpGet("https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-RBX/main/init.lua"))()

├── init.lua                 # Loader principal - ponto de entrada```

├── config.lua              # Configurações dos módulos

├── modules/Isso irá buscar `init.lua` que, por sua vez, baixa `src/admin_core.lua` e executa o admin.

│   ├── movement/           # Módulos de movimento

│   │   ├── fly.lua        # Sistema de voo## Estrutura

│   │   └── noclip.lua     # Atravessar paredes

│   ├── gui/               # Módulos de interface- `src/admin_core.lua`: Módulo principal, expõe `start()` que monta a GUI e todas as funcionalidades.

│   │   └── main.lua       # GUI principal- `init.lua`: Loader resiliente que usa `syn.request`/`http.request`/`http_request`/`request`/`game:HttpGet` para buscar o módulo remoto, e valida a presença de `loadstring`.

│   └── utils/             # Utilitários (futuras expansões)- `admin.txt`: Versão original do script (referência).

└── admin.txt              # Arquivo original (referência)

```## Observações



## 🚀 Como Usar- Alguns executores exigem habilitar HTTP (`HttpGetEnabled`) e/ou usam diferentes APIs de rede. O loader tenta múltiplas abordagens automaticamente.

 - Se seu executor não expõe `loadstring`, o loader emitirá um erro informando a limitação.

### Carregar o Script Completo- Se você for usar localmente, pode simplesmente executar `src/admin_core.lua` diretamente no executor (ele retorna uma tabela `M` com `M.start()`). Exemplo:

```lua

loadstring(game:HttpGet("https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-/main/init.lua"))()```

```local M = loadstring(readfile("src/admin_core.lua"))()

M.start()

### Carregar Módulos Individuais```

```lua

-- Apenas vooAproveite e bom jogo!

loadstring(game:HttpGet("https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-/main/modules/movement/fly.lua"))()

-- Apenas noclip
loadstring(game:HttpGet("https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-/main/modules/movement/noclip.lua"))()
```

## 🎮 Controles

### Interface Gráfica
- **Botão Voo**: Liga/desliga o sistema de voo
- **Botão Atravessar**: Liga/desliga atravessar paredes
- **Minimizar (—)**: Esconde a janela
- **Fechar (✕)**: Para completamente o script

### Comandos de Chat
- `/cleanup` - Limpa e para tudo
- `/limpar` - Limpa e para tudo
- `/clear` - Limpa e para tudo

### Controles de Voo
- **WASD**: Movimento horizontal
- **Espaço**: Subir
- **Ctrl Esquerdo**: Descer

## 🔧 API dos Módulos

### Sistema de Voo
```lua
_G.AdminScript.Movement.Fly.toggle()          -- Liga/desliga
_G.AdminScript.Movement.Fly.enable()          -- Apenas ligar
_G.AdminScript.Movement.Fly.disable()         -- Apenas desligar
_G.AdminScript.Movement.Fly.setSpeed(100)     -- Definir velocidade
_G.AdminScript.Movement.Fly.getSpeed()        -- Obter velocidade atual
_G.AdminScript.Movement.Fly.isEnabled()       -- Verificar se está ativo
```

### Sistema de Noclip
```lua
_G.AdminScript.Movement.Noclip.toggle()       -- Liga/desliga
_G.AdminScript.Movement.Noclip.enable()       -- Apenas ligar
_G.AdminScript.Movement.Noclip.disable()      -- Apenas desligar
_G.AdminScript.Movement.Noclip.forceOnce()    -- Atravessar temporariamente
_G.AdminScript.Movement.Noclip.isEnabled()    -- Verificar se está ativo
```

### Sistema de GUI
```lua
_G.AdminScript.GUI.Module.create()            -- Criar interface
_G.AdminScript.GUI.Module.toggleMinimize()    -- Minimizar/restaurar
_G.AdminScript.GUI.Module.addModule()         -- Adicionar módulo
_G.AdminScript.GUI.Module.removeModule()      -- Remover módulo
```

## ⚙️ Configuração

O arquivo `config.lua` permite personalizar quais módulos carregar:

```lua
-- Exemplo: Desabilitar noclip
movement = {
    enabled = true,
    modules = {
        fly = { enabled = true, path = "modules/movement/fly.lua" },
        noclip = { enabled = false, path = "modules/movement/noclip.lua" } -- Desabilitado
    }
}
```

## 🔄 Vantagens da Nova Arquitetura

### Para Desenvolvedores
- **Manutenção Fácil**: Cada função em seu próprio arquivo
- **Testes Isolados**: Teste módulos individualmente
- **Desenvolvimento Paralelo**: Múltiplos devs podem trabalhar simultaneamente
- **Reutilização**: Módulos podem ser usados em outros projetos

### Para Usuários
- **Carregamento Flexível**: Carregue apenas o que precisa
- **Performance**: Menos código = menos lag
- **Estabilidade**: Problemas em um módulo não afetam outros
- **Facilidade**: Interface mais limpa e organizada

## 🆕 Adicionando Novos Módulos

### 1. Criar o Arquivo
```lua
-- modules/movement/speed.lua
local Admin = _G.AdminScript
if not Admin then return end

local SpeedModule = {
    enabled = false,
    originalSpeed = 16
}

local function toggleSpeed()
    SpeedModule.enabled = not SpeedModule.enabled
    -- Implementação aqui
end

Admin.Movement.Speed = {
    toggle = toggleSpeed,
    -- Outras funções
}
```

### 2. Adicionar na Configuração
```lua
-- config.lua
movement = {
    modules = {
        speed = {
            enabled = true,
            path = "modules/movement/speed.lua"
        }
    }
},
loadOrder = {"movement.speed"} -- Adicionar na ordem
```

### 3. Registrar na GUI (opcional)
```lua
-- A GUI automaticamente detecta novos módulos
```

## 🔧 Compatibilidade

- **Executors**: Synapse X, KRNL, Script-Ware, Fluxus
- **Roblox**: Todas as versões atuais
- **Dispositivos**: PC, Mobile (com executor compatível)

## 📝 Notas Técnicas

- Cada módulo é independente e pode funcionar sozinho
- Sistema de cleanup automático em caso de erro
- Proteção contra multiple carregamentos
- Sistema de versionamento para compatibilidade
- Logs detalhados para debugging

---

**Desenvolvido para máxima modularidade e facilidade de manutenção** 🛠️