set t_Co=256
set pastetoggle=<F2>
set encoding=utf-8
set mouse=a

" Necesary for lots of cool vim things
set nocompatible

" Make splitting less surprising
set splitbelow
set splitright

" apply init.vim changes upon save
autocmd! bufwritepost init.vim source ~/.config/nvim/init.vim

" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! w !sudo tee > /dev/null %

" show evil trailing whitespace
set list listchars=trail:~

" remove it on :w
fun! StripTrailingWhiteSpace()
  " don't strip on these filetypes
  if &ft =~ 'markdown'
    return
  endif
%s/\s\+$//e
endfun
autocmd BufWritePre * :call StripTrailingWhiteSpace()

" This beauty remembers where you were the last time you edited the file, and returns to the same position.
au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif

" Allows the creation of directories from within nerdtree
set modifiable

" Highlight the matching bracket
set showmatch

" Show the line numbers
set number

" Disable highlighting spelling mistakes (http://stackoverflow.com/a/10963639/1477072)
set nospell

" Set use F6 to toggle spellcheck
:map <F6> :setlocal spell! spelllang=en_us<CR>

" Syntax highlight
syntax on
" More syntax highlighting.
let python_highlight_all = 1

" Highlight current line
set cursorline

" Better command-line completion
set wildmenu

" Backspace over insert, line breaks and autoindent
set backspace=indent,eol,start

""""""""""""""""""""""""""""""""""""""""""""""
" Search stuff
""""""""""""""""""""""""""""""""""""""""""""""
set incsearch
set hlsearch
set ignorecase
set smartcase

" Stupid shift key fixes
if has("user_commands")
" command! -bang -nargs=* -complete=file E e<bang> <args>
command! -bang -nargs=* -complete=file W w<bang> <args>
" command! -bang -nargs=* -complete=file Wq wq<bang> <args>
" command! -bang -nargs=* -complete=file WQ wq<bang> <args>
" command! -bang Wa wa<bang>
" command! -bang WA wa<bang>
" command! -bang Q q<bang>
" command! -bang QA qa<bang>
" command! -bang Qa qa<bang>
endif

""""""""""""""""""""""""""""""""""""""""""""""
" Indentation stuff
""""""""""""""""""""""""""""""""""""""""""""""

" Set the default to be 4 for everything
set shiftwidth=4
set softtabstop=4
set tabstop=4
set expandtab
set autoindent
filetype plugin indent on

" And then specify per filetype:
autocmd Filetype yaml setlocal ts=2 sts=2 sw=2
autocmd Filetype hcl setlocal ts=2 sts=2 sw=2
autocmd Filetype html setlocal ts=2 sts=2 sw=2
autocmd Filetype tf setlocal ts=2 sts=2 sw=2
autocmd Filetype htmldjango setlocal ts=2 sts=2 sw=2
autocmd Filetype javascript setlocal ts=2 sts=2 sw=2
autocmd Filetype python setlocal ts=4 sts=4 sw=4 cc=120,79
autocmd Filetype markdown setlocal ts=4 sts=4 sw=4 tw=90
autocmd Filetype c setlocal ts=8 sts=8 sw=8
autocmd Filetype go setlocal ts=4 sts=4 sw=4 noexpandtab nolist
autocmd Filetype make setlocal ts=4 sts=4 sw=4 noexpandtab nolist

" indent guides stuff
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1

set laststatus=2

" start scrolling 15 lines before the edge
set scrolloff=25

" when we jump to the end of the page, center the cursor
nnoremap G Gzz

" toggle highlighting search results
nnoremap <F3> :set hlsearch!<CR>

" \l toggles line numbers
:nmap \l :setlocal number!<CR>
" \m sets mouse to all
:nmap \m :set mouse=a<CR>
" \mm sets mouse to visual
:nmap \mm :set mouse=v<CR>

" insert python breakpoint
:imap <F12> import ipdb; ipdb.set_trace()
:nmap <F12> oimport ipdb; ipdb.set_trace()<Esc>

" instead of hitting Esc just press jj while on insert mode
:inoremap jj <Esc>

" Treat long lines as break lines (useful when moving around in them)
" (https://amix.dk/vim/vimrc.html)
map j gj
map k gk


""""""""""""""""""""""""""""""""""""""""""""""
" Folding
""""""""""""""""""""""""""""""""""""""""""""""
" set foldmethod=indent
" set foldnestmax=2
" nnoremap <space> za

