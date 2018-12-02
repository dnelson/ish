let g:ish#source#help# = {'name': 'help', 'rooted': 0, 'sink': function('g:ish#sink#help#')}

function! ish#source#help#.choices(_root) abort
  let tagfiles = filter(map(split(&rtp, ','), {i, p -> glob(p . 'doc/tags')}), {i, p -> !empty(p)})
  return systemlist(extend(['awk', '{print $1}'], tagfiles))
endfunction
