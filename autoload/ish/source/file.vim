let g:ish#source#file# = {'sink': function('g:ish#sink#open#')}

function! ish#source#file#.choices(root) abort
  return systemlist('rg --color never --files ' . shellescape(a:root) . ' 2>/dev/null')
endfunction
