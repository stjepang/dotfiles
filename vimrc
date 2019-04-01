set hidden            " Hide abandoned buffers, don't unload
set mouse=            " Disable mouse
set history=10000     " Long command history
set viminfo='500,"500 " Long mark history
set encoding=utf-8    " Use UTF-8 in Vim
set shortmess+=I      " Disable splash screen
set clipboard=unnamed " Use secondary clipboard (register '*') by default

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
set laststatus=2         " Always show statusline

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

" Statusline format
function! VCStatusLine()
  let branch = fugitive#head()
  return empty(branch) ? '' : '(' . branch . ')  '
endfunction
function! LintStatusLine() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:errors = l:counts.error + l:counts.style_error
  let l:warnings = l:counts.total - l:errors
  return l:counts.total == 0 ? 'OK' : printf('%de %dw', l:errors, l:warnings)
endfunction
set stl=\                                 " Start with a space
set stl+=%1*%{!empty(@%)?@%:&ro?'':'~'}\  " Color 1: File name or ~ if empty
set stl+=%2*%{&mod?'++':'\ \ '}\ \        " Color 2: Add ++ if modified
set stl+=%3*%{VCStatusLine()}             " Color 3: Version control
set stl+=%3*%{LintStatusLine()}           " Color 3: Linter
set stl+=\ %3*\ %=%-7.(%l,%c%V%)          " Color 3: Row & column
set stl+=\                                " Extra space


" Fix weird quickfix statusline
autocmd BufNewFile,BufWinEnter quickfix
  \   let &l:stl = '%1* quickfix%3*%=%-14.(%l,%c%V%)%P '
  \ | nnoremap <silent><buffer> q :cclose<CR>

" Opening a new line after a comment doesn't start a new comment
autocmd BufNewFile,BufWinEnter *
  \ setl formatoptions-=o

" Convenience mapping for colon
noremap ; :

" Disable ex mode
nnoremap Q <nop>

" Extended yank/paste mappings
noremap Y y$
noremap <space>Y "+y$
noremap <space>y "+y
noremap <space>y "+y
noremap <silent> <space>p :set paste<CR>"+p:set nopaste<CR>
noremap <silent> <space>P :set paste<CR>"+P:set nopaste<CR>

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
nnoremap <silent> <space>w :update<CR>
inoremap <silent> <C-s>    <C-O>:update<cr>
noremap  <silent> <C-s>    :update<cr>

" Redraw and clear highlighted search matches
noremap <silent> <C-l> :nohl<CR><C-l>

" Remove trailing whitespace from all lines in the buffer
command! TrimBuffer %s/\s\+$//

" Netrw settings
autocmd FileType netrw
  \ noremap <buffer><nowait> q :bd<CR>
let g:netrw_banner = 0
let g:netrw_browsex_viewer = 'xdg-open'

" Help settings
autocmd FileType help
  \ noremap <buffer><nowait> q :q<CR>

" Complete braces on <CR> in a sensible way
function! s:complete_braces()
  let line = getline('.')
  let col = col('.')
  if col < 1000 && col == len(line) + 1 && matchstr(line, '\%' . (col-1) . 'c.') == '{'
    return "}\<C-o>k\<C-o>A\<CR>"
  endif
  return ""
endfunction
inoremap <buffer><expr><CR> "\<CR>" . <SID>complete_braces()

" Start ranger and open the chosen file
function! s:ranger()
  exec "silent !ranger --choosefiles=/tmp/chosenfile --selectfile="
        \ . expand("%:p")
  if filereadable('/tmp/chosenfile')
    exec system('sed -ie "s/ /\\\ /g" /tmp/chosenfile')
    exec 'argadd ' . system('cat /tmp/chosenfile | tr "\\n" " "')
    exec 'edit ' . system('head -n1 /tmp/chosenfile')
    call system('rm -f /tmp/chosenfile')
  endif
  redraw!
endfunction
nnoremap <silent> - :call <SID>ranger()<CR>

" Show buffer outline
function! s:outline_format(lists)
  for list in a:lists
    let linenr = list[2][:len(list[2])-3]
    let line = getline(linenr)
    let idx = stridx(line, list[0])
    let len = len(list[0])
    let fg = synIDattr(synIDtrans(hlID("LineNr")), 'fg', 'cterm')
    let bg = synIDattr(synIDtrans(hlID("LineNr")), 'bg', 'cterm')
    let list[0] = ''
          \ . printf("\x1b[%sm %4d \x1b[m ", '38;5;'.fg.';48;5;'.bg, linenr)
          \ . line[:idx-1]
          \ . printf("\x1b[%sm%s\x1b[m", "34", line[idx:idx+len-1])
          \ . line[idx+len:]
    let list = list[:2]
  endfor
  return a:lists
