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
set encoding=utf-8
set fileencoding=utf-8
set backspace=indent,eol,start

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
Plug 'itchyny/lightline.vim'
Plug 'mengelbrecht/lightline-bufferline'
Plug 'joshdick/onedark.vim'

call plug#end()

colorscheme onedark

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

au filetype go inoremap <buffer> . .<C-x><C-o>
autocmd FileType go nmap <leader>t  <Plug>(go-test)
autocmd FileType go nmap <leader>b  <Plug>(go-build)
autocmd FileType go nmap <leader>r  <Plug>(go-run)
autocmd FileType go nmap <Leader>c <Plug>(go-coverage-toggle)

let g:prettier#autoformat = 1
let g:prettier#autoformat_require_pragma = 0
let g:prettier#exec_cmd_async = 1

let g:prettier#config#semi = 'false'
autocmd InsertLeave *.js,*.jsx,*.ts,*.tsx,*.css,*.scss,*.json,*.md,*.yaml,*.html PrettierAsync

let g:lightline#bufferline#show_number  = 1
let g:lightline#bufferline#shorten_path = 0
let g:lightline#bufferline#unnamed      = '[No Name]'
let g:lightline#bufferline#filename_modifier = ':t'

let g:lightline                  = {}
let g:lightline.active = {'left': [ [ 'mode', 'paste' ], [ 'gitbranch', 'readonly', 'modified' ], [ 'buffers' ] ]}
let g:lightline.component_expand = {'buffers': 'lightline#bufferline#buffers'}
let g:lightline.component_type   = {'buffers': 'tabsel'}
let g:lightline.component_function = {'gitbranch': 'FugitiveHead'}

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

