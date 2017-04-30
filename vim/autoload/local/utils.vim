" Utility functions defined for local use.
"
" Author:      Steven Ward <stevenward94@gmail.com>
" URL:         https://github.com/StevenWard94/dotfiles/vim/autoload/local/
" Last Change: 2017 Apr 30
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Define variable for user's home '.vim' or 'vimfiles' directory
function! s:init_vars()
  let l:rtp_list = split(&runtimepath, ',')
  if empty(l:rtp_list)
    return ''
  endif
  return matchstr(l:rtp_list, '\('.$HOME.'\|'.$VIM.'\)\/\(\.vim\|vimfiles\)')
endfunction
let s:vimhome = s:init_vars()


" Function to check if a plugin has been installed to the '.vim/bundle' directory.
function! local#utils#has_plugin(plug) abort
  if empty('s:vimhome')
    return 0
  endif
  if isdirectory(s:vimhome.'/bundle/'.a:plug) || isdirectory(s:vimhome.'/plugin/'.a:plug)
    return 1
  elseif filereadable(s:vimhome.'/autoload/'.a:plug) || filereadable(s:vimhome.'/plugin/'.a:plug)
    return 1
  endif
  return 0
endfunction
