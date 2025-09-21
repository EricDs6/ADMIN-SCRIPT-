# Admin Script (Modular, carregado por loadstring)

Este repositório contém o script admin modularizado para Roblox, com um módulo principal em `src/admin_core.lua` e um loader simples em `init.lua` que baixa o módulo remoto e executa com `loadstring`.

## Uso rápido (no executor)

Copie e cole no seu executor de scripts Roblox:

```
loadstring(game:HttpGet("https://raw.githubusercontent.com/EricDs6/ADMIN-SCRIPT-RBX/main/init.lua"))()
```

Isso irá buscar `init.lua` que, por sua vez, baixa `src/admin_core.lua` e executa o admin.

## Estrutura

- `src/admin_core.lua`: Módulo principal, expõe `start()` que monta a GUI e todas as funcionalidades.
- `init.lua`: Loader resiliente que usa `syn.request`/`http.request`/`http_request`/`request`/`game:HttpGet` para buscar o módulo remoto, e valida a presença de `loadstring`.
- `admin.txt`: Versão original do script (referência).

## Observações

- Alguns executores exigem habilitar HTTP (`HttpGetEnabled`) e/ou usam diferentes APIs de rede. O loader tenta múltiplas abordagens automaticamente.
 - Se seu executor não expõe `loadstring`, o loader emitirá um erro informando a limitação.
- Se você for usar localmente, pode simplesmente executar `src/admin_core.lua` diretamente no executor (ele retorna uma tabela `M` com `M.start()`). Exemplo:

```
local M = loadstring(readfile("src/admin_core.lua"))()
M.start()
```

Aproveite e bom jogo!
