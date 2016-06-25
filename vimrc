set hidden               " Hide abandoned buffers, don't unload
set mouse=               " Disable mouse
set history=10000        " Long command history
set encoding=utf-8       " Use UTF-8 within Vim
set shortmess+=I         " Disable splash screen
set clipboard=unnamed    " Use secondary clipboard (register '*') by default

set noswapfile       " Don't use swap files
set nobackup         " Don't use backup files
set undofile         " Keep persistent undo
set undodir=/tmp     " Where to store undo files
set undolevels=10000 " Long undo history

set number               " Show number line
set confirm              " Ask to save changes
set wildmenu             " Better command completion
set wildignorecase       " Ignore case in command completion
set completeopt-=preview " Disable annoying popup window when autocompleting

set nowrap                 " Don't wrap lines
set whichwrap+=<,>,[,],h,l " Arrow keys and h/l wrap over lines
set backspace=2            " Backspace wraps over lines

set scrolloff=2       " Keep a few lines above/below cursor
set sidescrolloff=2   " Keep a few columns left/right of the cursor
set sidescroll=1      " Scroll horizontally by one column
set display+=lastline " Show as much as possible of the last line

set timeout timeoutlen=500  " Timeout between key combos
set ttimeout ttimeoutlen=50 " No idea what this does, but keep it

set ignorecase " Case insensitive search
set smartcase  " If an uppercase letter is the query, be case sensitive
set incsearch  " Highlight matches while typing query
set hlsearch   " Highlight all search matches

set expandtab          " Expand Tab key to spaces
set tabstop=4          " Number of spaces Tab key expands to
set smarttab           " Apply tabs in front of a line according to shiftwidth
set shiftwidth=4       " Number of spaces for each step of (auto)indent
set autoindent         " Automatically indent when starting a new line
set list               " Enable list mode
set listchars=tab:\ \  " Represent tab character as spaces

set laststatus=2                          " Always show statusline
set stl=                                  " Clear statusline format
set stl+=\ %1*%{!empty(@%)?@%:&ro?'':'~'} " Color 1: File name or ~ if empty
set stl+=\ %2*%{&mod?'++':''}             " Color 2: Add ++ if modified
set stl+=\ %3*%=%-14.(%l,%c%V%)%P         " Color 3: Row, column, percentage
set stl+=\                                " Extra empty space

" Fix weird quickfix statusline
au! BufNewFile,BufWinEnter quickfix
  \   let &l:stl = '%1* quickfix%3*%=%-14.(%l,%c%V%)%P '
  \ | nnoremap <silent><buffer> q :cclose<CR>

" Opening a new line after a comment doesn't start a new comment
au! BufNewFile,BufWinEnter *
  \ setl formatoptions-=o

" Key q quits netrw
au! FileType netrw
  \ noremap <buffer><nowait> q :bd<CR>

" Opening files using external apps
let g:netrw_browsex_viewer = 'xdg-open'

" Convenience mapping for colon
map ; :

" The only mapping for Y that makes sense
noremap Y y$

" j/k moves up/down row by row, not line by line
noremap j gj
noremap k gk

" Fast jumping up/down
noremap J 5gj
noremap K 5gk

" Stay in visual mode when shifting indentation
xnoremap < <gv
xnoremap > >gv

" Switch to last used buffer
nnoremap <BS> <C-^>

" Move to next window
nnoremap <silent> <C-n> <C-w><C-w>

" Quick save
nnoremap <silent> <space>w :w<CR>

" Redraw and clear highlighted search matches
nnoremap <silent> <C-l> :nohl<CR><C-l>

" Remove trailing whitespace from all lines in the buffer
command! TrimBuffer %s/\s\+$//

" Search for a file using ranger and open it for editing
fun! Ranger()
  exec "silent !ranger --choosefiles=/tmp/chosenfile --selectfile="
       \ . expand("%:p")
  if filereadable('/tmp/chosenfile')
    exec system('sed -ie "s/ /\\\ /g" /tmp/chosenfile')
    exec 'argadd ' . system('cat /tmp/chosenfile | tr "\\n" " "')
    exec 'edit ' . system('head -n1 /tmp/chosenfile')
    call system('rm -f /tmp/chosenfile')
  endif
  redraw!
endfun
nnoremap <silent> - :call Ranger()<CR>


call plug#begin('~/.vim/plugged')

