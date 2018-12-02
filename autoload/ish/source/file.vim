let g:ish#source#file# = {'name': 'file', 'sink': function('g:ish#sink#open#')}

function! ish#source#file#.choices(root) abort
  let root = a:root ==# getcwd(0) ? '.' : a:root
  return systemlist('rg --color never --files ' . shellescape(root) . ' 2>/dev/null')
endfunction
