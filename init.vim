set magic
set shell=/bin/zsh
set modeline
set modelines=5


call plug#begin()
Plug 'junegunn/vim-easy-align'
Plug 'https://github.com/junegunn/vim-github-dashboard.git'
Plug 'chemzqm/vim-jsx-improve'
Plug 'chriskempson/base16-vim'
Plug 'elmcast/elm-vim'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'othree/html5.vim'
Plug 'reedes/vim-pencil'
Plug 'benjie/local-npm-bin.vim'
Plug 'numkil/ag.nvim'
Plug 'reedes/vim-pencil'
Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'thaerkh/vim-workspace'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'jonstoler/werewolf.vim'
call plug#end()

colorscheme base16-gruvbox-light-medium
set termguicolors
let g:werewolf_day_themes = ['base16-gruvbox-light-medium']
let g:werewolf_night_themes = ['base16-gruvbox-dark-hard']

if !has('nvim')
  filetype plugin indent on    " required
endif
set t_Co=256
set background=dark
syntax enable

" Split 'correctly' for left-to-right readers.
set splitbelow
set splitright

set history=700
set updatetime=200

" For when you forget to sudo.. Really Write the file.
cmap w!! w !sudo tee % >/dev/null

set noerrorbells
set novisualbell
set t_vb=
set autoread "Reload file when changed.

if !has('nvim')
  set backspace=2  "This makes the backspace key function like it does.
endif
set clipboard+=unnamed
set colorcolumn=80
set exrc
set secure
set expandtab
set completeopt=menuone
set foldmethod=manual
set nofoldenable
set ignorecase
set smartcase
set incsearch
set laststatus=2
set lazyredraw
set nobackup
set nowb
set noswapfile
set number  "Enables line numbering
set ruler
set showmatch "Highlights matching brackets in programming languages
set mat=2
set smartindent  "Automatically indents lines after opening a bracket
set smarttab  "Improves tabbing
set showcmd
set tm=500
set ffs=unix,dos,mac
set encoding=utf8
set ts=2 sw=2 et "Tabstop spacing
set wildignore+=*/tmp/*,*.so,*.swp,*.zip
set wildmenu
set wildmode=longest,list,full
set whichwrap+=<,>,h,l
set mouse=a
set lbr
set ai
set si
set listchars=eol:¬,tab:›·,trail:·,extends:›,precedes:‹
set list
map <leader>ll :set list!<cr>

let &path.="/usr/include/,/usr/local/include/,/usr/local/bin/,/usr/bin/"

function! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun

"Key bindings
map 0 ^
if has("mac") || has("macunix")
    nmap <D-j> <M-j>
    nmap <D-k> <M-k>
    vmap <D-j> <M-j>
    vmap <D-k> <M-k>
endif

" copy and paste
vmap <C-c> "+yi
vmap <C-x> "+c
vmap r "_dP
vmap ,d "_d
autocmd VimEnter * noremap <C-l> <C-W><C-L>
nnoremap <F5> :make!<cr>

func! DeleteTrailingWS()
    exe "normal mz"
    %s/\s\+$//ge
    exe "normal `z"
endfunc
autocmd BufWrite * :call DeleteTrailingWS()

let g:tmuxline_preset = {
    \'a'    : [ '#S:#I.#P', '#(/usr/local/bin/outatime)' ],
    \'b'    : [ '#(/usr/local/bin/current_itunes_song)' ],
    \'win'  : [ '#I #W' ],
    \'cwin' : [ '#I #W #F' ],
    \'x'    : [ '#(/usr/local/bin/battery -tp -g cyan -w magenta) ' ],
    \'z'    : ['%l:%M%p', '%a %m/%d'] }
let g:tmuxline_separators = {
    \ 'left' : '',
    \ 'left_alt': '»',
    \ 'right' : '',
    \ 'right_alt' : '«',
    \ 'space' : ' '}
let g:EditorConfig_exec_path = '/usr/local/bin/editorconfig'
let g:EditorConfig_exclude_patterns = [ 'fugitive://.*', 'scp://.*' ]

if isdirectory( expand( "~/.vim/bundle/vim-gitgutter" ) )
endif

au BufRead,BufNewFile *.jshintrc set ft=json
au BufRead,BufNewFile *.bowerrc set ft=json
au BufRead,BufNewFile *.pantheonrc set ft=json
au BufRead,BufNewFile *.txt set ft=markdown
au BufRead,BufNewFile *.text set ft=markdown
au BufRead,BufNewFile *.applescript set ft=applescript
au BufRead,BufNewFile *.eslintrc set ft=json

set statusline+=%#warningmsg#
set statusline+=%*

if has('nvim')
  let g:fzf_layout = { 'down': '~30%' }
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
  let g:fzf_history_dir = '~/.local/share/fzf-history'
  let g:fzf_buffers_jump = 1

  let g:rg_command = '
    \ rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --color "always"
    \ -g "*.{js,json,php,md,styl,pug,jade,html,config,py,cpp,c,go,hs,rb,conf,fa,lst}"
    \ -g "!{.config,.git,node_modules,vendor,build,yarn.lock,*.sty,*.bst,*.coffee,dist}/*" '

  command! -bang -nargs=* F call fzf#vim#grep(g:rg_command .shellescape(<q-args>), 1, <bang>0)

  " Auto close fzf on q
  autocmd! FileType fzf tnoremap <buffer> <leader>q <c-c>

  " Use fzf with buffers
  function! s:buflist()
    redir => ls
    silent ls
    redir END
    return split(ls, '\n')
  endfunction

  function! s:bufopen(e)
    execute 'buffer' matchstr(a:e, '^[ 0-9]*')
  endfunction

  nnoremap <silent> <Leader>b :call fzf#run({
  \   'source':  reverse(<sid>buflist()),
  \   'sink':    function('<sid>bufopen'),
  \   'options': '+m',
  \   'down':    len(<sid>buflist()) + 2
  \ })<CR>

  nmap <leader>r :F<cr>
  nmap <leader>c :Commits<CR>
  nnoremap <leader>, :tabprevious<CR>
  nnoremap <leader>. :tabnext<CR>
  nmap <F1> :echo<CR>
  imap <F1> <C-o>:echo<CR>

  nnoremap <C-S-J> :res +2<CR>
  nnoremap <C-S-K> :res -2<CR>
  nnoremap <C-S-H> :vertical resize -2<CR>
  nnoremap <C-S-L> :vertical resize +2<CR>

  nnoremap <C-J> <C-W><C-J>
  nnoremap <C-K> <C-W><C-K>
  nnoremap <C-L> <C-W><C-L>
  nnoremap <C-H> <C-W><C-H>
  tnoremap <Esc> <C-\><C-n>
  tnoremap <C-h> <C-\><C-n><C-w>h
  tnoremap <C-j> <C-\><C-n><C-w>j
  tnoremap <C-k> <C-\><C-n><C-w>k
  tnoremap <C-l> <C-\><C-n><C-w>l
endif
let base16colorspace=256  " Access colors present in 256 colorspace

let g:ale_change_sign_column_color=1
let g:ale_completion_enabled=1
let g:ale_set_balloons=1
let g:ale_set_highlights=1
let g:ale_fix_on_save=0
let g:ale_set_signs=1
let g:ale_linters = {
      \'javascript': ['eslint', 'eslint-prettier'],
      \'ruby': ['rubocop'],
      \}

let g:elm_format_autosave = 1
let g:elm_setup_keybindings = 0

let g:ale_set_lists_synchronously = 1
filetype plugin indent on
syntax on
