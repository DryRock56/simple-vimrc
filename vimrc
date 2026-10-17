" ==== GENERAL ====
" Set how many lines of history VIM remembers
set history=500

" Enable filetype plugins
filetype plugin on
filetype indent on

" ==== VISUAL ENHANCEMENTS ====
" Line numbers and display
set number      " Show line numbers
set cursorline  " Highlight the current line
set ruler       " Show cursor position in status line
set showcmd     " Show partial commands in status line
set showmatch   " Highlight matching brackers/parentheses

" Colors and syntax
syntax enable       " Enable syntax highlighting
set background=dark " Use dark background for better contrast
set regexpengine=0  " Set regexp engine automatically

" Enable 256 colors palette in Gnome Terminal
if $COLORTERM == 'gnome-terminal'
    set t_Co=256
endif

try
    colorscheme desert  " Bright, vibrant color scheme
catch
endtry

" Set extra options when running in GUI mode
if has("gui_running")
    set guioption-=T
    set guioption-=e
    set t_Co=256
    set guitablabel=%M\ %t
endif

" Status line configuration
set laststatus=2    " Always show status line
" set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")}
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ [TYPE=%Y]\ [CWD=%r%{getcwd()}%h]\ [POS=%l/%L,%c]

" Visual guides
set colorcolumn=160 " Show column at 160 characters
set list            " Show invisible characters
set listchars=tab:→\ ,trail:·,extends:>,precedes:<,nbsp:+

" ==== BEHAVIORAL ENHANCEMENTS ====
" Indentation and tabs
set autoindent      " Automatically indent new lines
set smartindent     " Smart auto-indenting
set expandtab       " Use spaces instead of tabs
set tabstop=4       " Tab width is 4 spaces
set shiftwidth=4    " Indent width is 4 spaces
set softtabstop=4   " Backspace deletes 4 spaces

" Search behavior
set ignorecase  " Case-insensitive search
set smartcase   " Case-sensitive if uppercase letters used
set incsearch   " Incremental search (highlight as you type)
set hlsearch    " Highlight all search matches
set magic       " Turn magic on for regular expressions

" File handling
set autoread                " Automatically reload files changed outside vim
set backup                  " Create backup files
set backupdir=~/.vim/backup " Store backup files in specific directory
set directory=~/.vim/swap   " Store swap files in specific directory
set undofile                " Persistent undo across sessions
set undodir=~/.vim/undo     " Store undo files in specific directory

" Editor behavior
set backspace=indent,eol,start  " Allow backspace over everything
set scrolloff=7                 " Keep 7 lines visible above/below cursor
set wrap                        " Wrap long lines
set linebreak                   " Break lines at word boundaries
set mouse=a                     " Enable mouse support
set wildmenu                    " Turn on the Wild menu
" Ignore compiled files
set wildignore=*.o,*~,.pyc
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store

" ==== WORKFLOW ENHANCEMENTS ====
" Remember cursor position
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Custom key mappings
" Map the leader key for easier key-combos
let mapleader = ","

" Clear search highlighting with Escape
nnoremap <Esc> :nohlsearch<CR>

" Quick save and quit
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>x :x<CR>

" Toggle line numbers
nnoremap <F2> :set number!<CR>
" Toggle relative line numbers
nnoremap <F3> :set relativenumber!<CR>

" Quick exit insert mode
inoremap jj <ESC>

" Search for current selection on pressing * or #
vnoremap <silent> * :<C-u> call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u> call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

" Disable highlight
map <silent> <leader><CR> :nohlsearch<CR>

" Remap VIM 0 to first non-blank character
map 0 ^

" Move lines of text with ALT+[jk]
" The '' is one character representing the ALT key (typed via <C-v> <ESC>).
" It should not be edited in anything other than VIM, as it may become broken.
nnoremap j :m .+1<CR>==
nnoremap k :m .-2<CR>==
vnoremap j :m '>+1<CR>gv=gv
vnoremap k :m '<-2<CR>gv=gv

" Switch CWD to the directory of the current open buffer
map <leader>cd :cd %:p:h<CR>:pwd<CR>

" Toggle paste mode on and off
map <leader>pp :setlocal paste!<CR>

" ==== FILE TYPE SPECIFIC ====
" Different settings for different file types
autocmd FileType python setlocal tabstop=4 shiftwidth=4 expandtab
autocmd FileType javascript setlocal tabstop=2 shiftwidth=2 expandtab
autocmd FileType html setlocal tabstop=2 shiftwidth=2 expandtab
autocmd FileType css setlocal tabstop=2 shiftwidth=2 expandtab

" ==== PERFORMANCE ====
set lazyredraw  " Don't redraw during macros
set ttyfast     " Fast terminal connection

" ==== SETUP DIRECTORIES ====
" Create necessary directories if they don't exist
if !isdirectory($HOME."/.vim/backup")
    call mkdir($HOME."/.vim/backup", "p")
endif
if !isdirectory($HOME."/.vim/swap")
    call mkdir($HOME."/.vim/swap", "p")
endif
if !isdirectory($HOME."/.vim/undo")
    call mkdir($HOME."/.vim/undo", "p")
endif

" ==== HELPER FUNCTIONS ====
" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE '
    endif
    return ''
endfunction

function! CmdLine(str)
    call feedkeys(":" . a:str)
endfunction

function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        call CmdLine("Ack '" . l:pattern . "' " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction
