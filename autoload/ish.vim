"
"     _____         ______
"     ___(_)___________  /_
"     __  / __  ___/__  __ \
"     _  /  _(__  ) _  / / /
"     /_/   /____/  /_/ /_/
"
"        vim + fzy = ish
"

let s:defaults = {
    \   'fzy': 'fzy',
    \   'root': function('getcwd'),
    \   'position': 'botright',
    \   'height': 12
    \ }
let g:ish#defaults = extend(copy(s:defaults), get(g:, 'ish#defaults', {}))

if !exists('s:session')
  let s:session = v:null
endif

function! ish#open(source, ...) abort
  let source = type(a:source) == type('') 
      \ ? eval(printf('g:ish#source#%s#', empty(a:source) ? 'file' : a:source))
      \ : a:source
  let options = extend(copy(g:ish#defaults), get(a:, 1, {}))

  if !executable(options.fzy)
    throw printf('Cannot find fzy at "%s"; install it or set g:ish#defaults.fzy', options.fzy)
  endif

  if type(s:session) !=# type(v:null)
    call ish#close()
  endif

  let root = type(options.root) == type('') ? options.root : options.root()
  let s:session = ish#session#new(options.fzy, root, options.position, options.height)

  call s:session.select(source, get(options, 'sink', source.sink))
endfunction

function! ish#close() abort
  if type(s:session) != type(v:null)
    try
      call s:session.close(win_getid())
    finally
      let s:session = v:null
    endtry
  endif
endfunction
