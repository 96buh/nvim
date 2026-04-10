# Repository Guidelines

## Project Structure & Module Organization
This repository is a personal Neovim configuration written in Lua. `init.lua` is the entrypoint and loads modules from `lua/config/` for bootstrap, options, and keymaps. Plugin specs live in `lua/plugins/`, generally one plugin or feature area per file, for example `lua/plugins/lsp.lua` or `lua/plugins/telescope.lua`. Custom LuaSnip snippets live in `lua/snippets/`, with TeX snippets grouped under `lua/snippets/tex/`. Plugin versions are pinned in `lazy-lock.json`.

## Build, Test, and Development Commands
Run Neovim with this config locally using `nvim`. Useful maintenance commands:

- `nvim --headless "+qa"`: basic startup smoke test.
- `nvim --headless "+Lazy! sync" "+qa"`: install or update pinned plugins from `lazy-lock.json`.
- `nvim --headless "+MasonToolsInstallSync" "+qa"`: install configured LSP and formatter tools.
- `stylua init.lua lua`: format Lua sources when `stylua` is installed.

Some plugins write to Neovim state directories during startup, so headless checks may fail in restricted sandboxes even when the config is otherwise valid.

## Coding Style & Naming Conventions
Follow the existing Lua style in the repo: 4-space indentation in core config, concise module files, and `return { ... }` for plugin specs. Use lowercase snake_case filenames such as `lua/plugins/treesitter.lua`. Keep related settings together and prefer descriptive local names over comments. When adding snippets, mirror the current directory layout, for example `lua/snippets/tex/math.lua`.

## Testing Guidelines
There is no dedicated automated test suite yet. Validate changes with a startup smoke test and by opening the affected workflow in Neovim, such as LSP attach, Telescope pickers, or LuaSnip expansion. For plugin changes, confirm `:Lazy` loads cleanly; for snippet edits, verify the target filetype expands as expected.

## Commit & Pull Request Guidelines
Git history currently contains only `initial commit`, so no strong commit convention is established. Use short, imperative commit subjects like `Add Typst preview plugin` or `Refine Telescope mappings`. Pull requests should include the purpose of the change, the files or workflows affected, manual verification steps, and screenshots only when UI behavior changes. Update `lazy-lock.json` only when intentionally changing plugin versions.
