" Vim user configuration file
" Configure Target: General User - terminal-based Vim
" Maintainer:       Steven Ward <stevenward94@gmail.com>
" URL:              https://github.com/StevenWard94/myvim
" Last Change:      2019 Jun 19
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" General Settings \begin

  set nocompatible        " set this first b/c it changes the values of several options

  " identify user's platform ( OSX()->true for mac  LINUX()->true for non-mac/win unix  WINDOWS()->true for win32/64
  execute "silent function! OSX() \n return has('macunix') \n endfunction"
  execute "silent function! LINUX() \n return has('unix') && !has('macunix') && !has('win32unix') \n endfunction"
  execute "silent function! WINDOWS() \n return ( has('win32') || has('win64') ) \n endfunction"

  if !WINDOWS()
    if executable('/bin/bash')
      set shell=/bin/bash
    else
      set shell=/bin/sh
    endif
  endif

  " fix arrow-key issues flagged at: " https://github.com/spf13/spf13-vim/issues/780
  if &term[:4] ==? 'xterm' || &term[:5] ==? 'screen' || &term[:3] ==? 'rxvt'
    inoremap <silent> <C-[>OC <RIGHT>
  endif

  if has('nvim')
    let $VIMHOME = '/home/steven/.config/nvim'
    let $NVIMHOME = $VIMHOME
  elseif !exists('$VIMHOME') || empty($VIMHOME)
    let $VIMHOME = local#utils#define_vimhome()
  endif

  " use 'helper configs' if they exist \begin
    if filereadable(expand("~/.vimrc.before"))
      silent source ~/.vimrc.before
    endif

    " For initialization of plugin manager, see this file (dotfiles/.vimrc.bundles)
    if filereadable(expand("~/.vimrc.bundles"))
      silent source ~/.vimrc.bundles
    endif

    " enable sourcing of '.exrc' or '.vimrc' config file in local directory
    set exrc
  " \end

  " create function to toggle background and map it to <leader>bg \begin
    function! ToggleBackground()
      let s:bgtoggle = &background
      if s:bgtoggle ==# 'dark'
        set background=light
      else
        set background=dark
      endif
    endfunction
    noremap <leader>bg :call ToggleBackground()<CR>
  " \end

  " make sure non-ASCII keys behave correctly
  if !has('gui') && !has('nvim')
    set term=$TERM
  endif

  if !exists('g:bundles_config_loaded')
    filetype plugin indent on
  endif
  syntax on
  set mouse=a                                   " enable mouse usage automatically for all modes
  set mousehide                                 " hide cursor when typing
  scriptencoding utf-8                          " tells vim to use utf-8 when reading this file
  " whenever possible, use single vim register for copy/paste in all buffers
  if has('clipboard')
    if has('unnamedplus')
      set clipboard=unnamed,unnamedplus
    else
      set clipboard=unnamed
    endif
  endif

  " automatically change working directory that of the file currently open in the buffer
  if !exists('g:sw_override_autochdir') || g:sw_override_autochdir == 0
   autocmd BufEnter * :if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif
  endif

  " use GHC functionality for haskell files
  autocmd BufEnter *.hs :compiler ghc
  let g:haddock_browser = "/opt/google/chrome/google-chrome"

  set shortmess+=filmnrxoOtT                " abbreviate messages from system (avoids 'hit enter' messages)
  set viewoptions=folds,options,cursor,unix,slash
  set virtualedit=onemore
  set history=1000
  set nospell
  set hidden
  set iskeyword-=.
  set iskeyword-=#
  set iskeyword-=-

  " when opening an existing file, restore cursor to its position at end of last edit \begin
  if !exists('g:sw_override_restorecursor') || g:sw_override_restorecursor == 0
    function! RestoreCursor()
      if line("'\"") <= line("$")
        silent! normal! g`"
        return 1
      endif
    endfunction

    augroup cursor_restore
      autocmd!
      autocmd BufWinEnter * :call RestoreCursor()
    augroup END
  endif
  " for git commit messages, clear all 'BufEnter' events and put cursor at start of file
  autocmd FileType gitcommit autocmd! BufEnter COMMIT_EDITMSG :call setpos('.', [0, 1, 1, 0])
  " \end

  " Setting up directories \begin
    " accepts (optional) list of filetypes that DO NOT GET BACKED UP
    function! SetBackupdir(...)
      if empty(&filetype)
        return
      endif

      if match(a:000, &filetype) != -1
        set nobackup
        return
      endif

      let l:bakdir_root = $HOME . '/.archived/bak.d/'

      if !( &backup && isdirectory(l:bakdir_root) )
        return
      endif

      " Setting 'backupdir' option to filetype-specific directories is the default
      if !exists('g:ftbackdir') || g:ftbackdir > 0
        let l:filetype_bakdir = l:bakdir_root . &filetype

        if !isdirectory(l:filetype_bakdir)
          execute 'silent !mkdir ' . l:filetype_bakdir . ' > /dev/null 2>&1'
          redraw!
          if !isdirectory(l:filetype_bakdir)    " something went wrong, shell cmd failed
            let &backupdir = l:bakdir_root
            return
          endif
        endif

        let &backupdir = l:filetype_bakdir

      else
        let &backupdir = l:bakdir_root
      endif
    endfunction

    autocmd BufWinEnter * :call SetBackupdir('gitcommit', 'qf')


    " disable swap files -- '*/.fname.swp'
    set noswapfile

    " source my .vimrc after writing it -- applies changes
    "autocmd BufWritePost .vimrc source $MYVIMRC

    if !exists('g:sw_override_views') || g:sw_override_views == 0
      let g:skipview_files = [
            \ '\[example pattern\]'
            \ ]
    endif
  " \end
" \end

" User Interface Settings \begin
  
  "if &t_Co < 256
  "  let &t_Co = match($TERM, '256') != -1 ? 256 : &t_Co
  "endif
  set t_Co=256

  let g:rehash256 = 1
  "colorscheme tomorrow-night-eighties
  colorscheme molokai
  "set background=dark
  let g:airline_theme = 'molokai'
  "let g:airline_theme = 'distinguished'
  syntax enable

  set tabpagemax=15
  set showmode

  set cursorline
  "highlight CursorLine ctermbg=234
  highlight clear SignColumn      " make SignColumn background match editor
  highlight clear LineNr          " current line # row will have same background w/ relativenumber set

  if has('cmdline_info')
    set ruler
    set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%)
    set showcmd
  endif

  " enable enhanced highlighting for c++11
  autocmd BufNewFile,BufRead *.cpp,*.cxx,*.cc,*.h,*.hpp,*.hxx :set syntax=cpp.cpp11

  " enable enhanced highlighting for Java
  autocmd BufNewFile,BufRead *.java :let java_highlight_all = 1


  if has('statusline')
    set laststatus=2

    set statusline=%<%f\                    " show filename
    set statusline+=%w%h%m%r                " show different i/o/status options
    if filereadable(expand("~/.vim/bundle/fugitive"))
      set statusline+=%{fugitive#statusline()}
    endif
    set statusline+=\ [%{&ff}/%Y]           " show filetype
    set statusline+=\ [%{getcwd()}]         " show current working directory
    set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " show (right-aligned) file-navigation info
  endif

  set backspace=indent,eol,start
  set linespace=3
  set number
  set relativenumber
  set showmatch
  set incsearch
  set hlsearch
  set winminheight=0
  set ignorecase
  set smartcase
  set whichwrap=b,s,h,l,<,>,[,]
  set scrolljump=15                               " when cursor leaves screen (not <C-E>, etc.) auto-scroll 25% winheight
  "set scrolloff=10                                " maintain at least 10 lines above and below cursor
  set scrolloff=0
  set foldenable
  set list
  set listchars=tab:»›,trail:∅,extends:Ϟ,nbsp:∙   " mark potentially problematic whitespace
  set nrformats+=alpha                            " allow use of CTRL-A and CTRL-X to inc/decrement letters in normal mode

  set tags=../.tags/tags,./.tags

" \end

" Text Formatting Settings \begin
  set nowrap nopaste
  set autoindent smartindent
  set formatoptions=cr1jb
  set textwidth=120 wrapmargin=0
  set expandtab
  set shiftwidth=4 tabstop=4 softtabstop=4
  set nojoinspaces                                " remove extra space (leave single space) between two joined lines
  set splitright splitbelow                       " :vsplit -> new window to right of old    :split -> new window below old
  "set matchpairs+=<:>                             " add '<' & '>' to list of matching pairs for use w/ '%'
  set pastetoggle=<F12>                           " enable toggling between ':set paste' & ':set nopaste' with F12 key
  "set comments=sl:/*,mb:*,elx*/                  " autoformat comment blocks -- no guarantees, idk what this does

  set completeopt=menuone,menu,longest

  set wildignore+=*\\tmp\\*,*.swp,*.swo,*.zip,.git,.cabal-sandbox
  set wildmenu
  set wildmode=list:longest,full                  " show a list of possible completions (longest matches then all) instead of auto-completing

  " Function & autocommands to strip whitespace \begin
    if !exists('g:sw_override_stripwsp') || g:sw_override_stripwsp == 0
      autocmd FileType c,cpp,java,go,php,javascript,puppet,python,rust,twig,xmlyml,perl,sql :autocmd BufWritePre <buffer> :call StripTrailingWhitespace()
      function! StripTrailingWhitespace()
        " save cursor position
        let l:save_win = winsaveview()
        " strip trailing whitespace
        %s/\s\+$//e
        " restore cursor position
        call winrestview(l:save_win)
      endfunction

      function! StripTrailingWhitespaceOld()
        " Preparation: save last search and cursor position
        let _s=@/
        let l = line(".")
        let c = col(".")
        " do the business:
        %s/\s\+$//e
        " clean up: restore previous search history and cursor position
        let @/= _s
        call cursor(l, c)
      endfunction
    endif
  " \end

  "autocmd FileType go :autocmd BufWritePre <buffer> :Fmt
  autocmd BufNewFile,BufRead *.html.twig :set filetype=html.twig
  autocmd BufNewFile,BufRead *.gs :set filetype=javascript
  autocmd FileType puppet,ruby,vim,yml :setlocal expandtab shiftwidth=2 softtabstop=2

  autocmd BufNewFile,BufRead *.coffee set filetype=coffee

  " workaround to disable spellcheck in help files
  augroup helpfiles_nospell
    autocmd!
    autocmd BufNewFile,BufReadPost,FileReadPost /usr/share/vim/vim74/doc/*,/home/steven/.vim/doc/*,*/doc/*.txt :set filetype=help nospell
    autocmd FileType help :set nospell
  augroup END

  " workarounds for vim-commentary and broken highlighting with Haskell
  augroup haskell_fixes
    autocmd!
    autocmd FileType haskell :setlocal commentstring=--\ %s
    autocmd FileType haskell,rust :setlocal nospell
  augroup END

  " pretty unicode haskell symbols
  let g:haskell_conceal_wide = 1
  let g:haskell_conceal_enumerations = 1
  let hscoptions = "STEMxRtBDw"

  " LATIN SUBSCRIPT SMALL LETTER N
  " UTF-16(hex): 0x2099      UTF-16(dec): 8345
  digraphs ns 8345    " add ₙ to digraphs (<C-K>ns)
" \end

" Key Mappings & Remappings \begin

  " Setting up the <leader> key for custom mappings - default is '\' but this changes it to ',' b/c it's near home row
  if !exists('g:sw_override_leader')
    let mapleader = ','
  else
    let mapleader = g:sw_override_leader
  endif
  if !exists('g:sw_override_locleader')
    let maplocalleader = '\'
  else
    let maplocalleader = g:sw_override_locleader
  endif

  " Mappings to quickly open config (.vimrc), edit it and then apply it
  if !exists('g:sw_override_econfigmap') || g:sw_override_econfigmap == 0
    let s:sw_econfigmap = '<leader>ec'
  else
    let s:sw_econfigmap = g:sw_override_econfigmap
  endif
  if !exists('g:sw_override_aconfigmap') || g:sw_override_aconfigmap == 0
    let s:sw_aconfigmap = '<leader>ac'
  else
    let s:sw_aconfigmap = g:sw_override_aconfigmap
  endif
  execute "noremap " . s:sw_econfigmap . " :silent! call <SID>EditMyConfig()<CR>"
  execute "noremap " . s:sw_aconfigmap . " :silent! call <SID>ApplyMyConfig()<CR>"

  " Mappings for easier movement between windows while in Normal mode
  if !exists('g:sw_override_easywindows') || g:sw_override_easywindows == 0
    nmap <C-J> <C-W>j<C-W>_
    nmap <C-K> <C-W>k<C-W>_
    nmap <C-L> <C-W>l<C-W>\<Bar>
    nmap <C-H> <C-W>h<C-W>\<Bar>
  endif

  " center cursor vertically within window when moving with 'j' or 'k'
  "noremap j jzz
  "noremap k kzz

  " Mappings for use with 'RelativeWrap(key,...)' in "Helper Functions"
  "   these map start/end of line motion commands to behave relative to the current row instead of moving to the
  "   start/end of a 'text line' when the 'wrap' option is set - e.g a sentence is wrapped at column 50 into two rows,
  "   commands like '$', '0', '^', etc. will only jump to column 1 of column 50 of the current row instead of wrapping
  "   with the sentence --- these seem more "intuitive" to me when I'm trying to work/remember mappings quickly
  if !exists('g:sw_override_relativewrap') || g:sw_override_relativewrap == 0
    " [essentially] Map a prefixed 'g' to each linewise motion key in Normal, Operator-Pending, and Visual+Select modes
    noremap <silent> $ :call RelativeWrap("$")<CR>
    noremap <silent> <End> :call RelativeWrap("$")<CR>
    noremap <silent> 0 :call RelativeWrap("0")<CR>
    noremap <silent> <Home> :call RelativeWrap("0")<CR>
    noremap <silent> ^ :call RelativeWrap("^")<CR>
    " the following 2 override the above mappings for $ and <End> in Operator-Pending mode to
    "   force inclusive motion when used with ':execute normal!'
    onoremap <silent> $ v:call RelativeWrap("$")<CR>
    onoremap <silent> <End> v:call RelativeWrap("$")<CR>
    " now override Visual+Select mode mappings for all keys to ensure RelativeWrap() executes with a correct 'vsel' value
    vnoremap <silent> $ :<C-U>call RelativeWrap("$", 1)<CR>
    vnoremap <silent> <End> :<C-U>call RelativeWrap("$", 1)<CR>
    vnoremap <silent> 0 :<C-U>call RelativeWrap("0", 1)<CR>
    vnoremap <silent> <Home> :<C-U>call RelativeWrap("0", 1)<CR>
    vnoremap <silent> ^ :<C-U>call RelativeWrap("^", 1)<CR>
  endif

  " Some helpful "autocorrects" for capitalization mistaked in commands
  if !exists('g:sw_override_shiftslips') || g:sw_override_shiftslips == 0
    if has('user_commands')
      command! -bang -nargs=* -complete=file E e<bang> <args>
      command! -bang -nargs=* -complete=file W w<bang> <args>
      command! -bang -nargs=* -complete=file Wq wq<bang> <args>
      command! -bang -nargs=* -complete=file WQ wq<bang> <args>
      command! -bang Wa wa<bang>
      command! -bang WA wa<bang>
      command! -bang Q q<bang>
      command! -bang QA qa<bang>
      command! -bang Qa qa<bang>
    endif
    cmap Tabe tabe
  endif

  " Map 'Y' to behave like 'C' or 'D' in Normal mode (i.e. 'yank' from cursor to end of line)
  nnoremap Y y$

  " Mappings for <leader>fn where 'n' is foldlevel for ':set foldlevel=n' -- makes pagewise folding/unfolding easier \begin
    nmap <leader>f0 :set foldlevel=0<CR>
    nmap <leader>f1 :set foldlevel=1<CR>
    nmap <leader>f2 :set foldlevel=2<CR>
    nmap <leader>f3 :set foldlevel=3<CR>
    nmap <leader>f4 :set foldlevel=4<CR>
    nmap <leader>f5 :set foldlevel=5<CR>
    nmap <leader>f6 :set foldlevel=6<CR>
    nmap <leader>f7 :set foldlevel=7<CR>
    nmap <leader>f8 :set foldlevel=8<CR>
    nmap <leader>f9 :set foldlevel=9<CR>
    " mapping for ':set foldenable!' to toggle folding
    nmap <leader>f! :set foldenable!<CR>
  " \end

  " Enable toggling of search-result highlighting (instead of clearing of results) with <leader>/
  nmap <silent> <leader>/ :nohlsearch<CR>

  " Mapping to quickly find markers for git-merge conflicts
  map <leader>fc /\v^[<\|=>]{7}( .*\|$)<CR>

  " Shortcuts!!!  \begin
    " indent shifting while in Visual mode will no longer exit Visual mode
    vnoremap < <gv
    vnoremap > >gv

    " enable use of the repeat operator for selections in Visual mode (!)
    "   http://stackoverflow.com/a/8064607/127816
    vnoremap . :normal .<CR>

    " actually writes files when they should have been opened with 'sudo' but weren't
    function! g:SudoSave() abort
      execute (has('gui_running') ? '' : 'silent') 'write !env SUDO_EDITOR=tee sudo -e % > /dev/null'
      let &modified = v:shell_error
    endfunction
    cmap w!! :call g:SudoSave()

    " some ':edit' mode helpers [http://vimcasts.org/e/14]
    " conflicted with previously mapped keys for editing/applying my .vimrc
    "cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<CR>
    "map <leader>ew :e %%
    "map <leader>es :sp %%
    "map <leader>ev :vsp %%
    "map <leader>et :tabe %%

    " make viewport sizes equal
    map <leader>= <C-w>=

    " map <leader>ff to display all lines with match to the keyword under cursor and ask which line to jump to
    nmap <leader>ff [I:let nr = input("Which one: ")<Bar>execute "normal " . nr . "[\t"<CR>

    " easier horizontal scrolling
    map zl zL
    map zh zH

    " easier auto-formatting
    nnoremap <silent> <leader>q gwip

    " open a new (empty) buffer
    nmap <leader>T :enew<CR>

    " move to next buffer
    nmap <leader>l :bnext<CR>

    " move to previous buffer
    nmap <leader>h :bprevious<CR>

    " close current buffer and move to previous one
    nmap <leader>bq :bp <BAR> bd #<CR>

    " list buffers and their statuses
    nmap <leader>bl :ls<CR>

    " jump to buffer # (so far only 1-9 mapped)
    nmap <leader>b1 :1b<CR>
    nmap <leader>b2 :2b<CR>
    nmap <leader>b3 :3b<CR>
    nmap <leader>b4 :4b<CR>
    nmap <leader>b5 :5b<CR>
    nmap <leader>b6 :6b<CR>
    nmap <leader>b7 :7b<CR>
    nmap <leader>b8 :8b<CR>
    nmap <leader>b9 :9b<CR>
  " \end

  " mappings for 'diffget...' commands
  nmap <leader>RE :diffget REMOTE
  nmap <leader>BA :diffget BASE
  nmap <leader>LO :diffget LOCAL

  " mapping to open file prompt using current buffer's path
  nmap <leader>e :e <C-r>=expand("%:p:h") . '/'<CR>

  " mapping to show undo-tree
  nmap <silent> <leader>u :MundoToggle<CR>

  " mapping to split a line at the cursor while maintaining normal formatting
  " (see 'UnjoinCommand()' in 'Helper Functions')
  nnoremap <leader>. :call <SID>UnjoinCommand()<CR>

  " mappings for location list navigation commands
    nnoremap <leader>ll :ll<CR>
    nnoremap <leader>lj :lnext<CR>
    nnoremap <leader>lk :lprev<CR>

    nnoremap <leader>l0 :lrewind<CR>
    nnoremap <leader>l$ :llast<CR>
" \end

" Helper Functions \begin
  if !exists('g:sw_override_relativewrap') || g:sw_override_relativewrap == 0
    function! RelativeWrap(key,...)
      let vsel = ""
      if a:0
        let vsel="gv"
      endif
      if &wrap
        execute "normal!" vsel . "g" . a:key
      else
        execute "normal!" vsel . a:key
      endif
      unlet vsel
    endfunction
  endif


  function! s:EditMyConfig()
    execute "edit " . expand("~/.vimrc") . " | edit " . expand("~/.vimrc.bundles") . " | bprevious"
  endfunction

  function! s:ApplyMyConfig()
    let l:vimrc_bufnr = bufnr(bufname('\.vimrc$'))
    let l:bndls_bufnr = bufnr(bufname('\.vimrc\.bundles$'))
    let l:cur_bufnr = bufnr("%")

    if getbufvar(l:bndls_bufnr, "&mod")
      execute 'buffer ' . l:bndls_bufnr
      write
    endif
    if getbufvar(l:vimrc_bufnr, "&mod")
      execute 'buffer ' . l:vimrc_bufnr
      write
    endif
    execute 'buffer ' . l:cur_bufnr
    execute 'bdelete ' . ( l:vimrc_bufnr != -1 ? l:vimrc_bufnr.' ' : '' ) . ( l:bndls_bufnr != -1 ? l:bndls_bufnr : '' )

    unlet l:vimrc_bufnr
    unlet l:bndls_bufnr
    unlet l:cur_bufnr
    source ~/.vimrc 
  endfunction



  function! s:CharUnderCursor()
    return matchstr(getline('.'), '\%' . col('.') . 'c.')
  endfunction


  function! s:UnjoinCommand() abort
    let l:cursor_char = s:CharUnderCursor()
    let l:line_indent = indent('.')
    if l:cursor_char =~? '\s'
      execute "normal! r\<CR>"
      call cursor(line('.'), l:line_indent + 1)
      while (s:CharUnderCursor() =~? '\s')
        normal x
      endwhile
      normal k
      .s/\s\+$//e
    else
      execute "normal! i\<CR>\<Esc>k"
      .s/\s\+$//e
    endif
    execute "normal! j$"
    unlet l:cursor_char
    unlet l:line_indent
  endfunction

" \end


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim: set foldmarker=\\begin,\\end foldmethod=marker foldlevel=0 tw=120 fo=cr1jb wm=0 expandtab sw=2 ts=2 sts=2 nospell:
