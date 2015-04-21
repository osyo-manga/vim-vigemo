scriptencoding utf-8
if exists('g:loaded_vigemo')
  finish
endif
let g:loaded_vigemo = 1

let s:save_cpo = &cpo
set cpo&vim


command! -nargs=* VigemoSearch call vigemo#search(<q-args>)

nnoremap <silent> <Plug>(vigemo-search) :VigemoSearch<CR>


let &cpo = s:save_cpo
unlet s:save_cpo
