set shiftwidth=2
set softtabstop=2
set tabstop=2
set autoindent
set nowrap
set ignorecase smartcase
set hidden
set ruler
set showcmd
set visualbell
set colorcolumn=96
set noshowmode
set laststatus=2

call plug#begin('~/.local/share/nvim/site/plugins')

Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'airblade/vim-gitgutter'
Plug 'fatih/vim-go'
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'prettier/vim-prettier'
Plug 'othree/html5.vim'
Plug 'yggdroot/indentline'
Plug 'cakebaker/scss-syntax.vim'
Plug 'itchyny/lightline.vim'
Plug 'joshdick/onedark.vim'

call plug#end()

colorscheme onedark

let g:prettier#autoformat = 0
let g:prettier#config#semi = 'false'
let g:prettier#config#trailing_comma = 'all'
autocmd BufWritePre *.js,*.jsx,*.ts,*.tsx,*.css,*.scss,*.json,*.graphql,*.md PrettierAsync

imap jj <Esc>