" unfold everything when opening files
" autocmd Syntax * normal zR


let mapleader=","

" Set the colorscheme
colorscheme molokai
let g:Powerline_colorscheme='mar'

" Set matching brackets' color
" list of colors: https://vim.fandom.com/wiki/Xterm256_color_names_for_console_Vim
:hi MatchParen cterm=underline,reverse ctermbg=gray ctermfg=88


""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""
" Vundle stuff
""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""

filetype off

" set the RunTimePath for vim-plug
call plug#begin('~/.local/share/nvim/plugged')

" Plug 'easymotion/vim-easymotion'
" Plug 'sjl/gundo.vim'
" Plug 'terryma/vim-multiple-cursors'
Plug 'airblade/vim-gitgutter'
Plug 'alvan/vim-closetag'
Plug 'christoomey/vim-tmux-navigator'
" Plug 'hashivim/vim-terraform'
Plug 'majutsushi/tagbar'
Plug 'mileszs/ack.vim'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/syntastic'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'sheerun/vim-polyglot'

" python stuff
Plug 'psf/black'

" go stuff
" Plug 'fatih/vim-go', {'tag': 'v1.21', 'do': ':GoUpdateBinaries'}
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/deoplete.nvim'
Plug 'deoplete-plugins/deoplete-go', { 'do': 'make'}

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'


" Initialize plugin system
call plug#end()

filetype plugin indent on


""""""""""""""""""""""""""""""""""""""""""""""
"
" Plugin configuration
"
""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""
" black config
""""""""""""""""""""""""""""""""""""""""""""""
" autocmd BufWritePre *.py execute ':Black'

""""""""""""""""""""""""""""""""""""""""""""""
" nertree config
""""""""""""""""""""""""""""""""""""""""""""""

" Toggle NERDTree
:map <F4> :NERDTreeToggle<CR>
" Open NERDTree  in current file
:nmap <leader>n :NERDTreeFind<CR>

" Ignore certain filetypes
let NERDTreeIgnore = ['\.pyc$']

""""""""""""""""""""""""""""""""""""""""""""""
" Flake8 config
""""""""""""""""""""""""""""""""""""""""""""""

let g:syntastic_python_flake8_args='--ignore=E501'
let g:syntastic_html_checkers=[]


""""""""""""""""""""""""""""""""""""""""""""""
" fzf config
""""""""""""""""""""""""""""""""""""""""""""""

let g:fzf_nvim_statusline = 0 " disable statusline overwriting

nnoremap <silent> <c-p> :GFiles<CR>
nnoremap <silent> <c-g> :History<CR>

" This is the default extra key bindings
let g:fzf_action = {
  \ 'enter': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" Default fzf layout
" - down / up / left / right
let g:fzf_layout = { 'down': '~40%' }

" In Neovim, you can set up fzf window using a Vim command
let g:fzf_layout = { 'window': 'enew' }
let g:fzf_layout = { 'window': '-tabnew' }
let g:fzf_layout = { 'window': '10new' }

" Customize fzf colors to match your color scheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" Enable per-command history.
" CTRL-N and CTRL-P will be automatically bound to next-history and
" previous-history instead of down and up. If you don't like the change,
" explicitly bind the keys to down and up in your $FZF_DEFAULT_OPTS.
let g:fzf_history_dir = '~/.local/share/fzf-history'


""""""""""""""""""""""""""""""""""""""""""""""
" Gundo config
""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <F5> :GundoToggle<CR>


""""""""""""""""""""""""""""""""""""""""""""""
" Tagbar config
""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <F7> :TagbarToggle<CR>


""""""""""""""""""""""""""""""""""""""""""""""
" Ack config
""""""""""""""""""""""""""""""""""""""""""""""
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif
cnoreabbrev Ack Ack!
nnoremap <Leader>a :Ack!<Space>

""""""""""""""""""""""""""""""""""""""""""""""
" vim-terraform config
""""""""""""""""""""""""""""""""""""""""""""""
let g:terraform_fmt_on_save = 1


""""""""""""""""""""""""""""""""""""""""""""""
" vim-go config
""""""""""""""""""""""""""""""""""""""""""""""
let g:go_fmt_command = "goimports"

" Show partial commands in the last line of the screen
set showcmd
set exrc
set secure
