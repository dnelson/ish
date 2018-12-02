function! ish#session#new(fzy, root, position, height) abort
  let session = {
    \   'fzy':    a:fzy,
    \   'root':   a:root,
    \   'height': a:height,
    \   'prev':   {'window': win_getid(), 'height': winheight('%')},
    \ }

  function! session.select(source, sink) dict abort
    let choices = a:source.choices(self.root)
    let self.sink = a:sink

    let self.infile = tempname()
    let self.outfile = tempname()

    call writefile(choices, self.infile)

    let command = shellescape(self.fzy) . ' --lines ' . shellescape(self.height) . 
        \ ' < ' . shellescape(self.infile) . ' > ' . shellescape(self.outfile)

    let joboptions = {'session': self}
    function joboptions.on_exit(id, code, _event) abort
      call self.session.done(a:code == 0 && filereadable(self.session.outfile))
    endfunction

    let self.job = termopen(command, joboptions)
    startinsert
  endfunction

  function! session.done(success) dict abort
    call self.close()

    if !a:success
      return
    endif

    let results = readfile(self.outfile)
    if empty(results)
      return
    endif

    for result in results
      call self.sink(result, self.root)
    endfor
  endfunction

  function! session.close(...) abort dict
    call win_gotoid(self.prev.window)
    if bufnr(self.bufnr) >= 0
      execute 'silent' 'bdelete!' self.bufnr
    endif
    execute 'resize' self.prev.height

    if a:0 > 0
      call win_gotoid(a:1)
    endif
  endfunction

  exe 'keepalt' a:position a:height . 'new'

  setlocal filetype=ish
  setlocal nonumber
  setlocal norelativenumber

  let session.bufnr = bufnr('%')

  return session
endfunction
