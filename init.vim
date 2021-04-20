"Because we are lazy
nnoremap ;	:
let mapleader=","
let maplocalleader="\\"

lua << EOF

local nvim_exec = vim.api.nvim_exec

nvim_exec("command! Scratch lua require'tools'.makeScratch()", false)
nvim_exec("command! ResetLua lua require'unrequire'.unrequire'tools'", false)

local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  execute 'packadd packer.nvim'
end

-- set colorscheme
nvim_exec("colorscheme delek", false)


-- Autosave as you type - TODO fix newbuf
nvim_exec("autocmd TextChanged,TextChangedI <buffer> silent write", false)


--[[
"set foldmethod=indent
"let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1

"Abbrev
func! Eatchar(pat)
    let c = nr2char(getchar(0))
    return (c =~ a:pat) ? '' : c
endfunc
"augroup RustAbbrev
"    autocmd!
"    autocmd FileType rust :iabbrev <buffer> pri println!("{}", );<Left><C-R>=Eatchar('\s')<CR>
"    autocmd FileType rust :iabbrev <buffer> prid println!("{:?}", );<Left><C-R>=Eatchar('\s')<CR>
"augroup END
--]]

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
vim.o.swapfile = false
vim.o.backup = false
vim.o.writebackup = false

-- Tab complete
vim.o.wildmenu = true
vim.o.wildmode = "longest,list,full"

-- Raise Number of Tabs Limit
vim.o.tabpagemax = 50


-- Set completeopt to have a better completion experience
-- :help completeopt
-- menuone: popup even when there's only one match
-- noinsert: Do not insert text until a selection is made
-- noselect: Do not select, force user to select one from the menu
vim.o.completeopt="menuone,noinsert,noselect"

-- Avoid showing messages when using completion
vim.o.shortmess = vim.o.shortmess .. "c"

-- Do not store global and local values in a session
-- set ssop-=options    

-- Remove annoying beep and flash from errors:
-- vb stands for visual bells and overwrites the eb (errorbells)
-- t_vb stores the code for visual bells (default is flash the screen)
-- setting it to nothing makes it do nothing; success!... however,
-- clearing the code needs to be done once the gui is loaded
vim.o.eb = false
vim.o.vb = false

-- Shift backspace works as backspace
vim.api.nvim_set_keymap('i', '<S><Del>', '<BS>', { noremap = true, silent = true })

-- Terminal
vim.api.nvim_set_keymap('n', '<C-h>', '<C-\\><C-n><C-w>h', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-j>', '<C-\\><C-n><C-w>j', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-k>', '<C-\\><C-n><C-w>k', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-l>', '<C-\\><C-n><C-w>l', { noremap = true, silent = true })
nvim_exec("au TermOpen * tnoremap <Esc> <C-\\><C-n>", false)
nvim_exec("au FileType fzf tunmap <Esc>", false)

-- Highlighter
vim.api.nvim_set_keymap('n', '<leader>l', ':MarkClear', { noremap = true, silent = true })

-- Quick vimrc edit
local function vsplit_vimrc()
    nvim_exec(':vsplit %MYVIMRC')
end
vim.api.nvim_set_keymap('n', '<leader>ev', ':vsplit $MYVIMRC<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sv', ':source $MYVIMRC<cr>', { noremap = true, silent = true })

-- "Common sense options" - aka things I like
vim.o.hlsearch = true -- highlight search results
vim.o.ruler = true -- show line number and row number
vim.o.showcmd = true -- show selected area size
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
EOF


"Do not expand tabs for Makefiles... they don't like that
let _curfile = expand("%:t")
if _curfile =~ "Makefile" || _curfile =~ "makefile" || _curfile =~ ".*\.mk" || _curfile =~ "rules"
set noexpandtab
endif

"Search using fzf
let $FZF_DEFAULT_COMMAND = 'rg --files --hidden'



"Maps
nnoremap <C-T>	:tabe<CR>
nnoremap <S-H>	:tabp<CR>
nnoremap <S-L>	:tabn<CR>
nnoremap <ESC>	:noh<CR>

set hidden
set updatetime=300
set cmdheight=2
set shortmess+=c

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif


"Highlighter
"nnoremap <leader>l :MarkClear<CR>

"Quick vimrc edit
"nnoremap <leader>ev :vsplit $MYVIMRC<cr>
"nnoremap <leader>sv :source $MYVIMRC<cr>


"Language integration
"noremap <F9>	:split<CR><C-w>j: 

"Splits movement
"nnoremap <A-h> <C-w>h
"nnoremap <A-j> <C-w>j
"nnoremap <A-k> <C-w>k
"nnoremap <A-l> <C-w>l

"Deoplete
"inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

"Shift backspace works as backspace
"inoremap <S-DEL> <BS>

"C"Unix delete fix
set backspace=indent,eol,start


"Set spacing for ocaml
augroup Ocaml
    autocmd!
    autocmd FileType ocaml setlocal shiftwidth=2 tabstop=2
augroup END



"Install Plug if not present
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

"Plugins using Plug
call plug#begin('~/.vim/plugged')
Plug 'VundleVim/Vundle.vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'Chiel92/vim-autoformat'
"Plug 'Shougo/deoplete.nvim'
Plug 'tpope/vim-commentary'
"Plug 'carlitux/deoplete-ternjs', { 'do': 'npm install -g tern' }
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } " Fuzzy matching, par 1
Plug 'junegunn/fzf.vim'                   " Fuzzy matching, part 2
Plug 'leafgarland/typescript-vim'
Plug 'tpope/vim-cucumber'
Plug 'inkarkat/vim-ingo-library'
Plug 'inkarkat/vim-mark'
"Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/lsp_extensions.nvim'
Plug 'nvim-lua/completion-nvim'
"" Telescope.nvim
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" File Explorer
Plug 'kyazdani42/nvim-web-devicons' " for file icons
" Plug 'kyazdani42/nvim-tree.lua'


call plug#end()


"Extended Mark pallete
let g:mwDefaultHighlightingPalette='extended'

lua << EOF

local nvim_lsp = require('lspconfig')
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
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
    ]]
  end
end

-- Use a loop to conveniently both setup defined servers 
-- and map buffer local keybindings when the language server attaches
local servers = { "pyright", "rust_analyzer", "tsserver" }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup { on_attach = on_attach }
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

EOF

" Use <Tab> and <S-Tab> to navigate through popup menu
"inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
"inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" use <Tab> as trigger keys
imap <Tab> <Plug>(completion_smart_tab)
imap <S-Tab> <Plug>(completion_smart_s_tab)
