-- Leaders
vim.g.mapleader=","
vim.g.maplocalleader="\\"

-- Packages
local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  execute 'packadd packer.nvim'
end

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

require('packer').startup(function()
  use 'wbthomason/packer.nvim' -- Packer can manage itself
  use 'VundleVim/Vundle.vim'
  use 'tpope/vim-fugitive'
  use 'tpope/vim-surround'
  use 'Chiel92/vim-autoformat'
  use 'tpope/vim-commentary'
  use 'junegunn/goyo.vim'
  use 'junegunn/limelight.vim'
  -- use 'junegunn/fzf', { 'do': { -> fzf#install() } } 
  -- use '/usr/local/opt/fzf' -- Fuzzy matching, par 1
  use {'junegunn/fzf', dir = '~/.fzf', run = './install --all' }
  use 'junegunn/fzf.vim'                   -- Fuzzy matching, part 2
  use 'leafgarland/typescript-vim'
  use 'tpope/vim-cucumber'
  use 'inkarkat/vim-ingo-library'
  use 'inkarkat/vim-mark'
  use 'neovim/nvim-lspconfig'
  use 'nvim-lua/lsp_extensions.nvim'
  use 'nvim-lua/completion-nvim'
  use 'nvim-lua/popup.nvim'
  use 'nvim-lua/plenary.nvim'
  use 'nvim-telescope/telescope.nvim'
  use 'hrsh7th/nvim-compe'
  use 'folke/tokyonight.nvim'

  -- File Explorer
  use 'kyazdani42/nvim-web-devicons' -- for file icons
  -- use 'kyazdani42/nvim-tree.lua'
end)

local nvim_lsp = require('lspconfig')
local on_attach = function(client, bufnr)

  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings
  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  elseif client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  end
  
  -- Set autocommands conditional on server_capabilities
  --[[
  if client.resolved_capabilities.document_highlight then
    require('lspconfig').util.nvim_multiline_command [[
      :hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
      :hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
      :hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
      augroup lsp_document_highlight
        autocmd!
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
  ] ] -- ?
  end
  --]]
end

-- Use a loop to conveniently both setup defined servers 
-- and map buffer local keybindings when the language server attaches
local servers = { "pyright", "rust_analyzer", "tsserver" }
for _, lsp in ipairs(servers) do
  if lsp == "rust_analyzer" then
    nvim_lsp[lsp].setup ({
      on_attach = on_attach,
      settings = {
        ["rust-analyzer"] = {
            assist = {
                importMergeBehavior = "last",
                importPrefix = "by_self",
            },
            cargo = {
                loadOutDirsFromCheck = true
            },
            diagnostics = { disabled = {"unresolved-proc-macro"} },
            procMacro = {
                enable = true
            },
        }
     }
  })
  else 
    nvim_lsp[lsp].setup { on_attach = on_attach }
  end
end


--[[ Enable diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = true,
    signs = true,
    update_in_insert = true,
  }
)
--]]

local nvim_exec = vim.api.nvim_exec

nvim_exec("command! Scratch lua require'tools'.makeScratch()", false)
nvim_exec("command! ResetLua lua require'unrequire'.unrequire'tools'", false)



-- Autosave as you type - TODO fix newbuf
-- nvim_exec("autocmd TextChanged,TextChangedI <buffer> silent write", false)


-- Whitespace
vim.o.wrap = false
vim.o.smartindent = true
vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.wo.number = true

-- Mouse
vim.o.mouse = "a"

-- Remove tildes for empty lines
nvim_exec("set fcs=eob:\\ ", false)

-- Searching
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.incsearch = true

-- No swap files
vim.g.swapfile = false
vim.g.backup = false
vim.g.writebackup = false

-- Tab complete
vim.g.wildmenu = true
vim.g.wildmode = "longest,list,full"

-- Raise Number of Tabs Limit
vim.g.tabpagemax = 50


-- Set completeopt to have a better completion experience
-- :help completeopt
-- menuone: popup even when there's only one match
-- noinsert: Do not insert text until a selection is made
-- noselect: Do not select, force user to select one from the menu
vim.g.completeopt="menuone,noselect"

