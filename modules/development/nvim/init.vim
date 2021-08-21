" Copyright Mazurel 2020
 

" My coc plugins:
" CocInstall coc-tsserver coc-json coc-clangd coc-rls

" Settings
set number
set relativenumber
set clipboard=unnamedplus

set tabstop=4
set shiftwidth=4
set expandtab

colorscheme gruvbox
set background=dark

" Better find
set path+=**
set wildmenu

let g:clang_format#style_options = {
            \ "AccessModifierOffset" : -4,
            \ "AllowShortIfStatementsOnASingleLine" : "true" }

" Vim-slime settings
let g:slime_target = "neovim"

" Key bindings
let mapleader=" "

" File reloads
nmap <leader>vr :so%<CR>

" Terminal mappings 
tnoremap <ESC> <C-\><C-n>

" Buffer settings
nmap <leader>bn :bn<CR>
nmap <leader>bp :bp<CR>
nmap <leader>bl :ls<CR>
nmap <leader>bb :b#<CR>
nnoremap <leader>bo :ls<CR>:b 
nnoremap <leader>bd :bdelete!<CR>

inoremap <c-p> <Esc>:CtrlP<CR>
nnoremap <c-p> <Esc>:CtrlP<CR>
imap <c-b> <Esc>:CtrlPBuffer<CR>
nmap <c-b> <Esc>:CtrlPBuffer<CR>

" Gitgutter mappings
nmap <silent> N :GitGutterPreviewHunk<CR>
nmap <silent> ]N :GitGutterNextHunk<CR>
nmap <silent> [N :GitGutterPrevHunk<CR>

" Window manipulations 
nmap <leader>w <C-w>

" Quitting
nnoremap <leader>wq :q!<CR>
nnoremap <leader>wd :wq<CR>

nmap <c-s> :w<CR>
imap <c-s> <ESC>:w<CR>a

nmap <leader>Tt :terminal<CR>
nmap <leader>Tn :NERDTree<CR>

" Spell checking 
nmap <leader>se :set spell<CR>
nmap <leader>sd :set spell&<CR>
nmap <leader>sl :set spell spelllang=

" Tabs
nmap <silent> tn :tabn<CR>
nmap <silent> tp :tabp<CR>
nmap to :tabnew<SPACE>

" Snippets
nnoremap <leader>imc i Copyright Mazurel 2021<cr><ESC>
