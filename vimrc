" Configuration file for vim/gvim
" Andrew Bettison <andrew@iverin.com.au>

if exists("g:loaded_vimrc_andrewb") || &cp
  finish
endif
let g:loaded_vimrc_andrewb = 1

" GUI preferences

set title               " Set the window title to the file name
set guifont=Monospace\ 10

" A sensible colour scheme with an off-white background
silent highlight clear Normal
silent highlight default Normal
silent highlight Normal guibg=#ffffcc

" Readable colours on a pale background
"highlight Search 	term=reverse	ctermbg=7	guibg=Yellow
"highlight DiffAdd 	term=reverse	ctermfg=white
"highlight DiffChange 	term=reverse	ctermfg=white

" Readable colours on a black background
"highlight Search 	term=reverse	ctermbg=3	guibg=Yellow
"highlight DiffAdd 	term=reverse	ctermfg=white
"highlight DiffChange 	term=reverse	ctermfg=white

" Start with the system-wide settings
if filereadable('/etc/vim/vimrc')
  source /etc/vim/vimrc
endif

" Various user interface preferences

set nocompatible        " No Vi compatibility

set mouse=              " No mouse support

set guioptions-=m       " No menu bar
set guioptions-=t       " No tearoff menus
set guioptions-=T       " No toolbar
set guioptions-=r       " No right hand scrollbar
set guioptions-=R       " No right hand scrollbar on vertically split windows
set guioptions-=l       " No left hand scrollbar
set guioptions-=L       " No left hand scrollbar on vertically split windows

set ruler               " Show ruler with cursor position
set showcmd		" Show (partial) command in status line.
set incsearch		" Incremental search
set hlsearch		" Highlight found strings
set showmatch           " show matching brackets for the last ')'
set showmode            " Snow insert/replace/visual mode in ruler
set nowrap              " Long lines fall off display
set history=100         " Remember this many ":" commands and search patterns
"set nobinary            " Not editing a binary file
let bash_is_sh=1
" ignore the following suffixes when loading files
set suffixes=.bak,.o,.a,.gz,~,.dvi,.tar,.zip

" Various editing preferences

set nostartofline       " Stay in current column when jumping
set backspace=indent,eol,start " Can backspace over anything
set joinspaces          " Two spaces between sentences when joining lines
set shiftround          " Round indent to nearest shiftwidth

" Paste toggle is useful for copying/pasting stuff
" into vim when vim is running in a terminal window
set pastetoggle=<F3>

let mapleader = "\\"
let maplocalleader = ""

