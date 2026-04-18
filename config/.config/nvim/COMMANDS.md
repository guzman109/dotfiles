# AgentVim Commands

> Enter commands with `:` in normal mode. Tab-complete to browse.

## LSP

| Command | Action |
|---------|--------|
| `:LspStart` | Start LSP for current buffer |
| `:LspStop` | Stop all LSP clients on current buffer |
| `:LspRestart` | Restart all LSP clients on current buffer |
| `:LspInfo` | Show attached LSP clients |

## Project

| Command | Action |
|---------|--------|
| `:Just` | Pick and run a recipe from the nearest `justfile` |
| `:Just <recipe>` | Run a recipe from the nearest `justfile` |
| `:Just <recipe> <args...>` | Run a recipe with arguments |
| `:JustEdit` | Edit nearest `justfile`, or create one in cwd |
| `:ProjectInit` | Pick a project scaffold template |
| `:ProjectInit C++` | Create C++ scaffold files |
| `:ProjectInit Zig` | Create Zig scaffold files |
| `:ProjectInit Python uv` | Create Python uv scaffold files |
| `:ProjectInit Lua` | Create Lua scaffold files |
| `:ProjectInit Swift` | Create Swift scaffold files |
| `:ProjectInit TypeScript` | Create TypeScript scaffold files |
| `:ProjectInit Prose` | Create prose lint scaffold files |

## Finder

| Command | Action |
|---------|--------|
| `:FzfLua files` | Find files |
| `:FzfLua live_grep` | Live grep |
| `:FzfLua buffers` | Buffers |
| `:FzfLua oldfiles` | Recent files |
| `:FzfLua help_tags` | Help tags |
| `:FzfLua diagnostics_document` | Document diagnostics |
| `:FzfLua lsp_document_symbols` | Document symbols |

## Tools

| Command | Action |
|---------|--------|
| `:Oil` | Open file explorer |
| `:AerialToggle` | Toggle code outline |
| `:LivePreview start` | Start browser live preview |
| `:LivePreview stop` | Stop browser live preview |
| `:LivePreview pick` | Pick file to preview |
| `:ConformInfo` | Show active formatters for current buffer |

## HTTP

Kulala stays separate from project tasks. Use `<leader>k` maps for normal HTTP work, or call commands directly:

| Command | Action |
|---------|--------|
| `:lua require("kulala").run()` | Run current request |
| `:lua require("kulala").run_all()` | Run all requests |
| `:lua require("kulala").set_selected_env()` | Select environment |
| `:lua require("kulala.ui").show_script_output()` | Show script output |

## Python Environment

| Command | Action |
|---------|--------|
| `:VenvSelect` | Select Python virtual environment |
| `:VenvSelectCached` | Use cached Python virtual environment when available |

## Plugin And Parser Management

| Command | Action |
|---------|--------|
| `:lua vim.pack.update()` | Update all plugins |
| `:lua vim.pack.update({ "name" })` | Update specific plugin |
| `:lua vim.pack.del({ "name" }, { force = true })` | Remove plugin |
| `:TSUpdate` | Update installed Tree-sitter parsers |
| `:InspectTree` | Show parse tree for current buffer |
| `:Mason` | Open Mason UI for DAP tools |

## AI

| Command | Action |
|---------|--------|
| `:ClaudePreviewInstallHooks` | Install Claude Code hooks in project |
