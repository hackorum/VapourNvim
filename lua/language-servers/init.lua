local lspconfig = Vapour.utils.plugins.require('lspconfig')

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- Language servers

require'lspconfig'.bashls.setup {}
require'lspconfig'.cssls.setup {}
require'lspconfig'.html.setup {capabilities = capabilities}
require'lspconfig'.tsserver.setup {}
require'lspconfig'.pyright.setup {}
require'lspconfig'.jedi_language_server.setup {}
require'lspconfig'.vimls.setup {}
require'lspconfig'.yamlls.setup {}
require'lspconfig'.solargraph.setup {}
require'lspconfig'.vuels.setup {}
require'lspconfig'.phpactor.setup {}
require'lspconfig'.jsonls.setup {
    commands = {
        Format = {
            function()
                vim.lsp.buf.range_formatting({}, {0, 0}, {vim.fn.line("$"), 0})
            end
        }
    }
}

require'lspconfig'.gopls.setup {cmd = {"gopls", "serve"}, settings = {gopls = {analyses = {unusedparams = true}, staticcheck = true}}}

-- Lua is a little bit different

USER = vim.fn.expand('$USER')

local sumneko_root_path = ""
local sumneko_binary = ""

if vim.fn.has("mac") == 1 then
    sumneko_root_path = "/Users/" .. USER .. "/.config/nvim/ls/lua-language-server"
    sumneko_binary = "/Users/" .. USER .. "/.config/nvim/ls/lua-language-server/bin/macOS/lua-language-server"
elseif vim.fn.has("unix") == 1 then
    sumneko_root_path = "/home/" .. USER .. "/.config/nvim/ls/lua-language-server"
    sumneko_binary = "/home/" .. USER .. "/.config/nvim/ls/lua-language-server/bin/Linux/lua-language-server"
elseif vim.fn.has("win32") == 1 then
    sumneko_root_path = "C:\\Users" .. USER .. "\\.config/nvim\\ls\\lua-language-server"
    sumneko_binary = "C:\\Users" .. USER .. "\\.config\\nvim\\ls\\lua-language-server\\bin\\Windows\\lua-language-server"
else
    print("Unsupported system for sumneko")
end

require'lspconfig'.sumneko_lua.setup {
    cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"},
    settings = {
        Lua = {
            runtime = {version = 'LuaJIT', path = vim.split(package.path, ';')},
            diagnostics = {globals = {'vim'}},
            workspace = {
                library = {[vim.fn.expand('$VIMRUNTIME/lua')] = true, [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true},
                preloadFileSize = 450
            }
        }
    }
}

-- Diagnostics

vim.fn.sign_define("LspDiagnosticsSignError", {texthl = "LspDiagnosticsSignError", text = "", numhl = "LspDiagnosticsSignError"})
vim.fn.sign_define("LspDiagnosticsSignWarning", {texthl = "LspDiagnosticsSignWarning", text = "", numhl = "LspDiagnosticsSignWarning"})
vim.fn.sign_define("LspDiagnosticsSignInformation", {texthl = "LspDiagnosticsSignInformation", text = "", numhl = "LspDiagnosticsSignInformation"})
vim.fn.sign_define("LspDiagnosticsSignHint", {texthl = "LspDiagnosticsSignHint", text = "", numhl = "LspDiagnosticsSignHint"})

-- Some Keybindings for lsp

vim.api.nvim_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', 'ca', ':Lspsaga code_action<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('v', 'ca', ':Lspsaga range_code_action<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', 'K', ':Lspsaga hover_doc<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<C-p>', ':Lspsaga diagnostic_jump_prev<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<C-f>', '<cmd>lua require(\'lspsaga.action\').smart_scroll_with_saga(1)<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<C-b>', '<cmd>lua require(\'lspsaga.action\').smart_scroll_with_saga(-1)<CR>', {noremap = true, silent = true})

-- Show icons in autocomplete

require('vim.lsp.protocol').CompletionItemKind = {
    '', '', 'ƒ', ' ', '', '', '', 'ﰮ', '', '', '', '', '了', ' ', '﬌ ', ' ', ' ', '', ' ', ' ',
    ' ', ' ', '', '', '<>'
}