" Tab and window mappings
nmap <C-S-PageUp> :tabmove <C-R>=max([0,tabpagenr()-2])<CR><CR>
nmap <C-S-PageDown> :tabmove <C-R>=tabpagenr()<CR><CR>
nmap <Leader>] :exec 'tab' 'tjump' expand('<cword>')<CR>
nmap <Leader>[ :call <SID>closeCurrentTab()<CR>

" Close current tab page and move back to the previous tab
function s:closeCurrentTab()
  let tn = tabpagenr()
  let tl = tabpagenr('$')
  tabclose
  if tn != 1 && tn != tl
  	tabprev
  endif
endf

" Searching commands
" Set grepprg to get better behaviour
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

" Set up cscope the way we use it
if has("cscope") && $CSCOPE_DB != ""
  cscope add $CSCOPE_DB
  set cscopeverbose  	" Show message when any other cscope db added
  set cscoperelative	" Cscope.out filenames are relative to cscope.out
  set cscopetag		" Tag jump commands include cscope search
  set csto=0		" Look up cscope before ctags
  " Cscope mappings:
  "   s   "symbol"	find all references to the token under cursor
  "   g   "global"	find global definition(s) of the token under cursor
  "   c   "calls"	find all calls to the function name under cursor
  "   t   "text"	find all instances of the text under cursor
  "   e   "egrep"	egrep search for the word under cursor
  "   f   "file"	open the filename under cursor
  "   i   "includes"	find files that include the filename under cursor
  "   d   "called"	find functions that function under cursor calls
  " To open in new tab:
  nmap <Leader>_s :tab cscope find s <C-R>=expand("<cword>")<CR><CR>	
  nmap <Leader>_g :tab cscope find g <C-R>=expand("<cword>")<CR><CR>	
  nmap <Leader>_c :tab cscope find c <C-R>=expand("<cword>")<CR><CR>	
  nmap <Leader>_t :tab cscope find t <C-R>=expand("<cword>")<CR><CR>	
  nmap <Leader>_e :tab cscope find e <C-R>=expand("<cword>")<CR><CR>	
  nmap <Leader>_f :tab cscope find f <C-R>=expand("<cfile>")<CR><CR>	
  nmap <Leader>_i :tab cscope find i ^<C-R>=expand("<cfile>")<CR>$<CR>
  nmap <Leader>_d :tab cscope find d <C-R>=expand("<cword>")<CR><CR>	
  " To jump in current window:
  nmap <LocalLeader>_s :cscope find s <C-R>=expand("<cword>")<CR><CR>	
  nmap <LocalLeader>_g :cscope find g <C-R>=expand("<cword>")<CR><CR>	
  nmap <LocalLeader>_c :cscope find c <C-R>=expand("<cword>")<CR><CR>	
  nmap <LocalLeader>_t :cscope find t <C-R>=expand("<cword>")<CR><CR>	
  nmap <LocalLeader>_e :cscope find e <C-R>=expand("<cword>")<CR><CR>	
  nmap <LocalLeader>_f :cscope find f <C-R>=expand("<cfile>")<CR><CR>	
  nmap <LocalLeader>_i :cscope find i ^<C-R>=expand("<cfile>")<CR>$<CR>
  nmap <LocalLeader>_d :cscope find d <C-R>=expand("<cword>")<CR><CR>	
endif

" Put swap files into hidden subdirectories, in the file's own directory only
" as a last resort.
set directory=./.vimtmp,~/.vimtmp//,/var/tmp//,/tmp//,.

" Do not make backup files.
set nobackup

" show whitespace at the end of lines
highlight WhitespaceEOL ctermbg=blue guibg=blue
match WhitespaceEOL /\s\+$/

" No tabs in source files, code indent is 4 spaces
set tabstop=8
set softtabstop=4
set shiftwidth=4
set expandtab

" Stop the netrw.vim plugin writing a .netrwhist file into plugin directories that
" pathogen adds to 'runtimepath'
let g:netrw_home = expand('~/.vim')

" Load all plugins managed by Pathogen
exe pathogen#infect()

" Git/Mercurial diff plugin
set runtimepath^=~/src/vim-delta

" Enable syntax highlighting (recommended by Pathogen)
if has("syntax")
  syntax on
endif

" Enable file type indenting (recommended by Pathogen)
if has("autocmd")
 filetype plugin indent on
endif

" Arrow keys move on display lines not physical lines
noremap  <buffer> <silent> <Up>   gk
noremap  <buffer> <silent> <Down> gj
noremap  <buffer> <silent> <Home> g<Home>
noremap  <buffer> <silent> <End>  g<End>
inoremap <buffer> <silent> <Up>   <C-o>gk
inoremap <buffer> <silent> <Down> <C-o>gj
inoremap <buffer> <silent> <Home> <C-o>g<Home>
inoremap <buffer> <silent> <End>  <C-o>g<End>

" Show incomplete lines
setlocal display+=lastline

" C++ development support
" Some C++ header files have no .h or .H extension
fun! DetectCpp()
  if getline(1) =~ '-\*- *[Cc]++ *-\*-'
    set filetype=cpp
  endif
endfun
augroup filetype
  au BufRead * 			call DetectCpp()
augroup END

" If the VIMRC_SWITCH env var is set, then use that vimrc file instead
if exists('$VIMRC_SWITCH') && filereadable($VIMRC_SWITCH)
  source $VIMRC_SWITCH
  finish
endif

" Various behaviour preferences

" Enable .vimrc files in individual directories (beware of trojan horses!)
set exrc

" Enable modelines (beware of trojan horses!)
set modeline
set modelines=5

" Various file type preferences

augroup filetype
  " Quixote PTL
  au BufRead *.ptl		set ft=python
augroup END

"setlocal spell spelllang=en_au
