command! Wd call cd#fzf()
cnoreabbrev wd Wd

let g:vim_cd_paths_file="/Users/xieyu/.vim_cd_paths"

function! cd#fzf()
  let l:fzf_options= '--preview "rougify {2..-1} | head -'.&lines.'"'

  function! s:jump_to_path(item)
    if !isdirectory(a:item)
      echomsg a:item. "is not dir"
    else
      echomsg "cd to dir" . a:item
      exec 'cd ' . a:item
    endif
  endfunction

  call fzf#run({
        \ 'source': <sid>load_paths(),
        \ 'sink':   function('s:jump_to_dir'),
        \ 'options': '-m ' . l:fzf_options,
        \ 'down':    '40%' })

endfunction

function! cd#path(path)
  if !isdirectory(a:path)
    echomsg a:path . "is not dir"
    return
  endif

  if s:exist(a:path) == 0
    call writefile([a:path], g:vim_cd_paths_file, "a")
  endif

  exec "cd " . a:path
endfunction


function! s:load_paths() 
  if filereadable(g:vim_cd_paths_file)
    return readfile(g:vim_cd_paths_file)
  else
    return []
  endif
endfunction

function! s:exist(path)
  let paths = s:load_paths()
  for path in paths
    if match(path, a:path) != -1
      return 1
    endif
  endfor
  return 0
endfunction

