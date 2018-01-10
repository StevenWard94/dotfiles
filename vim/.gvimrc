" Vim-Gnome configuration file
" Maintainer:   Steven Ward <stevenward94@gmail.com>
" URL:          https://github.com/StevenWard94/myvim
" Last Change:  2017 Nov 9
" ======================================================================================

" General GUI Settings \begin1
  set lines=46             " increase # of lines in editor

  set guioptions-=T        " remove the toolbar
  set guioptions-=r        " remove right-hand vertical scrollbar
  set guioptions-=R        " remove right-hand vertical scrollbar with :vsplit
  set guioptions-=l        " same as 'r' but left-hand side
  set guioptions-=L        " same as 'R' but left-hand side

  if LINUX()
    set guifont=Andale\ Mono\ Regular\ 16,Consolas\ Regular\ 16
  elseif WINDOWS()
    set guifont=Andale_Mono:h10,Consolas:h10
  endif

  colorscheme blacksea
  highlight CursorLine guibg=Grey10 


" Utility Functions/Commands \begin1

function! s:ChangeFontSize(op, ...) abort
  " validate 'op' argument
  if !(a:op == '+' || a:op == '-')
    return
  endif
  let l:font_size = str2nr(matchstr(&guifont, '[0-9]\+'), 10)

  " validate '...' arguments if present (set default if missing)
  if a:0 == 0
    let l:args = [ 1, 'g' ]
  elseif a:0 == 1
    let l:args = type(a:1) == type(1) ?
               \ [ a:1, 'g' ] :
               \ ( type(a:1) == type('g') ?
               \   [ 1, a:1 ] : [ 1, 'g' ] )
  else
    let [type_arg1, type_arg2] = map(deepcopy(a:000[:1]), 'type(v:val)')
    let l:args = [ (type_arg1 == type(1) ? a:1 : 1),
                \  (type_arg2 == type('g') ? a:2 : 'g') ]
  endif

  if l:font_size > 0
    let l:old_size = l:font_size
    silent! execute 'let l:font_size = l:font_size' a:op l:args[0]
    let &guifont = substitute(&guifont, l:old_size, l:font_size, l:args[1])
    if l:old_size != str2nr(matchstr(&guifont, '[0-9]\+'), 10)
      echomsg 'Font Size Changed: ' . string(l:old_size) . ' -> ' . string(l:font_size)
    endif
  endif
endfunction

command -count=1 IncFont call <SID>ChangeFontSize('+', <count>, 'g')
nnoremap <leader>+ :<C-u>execute "call <SID>ChangeFontSize('+', ".v:count1.", 'g')"<CR>
command -count=1 DecFont call <SID>ChangeFontSize('-', <count>, 'g')
nnoremap <leader>- :<C-u>execute "call <SID>ChangeFontSize('-', ".v:count1.", 'g')"<CR>

" vim: set et sw=2 sts=2 ts=4 foldmarker=\\begin,\\end foldmethod=marker: 
