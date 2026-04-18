# AgentVim

> Agentic editing. Native speed. Project-owned tasks.

AgentVim is a personal Neovim config built on `vim.pack`. Global config owns editing, navigation, LSP, formatting, debugging primitives, and a small `just` recipe launcher. Project-specific build/test/run behavior belongs in local `justfile` recipes.

## Layout

```text
~/.config/nvim/
├── init.lua
├── plugin/
│   ├── 10_options.lua
│   ├── 20_keymaps.lua
│   ├── 30_mini.lua
│   ├── 40_ui.lua
│   ├── 50_editor.lua
│   ├── 60_lsp.lua
│   ├── 70_completion.lua
│   ├── 80_dap.lua
│   └── 90_ai.lua
├── after/
│   ├── ftplugin/              # editing defaults only
│   └── lsp/                   # LSP server configs
├── lua/project_init.lua       # project scaffolds
├── KEYMAPS.md
└── COMMANDS.md
```

## Project Tasks

Local project tasks live in a `justfile`:

```make
set dotenv-load := true
set export := true

default:
	@just --list

build:
	meson compile -C build

test:
	meson test -C build --print-errorlogs

fmt:
	clang-format -i src/**/*.cpp include/**/*.hpp
```

Use `<leader>pp` or `:Just` from anywhere inside the project to pick a recipe. Use `<leader>pe` to edit the nearest `justfile`.

## Project Init

Use `:ProjectInit` or `<leader>pI` to scaffold project files. Available templates:

```text
C++
Zig
Python uv
Lua
Swift
TypeScript
Prose
```

The scaffolder creates missing files only; it does not overwrite existing project files.

## Key Bindings

| Key | Action |
|-----|--------|
| `<leader>pp` | Pick and run a `just` recipe |
| `<leader>pe` | Edit `justfile` |
| `<leader>pI` | Initialize project files |
| `<leader>Ni` | Edit `init.lua` |
| `<leader>Nu` | Update plugins |
| `<leader>Nx` | Clean inactive plugins |
| `<leader>cf` | Format current buffer |
| `-` / `<leader>e` | Open Oil |
| `<leader><space>` / `ff` | Find files |
| `<leader>/` | Live grep |
| `<leader>ac` | Open AI agent |

See [KEYMAPS.md](KEYMAPS.md) for the full list.

## Language Support

Focused language support:

| Language | LSP / Tools |
|----------|-------------|
| C/C++ | `clangd`, `clang-tidy`, `clang-format` |
| Meson | `mesonlsp` |
| Zig | `zls`, `zigfmt` |
| Python | `pyrefly`, `ruff`, `venv-selector` |
| Lua | `emmylua`, `stylua` |
| Swift | `sourcekit-lsp`, `swift-format` |
| TypeScript / JavaScript | `vtsls`, `biome` |
| Docker / Compose | `docker-language-server`, `dockerfmt`, `yamlfmt` |

Python venv maps attach only in Python contexts:

| Key | Action |
|-----|--------|
| `<leader>pv` | Select venv |
| `<leader>pV` | Activate cached venv |
| `<leader>pX` | Deactivate venv |
| `<leader>pP` | Show active Python |

## HTTP

Kulala stays separate from project tasks and uses a small dedicated keymap group:

| Key | Action |
|-----|--------|
| `<leader>kr` | Run current request |
| `<leader>kR` | Show script output |
| `<leader>ke` | Select environment |

## External Tools

```bash
brew install go llvm stylua fzf ripgrep meson ninja conan
uv tool install pyrefly ruff debugpy
cargo install mesonlsp
go install github.com/docker/docker-language-server/cmd/docker-language-server@latest
go install github.com/reteps/dockerfmt@latest
go install github.com/google/yamlfmt/cmd/yamlfmt@latest
```

Install `zls` with your Zig toolchain manager.

## Plugin Updates

```vim
:lua vim.pack.update()
```
