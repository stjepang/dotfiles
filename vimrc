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

set number         " Show number line
set confirm        " Ask to save changes
set wildmenu       " Better command completion
set wildignorecase " Ignore case in command completion
set laststatus=2   " Always show statusline

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
set stl=\                                 " Start with a space
set stl+=%1*%{!empty(@%)?@%:&ro?'':'~'}\  " Color 1: File name or ~ if empty
set stl+=%2*%{&mod?'++':'\ \ '}\ \        " Color 2: Add ++ if modified
set stl+=\ %3*\ %=%-7.(%l,%c%V%)          " Color 3: Row & column
set stl+=\                                " Extra space


" Quickfix settings
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

" Redraw and clear highlighted search matches
noremap <silent> <C-l> :nohl<CR>:set nopaste<CR><C-l>

" Remove trailing whitespace from all lines in the buffer
command! TrimBuffer %s/\s\+$//

" Netrw settings
autocmd FileType netrw
  \   setl bufhidden=wipe
  \ | noremap <buffer><nowait> q :bd<CR>
let g:netrw_banner = 0

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

" Open ranger or netrw with '-'
if executable('ranger')
  function! s:ranger()
    exec "silent !ranger --choosefiles=/tmp/chosenfile --selectfile=" . expand("%:p")
    if filereadable('/tmp/chosenfile')
      exec system('sed -ie "s/ /\\\ /g" /tmp/chosenfile')
      exec 'argadd ' . system('cat /tmp/chosenfile | tr "\\n" " "')
      exec 'edit ' . system('head -n1 /tmp/chosenfile')
      call system('rm -f /tmp/chosenfile')
    endif
    redraw!
  endfunction
  nnoremap <silent> - :call <SID>ranger()<CR>
else
  nnoremap <silent> - :e .<CR>
endif


call plug#begin('~/.vim/plugged')

Plug 'adelarsq/vim-matchit'            " Smarter bracket matching
Plug 'dietsche/vim-lastplace'          " Save cursor position in buffer
Plug 'mhinz/vim-signify'               " Show changed lines (VCS-backed)
Plug 'romainl/vim-cool'                " Automatic :nohl
Plug 'sheerun/vim-polyglot'            " Language pack
Plug 'tpope/vim-eunuch'                " Useful file management commands
Plug 'tpope/vim-repeat'                " Smarter . key
Plug 'tpope/vim-rsi'                   " Readline style mappings in insert mode
Plug 'tpope/vim-sleuth'                " Heuristically set buffer options
Plug 'tpope/vim-unimpaired'            " Pairs of handy [ and ] mappings

" Quit buffer using :d
Plug 'rbgrouleff/bclose.vim'
cnoreabbrev <silent><expr> d
  \ getcmdtype() == ":" && getcmdline() == 'd' ? 'Bclose!' : 'd'

" Strip modified lines
Plug 'tweekmonster/wstrip.vim'
let g:wstrip_auto = 1
let g:wstrip_highlight = 0
autocmd FileType gitconfig let b:wstrip_auto = 0