Plug 'ConradIrwin/vim-bracketed-paste' " Smarter pasting into vim
Plug 'dietsche/vim-lastplace'          " Save cursor positing in buffer
Plug 'justinmk/vim-dirvish'            " Alternative for netrw
Plug 'matchit.zip'                     " Smarter bracket matching
Plug 'mhinz/vim-signify'               " Show changed lines (VCS-backed)
Plug 'rbgrouleff/bclose.vim'           " Buffer-close (plugin dependency)
Plug 'sheerun/vim-polyglot'            " Language pack
Plug 'thirtythreeforty/lessspace.vim'  " Automatically strip whitespace
Plug 'tpope/vim-eunuch'                " Useful file management commands
Plug 'tpope/vim-repeat'                " Smarter . key
Plug 'tpope/vim-rsi'                   " Readline style mappings in insert mode
Plug 'tpope/vim-sleuth'                " Heuristically set buffer options
Plug 'tpope/vim-unimpaired'            " Pairs of handy [ and ] mappings

" Color theme
Plug 'chriskempson/base16-vim'
let base16colorspace = 256

" Git commands
Plug 'tpope/vim-fugitive'
au! FileType gitcommit
  \ setl cursorline

" Asynchronous building
Plug 'tpope/vim-dispatch'
nnoremap <silent> <space>m :w\|Make<CR>
nnoremap <silent> <space>q :Copen<CR>

" Automatically change current working directory
Plug 'airblade/vim-rooter'
let g:rooter_patterns = ['.rooter', '.git/', '_darcs/', '.hg/', '.bzr/', '.svn/']
let g:rooter_silent_chdir = 1

" C-p after pasting goes through yank history
Plug 'vim-scripts/YankRing.vim'
let g:yankring_history_dir = '~/.vim'
let g:yankring_replace_n_nkey = ''

" Snippets
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
let g:UltiSnipsExpandTrigger = "<Tab>"
let g:UltiSnipsJumpForwardTrigger = "<C-j>"
let g:UltiSnipsJumpBackwardTrigger = "<C-k>"

" Better search (display number of matches and automatically clear them)
Plug 'osyo-manga/vim-anzu'
Plug 'junegunn/vim-pseudocl'
Plug 'junegunn/vim-oblique'
nmap <silent> n <Plug>(Oblique-n!)
                \:AnzuUpdateSearchStatus<CR><Plug>(anzu-echo-search-status)
xmap <silent> n <Plug>(Oblique-n!)
                \:AnzuUpdateSearchStatus<CR><Plug>(anzu-echo-search-status)
nmap <silent> N <Plug>(Oblique-N!)
                \:AnzuUpdateSearchStatus<CR><Plug>(anzu-echo-search-status)
xmap <silent> N <Plug>(Oblique-N!)
                \:AnzuUpdateSearchStatus<CR><Plug>(anzu-echo-search-status)

" Quit buffer using :d command
Plug 'mhinz/vim-sayonara'
cnoreabbrev <silent><expr> d
  \ getcmdtype() == ":" && getcmdline() == 'd' ? 'Sayonara' : 'd'

" Undo tree
Plug 'mbbill/undotree'
noremap <silent> <space>u :UndotreeToggle<CR>
let g:undotree_SetFocusWhenToggle = 1
let g:undotree_WindowLayout = 3

" Interaction with tmux
Plug 'benmills/vimux'
nnoremap <space>\ :w<CR>:VimuxPromptCommand<CR>
nnoremap <silent> <space><CR> :w<CR>:VimuxRunLastCommand<CR>
nnoremap <silent> <space><BS> :call VimuxSendKeys("C-c")<CR>

" Autoclose parentheses
Plug 'cohama/lexima.vim'
let g:lexima_enable_basic_rules = 0

" Comment line(s) using t key
Plug 'tomtom/tcomment_vim'
let g:tcommentMaps = 0
nnoremap <silent> t :TComment<CR>j
vnoremap <silent> t :TComment<CR>

" TODO: Automatic style formatting
" Plug 'Chiel92/vim-autoformat'
" let g:formatdef_my_cpp = '"clang-format --style=google"'
" let g:formatters_cpp = ['my_cpp']

" A list of tags in the buffer
Plug 'majutsushi/tagbar'
let g:tagbar_compact = 1
let g:tagbar_sort = 0
nnoremap <silent> <space>o :TagbarOpenAutoClose<CR>
" autocmd FileType tagbar setlocal cursorline
highlight default link TagbarHighlight Normal

