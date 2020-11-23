let &packpath .= ',' . expand('<sfile>:p:h') " Plugins directory

set hidden            " Hide abandoned buffers, don't unload
set mouse=a           " Enable mouse
set history=10000     " Long command history
set viminfo='500,"500 " Long mark history
set encoding=utf-8    " Use UTF-8 in Vim
set shortmess+=I      " Disable splash screen
set shortmess-=S      " Show search count
set clipboard=unnamed " Use secondary clipboard (register '*') by default

set noswapfile       " Don't use swap files
set nobackup         " Don't use backup files
set undofile         " Keep persistent undo
set undodir=/tmp     " Where to store undo files
set undolevels=10000 " Long undo history

set number                " Show number line
set confirm               " Ask to save changes
set wildmenu              " Better command completion
set wildignorecase        " Ignore case in command completion
set laststatus=2          " Always show status line
set splitbelow            " Put new split window below current one
set completeopt=          " Clear completion options
set completeopt+=menu     " Use popup menu
set completeopt+=menuone  " Use popup menu even if only one match
set completeopt+=preview  " Show extra info in preview window
set completeopt+=noinsert " Don't insert text initially
set completeopt+=noselect " Don't select a match initially

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

" Help
autocmd FileType help nnoremap <buffer><nowait> q :q<CR>

" Netrw
let g:netrw_banner = 0
autocmd FileType netrw setl bufhidden=wipe
autocmd FileType netrw nnoremap <buffer><nowait> q :setl bufhidden=wipe<CR>:bd<CR>

" Quickfix
nnoremap <silent> <space>q :copen<CR>
autocmd BufNewFile,BufWinEnter quickfix let &l:stl = '%1* quickfix%=%5*%l '
autocmd FileType qf nnoremap <silent><buffer> q :cclose<CR>
autocmd FileType qf setl nonumber
autocmd FileType qf call QuickfixAdjust(3, 10)
function! QuickfixAdjust(minheight, maxheight)
  exe max([min([line("$"), a:maxheight]), a:minheight]) . "wincmd _"
endfunction

" Preview window
set previewheight=10
autocmd WinEnter *
  \   if &previewwindow
  \ |   setl wrap
  \ |   nnoremap <silent><buffer> q :pclose<CR>
  \ | endif

" Skip the C-x completion prefix
inoremap <C-o> <C-x><C-o>
inoremap <C-f> <C-x><C-f>

" Don't start a new comment after opening a new line below a comment
autocmd BufNewFile,BufWinEnter * setl formatoptions-=o

" Convenience mapping for colon
nnoremap ; :

" Disable Ex mode
nnoremap Q <nop>

" Extended yank/paste mappings
nnoremap Y y$
nnoremap <space>Y "+y$
onoremap <space>y "+y
onoremap <space>p "+p
onoremap <space>P "+P

" j/k moves up/down row by row, not line by line
noremap j gj
noremap k gk

" Fast jump up/down
noremap J 5gj
noremap K 5gk

" Stay in visual mode when shifting indentation
xnoremap < <gv
xnoremap > >gv

" Switch to last used buffer
nnoremap <silent> <BS> <C-^>

" Move to next window
nnoremap <silent> <C-n> <C-w><C-w>

" Quick save
nnoremap <silent> <space>w :update<CR>

" Simple reset when things go wrong
nnoremap <silent> <C-l> :pclose<CR>:nohl<CR>:set nopaste<CR><C-l>

" Delete buffer using :d
cnoreabbrev <silent><expr> d
  \ getcmdtype() == ":" && getcmdline() == 'd' ? 'Sayonara!' : 'd'

" Close brackets on <CR>{ and <CR>[
function! s:close_brackets()
  let line = getline('.')
  let c = len(line) == 0 ? '' : line[len(line)-1]
  if c == '{'
    return "}\<C-o>k\<C-o>A\<CR>"
  elseif c == '['
    return "]\<C-o>k\<C-o>A\<CR>"
  endif
  return ""
endfunction
inoremap <expr> <CR> "\<CR>" . <SID>close_brackets()

" Strip changed lines
let g:wstrip_auto = 1
let g:wstrip_highlight = 0
packadd wstrip.vim
autocmd FileType gitconfig let b:wstrip_auto = 0

