" Configuration file for Neovim, Neovim-Qt, Vim, Vim-GTK
" Andrew Bettison <andrew@iverin.com.au>

" GUI

set title                       " window title is file name
set mouse=                      " no mouse

set guioptions-=m               " no menu bar
set guioptions-=t               " no tearoff menus
set guioptions-=T               " no toolbar (Win32 only)
set guioptions-=r               " no right hand scrollbar
set guioptions-=R               " no right hand scrollbar on vertically split windows
set guioptions-=l               " no left hand scrollbar
set guioptions-=L               " no left hand scrollbar on vertically split windows

if has('nvim')
  set guifont=Inconsolata:h13
else
  set guifont=Inconsolata\ 12
endif

" A sensible colour scheme with an off-white background:
if has('nvim-0.5')
  colorscheme vim " Neovim 0.5 stopped using Vim colours as default
endif
set background=light
highlight Normal guibg=#ffffcc

" Readable colours on a pale background:
"highlight Search 	term=reverse	ctermbg=7	guibg=Yellow
"highlight DiffAdd 	term=reverse	ctermfg=white
"highlight DiffChange 	term=reverse	ctermfg=white

" Readable colours on a black background:
"highlight Search 	term=reverse	ctermbg=3	guibg=Yellow
"highlight DiffAdd 	term=reverse	ctermfg=white
"highlight DiffChange 	term=reverse	ctermfg=white

" INTERACTION

set nocompatible                " no Vi compatibility
set autoindent
set nostartofline               " stay in current column when jumping
set backspace=indent,eol,start  " backspace over anything
set joinspaces                  " two spaces between sentences when joining lines
set noshiftround                " do not set indent to nearest shiftwidth on << and >>
set ruler                       " show ruler with cursor position
set showcmd		        " show (partial) command in status line.
set incsearch		        " incremental search
set hlsearch		        " highlight found strings
set showmatch                   " show matching brackets for the last ')'
set showmode                    " show insert/replace/visual mode in ruler
set nowrap                      " long lines fall off display
set history=1000                " remember this many ":" commands and search patterns
setlocal display+=lastline      " show incomplete lines

let mapleader = "\\"
let maplocalleader = ""

" Enable syntax highlighting:
if has("syntax")
  syntax on
endif

" Highlight whitespace at the end of lines:
highlight WhitespaceEOL ctermbg=blue guibg=blue
match WhitespaceEOL /\s\+$/

" FILE HANDLING

" Enable modelines (beware of trojan horses!):
set modeline
set modelines=5

" Put swap files into hidden subdirectories, in the file's own directory only
" as a last resort:
set directory=./.vimtmp,~/.vimtmp//,/var/tmp//,/tmp//,.

" Do not make backup files:
set nobackup

" Deprioritise the following suffixes when autocompleting filenames:
set suffixes=.bak,~,.swp,
set suffixes+=.o,.a,.out
set suffixes+=.gz,.bz2,.xz,.tar,.zip,.tgz
set suffixes+=.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.toc

" Tab management:
nmap <C-S-PageUp> :tabmove -1<CR>
nmap <C-S-PageDown> :tabmove +1<CR>
nmap <Leader>] :exec 'tab' 'tjump' expand('<cword>')<CR>
nmap <Leader>[ :call <SID>closeCurrentTab()<CR>
function s:closeCurrentTab()
  let tn = tabpagenr()
  let tl = tabpagenr('$')
  tabclose
  if tn != 1 && tn != tl
  	tabprev
  endif
endf

" SEARCHING

set grepprg=vim-grep\ -Hn\ $*
command -nargs=1 Grep call g:Grep(<q-args>)
command -nargs=1 Grepword call g:Grepword(<q-args>)
nmap <Leader>== *:lgrep '-w' '<cword>'<CR>:lopen<CR>:lrewind<CR>n
nmap <Leader>=+ :tab split<CR>*:lgrep '-w' '<cword>'<CR>:lopen<CR>:lrewind<CR>n
nmap ]= :lnext<CR>
nmap [= :lprevious<CR>
nmap <Leader>=] :lnext<CR>
nmap <Leader>=[ :lprevious<CR>
nmap <Leader>=} :lnfile<CR>
nmap <Leader>={ :lpfile<CR>
nmap <Leader>=_ :ll<CR>
nmap <Leader>=^ :lrewind<CR>
nmap <Leader>=$ :llast<CR>
nmap <Leader>=o :lopen<CR>
nmap <Leader>=c :lclose<CR>

function g:Grep(text)
  exe 'lgrep' shellescape(a:text)
  lopen
  lrewind
endfunc

function g:Grepword(text)
  exe 'lgrep' '-w' shellescape(a:text)
  lopen
  lrewind
endfunc

" Arrow keys move on display lines not physical lines
noremap  <buffer> <silent> <Up>   gk
noremap  <buffer> <silent> <Down> gj
noremap  <buffer> <silent> <Home> g<Home>
noremap  <buffer> <silent> <End>  g<End>
inoremap <buffer> <silent> <Up>   <C-o>gk
inoremap <buffer> <silent> <Down> <C-o>gj
inoremap <buffer> <silent> <Home> <C-o>g<Home>
inoremap <buffer> <silent> <End>  <C-o>g<End>

" FORMATTING

" No tabs in source files, code indent is 4 spaces:
set tabstop=8
set softtabstop=4
set shiftwidth=4
set expandtab

" Format numbered lists in block comments:
set formatoptions+=n
let &formatlistpat='^\s*\((\?\d\+)\|(\?[A-Za-z])\|\[\?\d\+]\|{\?\d\+}\|\d\+[.:]\|\d\d\?:\d\d\s*\W\?\|[-*]\)\s\+'

augroup filetype
  " Quixote PTL
  au BufRead *.ptl set filetype=python
augroup END

" DEV PROFILE

" If the VIMRC_SWITCH env var is set, then use that vimrc file instead
if exists('$VIMRC_SWITCH') && filereadable($VIMRC_SWITCH)
  source $VIMRC_SWITCH
  finish
endif

" PLUGINS

" Load all plugins managed by vim-plug
call plug#begin()
Plug '~/.vim/package/vim-delta'
Plug 'junegunn/vim-easy-align'
Plug 'sophacles/vim-bundle-mako'
Plug 'rust-lang/rust.vim'
call plug#end()

" Rust settings

let g:cargo_makeprg_params = 'build'
let g:rustfmt_autosave = 1

"setlocal spell spelllang=en_au
