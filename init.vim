set nocompatible
set showmatch
set ignorecase
set mouse=v
set hlsearch
set incsearch
set tabstop=4
set softtabstop=4
set expandtab
set shiftwidth=4
set autoindent
set number
set relativenumber
set nowrap
set ruler
set noshowmode
set sidescroll=6
set hidden
set confirm
set autowriteall
set wildmenu wildmode=full
set splitright
set splitbelow
filetype on
filetype plugin indent on
syntax on
set mouse=a
set clipboard=unnamedplus
filetype plugin on
set ttyfast

let mapleader=" "
nnoremap <silent> <leader>ec :e $MYVIMRC<CR>
nnoremap <silent> <leader>sc :source $MYVIMRC<CR>
nnoremap <silent> <leader>w :wa<CR>
nnoremap <silent> <leader>cs :let @/ = ""<CR>
inoremap jj <ESC>
nnoremap <silent> <leader>bd :bd<CR>

call plug#begin("~/.vim/plugged")

Plug 'preservim/nerdtree'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'morhetz/gruvbox'
"Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
"Plug 'junegunn/fzf.vim'
Plug 'neovim/nvim-lspconfig'
Plug 'tami5/lspsaga.nvim'
Plug 'folke/lsp-colors.nvim'
Plug 'dense-analysis/ale'
Plug 'OmniSharp/omnisharp-vim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/async.vim'
Plug 'runoshun/tscompletejob'
Plug 'prabirshrestha/asyncomplete-tscompletejob.vim'
Plug 'puremourning/vimspector'
Plug 'vim-test/vim-test'
Plug 'github/copilot.vim'

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'antoinemadec/FixCursorHold.nvim'
Plug 'nvim-neotest/neotest'
Plug 'nvim-neotest/neotest-vim-test'

Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }
Plug 'kyazdani42/nvim-web-devicons'

call plug#end()

" gruvbox
set background=dark
colorscheme gruvbox
highlight Normal ctermbg=NONE

" NerdTree
nnoremap <silent> <leader>t :NERDTreeToggle<CR>

" better keyboard navigation
nnoremap <silent> <leader>sv <C-W>v
nnoremap <silent> <leader>ss <C-W>s
nnoremap <leader>h <C-W>h
nnoremap <leader>j <C-w>j
nnoremap <leader>k <C-w>k
nnoremap <leader>l <C-w>l
nmap <silent> <c-l> :noh<CR>

"vim-test
nnoremap <silent> <leader>tr :TestNearest<CR>
nnoremap <silent> <leader>tf :TestFile<CR>
nnoremap <silent> <leader>ta :TestSuite<CR>
nnoremap <silent> <leader>tt :TestLast<CR>

lua << EOF
require("neotest").setup({
  adapters = {
    require("neotest-vim-test")
  },
})
EOF

nnoremap <silent> <leader>tn <Cmd>lua require("neotest").run.run()<CR>

" telescope
nnoremap <silent> <leader>p :Telescope find_files<CR>
nnoremap <silent> <leader>pp :Telescope live_grep<CR>

" vimspector
let g:vimspector_enable_mappings='HUMAN'
nnoremap <silent> <leader>vr :VimspectorReset<CR>

" lsp
lua << EOF
local nvim_lsp = require('lspconfig')

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  local opts = { noremap = true, silent = true }

  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', '<leader>=', '<Cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

nvim_lsp.tsserver.setup {
  on_attach = on_attach,
  filetypes = { "typescript", "typescriptreact", "typescript.tsx" }
}
EOF

call asyncomplete#register_source(asyncomplete#sources#tscompletejob#get_source_options({
    \ 'name': 'tscompletejob',
    \ 'allowlist': ['typescript'],
    \ 'completor': function('asyncomplete#sources#tscompletejob#completor'),
    \ }))

" autocomplete
set completeopt=menuone,noinsert,noselect,preview
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <CR> pumvisible() ? asyncomplete#close_popup() : "\<CR>"
let g:asyncomplete_auto_popup = 1
let g:asyncomplete_auto_completeopt = 0
let g:asyncomplete_force_refresh_on_context_changed = 1
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

" ALE
let g:ale_linters = { 'cs': ['OmniSharp'] }

" lspsaga
lua << EOF

local saga = require('lspsaga')

saga.init_lsp_saga {
    border_style = "round",
    debug = true
}

EOF

nnoremap <silent> <C-j> :Lspsaga diagnostic_jump_next<CR>
nnoremap <silent> <leader>gh :Lspsaga hover_doc<CR>
inoremap <silent> <C-f> <cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>
inoremap <silent> <C-f> <cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>
nnoremap <silent> <leader>fu :Lspsaga lsp_finder<CR>
nnoremap <silent> <leader>gp :Lspsaga preview_definition<CR>
nnoremap <silent> <leader><leader> :Lspsaga code_action<CR>
vnoremap <silent> <leader><leader> :<C-U>Lspsaga range_code_action<CR>
nnoremap <silent> <F2> :Lspsaga rename<CR>

" OmniSharp
let g:OmniSharp_server_use_net6 = 1
"if has('patch-8.1.1880')
"    set completeopt = longest,menuone,popuphidden
"    set completepopup = highlight:Pmenu,border:off
"else
"    set completeopt = longest,menuone,preview
"    set previewheight = 5
"endif

augroup omnisharp_commands
    autocmd!

    autocmd FileType cs nmap <silent> <buffer> gd <Plug>(omnisharp_go_to_definition)
    autocmd FileType cs nmap <silent> <buffer> <leader>fu <Plug>(omnisharp_find_usages)
    autocmd FileType cs nmap <silent> <buffer> <leader>fi <Plug>(omnisharp_find_implementations)
    autocmd FileType cs nmap <silent> <buffer> <leader>pd <Plug>(omnisharp_preview_definition)
    autocmd FileType cs nmap <silent> <buffer> <leader>pi <Plug>(omnisharp_preview_implementations)
    autocmd FileType cs nmap <silent> <buffer> <leader>tl <Plug>(omnisharp_type_lookup)
    autocmd FileType cs nmap <silent> <buffer> <leader>gh <Plug>(omnisharp_documentation)
    autocmd FileType cs nmap <silent> <buffer> <leader>fs <Plug>(omnisharp_find_symbol)
    autocmd FileType cs nmap <silent> <buffer> <leader>o <Plug>(omnisharp_fix_usings)
    autocmd FileType cs nmap <silent> <buffer> <leader><leader> <Plug>(omnisharp_code_actions)
    autocmd FileType cs xmap <silent> <buffer> <leader><leader> <Plug>(omnisharp_code_actions)
    autocmd FileType cs nmap <silent> <buffer> <leader>= <Plug>(omnisharp_code_format)
    autocmd FileType cs nmap <silent> <buffer> <F2> <Plug>(omnisharp_rename)
augroup END