" Show changed lines in version control
let g:signify_priority = 1
packadd vim-signify

" Automatically set current directory
let g:rooter_patterns = ['.root', '.git/', '_darcs/', '.hg/', '.bzr/', '.svn/']
let g:rooter_cd_cmd = 'lcd'
let g:rooter_silent_chdir = 1
packadd vim-rooter

" Yank history (use C-p after pasting)
let g:yankring_history_dir = '/tmp'
let g:yankring_replace_n_nkey = ''
let g:yankring_n_keys = ''
packadd YankRing.vim

" Comment line(s) using t key
let g:tcomment_maps = 0
packadd tcomment_vim
nnoremap <silent> t :TComment<CR>j
xnoremap <silent> t :TComment<CR>

" Undo tree
let g:undotree_SetFocusWhenToggle = 1
let g:undotree_WindowLayout = 3
packadd undotree
nnoremap <silent> U :UndotreeToggle<CR>

" Open ranger or netrw using - key
if executable('ranger')
  function! s:ranger()
    exe "silent !ranger --choosefiles=/tmp/chosenfile --selectfile=" . expand("%:p")
    if filereadable('/tmp/chosenfile')
      exe system('sed -ie "s/ /\\\ /g" /tmp/chosenfile')
      exe 'argadd ' . system('cat /tmp/chosenfile | tr "\\n" " "')
      exe 'edit ' . system('head -n1 /tmp/chosenfile')
      call system('rm -f /tmp/chosenfile')
    endif
    redraw!
  endfunction
  nnoremap <silent> - :call <SID>ranger()<CR>
else
  nnoremap <silent> - :e .<CR>
endif