endfunction
function! s:outline_source(tag_cmds)
  if !filereadable(expand('%'))
    throw 'Save the file first'
  endif
  for cmd in a:tag_cmds
    let lines = split(system(cmd), "\n")
    if !v:shell_error
      break
    endif
  endfor
  if v:shell_error
    throw get(lines, 0, 'Failed to extract tags')
  elseif empty(lines)
    throw 'No tags found'
  endif
  return map(s:outline_format(map(lines, 'split(v:val, "\t")')), 'join(v:val, "\t")')
endfunction
function! s:outline_sink(lines)
  if !empty(a:lines)
    let line = a:lines[0]
    execute split(line, "\t")[2]
  endif
endfunction
function! s:outline(...)
  let args = copy(a:000)
  let tag_cmds = [
    \ printf('ctags -f - --sort=no --excmd=number --language-force=%s %s 2>/dev/null', &filetype, expand('%:S')),
    \ printf('ctags -f - --sort=no --excmd=number %s 2>/dev/null', expand('%:S'))]
  try
    return fzf#run(fzf#wrap('outline', {
      \ 'source':  s:outline_source(tag_cmds),
      \ 'sink*':   function('s:outline_sink'),
      \ 'options': '--tiebreak=index --reverse +m -d "\t" --with-nth=1 -n 1 --ansi --extended --prompt "Outline> "'}))
  catch
    echohl WarningMsg
    echom v:exception
    echohl None
  endtry
endfunction
command! -bang Outline call s:outline()
nnoremap <silent> <space>o :Outline<CR>

" Refresh - useful when things go wrong
function! s:refresh()
  silent! call mkdir(fnamemodify(tempname(), ":p:h"), "", 0700)
  set nohlsearch
  redraw
  redrawstatus
endfunction
command! -bang Refresh call s:refresh()
nnoremap <silent> <space>r :Refresh<CR>


call plug#begin('~/.vim/plugged')

Plug 'ConradIrwin/vim-bracketed-paste' " Smarter pasting into vim
Plug 'dietsche/vim-lastplace'          " Save cursor positing in buffer
Plug 'adelarsq/vim-matchit'            " Smarter bracket matching
Plug 'mhinz/vim-signify'               " Show changed lines (VCS-backed)
Plug 'rbgrouleff/bclose.vim'           " Buffer-close (common dependency)
Plug 'sheerun/vim-polyglot'            " Language pack
Plug 'tpope/vim-eunuch'                " Useful file management commands
Plug 'tpope/vim-repeat'                " Smarter . key
Plug 'tpope/vim-rsi'                   " Readline style mappings in insert mode
Plug 'tpope/vim-sleuth'                " Heuristically set buffer options
Plug 'tpope/vim-unimpaired'            " Pairs of handy [ and ] mappings

" Strip modified lines
Plug 'tweekmonster/wstrip.vim'
let g:wstrip_auto = 1
let g:wstrip_highlight = 0

