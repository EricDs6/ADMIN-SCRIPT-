# Fita-K7 Admin – Arquitetura Modular

Este guia mostra como dividir o `adm.lua` em módulos menores para eliminar o erro "excedeu o limite de 200 registradores" e facilitar manutenção.

## Visão geral

- `mod_loader.lua`: loader principal. Carrega módulos via URL (Raw GitHub) com `game:HttpGet` + `loadstring`, ou localmente da pasta `modules/` com `readfile`.
- `modules/core.lua`: serviços Roblox, estado compartilhado (player, character, humanoid, hrp, mouse) e utilidades.
- `modules/ui.lua`: UI simples que registra botões e chama as funções dos módulos de features.
- `modules/fly.lua`: voo com `BodyVelocity` e `BodyGyro`.
- `modules/teleport.lua`: teleporte ao clicar (Click TP).
- `modules/player.lua`: WalkSpeed, JumpPower, Invisível.
- `modules/world.lua`: Full Bright e X-Ray básico.
- `modules/stick.lua`: Grudar em objetos com Seat/Weld, alvo sob o mouse.

## Como usar (local)

1. Abra o executor e rode o conteúdo de `mod_loader.lua` (ou copie o arquivo inteiro para o executor).
2. O loader, por padrão, tenta carregar localmente (pasta `modules/`). A UI abrirá do lado esquerdo com botões básicos.

## Como hospedar no GitHub (Raw) e carregar via URL

1. Suba os arquivos em um repositório público (pasta `modules/`).
2. Pegue os links Raw dos módulos (por exemplo, `https://raw.githubusercontent.com/<user>/<repo>/main/modules/core.lua`).
3. No `mod_loader.lua`, preencha a tabela `SOURCE` com essas URLs:

```lua
local SOURCE = {
  core = "https://raw.githubusercontent.com/<user>/<repo>/main/modules/core.lua",
  ui = "https://raw.githubusercontent.com/<user>/<repo>/main/modules/ui.lua",
  fly = "https://raw.githubusercontent.com/<user>/<repo>/main/modules/fly.lua",
  teleport = "https://raw.githubusercontent.com/<user>/<repo>/main/modules/teleport.lua",
  player = "https://raw.githubusercontent.com/<user>/<repo>/main/modules/player.lua",
  world = "https://raw.githubusercontent.com/<user>/<repo>/main/modules/world.lua",
  stick = "https://raw.githubusercontent.com/<user>/<repo>/main/modules/stick.lua",
}
```

4. Execute o `mod_loader.lua` no executor. Ele baixará e executará cada módulo via `loadstring`.

## Migração progressiva do `adm.lua`

- Trate o `adm.lua` atual como base de referência. Mova funcionalidade por funcionalidade para módulos específicos.
- Dicas para migrar sem quebrar:
  - Evite muitos `local` no mesmo chunk; use tabelas para estado (ex.: `Feature = { enabled = false }`).
  - Evite dependências cruzadas complexas; exponha apenas pequenas funções públicas (ex.: `toggle`, `setup`, `unstick`).
  - Use o `Core.state()` para obter `player`, `character`, `humanoid`, `hrp`, `mouse`.
  - Use `Core.connect("nome", conn)` para gerenciar conexões que precisam ser limpas.

## Extensões futuras

- Adicionar módulos: `admin`, `weapons`, `camera`, `esp`, `anti-afk`, etc.
- Substituir a UI simples por uma mais parecida com a do `adm.lua` (com ScrollingFrame, categorias, etc.).
- Unificar botões com estados (ON/OFF) e textos dinâmicos.

## Observação

- Alguns executores exigem `setfflag("HumanoidParallelRemoveNoPhysics", "False")` ou permissões específicas para `HttpGet`.
- `readfile`/`writefile` são funções de executores; se o seu não suportar, prefira sempre `HttpGet` + URLs.