" Color theme
function FixupBase16(info)
    !sed -i '/Base16hi/\! s/a:\(attr\|guisp\)/l:\1/g' ~/.vim/plugged/base16-vim/colors/*.vim
endfunction
let base16colorspace = 256
Plug 'chriskempson/base16-vim', { 'do': function('FixupBase16') }

" Automatically change current working directory
Plug 'airblade/vim-rooter'
let g:rooter_patterns = ['.root', '.git/', '_darcs/', '.hg/', '.bzr/', '.svn/']
let g:rooter_cd_cmd = 'lcd'
let g:rooter_silent_chdir = 1

" Yank history (use C-p after pasting)
Plug 'vim-scripts/YankRing.vim'
let g:yankring_history_dir = '~/.vim'
let g:yankring_replace_n_nkey = ''
let g:yankring_n_keys = ''

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
let g:fzf_preview_window = ['up:50%', 'ctrl-/']
nnoremap <silent> <C-j> :Buffers<CR>
nnoremap <silent> <C-k> :Buffers<CR>
nnoremap <silent> <space>e :Files<CR>
nnoremap <silent> <space>l :BLines<CR>
nnoremap <silent> <space>h :History<CR>
nnoremap <silent> <space>; :Commands<CR>
nnoremap <silent> <space>: :Commands<CR>
nnoremap <silent> <space>` :Marks<CR>
if executable('ag')
  nnoremap <space>g :Ag<Space>
elseif executable('rg')
  nnoremap <space>g :Rg<Space>
else
  nnoremap <space>g :Grep<Space>
endif
command! -bang -nargs=* Grep
  \ call fzf#vim#grep(
  \   'grep --line-number --line-buffered --color=always -r '.shellescape(<q-args>).' .',
  \   0, fzf#vim#with_preview({'dir': '.'}), <bang>0)


" Real-time linting
" Plug 'w0rp/ale'
" let g:ale_lint_on_text_changed = 'never'
" let g:ale_lint_on_enter = 0
" let g:ale_cpp_clangcheck_options = '-std=c++14'
" nmap ]w <plug>(ale_next_wrap)
" nmap [w <plug>(ale_previous_wrap)
" hi link ALEError Default
" hi link ALEWarning Default
" let g:ale_rust_cargo_use_clippy = 0
" let g:ale_linters = {
" 	\ 'go': ['gopls'],
" 	\ 'rust': ['analyzer'],
" 	\}
" let g:ale_set_quickfix = 1
" let g:ale_open_list = 1
" let g:ale_hover_to_preview = 0
" let g:ale_set_balloons = 1




" Plug 'autozimu/LanguageClient-neovim', {
"     \ 'branch': 'next',
"     \ 'do': 'bash install.sh',
"     \ }
" let g:LanguageClient_serverCommands = {
" \ 'go': ['gopls'],
" \ 'rust': ['rust-analyzer'],
" \ }
" let g:LanguageClient_usePopupHover = 0
" let g:LanguageClient_preferredMarkupKind = ['plaintext']
" nmap <silent> <space>j :call LanguageClient#textDocument_definition()<CR>
" nmap <silent> <space>k :call LanguageClient#textDocument_hover()<CR>
" set completeopt+=preview
" set completeopt+=menuone,noselect,noinsert
" set completefunc=LanguageClient#complete
" " autocmd CompleteDone * pclose
" set previewheight=7
" set splitbelow
" noremap <silent> <C-l> :pclose<CR>:nohl<CR>:set nopaste<CR><C-l>
" autocmd BufNewFile,BufWinEnter *
"   \   if &previewwindow
"   \ |   nnoremap <silent><buffer> q :pclose<CR>
"   \ | endif




" Completion engine
" Plug 'Valloric/YouCompleteMe',
"       \ { 'do': './install.py --clang-completer --rust-completer --go-completer' }
" augroup load_ycm
"   " Load plugin when entering insert mode.
"   au! InsertEnter *
"     \   call plug#load('YouCompleteMe')
"     \ | call youcompleteme#Enable()
"     \ | setl formatoptions-=o
"     \ | au! load_ycm
" augroup END
" let g:ycm_confirm_extra_conf = 0
" let g:ycm_show_diagnostics_ui = 0
" let g:ycm_enable_diagnostic_signs = 0
" let g:ycm_enable_diagnostic_highlighting = 0
" let g:ycm_echo_current_diagnostic = 0
" let g:ycm_key_list_select_completion = ['<C-n>', '<Down>', '<Tab>']
" let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>', '<S-Tab>']
" map <silent> <space>j :YcmCompleter GoTo<CR>




Plug 'neoclide/coc.nvim', {'branch': 'release'}

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
  \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

nmap <silent> <space>j <Plug>(coc-definition)
nmap <silent> <space>k :call <SID>show_documentation()<CR>





" Shell scripts
autocmd FileType sh
  \ setl sw=4 ts=4 expandtab

" Go language
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
let g:go_doc_keywordprg_enabled = 0
autocmd FileType go
  \   setl colorcolumn=80
  \ | inoremap <buffer><expr><CR> "\<CR>" . <SID>complete_braces()

" Rust language
Plug 'rust-lang/rust.vim'
autocmd FileType rust
  \   setl colorcolumn=100
  \ | setl sw=4 ts=4 expandtab
  \ | inoremap <buffer><expr><CR> "\<CR>" . <SID>complete_braces()

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

" Some fixes for annoying colors follow.
" To debug colors, try this:
"   :highlight
"   :runtime syntax/colortest.vim

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
hi SpellRare ctermbg=0 cterm=undercurl
