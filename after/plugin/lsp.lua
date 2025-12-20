---
-- LSP configuration
---
vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP Actions',
    callback = function(event)
        local opts = {buffer = event.buf}

        -- buffer-local keybindings
        -- because they only work if there is an active language server

        vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
        vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
        vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
        vim.keymap.set('n', 'gI', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
        vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
        vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
        vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
        vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
        vim.keymap.set({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
        vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
        vim.keymap.set('n', '<leader>h', '<cmd>LspClangdSwitchSourceHeader<cr>', { desc = 'Switch between Source/Header' })
    end
})

-- Golang autoformat and organize imports
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    local params = vim.lsp.util.make_range_params()
    params.context = {only = {"source.organizeImports"}}
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
    for cid, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
          vim.lsp.util.apply_workspace_edit(r.edit, enc)
        end
      end
    end
    vim.lsp.buf.format({async = false})
  end
})


-- Lua setup 
vim.lsp.config('lua_ls', {
    settings = {
        Lua = {
            -- Supress undefined global variable warnings
            diagnostics = {
                globals = { 'vim' },
            },
            -- Proper path resolution and Neovim API awareness
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
            },
            -- Default neovim lua runtime
            runtime = {
                version = 'LuaJIT',
            },
        },
    },
})


-- Called for each lsp
local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
local default_lsp_setup = function(server)
    vim.lsp.config(server, {
        capabilities = lsp_capabilities,
    })

    -- just to be safe, mason-lspconfig does this automatically anyways
    vim.lsp.enable({ server })
end

---
-- Mason setup
---
require('mason').setup({})
require('mason-lspconfig').setup({
    ensure_installed = { 'lua_ls',
                         'rust_analyzer',
                         'clangd',
                         'cmake',
                         'gopls',
                         'vtsls',
                         'html',
                         'cssls',
                         'docker_language_server',
                         'jsonls' },
    handlers = {
        default_lsp_setup,
    },
})

---
-- Autocompletion setup
---
local cmp = require('cmp')

cmp.setup({
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
    }, {
        { name = 'buffer' },
    })
})

---
-- Autopairs setup
---
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done()
)