" General fuzzy completion
Plug 'junegunn/fzf', { 'dir': '~/.fzf' }
Plug 'junegunn/fzf.vim'
let g:fzf_layout = { 'down': '~40%' }
let g:fzf_buffers_jump = 1
nnoremap <silent> <C-j> :Buffers<CR>
nnoremap <silent> <C-k> :Buffers<CR>
nnoremap <silent> <space>a :Ag<CR>
nnoremap <silent> <space>e :Files<CR>
nnoremap <silent> <space>l :BLines<CR>
" nnoremap <silent> <space>k :BTags<CR>
nnoremap <silent> <space>g :GitFiles<CR>
" nnoremap <silent> <space>j :Buffers<CR>
nnoremap <silent> <space>h :History<CR>
nnoremap <silent> <space>; :Commands<CR>
nnoremap <silent> <space>: :Commands<CR>
" nnoremap <silent> <space>??? :Commits<CR>
" nnoremap <silent> <space>??? :BCommits<CR>
" nnoremap <silent> <space>m :Marks<CR>

" Automatic tag file generation
Plug 'ludovicchabant/vim-gutentags'
let g:gutentags_project_root = ['.root']
let g:gutentags_exclude = ['*CMakeFiles*', '.ycm_extra_conf.py']

" TODO: tag navigation
" TODO: tpope/vim-projectionist
" TODO: alternate file

" Intelligent completion engine
Plug 'Valloric/YouCompleteMe', { 'on': [] } " Don't load plugin on startup
augroup load_ycm
  " Load plugin when entering insert mode.
  au! InsertEnter *
    \   call plug#load('YouCompleteMe')
    \ | call youcompleteme#Enable()
    \ | setl formatoptions-=o
    \ | au! load_ycm
augroup END
let g:ycm_confirm_extra_conf = 0
let g:ycm_show_diagnostics_ui = 0
let g:ycm_global_ycm_extra_conf = '~/dotfiles/ycm_extra_conf.py'
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
map <silent> <space>j :YcmCompleter GoTo<CR>

" Rust language
Plug 'rust-lang/rust.vim'
Plug 'racer-rust/vim-racer'
let g:ycm_rust_src_path = "~/.rust"
let g:ycm_racerd_binary_path = "~/.cargo/bin/racer"
let g:tagbar_type_rust = {
  \   'ctagstype' : 'rust',
  \   'sort' : '0',
  \   'kinds' : [ 'm:modules', 'c:consts', 'T:types', 'g:enums',
  \               's:structs', 't:traits', 'i:impls', 'f:functions' ]
  \ }

" C++ language
au! FileType c,cpp
  \ setl shiftwidth=4 tabstop=4

" C++ highlighting
Plug 'octol/vim-cpp-enhanced-highlight'
set cinoptions+=g1 " Indent scope declarations by 1 space
set cinoptions+=h1 " Indent stuff after scope declarations by 1 more space

" Conveniences for programming contests
au! FileType cpp
  \   if expand('%:p') =~ '/contests/'
  \ |   set makeprg=clang++\ -std=c++11\ -O2\ -Wall\ -o\ %:r\ %
  \ |   map <buffer> <CR> :w\|Make<CR>
  \ |   map <silent> <space>\ VimuxPromptCommand("./" . expand("%:r"))<CR>
  \ | endif

" Java language
let g:EclimCompletionMethod = 'omnifunc'
" TODO: Fix black background in margin symbols for warnings

call plug#end()


syntax on            " Enable syntax highlighting
set background=dark  " Assume dark background
colo base16-tomorrow " Set color theme

" Statusline colors
hi def User1 ctermbg=18 ctermfg=20 cterm=bold
hi def User2 ctermbg=18 ctermfg=1 cterm=bold
hi def User3 ctermbg=18 ctermfg=20
hi StatusLine ctermbg=18 ctermfg=20
hi StatusLineNC ctermbg=18 ctermfg=8

" Omnicompletion popup menu colors
hi Pmenu ctermbg=19 ctermfg=7
hi PmenuSel ctermbg=17 ctermfg=15
hi PmenuSbar ctermbg=19 ctermfg=19
hi PmenuThumb ctermbg=8 ctermfg=8

" Search colors
hi Search ctermbg=0 ctermfg=15 cterm=bold
hi ObliqueCurrentMatch ctermbg=9 ctermfg=15 cterm=bold
hi ObliqueCurrentIncSearch ctermbg=9 ctermfg=15 cterm=bold

" Tab line colors
hi TabLineSel ctermbg=19 ctermfg=16 cterm=bold
hi TabLineFill ctermbg=18 ctermfg=20
hi TabLine ctermbg=18 ctermfg=20

" Other GUI colors
hi VertSplit ctermbg=0 ctermfg=19
hi CursorLine ctermbg=19
hi MatchParen ctermbg=0 ctermfg=15 cterm=bold,underline
hi WildMenu ctermbg=18 ctermfg=16 cterm=bold