" Color theme
function FixupBase16(info)
    !sed -i '/Base16hi/\! s/a:\(attr\|guisp\)/l:\1/g' ~/.vim/plugged/base16-vim/colors/*.vim
endfunction
Plug 'chriskempson/base16-vim', { 'do': function('FixupBase16') }
let base16colorspace = 256

" Better tab names
Plug 'gcmt/taboo.vim'
let g:taboo_tab_format = " %P%m "
let g:taboo_renamed_tab_format = " %l%m "
let g:taboo_modified_tab_flag = " ++"
let g:taboo_close_tabs_label = "X"
let g:taboo_unnamed_tab_label = "~"

" Git commands
Plug 'tpope/vim-fugitive'
autocmd FileType gitcommit
  \ setl cursorline

" Automatically change current working directory
Plug 'airblade/vim-rooter'
let g:rooter_patterns = ['.root', '.git/', '_darcs/', '.hg/', '.bzr/', '.svn/']
let g:rooter_use_lcd = 1
let g:rooter_silent_chdir = 1

" Yank history (use C-p/C-n after pasting)
Plug 'vim-scripts/YankRing.vim'
let g:yankring_history_dir = '~/.vim'
let g:yankring_replace_n_nkey = ''

" Automatic :nohl command
Plug 'junegunn/vim-slash'

" Quit buffer using :d command
Plug 'mhinz/vim-sayonara'
cnoreabbrev <silent><expr> d
  \ getcmdtype() == ":" && getcmdline() == 'd' ? 'Sayonara!' : 'd'

" Preview search-and-replace
Plug 'markonm/traces.vim'
let g:traces_preserve_view_state = 1

" Undo tree
Plug 'mbbill/undotree'
noremap U :UndotreeToggle<CR>
let g:undotree_SetFocusWhenToggle = 1
let g:undotree_WindowLayout = 3

" Comment line(s) using t key
Plug 'tomtom/tcomment_vim'
let g:tcomment_maps = 0
nnoremap <silent> t :TComment<CR>j
vnoremap <silent> t :TComment<CR>

" Code formatting
Plug 'sbdchd/neoformat'
let g:neoformat_rust_rustfmt = {
  \ 'exe': 'rustfmt',
  \ 'args': ['--edition', '2018', '--unstable-features'],
  \ 'stdin': 1,
  \ }
nnoremap <silent> <space>f :Neoformat<CR>
vnoremap <silent> <space>f :Neoformat<CR>

" Fuzzy completion
Plug 'junegunn/fzf', { 'dir': '~/.fzf' }
Plug 'junegunn/fzf.vim'
let g:fzf_layout = {}
let g:fzf_buffers_jump = 1
nnoremap <silent> <C-j> :Buffers<CR>
nnoremap <silent> <C-k> :Buffers<CR>
nnoremap <silent> <space>a :Ag<CR>
nnoremap <silent> <space>e :Files<CR>
nnoremap <silent> <space>l :BLines<CR>
nnoremap <silent> <space>h :History<CR>
nnoremap <silent> <space>; :Commands<CR>
nnoremap <silent> <space>: :Commands<CR>
nnoremap <silent> <space>` :Marks<CR>

" Real-time linting
Plug 'w0rp/ale'
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_enter = 0
let g:ale_cpp_clangcheck_options = '-std=c++14'
nmap ]w <plug>(ale_next_wrap)
nmap [w <plug>(ale_previous_wrap)
hi link ALEError Default
hi link ALEWarning Default

" Automatic tag file generation
Plug 'ludovicchabant/vim-gutentags'
let g:gutentags_project_root = ['.root']
let g:gutentags_ctags_exclude = ['*CMakeFiles*', '.ycm_extra_conf.py']

" Completion engine
Plug 'Valloric/YouCompleteMe',
      \ { 'do': './install.py --clang-completer --rust-completer' }
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
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>', '<Tab>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>', '<S-Tab>']
map <silent> <space>j :YcmCompleter GoTo<CR>

" Vimscript
Plug 'Shougo/neco-vim'

" Shell scripts
autocmd FileType sh
  \ setl sw=4 ts=4 expandtab

" Rust language
Plug 'rust-lang/rust.vim'
Plug 'racer-rust/vim-racer'
Plug 'sebastianmarkow/deoplete-rust'
let g:deoplete#sources#rust#disable_keymap = 1
let g:racer_experimental_completer = 1
let g:racer_no_default_keymappings = 1
let g:tagbar_type_rust = {
  \   'ctagstype' : 'rust',
  \   'sort' : '0',
  \   'kinds' : [ 'm:modules', 'c:consts', 'T:types', 'g:enums',
  \               's:structs', 't:traits', 'i:impls', 'f:functions' ]
  \ }
autocmd FileType rust
  \   setl colorcolumn=100
  \ | setl sw=4 ts=4 expandtab
  \ | compiler cargo
  \ | inoremap <buffer><expr><CR> "\<CR>" . <SID>complete_braces()

" C++ language
Plug 'octol/vim-cpp-enhanced-highlight'
set cinoptions+=g1 " Indent scope declarations by 1 space
set cinoptions+=h1 " Indent stuff after scope declarations by 1 more space
autocmd FileType c,cpp
  \   setl shiftwidth=4 tabstop=4

" Java language
autocmd FileType java
  \   setl colorcolumn=100

" Python language
autocmd FileType python
  \   setl colorcolumn=79

" Toml configuration language
autocmd FileType toml
  \   setl shiftwidth=2 tabstop=2

call plug#end()


syntax on                   " Enable syntax highlighting
set background=dark         " Assume dark background
colorscheme base16-tomorrow " Set color theme

" Statusline colors
hi def User1 ctermbg=18 ctermfg=20 cterm=bold
hi def User2 ctermbg=18 ctermfg=1 cterm=bold
hi def User3 ctermbg=18 ctermfg=20
hi StatusLine ctermbg=18 ctermfg=20
hi StatusLineNC ctermbg=18 ctermfg=8

" Completion popup colors
hi Pmenu ctermbg=19 ctermfg=7
hi PmenuSel ctermbg=17 ctermfg=15
hi PmenuSbar ctermbg=19 ctermfg=19
hi PmenuThumb ctermbg=8 ctermfg=8

" Search colors
hi Search ctermbg=0 ctermfg=15 cterm=bold
hi IncSearch ctermbg=9 ctermfg=15 cterm=bold

" Tab line colors
hi TabLineSel ctermbg=19 ctermfg=16 cterm=bold
hi TabLineFill ctermbg=18 ctermfg=20
hi TabLine ctermbg=18 ctermfg=20

" Other GUI colors
hi VertSplit ctermbg=0 ctermfg=19
hi CursorLine ctermbg=19
hi MatchParen ctermbg=0 ctermfg=15 cterm=bold,underline
hi WildMenu ctermbg=18 ctermfg=16 cterm=bold
