# Neovim Config — Quick Reference

Leader key: `<Space>`

---

## Opening Files

You have **4 ways** to open files, depending on context:

| Method | Key | When to use |
|---|---|---|
| **Fuzzy find** | `<leader>ff` | Jump to any file in the project by name |
| **Grep** | `<leader>fg` | Search file contents, then open the match |
| **File explorer** | `<leader>mf` | Browse the directory tree interactively |
| **Netrw (classic)** | `<leader>pv` | Traditional Vim file browser |

Inside **mini.files** (`<leader>mf`): press `l` to open a file or expand a directory, `h` to go up. Enter does nothing — use `l` instead.

Inside **netrw** (`<leader>pv`): press Enter to open.

---

## Plugins & Keybindings

### Navigation

| Key | Action | Plugin |
|---|---|---|
| `<leader>mf` | **File Explorer** (Miller columns) | mini.files |
| `<leader>pv` | Netrw file explorer (classic) | built-in |
| `<leader>ff` | Find files (fuzzy) | telescope |
| `<leader>fg` | Live grep (fuzzy) | telescope |
| `<leader>fb` | Browse open buffers | telescope |
| `<leader>fh` | Search help tags | telescope |

### Window Management

| Key | Action |
|---|---|
| `Ctrl+h/j/k/l` | Move to left/lower/upper/right window |
| `<leader>sv` | Split vertical |
| `<leader>sh` | Split horizontal |
| `<leader>se` | Equalize split sizes |
| `<leader>sx` | Close current split |

### Buffer Management

| Key | Action |
|---|---|
| `Shift+l` | Next buffer |
| `Shift+h` | Previous buffer |
| `<leader>bd` | Delete current buffer |

### LSP (Language Server)

