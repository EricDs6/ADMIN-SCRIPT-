# Admin Script Modular v2.0# Admin Script Modular v2.0# Admin Script Modular v2.0# Admin Script (Modular, carregado por loadstring)



## Loadstring



```## Descrição

loadstring(game:HttpGet("https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-/main/init.lua"))()

```Este script Admin para Roblox usa uma arquitetura modular que separa cada funcionalidade em arquivos individuais para maior facilidade de manutenção e personalização. Esta abordagem modular permite que você ative apenas as funcionalidades que deseja usar.



## Overrides de Configuração (opcional)## 🏗️ Nova Arquitetura ModularEste repositório contém o script admin modularizado para Roblox, com um módulo principal em `src/admin_core.lua` e um loader simples em `init.lua` que baixa o módulo remoto e executa com `loadstring`.



Antes do `loadstring`, você pode definir overrides rápidos:## Como Usar



```

_G.AdminScriptUserConfig = {

  autoLoadGUI = false,      -- não abrir GUI automaticamente### Instalação Básica

  debugMode = true,         -- logs detalhados

  diagnosticsCoreGui = true,-- monitorar CoreGui (modo diagnóstico)```luaEste projeto foi completamente reestruturado para máxima manutenibilidade e flexibilidade. Cada funcionalidade agora é um módulo independente.## Uso rápido (no executor)

  diagnosticsVerbosity = 2  -- nível de detalhe do diagnóstico

}loadstring(game:HttpGet("https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-/main/init.lua"))()

```

```

## Comandos de Chat

- `/admin` — abre/fecha a GUI

- `/fly` — ativa/desativa voo

- `/noclip` — ativa/desativa noclip### Comandos de Chat## 📁 Estrutura do ProjetoCopie e cole no seu executor de scripts Roblox:

- `/god` ou `/godmode` — ativa/desativa godmode (Character ou CharacterMods)

- `/cleanup` | `/limpar` | `/clear` — limpa tudo- `/admin` - Abre/fecha a GUI

- `/selftest` — roda um autoteste rápido do estado

- `/cleanup` - Remove todas as alterações feitas pelo script

## Estrutura

- `init.lua` — loader principal, baixa módulos do repositório e inicializa- `/fly` - Ativa/desativa modo de voo

- `config.lua` — mapeamento remoto de módulos e settings

- `modules/` — módulos por categoria- `/noclip` - Ativa/desativa atravessar paredes``````



## Notas- `/god` - Ativa/desativa modo invencível

- A GUI agora é parentada somente no PlayerGui (com timeout) para evitar erros em CoreGui.

- Em executores com sobreposições (overlays) que injetam scripts no CoreGui, ative `diagnosticsCoreGui` para identificar o criador.admPRISON/loadstring(game:HttpGet("https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-RBX/main/init.lua"))()


## Módulos Disponíveis

├── init.lua                 # Loader principal - ponto de entrada```

### Movimento

- **Fly** (`Admin.Movement.fly`)├── config.lua              # Configurações dos módulos

  - `.toggle()` - Ativa/desativa o modo de voo

  - `.setSpeed(valor)` - Define a velocidade de voo├── modules/Isso irá buscar `init.lua` que, por sua vez, baixa `src/admin_core.lua` e executa o admin.

  - `.enable()` / `.disable()` - Ativa/desativa diretamente

│   ├── movement/           # Módulos de movimento

- **Noclip** (`Admin.Movement.noclip`)

  - `.toggle()` - Ativa/desativa atravessar paredes│   │   ├── fly.lua        # Sistema de voo## Estrutura

  - `.forceOnce()` - Atravessa paredes uma única vez

  - `.enable()` / `.disable()` - Ativa/desativa diretamente│   │   └── noclip.lua     # Atravessar paredes



- **Speed** (`Admin.Movement.speed`)│   ├── gui/               # Módulos de interface- `src/admin_core.lua`: Módulo principal, expõe `start()` que monta a GUI e todas as funcionalidades.

  - `.set(valor)` - Define a velocidade de movimento

  - `.reset()` - Restaura a velocidade normal│   │   └── main.lua       # GUI principal- `init.lua`: Loader resiliente que usa `syn.request`/`http.request`/`http_request`/`request`/`game:HttpGet` para buscar o módulo remoto, e valida a presença de `loadstring`.

  - `.increase(valor)` / `.decrease(valor)` - Aumenta/diminui a velocidade

│   └── utils/             # Utilitários (futuras expansões)- `admin.txt`: Versão original do script (referência).

### Personagem

