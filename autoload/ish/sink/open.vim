function! ish#sink#open#(choice, root) abort
  silent execute 'lcd' fnameescape(a:root)
  silent execute 'edit' fnameescape(expand(a:choice))
  silent lcd -
endfunction