| Key | Action |
|---|---|
| `K` | Hover (show type/docs) |
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gI` | Go to implementation |
| `go` | Go to type definition |
| `gr` | List references |
| `gs` | Signature help |
| `F2` | Rename symbol |
| `F3` | Format buffer (LSP) |
| `F4` | Code action |
| `<leader>h` | Switch source/header (clangd only) |

**Installed LSP servers:** lua_ls, rust_analyzer, clangd, cmake, gopls, vtsls (TS/JS), html, cssls, docker_language_server, jsonls, basedpyright (Python)

### Git (gitsigns)

| Key | Action |
|---|---|
| `]h` / `[h` | Next / previous hunk |
| `<leader>ghs` | Stage hunk |
| `<leader>ghr` | Reset hunk |
| `<leader>ghS` | Stage entire buffer |
| `<leader>ghR` | Reset entire buffer |
| `<leader>ghu` | Undo stage hunk |
| `<leader>ghp` | Preview hunk inline |
| `<leader>gb` | Blame line |
| `<leader>gd` | Diff this file |
| `<leader>gD` | Diff this file (vs HEAD~) |
| `ih` | Select hunk (text object, operator-pending/visual) |

### Diagnostics

| Key | Action |
|---|---|
| `[d` / `]d` | Previous / next diagnostic |
| `<leader>e` | Show diagnostic float under cursor |
| `<leader>dl` | All diagnostics in location list |

### Linting (nvim-lint)

Linters configured:

| Filetype | Linter | Install |
|---|---|---|
| Lua | selene | `:MasonInstall selene` |
| Python | ruff | `:MasonInstall ruff` |
| Shell | shellcheck | `dnf install ShellCheck` |
| Dockerfile | hadolint | `:MasonInstall hadolint` |
| Markdown | markdownlint | `:MasonInstall markdownlint` |
| YAML | yamllint | `:MasonInstall yamllint` |

Linting runs automatically on save and insert leave.

| Key | Action |
|---|---|
| `<leader>ll` | Trigger lint manually |

### Formatting (conform)

Runs automatically on save. Formatters by filetype:

| Language | Formatter |
|---|---|
| C/C++ | clang_format |
| Go | goimports → gofumpt |
| Python | ruff_format |
| Rust | rustfmt |
| Lua | stylua |
| JS/TS/JSON/HTML/CSS | prettierd |

### Completion (blink.cmp)

| Key | Action |
|---|---|
| `Ctrl+Space` | Open completion menu (or toggle docs) |
| `Ctrl+n` / `Ctrl+p` | Next / previous suggestion |
| `Ctrl+e` | Dismiss menu |
| `Ctrl+y` | Accept suggestion |
| `Enter` | Confirm selection |

Sources: LSP, path, snippets (friendly-snippets), buffer words.

### Undo Tree (undotree)

| Key | Action |
|---|---|
| `<leader>u` | Toggle undo tree |

### mini.files — Explorer Mappings

Once inside the explorer (`<leader>mf`):

| Key | Action |
|---|---|
| `j` / `k` | Move cursor down / up |
| `l` | **Go in** — expand directory or open file |
| `L` | **Go in plus** — open file + close explorer |
| `h` | **Go out** — focus parent directory |
| `H` | **Go out plus** — focus parent + trim right |
| `q` | Close explorer |
| `Backspace` | Reset to anchor directory |
| `=` | Synchronize (apply edits / refresh from disk) |
| `m` + letter | Set bookmark |
| `'` + letter | Jump to bookmark |
| `@` | Reveal current working directory |
| `<` / `>` | Trim left / right part of branch |
| `g?` | Show help |

You edit directory buffers as text to create, delete, rename, copy, and move files. Press `=` to apply.

### mini.surround

| Key | Action |
|---|---|
| `sa` + motion + char | **Add** surrounding (e.g. `saiw"` → `"word"`) |
| `sd` + char | **Delete** surrounding |
| `sr` + old + new | **Replace** surrounding |

### mini.comment

| Key | Action |
|---|---|
| `gcc` | Toggle comment line |
| `gc` + motion | Toggle comment region (e.g. `gcip`) |

### mini.pairs

Auto-pairs `()`, `[]`, `{}`, `""`, `''`, etc. — works automatically in insert mode.

### mini.indentscope

Shows indentation guides and highlights the current scope. No keymaps — visual only.

### mini.trailspace

| Key | Action |
|---|---|
| `<leader>tt` | Trim trailing whitespace |
| `<leader>tT` | Trim trailing blank lines at end of file |

### mini.hipatterns

Auto-highlights hex color codes as their actual color, and calls out `TODO:`, `FIXME:`, `HACK:`, `NOTE:`, `XXX:` in standout colors.

### flash.nvim (Motion)

Label-based jumping — replaces vim-sneak. Press `s` to jump, labels appear on matches.

| Key | Action |
|---|---|
| `s` | Jump to any visible word (normal/visual/operator) |
| `S` | Jump to treesitter node |
| `r` | Remote jump (operator-pending) |
| `R` | Treesitter search (operator-pending/visual) |

Also enhances `/` search and `f`/`t` with labels automatically.

### Perforce (perfnvim)

| Key | Action |
|---|---|
| `<leader>pa` | `p4 add` — add current buffer |
| `<leader>pe` | `p4 edit` — checkout current buffer |
| `<leader>po` | `p4 opened` — list checked-out files (telescope) |
| `<leader>pg` | Grep checked-out files (telescope) |
| `<leader>pn` | Jump to next changed line |
| `<leader>pp` | Jump to previous changed line |

Also shows **signs** in the gutter for changed lines (like gitsigns).

### Toggles & Misc

| Key | Action |
|---|---|
| `<leader>tw` | Toggle line wrap |
| `<leader>tn` | Toggle line numbers |
| `<leader>tc` | Toggle 80-char column |
| `<leader>tl` | Toggle cursorline |
| `<leader>w` | Save file |
| `Alt+j` / `Alt+k` | Next / previous quickfix item |

---

## Colorschemes

- **Active:** tokyonight-night (with transparent background)
- **Available:** rose-pine, tokyonight (night, storm, day, moon)

---

## Future Candidates

### Other mini.nvim modules worth considering

| Module | What it does | Why you might want it |
|---|---|---|
| **mini.notify** | Non-blocking notification UI | ✅ Installed — replaces `vim.notify` with structured, history-browsable popups. |
| **mini.diff** | Diff hunks and navigation | Lightweight alternative to gitsigns if you want even smaller footprint. Currently redundant since you have gitsigns. |
| **mini.pick** | Fuzzy picker | Built-in picker that could replace telescope. Smaller, no dependencies, but fewer features. |
| **mini.starter** | Start screen | Shows recent files, bookmarks, session restore on Neovim launch. |
| **mini.sessions** | Session management | Save/restore window layouts and buffers per project. |
| **mini.tabline** | Tab bar | If you use tabs, shows buffers in each tab. Complements mini.statusline. |
| **mini.bufremove** | Safe buffer deletion | Close buffers without messing up window layout. Could pair with `<leader>bd`. |
| **mini.map** | Code minimap | Scrollable code outline on the side. |
| **mini.clue** | Keybinding hints | Which-key-like functionality but even smaller. Redundant since you have which-key, but worth knowing about as a fallback. |
| **mini.bracketed** | `[`/`]` prefix mappings | Standard `[d`/`]d` for diagnostics, `[h`/`]h` for hunks, etc. — you already have these manually set up. |
| **mini.git** | Git operations | Stage, commit, blame, diff. Covers some gitsigns ground but more focused on commit workflows. |
| **mini.test** | Test runner | Run tests from within Neovim with inline results. |
| **mini.visits** | Recently visited files/lines | Tracks cursor positions per buffer. Restore where you left off. |

### Modern motion replacement

| Plugin | What it does |
|---|---|
| **flash.nvim** | Label-based jumping replacing vim-sneak. See § flash.nvim above for keymaps. |

### Other notable plugins

| Plugin | Category | Why |
|---|---|---|
| **neogit** | Git UI | Magit-style git interface inside Neovim |
| **diffview.nvim** | Git diffs | Side-by-side diff views, file history |
| **trouble.nvim** | Diagnostics | Better diagnostic list UI with filtering |
| **fzf-lua** | Fuzzy finder | Faster than telescope (native fzf), similar API |
| **harpoon** | File bookmarks | Quick-jump between 2-4 frequent project files |
| **oil.nvim** | File explorer | Alternative to mini.files — single-window, text-editing-based, works over SSH |

---

## System Requirements

For a fully working OOTB experience on a new machine, install these before opening Neovim:

**Fedora:**
```
dnf install ripgrep fd-find ShellCheck nodejs
```

**macOS:**
```
brew install ripgrep fd shellcheck node
```

**Any platform:** Rust toolchain (`rustup.rs`) and Go toolchain (`go.dev`) if you work in those languages.

All other tools (LSP servers, formatters, linters) auto-install via Mason on first Neovim launch.

---

## 0.11 → 0.12 Migration

This config is a **Neovim 0.11 config**. It does not attempt to auto-detect or
support 0.12+. When upgrading:

### Treesitter (built-in)
Neovim 0.12 ships treesitter natively. Remove the `nvim-treesitter` plugin spec
from `lazy.lua` and delete `after/plugin/treesitter.lua`. Highlighting is on by
default; indentation needs `vim.bo.indentexpr = "v:lua.vim.treesitter.indentexpr()"`
in a `FileType` autocmd.

### Deprecated APIs
These are already fixed in this config:
- `vim.diagnostic.goto_next/prev` → `vim.diagnostic.jump()` ✅
- `c.request()` / `c.supports_method()` → `c:request()` / `c:supports_method()` ✅

These still need updating on 0.12+:
- `{ buffer = ... }` → `{ buf = ... }` in keymap opts (`after/plugin/lsp.lua`)
- `vim.hl.on_yank()` → `vim.hl.hl_op()` (`after/plugin/colors.lua` — `hl_op` doesn't exist on 0.11)

### Lazy-loading
With treesitter built-in, startup time drops. Consider removing `event = "VeryLazy"`
from lightweight plugins (mini.*) — the guards become unnecessary overhead.