- **Godmode** (`Admin.Character.godmode`)└── admin.txt              # Arquivo original (referência)

  - `.toggle()` - Ativa/desativa invencibilidade

  - `.enable()` / `.disable()` - Ativa/desativa diretamente```## Observações



### Teleporte

- **Locations** (`Admin.Teleport.locations`)

  - `.toPlayer("nome")` - Teleporta para um jogador## 🚀 Como Usar- Alguns executores exigem habilitar HTTP (`HttpGetEnabled`) e/ou usam diferentes APIs de rede. O loader tenta múltiplas abordagens automaticamente.

  - `.saveLocation("nome")` - Salva a localização atual

  - `.toSaved("nome")` - Teleporta para uma localização salva - Se seu executor não expõe `loadstring`, o loader emitirá um erro informando a limitação.

  - `.back()` - Volta para a localização anterior

  - `.toPredefined("Prison", "Celas")` - Teleporta para local pré-definido### Carregar o Script Completo- Se você for usar localmente, pode simplesmente executar `src/admin_core.lua` diretamente no executor (ele retorna uma tabela `M` com `M.start()`). Exemplo:



### GUI```lua

- **Main** (`Admin.GUI.main`)

  - `.toggle()` - Mostra/oculta a interface gráficaloadstring(game:HttpGet("https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-/main/init.lua"))()```

  - `.show()` / `.hide()` - Mostra/oculta diretamente

```local M = loadstring(readfile("src/admin_core.lua"))()

## Exemplo de Uso

M.start()

```lua

-- Carregar o script### Carregar Módulos Individuais```

loadstring(game:HttpGet("https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-/main/init.lua"))()

```lua

-- Ativar voo

Admin.Movement.fly.toggle()-- Apenas vooAproveite e bom jogo!



-- Definir velocidade de voo para 100loadstring(game:HttpGet("https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-/main/modules/movement/fly.lua"))()

Admin.Movement.fly.setSpeed(100)

-- Apenas noclip

-- Ativar modo invencívelloadstring(game:HttpGet("https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-/main/modules/movement/noclip.lua"))()

Admin.Character.godmode.toggle()```



-- Teleportar para um jogador## 🎮 Controles

Admin.Teleport.locations.toPlayer("NomeDoJogador")

### Interface Gráfica

-- Salvar localização atual- **Botão Voo**: Liga/desliga o sistema de voo

Admin.Teleport.locations.saveLocation("MinhaBase")- **Botão Atravessar**: Liga/desliga atravessar paredes

- **Minimizar (—)**: Esconde a janela

-- Mostrar GUI- **Fechar (✕)**: Para completamente o script

Admin.GUI.main.show()

```### Comandos de Chat

- `/cleanup` - Limpa e para tudo

## Estrutura de Arquivos- `/limpar` - Limpa e para tudo

```- `/clear` - Limpa e para tudo

/

├── init.lua                   # Carregador principal### Controles de Voo

├── modules/                   # Pasta de módulos- **WASD**: Movimento horizontal

│   ├── movement/              # Módulos de movimento- **Espaço**: Subir

│   │   ├── fly.lua            # Módulo de voo- **Ctrl Esquerdo**: Descer

│   │   ├── noclip.lua         # Módulo de atravessar paredes

│   │   └── speed.lua          # Módulo de velocidade## 🔧 API dos Módulos

│   ├── character/             # Módulos de personagem

│   │   └── godmode.lua        # Módulo de invencibilidade### Sistema de Voo

│   ├── teleport/              # Módulos de teleporte```lua

│   │   └── locations.lua      # Módulo de localizações_G.AdminScript.Movement.Fly.toggle()          -- Liga/desliga

│   └── gui/                   # Módulos de interface_G.AdminScript.Movement.Fly.enable()          -- Apenas ligar

│       └── main.lua           # Interface principal_G.AdminScript.Movement.Fly.disable()         -- Apenas desligar

```_G.AdminScript.Movement.Fly.setSpeed(100)     -- Definir velocidade

_G.AdminScript.Movement.Fly.getSpeed()        -- Obter velocidade atual

## Compatibilidade_G.AdminScript.Movement.Fly.isEnabled()       -- Verificar se está ativo

Este script foi projetado para funcionar com vários executores:```

- Synapse X

- Script-Ware### Sistema de Noclip

- KRNL```lua

- Executores genéricos que suportam HTTP e loadstring_G.AdminScript.Movement.Noclip.toggle()       -- Liga/desliga

_G.AdminScript.Movement.Noclip.enable()       -- Apenas ligar

## Limpeza_G.AdminScript.Movement.Noclip.disable()      -- Apenas desligar

Para remover completamente o script e todas as suas alterações:_G.AdminScript.Movement.Noclip.forceOnce()    -- Atravessar temporariamente

```lua_G.AdminScript.Movement.Noclip.isEnabled()    -- Verificar se está ativo

_G.AdminScript.cleanup()```

```

ou digite `/cleanup` no chat.### Sistema de GUI

```lua

## Notas_G.AdminScript.GUI.Module.create()            -- Criar interface

- Algumas funções podem ser detectadas pelos sistemas anti-cheat dos jogos. Use com cuidado._G.AdminScript.GUI.Module.toggleMinimize()    -- Minimizar/restaurar

- Este script é apenas para fins educacionais e de demonstração._G.AdminScript.GUI.Module.addModule()         -- Adicionar módulo

_G.AdminScript.GUI.Module.removeModule()      -- Remover módulo

## Créditos```

- EricDs6 - Desenvolvedor

- Versão 2.0 (21/09/2025)## ⚙️ Configuração

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