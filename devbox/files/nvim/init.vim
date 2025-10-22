set expandtab
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
set encoding=utf-8
set fileencoding=utf-8
set backspace=indent,eol,start
set number

call plug#begin('~/.local/share/nvim/site/plugins')

Plug 'preservim/nerdtree'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'airblade/vim-gitgutter'
Plug 'fatih/vim-go'
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'prettier/vim-prettier'
Plug 'othree/html5.vim'
Plug 'alvan/vim-closetag'
Plug 'yggdroot/indentline'
Plug 'cakebaker/scss-syntax.vim'
Plug 'joshdick/onedark.vim'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'vim-airline/vim-airline'
Plug 'rust-lang/rust.vim'
Plug 'dense-analysis/ale'

call plug#end()

colorscheme dracula

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tmuxline#enabled = 1

:nnoremap <C-g> :NERDTreeToggle<CR>

let g:netrw_liststyle = 3
let g:netrw_banner = 0
let g:netrw_browse_split = 4
let g:netrw_winsize = 20

let g:go_metalinter_autosave = 1
let g:go_fmt_command = "goimports"
let g:go_rename_command = "gopls"     
let g:go_auto_type_info = 1
let g:go_highlight_types = 1
let g:go_highlight_functions = 1
let g:go_highlight_fields = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_operators = 1
let g:go_auto_sameids = 1

let g:ale_fixers = {
\  '*': ['remove_trailing_lines', 'trim_whitespace'],
\  'javascript': ['prettier'],
\  'css': ['prettier'],
\  'json': ['jq'],
\}
let b:ale_linters = ['eslint']

"au filetype go inoremap <buffer> . .<C-x><C-o>
autocmd FileType go nmap <leader>t  <Plug>(go-test)
autocmd FileType go nmap <leader>b  <Plug>(go-build)
autocmd FileType go nmap <leader>r  <Plug>(go-run)
autocmd FileType go nmap <Leader>c <Plug>(go-coverage-toggle)

let g:prettier#autoformat = 1
let g:prettier#autoformat_require_pragma = 0
let g:prettier#exec_cmd_async = 1

let g:prettier#config#semi = 'false'
autocmd InsertLeave *.js,*.jsx,*.ts,*.tsx,*.css,*.scss,*.json,*.md,*.yaml,*.html PrettierAsync

let g:rustfmt_autosave = 1

let mapleader = "'"

imap jj <Esc>
map <leader>e :Vex<cr>

nnoremap <Leader>l :ls<CR>
nnoremap <Leader>p :bp<CR>
nnoremap <Leader>n :bn<CR>
nnoremap <Leader>g :b#<CR>
nnoremap <Leader>1 :1b<CR>
nnoremap <Leader>2 :2b<CR>
nnoremap <Leader>3 :3b<CR>
nnoremap <Leader>4 :4b<CR>
nnoremap <Leader>5 :5b<CR>
nnoremap <Leader>6 :6b<CR>
nnoremap <Leader>7 :7b<CR>
nnoremap <Leader>8 :8b<CR>
nnoremap <Leader>9 :9b<CR>
nnoremap <Leader>0 :10b<CR>