-- Avoid showing messages when using completion
vim.g.shortmess = vim.o.shortmess .. "c"

-- Do not store global and local values in a session
-- set ssop-=options    

-- Remove annoying beep and flash from errors:
-- vb stands for visual bells and overwrites the eb (errorbells)
-- t_vb stores the code for visual bells (default is flash the screen)
-- setting it to nothing makes it do nothing; success!... however,
-- clearing the code needs to be done once the gui is loaded
vim.g.eb = false
vim.g.vb = false

-- Increase cmd buffer window height
vim.g.cmdheight = 2

-- Because we are lazy
vim.api.nvim_set_keymap('n', ';', ':', { noremap = true, silent = false })

-- Shift backspace works as backspace
vim.api.nvim_set_keymap('i', '<S><Del>', '<BS>', { noremap = true, silent = true })

-- Terminal
vim.api.nvim_set_keymap('t', '<C-h>', '<C-\\><C-n><C-w>h', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<C-j>', '<C-\\><C-n><C-w>j', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<C-k>', '<C-\\><C-n><C-w>k', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<C-l>', '<C-\\><C-n><C-w>l', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', { noremap = true, silent = true })
-- nvim_exec("au FileType fzf tunmap <Esc>", false)

-- Highlighter
vim.api.nvim_set_keymap('n', '<leader>l', ':MarkClear<cr>', { noremap = true, silent = true })

-- Quick vimrc edit
local function vsplit_vimrc()
    nvim_exec(':vsplit %MYVIMRC')
end
vim.api.nvim_set_keymap('n', '<leader>ev', ':vsplit $MYVIMRC<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sv', ':luafile $MYVIMRC<cr>', { noremap = true, silent = true })

vim.o.shiftround = true -- round indent to a multiple of shiftwidth

-- Search using fzf
vim.api.nvim_set_keymap('n', '<C-p>', ':Files<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-g>', ':Rg<cr>', { noremap = true, silent = true })


local function t(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

-- Use <Tab> and <S-Tab> to navigate through popup menu
function _G.smart_tab()
    return vim.fn.pumvisible() == 1 and t'<C-n>' or t'<Tab>'
end
function _G.smart_tab_back()
    return vim.fn.pumvisible() == 1 and t'<C-p>' or t'<S-Tab>'
end

vim.api.nvim_set_keymap('i', '<Tab>', 'v:lua.smart_tab()', {expr = true, noremap = true})
vim.api.nvim_set_keymap('i', '<S-Tab>', 'v:lua.smart_tab()', {expr = true, noremap = true})

-- Extended Mark pallete
vim.g.mwDefaultHighlightingPalette='extended'

-- Tabs
vim.api.nvim_set_keymap('n', '<C-T>', ':tabe<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<S-H>', ':tabp<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<S-L>', ':tabn<cr>', { noremap = true, silent = true })

-- Clear highlight with Esc
vim.api.nvim_set_keymap('n', '<ESC>', ':noh<cr>', { noremap = true, silent = false })

-- use <Tab> as trigger keys
local check_back_space = function()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  --elseif vim.fn.call("vsnip#available", {1}) == 1 then
  --  return t "<Plug>(vsnip-expand-or-jump)"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn['compe#complete']()
  end
end
_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  --elseif vim.fn.call("vsnip#jumpable", {-1}) == 1 then
  --  return t "<Plug>(vsnip-jump-prev)"
  else
    return t "<S-Tab>"
  end
end

vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})

require'compe'.setup {
  enabled = true,
  source = {
    path = true,
    nvim_lsp = true,
    nvim_lua = true,
    --buffer = true,
  },
} 

-- Color theme
vim.g.tokyonight_style = "night"
vim.g.tokyonight_italic_functions = true
vim.g.tokyonight_colors = { comment = "#c14daa", fg_gutter = "#5455b5" }

vim.cmd[[colorscheme tokyonight]]

-- Search using fzf with ripgrep
vim.env.FZF_DEFAULT_COMMAND = 'rg --files'