" Fuzzy completion
if executable('fzf')
  let g:fzf_layout = {}
  let g:fzf_buffers_jump = 1
  let g:fzf_preview_window = ['up:50%', 'ctrl-/']
  packadd fzf
  packadd fzf.vim
  nnoremap <silent> <C-j> :Buffers<CR>
  nnoremap <silent> <C-k> :Buffers<CR>
  nnoremap <silent> <space>e :Files<CR>
  nnoremap <silent> <space>l :BLines<CR>
  nnoremap <silent> <space>h :History<CR>
  nnoremap <silent> <space>; :Commands<CR>
  nnoremap <silent> <space>: :Commands<CR>
  nnoremap <silent> <space>` :Marks<CR>
  if executable('rg')
    nnoremap <expr> <space>g ':Rg '.expand('<cword>')
    xnoremap <space>g "zy:Rg <C-r>z
  elseif executable('ag')
    nnoremap <expr> <space>g ':Ag '.expand('<cword>')
    xnoremap <space>g "zy:Ag <C-r>z
  else
    nnoremap <expr> <space>g ':Grep '.expand('<cword>')
    xnoremap <space>g "zy:Grep <C-r>z
  endif
  command! -bang -nargs=* Grep
    \ call fzf#vim#grep(
    \   'grep --line-number --line-buffered --color=always -r '
    \     . shellescape(<q-args>).' .',
    \   0,
    \   fzf#vim#with_preview({'dir': '.'}),
    \   <bang>0)
endif

" Color theme
if trim(system('tput colors')) == '256'
  " To debug colors, try this:
  " 1. :highlight
  " 2. :runtime syntax/colortest.vim
  set background=dark
  let base16colorspace = 256
  packadd base16-vim
  colorscheme base16-tomorrow
  syntax on

  " GUI
  hi TabLine ctermbg=18 ctermfg=20
  hi TabLineFill ctermbg=18 ctermfg=20
  hi TabLineSel ctermbg=19 ctermfg=16 cterm=bold
  hi VertSplit ctermbg=0 ctermfg=19
  hi WildMenu ctermbg=18 ctermfg=16 cterm=bold

  " Navigation
  hi CursorLine ctermbg=19
  hi Search ctermbg=0 ctermfg=15 cterm=bold
  hi IncSearch ctermbg=9 ctermfg=15 cterm=bold
  hi MatchParen ctermbg=0 ctermfg=15 cterm=bold,underline

  " Diagnostics
  hi Error ctermbg=18 ctermfg=1
  hi SpellRare ctermbg=0 cterm=undercurl

  " Completion popup
  hi Pmenu ctermbg=19 ctermfg=7
  hi PmenuSel ctermbg=17 ctermfg=15
  hi PmenuSbar ctermbg=19 ctermfg=19
  hi PmenuThumb ctermbg=8 ctermfg=8
else
  " Fallback colors on 8-bit terminals (e.g. ttys)
  set ruler
  set background=dark
  colorscheme zellner
endif

" Completion, linting, and formatting
let g:ale_completion_enabled = 1
let g:ale_set_quickfix = 1
let g:ale_set_highlights = 0
let g:ale_sign_error = '>>'
let g:ale_sign_warning = '>>'
hi link ALEErrorSign ErrorMsg
hi link ALEWarningSign WarningMsg
let g:ale_fixers = {
  \   'go': ['gofmt', 'goimports'],
  \   'rust': ['rustfmt'],
  \ }
let g:ale_linters = {
  \   'go': ['gofmt', 'gopls'],
  \   'rust': ['cargo', 'analyzer'],
  \ }
let g:ale_rust_cargo_check_tests = 1
let g:ale_rust_cargo_check_examples = 1
let g:ale_rust_cargo_default_feature_behavior = 'all'
packadd ale
set omnifunc=ale#completion#OmniFunc
inoremap <expr> <Tab> getline('.')[col('.')-2] =~ '^\_s*$' ? "\<Tab>" :
  \ pumvisible() ? "\<C-n>" : "\<C-x>\<C-o>"
inoremap <expr> <S-Tab> getline('.')[col('.')-2] =~ '^\_s*$' ? "\<Tab>" :
  \ pumvisible() ? "\<C-p>" : "\<S-Tab>"
autocmd CompleteDone * silent! pclose
nnoremap <silent> <space>j :ALEGoToDefinition<CR>
nnoremap <silent> <space>k :ALEHover<CR>
nnoremap <silent> <space>f :ALEFix<CR>
nnoremap <silent> <space>r :ALEResetBuffer<CR>:ALELint<CR>

" Status line
if trim(system('tput colors')) == '256'
  set stl=\                                 " Start with a space
  set stl+=%1*%{!empty(@%)?@%:&ro?'':'~'}\  " Color 1: File name or ~ if empty
  set stl+=%2*%{&mod?'++':'\ \ '}\ \        " Color 2: Add ++ if modified
  set stl+=%=                               " Align right
  set stl+=%3*%{ErrorCount()}               " Color 3: Errors
  set stl+=%4*%{WarningCount()}             " Color 4: Warnings
  set stl+=\ %5*\ %-6.(%l,%c%V%)            " Color 5: Row & column
  set stl+=\                                " Extra space

  hi def User1 ctermbg=18 ctermfg=20 cterm=bold
  hi def User2 ctermbg=18 ctermfg=1 cterm=bold
  hi def User3 ctermbg=18 ctermfg=1
  hi def User4 ctermbg=18 ctermfg=3
  hi def User5 ctermbg=18 ctermfg=20
  hi StatusLine ctermbg=18 ctermfg=20
  hi StatusLineNC ctermbg=18 ctermfg=8

  function! ErrorCount()
    let counts = ale#statusline#Count(bufnr(''))
    let n = counts.error + counts.style_error
    return n == 0 ? '' : n . ' '
  endfunction
  function! WarningCount()
    let l:counts = ale#statusline#Count(bufnr(''))
    let n = counts.warning + counts.style_warning
    return n == 0 ? '' : n . ' '
  endfunction
  autocmd User ALELintPost redrawstatus
endif

" Language pack
let g:polyglot_disabled = ['sh']
packadd vim-polyglot

" Shell scripts
autocmd FileType sh setl shiftwidth=4
autocmd FileType sh setl tabstop=4
autocmd FileType sh setl expandtab

" Golang
autocmd FileType go setl colorcolumn=80

" Rust
autocmd FileType rust setl colorcolumn=100
autocmd FileType rust setl shiftwidth=4
autocmd FileType rust setl tabstop=4
autocmd FileType rust setl expandtab

" Python
autocmd FileType python setl colorcolumn=79

" Toml
autocmd FileType toml setl shiftwidth=2
autocmd FileType toml setl tabstop=2
