# Neovim Commands

> Enter with `:` in normal mode. Tab-complete to browse.

## LSP

| Command | Action | File |
|---------|--------|------|
| `:LspStart` | Start LSP for current buffer | 20_keymaps |
| `:LspStop` | Stop all LSP clients on current buffer | 20_keymaps |
| `:LspRestart` | Restart all LSP clients on current buffer | 20_keymaps |
| `:LspInfo` | Show attached LSP clients | 20_keymaps |

## Code Outline

| Command | Action | File |
|---------|--------|------|
| `:AerialToggle` | Toggle code outline panel | 50_editor |
| `:AerialPrev` | Jump to previous symbol | 50_editor |
| `:AerialNext` | Jump to next symbol | 50_editor |
| `:Fluoride` | Symbol structure view | 50_editor |

## Finder (mini.pick)

| Command | Action | File |
|---------|--------|------|
| `:Pick files` | Find files | 50_editor |
| `:Pick grep_live` | Live grep | 50_editor |
| `:Pick buffers` | Open buffers | 50_editor |
| `:Pick oldfiles` | Recent files | 50_editor |
| `:Pick help` | Help tags | 50_editor |
| `:Pick diagnostic scope='current'` | Document diagnostics | 50_editor |
| `:Pick lsp scope='document_symbol'` | Document symbols | 50_editor |
| `:Pick <picker>` | Any other mini picker | 50_editor |

## Live Preview

| Command | Action | File |
|---------|--------|------|
| `:LivePreview start` | Start browser live preview | 50_editor |
| `:LivePreview stop` | Stop browser live preview | 50_editor |
| `:LivePreview pick` | Pick file to preview | 50_editor |

## AI (claude-preview)

| Command | Action | File |
|---------|--------|------|
| `:ClaudePreviewInstallHooks` | Install Claude Code hooks in project | 90_ai |

## Plugin Management (vim.pack)

| Command | Action |
|---------|--------|
| `:lua vim.pack.update()` | Update all plugins |
| `:lua vim.pack.update({ 'name' })` | Update specific plugin |
| `:lua vim.pack.del({ 'name' }, { force = true })` | Remove plugin |

## Treesitter

| Command | Action |
|---------|--------|
| `:TSInstall <lang>` | Install parser for language |
| `:TSUpdate` | Update all installed parsers |
| `:TSModuleInfo` | Show module status per filetype |
| `:InspectTree` | Show parse tree for current buffer |

## Mason (DAP tools)

| Command | Action |
|---------|--------|
| `:Mason` | Open Mason UI |
| `:MasonInstall <pkg>` | Install a package |
| `:MasonUninstall <pkg>` | Uninstall a package |
| `:MasonUpdate` | Update all installed packages |

## Formatting

| Command | Action |
|---------|--------|
| `:ConformInfo` | Show active formatters for current buffer |

## Markdown Rendering (markview)

| Command | Action |
|---------|--------|
| `:Markview` | Toggle markdown rendering |
| `:Markview enable` | Enable rendering |
| `:Markview disable` | Disable rendering |

## Testing (neotest)

| Command | Action |
|---------|--------|
| `:Neotest run` | Run nearest test |
| `:Neotest run file` | Run all tests in file |
| `:Neotest stop` | Stop running test |
| `:Neotest output` | Show test output |
| `:Neotest output-panel` | Toggle output panel |
| `:Neotest summary` | Toggle test summary panel |

## Python (only in .py files)

| Command | Action | File |
|---------|--------|------|
| `:VenvSelect` | Select Python virtual environment | ftplugin/python |
| `:VenvSelectCached` | Use cached Python virtual environment | ftplugin/python |

## C/C++ (only in .c/.cpp files)

| Command | Action | File |
|---------|--------|------|
| `:ClangdSwitchSourceHeader` | Switch between header and source file | ftplugin/cpp |
